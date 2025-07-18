import os

# Define paths
cla_file = "SceneIBR_Model_Testing_outdoor.cla"  # Replace with your actual .cla file path
source_folder = "Run2_Yuan_outdoor"
output_folder = "Run2_Yuan_outdoor_clean"

# Category filter list
target_categories = {
    "airport_terminal", "apartment_building_outdoor", "arch", "barn", "beach", "castle",
    "dam", "desert", "football_stadium", "great_pyramid", "mountain", "phone_booth", "river",
    "school_house", "skyscraper", "water_tower", "windmill"
}

# Create output folder if not exists
os.makedirs(output_folder, exist_ok=True)

# Step 1: Read .cla file and gather valid file IDs for target categories
valid_ids = set()

with open(cla_file, 'r') as f:
    lines = f.readlines()

i = 0
while i < len(lines):
    line = lines[i].strip()

    if line and not line.startswith("PSB") and not line[0].isdigit():
        category = line.split()[0]
        i += 1
        while i < len(lines) and lines[i].strip().isdigit():
            file_id = lines[i].strip()
            if category in target_categories:
                valid_ids.add(file_id)
            i += 1
    else:
        i += 1

# Step 2: Clean each file in the folder
for filename in os.listdir(source_folder):
    input_path = os.path.join(source_folder, filename)
    output_path = os.path.join(output_folder, filename)

    if os.path.isfile(input_path):
        with open(input_path, 'r') as infile:
            lines = infile.readlines()

        cleaned_lines = []
        for line in lines:
            parts = line.strip().split()
            if len(parts) == 2 and parts[1].isdigit():
                if parts[1] in valid_ids:
                    cleaned_lines.append(line)

        # Write cleaned file
        with open(output_path, 'w') as outfile:
            outfile.writelines(cleaned_lines)

print("Cleaning complete. Cleaned files saved to:", output_folder)