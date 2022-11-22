using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwordHit : MonoBehaviour
{
    [SerializeField] private int weaponDamageLight = 5;
    [SerializeField] private int weaponDamageHeavy = 10;
    [SerializeField] private AudioSource swordHitOnEnemy; 

    void Start()
    {
        
    }

    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other) {
        if(other.tag == "Enemy" && PlayerAttack.isLightAttacking) {
            other.GetComponent<AI>().recieveDamage(weaponDamageLight);
            swordHitOnEnemy.Play(); 
        }
        else if(other.tag == "Enemy" && PlayerAttack.isHeavyAttacking) {
            other.GetComponent<AI>().recieveDamage(weaponDamageHeavy);
            swordHitOnEnemy.Play(); 
        }
    }
}
