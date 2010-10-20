From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS} [1/3] NTLM auth & signing - Allocate session
 key/client response dynamically
Date: Wed, 20 Oct 2010 11:31:40 -0400
Message-ID: <20101020113140.62621cea@tlielax.poochiereds.net>
References: <1287533637-22367-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101020104539.5a17a03e@tlielax.poochiereds.net>
	<AANLkTin-t_=GKc3FNUZP_iiLFC-uK=608o8DOM8yRkvu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin-t_=GKc3FNUZP_iiLFC-uK=608o8DOM8yRkvu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 20 Oct 2010 10:15:27 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 20, 2010 at 9:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Tue, 19 Oct 2010 19:13:57 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
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
> >> Only after a very first smb session succeeds, it copy/make its
> >> session key, session key of smb connection. =A0This key stays with
> >> the smb connection throughout its life.
> >>
> >> The authentication response field within structure session_key
> >> is now dynamic. =A0Every authentication type allocates the respons=
e sized
> >> memory within its session structure and later frees it once the
> >> client response is sent and if session's session key becomes
> >> connetion's session key.
> >>
> >> ntlm/ntlmi authentication functions are rearranged. =A0A function
> >> named setup_ntlm_resp(), similar to setup_ntlmv2_resp(), replaces
> >> function cifs_calculate_session_key().
> >>
> >> size of CIFS_SESS_KEY_SIZE is changed to 16, to reflect the byte s=
ize
> >> of the key it holds.
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0 99 +++++++++++++++++++++++++-------=
---------------
> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 10 +----
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +++-
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 11 ++---
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 33 ++++++++++++++--
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0103 +++++++++++++++++++-----=
-------------------------
> >> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
> >> =A07 files changed, 137 insertions(+), 132 deletions(-)
> >>
> >
> > [...]
> >
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 18ee0ad..c374859 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -98,15 +98,9 @@ enum protocolEnum {
> >> =A0};
> >>
> >> =A0struct session_key {
> >> + =A0 =A0 char key[16];
> >> + =A0 =A0 char *response;
> > =A0 =A0 =A0 =A0^^^^^^^
> > =A0 =A0 =A0 =A0What's the point of keeping the key separate from th=
e response?
> > =A0 =A0 =A0 =A0If you'll always need to allocate memory for the res=
ponse, why
> > =A0 =A0 =A0 =A0not allocate the key too as part of the same allocat=
ion?
>=20
> The key (session key) is different than response.  We need both when
> generating signature.  The key is always fixed in size, 16 byte where=
as
> response can vary, 24 bytes long for ntlm, variable length for ntlmv2=
=2E
>=20

The key and response are separate pieces, sure but there's no reason
that they need to be allocated separately. That design decision is what
causes some of the special casing in later parts of the patch.

> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->server->srv_mutex);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_estab) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session_=
key.data,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->au=
th_key.data, ses->auth_key.len);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len =
=3D ses->auth_key.len;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_est=
ab =3D true;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=3D=
 RawNTLMSSP)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D =
16;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^=
^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Why is this special-=
cased here? Does the
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0auth_key have an inc=
orrect len field in the
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RawNTLMSSP case?
>=20
> I could take this out.  But for NTLMv2 within NTLMSSP, only key gets =
used
> in the signature, so for NTLMv2 in NTLMSSP (RawNTLMSSP), I do not eve=
n
> need to copy the response.
>=20

Again, the fact that these fields are separate seems to be causing a
lot of special-casing. That's generally a bad sign. I encourage you to
rethink this approach.

> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D =
ses->auth_key.len;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.resp=
onse =3D kmalloc(len, GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_key=
=2Eresponse) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_un=
lock(&server->srv_mutex);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cif=
s_setup_session_ret;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->session_k=
ey.response,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->aut=
h_key.response, len);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->session_k=
ey.key,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->aut=
h_key.key, 16);
> >
> > Hmmm...you're going to be freeing ses->auth_key.response below.
> > Wouldn't it make more sense to just "hand-off" the pointer to the
> > response field instead? For instance:
> >
> > =A0 =A0 =A0 =A0server->session_key.response =3D ses->auth_key.respo=
nse;
> > =A0 =A0 =A0 =A0ses->auth_key.response =3D NULL;
> > =A0 =A0 =A0 =A0ses->auth_key.len =3D 0;
> >
> > Then you don't have to deal with an error condition, etc...
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len =
=3D len;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_estab =3D=
 true;
>=20
> Only for the first session do we do this copy. For rest of the sessio=
ns,
> the auth_key response is freed.  So when we go to free response down =
here,
>=20
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
> >>
> >> @@ -3192,6 +3212,11 @@ int cifs_setup_session(unsigned int xid, st=
ruct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> >> =A0 =A0 =A0 }
> >>
> >> +cifs_setup_session_ret:
> >> + =A0 =A0 kfree(ses->auth_key.response);
>=20
> we have to do a check whether this respose for a that has become part
> of smb connection.
>=20

That's why you zero out the original pointer when you hand it off. The
kfree will be a no-op in that case. That will be far simpler and more
efficient then allocating more memory and copying it.

> >> + =A0 =A0 ses->auth_key.response =3D NULL;
> >> + =A0 =A0 ses->auth_key.len =3D 0;
> >> +
> >> =A0 =A0 =A0 return rc;
> >> =A0}
> >>
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index e35dc60..8bb4518 100644
> >> --- a/fs/cifs/sess.c
> >> +++ b/fs/cifs/sess.c
> >
> > [...]
> >
> >> @@ -785,16 +756,24 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EKEYREJECTED;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 resplen =3D CIFS_SESS_KEY_SIZE + CIFS_AU=
TH_RESP_SIZE;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bail out if key is too long */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len >
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->auth_key.data.krb5))=
 {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len > resplen) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos si=
gning key too long (%u bytes)",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->s=
esskey_len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOVERFLOW;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response =3D kmalloc(respl=
en, GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->auth_key.response) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos can'=
t allocate (%u bytes) memory",
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 resplen)=
;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.len =3D msg->sesskey_len=
;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.data.krb5, msg->dat=
a, msg->sesskey_len);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.response, msg->data=
, msg->sesskey_len);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0This looks questionable. Previously =
we had a fixed 40
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0byte field for the krb5 key (CIFS_SE=
SS_KEY_SIZE (24) +
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A016). Now, we have a 16 byte key and =
a 40-byte response field
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(CIFS_SESS_KEY_SIZE (16) + CIFS_AUTH=
_RESP_SIZE (24)),
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You're copying the data into the aut=
h_key.response but
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the auth_key.key seems to be unused.=
 Won't that mean
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that signing is broken?
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0I suppose you could copy the first 1=
6 bytes into the
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0key part and then stick the rest int=
o the response
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0field, but that seems sort of kludge=
y. It would make
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0more sense to have the session_key j=
ust be a length and
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a pointer to memory allocated off th=
e slab and do away
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0with the fixed-length key[16] field.
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Then when you want to access the key=
/response, just
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cast that pointer to a struct that h=
as the fields you
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0need.
>=20
> As I stated above, response and key can't be mixed.  At least for
> ntlm and ntlmv2 authentications.  For Kerberos signing, we would
> just use response and not the key.
>=20

Ok, but the signature functions don't seem to do that. They seem to do
this unconditionally:

    cifs_MD5_update(&context, server->session_key.key, 16);

=2E..since there's no way for them to know whether the key field is
actually valid or not.

In fact, the signing functions don't look correct either. You have two
functions for calculating the signature now (cifs_calculate_signature
and cifs_calc_signature2), but cifs_verify_signature only calls
cifs_calculate_signature. Shouldn't it call cifs_calc_signature2 when
that sort of key is in use?

Another idea to consider: It might be worthwhile to track the type of
key that you have in the session_key struct so that you don't have to
refer back to the TCP_Server_Info->secType field in order to determine
it.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
