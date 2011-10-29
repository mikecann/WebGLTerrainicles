package ;

import Html5Dom;
import shaders.RenderPointsShader;
import shaders.UpdatePositionsShader;
import shaders.UpdateVelocitiesShader;
import utils.ColorConverter;
import utils.Rand;
import webgl.geom.FullscreenQuad;
import webgl.geom.PointCloud2D;
import webgl.math.Mat4;
import webgl.textures.DoubleBufferedRenderTarget2D;
import webgl.textures.Texture2D;

/**
 * ...
 * @author 
 */

class ParticlesManager 
{
	inline public static var WORLD_W : Float = 2048;
	inline public static var WORLD_H : Float = 2048;
	
	public var gl : WebGLRenderingContext;		

	public var x : Float;
	public var y : Float;
	public var particleCount : Int;
	public var particleSize : Int;
	public var wallFriction : Float;		
	public var mvMatrix : Mat4;	
	public var perspective : Mat4;	
	public var texWidth : Int;
	public var texHeight : Int;
	public var terrainTexture : Texture2D;
	public var positionsDB : DoubleBufferedRenderTarget2D;
	public var velocitiesDB : DoubleBufferedRenderTarget2D;
	public var spawner : ParticleSpawner;
	public var gravityStrength : Float;
	public var startColor : Int;
	public var endColor : Int;
	
	private var updatePositionsShader : UpdatePositionsShader;
	private var updateVelocitiesShader : UpdateVelocitiesShader;
	private var renderShader : RenderPointsShader;	
	
	private var quad : FullscreenQuad;
	private var cloud : PointCloud2D;
	
	public function new(gl:WebGLRenderingContext) 
	{
		this.gl = gl;
		
		particleCount = 300000;
		particleSize = 2;
		wallFriction = 0.5;
		gravityStrength = 0.04;
		startColor = 0xff3333;
		endColor = 0xff0000;
		
		perspective = new Mat4();
		mvMatrix = new Mat4();
		
		spawner = new ParticleSpawner(this);
		updatePositionsShader = new UpdatePositionsShader(gl);
		updateVelocitiesShader = new UpdateVelocitiesShader(gl);
		renderShader = new RenderPointsShader(gl);	
		positionsDB = new DoubleBufferedRenderTarget2D(gl);
		velocitiesDB = new DoubleBufferedRenderTarget2D(gl);		
		quad = new FullscreenQuad(gl);
		cloud = new PointCloud2D(gl);
	}
	
	public function reset() : Void
	{
		// Fist work out how big our positions and velocities textures need to be
		// in webgl they need to be a power of two
		calculateTexWidthAndHeight();	
		spawner.reset();

		// Setup some bits
		setupInitialPositionsAndVelocities();					
		setupRenderShader();
	}
	
	private function calculateTexWidthAndHeight():Void 
	{
		texWidth = texHeight = 2;		
		while (texWidth * texHeight < particleCount)
		{
			texWidth *= 2;
			if (texWidth * texHeight >= particleCount) break;
			texHeight *= 2;
		}			
		trace("Texture width and height set to: " + texWidth + "x" + texHeight);
	}	
	
	private function setupInitialPositionsAndVelocities() : Void
	{
		var positions : Array<Float> = [];
		var velocities : Array<Float> = [];
		
		for (k in 0...texWidth*texHeight)
		{
			var ang = (180 / Math.PI) * Math.random();
			var dist = 0.1+Math.random();
			positions.push(Rand.float(0,2048));
			positions.push (Rand.float(0,200));
			positions.push (0);			
			velocities.push(Rand.float(-5,5));
			velocities.push(Rand.float(-5,5));
			velocities.push(0);
		}			
	
		positionsDB.bufferA.initFromFloats(texWidth, texHeight, positions);
		positionsDB.bufferB.initFromFloats(texWidth, texHeight, positions);
		velocitiesDB.bufferA.initFromFloats(texWidth, texHeight, velocities);
		velocitiesDB.bufferB.initFromFloats(texWidth, texHeight, velocities);
		
		positionsDB.bufferA.setupFBO();
		positionsDB.bufferB.setupFBO();
		velocitiesDB.bufferA.setupFBO();
		velocitiesDB.bufferB.setupFBO();
	}
	
	private function setupRenderShader() : Void	
	{
		var vertices = [];
		var invTexW : Float = 1 / texWidth;
		var invTexH : Float = 1 / texHeight;
		var y : Float = invTexH / 2;
		while ( y < 1 )
		{
			var x : Float = invTexW / 2;
			while ( x < 1 )
			{
				vertices.push ( x );
				vertices.push ( y );
				x += invTexW;
			}
			y += invTexH;
		}				

		cloud.initFromData(new Float32Array(vertices));
	}
	
	public function update(delta:Float):Void 
	{	
		updatePositions(delta);
		updateVelocities(delta);		
	}
	
	private function updatePositions(delta:Float): Void
	{
		// Limit to the size of our offscreen buffers
		gl.viewport(0, 0, texWidth, texHeight);	
		
		// Update shader params
		updatePositionsShader.use();		
		updatePositionsShader.worldWidthUniform.setFloat(WORLD_W);
		updatePositionsShader.worldHeightUniform.setFloat(WORLD_H);
		updatePositionsShader.positionsUniform.setTexture(positionsDB.front);
		updatePositionsShader.velocitiesUniform.setTexture(velocitiesDB.front);	
		updatePositionsShader.terrainUniform.setTexture(terrainTexture);
		updatePositionsShader.vertexPosition.setBuffer(quad.vertexBuffer);
		updatePositionsShader.vertexTextureCoord.setBuffer(quad.texCoordBuffer);
		updatePositionsShader.frameDelta.setFloat(delta/10);
		
		// Render updates to back buffer
		positionsDB.back.bind();		
		quad.render();
		positionsDB.back.unbind();
	}
	
	private function updateVelocities(delta:Float) : Void
	{
		// Limit to the size of our offscreen buffers
		gl.viewport(0, 0, texWidth, texHeight);	
		
		// Update shader params
		updateVelocitiesShader.use();		
		updateVelocitiesShader.worldWidthUniform.setFloat(WORLD_W);
		updateVelocitiesShader.worldHeightUniform.setFloat(WORLD_H);				
		updateVelocitiesShader.positionsUniform.setTexture(positionsDB.front);
		updateVelocitiesShader.velocitiesUniform.setTexture(velocitiesDB.front);
		updateVelocitiesShader.terrainUniform.setTexture(terrainTexture);
		updateVelocitiesShader.vertexPosition.setBuffer(quad.vertexBuffer);
		updateVelocitiesShader.vertexTextureCoord.setBuffer(quad.texCoordBuffer);
		updateVelocitiesShader.bounceFrictionUniform.setFloat(wallFriction);
		updateVelocitiesShader.gravityStrengthUniform.setFloat(gravityStrength);
		updateVelocitiesShader.frameDelta.setFloat(delta/10);
		
		// Render updates to back buffer
		velocitiesDB.back.bind();
		quad.render();
		velocitiesDB.back.unbind();
	}
	
	public function render() : Void
	{
		// Work out where to position the particles
		mvMatrix.reset();
		mvMatrix.translate(x, y, 0);
		
		// Update shader params
		renderShader.use();				
		renderShader.perspectiveMatrix.setMatrix(perspective.toFloat32Array());
		renderShader.vertexPosition.setBuffer(cloud.vertexBuffer);
		renderShader.viewMatrix.setMatrix(mvMatrix.toFloat32Array());		
		renderShader.positionsTexture.setTexture(positionsDB.back);
		renderShader.velocitiesTexture.setTexture(velocitiesDB.back);
		renderShader.pointSize.setFloat(particleSize);	
		
		var parts : RGB = ColorConverter.toRGB(startColor);		
		renderShader.startColor.set4Floats(parts.r, parts.g, parts.b, .8);	
		
		var parts : RGB = ColorConverter.toRGB(endColor);	
		renderShader.endColor.set4Floats(parts.r, parts.g, parts.b, .8);	
	

		// Render all the points		
		cloud.render();		
		
		// Swap our double buffers
		positionsDB.swap();
		velocitiesDB.swap();
	}
	
}