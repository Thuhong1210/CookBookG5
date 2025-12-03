
import os

file_path = '/Users/admin/Documents/GitHub/CookBookG5/frontend/templates/Admin.html'

new_content_lines = [
    "        const statusData = {\n",
    "            labels: ['Approved', 'Pending', 'Hidden'],\n",
    "            data: [\n",
    "                {{ approved_recipes_count or 0 }},\n",
    "                {{ pending_recipes_count or 0 }},\n",
    "                {{ hidden_recipes_count or 0 }}\n",
    "            ]\n",
    "        };\n",
    "\n",
    "        const categoryData = {\n",
    "            labels: [{% for label, count in category_counts %}'{{ label or \"Other\" }}'{% if not loop.last %}, {% endif %}{% endfor %}],\n",
    "            data: [{% for label, count in category_counts %}{{ count }}{% if not loop.last %}, {% endif %}{% endfor %}]\n",
    "        };\n"
]

with open(file_path, 'r') as f:
    lines = f.readlines()

# Indices are 0-based, so line 2948 is index 2947.
# We want to replace lines 2948 to 2961 (inclusive).
# 2948 -> 2947
# 2961 -> 2960
# Slice: [2947 : 2961] (since end index is exclusive, 2961 means up to 2960)

start_line = 2948
end_line = 2961

# Adjust for 0-based index
start_idx = start_line - 1
end_idx = end_line

# Verify we are replacing the right stuff
print("Replacing lines:")
for i in range(start_idx, end_idx):
    print(f"{i+1}: {lines[i].rstrip()}")

# Replace
lines[start_idx:end_idx] = new_content_lines

with open(file_path, 'w') as f:
    f.writelines(lines)

print("Successfully replaced lines.")
