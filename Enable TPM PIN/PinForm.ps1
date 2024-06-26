# Load necessary .NET assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
# Function to create and show the input form
function Show-InputForm {
    # Create form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Enable Encryption with Startup PIN"
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.StartPosition = "CenterScreen"

    # Create label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Enter at least 8 characters to set Startup PIN"
    $label.Size = New-Object System.Drawing.Size(250, 20)
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $form.Controls.Add($label)


    $label2 = New-Object System.Windows.Forms.Label
    $label2.Text = "Confirm the set Startup PIN"
    $label2.Size = New-Object System.Drawing.Size(250, 20)
    $label2.Location = New-Object System.Drawing.Point(20, 80)
    $form.Controls.Add($label2)

    # Create text box 1
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Size = New-Object System.Drawing.Size(240, 20)
    $textBox.Location = New-Object System.Drawing.Point(20, 50)
    $form.Controls.Add($textBox)

    # Create text box 2
    $textBox2 = New-Object System.Windows.Forms.TextBox
    $textBox2.Size = New-Object System.Drawing.Size(240, 20)
    $textBox2.Location = New-Object System.Drawing.Point(20, 100)
    $form.Controls.Add($textBox2)


    # Create OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(160, 130)
    $okButton.Add_Click({
        if ($textBox.Text.Length -ge 8 -and $textBox.Text -eq $textBox2.text) {
            $Form.tag = $textBox.Text
            $form.Close()
        } else {
            [System.Windows.Forms.MessageBox]::Show("Confirmation Input Mismatch OR Minimum 8 char required", "Error")
        }
    })
    $form.Controls.Add($okButton)

    # Create Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(80, 130)
    $cancelButton.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($cancelButton)
 
    # Show form
    $form.ShowDialog() | Out-Null
    Return $Form.tag
}

# Function to show confirmation dialog
function Show-ConfirmationDialog {
    param (
        [string]$message
    )
    $result = [System.Windows.Forms.MessageBox]::Show($message, "Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    return $result -eq [System.Windows.Forms.DialogResult]::Yes
}

do {
    $userInput = Show-InputForm
    if ($userInput) {
        $confirmation = Show-ConfirmationDialog -message "You entered: $UserInput `nIs this correct?"
        if ($confirmation) {
            [System.Windows.Forms.MessageBox]::Show("TPM PIN: $UserInput", "Success")
            break
        }
    }
} while ($true)

New-Item -Path $env:PUBLIC -Name input.txt -Value $userInput