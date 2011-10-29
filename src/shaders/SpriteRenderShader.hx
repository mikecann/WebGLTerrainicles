package shaders;

import Html5Dom;
import webgl.shaders.Shader;
import webgl.shaders.ShaderAttribute;
import webgl.shaders.ShaderTextureUniform;
import webgl.shaders.ShaderUniform;

/**
 * ...
 * @author 
 */

class SpriteRenderShader extends Shader
{
	public var vertexPosition : ShaderAttribute;	
	public var vertexTextureCoord : ShaderAttribute;	
	public var viewMatrix : ShaderUniform;
	public var perspectiveMatrix : ShaderUniform;
	public var spriteTex : ShaderTextureUniform;
	
	public function new(gl:WebGLRenderingContext)
	{			
		super(gl);	
		setupAtribsAndUniforms();
	}
	
	public function setupAtribsAndUniforms() : Void
	{
		viewMatrix = new ShaderUniform(this, "mvMatrix");
		perspectiveMatrix = new ShaderUniform(this, "prMatrix");
		vertexTextureCoord = new ShaderAttribute(this, "aTexCoord");
		spriteTex = new ShaderTextureUniform(this, "spriteTex", 0);
		vertexPosition = new ShaderAttribute(this, "vertexPosition");
	}
	
	override private function getVertexSrc() : String
	{
		return 
		"			
			uniform mat4 mvMatrix;
			uniform mat4 prMatrix;		
			
			attribute vec2 vertexPosition;
			attribute vec2 aTexCoord;
			
			varying   vec2 vTexCoord;			
			
			void main(void) 
			{
				gl_Position = prMatrix * mvMatrix * vec4(vertexPosition, 0., 1.);
				//gl_Position = vec4(vertexPosition, 0., 1.);
				vTexCoord = aTexCoord;
			}
		";		
	}
	
	override private function getFragmentSrc() : String
	{
		return 
		"
			#ifdef GL_ES
			precision highp float;
			#endif			

			uniform sampler2D spriteTex;
			varying vec2 vTexCoord;
			
			void main(void) 
			{
			   gl_FragColor = texture2D(spriteTex, vTexCoord);
			}
		";		
	}
	
}