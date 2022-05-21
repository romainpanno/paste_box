#!/bin/bash

echo "Copying paste_box to bins"
sudo cp paste_box.sh /usr/bin/
echo "Adding permissions"
sudo chmod +x /usr/bin/paste_box.sh
echo "Changing name without .sh"
sudo mv /usr/bin/paste_box.sh /usr/bin/paste_box
bash
