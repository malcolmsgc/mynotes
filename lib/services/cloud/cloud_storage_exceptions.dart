class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CreateNoteException implements CloudStorageException {}

class GetAllNotesException implements CloudStorageException {}

class UpdateNoteException implements CloudStorageException {}

class DeleteNoteException implements CloudStorageException {}
