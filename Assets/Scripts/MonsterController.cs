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

    private Vector3 _position, _velocity, _angularVelocity;
    private Quaternion _rotation;

    void Awake()
    {
        _rbody = GetComponent<Rigidbody>();

        _rbody.freezeRotation = true;
    }

    void Update()
    {
        if(playerPosition != null)
            FollowPlayer ();

        _position = _rbody.position;
        _velocity = _rbody.velocity;
        _rotation = _rbody.rotation;
        _angularVelocity = _rbody.angularVelocity;
    }

    private void OnCollisionEnter(Collision collision) {
        _rbody.position = _position;
        _rbody.velocity = _velocity;
        _rbody.rotation = _rotation;
        _rbody.angularVelocity = _angularVelocity;
    }

    private void FollowPlayer() {
        _moveDirection = (playerPosition.position - _rbody.position).normalized * monsterSpeed;
        Debug.Log(_moveDirection);
    }

    private void FixedUpdate() {
        _rbody.MovePosition(_rbody.position + _moveDirection * Time.fixedDeltaTime);
    }
}
