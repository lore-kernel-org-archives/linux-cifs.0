From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Samba POSIX ACL behavior
Date: Thu, 14 Nov 2013 12:14:01 -0600
Message-ID: <CAH2r5mtrYOqBG-tPeOqZBmnP+YuEZy1RAqz0iBz1HTPRb0d1Dw@mail.gmail.com>
References: <CAH2r5msH8qTago4G=-_PpAzPJaOxwPeRVL3E8qfowjqwiSo5LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msH8qTago4G=-_PpAzPJaOxwPeRVL3E8qfowjqwiSo5LA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, Nov 14, 2013 at 12:13 PM
Subject: Samba POSIX ACL behavior
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, Jeremy Allison
<jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>


> I recently encountered the following strange behavior as mentioned in
> this post from several years ago:
>
> https://lists.samba.org/archive/linux-cifs-client/2009-February/004079.html
>
> I'm currently running Ubuntu 12.04 LTS on desktop and server, so
> I took some time to try the latest packaged versions of Samba and
> the kernel to make sure that the issue had not yet been fixed.
>
> Client:  Ubuntu 12.04 LTS with Kernel 3.11.0-13-generic
> Server:  Ubuntu 12.04 LTS with Samba 3.6.20 and Kernel 3.5.0-43-generic
>
> I tried many other combinations and the behavior is the same.  It
> looks like setting default ACLs somehow interacts with the
> non-default ACLs and vice versa.

I tried this here to Samba 3.6 with slightly different results:
1) If I set both a default and non-default ACL that seems to work
2) but as you and Rob saw, if I setfacl a default ACL it removes the
non-default ACL
3) and if I setfacl a non-default ACL it removes the default ACL

So for case 2 and 3 the behavior is different than for a local file
system.  This may be a server bug.

For Samba 4 and Samba 4.2-pre (master) - I get an error not supported
on this infolevel 512 (Set POSIX ACL).

-- 
Thanks,

Steve



-- 
Thanks,

Steve
