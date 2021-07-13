
import Foundation
import CoreData
import UIKit

class PracticeNotes {
    var arrayData = [Notes]()
    var notesData : Notes!
    var practiceData = UserPracticesData()
    let currentUser = CurrentUser()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func addNotesData(uid: String, currentDate: Date,note: String,practiceName: String){
        let practiceData =  practiceData.getPracticeDataObj(practiceName: practiceName)
        let notes = Notes(context: self.context)
        notes.uid = uid
        notes.noteDate = currentDate.dateFormate()! as NSDate
        notes.note = note
        notes.practiceData = practiceData
        _ = currentUser.saveUser()
    }
    func getPracticeNoteObj(noteuid: String) -> Notes? {
        
        arrayData = getNotesByUid(uid: noteuid)!
        for data in arrayData{
            if(data.practiceData?.pUid == noteuid){
                notesData = arrayData.last
                return notesData
            }
        }
        return nil
        
    }
    func getNotesByUid(uid: String) -> [Notes]? {
        
        let request : NSFetchRequest<Notes> = Notes.fetchRequest()
        request.predicate = NSPredicate(format: "practiceData.noteuid = %@", argumentArray: [uid])
        
        do {
            let notesArray = try context.fetch(request)
            return notesArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
}
