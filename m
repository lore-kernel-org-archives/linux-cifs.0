From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/3 -v3] NTLM auth and sign - Allocate session
 key/client response dynamically
Date: Mon, 25 Oct 2010 13:13:44 -0400
Message-ID: <20101025131344.65779724@corrin.poochiereds.net>
References: <1287661375-6954-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101025121410.6a0aef5f@corrin.poochiereds.net>
	<AANLkTik0aRH9NcBjR0AGVgc5V-TwEsV3uMYJ_PhcqvD8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik0aRH9NcBjR0AGVgc5V-TwEsV3uMYJ_PhcqvD8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 25 Oct 2010 11:26:53 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Oct 25, 2010 at 11:14 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Thu, 21 Oct 2010 06:42:55 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Start calculating auth response within a session. =A0Move/Add pert=
inet
> >> data structures like session key, server challenge and ntlmv2_hash=
 in
> >> a session structure. =A0We should do the calculations within a ses=
sion
> >> before copying session key and response over to server data
> >> structures because a session setup can fail.
> >>
> >> Only after a very first smb session succeeds, it copy/make its
> >> session key, session key of smb connection. =A0This key stays with
> >> the smb connection throughout its life.
> >> sequence_number within server is set to 0x2.
> >>
> >> The authentication Message Authentication Key (mak) which consists
> >> of session key followed by client response within structure sessio=
n_key
> >> is now dynamic. =A0Every authentication type allocates the key + r=
esponse
> >> sized memory within its session structure and later either assigns=
 or
> >> frees it once the client response is sent and if session's session=
 key
> >> becomes connetion's session key.
> >>
> >> ntlm/ntlmi authentication functions are rearranged. =A0A function
> >> named setup_ntlm_resp(), similar to setup_ntlmv2_resp(), replaces
> >> function cifs_calculate_session_key().
> >>
> >> size of CIFS_SESS_KEY_SIZE is changed to 16, to reflect the byte s=
ize
> >> of the key it holds.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0113 ++++++++++++++++++++++++++++----=
-----------------
> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A09 +----
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +++-
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 11 ++---
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 18 +++++++-
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0107 +++++++++++++++++-------=
----------------------
> >> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
> >> =A07 files changed, 134 insertions(+), 137 deletions(-)
> >>
> >
> > [...]
> >
> >> @@ -3178,10 +3185,11 @@ int cifs_setup_session(unsigned int xid, s=
truct cifsSesInfo *ses,
> >> =A0 =A0 =A0 } else {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->server->srv_mutex);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_estab) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session_=
key.data,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->au=
th_key.data, ses->auth_key.len);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.resp=
onse =3D ses->auth_key.response;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.le=
n =3D ses->auth_key.len;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_est=
ab =3D true;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->sequence_number =
=3D 0x2;
> >
> > It looks like the sequence_number is protected by the Global_MidLoc=
k.
> > It's not held here. Are there potential races with setting this val=
ue
> > here?
> >
>=20
> Jeff, I do not think so.  This setting is happening only during the v=
ery first
> smb session setup for that smb connection. Rest of the smb sessions
> and subsequent smb traffic going on on that smb connection for all th=
e
> smb sessions ensues only after this step i.e. for signature calculati=
ons.
> So there is no resetting sequence_number by doing this.
> If signing is not enabled, this is not even an issue at all.
>=20

I'm not sure I follow...

The Global_MidLock is taken in the other places where this counter is
incremented. Why is it OK to set it here outside of that lock?

Isn't it possible for two session setups to proceed in parallel? If
not, what serializes them?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
