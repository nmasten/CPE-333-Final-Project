#include <stdio.h>
#include <stdlib.h>
#include <GLUT/glut.h>

GLfloat angle = 0.0;

void display(void)
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    glTranslatef(0.0, 0.0, -5.0);
    glRotatef(angle, 1.0, 1.0, 1.0);

    glBegin(GL_TRIANGLES);
    glColor3f(1.0, 0.0, 0.0); // red
    glVertex3f( 1.0, 0.0, 0.0);
    glVertex3f( 0.0, 1.0, 0.0);
    glVertex3f( 0.0, 0.0, 1.0);

    glColor3f(0.0, 1.0, 0.0); // green
    glVertex3f( 1.0, 0.0, 0.0);
    glVertex3f( 0.0, 0.0, 1.0);
    glVertex3f( 0.0,-1.0, 0.0);

    glColor3f(0.0, 0.0, 1.0); // blue
    glVertex3f( 1.0, 0.0, 0.0);
    glVertex3f( 0.0,-1.0, 0.0);
    glVertex3f( 0.0, 0.0,-1.0);

    glColor3f(1.0, 0.0, 1.0); // magenta
    glVertex3f( 1.0, 0.0, 0.0);
    glVertex3f( 0.0, 0.0,-1.0);
    glVertex3f( 0.0, 1.0, 0.0);

    glColor3f(0.0, 0.0, 1.0); // blue
    glVertex3f(-1.0, 0.0, 0.0);
    glVertex3f( 0.0, 1.0, 0.0);
    glVertex3f( 0.0, 0.0, 1.0);

    glColor3f(1.0, 0.0, 0.0); // red
    glVertex3f(-1.0, 0.0, 0.0);
    glVertex3f( 0.0, 0.0, 1.0);
    glVertex3f( 0.0,-1.0, 0.0);

    glColor3f(0.0, 1.0, 0.0); // green
    glVertex3f(-1.0, 0.0, 0.0);
    glVertex3f( 0.0,-1.0, 0.0);
    glVertex3f( 0.0, 0.0,-1.0);

    glColor3f(1.0, 0.0, 1.0); // magenta
    glVertex3f(-1.0, 0.0, 0.0);
    glVertex3f( 0.0, 0.0,-1.0);
    glVertex3f( 0.0, 1.0, 0.0);
    glEnd();

    glutSwapBuffers();
}

void reshape(int w, int h)
{
    glViewport(0, 0, (GLsizei) w, (GLsizei) h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, (GLfloat) w/(GLfloat) h, 1.0, 20.0);
    glMatrixMode(GL_MODELVIEW);
}

void idle(void)
{
    angle += 0.5;
    if (angle > 360.0)
        angle -= 360.0;

    glutPostRedisplay();
}

int main(int argc, char **argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(500, 500);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("Rotating Octahedron");
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);
    glEnable(GL_DEPTH_TEST);
    glutMainLoop();
    return 0;
}
