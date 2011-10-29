package ;
import shaders.SpawnParticleShader;
import utils.Rand;
import webgl.geom.FullscreenQuad;
import webgl.math.Mat4;
import webgl.sprites.Sprite;
import webgl.textures.DoubleBufferedRenderTarget2D;
import webgl.textures.RenderTarget2D;
import webgl.textures.Texture2D;
import Html5Dom;

/**
 * ...
 * @author 
 */

class ParticleSpawner 
{
	private var manager : ParticlesManager;
	private var nextIndx : Int;
	private var gl : WebGLRenderingContext;
	private var shader : SpawnParticleShader;
	private var quad : FullscreenQuad;
	private var spawnTex : Texture2D;	
	private var positions : Array<Float>;
	private var velocities : Array<Float>;

	public function new(manager:ParticlesManager) 
	{
		this.manager = manager;
		this.gl = manager.gl;
		
		nextIndx = 0;
		
		shader = new SpawnParticleShader(gl);
		quad = new FullscreenQuad(gl);
		spawnTex = new Texture2D(gl);	
	}
	
	public function reset():Void 
	{
		positions = [];
		velocities = [];
		
		for (k in 0...manager.texWidth*manager.texHeight)
		{
			positions.push(0);
			positions.push(0);
			positions.push(0);
			velocities.push(0);
			velocities.push(0);
			velocities.push(0);	
		}			
	}
	
	public function spawnParticles(x:Int, y:Int, num:Int) : Void
	{	
		var start = nextIndx;		
		for (i in 0...num)
		{
			var ang = Rand.float(0, 6);
			positions[nextIndx]=x;
			positions[nextIndx+1] = y;
			positions[nextIndx+2] = 1;
			velocities[nextIndx] = Math.random()*5*Math.cos(ang);
			velocities[nextIndx+1] = Math.random()*5*Math.sin(ang);
			velocities[nextIndx+2] = 1;
			nextIndx += 3;
			if (nextIndx >= positions.length) nextIndx = 0;			
		}	
		
		updateDBuffer(manager.positionsDB, positions);
		updateDBuffer(manager.velocitiesDB, velocities);		
		
		nextIndx = start;
		for (j in 0...num)
		{			
			positions[nextIndx+2] = 0;
			velocities[nextIndx+2] = 0;
			nextIndx += 3;
			if (nextIndx >= positions.length) nextIndx = 0;			
		}	
	}
	
	private function updateDBuffer(target:DoubleBufferedRenderTarget2D, data:Array<Float>) : Void
	{
		spawnTex.initFromFloats(manager.texWidth, manager.texHeight, data);
		
		// Limit to the size of our offscreen buffers
		gl.viewport(0, 0, manager.texWidth, manager.texHeight);	
		
		// Update shader params
		shader.use();		
		shader.vertexPosition.setBuffer(quad.vertexBuffer);
		shader.vertexTextureCoord.setBuffer(quad.texCoordBuffer);
		shader.spawnTexture.setTexture(spawnTex);		
		shader.oldTexture.setTexture(target.front);
		
		// Render updates to back buffer
		target.front.bind();		
		quad.render();
		target.front.unbind();		
	}
}