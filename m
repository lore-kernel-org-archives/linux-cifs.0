From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 5/8] ntlmv2/ntlmssp functions to either extract or
 create av pair/ti info blob
Date: Wed, 8 Sep 2010 17:59:38 -0400
Message-ID: <20100908175938.52894ad3@tlielax.poochiereds.net>
References: <1283921185-13114-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100908160930.53ff6208@tlielax.poochiereds.net>
	<AANLkTikNO=f9n0X34SPe7Z-BZDNRyvrN0Ng6X6G=GFah@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikNO=f9n0X34SPe7Z-BZDNRyvrN0Ng6X6G=GFah-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 8 Sep 2010 15:48:54 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Sep 8, 2010 at 3:09 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Tue, =A07 Sep 2010 23:46:25 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Attribue Value (AV) pairs or Target Info (TI) pairs are part of
> >> ntlmv2 authentication.
> >> Structure ntlmv2_resp had only definition for two av pairs.
> >> So removed it, and now allocation of av pairs is dynamic.
> >> For servers like Windows 7/2008, av pairs sent by server in
> >> challege packet (type 2 in the ntlmssp exchange/negotiation) can
> >> vary.
> >>
> >> Server sends them during ntlmssp negotiation. So when ntlmssp is u=
sed
> >> as an authentication mechanism, type 2 challenge packet from serve=
r
> >> has this information. =A0Pluck it and use the entire blob for
> >> authenticaiton purpose. =A0If user has not specified, extract
> >> (netbios) domain name from the av pairs which is used to calculate
> >> ntlmv2 hash. =A0Servers like Windows 7 are particular about the AV=
 pair
> >> blob.
> >>
> >> Servers like Windows 2003, are not very strict about the contents
> >> of av pair blob used during ntlmv2 authentication.
> >> So when security mechanism such as ntlmv2 is used (not ntlmv2 in n=
tlmssp),
> >> there is no negotiation and so genereate a minimal blob that gets
> >> used in ntlmv2 authentication as well as gets sent.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0 77 ++++++++++++++++++++++++++++++++=
++++++++++++++--
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 18 +++++++++++
> >> =A04 files changed, 93 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index 4772c4d..e53fbeb 100644
> >> --- a/fs/cifs/cifsencrypt.c
> >> +++ b/fs/cifs/cifsencrypt.c
> >> @@ -27,6 +27,7 @@
> >> =A0#include "md5.h"
> >> =A0#include "cifs_unicode.h"
> >> =A0#include "cifsproto.h"
> >> +#include "ntlmssp.h"
> >> =A0#include <linux/ctype.h>
> >> =A0#include <linux/random.h>
> >>
> >> @@ -263,6 +264,78 @@ void calc_lanman_hash(const char *password, c=
onst char *cryptkey, bool encrypt,
> >> =A0}
> >> =A0#endif /* CIFS_WEAK_PW_HASH */
> >>
> >> +/* This is just a filler for ntlmv2 type of security mechanisms.
> >> + * Older servers are not very particular about the contents of av=
 pairs
> >> + * in the blob and for sec mechs like ntlmv2, there is no negotia=
tion
> >> + * as in ntlmssp, so unless domain and server =A0netbios and dns =
names
> >> + * are specified, there is no way to obtain name. =A0In case of n=
tlmssp,
> >> + * server provides that info in type 2 challenge packet
> >> + */
> >> +
> > ^^^ nit: this blank line shouldn't be there
> >
> >> +static int
> >> +build_avpair_blob(struct cifsSesInfo *ses)
> >> +{
> >> + =A0 =A0 struct ntlmssp2_name *attrptr;
> >> +
> >> + =A0 =A0 ses->tilen =3D 2 * sizeof(struct ntlmssp2_name);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Why 2 here? This deserves a comment.
> >
> >> + =A0 =A0 ses->tiblob =3D kzalloc(ses->tilen, GFP_KERNEL);
> >> + =A0 =A0 if (!ses->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge target info allocat=
ion failure");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 }
> >> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses->tiblob;
> >> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> >> +
> >> + =A0 =A0 return 0;
> >> +}
> >> +
> >> +/* Server has provided av pairs/target info in the type 2 challen=
ge
> >> + * packet and we have plucked it and stored within smb connection=
=2E
> >> + * We parse that blob here to find netbios domain name to be used
> >> + * as part of ntlmv2 authentication, if not already specified on
> >> + * the command line
> >> + */
> >> +
> > ^^^^
> > nit: again, blank line not needed there
> >
> >> +static int
> >> +find_domain_name(struct cifsSesInfo *ses)
> >> +{
> >> + =A0 =A0 int rc =3D 0;
> >> + =A0 =A0 unsigned int attrsize;
> >> + =A0 =A0 unsigned int type;
> >> + =A0 =A0 unsigned char *blobptr;
> >> + =A0 =A0 struct ntlmssp2_name *attrptr;
> >> +
> >> + =A0 =A0 if (ses->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr =3D ses->tiblob;
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
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_=
AV_NB_DOMAIN_NAME) {
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
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
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
> >> + =A0 =A0 return rc;
> >> +}
> >> +
> >
> > I think the above function needs some bounds checking. What prevent=
s
> > the client from trying to access data past the end of the tiblob? I=
 see
> > no reference to the tilen in that function.
>=20
> Jeff, when a server provides AV pair blob in type 2 packet during
> ntlmssp negotiation, the last field is always supposed to be 0
> (I defined it as NTLMSSP_AV_EOL).
>=20
> Would a change like
>    while ((type =3D attrptr->type) !=3D NTLMSSP_AV_EOL) {
> be a good enough check?
>=20

No. There's no guarantee that the server is well-behaved here. What if
the last field isn't 0? That's at least a possible DoS attack vector if
someone can replace the server.

>=20
> >
> >
> >> =A0static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct n=
ls_table *nls_cp)
> >> =A0{
> >> @@ -334,10 +407,6 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses=
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
> >>
> >> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
> >> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
> >> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> >> index f5c78fb..dc90a36 100644
> >> --- a/fs/cifs/cifspdu.h
> >> +++ b/fs/cifs/cifspdu.h
> >> @@ -670,7 +670,6 @@ struct ntlmv2_resp {
> >> =A0 =A0 =A0 __le64 =A0time;
> >> =A0 =A0 =A0 __u64 =A0client_chal; /* random */
> >> =A0 =A0 =A0 __u32 =A0reserved2;
> >> - =A0 =A0 struct ntlmssp2_name names[2];
> >> =A0 =A0 =A0 /* array of name entries could follow ending in minimu=
m 4 byte struct */
> >> =A0} __attribute__((packed));
> >>
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index f5369e7..0621a72 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -1768,6 +1768,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *ser=
ver, struct smb_vol *volume_info)
> >> =A0 =A0 =A0 if (ses =3D=3D NULL)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto get_ses_fail;
> >>
> >> + =A0 =A0 ses->tilen =3D 0;
> >> + =A0 =A0 ses->tiblob =3D NULL;
> >> =A0 =A0 =A0 /* new SMB session uses our server ref */
> >> =A0 =A0 =A0 ses->server =3D server;
> >> =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6=
)
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index 0a57cb7..756f410 100644
> >> --- a/fs/cifs/sess.c
> >> +++ b/fs/cifs/sess.c
> >> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_are=
a, int bleft,
> >> =A0static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len=
,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 struct cifsSesInfo *ses)
> >> =A0{
> >> + =A0 =A0 unsigned int tioffset; /* challenge message target info =
area */
> >> + =A0 =A0 unsigned int tilen; /* challenge message target info are=
a length =A0*/
> >> +
> >> =A0 =A0 =A0 CHALLENGE_MESSAGE *pblob =3D (CHALLENGE_MESSAGE *)bcc_=
ptr;
> >>
> >> =A0 =A0 =A0 if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
> >> @@ -405,6 +408,20 @@ static int decode_ntlmssp_challenge(char *bcc=
_ptr, int blob_len,
> >> =A0 =A0 =A0 /* BB spec says that if AvId field of MsvAvTimestamp i=
s populated then
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 we must set the MIC field of the AUTHE=
NTICATE_MESSAGE */
> >>
> >> + =A0 =A0 ses->server->ntlmssp.server_flags =3D le32_to_cpu(pblob-=
>NegotiateFlags);
> >> +
> >> + =A0 =A0 tioffset =3D cpu_to_le16(pblob->TargetInfoArray.BufferOf=
fset);
> >> + =A0 =A0 tilen =3D cpu_to_le16(pblob->TargetInfoArray.Length);
> >> + =A0 =A0 ses->tilen =3D tilen;
> >> + =A0 =A0 if (ses->tilen) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D kmalloc(tilen, GFP_KERNE=
L);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge tar=
get info allocation failure");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->tiblob, =A0bcc_ptr + tioffse=
t, ses->tilen);
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 return 0;
> >> =A0}
> >>
> >> @@ -533,6 +550,7 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_le32(tmp =
- pbuffer);
> >> =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
> >> =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
> >> +
> >> =A0 =A0 =A0 return tmp - pbuffer;
> >> =A0}
> >>
> >
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
