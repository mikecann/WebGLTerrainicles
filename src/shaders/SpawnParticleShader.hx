package shaders;
import webgl.shaders.Shader;
import Html5Dom;
import webgl.shaders.ShaderAttribute;
import webgl.shaders.ShaderTextureUniform;
import webgl.shaders.ShaderUniform;

/**
 * ...
 * @author 
 */

class SpawnParticleShader extends Shader
{

	public var vertexPosition : ShaderAttribute;	
	public var vertexTextureCoord : ShaderAttribute;	
	public var spawnTexture : ShaderTextureUniform;
	public var oldTexture : ShaderTextureUniform;
	
	public function new(gl:WebGLRenderingContext)
	{			
		super(gl);	
		setupAtribsAndUniforms();
	}
	
	public function setupAtribsAndUniforms() : Void
	{
		vertexTextureCoord = new ShaderAttribute(this, "aTexCoord");
		spawnTexture = new ShaderTextureUniform(this, "spawntex", 0);
		oldTexture = new ShaderTextureUniform(this, "oldtex", 1);
		vertexPosition = new ShaderAttribute(this, "vertexPosition");
	}
	
	override private function getVertexSrc() : String
	{
		return 
		"						
			attribute vec2 vertexPosition;
			attribute vec2 aTexCoord;
			
			varying   vec2 vTexCoord;			
			
			void main(void) 
			{
				gl_Position = vec4(vertexPosition, 0., 1.);
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

			uniform sampler2D spawntex;
			uniform sampler2D oldtex;
			varying vec2 vTexCoord;
			
			void main(void) 
			{				
				vec4 v = texture2D(spawntex, vTexCoord);
				if (v.z == 1.) gl_FragColor = vec4(v.xy,0.,0.);
				else gl_FragColor = texture2D(oldtex, vTexCoord);
			}
		";		
	}
}