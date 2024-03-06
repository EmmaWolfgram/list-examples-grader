CPATH='.;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [ -f student-submission/ListExamples.java ]
then
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/
else 
    echo "Missing student-submission/ListExamples.java. Did you forget it?"
    exit 1
fi

cd grading-area

javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
    echo "The program failed to compile, see error above"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$((tests - failures))

echo "Your score is $successes / $tests"


