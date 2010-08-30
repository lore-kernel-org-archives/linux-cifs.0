From: joe hefner <joehef06-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: cifs mount errors
Date: Mon, 30 Aug 2010 11:41:56 -0700 (PDT)
Message-ID: <545700.65464.qm@web56901.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

First, thanks to responders for the help with the "Cannot allocate memory error on mount". The noted change to inode.c did the trick:

     -        return ERR_PTR(-ENOMEM);
     +        return ERR_PTR(rc);

I am also seeing another odd behavior difference between Fedora 7 and Fedora 13. If I try a mount of a share on a particular Windows server I get the following error:

  # mount //servername/sharename /mnt -o user=mydom/administrator%mypass
  mount error(11): Resource temporarily unavailable
  Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

It does not matter if I use "dom=mydom,user=administrator%mypass". That also fails. This is odd for several reasons:

1. This does not occur on Fedora 7 systems.

2. Since the server and Linux box are on the same network, the domain name is not needed. Mounting with user=administrator%mypass works fine. 

3. If you immediately try the original command a second time on Fedora 13, it succeeds. If you wait about 30 seconds between attempts, it always fails.

Is this a known issue? Are there any tunable timers at play here? What is the cause/intent of the "temporarily unavailable" message.

The log has lines like this with cifsFYI g.t. 0:

CIFS VFS: No response to cmd 115 mid 2
fs/cifs/transport.c: marking request for retry
fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
fs/cifs/sess.c: ssetup rc from sendrecv2 is -11
CIFS VFS: Send error in SessSetup = -11

Thanks, Joe H.





      
