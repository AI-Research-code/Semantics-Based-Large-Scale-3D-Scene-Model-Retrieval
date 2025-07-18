import os
import shutil

# Your specified category list
target_categories = {
    "auditorium", "bedroom", "classroom", "conference_room", "hotel_room", "kitchen",
    "library", "office", "reception", "restaurant", "shower", "supermarket", "waiting_room"
}

# Paths
source_folder = "Run2_Yuan"
in_folder = "Run2_Yuan_indoor"
out_folder = "Run2_Yuan_outdoor"
cla_file_path = "SceneIBR_Image_Testing.cla"  # Replace with actual .cla file path

# Create output folders if they don't exist
os.makedirs(in_folder, exist_ok=True)
os.makedirs(out_folder, exist_ok=True)

# Parse .cla file
with open(cla_file_path, "r") as f:
    lines = f.readlines()

i = 0
while i < len(lines):
    line = lines[i].strip()

    # Skip the header and non-category lines
    if line and not line.startswith("PSB") and not line[0].isdigit():
        parts = line.split()
        category = parts[0]
        i += 1
        file_ids = []
        
        # Collect all file IDs under this category
        while i < len(lines) and lines[i].strip().isdigit():
            file_ids.append(lines[i].strip())
            i += 1

        # Copy files based on category match
        for fid in file_ids:
            src = os.path.join(source_folder, fid)
            if category in target_categories:
                dst = os.path.join(in_folder, fid)
            else:
                dst = os.path.join(out_folder, fid)

            if os.path.exists(src):
                shutil.copy(src, dst)
            else:
                print(f"Warning: File {src} does not exist.")
    else:
        i += 1