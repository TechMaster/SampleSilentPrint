# Problem
If we don't scale photo size, file size of final PDF is big.

# Solution
1. Calculate approximate width and height of image when it is layout in web page
2. Resize image file
3. Write to temp folder

# How to calculate size of scaled photo when generate PDF

N : image per page
pagewidth = (215.9mm - 2 * 15mm)= 185 mm
1 mm = 0.0393701 inch
print resolution = 300 pixel per inch
display resolution = 72 pixel per inch
185 mm  * 0.0393701 * 300 DPI = 2185
185 * 0.0393701 * 72 = 524 pixels
524 / 2
1. max width = pagewidth
2. max width = pageheight / 1.5
3. max width = pagewidth / 2
4. max width = pagewidth / 2
5. max width = pagewidth / 2
6. max width = pagewidth / 2
7. max width = pagewidth / 3
8. max width = pagewidth / 3
9. max width = pagewidth / 3
10. max width = pagewidth / 3
11. max width = pagewidth / 3
12. max width = pagewidth / 3