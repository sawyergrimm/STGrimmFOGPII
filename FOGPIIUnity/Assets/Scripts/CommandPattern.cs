using System;
using System.Collections;
using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
#endif

[DisallowMultipleComponent]
public class CommandPattern : MonoBehaviour
{

    public float moveDistance = 1.0f;
    private readonly Stack<ICommand> commandHistory = new Stack<ICommand>();
    public int UndoCount = 0;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.W))
        {
            ExecuteMoveCommand(transform.forward * moveDistance);
        }

        if (Input.GetKeyDown(KeyCode.A))
        {
            ExecuteMoveCommand(transform.right * -moveDistance);
        }
        if (Input.GetKeyDown(KeyCode.S))
        {
            ExecuteMoveCommand(transform.forward * -moveDistance);
        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            ExecuteMoveCommand(transform.right * moveDistance);
        }

        if (Input.GetKeyDown(KeyCode.R))
        {
            Undo();
        }
    }

    public void Undo()
    {
        if (commandHistory.Count == 0)
            return;
        ICommand command = commandHistory.Pop();
        command.Undo();
        UndoCount--;
    }
    void ExecuteMoveCommand(Vector3 _amount)
    {
        ICommand command = new MoveCommand(transform, _amount);
        command.Execute();
        commandHistory.Push(command);
        UndoCount++;
    }
}

public interface ICommand
{
    void Execute();
    void Undo();
}

public class MoveCommand : ICommand
{
    private readonly Action execute;
    private readonly Action undo;
    private Vector3 startingPosition;
    public MoveCommand(Transform _transform, Vector3 _moveAmount)
    {
        execute = () =>
        {
            startingPosition = _transform.position;
            _transform.position += _moveAmount;
        };

        undo = () => {_transform.position = startingPosition;};
    }

    public void Execute()
    {
        execute();
    }

    public void Undo()
    {
        undo();
    }
}

#if UNITY_EDITOR

#endif