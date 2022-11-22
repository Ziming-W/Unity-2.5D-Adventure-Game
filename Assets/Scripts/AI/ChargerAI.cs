using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ChargerAI : AI
{

    float left;
    float right;
    [SerializeField] GameObject tile;
    // [SerializeField] GameObject marker;
    [SerializeField] private Material invisible;


    private bool toLeft = true;

    private bool prepareAttacking;
    private bool attacking;
    private bool endAttacking;
    private float timebetweenAttacks;

    private float chargingWaitTime;
    private float chargeSpeed;
    private Vector3 chargingAt;
    private Vector3 jumpingAt;

    private float frameCount;
    private float attackFrameCount;

    private bool isInvisible;
    private float invisibleFrame;
    private float invisibleFrameCount;

    private float timeCounter = 0;

    private float prepareJumpCounter = 0;
    private float jumpFinishTim = 1.5f;
    private float jumpPrepareTime = 2;

    private bool isChargeAttack;

    private bool isJumpAttack;
    private bool isCharged = false;
    private bool isJumped = false;

    private float jumpCurveX = 0;
    private float jumpCurveXDest = 0;
    private float jumpCurveY = 0;
    private double jumpCurveScale = 0;

    [SerializeField] private int JUMP_LIMIT = 4;

    private float yCoord;


    private Vector3 normalHitboxSize;
    private Vector3 normalHitboxCenter;
    private Vector3 chargeHitboxSize;
    private Vector3 chargeHitboxCenter;


    private Vector3 chargeLHitboxSize;
    private Vector3 chargeLHitboxCenter;

    private Vector3 chargeRHitboxSize;
    private Vector3 chargeRHitboxCenter;

    private float yLevel;
    private Vector3 startingPos;
    private bool isAttackMethodSet = false;

    public ChargerAI() : base()
    {
        currHp = HP_LIMIT;
    }
    void Start()
    {
        currHp = HP_LIMIT;
        frameCount = 0;
        left = tile.GetComponent<Collider>().bounds.min.x;
        right = tile.GetComponent<Collider>().bounds.max.x;
        player = GameObject.Find(playerName).transform;
        timebetweenAttacks = 10.0f;
        attackFrameCount = 0;
        chargingWaitTime = 3.0f;
        chargeSpeed = 0.2f;
        hurtTimeFrame = 20;
        hurtFrameCount = 0;
        normal = bottom.GetComponent<SkinnedMeshRenderer>().material;
        invisibleFrameCount = 0;
        invisibleFrame = 3f;
        jumpFinishTim = 3.0f;
        isInvisible = false;
        isChargeAttack = false;
        isJumpAttack = false;
        
        yCoord = tile.GetComponent<Collider>().bounds.max.y;
        animator.ResetTrigger("startWalking");
        normalHitboxSize = GetComponent<BoxCollider>().size;
        normalHitboxCenter = GetComponent<BoxCollider>().center;

        chargeLHitboxSize = new Vector3(1.300714f, 1.081355f, 2.078846f);
        chargeLHitboxCenter = new Vector3(-0.2284f, -0.65f, 0.53432f);

        chargeRHitboxSize = new Vector3(1.996742f, 1.213f, 2.078846f);
        chargeRHitboxCenter = new Vector3(0.4499f, -0.5835f, 0.53432f);
        yLevel = transform.position.y;

        startingPos = transform.position;

    }

    private void Update()
    {
        float minx = tile.GetComponent<Collider>().bounds.min.x;
        float maxx = tile.GetComponent<Collider>().bounds.max.x;

        if (!isInvisible)
        {
            int randomNum = UnityEngine.Random.Range(0, 100000);
            if (randomNum < 100)
            {
                isInvisible = true;
                bottom.GetComponent<SkinnedMeshRenderer>().material = invisible;
            }
        }
        else
        {
            if (invisibleFrameCount >= invisibleFrame)
            {
                invisibleFrameCount = -1;
                isInvisible = false;
                bottom.GetComponent<SkinnedMeshRenderer>().material = normal;
            }
            invisibleFrameCount += Time.deltaTime;
        }
        isDamaged();
        if ((player.transform.position.x > minx && player.transform.position.x < maxx))
        {
            if (frameCount >= timebetweenAttacks)
            {
                if (!isAttackMethodSet)
                {
                    Debug.Log("thinking for attack method");
                    thinkForAttackMethod();
                }
                if (isChargeAttack)
                {
                    if (prepareAttacking)
                    {
                        SearchChargePoint();
                        BoxCollider m_Collider = GetComponent<BoxCollider>();
                        m_Collider.size = chargeHitboxSize;
                        m_Collider.center = chargeHitboxCenter;

                        animator.SetTrigger("startCharging");
                        animator.ResetTrigger("startWalking");
                        prepareAttacking = false;
                        isCharged = false;
                    }

                    if (attackFrameCount >= chargingWaitTime && !isCharged)
                    {
                        //CapsuleCollider
                        BoxCollider m_Collider = GetComponent<BoxCollider>();
                        m_Collider.size = normalHitboxSize;
                        m_Collider.center = normalHitboxCenter;

                        animator.SetTrigger("startRunning");
                        animator.ResetTrigger("startCharging");
                        attackFrameCount += Time.deltaTime;
                        attacking = true;
                        isCharged = true;
                        //animator.SetBool("startCharging",false);
                    }
                    else
                    {
                        attackFrameCount += Time.deltaTime;
                    }

                    if (attacking)
                    {
                        chargeAt();
                    }

                    Vector3 distanceToWalkPoint = transform.position - chargingAt;
                    if (distanceToWalkPoint.magnitude < 1f)
                    {

                        attacking = false;
                        animator.SetTrigger("startWalking");
                        animator.ResetTrigger("startRunning");
                        // thinkForAttackMethod();
                        attackFinish();
                        isChargeAttack = false;
                         isAttackMethodSet = false;
                        //animator.SetBool("startRunning",false);
                        return;
                    }
                }
                if (isJumpAttack)
                {
                    if (prepareAttacking)
                    {
                        SearchJumpPoint();
                        attacking = true;
                        animator.SetTrigger("startJumping");
                        animator.ResetTrigger("startWalking");
                        prepareAttacking = false;
                    }

                    if (attacking)
                    {
                        jumpAt();
                    }


                    Vector3 distanceToWalkPoint = transform.position - jumpingAt;
                    if (distanceToWalkPoint.magnitude < 1f)
                    {
                        attacking = false;
                        transform.position = jumpingAt;
                        //animator.SetBool("startRunning",false);
                        animator.SetTrigger("finishJumping");
                        animator.ResetTrigger("startJumping");
                        timeCounter += Time.deltaTime;
                        if (timeCounter > jumpFinishTim)
                        {
                            timeCounter = 0;
                            prepareJumpCounter = 0;
                            animator.SetTrigger("startWalking");
                            animator.ResetTrigger("finishJumping");
                            transform.position = new Vector3(transform.position.x, yLevel, transform.position.z);
                            attackFinish();
                            isJumpAttack = false;
                            isAttackMethodSet = false;
                            return;
                        }
                    }
                }
            }
            else
            {
                Patroling();
                frameCount += Time.deltaTime;
            }
        }
        
        isAlive();
        timeBetweenDamagesCounter += Time.deltaTime;
        //Debug.Log(timeBetweenDamagesCounter);
    }

    public override void moveTo(Vector3 destination)
    {
        Vector3 dir = (destination - transform.position).normalized;

        transform.position += dir * speed;
    }

    private void jumpAt()
    {

        Vector3 dir = (jumpingAt - transform.position).normalized;
        transform.position += dir * 0.1f;
        //float dest = -0.25f* (transform.position.x-jumpCurveX)*(transform.position.x-jumpCurveXDest) + yCoord;
        //(float)((jumpCurveScale*Math.Pow((transform.position.x - jumpCurveX), 2)) + jumpCurveY);
        float dest = (float)(jumpCurveScale * (Math.Pow((transform.position.x - jumpCurveX), 2)) + JUMP_LIMIT);
        if (dest > jumpingAt.y)
        {
            transform.position = new Vector3(transform.position.x, dest, transform.position.z);
            // Instantiate(marker,transform.position,Quaternion.identity);
        }


    }

    public void attackFinish()
    {
        attacking = false;
        frameCount = -1;
        attackFrameCount = 0;
        timebetweenAttacks = UnityEngine.Random.Range(3.0f, 5.0f);
    }

    public void thinkForAttackMethod()
    {


        // timebetweenAttacks = UnityEngine.Random.Range(3.0f,5.0f);
        int randomNum = UnityEngine.Random.Range(1, 5);
        //  Vector3 distanceToPlayer = player.position.x - transform.position.x;
        float distanceToPlayer = (float)Math.Abs(player.position.x - transform.position.x);

        Debug.Log("distance: "+distanceToPlayer);
        if (distanceToPlayer < 6f)
        {
            isChargeAttack = true;
            isJumpAttack = false;
            prepareAttacking = true;
        }
        else
        {
            isJumpAttack = true;
            isChargeAttack = false;
            prepareAttacking = true;
        }
        isAttackMethodSet = true;
        /*
       if (randomNum <= 2)
       {
           isChargeAttack = true;
           isJumpAttack = false;
           prepareAttacking = true;

       }
       else
       {
           isJumpAttack = true;
           isChargeAttack = false;
           prepareAttacking = true;
       }*/
    }

    public void chargeAt()
    {
        Vector3 dir = (chargingAt - transform.position).normalized;

        transform.position += dir * chargeSpeed;
    }

    public override void Patroling()
    {
        /*
        if (!walkPointSet) SearchWalkPoint();
        if (walkPointSet)
        {
            moveTo(walkPoint);
        }
        Vector3 distanceToWalkPoint = transform.position - walkPoint;
        if (distanceToWalkPoint.magnitude < 1f)
        {
            //Debug.Log("arrived walkpoint: "+walkPoint);
            walkPointSet = false;
        }*/
        moveTo(new Vector3(player.position.x, transform.position.y, transform.position.z));
        if (transform.position.x > player.position.x)
        {
            
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(-999999, transform.position.y, transform.position.z));
            model.rotation = newRotation;
        }
        else
        {
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(999999, transform.position.y, transform.position.z));
            model.rotation = newRotation;
        }
    }

    private void SearchWalkPoint()
    {

        if (transform.position.x > player.position.x)
        {
            walkPoint = (new Vector3(player.position.x - 2, transform.position.y, transform.position.z));
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(-999999, transform.position.y, transform.position.z));
            model.rotation = newRotation;
        }
        else
        {
            walkPoint = (new Vector3(player.position.x + 2, transform.position.y, transform.position.z));
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(999999, transform.position.y, transform.position.z));
            model.rotation = newRotation;
        }

        walkPointSet = true;

    }



    private void SearchChargePoint()
    {

        if (transform.position.x >player.position.x)
        {
            chargingAt = new Vector3(left, transform.position.y, transform.position.z);
            chargeHitboxCenter = chargeLHitboxCenter;
            chargeHitboxSize = chargeLHitboxSize;
            // Quaternion newRotation = Quaternion.LookRotation(new Vector3(-999, transform.position.y, transform.position.z));
            //model.rotation = newRotation;
        }
        else
        {
            chargingAt = new Vector3(right, transform.position.y, transform.position.z);
            chargeHitboxCenter = chargeRHitboxCenter;
            chargeHitboxSize = chargeRHitboxSize;
            //Quaternion newRotation = Quaternion.LookRotation(new Vector3(999, transform.position.y, transform.position.z));
            //model.rotation = newRotation;
        }

    }

    private void SearchJumpPoint()
    {
        //jumpCurveX = (transform.position.x + player.position.x) / 2;
        // jumpCurveX = transform.position.x;
        // jumpCurveXDest =player.position.x;
        jumpCurveX = (transform.position.x + player.position.x) / 2;
        jumpCurveScale = (yCoord - JUMP_LIMIT) / (Math.Pow((transform.position.x - jumpCurveX), 2));

        jumpingAt = new Vector3(player.position.x, yCoord+1f, transform.position.z); ;
        //Debug.Log("player x: "+player.position.x+" boss x: "+transform.position.x+" tile y: "+yCoord);
    }

    public override bool Attack()
    {
        return false;
    }

    ////////////*testing*/////////////////
    public void isAlive()
    {
        if (currHp == 0)
        {
            SceneManager.LoadScene("WinUI");
        }
    }
    /////////////////////////////////////



}
