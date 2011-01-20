From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH -v2 1/6] functions to either extract or create av_
 pair/ti_info blob
Date: Thu, 20 Jan 2011 15:59:28 -0600
Message-ID: <AANLkTinuodRvi2erJK+kfzrvr0Ce4_PdFh=8_aPq1J1X@mail.gmail.com>
References: <1295560604-4941-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: smfrench@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1295560604-4941-1-git-send-email-shirishpargaonkar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Jan 20, 2011 at 3:56 PM,  <shirishpargaonkar@gmail.com> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>
>
> Attribue Value (AV) pairs or Target Info (TI) pairs are part of
> ntlmv2 authentication.
> Structure ntlmv2_resp had only definition for two av pairs.
> So removed it, and now allocation of av pairs is dynamic.
> For servers like Windows 7/2008, av pairs sent by server in
> challege packet (type 2 in the ntlmssp exchange/negotiation) can
> vary.
>
> Server sends them during ntlmssp negotiation. So when ntlmssp is used
> as an authentication mechanism, type 2 challenge packet from server
> has this information. =A0Pluck it and use the entire blob for
> authenticaiton purpose. =A0If user has not specified, extract
> (netbios) domain name from the av pairs which is used to calculate
> ntlmv2 hash. =A0Servers like Windows 7 are particular about the AV pa=
ir
> blob.
>
> Servers like Windows 2003, are not very strict about the contents
> of av pair blob used during ntlmv2 authentication.
> So when security mechanism such as ntlmv2 is used (not ntlmv2 in ntlm=
ssp),
> there is no negotiation and so genereate a minimal blob that gets
> used in ntlmv2 authentication as well as gets sent.
>
> Fields tilen and tilbob are session specific. =A0AV pair values are d=
efined.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 78 +++++++++++++++++++++++++++++++++++=
+++++++++++--
> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 +
> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +
> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 15 +++++++++
> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 15 +++++++++
> =A06 files changed, 108 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 35042d8..a547d24 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -27,6 +27,7 @@
> =A0#include "md5.h"
> =A0#include "cifs_unicode.h"
> =A0#include "cifsproto.h"
> +#include "ntlmssp.h"
> =A0#include <linux/ctype.h>
> =A0#include <linux/random.h>
>
> @@ -262,6 +263,79 @@ void calc_lanman_hash(const char *password, cons=
t char *cryptkey, bool encrypt,
> =A0}
> =A0#endif /* CIFS_WEAK_PW_HASH */
>
> +/* This is just a filler for ntlmv2 type of security mechanisms.
> + * Older servers are not very particular about the contents of av pa=
irs
> + * in the blob and for sec mechs like ntlmv2, there is no negotiatio=
n
> + * as in ntlmssp, so unless domain and server =A0netbios and dns nam=
es
> + * are specified, there is no way to obtain name. =A0In case of ntlm=
ssp,
> + * server provides that info in type 2 challenge packet
> + */
> +static int
> +build_avpair_blob(struct cifsSesInfo *ses)
> +{
> + =A0 =A0 =A0 struct ntlmssp2_name *attrptr;
> +
> + =A0 =A0 =A0 ses->tilen =3D 2 * sizeof(struct ntlmssp2_name);
> + =A0 =A0 =A0 ses->tiblob =3D kzalloc(ses->tilen, GFP_KERNEL);
> + =A0 =A0 =A0 if (!ses->tiblob) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge target info alloca=
tion failure");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses->tiblob;
> + =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/* Server has provided av pairs/target info in the type 2 challenge
> + * packet and we have plucked it and stored within smb session.
> + * We parse that blob here to find netbios domain name to be used
> + * as part of ntlmv2 authentication (in Target String), if not alrea=
dy
> + * specified on the command line.
> + */
> +static int
> +find_domain_name(struct cifsSesInfo *ses)
> +{
> + =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 unsigned int attrsize;
> + =A0 =A0 =A0 unsigned int type;
> + =A0 =A0 =A0 unsigned char *blobptr;
> + =A0 =A0 =A0 unsigned char *blobend;
> + =A0 =A0 =A0 struct ntlmssp2_name *attrptr;
> +
> + =A0 =A0 =A0 if (ses->tiblob) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobend =3D ses->tiblob + ses->tilen;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr =3D ses->tiblob;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) bl=
obptr;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (blobptr <=3D blobend &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (type =3D=
 attrptr->type) !=3D NTLMSSP_AV_EOL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* adva=
nce attr type */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D attrptr->l=
ength;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* adva=
nce attr size */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP=
_AV_NB_DOMAIN_NAME) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!se=
s->domainName) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ses->domainName =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 kmalloc(attrptr->length + 1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (!ses->domainName)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_from_ucs2(ses->domainName,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 (__le16 *)blobptr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 attrptr->length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 attrptr->length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 load_nls_default(), false);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; =
/* advance attr =A0value */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntl=
mssp2_name *) blobptr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct n=
ls_table *nls_cp)
> =A0{
> @@ -333,10 +407,6 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, c=
har *resp_buf,
> =A0 =A0 =A0 =A0buf->time =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TI=
ME));
> =A0 =A0 =A0 =A0get_random_bytes(&buf->client_chal, sizeof(buf->client=
_chal));
> =A0 =A0 =A0 =A0buf->reserved2 =3D 0;
> - =A0 =A0 =A0 buf->names[0].type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE)=
;
> - =A0 =A0 =A0 buf->names[0].length =3D 0;
> - =A0 =A0 =A0 buf->names[1].type =3D 0;
> - =A0 =A0 =A0 buf->names[1].length =3D 0;
>
> =A0 =A0 =A0 =A0/* calculate buf->ntlmv2_hash */
> =A0 =A0 =A0 =A0rc =3D calc_ntlmv2_hash(ses, nls_cp);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 0cdfb8c..2bfe682 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -222,6 +222,8 @@ struct cifsSesInfo {
> =A0 =A0 =A0 =A0char userName[MAX_USERNAME_SIZE + 1];
> =A0 =A0 =A0 =A0char *domainName;
> =A0 =A0 =A0 =A0char *password;
> + =A0 =A0 =A0 unsigned int tilen; /* length of the target info blob *=
/
> + =A0 =A0 =A0 unsigned char *tiblob; /* target info blob in challenge=
 response */
> =A0 =A0 =A0 =A0bool need_reconnect:1; /* connection reset, uid now in=
valid */
> =A0};
> =A0/* no more than one of the following three session flags may be se=
t */
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 14d036d..b0f4b56 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -663,7 +663,6 @@ struct ntlmv2_resp {
> =A0 =A0 =A0 =A0__le64 =A0time;
> =A0 =A0 =A0 =A0__u64 =A0client_chal; /* random */
> =A0 =A0 =A0 =A0__u32 =A0reserved2;
> - =A0 =A0 =A0 struct ntlmssp2_name names[2];
> =A0 =A0 =A0 =A0/* array of name entries could follow ending in minimu=
m 4 byte struct */
> =A0} __attribute__((packed));
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 67dad54..f8891a2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1740,6 +1740,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server=
, struct smb_vol *volume_info)
> =A0 =A0 =A0 =A0if (ses =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto get_ses_fail;
>
> + =A0 =A0 =A0 ses->tilen =3D 0;
> + =A0 =A0 =A0 ses->tiblob =3D NULL;
> =A0 =A0 =A0 =A0/* new SMB session uses our server ref */
> =A0 =A0 =A0 =A0ses->server =3D server;
> =A0 =A0 =A0 =A0if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6=
)
> diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
> index 49c9a4e..5d52e4a 100644
> --- a/fs/cifs/ntlmssp.h
> +++ b/fs/cifs/ntlmssp.h
> @@ -61,6 +61,21 @@
> =A0#define NTLMSSP_NEGOTIATE_KEY_XCH =A0 0x40000000
> =A0#define NTLMSSP_NEGOTIATE_56 =A0 =A0 =A0 =A00x80000000
>
> +/* Define AV Pair Field IDs */
> +enum av_field_type {
> + =A0 =A0 =A0 NTLMSSP_AV_EOL =3D 0,
> + =A0 =A0 =A0 NTLMSSP_AV_NB_COMPUTER_NAME,
> + =A0 =A0 =A0 NTLMSSP_AV_NB_DOMAIN_NAME,
> + =A0 =A0 =A0 NTLMSSP_AV_DNS_COMPUTER_NAME,
> + =A0 =A0 =A0 NTLMSSP_AV_DNS_DOMAIN_NAME,
> + =A0 =A0 =A0 NTLMSSP_AV_DNS_TREE_NAME,
> + =A0 =A0 =A0 NTLMSSP_AV_FLAGS,
> + =A0 =A0 =A0 NTLMSSP_AV_TIMESTAMP,
> + =A0 =A0 =A0 NTLMSSP_AV_RESTRICTION,
> + =A0 =A0 =A0 NTLMSSP_AV_TARGET_NAME,
> + =A0 =A0 =A0 NTLMSSP_AV_CHANNEL_BINDINGS
> +};
> +
> =A0/* Although typedefs are not commonly used for structure definitio=
ns */
> =A0/* in the Linux kernel, in this particular case they are useful =A0=
 =A0 =A0*/
> =A0/* to more closely match the standards document for NTLMSSP from =A0=
 =A0 */
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 0a57cb7..2de5f08 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, =
int bleft,
> =A0static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct cifsSesInfo *ses)
> =A0{
> + =A0 =A0 =A0 unsigned int tioffset; /* challenge message target info=
 area */
> + =A0 =A0 =A0 unsigned int tilen; /* challenge message target info ar=
ea length =A0*/
> +
> =A0 =A0 =A0 =A0CHALLENGE_MESSAGE *pblob =3D (CHALLENGE_MESSAGE *)bcc_=
ptr;
>
> =A0 =A0 =A0 =A0if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
> @@ -405,6 +408,18 @@ static int decode_ntlmssp_challenge(char *bcc_pt=
r, int blob_len,
> =A0 =A0 =A0 =A0/* BB spec says that if AvId field of MsvAvTimestamp i=
s populated then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0we must set the MIC field of the AUTHE=
NTICATE_MESSAGE */
>
> + =A0 =A0 =A0 tioffset =3D cpu_to_le16(pblob->TargetInfoArray.BufferO=
ffset);
> + =A0 =A0 =A0 tilen =3D cpu_to_le16(pblob->TargetInfoArray.Length);
> + =A0 =A0 =A0 ses->tilen =3D tilen;
> + =A0 =A0 =A0 if (ses->tilen) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D kmalloc(tilen, GFP_KERN=
EL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->tiblob) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge ta=
rget info allocation failure");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->tiblob, =A0bcc_ptr + tioffs=
et, ses->tilen);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> --
> 1.6.0.2
>
>

Incorrect patch, please disregard.
