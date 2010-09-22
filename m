From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH -v6 3/4] cifs NTLMv2/NTLMSSP define crypto hash
 functions and create and send keys needed for key exchange
Date: Tue, 21 Sep 2010 20:07:15 -0700
Message-ID: <20100921200715.2a2d0b9e@corrin.poochiereds.net>
References: <1284865355-16815-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100921105254.32574ba4@corrin.poochiereds.net>
	<AANLkTimqjBtVyB+xvtv5F5_qs333XiFQm+S=8Gh20+x2@mail.gmail.com>
	<20100921114049.75ab2ee8@corrin.poochiereds.net>
	<AANLkTikxqyK72=QcBPu1h-CmpiC+pg5AhVj=V4JRBqS-@mail.gmail.com>
	<20100921164257.3d67598f@corrin.poochiereds.net>
	<AANLkTimOJLuBxDQHPZJAUxR3ieeErzUyzXwSP=VPO-+_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimOJLuBxDQHPZJAUxR3ieeErzUyzXwSP=VPO-+_-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 21 Sep 2010 21:57:44 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Sep 21, 2010 at 6:42 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Tue, 21 Sep 2010 14:04:24 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> >
> >> > Right. I'm just not sure why we need a separate flag attached to=
 the
> >> > server struct for this. Why was the "first_time" mechanism not g=
ood
> >> > enough here? I see no reason why that wouldn't have worked for N=
TLMSSP
> >> > too.
> >>
> >> Jeff, I will investigate but at the first glance, it looks like
> >> first_ses is per smb session
> >> and not smb connection, not sure if that would be good enough for =
ntlmssp.
> >>
> >
> > first_time is set by is_first_ses_reconnect(). The comment on that
> > function says:
> >
> > =A0* Checks if this is the first smb session to be reconnected afte=
r
> > =A0* the socket has been reestablished (so we know whether to use v=
c 0).
> > =A0* Called while holding the cifs_tcp_ses_lock, so do not block
> >
> > ...which isn't entirely true, since this works even when there hasn=
't
> > been a reconnect. It just walks the list of sessions on a socket an=
d
> > sees if any of them are already established (that is, need_reconnec=
t
> > is false).
> >
> > So there is nominally a bug here -- sesInfoAlloc probably should se=
t
> > needs_reconnect to true. But since cifs_get_smb_ses doesn't stick t=
he
> > session on the server's list until after the session setup succeeds=
 the
> > first time, it doesn't really cause any problems.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> We probably ought to keep first_time or cphready per type of auth mec=
h
> since it is possible to have multiple smb sessions on the same connec=
tion using
> various kinds of authentication mechanisms.
>=20

Ok, but only one of them gets to set the actual session_key. The socket
is a "shared" resource of sorts and we need something that indicates
which session has the "right of way" to set the session_key. The thing
with traffic lights is that they only work if everyone agrees on which
ones to use. ;)

Your previous email sounded convincing that there is a potential race
there. I think you should work through the implications of that and
come up with a race-free scheme that fixes this. Don't just do it for
NTLMSSP though -- fix it for all the sectypes.

Cheers,
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
