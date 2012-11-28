From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: exec of files off cifs mounts can fail
Date: Wed, 28 Nov 2012 14:17:31 -0600
Message-ID: <CAH2r5mtoZ79xo2LFPsTzxPEYobYAfJ4LReOkKad4pzDrGdr+LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Discovered something interesting testing cifs.  When you mount cifs
with "user=your-username" instead of "username=your-username" you can
confuse mount about whether to allow executing files on the mount, at
least mount from util-linux 2.21.2 (libmount 2.21.0: selinux, debug)

Basically if you mount with "user=" this version of mount assumes it
is a non-root initiated mount and turns off exec (also sets nosuid and
nodev).  To workaround this if executing a program fails on a cifs
mount, you can mount specifying "username=" instead of "user=" or you
can simply append "exec" to the mount options.


-- 
Thanks,

Steve
