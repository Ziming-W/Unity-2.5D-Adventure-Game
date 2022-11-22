using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class StationaryAI : AI
{
    // Start is called before the first frame update
    [SerializeField] GameObject tile;
    [SerializeField] int increment;

    [SerializeField] int verticalRange;

    [SerializeField] GameObject bullet;
    int frameCount;
    int angle = 0;

    float initialY;
    float initialZ;

    void Start()
    {
        player = GameObject.Find("Player").transform;
        currHp = HP_LIMIT;
        initialY = model.rotation.y;
        initialZ = model.rotation.z;
                hurtTimeFrame = 20;
        hurtFrameCount = 0;
        normal = bottom.GetComponent<SkinnedMeshRenderer>().material;
        
    }

    // Update is called once per frame
    void Update()
    {
        isAlive();
        isDamaged();
        float minx = tile.GetComponent<Collider>().bounds.min.x;
        float maxx = tile.GetComponent<Collider>().bounds.max.x;
        float miny = tile.GetComponent<Collider>().bounds.max.y;
        float maxy = miny + verticalRange;
        if ((player.transform.position.x > minx && player.transform.position.x < maxx) &&
        (player.transform.position.y > miny && player.transform.position.y < maxy))
        {
            //Debug.Log("enemy spotted!!!");
            Vector3 dir = player.position - transform.position;
            if (dir.magnitude > 1f)
            {
                Quaternion newRotation = Quaternion.LookRotation(new Vector3(dir.x, initialY, initialZ));
                model.rotation = newRotation;
            }

            if (frameCount == increment)
            {
                animator.SetBool("playerIsInSight", true);
                //Vector3 dir = (transform.position-player.transform.position).normalized;
                //EnemyBullet newBullet = new EnemyBullet(dir);
                Instantiate(bullet,transform.position,Quaternion.identity);
                //Debug.Log("open fire!!");
                frameCount = -1;
            }
            frameCount++;

            // Instantiate(tile,new Vector3(0,-2,0),Quaternion.identity);
        }
        else
        {
            animator.SetBool("playerIsInSight", false);
        }

        /*if(frameCount == increment){
           float radian = (float)( Math.PI * angle / 180.0);
           float x = (float)Math.Cos(radian);
           float y = (float)Math.Sin(radian);
            Quaternion newRotation = Quaternion.LookRotation(new Vector3(x,y,transform.position.z));
            Debug.Log("("+x+", "+y+")");
            model.rotation = newRotation;
            angle++;
            frameCount=-1;
        }
        
        frameCount++;*/

    }

    public override void moveTo(Vector3 destination)
    {
    }

    public override void Patroling()
    {
    }

    private void SearchWalkPoint()
    {

    }

    public override bool Attack()
    {
        return false;
    }
}
