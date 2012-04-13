From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: 3.4.0-rc2+: CIFS - strange file modes
Date: Fri, 13 Apr 2012 07:12:51 +0100
Message-ID: <201204130712.51693.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I'm running a kernel built from a pull from Linus last night (v3.4-rc2-174-gecca5c3), patched
with Sachin Prabhu's " Cleanup handling of NULL value passed for a mount option" patch, 
which hasn't made it to Linus yet.

When I mount a partition on a small nas, I see strange file modes as is shown below:

[chris:~]$ uname -r
3.4.0-rc2+
[chris:~]$ sudo mount /media/nas/share
[chris:~]$ cp IMAG014* /media/nas/share/chris/upstairs/
[chris:~]$ ls -l /media/nas/share/chris/upstairs/
total 3980
drwxr-xr-x 2 chris users       0 Apr 13 06:55 ./
drwxr-xr-x 2 chris users       0 Apr  5 12:01 ../
--w--wx-wT 1 chris users 1255508 Apr 13 06:55 IMAG0147.jpg*
--w--wx-wT 1 chris users 1388786 Apr 13 06:55 IMAG0148.jpg*
--w--wx-wT 1 chris users 1430092 Apr 13 06:55 IMAG0149.jpg*

The related line in fstab is:

//nas/Share             /media/nas/share        cifs 
rw,noauto,noserverino,nosuid,nodev,user,guest,uid=1002,gid=100,file_mode=0666      0 0

When I reboot into 3.3.1, the same files look fine:

[chris:~]$ uname -r
3.3.1
[chris:~]$ sudo mount /media/nas/share
[chris:~]$ ls -l /media/nas/share/chris/upstairs/
total 3980
drwxr-xr-x 2 chris users       0 Apr 13 06:55 ./
drwxr-xr-x 2 chris users       0 Apr  5 12:01 ../
-rw-rw-rw- 1 chris users 1255508 Apr 13 06:55 IMAG0147.jpg
-rw-rw-rw- 1 chris users 1388786 Apr 13 06:55 IMAG0148.jpg
-rw-rw-rw- 1 chris users 1430092 Apr 13 06:55 IMAG0149.jpg

Let me know if I can help in fixing this regression.

Please cc me on any reply - I'm not subscribed.

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. Changing Man - Paul Weller
