using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartFinish : MonoBehaviour
{
    public Text pointText;

  

   


    public void RestartButton()
    {
        SceneManager.LoadScene("level1");
    }

    
    public void ExitButton()
    {
        Application.Quit();
        Debug.Log("Quit!");

    }


    public void gameOver()
    {

        SceneManager.LoadScene("EndUI");
    }

    public void MenuButton()
    {
        SceneManager.LoadScene("Settings");
    }    

    public void MainMenuButton()
    {
        SceneManager.LoadScene("MainMenu");
    }    

}
