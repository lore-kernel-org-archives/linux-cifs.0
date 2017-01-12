From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: weirdness with cifsd
Date: Thu, 12 Jan 2017 15:49:12 -0800
Message-ID: <587815F8.5050309@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Just today, for the first time in a while, I have my Win machine
mounted on my linux machine.

But after a short while I'm seeing a large amount of read & write
network traffic between the two machines.

If I unmount the share (essentially my entire
Win disk), it stops.  But otherwise, I see cifsd getting
100% of a cpu most of the time.


Is there a log like samba has to see what is being accessed?

I'm not sure at this point what is causing it...

(sorry for partial note before.  I swear I clicked on save, but 
must have hit send... (lame!)...
