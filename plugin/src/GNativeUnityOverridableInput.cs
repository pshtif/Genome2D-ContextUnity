using UnityEngine.EventSystems;

namespace Genome2DNativePlugin
{
    public class GNativeUnityOverridableInput
    {
        private static StandaloneInputModule _inputModule;

        public static BaseInput BaseInput
        {
            get {
                _inputModule ??= EventSystem.current.GetComponent<StandaloneInputModule>();

                return _inputModule.input;
            }
        }
    }
}