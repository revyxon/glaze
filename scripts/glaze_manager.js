const fs = require('fs');
const path = require('path');
const { execSync, spawn } = require('child_process');
const https = require('https');
const readline = require('readline');

// --- CONFIGURATION ---
const CONFIG = {
    owner: 'revyxon',
    repo: 'glaze',
    // Token is expected in environment or passed interactively if missing? 
    // For now we assume env var or hardcode strictly for this user's machine if safe.
    // Given the user context, I will use the known working PAT from env or fallback.
    // Token should be provided via environment variable: GH_TOKEN
    token: process.env.GH_TOKEN,
    projectDir: 'glaze',
    apkPath: 'glaze/build/app/outputs/flutter-apk/app-release.apk'
};

// --- STYLING ---
const style = {
    reset: "\x1b[0m",
    bright: "\x1b[1m",
    dim: "\x1b[2m",
    fg: {
        green: "\x1b[32m",
        yellow: "\x1b[33m",
        blue: "\x1b[34m",
        cyan: "\x1b[36m",
        red: "\x1b[31m",
        magenta: "\x1b[35m"
    },
    bg: {
        blue: "\x1b[44m"
    }
};

const print = {
    header: (text) => console.log(`\n${style.bg.blue}${style.bright} ${text} ${style.reset}\n`),
    success: (text) => console.log(`${style.fg.green}✔ ${text}${style.reset}`),
    info: (text) => console.log(`${style.fg.cyan}ℹ ${text}${style.reset}`),
    warn: (text) => console.log(`${style.fg.yellow}⚠ ${text}${style.reset}`),
    error: (text) => console.log(`${style.fg.red}✖ ${text}${style.reset}`),
    step: (text) => console.log(`${style.bright}➤ ${text}${style.reset}`)
};

// --- HELPERS ---
function run(command, showOutput = false) {
    try {
        const output = execSync(command, { encoding: 'utf8', stdio: showOutput ? 'inherit' : 'pipe' });
        return output ? output.trim() : '';
    } catch (e) {
        throw new Error(`Command failed: ${command}\n${e.message}`);
    }
}

function getPubspecVersion() {
    const pubspecPath = path.join(CONFIG.projectDir, 'pubspec.yaml');
    if (!fs.existsSync(pubspecPath)) return null;
    const pubspec = fs.readFileSync(pubspecPath, 'utf8');
    const match = pubspec.match(/version:\s+([0-9]+\.[0-9]+\.[0-9]+(\+[0-9]+)?)/);
    return match ? match[1] : null;
}

function request(method, apiPath, body = null) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: 'api.github.com',
            path: apiPath,
            method: method,
            headers: {
                'User-Agent': 'Glaze-Manager',
                'Authorization': `token ${CONFIG.token}`,
                'Accept': 'application/vnd.github.v3+json',
                'Content-Type': 'application/json'
            }
        };
        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', c => data += c);
            res.on('end', () => {
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    try { resolve(JSON.parse(data)); } catch (e) { resolve(data); }
                } else {
                    reject({ status: res.statusCode, body: data });
                }
            });
        });
        req.on('error', reject);
        if (body) req.write(body);
        req.end();
    });
}

async function uploadAsset(releaseId, filePath, fileName) {
    const stat = fs.statSync(filePath);
    const fileContent = fs.readFileSync(filePath);

    return new Promise((resolve, reject) => {
        // Upload URL format: https://uploads.github.com/repos/:owner/:repo/releases/:id/assets?name=:name
        const options = {
            hostname: 'uploads.github.com',
            path: `/repos/${CONFIG.owner}/${CONFIG.repo}/releases/${releaseId}/assets?name=${fileName}`,
            method: 'POST',
            headers: {
                'User-Agent': 'Glaze-Manager',
                'Authorization': `token ${CONFIG.token}`,
                'Content-Type': 'application/vnd.android.package-archive',
                'Content-Length': stat.size
            }
        };

        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', c => data += c);
            res.on('end', () => {
                if (res.statusCode === 201) resolve();
                else reject(data);
            });
        });
        req.on('error', reject);
        req.write(fileContent);
        req.end();
    });
}

// --- ACTIONS ---

async function syncRepo() {
    print.header("SYNCING REPOSITORY");

    const status = run('git status --porcelain');
    if (!status) {
        print.info("Working directory clean. Pushing latest commits...");
    } else {
        print.step("Staging all changes...");
        run('git add .');

        const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
        const commitMsg = await new Promise(resolve => {
            rl.question(`${style.fg.cyan}? Enter commit message: ${style.reset}`, (ans) => {
                rl.close();
                resolve(ans || "chore: Update");
            });
        });

        print.step("Committing...");
        run(`git commit -m "${commitMsg}"`);
    }

    print.step("Pushing to origin/main...");
    try {
        run('git push');
        print.success("Code successfully synced to GitHub!");
    } catch (e) {
        print.error("Push failed. Check credentials.");
        console.error(e.message);
    }
}

async function deployNewVersion() {
    print.header("DEPLOYING NEW RELEASE");

    // 1. Check Version
    const version = getPubspecVersion();
    if (!version) {
        print.error("Could not find version in pubspec.yaml");
        return;
    }
    const cleanVersion = version.split('+')[0]; // 1.2.3
    const tagName = `v${cleanVersion}`;

    print.info(`Detected Version: ${style.bright}${version}${style.reset}`);

    // 2. Check Release Notes
    const releaseNotePath = `releases/${tagName}.md`;
    let releaseNotes = '';

    if (fs.existsSync(releaseNotePath)) {
        print.success(`Found release notes: ${releaseNotePath}`);
        releaseNotes = fs.readFileSync(releaseNotePath, 'utf8');
    } else {
        print.warn(`No release notes found at ${releaseNotePath}`);
        const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
        const ans = await new Promise(resolve => {
            rl.question(`${style.fg.yellow}? Create default notes? (y/n): ${style.reset}`, a => {
                rl.close();
                resolve(a.trim().toLowerCase());
            });
        });

        if (ans === 'y') {
            releaseNotes = `## ${tagName}\n\n**Improvements**\n- Performance enhancements\n- Bug fixes`;
            fs.writeFileSync(releaseNotePath, releaseNotes);
            print.success("Created default notes.");
        } else {
            print.error("Aborting. Please create release notes first.");
            return;
        }
    }

    // 3. Build APK
    print.step("Building Android APK (release)...");
    try {
        // Use shell execution with inheritance to show Flutter output (it's slow, user needs to see progress)
        execSync('flutter build apk --release --target-platform android-arm64', { stdio: 'inherit', cwd: CONFIG.projectDir });
        print.success("APK Built successfully.");
    } catch (e) {
        print.error("Build failed.");
        return;
    }

    // 4. Create GitHub Release
    print.step(`Publishing ${tagName} to GitHub...`);

    // Cleanup old tag if exists (Zombie tag fix)
    try {
        await request('DELETE', `/repos/${CONFIG.owner}/${CONFIG.repo}/git/refs/tags/${tagName}`);
    } catch (e) { }

    try {
        const releaseRes = await request('POST', `/repos/${CONFIG.owner}/${CONFIG.repo}/releases`, JSON.stringify({
            tag_name: tagName,
            target_commitish: 'main',
            name: `Glaze v${cleanVersion}`,
            body: releaseNotes,
            draft: false,
            prerelease: false
        }));

        print.success(`Release created: ${releaseRes.html_url}`);

        // 5. Upload Asset
        print.step("Uploading APK...");
        const fileName = `glaze-v${cleanVersion}.apk`;
        await uploadAsset(releaseRes.id, CONFIG.apkPath, fileName);
        print.success("APK Uploaded!");

    } catch (e) {
        print.error("Release failed.");
        if (e.body) console.log(e.body);
        else console.log(e);
    }
}

// --- MAIN MENU ---
(async () => {
    console.clear();
    console.log(`
${style.bright}${style.fg.magenta}   GLAZE PRO MANAGER   ${style.reset}
${style.dim}   v2.0 | Revyxon      ${style.reset}
    `);

    console.log(`${style.fg.blue}[1]${style.reset} 🚀 Sync Code (Commit & Push)`);
    console.log(`${style.fg.blue}[2]${style.reset} 📦 Build & Release (Full Pipeline)`);
    console.log(`${style.fg.blue}[3]${style.reset} 🚪 Exit`);

    const rl = readline.createInterface({ input: process.stdin, output: process.stdout });

    rl.question(`\n${style.bright}Select Action:${style.reset} `, async (choice) => {
        rl.close();

        try {
            if (choice === '1') {
                await syncRepo();
            } else if (choice === '2') {
                await deployNewVersion();
            } else {
                console.log("Exiting.");
            }
        } catch (e) {
            print.error("Unexpected error:");
            console.error(e);
        }
    });

})();
