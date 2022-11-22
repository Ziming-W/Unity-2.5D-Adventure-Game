using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrackerAI : AI
{

    [SerializeField] public float timeBetweenAttacks;
    protected bool alreadyAttacked;

    [SerializeField] public float sightRange, attackRange;
    //[SerializeField] public bool playerInSightRange, playerInAttackRange;

    [SerializeField] public LayerMask whatIsGround, whatIsPlayer;
    [SerializeField] private float walkPointRange;
    private bool isFired;
    //private bool walkPointSet;

    private Vector3[] presetWalkPoints;
    private int numOfWalkPoints;

    private int currWalkPoint;
    // Start is called before the first frame update
    void Start()
    {
        currHp = HP_LIMIT;
        player = GameObject.Find("Player").transform;
        numOfWalkPoints = 2;
        currWalkPoint = 0;
        presetWalkPoints = new Vector3[numOfWalkPoints];

        float x = transform.position.x;
        float y = transform.position.y;
        float z = transform.position.z;
        presetWalkPoints[0] = new Vector3(x - walkPointRange, y, z);
        presetWalkPoints[1] = new Vector3(x + walkPointRange, y, z);
        hurtTimeFrame = 20;
        hurtFrameCount = 0;
        normal = bottom.GetComponent<SkinnedMeshRenderer>().material;

    }

    private void Update()
    {
        isDamaged();
        isAlive();
        if (!isFired)
        {
            bool playerInSightRange = Physics.CheckSphere(transform.position, sightRange, whatIsPlayer);

            if (playerInSightRange)
            {
                isFired = true;
            }
            else
            {
                Patroling();
            }
        }


        if (isFired)
        {
            bool playerInAttackRange = Physics.CheckSphere(transform.position, attackRange, whatIsPlayer);
            if (!playerInAttackRange) ChasePlayer();
            if (playerInAttackRange) AttackPlayer();
        }

        //Patroling();

        //playerInSightRange = Physics.CheckSphere(transform.position, sightRange, whatIsPlayer);
        // playerInAttackRange = Physics.CheckSphere(transform.position, attackRange, whatIsPlayer);

        //if (!playerInSightRange && !playerInAttackRange) 

        // if (playerInSightRange && !playerInAttackRange) ChasePlayer();
        // if (playerInSightRange && playerInAttackRange) AttackPlayer();
    }

    public override void moveTo(Vector3 destination)
    {
        Vector3 dir = (destination - transform.position).normalized;
        //Debug.Log("moving in dir: "+dir+" towards: "+destination);
        transform.position += dir * speed;

    }

    public override void Patroling()
    {
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
        }
    }

    private void SearchWalkPoint()
    {
        //Debug.Log("searching walkpoint");
        /*
        //float randomZ = Random.Range(-walkPointRange,walkPointRange);
        float randomX = Random.Range(-walkPointRange,walkPointRange);
        float randomY = Random.Range(-walkPointRange,walkPointRange);

        walkPoint =  new Vector3(transform.position.x + randomX,transform.position.y + randomY,  0);

        if(Physics.Raycast(walkPoint, -transform.up,2f,whatIsGround))
        {
            walkPointSet = true;
        }*/

        if (currWalkPoint == numOfWalkPoints)
        {
            currWalkPoint = 0;
        }
        walkPoint = presetWalkPoints[currWalkPoint];
        //Debug.Log("walkpoint set to: "+walkPoint);
        walkPointSet = true;
        currWalkPoint++;

        Vector3 dir = walkPoint - transform.position;
        Quaternion newRotation = Quaternion.LookRotation(dir);
        model.rotation = newRotation;



    }

    // Update is called once per fram
    private void ChasePlayer()
    {

        Vector3 distanceToWalkPoint = player.position-transform.position;
        
        // if (distanceToWalkPoint.magnitude > 0.21f)
        //{
            Vector3 dir = player.position - transform.position;
            Quaternion newRotation = Quaternion.LookRotation(dir);
            model.rotation = newRotation;
            transform.LookAt(player);
       //}
        //
        //
        //distanceToWalkPoint = distanceToWalkPoint.normalized;
        //moveTo(player.position+ distanceToWalkPoint);
        moveTo(player.position);
    }
    private void AttackPlayer()
    {
        ChasePlayer();

        /*
        if (!alreadyAttacked)
        {

            //Attack code
            alreadyAttacked = true;
            Invoke(nameof(ResetAttack), timeBetweenAttacks);

        }*/
    }

    private void ResetAttack()
    {
        //alreadyAttacked = false;
    }

    public override bool Attack()
    {
        return false;
    }
}
