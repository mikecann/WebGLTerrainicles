package webgl.shaders;

import Html5Dom;

/**
 * ...
 * @author 
 */

class ShaderAttribute
{
	public var shader : Shader;
	public var name : String;
	public var location : GLint;
	public var buffer(default, setBuffer) : WebGLBuffer;
	
	private var gl : WebGLRenderingContext;

	public function new(shader:Shader, name:String) 
	{
		this.shader = shader;
		this.name = name;
		this.gl = shader.gl;
		
		location = gl.getAttribLocation(shader.program, name);
		gl.enableVertexAttribArray(location);		
	}
	
	public function setData(value:Float32Array,?size:Int=1, ?stride:Int=0, ?offset:Int=0) : Float32Array
	{
		shader.use();
		gl.bindBuffer(gl.ARRAY_BUFFER, gl.createBuffer());
		gl.bufferData(gl.ARRAY_BUFFER, value, gl.STATIC_DRAW);
		gl.vertexAttribPointer(location, size, gl.FLOAT, false, stride, offset);
		return value;
	}	
	
	public function setBuffer(value:WebGLBuffer) : WebGLBuffer
	{
		shader.use();
		gl.bindBuffer(gl.ARRAY_BUFFER, value);
		gl.vertexAttribPointer(location, value.itemSize, gl.FLOAT, false, 0, 0);
		return value;
	}
}