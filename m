From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [cifs bindaddr v3] cifs: Allow binding to local IP address.
Date: Wed, 1 Sep 2010 08:50:51 -0500
Message-ID: <AANLkTi=c2bHRqxS0OD0sHLU87NHDm9_ArvqphU2PQy9n@mail.gmail.com>
References: <1283284514-25588-1-git-send-email-greearb@candelatech.com>
	<20100901084147.4aa66e9d@corrin.poochiereds.net>
	<AANLkTi=hKNekX4_8RMm+OLvoPQahYHY-8iNm=ELFFPqS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=hKNekX4_8RMm+OLvoPQahYHY-8iNm=ELFFPqS-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 1, 2010 at 7:41 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> On Tue, 31 Aug 2010 12:55:14 -0700
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
<snip>
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KE=
RN_WARNING "cifs: "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0"Failed to bind to: %pI4, error: %d\n",
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0&saddr4->sin_addr.s_addr, rc);
> > + =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
> For better or worse, the CIFS code uses the cFYI and cERROR macros fo=
r
> printk's. You should probably do the same here.

This reminds me that as soon as we can figure out a good model/example =
of
file system code using dynamic trace points (and where to store their
definitions, presumably somewhere in the documentation area of
the kernel source tree) we could consider replacing the cFYIs eventuall=
y (it
will make debugging mount problems harder when we use dynamic trace
points since we sometimes have to have users turn on cifsFYI to find ou=
t
exactly which request a server is rejecting - and whether it is a serve=
r
or client issue - but it will make the module smaller).

--
Thanks,

Steve



--
Thanks,

Steve
