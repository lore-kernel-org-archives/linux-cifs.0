From: "ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org>
Subject: Trouble accessing Buffalo NAS with CIFSFS
Date: Thu, 19 Jan 2012 09:07:52 +0100
Message-ID: <20120119090752.9b7aea6c.ralda@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

Some weeks ago I upgraded my Linux system to a recent kernel (currently
3.2.1). Since this update I have trouble accessing my NAS station
(Buffalo DriveStation 2Share) with CIFSFS.

Formerly I used an older 2.6er Kernel with SMBFS to mount and access
the NAS station. The speed was not that high, but the connection worked
without failures. As the SMBFS vanished I had to switch to CIFS in the
new installation. With CIFS I can mount the NAS station and I can see
the directory listings, but whenever I try to copy a file to the NAS
station the copy hangs and probably never return (leaving the process
with a D status in process list).

The NAS is mounted like this (output from /proc/mounts):

//archiv/share /nas cifs rw,mand,nosuid,nodev,noexec,relatime,sec=ntlm,
  unc=\\archiv\share,username=root,uid=1002,forceuid,gid=65534,forcegid,
  addr=192.168.178.3,file_mode=0600,dir_mode=0700,nounix,rsize=16384,
  wsize=65216,actimeo=1
  0 0

mount.cifs --version: 1.10

dmesg output gives info like this:

CIFS VFS: Autodisabling the use of server inode numbers on \\archiv
\share. This server doesn't seem to support them properly. Hardlinks
will not be recognized on this mount. Consider mounting with the
"noserverino" option to silence this message.
CIFS VFS: Server archiv has not responded in 300 seconds.
Reconnecting...
CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
CIFS VFS: Error -11 sending data on socket to server
CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
CIFS VFS: Error -11 sending data on socket to server
CIFS VFS: sends on sock ae3b9b40 stuck for 15 seconds
CIFS VFS: Error -11 sending data on socket to server
CIFS VFS: Error -32 sending data on socket to server
CIFS VFS: Error -32 sending data on socket to server
CIFS VFS: Error -32 sending data on socket to server
...

adding "noserverino" to mount options silences one message in the above
list but changes the other behavior.

CIFS is compiled statically into the kernel. Self optimized statical
kernel, not standard modular distro kernel.

I really need help to get the NAS back to a working state. Feel free to
ask for any information you need for diagnosis. If required I'm able to
add patches and recompile the kernel for diagnosis.

Thx ahead
Harald
