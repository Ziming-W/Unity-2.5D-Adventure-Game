using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class AI : MonoBehaviour
{
    // Start is called before the first frame update

    protected int currHp;
    [SerializeField] protected int HP_LIMIT;
    [SerializeField] protected int DAMAGE;
    [SerializeField] public float speed;
    [SerializeField] protected Rigidbody hitbox;

    [SerializeField] public Animator animator;
    [SerializeField] public Transform model;

    [SerializeField] public Transform bottom;

    [SerializeField] protected Material hurt;
    protected Material normal;
    public Transform player;

    protected Vector3 walkPoint;
    protected bool walkPointSet;

    protected bool isHurt;
    protected int hurtTimeFrame;
    protected int hurtFrameCount;

       private  float timeBetweenDamages = 2f;
    protected float timeBetweenDamagesCounter = 0f;
    protected string playerName = "Player";

    public AI(){
        //currHp = HP_LIMIT;
    }

    public abstract void moveTo(Vector3 destination);

    public abstract void Patroling();

    public abstract bool Attack();

    public void isAlive(){
        timeBetweenDamagesCounter+=Time.deltaTime;
        if(currHp <= 0){
            Destroy(gameObject);
        }

    }

    public void isDamaged(){
        if(isHurt){
            if(hurtFrameCount == 0){
                //currComp.material = hurt;
                bottom.GetComponent<SkinnedMeshRenderer>().material = hurt;
            }
           // this.gameObject.transform.GetChild(0).GetChild(1).GetComponent<SkinnedMeshRenderer>().material = hurt;
            
            if(hurtFrameCount >= hurtTimeFrame){
                isHurt = false;
                hurtFrameCount = -1;
                //this.gameObject.transform.GetChild(0).GetChild(1).GetComponent<SkinnedMeshRenderer>().material = normal;
                 bottom.GetComponent<SkinnedMeshRenderer>().material = normal;
            }
            hurtFrameCount++;
        }
    }

    public void recieveDamage(int damage){
        currHp -= damage;
        isHurt = true;
    }



     void OnCollisionEnter(Collision collision)
    {
        //Debug.Log("collided with: "+collision.gameObject.name+" player name: "+playerName+" prepare to deal damage");
        if (collision.gameObject.name == playerName)
        {
            if(timeBetweenDamagesCounter >=timeBetweenDamages){
                
                PlayerController playerScript = FindObjectOfType<PlayerController>();
                playerScript.getDamage(DAMAGE);
                timeBetweenDamagesCounter = 0;
                Debug.Log("is Hit!! counter set to "+timeBetweenDamagesCounter);
            }else{
                Debug.Log("not yet, time is: a "+timeBetweenDamagesCounter);
            }

            
            
            //Debug.Log("Damage dealt!: "+DAMAGE);
        }
    }

    void OnTriggerEnter(Collider other) {
        Debug.Log("trigger!");
    }
}
