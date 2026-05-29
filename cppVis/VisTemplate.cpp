#include <iostream>
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <string>
#include <fstream>
#include <vector>
#include <functional>
#include <cmath>

struct DrawCommand
{
	GLenum mode;
	int size;
	int offset;
};

void key_callback();
std::string ReadShaderToString(const std::string filename);
void ReadFuncVal(std::vector<float>& verts, std::vector<DrawCommand>& commands, int& offset);
int winW = 800;
int winH = 800;


struct Vec2
{
	float x;
	float y;

	Vec2 operator+(const Vec2& other) const
	{
		return
		{
			x + other.x,
			y + other.y
		};
	}
	Vec2 operator*(float c) const
	{
		return
		{
			x*c,
			y*c
		};
	}
	Vec2 operator-(const Vec2& other) const
	{
		return
		{
			x - other.x,
			y - other.y
		};
	}	
};



// START tegnefunksjoner
void DrawCircle(
	std::vector<DrawCommand>& commands, 
	std::vector<float>& verts, 
	int& offset, 
	float radius, 
	Vec2 position);
void DrawLine(std::vector<DrawCommand>& commands, int& offset);
// SLUTT tegnefunksjoner

const double PI = 3.1415926535;
std::vector<float> position;

struct Engine
{
	GLFWwindow* window;
	int WIDTH 	= winW;
	int HEIGHT 	= winH;
	int offset;

	// START definisjon av viktige variabler
	std::vector<DrawCommand> commands;
	std::vector<float> verts;
	GLuint shader_program;
	GLuint vao;
	GLuint vbo;
	// SLUTT definisjon av viktige variabler

	Engine()
	{
	
		// START setup av skjerm
		if (!glfwInit())
		{
			fprintf(stderr, "ERROR: could not initalize GLFW3.\n");
			exit(EXIT_FAILURE);
		}

		glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
		glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
		glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
		glfwWindowHint(GLFW_OPENGL_PROFILE,GLFW_OPENGL_CORE_PROFILE);
		
		
		window = glfwCreateWindow(WIDTH,HEIGHT,"Simulation",NULL,NULL);
		
verts.clear();
		commands.clear();
		int offset = 0;		if (!window)
		{
			fprintf(stderr, "ERROR: could not open window with GLFW3.\n");
			exit(EXIT_FAILURE);
		}	
		
		
		glfwMakeContextCurrent(window);
 		int version_glad = gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);
		glfwSwapInterval(1);
		
		if (version_glad == 0)
		{
			fprintf(stderr, "ERROR: could not initalize openGL context.\n");
			exit(EXIT_FAILURE);
		}
		// SLUTT setup av skjerm

		// START setup av vbo / vao

		vbo = 0;
		glGenBuffers(1,&vbo);
		glBindBuffer(GL_ARRAY_BUFFER,vbo);

		// Det essensielle for hele idk
		glBufferData(GL_ARRAY_BUFFER, 10000*3, nullptr, GL_DYNAMIC_DRAW);
	
		vao = 0;
		glGenVertexArrays(1,&vao);
		glBindVertexArray(vao);
		glEnableVertexAttribArray(0);

		glBindBuffer(GL_ARRAY_BUFFER,vbo);
		glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,0,NULL);
		// SLUTT setup av vbo / vao

		// START setup av shaders

		std::string pre_vertex_shader = ReadShaderToString("shade.vert");
		std::string pre_frag_shader = ReadShaderToString("shade.frag");
		const char* vert_shader = pre_vertex_shader.c_str();
		const char* frag_shader = pre_frag_shader.c_str();
		
		GLuint vs = glCreateShader(GL_VERTEX_SHADER);
		glShaderSource(vs, 1, &vert_shader,NULL);
		glCompileShader(vs);
		GLuint fs = glCreateShader(GL_FRAGMENT_SHADER);
		glShaderSource(fs,1,&frag_shader,NULL);
		glCompileShader(fs);

		shader_program = glCreateProgram();
		glAttachShader(shader_program,vs);
		glAttachShader(shader_program,fs);
		glLinkProgram(shader_program);		
		// SLUTT setup av shaders
		int lparams = -1;
		glGetProgramiv(shader_program,GL_LINK_STATUS,&lparams);
		if (GL_TRUE != lparams)
		{
			fprintf(stderr,"ERROR: could not link shader program.\n");
			exit(EXIT_FAILURE);
		}	
	}
	// func for å sett opp vbo og tegne
	void run(GLuint& shader_program,GLuint& vao)
	{
		glViewport(0,0,winW,winH);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glUseProgram(shader_program);
		// START lag former
		//verts.clear();
		//commands.clear();
		offset = 0;



		// HER lag commands


		/*		glNamedBufferSubData(
			vbo,
			0,
			verts.size()*sizeof(float),
			verts.data()		
		);
		
*/

		glBindVertexArray(vao);


		// SLUTT lag former
		// START tegne fra commands
		for (DrawCommand cmd : commands)
		{
			glDrawArrays(
				cmd.mode,
				cmd.offset,
				cmd.size
			);
		}

		// SLUTT tegne fra commands


	}
	
}; Engine engine;

std::string ReadShaderToString(std::string filename)
{
	std::string line = "";
	std::string file = "";
	std::ifstream myFile(filename.c_str());

	if (myFile.is_open())
	{
		while (std::getline(myFile,line))
		{
			file += line + '\n';
		}
	}
	myFile.close();
	return file;
}

void AddVec3(std::vector<float>& verts, float X, float Y)
{
	verts.push_back(X);
	verts.push_back(Y);
	verts.push_back(1.0);
}

void DrawCircle(
	std::vector<DrawCommand>& commands, 
	std::vector<float>& verts, 
	int& offset, 
	float radius, 
	Vec2 position)
{
	float x = position.x;
	float y = position.y;
	float r = radius*2/engine.WIDTH;
	int resolution = 15;

	DrawCommand cmd = {GL_TRIANGLE_FAN, resolution ,offset};
	commands.push_back(cmd);
	offset += resolution;
	for (int i = 0; i < resolution+1; i++)
	{
		float X = r*cos(2*PI*i/resolution) + x;
		float Y = r*sin(2*PI*i/resolution) + y;
	
		AddVec3(verts, X, Y);
	}
}

void ReadFuncVal(std::vector<float>& verts, std::vector<DrawCommand>& commands, int& offset)
{
	std::string X;
	std::string Y;

	std::getline(std::cin,X);
	std::getline(std::cin,Y);

	int Xlen = X.length();
	X = X.substr(1,Xlen-2);
	Y = Y.substr(1,Xlen-2);
	Xlen = X.length();
	
	std::cout << X << std::endl;

	commands.push_back({GL_LINE_STRIP,10, 0});
	offset += 10;


	for (int i = 0; i<10; i++)
	{
		AddVec3(verts,i/5-1,i/5-1);
	}

	
}

int main()
{
	ReadFuncVal(engine.verts, engine.commands,engine.offset);
	double prevsec=0.0;
	double countdown = 1;

	while(!glfwWindowShouldClose(engine.window))
	{

		double timePassed = glfwGetTime();
		double elapsed = timePassed-prevsec;
		prevsec = timePassed;
		countdown -= elapsed;
		if (countdown <= 0.0 && elapsed > 0.0)
		{
			countdown = 1;
		}
		if (glfwGetKey(engine.window,GLFW_KEY_ESCAPE))
		{
			glfwSetWindowShouldClose(engine.window,GLFW_TRUE);
		}
		// START drawing
		engine.run(engine.shader_program, engine.vao);
			
		// SLUTT drawing

		glfwSwapBuffers(engine.window);
		glfwPollEvents();
	}
	glfwTerminate();
	return 0;
}
