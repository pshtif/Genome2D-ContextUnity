using UnityEngine;

namespace Genome2DNativePlugin
{
    public interface IGNativeUnityFilter
    {
        Material getMaterial();
        void bind();
    }
}