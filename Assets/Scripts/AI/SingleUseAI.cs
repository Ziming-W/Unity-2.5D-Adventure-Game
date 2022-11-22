using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SingleUseAI : AI
{
    // Start is called before the first frame update

    [SerializeField] float endingPoint;
    [SerializeField] public float sightRange;

    [SerializeField] public LayerMask whatIsPlayer;
    private bool isFired;
    void Start()
    {
        player = GameObject.Find(playerName).transform;
        isFired = false;
        currHp = HP_LIMIT;
                hurtTimeFrame = 20;
        hurtFrameCount = 0;
        normal = bottom.GetComponent<SkinnedMeshRenderer>().material;
    }

    // Update is called once per frame
    private void Update()
    {

        isAlive();
        isDamaged();
        if (!isFired)
        {
            bool playerInSightRange = Physics.CheckSphere(transform.position, sightRange, whatIsPlayer);
            //Debug.Log(playerInSightRange);
            if(playerInSightRange){
                isFired = true;
            }
        }

        


        if (isFired)
        {
            Patroling();
        }
    }

    public override void moveTo(Vector3 destination)
    {
        Vector3 dir = (destination - transform.position).normalized;

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
            walkPointSet = false;
            Destroy(gameObject);
            //Debug.Log("self-Destruct!");
        }
    }

    private void SearchWalkPoint()
    {


        walkPoint = new Vector3(transform.position.x,transform.position.y+endingPoint,transform.position.z);
        Vector3 dir = walkPoint - transform.position;
        Quaternion newRotation = Quaternion.LookRotation(dir);
        model.rotation = newRotation;
        walkPointSet = true;
    }

    public override bool Attack()
    {
        return false;
    }
}
