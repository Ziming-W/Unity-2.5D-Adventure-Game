using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BasicAI : AI
{

    float left;
    float right;
    [SerializeField] GameObject tile;
    private bool toLeft = true;

    public BasicAI() : base(){
        currHp = HP_LIMIT;
    }
    void Start()
    {
        currHp = HP_LIMIT;
        
        left = tile.GetComponent<Collider>().bounds.min.x;
        right = tile.GetComponent<Collider>().bounds.max.x;
        player = GameObject.Find(playerName).transform;
        hurtTimeFrame = 20;
        hurtFrameCount = 0;
        normal = bottom.GetComponent<SkinnedMeshRenderer>().material;
    }

    private void Update(){
        isDamaged();
        Patroling();
        isAlive();

        /*
        playerInSightRange = Physics.CheckSphere(transform.position,sightRange,whatIsPlayer);
        playerInAttackRange = Physics.CheckSphere(transform.position,attackRange,whatIsPlayer);

        if(!playerInSightRange && ! playerInAttackRange) Patroling();
        if(playerInSightRange && !playerInAttackRange) ChasePlayer();
        if(playerInSightRange && playerInAttackRange) AttackPlayer();*/
    }

    public override void moveTo(Vector3 destination){
        Vector3 dir = (destination-transform.position).normalized;
        
        transform.position += dir * speed;
    }

    public override void Patroling(){
        if(!walkPointSet) SearchWalkPoint();
        if(walkPointSet){
            moveTo(walkPoint);
        }
        Vector3 distanceToWalkPoint = transform.position - walkPoint;
        if(distanceToWalkPoint.magnitude < 1f){
            walkPointSet = false;
            toLeft = (!toLeft);
        }
    }

    private void SearchWalkPoint()
    {
        /*
        float randomZ = Random.Range(walkPointRange,walkPointRange);
        float randomX = Random.Range(walkPointRange,walkPointRange);
        float randomY = Random.Range(walkPointRange,walkPointRange);

        walkPoint =  new Vector3(transform.position.x + randomX,transform.position.y + randomY,  transform.position.z + randomZ);

        if(Physics.Raycast(walkPoint, -transform.up,2f,whatIsGround))
        {
            walkPointSet = true;
        }*/
        if(toLeft){
            walkPointSet = true;
            walkPoint =  new Vector3(left,transform.position.y,  transform.position.z);
        }else{
            walkPointSet = true;
            walkPoint =  new Vector3(right,transform.position.y,  transform.position.z);
        }

        if(toLeft){
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(-999,transform.position.y,transform.position.z));
            model.rotation = newRotation;
        }else{
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(999,transform.position.y,transform.position.z));
            model.rotation = newRotation;
        }
        
    }

    public override bool Attack(){
        return false;
    }


    
}
