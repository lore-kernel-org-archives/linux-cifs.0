From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/4] NTLM authentication and signing -
 Calculate auth response per smb session
Date: Wed, 13 Oct 2010 13:03:45 -0400
Message-ID: <20101013130345.41bb7e85@corrin.poochiereds.net>
References: <1286912703-22661-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101013083642.74d9b8a9@corrin.poochiereds.net>
	<AANLkTik_bqHOsOn1UpgWECu-x=cZgVKUt4HAgWRi-z7W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik_bqHOsOn1UpgWECu-x=cZgVKUt4HAgWRi-z7W-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Oct 2010 10:28:25 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 13, 2010 at 7:36 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Tue, 12 Oct 2010 14:45:03 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Start calculation auth response within a session. =A0Move/Add pert=
inet
> >> data structures like session key, server challenge and ntlmv2_hash=
 in
> >> a session structure. =A0We should do the calculations within a ses=
sion
> >> before copying session key and response over to server data
> >> structures because a session setup can fail.
> >>
> >> Only after a very first smb session succeeds, it copies/makes its
> >> session key, session key of smb connection. =A0This key stays with
> >> the smb connection throughout its life.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> >
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
> >> @@ -3175,6 +3176,15 @@ int cifs_setup_session(unsigned int xid, st=
ruct cifsSesInfo *ses,
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in SessSetup =3D=
 %d", rc);
> >> =A0 =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->server->srv_mutex);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_estab) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session_=
key.data,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->au=
th_key.data, ses->auth_key.len);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len =
=3D ses->auth_key.len;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_est=
ab =3D true;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nit: Aren't "server"=
 and "ses->server" the
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0same? Why access the=
m differently here?
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
> >> +
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0What are the rules for locking aroun=
d the session_estab
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flag? Here you're holding the srv_mu=
tex when checking
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and altering it, but in cifs_reconne=
ct you're altering
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0it without holding the mutex. Is tha=
t a potential race
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0condition?
>=20
> Jeff, I do not think it is a potential race.  In cifs_reconnect, by t=
he
> time session_estab is set as false, all the sessions have been
> invalidated and socket connection has been taken down
> and restablished. Isn't that as good as new connection?
> Setting session_estab under srv_mutex is mainly to prevent
> newly established sessions from racing.
>=20

You may be right, but I don't immediately see what prevents the
following scenario:

The sessions have been invalidated in cifs_reconnect and we're making
our way down to the point where that flag is set to false.

Another task then calls smb_init to issue a new call, notices that the
session is invalid and reconnects it.

This succeeds, but cifs_reconnect isn't done yet. session_estab is
still true. The session setup code takes the mutex and then checks and
finds that the flag is still true so it doesn't copy the key.

Eventually cifs_reconnect flips the flag to false (maybe even while
we're holding the mutex) but now we're borked. We have a valid session
on the socket but the key is likely to be wrong.

This is admittedly unlikely, and maybe impossible, but we should
understand what makes it impossible before we wave our hands and say
there's no race.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
