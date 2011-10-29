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

class RenderPointsShader extends Shader
{
	public var vertexPosition : ShaderAttribute;	
	public var viewMatrix : ShaderUniform;
	public var perspectiveMatrix : ShaderUniform;
	public var positionsTexture : ShaderTextureUniform;
	public var velocitiesTexture : ShaderTextureUniform;
	public var pointSize : ShaderUniform;
	public var startColor : ShaderUniform;
	public var endColor : ShaderUniform;
	
	public function new(gl:WebGLRenderingContext)
	{			
		super(gl);	
		setupAtribsAndUniforms();
	}
	
	public function setupAtribsAndUniforms() : Void
	{
		viewMatrix = new ShaderUniform(this, "mvMatrix");
		perspectiveMatrix = new ShaderUniform(this, "prMatrix");
		positionsTexture = new ShaderTextureUniform(this, "positions", 0);
		velocitiesTexture = new ShaderTextureUniform(this, "velocities", 1);
		vertexPosition = new ShaderAttribute(this, "vertexPosition");
		pointSize = new ShaderUniform(this, "pointSize");
		startColor = new ShaderUniform(this, "startColor");
		endColor = new ShaderUniform(this, "endColor");
	}
	
	override private function getVertexSrc() : String
	{
		return 
		"			
			uniform mat4 mvMatrix;
			uniform float pointSize;
			uniform mat4 prMatrix;
			uniform sampler2D positions;
			uniform sampler2D velocities;			
			uniform vec4 startColor;
			uniform vec4 endColor;
			
			varying vec4 color;
			
			attribute vec2 vertexPosition;			
			
			void main(void) 
			{
				float age = texture2D(velocities, vertexPosition).z;
				gl_Position = prMatrix * mvMatrix * texture2D(positions, vertexPosition);
				//gl_Position = texture2D(positions, aPoints)*.500;
				//gl_Position = vec4(0.0+0.5, 0.0+0.5, 0., 1.);
				gl_PointSize = pointSize;
				
				//float invage = 1. - age;
				
				//vec3 col = mix(vec3(1., 1., 1.),vec3(8., .1, .1), age);
				vec4 col = mix(startColor,endColor, age);
				
				color = col;
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
			
			varying vec4 color;
			
			void main(void) 
			{
			   gl_FragColor = color;
			}
		";		
	}
	
}