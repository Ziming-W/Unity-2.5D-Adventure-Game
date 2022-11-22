/*Original Author : https://www.youtube.com/watch?v=I2r97r9h074*/
/*Modified by Ziming Wang*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class FPSCounter : MonoBehaviour
{
    private int lastFrameIndex;
    private float[] frameDeltaTimeArray;

    public Text FPSCounter_text; 

    void Start()
    {
        
    }
    private void Awake() {
        frameDeltaTimeArray = new float[50];
    }

    private float CalculateFPS() {
        float total = 0.0f; 
        foreach(float deltaTime in frameDeltaTimeArray) {
            total += deltaTime; 
        }
        return frameDeltaTimeArray.Length / total; 
    }

    void Update()
    {
        frameDeltaTimeArray[lastFrameIndex] = Time.deltaTime;
        lastFrameIndex = (lastFrameIndex + 1) % frameDeltaTimeArray.Length;
        FPSCounter_text.text = "FPS: " + Mathf.RoundToInt(CalculateFPS()).ToString(); 
    }


}
