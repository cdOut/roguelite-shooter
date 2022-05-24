using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterController : MonoBehaviour
{
    [Header("References")]
    [SerializeField] private Transform playerPosition;

    [Header("Movement")]
    [SerializeField] private float monsterSpeed;

    private Rigidbody _rbody;
    private Vector3 _moveDirection = Vector3.zero;

    void Awake()
    {
        _rbody = GetComponent<Rigidbody>();

        _rbody.freezeRotation = true;
    }

    void Update()
    {
        if(playerPosition != null)
            FollowPlayer ();
    }

    private void FollowPlayer() {
        _moveDirection = (playerPosition.position - _rbody.position).normalized * monsterSpeed;
    }

    private void FixedUpdate() {
        _rbody.MovePosition(_rbody.position + _moveDirection * Time.fixedDeltaTime);
    }
}
