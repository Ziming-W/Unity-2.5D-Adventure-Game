using System; 
using System.Collections;
using System.Collections.Generic;
using UnityEngine; 
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Equipment : MonoBehaviour
{
    public static int numCoin;
    public Text numCoin_text;

    public float initialPlayerHealth = 100.0f; 
    public static float playerHealth;
    public Slider healthBar;
    public static bool playerDead;

    public static int arrowRemain;
    [SerializeField] private Text arrowRemain_text;
    [SerializeField] private int initialArrowNum = 10;

    public static bool trigerInvincible; 
    public static bool isInvincible;
    public static float invincibleTimer; 
    [SerializeField] private Text invincibleDuring_text; 

    void Start()
    {
        numCoin = 0;
        playerDead = false;
        playerHealth = initialPlayerHealth;
        arrowRemain = initialArrowNum;
        trigerInvincible = false;
        isInvincible = false;
    }

    // Update is called once per frame
    void Update()
    {
        //display coin
        numCoin_text.text = "Savings: " + numCoin;

        //player health 
        healthBar.value = playerHealth; 
        if(playerHealth < 0.0f) {
            playerDead = true; 
        }
        if(playerDead) {
            Die(); 
        }

        //display number of arrow remaining
        arrowRemain_text.text = "Arrow: " + arrowRemain; 

        if(playerHealth > initialPlayerHealth) {
            playerHealth = initialPlayerHealth; 
        }

        //triger invincible
        if (trigerInvincible) {
            //initial timer
            isInvincible = true; 
            trigerInvincible = false; 
        }
        if (isInvincible) {
            invincibleDuring_text.text = "Invincible: " + Math.Round(invincibleTimer, 3); 
            invincibleTimer -= Time.deltaTime; 
            if(invincibleTimer <= 0.0f) {
                isInvincible = false; 
            }
        }
        if (!isInvincible) {
            invincibleDuring_text.text = ""; 
        }
    }

    private void Die() {
        StartFinish P = new StartFinish();
        P.gameOver();
    }

}
