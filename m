From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: Failure to mount a built-in SMB/CIFS server in a router
Date: Fri, 20 Feb 2015 04:03:45 +0900
Message-ID: <54E63391.1070309@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Failure to mount a built-in SMB/CIFS server in a router

I have a router that supports a smb/CIFS server that exports a FAT32
filesystem on a USB storage that is plugged into its USB port.
(IODATA  WN-AC1167DGR)


Windows 7 64 bit can mount the FAT32 file system in a USB memory stick.
I can mount it from the window's explorer with user/password.

However, when I tried to mount it from linux by mount.cifs, I failed.

More details.

The SMB/CIFS server in the router expots a share name "Drive(A1)"
I learned this from the mounting of this SMB/CIFS server
by Windows 7 64-bit PC.

Also, I can dump the following using smbclient from the same linux PC
(actually a virtualbox guest on the said Windows 7 host).

$ smbclient -L AIRPORT51712 --ip-address=192.168.0.201 --user=admin
Enter admin's password:
Domain=[WORKGROUP] OS=[Linux 2.6.33] Server=[SXLM1.0.7beta1.iodata]

	Sharename       Type      Comment
	---------       ----      -------
	IPC$            IPC
	Drive(A1)       Disk      USB Storage Device (Flash/Drive UT_USB20)
Domain=[WORKGROUP] OS=[Linux 2.6.33] Server=[SXLM1.0.7beta1.iodata]

	Server               Comment
	---------            -------

	Workgroup            Master
	---------            -------


I notice that the router runs an old/stable version of linux.

Strange thing is that if I don't specify the  hostname of the server
"AIRPORT51712" that is assigned in the router SMB/CIFS setup to
smbclient command,
I get the following error.
$ smbclient -L --ip-address=192.168.0.201 --user=admin
Enter admin's password:
Connection to --ip-address=192.168.0.201 failed (Error
NT_STATUS_UNSUCCESSFUL)
$

Anyway, mount.cifs failed thusly:

# mount.cifs "//192.168.0.201/Drive(A1)" /tmp/L-temp -o
username=admin,noperm
Password for admin@//192.168.0.201/Drive(A1):
************
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

And at the end of dmesg I got:

[92588.526403] Key type dns_resolver registered
[92588.559363] FS-Cache: Netfs 'cifs' registered for caching
[92588.560391] Key type cifs.spnego registered
[92588.560406] Key type cifs.idmap registered
[92588.651527] CIFS VFS: bad security blob length 188
[92588.651532] CIFS VFS: Send error in SessSetup = -22
[92588.651772] CIFS VFS: cifs_mount failed w/return code = -22

So it seems that there is an authentication error due to unexpected blog
length (?).

Since windows 7 64-bit can mount the share "Drive(A1)" and
smbclient prints the share information,
the smb/cifs server function of the router
seems to work more or less. I wonder why mount.cifs failed.

I searched the web, but could not find the particular
message "CIFS VFS: bad security blob length 188".
That is the particular length 188 does not show up quickly.

Any ideas?

TIA

CI
