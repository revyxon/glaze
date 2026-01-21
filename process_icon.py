from PIL import Image
import os

def process_icon():
    input_path = "app_icon.png"
    output_dir = "assets/icons"
    output_path = os.path.join(output_dir, "app_icon.png")

    # Ensure output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    try:
        # Open source image
        img = Image.open(input_path).convert("RGBA")
        
        # Target canvas size
        canvas_size = (1024, 1024)
        
        # Create transparent canvas (or white if preferred, but transparent is safer for adaptive layers usually)
        # However, for a "Launcher Icon", a background is often needed if the icon itself isn't full bleed.
        # User said "thoda or space lena... taki puncher banne ke baad... perfect fit aye"
        # This implies the user's icon is the foreground logo.
        # We will keep the background transparent for now, assuming the user's PNG might have its own background shape
        # OR we can assume we strictly want to pad the content.
        
        canvas = Image.new("RGBA", canvas_size, (255, 255, 255, 0)) # Transparent background
        
        # Calculate resize (Safe zone logic)
        # Android Safe Zone is diameter 72dp (66% of 108dp).
        # User requested 100% (Full Bleed).
        # This will touch the edges of the 1024x1024 canvas.
        # Note: Corners WILL be cut by adaptive masks.
        target_scale = 1.0
        new_width = int(canvas_size[0] * target_scale)
        
        # Calculate new height maintaining aspect ratio
        aspect_ratio = img.height / img.width
        new_height = int(new_width * aspect_ratio)
        
        # Resize using high-quality resampling (LANCZOS)
        img_resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
        
        # Center position
        x = (canvas_size[0] - new_width) // 2
        y = (canvas_size[1] - new_height) // 2
        
        # Paste centered
        canvas.paste(img_resized, (x, y), img_resized)
        
        # Save
        canvas.save(output_path, "PNG")
        print(f"Success: Icon processed and saved to {output_path}")
        print(f"Dimensions: 1024x1024, Logo Size: {new_width}x{new_height} (centered)")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    process_icon()
