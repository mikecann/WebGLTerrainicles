package ;

import Html5Dom;
import js.Lib;
import js.Dom;

/**
 * ...
 * @author 
 */

class CanvasManager 
{
	public var canvas : HTMLCanvasElement;
	
	public var translateX:Float;
	public var translateY:Float;
	
	private var isMouseDown : Bool;
	private var lastMouseX:Float;
	private var lastMouseY:Float;
	private var system : GPUParticles2;
	private var gl : WebGLRenderingContext;

	
	public function new(system:GPUParticles2) 
	{
		this.system = system;		
		this.gl = system.gl;		
		
		translateX = -Lib.window.innerWidth / 2;
		translateY = -Lib.window.innerHeight / 2;
		
		canvas = cast Lib.document.getElementById("canvas");
		canvas.width = Lib.window.innerWidth;
		canvas.height = Lib.window.innerHeight;
		trace("Canvas -> "+canvas.width + ", " + canvas.height);		
	  
		Lib.window.onresize = onResize;
		canvas.onmousedown = onCanvasMouseDown;	
		canvas.onmouseup = onCanvasMouseUp;				
		canvas.onmousemove = onCanvasMouseMove;			
	}	
	
	private function onResize(e):Void 
	{
		canvas.width = Lib.window.innerWidth;
		canvas.height = Lib.window.innerHeight;
		trace("Canvas -> "+canvas.width + ", " + canvas.height);
	}
	
	private function onCanvasMouseDown(ev) : Void
	{		
		isMouseDown = true;
		lastMouseX = ev.clientX;  
		lastMouseY = ev.clientY;
		
		var wx : Int = Std.int(ev.clientX-translateX-Lib.window.innerWidth/2);
		var wy : Int = Std.int(ev.clientY - translateY - Lib.window.innerHeight / 2);
		if (ev.ctrlKey)
		{			
			system.particlesManger.spawner.spawnParticles(wx, wy, 5000);
			system.map.writeExplosion(wx,wy);
		}
	}
	
	private function onCanvasMouseUp(ev) : Void
	{
		isMouseDown  = false;
	}
	
	private function onCanvasMouseMove(ev) : Void
	{		
		if ( !isMouseDown ) return;	
		
		var wx : Int = Std.int(ev.clientX-translateX-Lib.window.innerWidth/2);
		var wy : Int = Std.int(ev.clientY-translateY-Lib.window.innerHeight/2);
	
		if (ev.shiftKey)
		{			
			system.particlesManger.spawner.spawnParticles(wx, wy, 200);
			system.map.writeExplosion(wx,wy);
		}
		else if (!ev.shiftKey && !ev.ctrlKey)
		{
			translateX += ev.clientX - lastMouseX;
			translateY += ev.clientY - lastMouseY;
			lastMouseX = ev.clientX;
			lastMouseY = ev.clientY;	
		}		
		
		//system.mvMatrix.reset();
		//system.mvMatrix.translate(translateX, translateY, 0);				
		
		// Rotate
		/*if ( ev.shiftKey ) {
		transl *= 1 + (ev.clientY - yOffs)/300;
		yRot = - xOffs + ev.clientX; }
		else {
		yRot = - xOffs + ev.clientX;  xRot = - yOffs + ev.clientY; }
		xOffs = ev.clientX;   yOffs = ev.clientY;*/
	}
	
}