using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthPotion : MonoBehaviour
{
    [SerializeField] private float rotationSpeed = 100.0f;
    [SerializeField] private float healthIncrease = 50.0f; 
    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);
    }
    private void OnTriggerEnter(Collider other) {
        if (other.CompareTag("Player")) {
            Destroy(gameObject);
            Equipment.playerHealth += healthIncrease;
        }
    }
}
