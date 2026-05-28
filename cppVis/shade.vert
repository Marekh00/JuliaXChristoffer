#version 410 core
in vec3 oCol;
out vec4 frag_color;

void main()
{

frag_color = vec4(oCol,1.0f);
}
