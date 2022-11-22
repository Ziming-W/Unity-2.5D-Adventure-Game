using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseMenu : MonoBehaviour
{
    public static bool GameIsPaused = false;
    public GameObject pauseMenuUI;
    

    // Update is called once per frame
    void Update(){
    if (Input.GetKeyDown(KeyCode.Escape))
    {
        if(GameIsPaused)
        {
            Resume();
        }else
        {
            Pause();
        }
    }
}

    public void Resume()
    {
        pauseMenuUI.SetActive(false);
        Time.timeScale = 1f;
        GameIsPaused = false;


    }
    void Pause()
    {
        pauseMenuUI.SetActive(true);
        Time.timeScale = 0f;
        GameIsPaused = true;
    }

    public void LoadSettings()
    {
        SceneManager.LoadScene("Settings");
        Time.timeScale = 1f;

    }

     public void LoadMainMenu()
    {
        SceneManager.LoadScene("MainMenu");
        Time.timeScale = 1f;

    }

    public void QuitGame()
    {
        
        Debug.Log("QUIT...");
        Application.Quit();

    }
}
