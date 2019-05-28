package com.genome2d.examples;
import com.genome2d.debug.GDebug;
import com.genome2d.context.renderers.G3DRenderer;
import com.genome2d.context.stats.GStats;
import com.genome2d.examples.AbstractExample;
import com.genome2d.g3d.G3DFactory;
import com.genome2d.g3d.G3DScene;
import com.genome2d.geom.GFloat4;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.geom.GVector3D;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import com.genome2d.g3d.importers.G3DImporter;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.assets.GBinaryAsset;

/**
 * @author Peter @sHTiF Stefcek
 */
@:nativeGen
class G3DExample extends AbstractExample
{
	private var scene:G3DScene;
	private var cameraMatrix:GMatrix3D;

	private var renderTexture:GTexture;
	
    /**
        Initialize Example code
     **/
  override public function initExample():Void {
		title = "G3D EXAMPLE";
		detail = "Example showcasing 3D rendering capabilities inside Genome2D using custom overridable and extendable renderer.";

		//scene = G3DFactory.createPlane(100, 100, GTextureManager.getTexture("assets/texture.png"));
		scene = G3DFactory.createBox(100, 100, 100, GTextureManager.getTexture("assets/texture.png"));
		var importer:G3DImporter = new G3DImporter(true);
		var asset:GBinaryAsset = GStaticAssetManager.getBinaryAssetById("assets/fisherman01.bytes");
		GDebug.info(asset.data.length);
		scene = importer.importScene(asset.data);
		scene.invalidate();
		
		cameraMatrix = new GMatrix3D();
		cameraMatrix.appendRotation(120, GVector3D.X_AXIS);
		cameraMatrix.appendTranslation(400, 300, 0);

		getGenome().onPostRender.add(postRender_handler);
	}

	private var rotation:Float = 0;
	
	private function postRender_handler():Void {
		rotation++;
		
		scene.getSceneMatrix().identity();
		scene.getSceneMatrix().appendRotation(rotation, GVector3D.Z_AXIS);
		scene.tintColor = new GFloat4(1,1,1,.01);
		
		scene.render(cameraMatrix, 0);
	}
	
	override public function dispose():Void {
		super.dispose();
		
		getGenome().onPostRender.remove(postRender_handler);
		
		scene.dispose();
	}
}