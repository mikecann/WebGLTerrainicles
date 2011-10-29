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

class UpdatePositionsShader extends Shader
{	
	public var positionsUniform : ShaderTextureUniform;
	public var velocitiesUniform : ShaderTextureUniform;
	public var terrainUniform : ShaderTextureUniform;
	public var worldWidthUniform : ShaderUniform;
	public var worldHeightUniform : ShaderUniform;
	public var frameDelta : ShaderUniform;
	
	public var vertexPosition : ShaderAttribute;
	public var vertexTextureCoord : ShaderAttribute;
	
	public function new(gl:WebGLRenderingContext)
	{			
		super(gl);	
		vertexPosition = new ShaderAttribute(this, "aPos");
		vertexTextureCoord = new ShaderAttribute(this, "aTexCoord");
		positionsUniform = new ShaderTextureUniform(this, "positions", 0);
		velocitiesUniform = new ShaderTextureUniform(this, "velocities", 1);
		terrainUniform = new ShaderTextureUniform(this, "terrain", 2);
		
		worldWidthUniform = new ShaderUniform(this, "worldW");
		worldHeightUniform = new ShaderUniform(this, "worldH");
		frameDelta = new ShaderUniform(this, "frameDelta");
	}
	
	override private function getVertexSrc() : String
	{
		return 
		"
			attribute vec2 aPos;
			attribute vec2 aTexCoord;
			
			varying   vec2 vTexCoord;
			
			void main(void) 
			{
				gl_Position = vec4(aPos, 0., 1.);
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
			
			uniform float worldW;
			uniform float worldH;
			uniform sampler2D positions;
			uniform sampler2D velocities;
			uniform sampler2D terrain;
			uniform float frameDelta;
			
			varying vec2 vTexCoord;
			
			const float terrainW = 2048.;
			const float terrainH = 2048.;
			
			void main(void) 
			{
				vec2 pos = texture2D(positions, vTexCoord).xy;
				vec2 vel = texture2D(velocities, vTexCoord).xy;
				
				vec2 nextPos = pos + (vel*frameDelta);
				vec2 newPos;
				
				vec2 p = vec2(nextPos.x, pos.y);				
				vec4 t = texture2D(terrain, p / terrainW);
				if (t.a == 0.) { newPos.x = nextPos.x; }
				else { newPos.x = pos.x; }
												
				p = vec2(pos.x, nextPos.y);				
				t = texture2D(terrain, p / terrainH);
				if (t.a == 0.) { newPos.y = nextPos.y; }		
				else { newPos.y = pos.y; }
				
				if (newPos.y < 0.) { newPos.y = 0.; }
				else if (newPos.y > worldH) { newPos.y = worldH; }
				if (newPos.x < 0.) { newPos.x = 0.; }
				else if (newPos.x > worldW) { newPos.x = worldW; }	
				
				
				gl_FragColor = vec4(newPos,0., 1.);				
			}
		";		
	}
}