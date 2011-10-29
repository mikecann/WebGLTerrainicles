package webgl.sprites;
import shaders.SpriteRenderShader;
import webgl.geom.FullscreenQuad;
import webgl.geom.Quad;
import webgl.math.Mat4;
import webgl.textures.Texture2D;
import Html5Dom;

/**
 * ...
 * @author 
 */

class Sprite 
{
	public var gl : WebGLRenderingContext;	
	public var texture : Texture2D;
	public var quad : Quad;
	public var shader : SpriteRenderShader;
	public var mvMatrix : Mat4;	
	public var perspective : Mat4;	
	public var x:Float;
	public var y:Float;
	
	public function new(gl:WebGLRenderingContext) 
	{
		this.gl = gl;	
		x = y = 0;
		quad = new Quad(gl);
		shader = new SpriteRenderShader(gl);
		mvMatrix = new Mat4();
		perspective = new Mat4();
	}
	
	public function render(?mat:Mat4) : Void
	{			
		if (mat==null)
		{
			mvMatrix.reset();
			mvMatrix.translate(x+texture.width/2, y+texture.height/2, 0);
			mvMatrix.scale(texture.width / 2, texture.height / 2, 0);
		}
		else
		{
			mvMatrix = mat;
		}
		
		// Update shader params
		shader.use();				
		shader.perspectiveMatrix.setMatrix(perspective.toFloat32Array());
		shader.vertexPosition.setBuffer(quad.vertexBuffer);
		shader.vertexTextureCoord.setBuffer(quad.texCoordBuffer);
		shader.viewMatrix.setMatrix(mvMatrix.toFloat32Array());		
		shader.spriteTex.setTexture(texture);
		
		quad.render();
	}
	
	
	
}