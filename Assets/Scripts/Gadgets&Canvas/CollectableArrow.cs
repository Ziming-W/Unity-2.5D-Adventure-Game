using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectableArrow : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private float rotationSpeed = 100.0f;
    [SerializeField] private int arrowAdd = 5; 
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update() {
        transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);
    }

    private void OnTriggerEnter(Collider other) {
        if (other.CompareTag("Player")) {
            Destroy(gameObject);
            Equipment.arrowRemain += arrowAdd;
        }
    }
}
