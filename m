From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server
 resources"
Date: Wed, 28 Sep 2011 15:54:04 -0400
Message-ID: <20110928155404.12b84af3@tlielax.poochiereds.net>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<4E82B4ED.4060107@suse.com>
	<20110928080622.5e30429b@corrin.poochiereds.net>
	<CAH2r5msGRvhahCXbAb8mj7c28qUzPxOB5dJjjyQFAZvQxZzY-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msGRvhahCXbAb8mj7c28qUzPxOB5dJjjyQFAZvQxZzY-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Sep 2011 13:27:33 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Sep 28, 2011 at 7:06 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Wed, 28 Sep 2011 11:17:25 +0530
> > Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> >
> >> On 09/28/2011 03:06 AM, Steve French wrote:
> >> > FYI - The cifs async write in 3.0 seems to exacerbate problems r=
unning
> >> > out of memory (apparently) on the Windows 7 system (running as a
> >> > server) after a large file copy to the server completes. =C2=A0 =
I have been
> >> > able to reproduce the same problem on Windows Vista Service Pack=
 2
> >> > (which is a good news/bad news story since my earlier testing on
> >> > Windows Vista showed hangs on some requests rather than returnin=
g out
> >> > of memory). =C2=A0Does not seem to be a problem with any of the =
Windows
> >> > server versions just Windows 7 and Vista so far.
> >>
> >> The last time when I encountered this, cifs client was reporting "=
Cannot
> >> allocate memory" a.k.a -ENOMEM error. But, it is actually a
> >> NT_STATUS_INSUFF_SERVER_RESOURCES error from Server being mapped t=
o
> >> -ENOMEM. I found this mapping confusing atleast initially. Is this
> >> mapping correct?
> >>
> >> Not sure do we have a POSIX equivalent of
> >> NT_STATUS_INSUFF_SERVER_RESOURCES? Should we map it to a error cod=
e that
> >> is more obvious?
> >>
> >
> > Maybe -EREMOTEIO ?
>=20
> The mapping of NT_STATUS_INSUFFICIENT_SERVER_RESOURCES to posix error
> ENOMEM appears to be correct for multiple reasons.  Windows itself ma=
ps it this
> way when mapping from NT STATUS to DOS errors. For example, on subseq=
uent
> requests, I see server returning DOS (!) error for error_no_memory on=
 some
> types of SMBs and NT error insufficient_server_resources on others.
>=20

I don't know...

ENOMEM has clear connotations -- it tells you the machine (client) is
unable to allocate memory. You might be able to stretch that to mean
that the client is unable to allocate some other resource, but in this
case it's the *server* not the client that's reporting the problem.

It seems probable that DOS error codes just lacked anything better for
this mapping. In our case though, -EREMOTEIO seems like a better
mapping as it makes it clear that it's the server that can't allocate
resources, not the client.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
