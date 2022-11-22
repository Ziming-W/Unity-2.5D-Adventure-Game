using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneSkip : MonoBehaviour
{

    void Update()
    {
        InputSystem();
        
    }

    void InputSystem(){
        if(Input.GetKey(KeyCode.Y)){
             SceneManager.LoadScene("MainMenu");
        }

    }

}
