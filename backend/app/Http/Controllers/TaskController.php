<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index()
    {
        return response()->json(Task::all());
    }

    // ✅ CREATE avec date
    public function store(Request $request)
    {
        $task = Task::create([
            'title' => $request->title,
            'priority' => $request->priority,
            'due_date' => $request->due_date, // ⭐ AJOUT
        ]);

        return response()->json($task, 201);
    }

    // ✅ UPDATE avec date
    public function update(Request $request, $id)
    {
        $task = Task::findOrFail($id);

        $task->update([
            'title' => $request->title,
            'priority' => $request->priority,
            'due_date' => $request->due_date, // ⭐ AJOUT
        ]);

        return response()->json([
            'message' => 'updated',
            'task' => $task
        ]);
    }

    public function destroy($id)
    {
        Task::findOrFail($id)->delete();

        return response()->json([
            'message' => 'deleted'
        ]);
    }
}