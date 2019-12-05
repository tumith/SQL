from mysql.connector import connect
from mysql.connector import Error

class DbManager:
    def __init__(self):
        self.status = ' '
        try:
            self.conn = connect(
                user='root',
                password='mypassword',
                host='localhost',
                database='ProgressTracker_V6'
            )
            if self.conn.is_connected():
                self.status = 'connected'
            else:
                print('connection failed.')
                exit()
        except Error as error:
            print(error)
            exit()

    def runStoredP(self, runSPName, *more):
        outputcommand = "call " + runSPName + "("
        for x in more:
            try:
                int(x)
                outputcommand += str(x) + ", "
            except ValueError:
               outputcommand += '"' + str(x) + '", '

        if len(more) != 0:
            outputcommandnew = outputcommand[:-2]
        else:
            outputcommandnew = outputcommand
        outputcommandnew += ");"


        try:
            cursor = self.conn.cursor(prepared=True)
            sql_function_query = outputcommandnew
            cursor.execute(sql_function_query)
            output = cursor.fetchall()
            cursor.close()
        except Error as error:
            self.status = error
            output = error
        
        print(outputcommandnew)
        
        return output

#   --------------------------- Course -------------------------
    def checkCourse(self, CNumber):
        return self.runStoredP('GetCourse', CNumber)

    def buldiCourse(self, courseNumer, courseNafn, courseStig):
        return self.runStoredP('NewCourse', courseNumer, courseNafn, courseStig)
   
    def updataCourse(self, CNumer, CNafn, CStig):
        return self.runStoredP('UpdateCourse', CNumer, CNafn, CStig)
    
    def nukeCourse(self, CuNumer):
        return self.runStoredP(' DeleteCourse', CuNumer)
#   ---------------------- end of Course ------------------------

#   --------------------------- Student -------------------------
    def calluponStudent(self, getSID):
        return self.runStoredP('GetStudent', getSID)

    def create_student(self, fname, lname, dob, startsem):
        return self.runStoredP('NewStudent', fname, lname, dob, startsem)
    
    def reevaluateStudent(self, fnafn, lnafn, ndob, nstartsem):
        return self.runStoredP('UpdateStudent', fnafn, lnafn, ndob, nstartsem)
    
    def reevaluateStudentsExistance(self, inSchID):
        return self.runStoredP('DeleteStudent', inSchID)
#   ---------------------- end of Student ------------------------

#   --------------------------- School -------------------------
    def checkSchool(self, SchNumber):
        return self.runStoredP('GetSchool', SchNumber)

    def foundASchool(self, SchoolNafn):
        return self.runStoredP('NewSchool', SchoolNafn)
    
    def updateSchool(self, schName, SchID):
        return self.runStoredP('UpdateSchool', schName, SchID)
    
    def nukeSchool(self, schNumer):
        return self.runStoredP('DeleteSchool', schNumer)
#   ---------------------- end of School ------------------------

# ----------------------------------------------- oo0oo -----------------------------------------------
dm = DbManager()

#------Course-----
# courseNumber = input("Sl")
# dm.buldiCourse(courseNumber, 'Netkerfis kennsla fyrir fólk sem kann ekki', 5)
# dm.updataCourse(courseNumber, 'Netkerfis Kennsla', 5)
# dm.checkCourse(courseNumber)
# dm.nukeCourse(courseNumber)
#--end of Course--

# #-----Student-----
dm.create_student('Hrólfur', 'Gilfason', '1001-01-01', 8)
dm.reevaluateStudent('Hrólfur', 'Gylfason', '2001-09-21', 9)
dm.calluponStudent(11)
# dm.reevaluateStudentsExistance(11)
# #--end of Student--

# #-----School-----
# dm.foundASchool('HrólfaSkóli')
# dm.updateSchool('HrólfaSkóli', 2)
# dm.checkSchool(2)
# dm.nukeSchool(2)
# #--end of School--
