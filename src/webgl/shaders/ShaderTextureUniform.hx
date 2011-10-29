package webgl.shaders;
import webgl.textures.Texture2D;
import Html5Dom;

/**
 * ...
 * @author 
 */

class ShaderTextureUniform 
{	
	public var shader : Shader;
	public var name : String;
	public var location : WebGLUniformLocation;
	public var texIndx : GLint;
	
	private var gl : WebGLRenderingContext;

	public function new(shader:Shader, name:String, textureindex:Int) 
	{
		this.shader = shader;
		this.name = name;
		this.gl = shader.gl;			
		texIndx = [gl.TEXTURE0, gl.TEXTURE1, gl.TEXTURE2, gl.TEXTURE3, gl.TEXTURE4, gl.TEXTURE5, gl.TEXTURE6, gl.TEXTURE7][textureindex];
		shader.use();
		location = gl.getUniformLocation(shader.program, name);
		gl.uniform1i(location, textureindex);
	}
	
	public function setTexture(value:Texture2D) : Void
	{
		shader.use();
		gl.activeTexture(texIndx);
		gl.bindTexture(gl.TEXTURE_2D, value.texture);
	}
	
}