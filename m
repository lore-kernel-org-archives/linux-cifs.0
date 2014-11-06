From: Michael_OF <michaelof-ur4TIblo6goN+BqQ9rBEUg@public.gmane.org>
Subject: user mount.cifs with credentials file results in "error 13 (Permission
 denied) opening credential file"
Date: Thu, 06 Nov 2014 04:07:01 +0100
Message-ID: <545AE5D5.7090602@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,


I want to enable a user mount of a remote samba share. OpenSuse 13.1.
First step was to enable setuid bit for /etc/mount.cifs.
To keep mount as easy as possible, I've added an /etc/fstab entry like this:
   //host/share /mount_dir user=user,users 0 0

Works fine in bash, prompts for remote user's password.
Does not work in KDE's dolphin, no action when clicking on location bar's entry "share on host"

I then recognized the "credentials" option and changed the /etc/fstab entry like this:
   //host/share /mount_dir cifs credentials=/root/cred-file,users 0 0

(sudo chmod 600 /root/cred-file, to protect password)

Having done this, e.g.
   mount /mount_dir
as "root" or with sudo works fine.

But NOT as an end user: "error 13 (Permission denied) opening credential file /root/cred-file"
Both in bash or Dolphin.

chmod to allow read credential file for any user "solves" the problem, so it's really a local access right issue.

Which in fact seems to make user cifs mount impossible, at least this way.
And which confuses me: Why, if the mount.cifs program has the sticky bit set, it's not allowed to open a root-owned file?

Is this a bug, should I file it in bugzilla?


Thanks in advance,
Michael
