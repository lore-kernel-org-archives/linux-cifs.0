From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP
 authentication [try #3]
Date: Fri, 10 Dec 2010 08:39:13 -0500
Message-ID: <20101210083913.284eb5f7@tlielax.poochiereds.net>
References: <1291917491-5924-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101209162709.57cc5019@tlielax.poochiereds.net>
	<AANLkTikasjUoVLk_vGKB=or7LvMkCf+AOa0QQzR=EEuo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikasjUoVLk_vGKB=or7LvMkCf+AOa0QQzR=EEuo-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 10 Dec 2010 07:07:23 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Dec 9, 2010 at 3:27 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Thu, =A09 Dec 2010 11:58:11 -0600
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Indicate to the server a capability of NTLM2 session security (NTL=
M2 Key)
> >> during ntlmssp protocol exchange in one of the bits of the flags f=
ield.
> >> If server supports this capability, send NTLM2 key even if signing=
 is not
> >> required on the server.
> >>
> >> If the server requires signing, the session keys exchanged for NTL=
Mv2
> >> and NTLM2 session security in auth packet of the nlmssp exchange a=
re same.
> >>
> >> Send the same flags in authenticate message (type 3) that client s=
ent in
> >> negotiate message (type 1).
> >>
> >>
> >> Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/sess.c | =A0 13 +++++++------
> >> =A01 files changed, 7 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index 7b01d3f..ea39f3f 100644
> >> --- a/fs/cifs/sess.c
> >> +++ b/fs/cifs/sess.c
> >> @@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(unsig=
ned char *pbuffer,
> >> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use =
here? */
> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_TA=
RGET |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIA=
TE_EXTENDED_SEC;
> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED=
 | SECMODE_SIGN_ENABLED)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> @@ -446,7 +446,7 @@ static void build_ntlmssp_negotiate_blob(unsig=
ned char *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSS=
P_NEGOTIATE_EXTENDED_SEC;
> >> =A0 =A0 =A0 }
> >>
> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
> >>
> >
> > Your earlier emails about seeing the POISON_INUSE value in this str=
uct
> > worry me a bit. Maybe we ought to zero out the sec_blob before use?
> >
> > These aren't exactly hot codepaths so we can afford to do a little
> > defensive coding here. Ditto for this buffer in the other phases of
> > NTLMSSP negotiation too.
> >
> > Thoughts?
> >
> >> =A0 =A0 =A0 sec_blob->WorkstationName.BufferOffset =3D 0;
> >> =A0 =A0 =A0 sec_blob->WorkstationName.Length =3D 0;
> >> @@ -477,7 +477,7 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOT=
IATE_TARGET_INFO |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIA=
TE_EXTENDED_SEC;
> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> @@ -485,7 +485,7 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_ALWAYS_SI=
GN;
> >>
> >> =A0 =A0 =A0 tmp =3D pbuffer + sizeof(AUTHENTICATE_MESSAGE);
> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
> >>
> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.BufferOffset =3D
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to=
_le32(sizeof(AUTHENTICATE_MESSAGE));
> >> @@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
> >> =A0 =A0 =A0 tmp +=3D 2;
> >>
> >> - =A0 =A0 if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_=
XCH) &&
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses)) {
> >> + =A0 =A0 if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY=
_XCH) ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (ses->ntlmssp->server_flags & NTLMSSP_NE=
GOTIATE_EXTENDED_SEC))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !calc_seckey(ses)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->ntlmssp->ciphertext, =
CIFS_CPHTXT_SIZE);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D =
cpu_to_le32(tmp - pbuffer);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu_to=
_le16(CIFS_CPHTXT_SIZE);
> >
> >
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> Yes. I think that would be safe thing to do.  I will look into
> wireshark trace again
> just to see what other fields contained POISON_INUSE  besides flags f=
ield
> when either of the requests (type 1 and type 3 of ntlmssp exchange) w=
ere
> sent (such as session key) and resubmit this patch as well.
> This  code gets called may be once per smb connection so it does not
> get exercised often, as you stated.
>=20

We have to consider that wherever you see POISON_INUSE, it could just
as easily be leftover data from earlier use of the page. We really need
to take great care not to stick unintialized data out on the wire.
There's no telling what it might contain.

It may even be best to just to memset all buffers to zero in smb_init
and small_smb_init. Those functions look like they do part of the
buffer now, but it seems a little dangerous to leave the rest unset.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
