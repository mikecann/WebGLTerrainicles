package webgl.shaders;

import haxe.rtti.Infos;
import Html5Dom;

/**
 * ...
 * @author MikeCann
 */

class Shader
{	
	// Publics
	public var program(default, null) : Dynamic;
	public var gl(default, null) : WebGLRenderingContext;
	
	public function new(gl)
	{
		this.gl = gl;
		
		var fragmentShader = getShader(getFragmentSrc(), gl.FRAGMENT_SHADER);
		var vertexShader = getShader(getVertexSrc() , gl.VERTEX_SHADER);

		program = gl.createProgram();
		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);

		if (!gl.getProgramParameter(program, gl.LINK_STATUS))  { trace("Could not initialise shaders"); }
	}
	
	private function getUniformLocation(name:String) : WebGLUniformLocation
	{
		return gl.getUniformLocation(program, name);
	}
	
	public function use() : Void
	{
		gl.useProgram(program);	
	}
	
	private function getShader(shaderSrc:String, shaderType:GLenum) 
	{		
		// Create and compile the shader
		var shader : WebGLShader = gl.createShader(shaderType);
		gl.shaderSource(shader, shaderSrc);
		gl.compileShader(shader);	

		// Check for erros
		if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) { trace("An error occurred compiling the shaders: " + gl.getShaderInfoLog(shader)); return null;	}		
		
		// Return
		return shader;
	}	
	
	private function getFragmentSrc() : String
	{
		return "";
	}
	
	private function getVertexSrc() : String
	{
		return "";
	}
}