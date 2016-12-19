$numberInput = Read-Host 'Type a number'

write-output "Your number: $numberInput"

if($args){
    $firstArgument = $args[0]
    write-output "First argument: $firstArgument"
} else {
    write-output "No argument passed."
}
