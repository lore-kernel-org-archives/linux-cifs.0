From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Samba] mount.cifs gives error 13 after changing servers --
 hidden cache??
Date: Mon, 20 Feb 2012 11:24:55 -0500
Message-ID: <20120220112455.6f7eb1cc@tlielax.poochiereds.net>
References: <CA+V+_PbaT9DZ+Yyx6on6_6Ja_j-vg17R=yBwHj3Cr0CkYiu5yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Digit Ijit <digitijit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+V+_PbaT9DZ+Yyx6on6_6Ja_j-vg17R=yBwHj3Cr0CkYiu5yA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 15 Feb 2012 13:23:06 -0600
Digit Ijit <digitijit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> A sysadmin moved a share from one Windows server to another.  I am now
> getting error 13 when trying to mount the share from the new server.
> 
> The following worked before the server was replaced:
> 
> mount.cifs //ipaddress1/share1$ /mnt/share1 -o
> credientials/home/whatever/.smbcredentials,rw
> mount.cifs //ipaddress2/share2$ /mnt/share2 -o
> credientials/home/whatever/.smbcredentials,ro
> 
> Change: server ipaddress2 was replaced with server ipaddress3 and share2$
> was created on that server.
> 
> mount.cifs //ipaddress1/share1$ /mnt/share1 -o
> credientials/home/whatever/.smbcredentials,rw
> Still works!
> mount.cifs //ipaddress3/share2$ /mnt/share2 -o
> credientials/home/whatever/.smbcredentials,ro
> FAILS with mount error(13): Permission denied
> 
> However, I can browse to //ipaddress3/share2$ using nautilus, and it is
> also accessible from any Windows box on the network!  This problem looks
> similar to
> lists.samba.org/archive/samba/2011-June/162704.html.  Clearly, mount.cifs
> seems to cache information somewhere.  I have looked through /etc, /lib,
> /var and /proc for any evidence that ipaddress2 was cached, but cannot find
> anything.  Any tips on how to solve this problem?
> 
> Thanks!

No, mount.cifs doesn't cache anything. It's more likely that the server
is just rejecting the authentication for some reason. mount.cifs
generally just passes the username and password to the kernel, so the
problem is likely there...

What kernel are you using on the client here, and what version of
cifs-utils do you have?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
