From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: allow ntlmv2 ntlmssp authentication
Date: Wed, 7 Jul 2010 13:35:01 -0400
Message-ID: <20100707133501.5b354c24@tlielax.poochiereds.net>
References: <1278126963-16111-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100707072517.1446d70e@corrin.poochiereds.net>
	<AANLkTildpOmttZwCEHMiN9LRLaVuc01Srqe7UaEGu0hu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-N0cyB0Tf/z2923ynj/IuLw@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTildpOmttZwCEHMiN9LRLaVuc01Srqe7UaEGu0hu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 7 Jul 2010 11:52:16 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Jul 7, 2010 at 6:25 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Fri, =A02 Jul 2010 22:16:03 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> Have kept ntlmv1 ntlmssp as a default, ntlmv2 ntlmssp can
> >> be made default only by making code change.
> >>
> >>
> >> From 3d8a8960a6d164e2bacd2a4fc96456453042e049 Mon Sep 17 00:00:00 =
2001
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Date: Fri, 2 Jul 2010 21:54:51 -0500
> >> Subject: [PATCH] add ntlvm2 ntlmssp authentication
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0 48 ++++++++++++++++++++++++++++++++=
++++++++++++----
> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 ++
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 39 ++++++++++++++++++++++++=
+++++++++++++--
> >> =A04 files changed, 83 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index 847628d..ebfafec 100644
> >> --- a/fs/cifs/cifsencrypt.c
> >> +++ b/fs/cifs/cifsencrypt.c
> >> @@ -378,6 +378,44 @@ calc_exit_2:
> >> =A0 =A0 =A0 return rc;
> >> =A0}
> >>
> >> +static void
> >> +find_domain_name(struct cifsSesInfo *ses)
> >> +{
> >> + =A0 =A0 unsigned int attrsize;
> >> + =A0 =A0 unsigned int type;
> >> + =A0 =A0 unsigned char *blobptr;
> >> + =A0 =A0 struct ntlmssp2_name *attrptr;
> >> +
> >> + =A0 =A0 if (ses->server->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr =3D ses->server->tiblob;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blo=
bptr;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 while ((type =3D attrptr->type) !=3D 0) =
{
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advan=
ce attr type */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D attrptr->le=
ngth;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advan=
ce attr size */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D 0x2) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Magic numbers like this should be tu=
rned into names.
>=20
> Yes, will make the change.
>=20
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses=
->domainName) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 ses->domainName =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 kmalloc(attrptr->length + 1,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 if (!ses->domainName)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 return;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_from_ucs2(ses->domainName,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 (__le16 *)blobptr,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 attrptr->length,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 attrptr->length,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 load_nls_default(), false);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /=
* advance attr =A0value */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlm=
ssp2_name *) blobptr;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 return;
> >> +}
> >> +
> >
> > Is it possible that you'll need to pick other UCS2 fields than the
> > domain out of a NTLMSSP blob? If so, it might be better to turn the
> > above function into a "copy the field of type X out of the blob"
> > function.
>=20
> I have not seen enough responses where a server does not
> return a domain name field in the AV pairs it sends in type 2
> message of NTLMSSP protocol.
> NTLM v2 protocol is supposed to use server name in case of
> servers of with local accounts.  I will have to do some code
> changes and testing to determine whether authentication
> succeeds or not using server name instead of domain name
> returned in type 2 challenge packet.
>=20

Either way, I think it would be better to make this a generic routine
for pulling a field of type X out of the blob. I imagine other fields
in there will eventually be useful and making a toolkit for this sort
of thing will make it easier to expand on your work.
> >
> >> =A0void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nl=
s_cp)
> >> =A0{
> >> @@ -390,10 +428,9 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses=
, char *resp_buf,
> >> =A0 =A0 =A0 buf->time =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TI=
ME));
> >> =A0 =A0 =A0 get_random_bytes(&buf->client_chal, sizeof(buf->client=
_chal));
> >> =A0 =A0 =A0 buf->reserved2 =3D 0;
> >> - =A0 =A0 buf->names[0].type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> >> - =A0 =A0 buf->names[0].length =3D 0;
> >> - =A0 =A0 buf->names[1].type =3D 0;
> >> - =A0 =A0 buf->names[1].length =3D 0;
> >> +
> >> + =A0 =A0 if (!ses->domainName)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 find_domain_name(ses);
> >>
> >> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
> >> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
> >> @@ -421,6 +458,9 @@ void CalcNTLMv2_response(const struct cifsSesI=
nfo *ses,
> >>
> >> =A0 =A0 =A0 hmac_md5_update(v2_session_response+8,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_r=
esp) - 8, &context);
> >> + =A0 =A0 if (ses->server->tilen)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->server->tiblob,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen, &con=
text);
> >>
> >> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
> >> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32);=
 */
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 3c55e10..db6c5da 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -188,6 +188,8 @@ struct TCP_Server_Info {
> >> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from=
 this server */
> >> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
> >> =A0 =A0 =A0 /* extended security flavors that server supports */
> >> + =A0 =A0 unsigned int tilen; /* length of the target info blob */
> >> + =A0 =A0 unsigned char *tiblob; /* target info blob in challenge =
response */
> >
> > All of this is for NTLMSSP session setup, correct? If so, is the
> > TCP_Server_Info really the right place for this? Will this break if=
 I
> > have more than one session on the same socket?
>=20
> I think it will not break authentication but will break signing (and
> perhaps sealing).
> What would be a good place to hang is per session, per user informati=
on?
>=20

Per session sounds right to me. IIUC, the first session on the socket
sets the signing key.

> >> @@ -451,10 +466,12 @@ static int build_ntlmssp_auth_blob(unsigned =
char *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
const struct nls_table *nls_cp, bool first)
> >> =A0{
> >> + =A0 =A0 unsigned int size;
> >> =A0 =A0 =A0 AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSA=
GE *)pbuffer;
> >> =A0 =A0 =A0 __u32 flags;
> >> =A0 =A0 =A0 unsigned char *tmp;
> >> =A0 =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZE];
> >> + =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
> >>
> >> =A0 =A0 =A0 memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
> >> =A0 =A0 =A0 sec_blob->MessageType =3D NtLmAuthenticate;
> >> @@ -477,6 +494,7 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.Length =3D 0;
> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.MaximumLength =3D 0;
> >>
> >> +#if 1
> > =A0^^^^^^^
> > Why are you adding code that's always compiled out?
>=20
> Right now we are using ntlmv1 as a default authentication mechanism i=
n NTLMSSP.
> I am not sure whether we can just switch to ntlmv2 as an
> authentication mechanism.
> I think in case of Windows servers, an LmCompatibilityLevel registry
> setting of 0 through 5
> will accept NTLMv2 response but not sure how it is handled by other
> servers i.e. are
> there servers out there who will/can't handle ntlmv2 authentication
> mechanism within
> NTLMSSP.
>=20

Ok, just to be clear -- NAK on this patch as it stands now. Please do
not add code to the kernel that's just commented out. It's confusing
and leads to maintenance headaches.

Either this is ready for merge, in which case you should just replace
the old code or it's not.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
