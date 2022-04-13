############################################################################
#
#                       PS5 Target Stock Check App
#                          By:  Matt Peterson
#                                4/12/22
#                _______________________________________
#
#    Checking Target stock is easy because they pull the page down
#    if they are out of stockso all we do is check to see if we get an
#    error and repeat until it's a success. Then# trigger your IFTTT 
#    and Home Assistant events.
#
############################################################################

# Sets URL to check - I used the Nintendo Switch URL to test the automation triggers
$PS5URL = "https://www.target.com/p/playstation-5-console/-/A-81114595"
# $SwitchURL = "https://www.target.com/p/nintendo-switch-with-neon-blue-and-neon-red-joy-con/-/A-77464001"

# Set Home Assistant call variables

$APIUrl = "http://YourHAAddress:8123/api/" # Replace to match your Home Assistant URL

$EntityId = "automation.turn_on_light_with_front_door" # Obviously replace with your entity ID

$body = ConvertTo-Json @{"entity_id" = "$EntityID"}

$HAToken = "Long__HA__TOKEN" # See HA API documentation if you don't already have a token

$Headers = @{Authorization = "Bearer "+$HAToken}

$service = "automation/trigger" # If you're calling a different service, adjust this. Replace any "." with "/"

$RestUri=$APIUrl+"services/"+$service # This calls a service - adjust if you need

# Define how many seconds to wait between calls to the Target site

$PingWaitSecs = 60 

# Set up your IFTTT info to ping GroupMe, Discord, or just get a notification on your phone

$IFTTT = "IFTTT_DEV_KEY"
$IFUri = "https://maker.ifttt.com/trigger/PS5_Stock_Target/with/key/" + $IFTTT # Make sure you get the right trigger name

# Loop until you don't get an error

While ($true){

    Try {
        Invoke-WebRequest $PS5URL
        Break
    } Catch {
        "Caught" # you don't really need this - I just like to see things work
    }
    Start-Sleep $PingWaitSecs
}

# Ping your IFTTT automation
Invoke-WebRequest $IFUri

# Ping your Home Assistant API
Invoke-RestMethod -Method Post -Uri $RestUri -Body ($body) -Header $ha_api_headers
