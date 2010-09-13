From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v2 1/6] functions to either extract or create av_
 pair/ti_info blob
Date: Mon, 13 Sep 2010 11:46:04 -0500
Message-ID: <AANLkTi=PjqK78VubpC2hh29fR3hLa59rcVsPimcoofpo@mail.gmail.com>
References: <1284055939-767-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100912084639.5c1bf654@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100912084639.5c1bf654-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 12, 2010 at 7:46 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, =A09 Sep 2010 13:12:19 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>
> It would be good to prefix the subject line in these patches with
> "cifs:" so that people can quickly see what these patches are intende=
d
> to touch.
>
>>
>> Attribue Value (AV) pairs or Target Info (TI) pairs are part of
>> ntlmv2 authentication.
>> Structure ntlmv2_resp had only definition for two av pairs.
>> So removed it, and now allocation of av pairs is dynamic.
>> For servers like Windows 7/2008, av pairs sent by server in
>> challege packet (type 2 in the ntlmssp exchange/negotiation) can
>> vary.
>>
>> Server sends them during ntlmssp negotiation. So when ntlmssp is use=
d
>> as an authentication mechanism, type 2 challenge packet from server
>> has this information. =A0Pluck it and use the entire blob for
>> authenticaiton purpose. =A0If user has not specified, extract
>> (netbios) domain name from the av pairs which is used to calculate
>> ntlmv2 hash. =A0Servers like Windows 7 are particular about the AV p=
air
>> blob.
>>
>> Servers like Windows 2003, are not very strict about the contents
>> of av pair blob used during ntlmv2 authentication.
>> So when security mechanism such as ntlmv2 is used (not ntlmv2 in ntl=
mssp),
>> there is no negotiation and so genereate a minimal blob that gets
>> used in ntlmv2 authentication as well as gets sent.
>>
>> Fields tilen and tilbob are session specific. =A0AV pair values are =
defined.
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 78 ++++++++++++++++++++++++++++++++++=
++++++++++++--
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 +
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +
>> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 15 +++++++++
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 15 +++++++++
>> =A06 files changed, 108 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 35042d8..a547d24 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -27,6 +27,7 @@
>> =A0#include "md5.h"
>> =A0#include "cifs_unicode.h"
>> =A0#include "cifsproto.h"
>> +#include "ntlmssp.h"
>> =A0#include <linux/ctype.h>
>> =A0#include <linux/random.h>
>>
>> @@ -262,6 +263,79 @@ void calc_lanman_hash(const char *password, con=
st char *cryptkey, bool encrypt,
>> =A0}
>> =A0#endif /* CIFS_WEAK_PW_HASH */
>>
>> +/* This is just a filler for ntlmv2 type of security mechanisms.
>> + * Older servers are not very particular about the contents of av p=
airs
>> + * in the blob and for sec mechs like ntlmv2, there is no negotiati=
on
>> + * as in ntlmssp, so unless domain and server =A0netbios and dns na=
mes
>> + * are specified, there is no way to obtain name. =A0In case of ntl=
mssp,
>> + * server provides that info in type 2 challenge packet
>> + */
>> +static int
>> +build_avpair_blob(struct cifsSesInfo *ses)
>> +{
>> + =A0 =A0 struct ntlmssp2_name *attrptr;
>> +
>> + =A0 =A0 ses->tilen =3D 2 * sizeof(struct ntlmssp2_name);
>> + =A0 =A0 ses->tiblob =3D kzalloc(ses->tilen, GFP_KERNEL);
>> + =A0 =A0 if (!ses->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge target info allocatio=
n failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 }
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses->tiblob;
>> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +/* Server has provided av pairs/target info in the type 2 challenge
>> + * packet and we have plucked it and stored within smb session.
>> + * We parse that blob here to find netbios domain name to be used
>> + * as part of ntlmv2 authentication (in Target String), if not alre=
ady
>> + * specified on the command line.
>> + */
>> +static int
>> +find_domain_name(struct cifsSesInfo *ses)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 unsigned int attrsize;
>> + =A0 =A0 unsigned int type;
>> + =A0 =A0 unsigned char *blobptr;
>> + =A0 =A0 unsigned char *blobend;
>> + =A0 =A0 struct ntlmssp2_name *attrptr;
>> +
>> + =A0 =A0 if (ses->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobend =3D ses->tiblob + ses->tilen;
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr =3D ses->tiblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobp=
tr;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 while (blobptr <=3D blobend &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (type =3D =
attrptr->type) !=3D NTLMSSP_AV_EOL) {
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0That can still read past the end of th=
e buffer, right?
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Consider:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blobptr =3D 1
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blobend =3D 1
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Now, type is a __le16, so checking thi=
s will mean that
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0you're accessing the 2nd byte, which i=
s beyond the end
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0of the buffer. Even if you check that =
though, you'll
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0have a similar problem below if bloben=
d is 3 when you
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read the length.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You really need to ensure that this pa=
rser can't be
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tricked into reading past the end of t=
he buffer. One
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0way to do this would be to check here =
to make sure the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blob is big enough to read the type an=
d length. If it
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is, then check the type and read the l=
ength. Then check
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to see if the provided length is beyon=
d the end of the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buffer.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance=
 attr type */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D attrptr->leng=
th;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance=
 attr size */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV=
_NB_DOMAIN_NAME) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Don't you need to endian convert this?=
 This will break
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0on big endian machines, I think...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->=
domainName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 ses->domainName =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 kmalloc(attrptr->length + 1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (!ses->domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cifs_from_ucs2(ses->domainName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (__le16 *)blobptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 load_nls_default(), false);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0Would it be better to break
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0here? Is there any reason to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0keep parsing this buffer once
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0you find the domainName?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /* =
advance attr =A0value */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmss=
p2_name *) blobptr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0Does rc ever hold anything but 0?
>> +}
>> +
>> =A0static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls=
_table *nls_cp)
>> =A0{
>> @@ -333,10 +407,6 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, =
char *resp_buf,
>> =A0 =A0 =A0 buf->time =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME=
));
>> =A0 =A0 =A0 get_random_bytes(&buf->client_chal, sizeof(buf->client_c=
hal));
>> =A0 =A0 =A0 buf->reserved2 =3D 0;
>> - =A0 =A0 buf->names[0].type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
>> - =A0 =A0 buf->names[0].length =3D 0;
>> - =A0 =A0 buf->names[1].type =3D 0;
>> - =A0 =A0 buf->names[1].length =3D 0;
>>
>> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
>> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 0cdfb8c..2bfe682 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -222,6 +222,8 @@ struct cifsSesInfo {
>> =A0 =A0 =A0 char userName[MAX_USERNAME_SIZE + 1];
>> =A0 =A0 =A0 char *domainName;
>> =A0 =A0 =A0 char *password;
>> + =A0 =A0 unsigned int tilen; /* length of the target info blob */
>> + =A0 =A0 unsigned char *tiblob; /* target info blob in challenge re=
sponse */
>> =A0 =A0 =A0 bool need_reconnect:1; /* connection reset, uid now inva=
lid */
>> =A0};
>> =A0/* no more than one of the following three session flags may be s=
et */
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index 14d036d..b0f4b56 100644
>> --- a/fs/cifs/cifspdu.h
>> +++ b/fs/cifs/cifspdu.h
>> @@ -663,7 +663,6 @@ struct ntlmv2_resp {
>> =A0 =A0 =A0 __le64 =A0time;
>> =A0 =A0 =A0 __u64 =A0client_chal; /* random */
>> =A0 =A0 =A0 __u32 =A0reserved2;
>> - =A0 =A0 struct ntlmssp2_name names[2];
>> =A0 =A0 =A0 /* array of name entries could follow ending in minimum =
4 byte struct */
>> =A0} __attribute__((packed));
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 67dad54..f8891a2 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1740,6 +1740,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *serve=
r, struct smb_vol *volume_info)
>> =A0 =A0 =A0 if (ses =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto get_ses_fail;
>>
>> + =A0 =A0 ses->tilen =3D 0;
>> + =A0 =A0 ses->tiblob =3D NULL;
>> =A0 =A0 =A0 /* new SMB session uses our server ref */
>> =A0 =A0 =A0 ses->server =3D server;
>> =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6)
>> diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
>> index 49c9a4e..5d52e4a 100644
>> --- a/fs/cifs/ntlmssp.h
>> +++ b/fs/cifs/ntlmssp.h
>> @@ -61,6 +61,21 @@
>> =A0#define NTLMSSP_NEGOTIATE_KEY_XCH =A0 0x40000000
>> =A0#define NTLMSSP_NEGOTIATE_56 =A0 =A0 =A0 =A00x80000000
>>
>> +/* Define AV Pair Field IDs */
>> +enum av_field_type {
>> + =A0 =A0 NTLMSSP_AV_EOL =3D 0,
>> + =A0 =A0 NTLMSSP_AV_NB_COMPUTER_NAME,
>> + =A0 =A0 NTLMSSP_AV_NB_DOMAIN_NAME,
>> + =A0 =A0 NTLMSSP_AV_DNS_COMPUTER_NAME,
>> + =A0 =A0 NTLMSSP_AV_DNS_DOMAIN_NAME,
>> + =A0 =A0 NTLMSSP_AV_DNS_TREE_NAME,
>> + =A0 =A0 NTLMSSP_AV_FLAGS,
>> + =A0 =A0 NTLMSSP_AV_TIMESTAMP,
>> + =A0 =A0 NTLMSSP_AV_RESTRICTION,
>> + =A0 =A0 NTLMSSP_AV_TARGET_NAME,
>> + =A0 =A0 NTLMSSP_AV_CHANNEL_BINDINGS
>> +};
>> +
>> =A0/* Although typedefs are not commonly used for structure definiti=
ons */
>> =A0/* in the Linux kernel, in this particular case they are useful =A0=
 =A0 =A0*/
>> =A0/* to more closely match the standards document for NTLMSSP from =
=A0 =A0 */
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 0a57cb7..2de5f08 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area,=
 int bleft,
>> =A0static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
struct cifsSesInfo *ses)
>> =A0{
>> + =A0 =A0 unsigned int tioffset; /* challenge message target info ar=
ea */
>> + =A0 =A0 unsigned int tilen; /* challenge message target info area =
length =A0*/
>> +
>> =A0 =A0 =A0 CHALLENGE_MESSAGE *pblob =3D (CHALLENGE_MESSAGE *)bcc_pt=
r;
>>
>> =A0 =A0 =A0 if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
>> @@ -405,6 +408,18 @@ static int decode_ntlmssp_challenge(char *bcc_p=
tr, int blob_len,
>> =A0 =A0 =A0 /* BB spec says that if AvId field of MsvAvTimestamp is =
populated then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 we must set the MIC field of the AUTHENT=
ICATE_MESSAGE */
>>
>> + =A0 =A0 tioffset =3D cpu_to_le16(pblob->TargetInfoArray.BufferOffs=
et);
>> + =A0 =A0 tilen =3D cpu_to_le16(pblob->TargetInfoArray.Length);
>> + =A0 =A0 ses->tilen =3D tilen;
>> + =A0 =A0 if (ses->tilen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D kmalloc(tilen, GFP_KERNEL)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge targe=
t info allocation failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->tiblob, =A0bcc_ptr + tioffset,=
 ses->tilen);
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 return 0;
>> =A0}
>>

This patch should address the concerns raised uptill now.

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index a547d24..82cf8e3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -293,47 +293,55 @@ build_avpair_blob(struct cifsSesInfo *ses)
  * We parse that blob here to find netbios domain name to be used
  * as part of ntlmv2 authentication (in Target String), if not already
  * specified on the command line.
+ * If this function returns without any error but without fetching
+ * domain name, authentication may fail against some server but
+ * may not fail against other (those who are not very particular
+ * about target string i.e. for some, just user name might suffice.
  */
 static int
 find_domain_name(struct cifsSesInfo *ses)
 {
-       int rc =3D 0;
        unsigned int attrsize;
        unsigned int type;
        unsigned char *blobptr;
        unsigned char *blobend;
        struct ntlmssp2_name *attrptr;

-       if (ses->tiblob) {
-               blobend =3D ses->tiblob + ses->tilen;
-               blobptr =3D ses->tiblob;
-               attrptr =3D (struct ntlmssp2_name *) blobptr;
+       if (!ses->tilen || !ses->tiblob)
+               return 0;
+
+       if (ses->tilen < sizeof(struct ntlmssp2_name))
+               return 0;

-               while (blobptr <=3D blobend &&
-                               (type =3D attrptr->type) !=3D NTLMSSP_A=
V_EOL) {
-                       blobptr +=3D 2; /* advance attr type */
-                       attrsize =3D attrptr->length;
-                       blobptr +=3D 2; /* advance attr size */
-                       if (type =3D=3D NTLMSSP_AV_NB_DOMAIN_NAME) {
-                               if (!ses->domainName) {
-                                       ses->domainName =3D
-                                               kmalloc(attrptr->length=
 + 1,
-                                                               GFP_KER=
NEL);
-                                       if (!ses->domainName)
-                                                       return -ENOMEM;
-                                       cifs_from_ucs2(ses->domainName,
-                                               (__le16 *)blobptr,
-                                               attrptr->length,
-                                               attrptr->length,
-                                               load_nls_default(), fal=
se);
-                               }
+       blobend =3D ses->tiblob + ses->tilen;
+       blobptr =3D ses->tiblob;
+       attrptr =3D (struct ntlmssp2_name *) blobptr;
+
+       while (blobptr <=3D blobend) {
+               type =3D le16_to_cpu(attrptr->type);
+               if (type =3D=3D NTLMSSP_AV_EOL)
+                       break;
+               blobptr +=3D 2; /* advance attr type */
+               attrsize =3D le16_to_cpu(attrptr->length);
+               blobptr +=3D 2; /* advance attr size */
+               if (type =3D=3D NTLMSSP_AV_NB_DOMAIN_NAME) {
+                       if (!ses->domainName) {
+                               ses->domainName =3D
+                                       kmalloc(attrsize+ 1, GFP_KERNEL=
);
+                               if (!ses->domainName)
+                                               return -ENOMEM;
+                               cifs_from_ucs2(ses->domainName,
+                                       (__le16 *)blobptr,
+                                       attrptr->length,
+                                       attrptr->length,
+                                       load_nls_default(), false);
                        }
-                       blobptr +=3D attrsize; /* advance attr  value *=
/
-                       attrptr =3D (struct ntlmssp2_name *) blobptr;
                }
+               blobptr +=3D attrsize; /* advance attr  value */
+               attrptr =3D (struct ntlmssp2_name *) blobptr;
        }

-       return rc;
+       return 0;
 }

 static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
cifstest6:/usr/src/linux.ssp.052109.1/cifs-2.6 #

>
> A little weird to add these blob allocations in this patch without
> actually ever freeing them. Maybe it would be better to split this up
> differently for bisectability?

No, they do get freed, in case of no errors, once the blob gets copied
in the type 3 packet of NTLMSSP negotiation being constructed
(functions build_ntlmssp_auth_blob() in caes of RawNTLMSSP
and in CIFS_SessSetup() in case of ntlmv2) and in case of error, in
function setup_ntlmv2_rsp().

I will combine 1/6 and 2/6 in one so that that one patch has all of the
authentication code.

>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
