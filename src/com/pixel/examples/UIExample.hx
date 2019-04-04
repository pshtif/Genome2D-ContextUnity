/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.pixel.examples;

import com.genome2d.input.GKeyboardInputType;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.debug.GDebug;
import com.genome2d.context.stats.GStats;
import com.genome2d.textures.GTextureManager;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.geom.GRectangle;
import com.genome2d.input.GMouseInput;
import com.genome2d.node.GNode;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.skin.GUISkin;
import com.genome2d.ui.skin.GUISkinManager;
import com.genome2d.Genome2D;

@:nativeGen
class UIExample extends AbstractExample
{
	private	var skinPrototype:String;

	private var elementPrototype:String;

	private var customCamera:GCameraController;
	private var gui:GUI;

	/**
			Initialize Example code
		**/
	override public function initExample():Void {
		GStats.visible = true;

		title = "UI EXAMPLE";
		detail = "Example showcasing UI elements, layouts and skinning.\n";

		skinPrototype = '<skinSheet>
											<textureSkin id="textureSkin" texture="@assets/button.png" sliceLeft="10" sliceTop="10" sliceRight="35" sliceBottom="35"/>
											<fontSkin id="fontSkin" font="@assets/font.fnt" color="0x0" autoSize="true"/>
										</skinSheet>';

		elementPrototype = '<element name="A1" anchorLeft="0" anchorRight="1" anchorTop="0" anchorBottom="1">
										<element name="A2" skin="@textureSkin" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="100" preferredWidth="200">
											<element skin="@fontSkin" model="TITLE" anchorAlign="MIDDLE_CENTER" pivotAlign="MIDDLE_CENTER"/>
										</element>
									</element>';

		GXmlPrototypeParser.createPrototypeFromXmlString(skinPrototype);

		gui = GNode.createWithComponent(GUI);
		gui.node.mouseEnabled = true;
		gui.setBounds(new GRectangle(0,0,800,600));
		container.addChild(gui.node);

		var textureElement:GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(elementPrototype);
		gui.root.addChild(textureElement);

		Genome2D.getInstance().onKeyboardInput.add(keyboardInput_handler);
	}

	private function keyboardInput_handler(p_input:GKeyboardInput):Void {
		if (p_input.type == GKeyboardInputType.KEY_DOWN) {
			switch (p_input.keyCode) {
				case 219:
					GDebug.debugDrawCall--;
					if (GDebug.debugDrawCall < 0) GDebug.debugDrawCall = 0;
				case 221:
					GDebug.debugDrawCall++;
			}
		}
	}

	private function mouseClick_handler(p_input:GMouseInput):Void {
	}
	
	override public function dispose():Void {
		super.dispose();
		
		cast (GUISkinManager.getSkin("textureSkin"),GUISkin).dispose();
		cast (GUISkinManager.getSkin("fontSkin"),GUISkin).dispose();
	}
}
