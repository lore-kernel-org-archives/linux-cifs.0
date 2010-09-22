From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH -v6 3/4] cifs NTLMv2/NTLMSSP define crypto hash
 functions and create and send keys needed for key exchange
Date: Wed, 22 Sep 2010 13:52:42 -0700
Message-ID: <20100922135242.42e58426@corrin.poochiereds.net>
References: <1284865355-16815-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100921105254.32574ba4@corrin.poochiereds.net>
	<AANLkTimqjBtVyB+xvtv5F5_qs333XiFQm+S=8Gh20+x2@mail.gmail.com>
	<20100921114049.75ab2ee8@corrin.poochiereds.net>
	<AANLkTikxqyK72=QcBPu1h-CmpiC+pg5AhVj=V4JRBqS-@mail.gmail.com>
	<20100921164257.3d67598f@corrin.poochiereds.net>
	<AANLkTimOJLuBxDQHPZJAUxR3ieeErzUyzXwSP=VPO-+_@mail.gmail.com>
	<20100921200715.2a2d0b9e@corrin.poochiereds.net>
	<AANLkTinpO_pNz5JQTx9mRAE+HSaWeasMtmTzM6+OfE4Z@mail.gmail.com>
	<20100921204034.5cb9eca5@corrin.poochiereds.net>
	<AANLkTinU50DqmH_C74vS_N_U-EU9RN4DMtSMA9osA6v2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinU50DqmH_C74vS_N_U-EU9RN4DMtSMA9osA6v2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 22 Sep 2010 15:42:16 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Sep 21, 2010 at 10:40 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Tue, 21 Sep 2010 22:20:21 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Sep 21, 2010 at 10:07 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =
wrote:
> >> > On Tue, 21 Sep 2010 21:57:44 -0500
> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> On Tue, Sep 21, 2010 at 6:42 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org=
> wrote:
> >> >> > On Tue, 21 Sep 2010 14:04:24 -0500
> >> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >
> >> >> >> >
> >> >> >> > Right. I'm just not sure why we need a separate flag attac=
hed to the
> >> >> >> > server struct for this. Why was the "first_time" mechanism=
 not good
> >> >> >> > enough here? I see no reason why that wouldn't have worked=
 for NTLMSSP
> >> >> >> > too.
> >> >> >>
> >> >> >> Jeff, I will investigate but at the first glance, it looks l=
ike
> >> >> >> first_ses is per smb session
> >> >> >> and not smb connection, not sure if that would be good enoug=
h for ntlmssp.
> >> >> >>
> >> >> >
> >> >> > first_time is set by is_first_ses_reconnect(). The comment on=
 that
> >> >> > function says:
> >> >> >
> >> >> > =A0* Checks if this is the first smb session to be reconnecte=
d after
> >> >> > =A0* the socket has been reestablished (so we know whether to=
 use vc 0).
> >> >> > =A0* Called while holding the cifs_tcp_ses_lock, so do not bl=
ock
> >> >> >
> >> >> > ...which isn't entirely true, since this works even when ther=
e hasn't
> >> >> > been a reconnect. It just walks the list of sessions on a soc=
ket and
> >> >> > sees if any of them are already established (that is, need_re=
connect
> >> >> > is false).
> >> >> >
> >> >> > So there is nominally a bug here -- sesInfoAlloc probably sho=
uld set
> >> >> > needs_reconnect to true. But since cifs_get_smb_ses doesn't s=
tick the
> >> >> > session on the server's list until after the session setup su=
cceeds the
> >> >> > first time, it doesn't really cause any problems.
> >> >> >
> >> >> > --
> >> >> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> >> >
> >> >>
> >> >> We probably ought to keep first_time or cphready per type of au=
th mech
> >> >> since it is possible to have multiple smb sessions on the same =
connection using
> >> >> various kinds of authentication mechanisms.
> >> >>
> >> >
> >> > Ok, but only one of them gets to set the actual session_key. The=
 socket
> >> > is a "shared" resource of sorts and we need something that indic=
ates
> >> > which session has the "right of way" to set the session_key. The=
 thing
> >> > with traffic lights is that they only work if everyone agrees on=
 which
> >> > ones to use. ;)
> >> >
> >>
> >> I am not sure traffic light analogy will work. =A0I think signing =
for session
> >> with sec=3Dntlmsspi will fail if sec=3Dntlmv2i happend to be very =
first session
> >> on that smb connect and has set up the session key.
> >> The keys are different, stored in different locations, and the sch=
eme is
> >> different i.e. the key sizes that go in the signing are different =
sizes.
> >>
> >
> > Do you know this for a fact? My understanding is different than thi=
s.
> > AFAIU, the session_key is simply set by the first SESSION_SETUP
> > performed on the socket. If the first one uses plain NTLM and then =
a
> > later one uses krb5, then the socket uses the key from the NTLM set=
up
> > for signing even if the krb5 session had a bigger key.
> >
> > Now, in point of fact, the client doesn't currently mix sectypes on=
 a
> > socket, so the argument is somewhat moot. If there are races with t=
he
> > first_time flag however (and I think that you're correct that there
> > are), then they should be fixed.
> >
> >> > Your previous email sounded convincing that there is a potential=
 race
> >> > there. I think you should work through the implications of that =
and
> >> > come up with a race-free scheme that fixes this. Don't just do i=
t for
> >> > NTLMSSP though -- fix it for all the sectypes.
> >> >
> >>
> >> The scope of this patch was deemed ntlmv2 within NTLMSSP
> >> authentication and signing.
> >> I do not have a setup for kerberos testing on Samba as well as Win=
dows
> >> server as of now.
> >>
> >
> > That's fine, a separate patch will do. My suggestion would be to do=
 an
> > initial cleanup patch that eliminates the first_time flag and switc=
hes
> > it to use your new scheme or something similarly non-racy, and then=
 to
> > respin patches 3 and 4 in your set as a new set on top of that.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
> Is this correct? Every auth type gets its own smb connection (in matc=
h
> security)?
> We probably do not need that check (and functionality).
>=20

Yep, that's correct. Note that the secType is a per-server parameter
right now.

We could mix sectypes on a socket. I sent a patchset that did that this
past spring, but Steve basically NAK'ed it. IIRC, he wanted to allow
the sec=3D option to take an ordered list of sectypes and I didn't see
any way to do that sanely.

After that I backed off and left that more or less as is, but fixed it
so that socket selection takes the secType into account (hence the
match_security function).

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
