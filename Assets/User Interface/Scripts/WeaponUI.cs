using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WeaponUI : MonoBehaviour
{

    [SerializeField]private GameObject bowPic;
    [SerializeField]private GameObject swordPic;



    public void WeaponCheck() {
       
        if  (PlayerAttack.weaponHold == 1){
          
            
            bowPic.SetActive(false);
            swordPic.SetActive(true);
        }
        else if (PlayerAttack.weaponHold == 2) {
           
          
            bowPic.SetActive(true);
            swordPic.SetActive(false);
        }

    }
    
     void Update()
    {
       
        WeaponCheck();


    }
        
}

