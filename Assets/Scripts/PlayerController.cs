using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [Header("Movement")]
    [SerializeField] private float moveSpeed = 8f;
    [SerializeField] private float jumpForce = 5f;
    [SerializeField] private float gravity = -13f;
    [SerializeField] private float moveSmoothTime = 0.05f;

    [Header("Look")]
    [SerializeField] private float lookSensitivity = 0.1f;
    [SerializeField] private float lookTiltAmount = 1.2f;
    [SerializeField] private float lookSmoothTime = 0.03f;
    [SerializeField] private float tiltSmoothTime = 0.1f;

    private Camera _camera;
    private CharacterController _controller;
    private PlayerInput _input;

    private float _cameraPitch = 0f;
    private float _cameraTilt = 0f;
    private float _velocityY = 0f;

    private Vector2 _currentDirection, _currentDirectionVelocity;
    private Vector2 _currentDelta, _currentDeltaVelocity;
    private float _currentTilt, _currentTiltVelocity;

    private void Awake() {
        _camera = GetComponentInChildren<Camera>();
        _controller = GetComponent<CharacterController>();
        _input = new PlayerInput();

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void OnEnable() {
        _input.Player.Enable();
    }

    private void OnDisable() {
        _input.Player.Disable();
    }

    private void Update() {
        HandleMovement();
        HandleLook();
    }

    private void HandleMovement() {
        Vector2 targetDirection = _input.Player.Movement.ReadValue<Vector2>();

        _currentDirection = Vector2.SmoothDamp(_currentDirection, targetDirection, ref _currentDirectionVelocity, moveSmoothTime);

        if (_controller.isGrounded)
            _velocityY = 0.0f;

        if (_input.Player.Jump.IsPressed() && _controller.isGrounded)
            _velocityY += jumpForce;

        _velocityY += gravity * Time.deltaTime;

        Vector3 velocity = (transform.forward * _currentDirection.y + transform.right * _currentDirection.x) * moveSpeed + Vector3.up * _velocityY;
        _controller.Move(velocity * Time.deltaTime);
    }

    private void HandleLook() {
        Vector2 targetDelta = _input.Player.Look.ReadValue<Vector2>();

        _currentDelta = Vector2.SmoothDamp(_currentDelta, targetDelta, ref _currentDeltaVelocity, lookSmoothTime);

        _cameraPitch -= _currentDelta.y * lookSensitivity;
        _cameraPitch = Mathf.Clamp(_cameraPitch, -90f, 90f);

        _cameraTilt = _currentDirection.x < -0.1f ? lookTiltAmount : _currentDirection.x > 0.1f ? -lookTiltAmount : 0f;
        _currentTilt = Mathf.SmoothDamp(_currentTilt, _cameraTilt, ref _currentTiltVelocity, tiltSmoothTime);

        _camera.transform.localEulerAngles = Vector3.right * _cameraPitch + Vector3.forward * _currentTilt;
        transform.Rotate(Vector3.up * _currentDelta.x * lookSensitivity);
    }
}
