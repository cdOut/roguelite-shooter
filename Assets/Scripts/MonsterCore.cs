using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterCore : MonoBehaviour
{
    [Header("Stats")]
    [SerializeField] private float maxHealth;

    private float _health;

    private void Start()
    {
        if(maxHealth > 0)
            _health = maxHealth;
    }

    public void DealDamage(float amount) {
        _health -= amount;
        if (_health <= 0)
            Destroy();
    }

    private void Destroy() {
        Destroy(gameObject);
    }
}
