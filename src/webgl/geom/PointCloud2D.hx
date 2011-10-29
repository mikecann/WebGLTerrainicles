package webgl.geom;

import Html5Dom;

/**
 * ...
 * @author 
 */

class PointCloud2D
{
	// Publics
	public var vertexBuffer : WebGLBuffer;
	
	// Privates
	private var gl : WebGLRenderingContext;
	
	public function new(gl:WebGLRenderingContext)
	{
		this.gl = gl;
	}
	
	public function initFromData(points:Float32Array) : Void
	{
		// Create the vertex buffer
        vertexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, points, gl.STATIC_DRAW);
        vertexBuffer.itemSize = 2;
        vertexBuffer.numItems = Std.int(points.length/2);
	}
	
	public function render() : Void
	{		        
		gl.drawArrays(gl.POINTS, 0, vertexBuffer.numItems);
	}
	
}