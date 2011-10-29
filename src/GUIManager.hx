package ;
import js.JQuery;

/**
 * ...
 * @author MikeC
 */

class GUIManager 
{
	private var main : Main;
	
	public function new(main:Main) 
	{
		this.main = main;		
		updateGUIElements();
		new JQuery("#updateBtn").click(onUpdateButtonClicked);	
	}
	
	private function updateGUIElements() : Void
	{		
		new JQuery("#numParticlesInp").val(main.gpuParticles2.particlesManger.particleCount+"");
		new JQuery("#particleSizeInp").val(main.gpuParticles2.particlesManger.particleSize + "").change(onPartcleSizeChange);
		new JQuery("#wallFrictionInp").val(main.gpuParticles2.particlesManger.wallFriction + "").change(onFrictionChange);
		new JQuery("#gravityStrength").val(main.gpuParticles2.particlesManger.gravityStrength+"").change(onGravityChange);	
		new JQuery("#startColor").val(StringTools.hex(main.gpuParticles2.particlesManger.startColor)).change(onStartColorChange);	
		new JQuery("#endColor").val(StringTools.hex(main.gpuParticles2.particlesManger.endColor)).change(onEndColorChange);	
	}
	
	private function onEndColorChange(e):Void 
	{
		main.gpuParticles2.particlesManger.endColor = Std.parseInt("0x"+new JQuery("#endColor").val());
	}
	
	private function onStartColorChange(e):Void 
	{
		main.gpuParticles2.particlesManger.startColor = Std.parseInt("0x"+new JQuery("#startColor").val());
	}
	
	private function onGravityChange(e):Void 
	{
		main.gpuParticles2.particlesManger.gravityStrength = Std.parseFloat(new JQuery("#gravityStrength").val());
	}
	
	private function onFrictionChange(e):Void 
	{
		main.gpuParticles2.particlesManger.wallFriction = Std.parseFloat(new JQuery("#wallFrictionInp").val());
	}
	
	private function onPartcleSizeChange(e):Void 
	{
		main.gpuParticles2.particlesManger.particleSize = Std.parseInt(new JQuery("#particleSizeInp").val());
	}
	
	private function onUpdateButtonClicked(e:JqEvent):Void 
	{
		main.gpuParticles2.particlesManger.particleCount = Std.parseInt(new JQuery("#numParticlesInp").val());
		main.gpuParticles2.particlesManger.particleSize = Std.parseInt(new JQuery("#particleSizeInp").val());
		main.gpuParticles2.particlesManger.wallFriction = Std.parseFloat(new JQuery("#wallFrictionInp").val());
		main.gpuParticles2.particlesManger.gravityStrength = Std.parseFloat(new JQuery("#gravityStrength").val());
		main.gpuParticles2.particlesManger.startColor = Std.parseInt("0x"+new JQuery("#startColor").val());
		main.gpuParticles2.particlesManger.endColor = Std.parseInt("0x"+new JQuery("#endColor").val());
		main.gpuParticles2.particlesManger.reset();
	}
	
	
	
}