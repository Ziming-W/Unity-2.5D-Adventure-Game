using System; 
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoinController : MonoBehaviour {
    private float rotationSpeed = 100.0f;
    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        transform.Rotate(rotationSpeed * Time.deltaTime, 0, 0);
    }
    private void OnTriggerEnter(Collider other) {
        if(other.CompareTag("Player")) {
            Destroy(gameObject);
            Equipment.numCoin++;
        }
    }
}

