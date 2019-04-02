namespace Genome2DNativePlugin
{
    public static class NativeArrayExtensions
    {
        public static unsafe void CopyToFast<T>(
            this NativeArray<T> nativeArray,
            T[] array)
            where T : struct
        {
            if (array == null)
            {
                throw new NullReferenceException(nameof(array) + " is null");
            }

            int nativeArrayLength = nativeArray.Length;
            if (array.Length < nativeArrayLength)
            {
                throw new IndexOutOfRangeException(
                    nameof(array) + " is shorter than " + nameof(nativeArray));
            }

            int byteLength = nativeArray.Length * Marshal.SizeOf(default(T));
            void* managedBuffer = UnsafeUtility.AddressOf(ref array[0]);
            void* nativeBuffer = nativeArray.GetUnsafePtr();
            Buffer.MemoryCopy(nativeBuffer, managedBuffer, byteLength, byteLength);
        }
    }
}