# pinball
 A little pinball game




## Level file format
The levels will be lists of shapes that are needed to populate the screen. As of now they are in the format of Shape(C, L, B): Data(formats below).

-C(ircles): center_x center_y radius

-L(ines): x1 y1 x2 y2

-B(oxes): center_x center_y width height

For future it may be changed to include the color that the shape should take or it will be implemented into the program to fit a "theme".

Before each shape section will be a line with the number of the shapes present in the file after it's letter, i.e. C: 3 for 3 circles.