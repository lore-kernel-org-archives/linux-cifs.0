From: Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>
Subject: Unable to mount using credentials file
Date: Sat, 1 Nov 2014 12:03:34 +0000 (UTC)
Message-ID: <loom.20141101T124621-513@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am attempting to mount Windows volumes on a Synology DS (running DSM 5.0,
a Debian-based distribution).
Command lines of the form:
mount -t cifs -o username=<user>,password=<pass> //<IP address>/share/
/mnt/<mountpoint>
succeed.
However, command lines of the form:
mount -t cifs -o credentials=<filename> //<IP address>/share/ /mnt/<mountpoint>
fail with the error "Invalid argument".
For diagnostic purposes, I have attempted to mount the volumes directly
using mount.cifs (v5.5).  
Once again, commands of the form:
mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o
username=<user>,password=<password>
succeed.
However, commands of the form:
mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o credentials=<file>
fail with the error message:
error -1 (Unknown error 4294967295) opening credential file <file>
This is the case regardless of the location of the file (see
http://samba.2283325.n4.nabble.com/Error-s-opening-credentials-file-td2518214.html)
or its privileges.  The error persists, even when the command is executed
from a root session and the credentials file has permissions 0777 and is in
a subdirectory of /root.
How can I get mount to work using a credentials file?
