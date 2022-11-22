using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProceduralGeneration : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] int minGapWidth;
    [SerializeField] int maxGapWidth;
    [SerializeField] int minGapHeight;
    [SerializeField] int maxGapHeight;
    [SerializeField] int minInterval;
    [SerializeField] int maxInterval;

    [SerializeField] GameObject tile;


    private int previousTileY;
    private int previousTileZ;

    private int frame;

    private int interval;
    private int[] mutipl = {-1,1};
    void Start()
    {
        //for(int i=0;i<20;i++){
            GameObject newTile = Instantiate(tile,new Vector3(0,-2,0),Quaternion.identity);
            newTile.transform.localScale = new Vector3(20.0f, 1, 1);
    
            previousTileY = -2;
            //interval = Random.Range(minInterval,maxInterval);
            interval = 120;
    }

    // Update is called once per frame
    void Update()
    {
       //Debug.Log(frame+" "+interval);
       
        if(frame == interval){
            var dist = (transform.position - Camera.main.transform.position).z;
            int rightmost = (int)Camera.main.ViewportToWorldPoint(new Vector3(1, 0, dist)).x+5;
            int top = (int)Camera.main.ViewportToWorldPoint(new Vector3(1, 1, dist)).y-5;
            int bot = (int)Camera.main.ViewportToWorldPoint(new Vector3(1, 1, dist)).y-5;
            int height;
            if(previousTileY >= top){
                height = previousTileY -(Random.Range(minGapHeight,maxGapHeight));
            }else if(previousTileY <= bot){
                 height = previousTileY +(Random.Range(minGapHeight,maxGapHeight));
            }else{
                height = previousTileY +(Random.Range(minGapHeight,maxGapHeight)*mutipl[Random.Range(0,2)]);
            }
            
            //Debug.Log("height: "+height);
            previousTileY = height;
            GameObject newTile = Instantiate(tile,new Vector3(20,height,0),Quaternion.identity);
            int xsize = Random.Range(minGapWidth,maxGapWidth);
            newTile.transform.localScale = new Vector3(xsize, 1, 1);
            //interval = Random.Range(minInterval,maxInterval);
            frame=-1;
        }
        frame++;
    }

    
}
