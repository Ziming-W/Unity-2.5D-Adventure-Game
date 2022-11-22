using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttack : MonoBehaviour

{
    //weapons
    private Rigidbody player;
    [SerializeField]private Animator animator;
    [SerializeField]private GameObject sword;
    [SerializeField]private GameObject bow;
    [SerializeField]private GameObject arrow;
    //arrow argument
    [SerializeField]private Transform arrowStartPoint;
    [SerializeField] private float arrowSpeed = 800; 

    //attack control variable
    private const float SWORD_ATTACK_CD_LIGHT = 0.7f; 
    private const float SWORD_ATTACK_CD_HEAVY = 1.2f;
    private const float BOW_ATTACK_CD = 1.0f; 
    private float lastAttackClickTime;
    private bool canLightAttack;
    private bool canHeavyAttack;
    private bool canBowAttack; 
    public static bool isLightAttacking;
    public static bool isHeavyAttacking;
    public static int weaponHold;
    private const int NO_WEAPON = 0;
    private const int SWORD = 1;
    private const int BOW = 2;

    //audio
    [SerializeField] AudioSource swordLightAttackSound;
    [SerializeField] AudioSource swordHeavyAttackSound;
    [SerializeField] AudioSource arrowReleaseSound; 
    

    private void Start() {
        player = GetComponent<Rigidbody>();
        lastAttackClickTime = 0.0f;
        canLightAttack = false;
        canHeavyAttack = false;
        isLightAttacking = false;
        isHeavyAttacking = false;
        bow.SetActive(false);
        sword.SetActive(true);
        weaponHold = SWORD; 
    }

    private void Update() {
        //switch weapon
        WeaponSwitchCheck(); 

        //sword attack
        canLightAttack = (lastAttackClickTime == 0.0f || (Time.time - lastAttackClickTime) > SWORD_ATTACK_CD_LIGHT)?true:false;
        canHeavyAttack = (lastAttackClickTime == 0.0f || (Time.time - lastAttackClickTime) > SWORD_ATTACK_CD_HEAVY) ? true : false;
        canBowAttack = (lastAttackClickTime == 0.0f || (Time.time - lastAttackClickTime) > BOW_ATTACK_CD) ? true : false;
        if (Input.GetMouseButtonDown(0) && canLightAttack &&weaponHold==SWORD) {
            SwordAttackLight();
        }
        if(Input.GetMouseButtonDown(1) && canHeavyAttack && weaponHold == SWORD) {
            SwordAttackHeavy(); 
        }
        if(Input.GetMouseButtonDown(0) &&canBowAttack && weaponHold == BOW && Equipment.arrowRemain>0) {
            ShootArrowAnimation();
            Equipment.arrowRemain -= 1; 
        }
        //check if is attacking by referring to the current animation
        //if (animator.GetCurrentAnimatorStateInfo(0).IsName("SwordAttackLight")) {
        //    isLightAttacking = true;
        //} else {
        //    isLightAttacking = false; 
        //}
        isLightAttacking = animator.GetCurrentAnimatorStateInfo(0).IsName("SwordAttackLight") ? true : false; 
        //if (animator.GetCurrentAnimatorStateInfo(0).IsName("SwordAttackHeavy")) {
        //    isHeavyAttacking = true;
        //} else {
        //    isHeavyAttacking = false; 
        //}
        isHeavyAttacking = animator.GetCurrentAnimatorStateInfo(0).IsName("SwordAttackHeavy") ? true : false; 

    }

    private void SwordAttackLight() {
        animator.SetTrigger("PlayerSwordAttackLight");
        lastAttackClickTime = Time.time;
        swordLightAttackSound.PlayDelayed(0.08f); 
    }

    private void SwordAttackHeavy() {
        animator.SetTrigger("PlayerSwordAttackHeavy");
        lastAttackClickTime = Time.time;
        swordHeavyAttackSound.PlayDelayed(0.25f); 
    }

    private void ShootArrowAnimation() {
        animator.SetTrigger("PlayerShootArrow");
        lastAttackClickTime = Time.time;
        arrowReleaseSound.PlayDelayed(0.7f); 
    }

    private void ShootGenerateArrow() {
        GameObject arrowShot = Instantiate(arrow, arrowStartPoint.position, Quaternion.AngleAxis(90.0f, new Vector3(0, 0, 1)));
        arrowShot.GetComponent<Rigidbody>().AddForce(arrowStartPoint.forward * 600);
        arrowShot.transform.GetChild(0).GetComponent<MeshRenderer>().enabled = true;
    }


    private void WeaponSwitchCheck() {
        //switch to sword
        if (Input.GetKeyDown(KeyCode.Alpha1) && weaponHold != SWORD && !animator.GetCurrentAnimatorStateInfo(0).IsName("SwitchWeapon")) {
            animator.SetTrigger("WeaponSwitch");
            weaponHold = SWORD;
            bow.SetActive(false);
            sword.SetActive(true);
        }
        else if(Input.GetKeyDown(KeyCode.Alpha2) && weaponHold != BOW && !animator.GetCurrentAnimatorStateInfo(0).IsName("SwitchWeapon")) {
            animator.SetTrigger("WeaponSwitch");
            weaponHold = BOW;
            bow.SetActive(true);
            sword.SetActive(false);
        }

    }

}
