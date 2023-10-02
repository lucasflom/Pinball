# pinball
 A little pinball game created by Jack Nemitz and Lucas Flom for CSCI 5611.



## Scored Sections
- **Basic Pinball Dynamics** (30)
Simulate a ball falling down a screen (accelerating under gravity) that has natural
bouncing interactions with multiple objects as it falls down.

- **Multiple Balls Interacting** (20)
Simulate multiple balls interacting with each other all they fall down bouncing
through a set of obstacles in the style of pinball machine. The balls need to clearly
bounce off each other in a natural fashion. For full credit, the balls cannot penetrate
any obstacles (even briefly) or miss collisions, and all motion must look natural.

- **Circular Obstacles** (10)
The pinball simulation must include multiple circular objects that the ball interacts
with, in a smooth and natural fashion.

- **Line-Segment and/or Polygonal Obstacles** (10)
Include multiple line-segment and/or polygonal obstacles that the ball interacts
with, in a smooth and natural fashion.

- **Plunger/Launcher to shoot balls** (10)
Launch the balls into the scene in the style of a traditional pinball game, making sure
the balls have a natural initial velocity and resulting path.

- **Textured Background** (5)
Use textures or sprite to display an image on the pinball table/background. For full
credit, this image should make sense with the placement of any obstacles.

- **Score Display** (5)
Track some score based on the ball’s motion and display this score graphically. (No
credit for displaying the score on the command line.)

- **Loading Scenes from Files** (10)
Create a scene format that allows you to specify the layout of the pinball obstacles;
then load the scene from a file. For full credit, you must demonstrate loading at least
two different scenes/table layouts.

 - **Sound Effects** (5)
Have sound effects that are triggered by the balls’ interaction with objects.

- **Progressive Objectives** (5)
Implement an objective system where the user has different objects as targets that
they must chain together to unlock some extra reward or effect. E.g., a series of
targets that pop-up after each is hit, areas on the floor that must be hit in a certain
order to unlock multi-ball, or maybe knocking over three special targets triggers a
special effect or triggers a particle system animation and gives a score multiplier for
the duration of the animation.

## Level file format
The levels will be lists of shapes that are needed to populate the screen. As of now they are in the format of Shape(C, L, B): Data(formats below).

- C(ircles): center_x center_y radius

- L(ines): x1 y1 x2 y2

- B(oxes): center_x center_y width height

For future it may be changed to include the color that the shape should take or it will be implemented into the program to fit a "theme".

Before each shape section will be a line with the number of the shapes present in the file after it's letter, i.e. C: 3 for 3 circles.