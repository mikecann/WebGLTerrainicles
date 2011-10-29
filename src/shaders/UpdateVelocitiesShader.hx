package shaders;
import webgl.shaders.Shader;
import webgl.shaders.ShaderAttribute;
import webgl.shaders.ShaderTextureUniform;
import webgl.shaders.ShaderUniform;

import Html5Dom;

/**
 * ...
 * @author 
 */

class UpdateVelocitiesShader extends Shader
{
	public var positionsUniform : ShaderTextureUniform;
	public var velocitiesUniform : ShaderTextureUniform;
	public var terrainUniform : ShaderTextureUniform;
	public var worldWidthUniform : ShaderUniform;
	public var worldHeightUniform : ShaderUniform;
	public var bounceFrictionUniform : ShaderUniform;
	public var gravityStrengthUniform : ShaderUniform;
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
		bounceFrictionUniform = new ShaderUniform(this, "bounceFriction");
		gravityStrengthUniform = new ShaderUniform(this, "gravityStrength");
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
			uniform float bounceFriction;
			uniform float gravityStrength;
			uniform float frameDelta;
			
			uniform sampler2D positions;
			uniform sampler2D velocities;
			uniform sampler2D terrain;
			
			varying vec2 vTexCoord;

			const float terrainW = 2048.;
			const float terrainH = 2048.;
			
			void main(void) 
			{
				vec2 pos = texture2D(positions, vTexCoord).xy;
				vec3 vel = texture2D(velocities, vTexCoord).xyz;		
				
				float age = vel.z + 0.02;
				if (age > 1.) age = 1.;
				
				vec2 newVel = vel.xy;
				newVel.y += gravityStrength;
				
				vec2 nextPos = pos + (newVel*frameDelta);
				vec2 outVel;
				
				vec2 p = vec2(nextPos.x, pos.y);				
				vec4 t = texture2D(terrain, p / terrainW);
				if (t.a != 0.) { outVel.x = -newVel.x*bounceFriction; }
				else { outVel.x = newVel.x; }
												
				p = vec2(pos.x, nextPos.y);				
				t = texture2D(terrain, p / terrainH);
				if (t.a != 0.) { outVel.y = -newVel.y*bounceFriction; }		
				else { outVel.y = newVel.y; }
				
				pos += newVel*frameDelta;
					
				if (pos.y < -0.) { outVel.y *= -bounceFriction; }
				else if (pos.y > worldH) { outVel.y *= -bounceFriction; }
				if (pos.x < -0.) { outVel.x *= -bounceFriction; }
				else if (pos.x > worldW) { outVel.x *= -bounceFriction; }
				
				gl_FragColor = vec4(outVel,age, 1.);				
				//gl_FragColor = vec4(outVel,0., 1.);				
			}
		";		
	}	
}