CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

# Step 1 -- Clone the student's repository
git clone $1 student-submission
echo 'Finished cloning'

# Step 2 -- Check that the student code contains ListExamples.java
if [[ -f ./student-submission/ListExamples.java ]]; then
    echo "File Existed"
else
    echo "ListExamples.java does not exist"
    echo "Grade: 0"
    exit 1
fi

# Step 3 -- Put all the relevant files in the grading-area directory.
# ListExamples.java, TestListExamples.java, lib directory
cp student-submission/ListExamples.java TestListExamples.java grading-area
cp -r lib grading-area

# Step 4 -- Compile the java files and check that they compiled successfully.
cd grading-area
javac -cp $CPATH ListExamples.java TestListExamples.java

ExitCode=$?
echo "This is the exit code of javac(previous command): $ExitCode."
if [[ $ExitCode -ne 0 ]]; then
    echo "ListExamples.java did not compile."
    echo "Grade: 0"
    exit 1
fi

# Step 5 -- Run the tests and report the grade based on JUNit output
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt
if [[ $(grep "FAILURES!!!" output.txt) == "FAILURES!!!" ]]; then
    TestCount=$(grep "Tests run" output.txt | cut -d',' -f 1 | cut -d' ' -f 3)
    echo Tests Run: $TestCount
    FailureCount=$(grep "Tests run" output.txt | cut -d',' -f 2 | cut -d' ' -f 4)
    echo Failures: $FailureCount
    echo "Grade: 0"
else
    echo "All Tests Successful!"
    echo "Grade: 100"
fi

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
