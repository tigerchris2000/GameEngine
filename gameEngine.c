#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include "gameEngine.h"

static int width, height;

void renderScene()
{
	glClear(GL_COLOR_BUFFER_BIT);
	glutSwapBuffers();
}
void setupRC(void)
{
	glClearColor(0.0f,0.0f,1.0f,1.0f);
}

void engineSetup(int* argc,char* argv[],int pwidth,int pheight,char* name)
{
	width = pwidth;
	height = pheight;
	glutInit(argc,argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGBA);
	glutInitWindowSize(pwidth,pheight);
	glutCreateWindow(name);
	glutDisplayFunc(renderScene);

	setupRC();
	glutMainLoop();
}
