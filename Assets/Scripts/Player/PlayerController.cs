using System.Collections; 
using System.Collections.Generic; 
using UnityEngine;

public class PlayerController : MonoBehaviour {
    //player
    private Rigidbody player;
    public Animator animator;
    public Transform playerModel;
    private Vector3 direction;


    //horizontal movement
    public float speed = 2;
    private float hInput;

    //jump
    public int jumpScale = 5;
    private bool jumpKeyWasPressed;
    private bool isGrounded;
    private bool doubleJumpAllow;
    [SerializeField]private Transform playerBottom;
    [SerializeField]private LayerMask groundLayer;

    //roll forward
    private const float ROLL_CD = 0.7f;
    private bool canRoll;
    private float lastRollTime; 

    //minumum Y axix
    [SerializeField] private float DIE_IF_Y_LOWER_THAN = -10.0f; 

    [SerializeField]private Material hurtCameraTexture;
    [SerializeField]private Material normalCameraTexture;

    //receive damage animation constant
    private const float DMG_ANIM_CD = 2.0f; //the cd between two damage ANIMATION!!
    private float lastDamageAnimationPlayTime = 0.0f;
    private float damagedFrame;
    private float damagedFrameCount;

    private bool isBeingDamaged;

    void Start() {
        player = GetComponent<Rigidbody>();
        isBeingDamaged = false;
        damagedFrame = 0.1f;
        damagedFrameCount = 0;
        canRoll = false;
        lastRollTime = 0.0f; 
        PlayerHurtScirpt cameraScript = this.gameObject.transform.Find("Main Camera").GetComponent<PlayerHurtScirpt>();
        cameraScript.mat = normalCameraTexture;
    }

    void Update() {
        /*********************  move left right, jump   *********************/
        //jump
        if (Input.GetKeyDown(KeyCode.Space)) {
            jumpKeyWasPressed = true;
        }
        if (Physics.CheckSphere(playerBottom.position, 0.03f, groundLayer)) {
            isGrounded = true;
            doubleJumpAllow = true;
        }

        //roll forward
        canRoll = (lastRollTime == 0.0f || (Time.time - lastRollTime) > ROLL_CD) ? true : false;
        if (Input.GetKeyDown(KeyCode.C) && canRoll) {
            animator.SetTrigger("PlayerRollForward");
            lastRollTime = Time.time; 
        }

        //move left and right
        hInput = Input.GetAxis("Horizontal");

        //player face left or right
        if (hInput != 0) {
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(hInput, 0, 0));
            playerModel.rotation = newRotation;
        }

        //Y can't drop  to -10.0f
        if(player.transform.position.y < DIE_IF_Y_LOWER_THAN) {
            Equipment.playerDead = true; 
        }

        //activate shield
        if (Equipment.isInvincible) {
            GameObject.Find("Shield").GetComponent<MeshRenderer>().enabled = true;
        } else {
            GameObject.Find("Shield").GetComponent<MeshRenderer>().enabled = false;
        }

        //animator
        animator.SetFloat("PlayerSpeed", Mathf.Abs(hInput));
        animator.SetBool("PlayerIsGrounded", isGrounded);

        /*********************  death   *********************/
        if (Equipment.playerDead) {
            animator.SetTrigger("PlayerDie");
            animator.SetBool("PlayerIsDead", true); 
            this.enabled = false;
        }

        //check if player is being damaged
        //bottom.GetComponent<SkinnedMeshRenderer>().material = normal;
        //this.gameObject.transform.GetChild(0).material = normal
        if(isBeingDamaged){
            if(damagedFrameCount >= damagedFrame){
                isBeingDamaged = false;
                PlayerHurtScirpt cameraScript = this.gameObject.transform.Find("Main Camera").GetComponent<PlayerHurtScirpt>();
                cameraScript.mat = normalCameraTexture;
                damagedFrameCount = -1;
            }
            damagedFrameCount+= Time.deltaTime;
        }

    }
    private void FixedUpdate() {
        //jump
        if (jumpKeyWasPressed && isGrounded) {
            Jump();
        }
        if (jumpKeyWasPressed && doubleJumpAllow) {
            DoubleJump();
        }

        //move left and right
        player.velocity = new Vector3(hInput * speed, player.velocity.y, player.velocity.z);
    }

    private void Jump() {
        player.AddForce(Vector3.up * jumpScale, ForceMode.VelocityChange);
        jumpKeyWasPressed = false;
        isGrounded = false;
    }

    private void DoubleJump() {
        player.AddForce(Vector3.up * jumpScale, ForceMode.VelocityChange);
        doubleJumpAllow = false;
    }

    public void getDamage(float damage) {
        if (!Equipment.isInvincible) {
            Equipment.playerHealth -= damage;
            //decide to play animation or not
            if (lastDamageAnimationPlayTime == 0.0f || (Time.time - lastDamageAnimationPlayTime) > DMG_ANIM_CD) {
                animator.SetTrigger("PlayerReceiveDamage");
                lastDamageAnimationPlayTime = Time.time;
                PlayerHurtScirpt cameraScript = this.gameObject.transform.Find("Main Camera").GetComponent<PlayerHurtScirpt>();
                cameraScript.mat = hurtCameraTexture;
                isBeingDamaged = true;
            }
        }

    }
    
}