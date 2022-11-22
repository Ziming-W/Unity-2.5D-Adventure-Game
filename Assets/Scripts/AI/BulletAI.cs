using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletAI : AI
{

    [SerializeField] float range;
    
    //[SerializeField] float speed;
    Vector3 dir;
    // Start is called before the first frame update

    public BulletAI(Vector3 dir){
        this.dir = dir;
        
    }
    void Start()
    {
        //Debug.Log("enemy set: "+this.playerName+" Damage set: "+DAMAGE+" speed set: "+speed);
        Transform player = GameObject.Find("Player").transform;
        dir =  (player.transform.position-transform.position).normalized;
        
    }

    // Update is called once per frame
    void Update()
    {
        
        if(range<=0){
            
            Destroy(gameObject);
        }
        transform.position += (dir*speed);
        range-= speed;
        //Debug.Log("remaining range: "+range);
    }


    public override void moveTo(Vector3 destination){

    }

    public override void Patroling(){

    }

    public override bool Attack(){
         return false;
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.name == "Player")
        {
            PlayerController playerScript = FindObjectOfType<PlayerController>();
            playerScript.getDamage(DAMAGE);
            
            //Debug.Log("Damage dealt!: "+DAMAGE);
            Destroy(gameObject);
        }
    }
}
