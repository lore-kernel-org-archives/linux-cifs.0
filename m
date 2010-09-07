From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] extract or create av pair blob and free it - during
 first session setup
Date: Tue, 7 Sep 2010 09:00:08 -0400
Message-ID: <20100907090008.74ad80a6@corrin.poochiereds.net>
References: <1283830497-25086-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907075648.007c4e1e@corrin.poochiereds.net>
	<AANLkTi=FMm-fYhBcZbCxwWQ=LejdYahDM=E5RUWg62sy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=FMm-fYhBcZbCxwWQ=LejdYahDM=E5RUWg62sy-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 7 Sep 2010 07:52:09 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Sep 7, 2010 at 6:56 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Mon, =A06 Sep 2010 22:34:57 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0 68 ++++++++++++++++++++++++++++++++=
+++++++++++++---
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +-
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 24 ++++++++++++++++-
> >> =A05 files changed, 88 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index fe1e4c9..5f0fc6b 100644
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
> >> @@ -263,6 +264,56 @@ void calc_lanman_hash(const char *password, c=
onst char *cryptkey, bool encrypt,
> >> =A0}
> >> =A0#endif /* CIFS_WEAK_PW_HASH */
> >>
> >> +static int
> >> +find_domain_name(struct cifsSesInfo *ses)
> >> +{
> >> + =A0 =A0 int rc =3D 0;
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
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0Doesn't
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0"load_nls_default" need
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0an "unload_nls" when
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0you're done with it?
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /=
* advance attr =A0value */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlm=
ssp2_name *) blobptr;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 2 * sizeof(struct=
 ntlmssp2_name);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tiblob =3D kmalloc(ses->ser=
ver->tilen, GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 0=
;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge tar=
get info allocation failure");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memset(ses->server->tiblob, 0x0, ses->se=
rver->tilen);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0This memset can be eliminated if you=
 use kzalloc
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0instead.
>=20
> OK, will change the call.
>=20
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses=
->server->tiblob;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DO=
MAIN_TYPE);
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 return rc;
> >> +}
> >> +
> >
> > A comment describing what the above function is intended to do woul=
d be
> > nice. I can sort of guess that it's intended to parse the domain na=
me
> > out of one of the NTLMSSP blobs, but I don't quite understand what =
the
> > stuff in the big "else" clause is for. Why allocate the buffer for =
the
> > tiblob in "find_domain_name" ? It seems like that ought to be done =
in a
> > more well-defined fashion.
>=20
> Because av pairs were removed from struct ntlmv2_resp, if we are usin=
g a
> a non ntlmssp sec mech e.g. sec=3Dntlmv2/ntlmv2i, the very same tiblo=
b is
> created as it was done before.  Servers like Windows 2003 are not ver=
y
> particular about this blob and so this blob does not need all the Tar=
get Info/
> AV pairs such as dns/netbios names of the domain and server, timestam=
p etc.
> But you need that (else part) blob nonetheless for sec=3Dntlmv2i like=
 of security
> mech options.
>=20
> >
> >> =A0static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct n=
ls_table *nls_cp)
> >> =A0{
> >> @@ -322,7 +373,8 @@ calc_exit_2:
> >> =A0 =A0 =A0 return rc;
> >> =A0}
> >>
> >> -void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
> >> +int
> >> +setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nl=
s_cp)
> >> =A0{
> >> =A0 =A0 =A0 int rc;
> >> @@ -334,10 +386,14 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *se=
s, char *resp_buf,
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
> >> + =A0 =A0 if (!ses->domainName) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D find_domain_name(ses);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get=
 domain/server name rc %d", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 }
> >>
> >> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
> >> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
> >> @@ -353,6 +409,8 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses,=
 char *resp_buf,
> >> =A0 =A0 =A0 memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp,=
 resp_buf,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
> >> =A0 =A0 =A0 ses->server->mac_signing_key.len =3D 16 + sizeof(struc=
t ntlmv2_resp);
> >> +
> >> + =A0 =A0 return rc;
> >> =A0}
> >>
> >> =A0void CalcNTLMv2_response(const struct cifsSesInfo *ses,
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
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index f3ffa69..ccc6d57 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -368,7 +368,7 @@ extern int cifs_calculate_mac_key(struct sessi=
on_key *key, const char *rn,
> >> =A0extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table=
 *);
> >> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *, cha=
r *);
> >> -extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> >> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struc=
t nls_table *);
> >> =A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *)=
;
> >> =A0extern void cifs_crypto_shash_release(struct TCP_Server_Info *)=
;
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index f5369e7..47b51eb 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -1580,6 +1580,8 @@ cifs_get_tcp_session(struct smb_vol *volume_=
info)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not setup hash struct=
ures rc %d", rc);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> >> =A0 =A0 =A0 }
> >> + =A0 =A0 tcp_ses->tilen =3D 0;
> >> + =A0 =A0 tcp_ses->tiblob =3D NULL;
> >>
> >> =A0 =A0 =A0 tcp_ses->hostname =3D extract_hostname(volume_info->UN=
C);
> >> =A0 =A0 =A0 if (IS_ERR(tcp_ses->hostname)) {
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index 0a57cb7..6551b17 100644
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
> >> + =A0 =A0 ses->server->tilen =3D tilen;
> >> + =A0 =A0 if (tilen) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tiblob =3D kmalloc(tilen, G=
=46P_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->tiblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge tar=
get info allocation failure");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->tiblob, =A0bcc_ptr +=
 tioffset, tilen);
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 return 0;
> >> =A0}
> >>
> >> @@ -533,6 +550,10 @@ static int build_ntlmssp_auth_blob(unsigned c=
har *pbuffer,
> >> =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_le32(tmp =
- pbuffer);
> >> =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
> >> =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
> >> +
> >> + =A0 =A0 if (ses->server->tilen > 0)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->server->tiblob);
> >> +
> >
> > I'm not sure I get this...why are you freeing the blob if tilen is =
0?
> > That seems like you could end up with a leak in corner cases. Why n=
ot
> > just unconditionally kfree it and make sure it's set to NULL if the=
re
> > is no buffer?
>=20
> Not ure I get it, freeing it only if tilen is greater than 0 i.e. we
> did allocate
> the blob.
>=20

Is it possible for tilen to end up being set to 0, and the tiblob to be
a valid pointer? If so, then this buffer will be leaked here. Right?

> >
> >> =A0 =A0 =A0 return tmp - pbuffer;
> >> =A0}
> >>
> >> @@ -729,8 +750,7 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(str=
uct ntlmv2_resp));
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlmv2_rsp(ses, v2_sess_key, nls_c=
p);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: calculate MAC key */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_key=
, nls_cp);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
> > You're getting the return code from this function now, but it'll ju=
st
> > get clobbered when SendReceive2 is called. What's the point? Should=
n't
> > you do something different if it comes back with an error? What's g=
oing
> > to happen if find_domain_name fails and the session setup call proc=
eeds?
>=20
> In that case, authentication would fail.
>=20

So why not return with a valid error code instead of leaving us
wondering what the heck went wrong?

> >
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)v2_sess_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_re=
sp));
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D sizeof(struct ntlmv2_resp=
);
> >
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
