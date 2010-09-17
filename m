From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH -v5 2/4] cifs NTLMv2/NTLMSSP ntlmv2 within ntlmssp
 autentication code
Date: Fri, 17 Sep 2010 10:54:53 -0400
Message-ID: <20100917105453.7689e34e@tlielax.poochiereds.net>
References: <1284616023-9264-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100917101955.5814487c@tlielax.poochiereds.net>
	<AANLkTi=uoBbm=5Y2tU3zx=UNZJ9sGXugHCMkpr0BRLYd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=uoBbm=5Y2tU3zx=UNZJ9sGXugHCMkpr0BRLYd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Sep 2010 09:46:51 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Sep 17, 2010 at 9:19 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Thu, 16 Sep 2010 00:47:03 -0500
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
> >> Fields tilen, tilbob, and tidomain are session specific.
> >> AV pair values are defined.
> >> tidomain is used to figure out whether domainName field of smb ses=
sion
> >> was allocated during ntlmssp exchange. If it was, then it gets fre=
ed
> >> once (netbios) domain name is used as a part of ntlmv2 hash calcul=
ation
> >> and then as a part of ntlmv2 ntlmssp response.
> >>
> >> To calculate ntlmv2 response we need ti/av pair blob.
> >>
> >> For sec mech like ntlmssp, the blob is plucked from type 2 respons=
e from
> >> the server. =A0From this blob, netbios name of the domain is retri=
eved,
> >> if user has not already provided, to be included in the Target Str=
ing
> >> as part of ntlmv2 hash calculations.
> >>
> >> For sec mech like ntlmv2, create a minimal, two av pair blob.
> >>
> >> The allocated blob is freed in case of error. =A0In case there is =
no error,
> >> this blob is used in calculating ntlmv2 response (in CalcNTLMv2_re=
sponse)
> >> and is also copied on the response to the server, and then freed.
> >>
> >> The type 3 ntlmssp response is prepared on a buffer,
> >> 5 * sizeof of struct _AUTHENTICATE_MESSAGE, an empirical value lar=
ge
> >> enough to hold _AUTHENTICATE_MESSAGE plus a blob with max possible
> >> 10 values as part of ntlmv2 response and lmv2 keys and domain, use=
r,
> >> workstation =A0names etc.
> >>
> >> Also, kerberos gets selected as a default mechanism if server supp=
orts it,
> >> over the other security mechanisms.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0127 ++++++++++++++++++++++++++++++++=
++++++++++++++--
> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A03 +
> >> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +-
> >> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 16 ++++---
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A03 +
> >> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 15 ++++++
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0127 ++++++++++++++++++++++++=
++++++++++---------------
> >> =A08 files changed, 241 insertions(+), 53 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index eed70ca..6cf58c0 100644
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
> >> @@ -262,6 +263,88 @@ void calc_lanman_hash(const char *password, c=
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
> >> +static int
> >> +build_avpair_blob(struct cifsSesInfo *ses)
> >> +{
> >> + =A0 =A0 struct ntlmssp2_name *attrptr;
> >> +
> >> + =A0 =A0 ses->tilen =3D 2 * sizeof(struct ntlmssp2_name);
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
> >> + * packet and we have plucked it and stored within smb session.
> >> + * We parse that blob here to find netbios domain name to be used
> >> + * as part of ntlmv2 authentication (in Target String), if not al=
ready
> >> + * specified on the command line.
> >> + * If this function returns without any error but without fetchin=
g
> >> + * domain name, authentication may fail against some server but
> >> + * may not fail against other (those who are not very particular
> >> + * about target string i.e. for some, just user name might suffic=
e.
> >> + */
> >> +static int
> >> +find_domain_name(struct cifsSesInfo *ses)
> >> +{
> >> + =A0 =A0 unsigned int attrsize;
> >> + =A0 =A0 unsigned int type;
> >> + =A0 =A0 unsigned int onesize =3D sizeof(struct ntlmssp2_name);
> >> + =A0 =A0 unsigned char *blobptr;
> >> + =A0 =A0 unsigned char *blobend;
> >> + =A0 =A0 struct ntlmssp2_name *attrptr;
> >> +
> >> + =A0 =A0 if (!ses->tilen || !ses->tiblob)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> +
> >> + =A0 =A0 blobptr =3D ses->tiblob;
> >> + =A0 =A0 blobend =3D ses->tiblob + ses->tilen;
> >> +
> >> + =A0 =A0 while (blobptr + onesize < blobend) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blo=
bptr;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 type =3D le16_to_cpu(attrptr->type);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV_EOL)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance attr type */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D le16_to_cpu(attrptr->length=
);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance attr size */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (blobptr + attrsize > blobend)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV_NB_DOMAIN_NAM=
E) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!attrsize)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->dom=
ainName =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 kmalloc(attrsize + 1, GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses=
->domainName)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_fro=
m_ucs2(ses->domainName,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 (__le16 *)blobptr, attrsize, attrsize,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 load_nls_default(), false);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tid=
omain =3D true;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /* advance attr =A0=
value */
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 return 0;
> >> +}
> >> +
> >> =A0static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct n=
ls_table *nls_cp)
> >> =A0{
> >> @@ -321,7 +404,8 @@ calc_exit_2:
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
> >> @@ -333,15 +417,29 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *se=
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
> >> + =A0 =A0 if (ses->server->secType =3D=3D RawNTLMSSP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D find_domain_name(=
ses);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1=
, "error %d finding domain name", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto set=
up_ntlmv2_rsp_ret;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_avpair_blob(ses);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error %d buil=
ding av pair blob", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 }
> >>
> >> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
> >> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
> >> - =A0 =A0 if (rc)
> >> + =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get v2 hash rc %d=
", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_rsp_ret;
> >> + =A0 =A0 }
> >> =A0 =A0 =A0 CalcNTLMv2_response(ses, resp_buf);
> >>
> >> =A0 =A0 =A0 /* now calculate the MAC key for NTLMv2 */
> >> @@ -352,6 +450,20 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses=
, char *resp_buf,
> >> =A0 =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, res=
p_buf,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
> >> =A0 =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct nt=
lmv2_resp);
> >> +
> >> + =A0 =A0 return 0;
> >> +
> >> +setup_ntlmv2_rsp_ret:
> >> + =A0 =A0 if (ses->tidomain) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->domainName);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->domainName =3D NULL;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tidomain =3D false;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
> > I don't understand the need for the tidomain flag. IIUC, we have tw=
o
> > ways to get the domainName:
> >
> > 1) user supplies it via mount option
> >
> > 2) server supplies it via NTLMSSP AV pairs
> >
> > In the first case, this gets allocated at mount time and then freed=
 in
> > sesInfoFree. Why is it important to free it here? Why not just hold
> > onto the domainName string here and let it be freed in sesInfoFree?
>=20
> Jeff, only if the domainName was malloced in case user did not supply
> it, do we free it.
>=20
> I am not aware of any multidomain servers but if there
> is such a set up, and if domain name is not enough to distinguish
> a different session, can a tree connect come with different user supp=
lied
> domain name?
>=20
> I am probably fetching it too far but I will remove that code and if =
we run
> into such a thing, can always add back.  And I was not thinking of th=
is case
> when I added that code, but added it with the consideration that what=
 was
> malloc'ed during session setup, should be freed.
>=20

Not sure. Honestly, the whole domain=3D mount option seems like a
solution looking for a problem. It's not at all clear what its intended
use is. Perhaps it would be good to step back and attempt to clarify
its usage before we make any assumptions here.

It'll get freed at sesInfoFree, so I don't think you need to worry
about leaks here. The main question is whether we ever expect for the
domainName to change on a reconnect. If so, then your scheme or
something like it may be necessary.

>=20
> >
> >> + =A0 =A0 }
> >> + =A0 =A0 kfree(ses->tiblob);
> >> + =A0 =A0 ses->tiblob =3D NULL;
> >> + =A0 =A0 ses->tilen =3D 0;
> >> +
> >> + =A0 =A0 return rc;
> >> =A0}
> >>
> >> =A0void CalcNTLMv2_response(const struct cifsSesInfo *ses,
> >> @@ -365,6 +477,9 @@ void CalcNTLMv2_response(const struct cifsSesI=
nfo *ses,
> >> =A0 =A0 =A0 hmac_md5_update(v2_session_response+8,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_r=
esp) - 8, &context);
> >>
> >> + =A0 =A0 if (ses->tilen)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->tiblob, ses->tilen,=
 &context);
> >> +
> >> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
> >> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32);=
 */
> >> =A0}
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 14dfa9a..d6dbe18 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -222,6 +222,9 @@ struct cifsSesInfo {
> >> =A0 =A0 =A0 char userName[MAX_USERNAME_SIZE + 1];
> >> =A0 =A0 =A0 char *domainName;
> >> =A0 =A0 =A0 char *password;
> >> + =A0 =A0 unsigned int tilen; /* length of the target info blob */
> >> + =A0 =A0 unsigned char *tiblob; /* target info blob in challenge =
response */
> >> + =A0 =A0 bool tidomain; /* domain name was kmalloc'ed, free it */
> >> =A0 =A0 =A0 bool need_reconnect:1; /* connection reset, uid now in=
valid */
> >> =A0};
> >> =A0/* no more than one of the following three session flags may be=
 set */
> >> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> >> index 14d036d..b0f4b56 100644
> >> --- a/fs/cifs/cifspdu.h
> >> +++ b/fs/cifs/cifspdu.h
> >> @@ -663,7 +663,6 @@ struct ntlmv2_resp {
> >> =A0 =A0 =A0 __le64 =A0time;
> >> =A0 =A0 =A0 __u64 =A0client_chal; /* random */
> >> =A0 =A0 =A0 __u32 =A0reserved2;
> >> - =A0 =A0 struct ntlmssp2_name names[2];
> >> =A0 =A0 =A0 /* array of name entries could follow ending in minimu=
m 4 byte struct */
> >> =A0} __attribute__((packed));
> >>
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index 3f4fa81..c155479 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -367,7 +367,7 @@ extern int cifs_verify_signature(struct smb_hd=
r *,
> >> =A0extern int cifs_calculate_session_key(struct session_key *key, =
const char *rn,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0con=
st char *pass);
> >> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *, cha=
r *);
> >> -extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> >> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struc=
t nls_table *);
> >> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> >> =A0extern void calc_lanman_hash(const char *password, const char *=
cryptkey,
> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> >> index c65c341..13c854e 100644
> >> --- a/fs/cifs/cifssmb.c
> >> +++ b/fs/cifs/cifssmb.c
> >> @@ -603,13 +603,15 @@ CIFSSMBNegotiate(unsigned int xid, struct ci=
fsSesInfo *ses)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D=
 0;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D=
 -EINVAL;
> >> -
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->sec_kerberos=
 || server->sec_mskerberos)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->=
secType =3D Kerberos;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (server->sec_ntl=
mssp)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->=
secType =3D RawNTLMSSP;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
EOPNOTSUPP;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=3D=
 Kerberos) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ser=
ver->sec_kerberos &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 !server->sec_mskerberos)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc =3D -EOPNOTSUPP;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->secTy=
pe =3D=3D RawNTLMSSP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ser=
ver->sec_ntlmssp)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc =3D -EOPNOTSUPP;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc =3D -EOPNOTSUPP;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 } else
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->capabilities &=3D ~CAP_EXTENDE=
D_SECURITY;
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 88c84a3..7932813 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -1740,6 +1740,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *ser=
ver, struct smb_vol *volume_info)
> >> =A0 =A0 =A0 if (ses =3D=3D NULL)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto get_ses_fail;
> >>
> >> + =A0 =A0 ses->tilen =3D 0;
> >> + =A0 =A0 ses->tiblob =3D NULL;
> >> + =A0 =A0 ses->tidomain =3D false;
> >> =A0 =A0 =A0 /* new SMB session uses our server ref */
> >> =A0 =A0 =A0 ses->server =3D server;
> >> =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6=
)
> >> diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
> >> index 49c9a4e..5d52e4a 100644
> >> --- a/fs/cifs/ntlmssp.h
> >> +++ b/fs/cifs/ntlmssp.h
> >> @@ -61,6 +61,21 @@
> >> =A0#define NTLMSSP_NEGOTIATE_KEY_XCH =A0 0x40000000
> >> =A0#define NTLMSSP_NEGOTIATE_56 =A0 =A0 =A0 =A00x80000000
> >>
> >> +/* Define AV Pair Field IDs */
> >> +enum av_field_type {
> >> + =A0 =A0 NTLMSSP_AV_EOL =3D 0,
> >> + =A0 =A0 NTLMSSP_AV_NB_COMPUTER_NAME,
> >> + =A0 =A0 NTLMSSP_AV_NB_DOMAIN_NAME,
> >> + =A0 =A0 NTLMSSP_AV_DNS_COMPUTER_NAME,
> >> + =A0 =A0 NTLMSSP_AV_DNS_DOMAIN_NAME,
> >> + =A0 =A0 NTLMSSP_AV_DNS_TREE_NAME,
> >> + =A0 =A0 NTLMSSP_AV_FLAGS,
> >> + =A0 =A0 NTLMSSP_AV_TIMESTAMP,
> >> + =A0 =A0 NTLMSSP_AV_RESTRICTION,
> >> + =A0 =A0 NTLMSSP_AV_TARGET_NAME,
> >> + =A0 =A0 NTLMSSP_AV_CHANNEL_BINDINGS
> >> +};
> >> +
> >> =A0/* Although typedefs are not commonly used for structure defini=
tions */
> >> =A0/* in the Linux kernel, in this particular case they are useful=
 =A0 =A0 =A0*/
> >> =A0/* to more closely match the standards document for NTLMSSP fro=
m =A0 =A0 */
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index 8882012..b857046 100644
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
> >> @@ -405,6 +408,19 @@ static int decode_ntlmssp_challenge(char *bcc=
_ptr, int blob_len,
> >> =A0 =A0 =A0 /* BB spec says that if AvId field of MsvAvTimestamp i=
s populated then
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 we must set the MIC field of the AUTHE=
NTICATE_MESSAGE */
> >>
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
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->tiblob, =A0bcc_ptr + tioffse=
t, ses->tilen);
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 return 0;
> >> =A0}
> >>
> >> @@ -425,7 +441,7 @@ static void build_ntlmssp_negotiate_blob(unsig=
ned char *pbuffer,
> >> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use =
here? */
> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_TA=
RGET |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGO=
TIATE_NTLM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> @@ -449,12 +465,14 @@ static void build_ntlmssp_negotiate_blob(uns=
igned char *pbuffer,
> >> =A0 =A0 This function returns the length of the data in the blob *=
/
> >> =A0static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct cifsSesInfo *ses,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c=
onst struct nls_table *nls_cp, bool first)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c=
onst struct nls_table *nls_cp)
> >> =A0{
> >> + =A0 =A0 int rc;
> >> + =A0 =A0 unsigned int size;
> >> =A0 =A0 =A0 AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSA=
GE *)pbuffer;
> >> =A0 =A0 =A0 __u32 flags;
> >> =A0 =A0 =A0 unsigned char *tmp;
> >> - =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZE];
> >> + =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
> >>
> >> =A0 =A0 =A0 memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
> >> =A0 =A0 =A0 sec_blob->MessageType =3D NtLmAuthenticate;
> >> @@ -462,7 +480,7 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOT=
IATE_TARGET_INFO |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGO=
TIATE_NTLM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> @@ -477,19 +495,23 @@ static int build_ntlmssp_auth_blob(unsigned =
char *pbuffer,
> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.Length =3D 0;
> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.MaximumLength =3D 0;
> >>
> >> - =A0 =A0 /* calculate session key, =A0BB what about adding simila=
r ntlmv2 path? */
> >> - =A0 =A0 SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_=
session_key);
> >> - =A0 =A0 if (first)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_key(&ses->server-=
>session_key,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0ntlm_session_key, ses->password);
> >> -
> >> - =A0 =A0 memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
> >> =A0 =A0 =A0 sec_blob->NtChallengeResponse.BufferOffset =3D cpu_to_=
le32(tmp - pbuffer);
> >> - =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(CIF=
S_SESS_KEY_SIZE);
> >> - =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_l=
e16(CIFS_SESS_KEY_SIZE);
> >> + =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, n=
ls_cp);
> >> + =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d during NTLMSSP authe=
ntication", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_ret;
> >> + =A0 =A0 }
> >> + =A0 =A0 size =3D =A0sizeof(struct ntlmv2_resp);
> >> + =A0 =A0 memcpy(tmp, (char *)&ntlmv2_response, size);
> >> + =A0 =A0 tmp +=3D size;
> >> + =A0 =A0 if (ses->tilen > 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->tiblob, ses->tilen);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D ses->tilen;
> >> + =A0 =A0 }
> >>
> >> - =A0 =A0 tmp +=3D CIFS_SESS_KEY_SIZE;
> >> + =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(siz=
e + ses->tilen);
> >> + =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_l=
e16(size + ses->tilen);
> >>
> >> =A0 =A0 =A0 if (ses->domainName =3D=3D NULL) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D =
cpu_to_le32(tmp - pbuffer);
> >> @@ -501,13 +523,24 @@ static int build_ntlmssp_auth_blob(unsigned =
char *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, s=
es->domainName,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MAX_USERNAME_SIZE, nls_cp);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each=
 */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D =
cpu_to_le32(tmp - pbuffer);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D cpu_to=
_le16(len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.MaximumLength =3D=
 cpu_to_le16(len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D len;
> >> =A0 =A0 =A0 }
> >>
> >> + =A0 =A0 /* Need to wait till domainName is copied over in the
> >> + =A0 =A0 =A0* ntlmssp response before freeing it if it was alloca=
ted.
> >> + =A0 =A0 =A0*/
> >> + =A0 =A0 if (ses->tidomain) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->domainName);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->domainName =3D NULL;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tidomain =3D false;
> >> + =A0 =A0 }
> >> + =A0 =A0 kfree(ses->tiblob);
> >> + =A0 =A0 ses->tiblob =3D NULL;
> >> + =A0 =A0 ses->tilen =3D 0;
> >> +
> >> =A0 =A0 =A0 if (ses->userName =3D=3D NULL) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D 0;
> >> @@ -518,7 +551,6 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, s=
es->userName,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MAX_USERNAME_SIZE, nls_cp);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each=
 */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D cpu_to_l=
e16(len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.MaximumLength =3D c=
pu_to_le16(len);
> >> @@ -533,6 +565,8 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_le32(tmp =
- pbuffer);
> >> =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
> >> =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
> >> +
> >> +setup_ntlmv2_ret:
> >> =A0 =A0 =A0 return tmp - pbuffer;
> >> =A0}
> >>
> >> @@ -545,19 +579,6 @@ static void setup_ntlmssp_neg_req(SESSION_SET=
UP_ANDX *pSMB,
> >>
> >> =A0 =A0 =A0 return;
> >> =A0}
> >> -
> >> -static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stru=
ct cifsSesInfo *ses,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cons=
t struct nls_table *nls, bool first_time)
> >> -{
> >> - =A0 =A0 int bloblen;
> >> -
> >> - =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(&pSMB->req.SecurityB=
lob[0], ses, nls,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 first_time);
> >> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(bloblen);
> >> -
> >> - =A0 =A0 return bloblen;
> >> -}
> >> =A0#endif
> >>
> >> =A0int
> >> @@ -580,6 +601,8 @@ CIFS_SessSetup(unsigned int xid, struct cifsSe=
sInfo *ses,
> >> =A0 =A0 =A0 struct key *spnego_key =3D NULL;
> >> =A0 =A0 =A0 __le32 phase =3D NtLmNegotiate; /* NTLMSSP, if needed,=
 is multistage */
> >> =A0 =A0 =A0 bool first_time;
> >> + =A0 =A0 int blob_len;
> >> + =A0 =A0 char *ntlmsspblob =3D NULL;
> >>
> >> =A0 =A0 =A0 if (ses =3D=3D NULL)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> >> @@ -729,12 +752,24 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(str=
uct ntlmv2_resp));
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlmv2_rsp(ses, v2_sess_key, nls_c=
p);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: calculate MAC key */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_key=
, nls_cp);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d duri=
ng NTLMv2 authentication", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)v2_sess_key,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp=
));
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(s=
truct ntlmv2_resp));
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D sizeof(struct ntlmv2_resp=
);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (ses->tilen > 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->tib=
lob, ses->tilen);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->tilen;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we never did allocate=
 ses->domainName to free */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->tiblob);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D NULL;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len % 2=
) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_p=
tr =3D 0;
> >> @@ -815,12 +850,28 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D NtLmN=
egotiate) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_=
ntlmssp_neg_req(pSMB, ses);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1]=
=2Eiov_len =3D sizeof(NEGOTIATE_MESSAGE);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_base =3D &pSMB->req.SecurityBlob[0];
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (phase =3D=3D=
 NtLmAuthenticate) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int blob=
_len;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len=
 =3D setup_ntlmssp_auth_req(pSMB, ses,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_cp,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_time)=
;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is =
an empirical value, large enought to
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* hol=
d authenticate message, max 10 of
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* av =
paris, doamin,user,workstation mames,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fla=
gs etc..
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspb=
lob =3D kmalloc(
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 5*sizeof(struct _AUTHENTICATE_MESSAGE),
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ntl=
msspblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cERROR(1, "Can't allocate NTLMSSP");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc =3D -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 goto ssetup_exit;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len=
 =3D build_ntlmssp_auth_blob(ntlmsspblob,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses, nls_cp);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1]=
=2Eiov_len =3D blob_len;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_base =3D ntlmsspblob;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->re=
q.SecurityBlobLength =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cpu_to_le16(blob_len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Mak=
e sure that we tell the server that we
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
are using the uid that it just gave us back
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
on the response (challenge) */
> >> @@ -830,7 +881,6 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D=
 -ENOSYS;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto s=
setup_exit;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D &pSM=
B->req.SecurityBlob[0];
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* unicode strings mus=
t be word aligned */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((iov[0].iov_len + =
iov[1].iov_len) % 2) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_p=
tr =3D 0;
> >> @@ -931,6 +981,7 @@ ssetup_exit:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(spnego_key);
> >> =A0 =A0 =A0 }
> >> =A0 =A0 =A0 kfree(str_area);
> >> + =A0 =A0 kfree(ntlmsspblob);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
> > I think you should set the above pointer to NULL too. It's a bit ha=
rd
> > to follow the code in CIFS_SessSetup, but if it'll ever be possible=
 to
> > make another trip to the server after the NtLmAuthenticate phase, t=
hen
> > you'll potentially double-free this pointer. Some defensive coding =
here
> > would be good.
>=20
> Sure.  But as far as I know, there are only three types of packets
> exchanged in NTLM protocol and authenticate type is the last a client=
 sends.
>=20

I think you're right, but given that we can travel through this kfree
multiple times, it's worthwhile to be very careful with how that
pointer is handled. That's the kind of thing that can come back to bite
you later in the face of other changes to this function.

> >
> >> =A0 =A0 =A0 if (resp_buf_type =3D=3D CIFS_SMALL_BUFFER) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "ssetup freeing small buf %p",=
 iov[0].iov_base);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(iov[0].iov_base=
);
> >
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
