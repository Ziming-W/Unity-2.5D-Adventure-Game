using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProcTree : MonoBehaviour
{
     
    [SerializeField] private int numTrees;
    [SerializeField] private int maxNumTreesLimitation;
    [SerializeField] private int gap; 
    [SerializeField] private int xLen;
    [SerializeField] private int zLen;
    [SerializeField] private GameObject[] treeTypes;
    [SerializeField] private Vector3 ratio_birch_fruit_meadow;
    private const int TREE_TYPE_POOL_SIZE = 10;
    private const int DELETE_IF_Y_SMALLER_THAN = -20;  

    private List<GameObject> treeList = new List<GameObject>();
    private List<Vector3> possiblePositions = new List<Vector3>(); 

    void Start()
    {
        //generate the list of all possible points
        int xCount = (xLen / gap) + 1;
        int zCount = (zLen / gap) + 1;
        float xPos = -xLen / 2.0f;
        float zPos = -zLen / 2.0f;
        float yAlways = 0.0f;
        float gapF = (float)gap; 
        for(int i = 0; i < xCount; i++) {
            for(int j = 0; j < zCount; j++) {
                possiblePositions.Add(new Vector3(xPos + (gapF * i), yAlways, zPos + (gapF * j))); 
            }
        }
        //adjust the y location of the point by shooting raycast
        int layermask = 1 << 6; //groundlayer
        for(int i = 0; i < possiblePositions.Count; i++) {
            RaycastHit hit;
            Vector3 worldPos = transform.TransformPoint(possiblePositions[i]); 
            if (Physics.Raycast(worldPos, Vector3.down, out hit, Mathf.Infinity, layermask)) {
                possiblePositions[i] = new Vector3(possiblePositions[i].x,
                                                  hit.point.y - transform.position.y,
                                                  possiblePositions[i].z); 
            }
        }

        //check if numTrees want to generate is greater than this limitation
        maxNumTreesLimitation = possiblePositions.Count; 
        if(numTrees > maxNumTreesLimitation) {
            Debug.LogError("Not possible to generate more than maxNumTreesLimitation");
            this.enabled = false; 
        }
        //set up random tree type selection pool
        ratio_birch_fruit_meadow = ratio_birch_fruit_meadow.normalized;//normalized this vector
        List<int> treeTypePool = new List<int>(); 
        for(int i = 0; i< (int)(TREE_TYPE_POOL_SIZE*ratio_birch_fruit_meadow.x); i++) {
            treeTypePool.Add(Random.Range(0, 3)); 
        }
        for(int i = 0; i< (int)(TREE_TYPE_POOL_SIZE * ratio_birch_fruit_meadow.y); i++) {
            treeTypePool.Add(Random.Range(3, 6)); 
        }
        for (int i = 0; i < (int)(TREE_TYPE_POOL_SIZE * ratio_birch_fruit_meadow.z); i++) {
            treeTypePool.Add(Random.Range(6, 8));
        }
        //randomly choose point and assign tree from this list based on treeTypePool's probablity distribution
        for (int i = 0; i < numTrees; i++) {
            int index = Random.Range(0, possiblePositions.Count); 
            Vector3 pos = possiblePositions[index];
            possiblePositions.RemoveAt(index);
            GameObject newTree = Instantiate(treeTypes[treeTypePool[Random.Range(0, treeTypePool.Count)]]);
            newTree.transform.parent = this.transform;
            newTree.transform.localPosition = pos; 
            treeList.Add(newTree);
        }
    }

    void Update()
    {
        //check if drop below ground, this is a rarely happend bug
        //delete tree if y is too small
        foreach (Transform t in transform.GetComponentsInChildren<Transform>()) {
            if(t.transform.position.y < DELETE_IF_Y_SMALLER_THAN) {
                Destroy(t.gameObject);
            }
        }
    }
}
