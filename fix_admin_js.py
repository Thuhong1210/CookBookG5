#!/usr/bin/env python3
"""Fix JavaScript syntax errors in Admin.html"""

with open('/Users/admin/Documents/GitHub/CookBookG5/frontend/templates/Admin.html', 'r') as f:
    lines = f.readlines()

# Fix statusData (lines 3360-3365, 0-indexed: 3359-3364)
lines[3361] = '                {{ approved_recipes_count or 0 }},\n'
lines[3362] = '                {{ pending_recipes_count or 0 }},\n'
lines[3363] = '                {{ hidden_recipes_count or 0 }}\n'

# Fix categoryData (lines 3367-3369, 0-indexed: 3366-3368)
lines[3366] = '\n'
lines[3367] = '        const categoryData = {\n'
lines[3368] = "            labels: [{% for label, count in category_counts %}'{{ label or \"Other\" }}'{% if not loop.last %}, {% endif %}{% endfor %}],\n"
lines[3369] = '            data: [{% for label, count in category_counts %}{{ count }}{% if not loop.last %}, {% endif %}{% endfor %}]\n'

with open('/Users/admin/Documents/GitHub/CookBookG5/frontend/templates/Admin.html', 'w') as f:
    f.writelines(lines)

print("Fixed JavaScript syntax errors in Admin.html")
