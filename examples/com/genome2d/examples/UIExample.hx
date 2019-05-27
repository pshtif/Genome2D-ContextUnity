/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2019 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

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
											<fontSkin id="fontSkin" font="@assets/font.fnt" color="0xFFFFFF" autoSize="true"/>
										</skinSheet>';

		elementPrototype = '<element name="A1" anchorLeft="0" anchorRight="1" anchorTop="0" anchorBottom="1">
										<element name="A2" skin="@textureSkin" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="100" preferredWidth="200">
											<element skin="@fontSkin" model="TITLE" anchorAlign="MIDDLE_CENTER" pivotAlign="MIDDLE_CENTER"/>
										</element>
										<element useMask="true" name="B2" skin="@textureSkin" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="180" preferredWidth="512" preferredHeight="150">
											<element name="A3" skin="@fontSkin" model="LAYOUT" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
											<element name="B3" anchorY="90" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER">
												<p:layout><horizontal gap="5"/></p:layout>
												<element name="A4" skin="@textureSkin" color="0xFFBBBB" preferredWidth="140">
													<element name="A5" skin="@fontSkin" model="BUTTONDLHYJAKSVINA" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>
												<element name="B4" skin="@textureSkin" color="0xBBFFBB" preferredWidth="140">
													<element name="B5" skin="@fontSkin" model="BUTTON" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>
												<element name="C4" skin="@textureSkin" preferredWidth="140" color.default-mouseOut="0xFF0000" color.mouseOver="0xFFFFFF">
													<element name="C5" skin="@fontSkin" model="BUTTON" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>
												<element name="C4" skin="@textureSkin" preferredWidth="140" color.default-mouseOut="0xFF0000" color.mouseOver="0xFFFFFF">
													<element name="C5" skin="@fontSkin" model="BUTTON" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>
												<element name="C4" skin="@textureSkin" preferredWidth="140" color.default-mouseOut="0xFF0000" color.mouseOver="0xFFFFFF">
													<element name="C5" skin="@fontSkin" model="BUTTON" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>
											</element>
										</element>
										<element name="C2" skin="@textureSkin" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="360" preferredWidth="300">
											<element name="C3" skin="@fontSkin" model="SETTINGS" anchorAlign="MIDDLE_CENTER" pivotAlign="MIDDLE_CENTER"/>
										</element>
									</element>';

		GXmlPrototypeParser.createPrototypeFromXmlString(skinPrototype);

		gui = GNode.createWithComponent(GUI);
		gui.node.mouseEnabled = true;
		gui.setBounds(new GRectangle(0,0,600,600));
		container.addChild(gui.node);

		var textureElement:GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(elementPrototype);
		gui.root.addChild(textureElement);

		var camera1:GCameraController = GNode.createWithComponent(GCameraController);
		camera1.node.setPosition(400,300);
		//camera1.zoom = .8;
		//camera1.node.setPosition(getGenome().getContext().getStageViewRect().width/2, getGenome().getContext().getStageViewRect().height/2);
		camera1.setView(0, 0, .5, .5);
		//camera1.contextCamera.group = 3;
		getGenome().root.addChild(camera1.node);

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
