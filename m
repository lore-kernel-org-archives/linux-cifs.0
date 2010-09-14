From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v3 2/4 cifs] NTLMv2/NTLMSSP ntlmv2 within ntlmssp
 autentication code
Date: Tue, 14 Sep 2010 06:33:53 -0500
Message-ID: <AANLkTin4GnCDc8wauH0=LJoBiA_g3Q5dkXMbSty2hoAD@mail.gmail.com>
References: <1284405322-31202-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100914072333.67649ee2@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100914072333.67649ee2-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 14, 2010 at 6:23 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 13 Sep 2010 14:15:22 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
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
>> To calculate ntlmv2 response we need ti/av pair blob.
>>
>> For sec mech like ntlmssp, the blob is plucked from type 2 response =
from
>> the server. =A0From this blob, netbios name of the domain is retriev=
ed,
>> if user has not already provided, to be included in the Target Strin=
g
>> as part of ntlmv2 hash calculations.
>>
>> For sec mech like ntlmv2, create a minimal, two av pair blob.
>>
>> The allocated blob is freed in case of error. =A0In case there is no=
 error,
>> this blob is used in calculating ntlmv2 response (in CalcNTLMv2_resp=
onse)
>> and is also copied on the response to the server, and then freed.
>>
>> The type 3 ntlmssp response is prepared on a buffer,
>> 5 * sizeof of struct _AUTHENTICATE_MESSAGE, an empirical value large
>> enough to hold _AUTHENTICATE_MESSAGE plus a blob with max possible
>> 10 values as part of ntlmv2 response and lmv2 keys and domain, user,
>> workstation =A0names etc.
>>
>> Also, kerberos gets selected as a default mechanism if server suppor=
ts it,
>> over the other security mechanisms.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0121 ++++++++++++++++++++++++++++++++++=
++++++++++++---
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 +
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +-
>> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 16 ++++---
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +
>> =A0fs/cifs/ntlmssp.h =A0 =A0 | =A0 15 ++++++
>> =A07 files changed, 144 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index eed70ca..960c948 100644
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
>> @@ -262,6 +263,87 @@ void calc_lanman_hash(const char *password, con=
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
>> + * If this function returns without any error but without fetching
>> + * domain name, authentication may fail against some server but
>> + * may not fail against other (those who are not very particular
>> + * about target string i.e. for some, just user name might suffice.
>> + */
>> +static int
>> +find_domain_name(struct cifsSesInfo *ses)
>> +{
>> + =A0 =A0 unsigned int attrsize;
>> + =A0 =A0 unsigned int type;
>> + =A0 =A0 unsigned char *blobptr;
>> + =A0 =A0 unsigned char *blobend;
>> + =A0 =A0 struct ntlmssp2_name *attrptr;
>> +
>> + =A0 =A0 if (!ses->tilen || !ses->tiblob)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (ses->tilen < sizeof(struct ntlmssp2_name))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 blobend =3D ses->tiblob + ses->tilen;
>> + =A0 =A0 blobptr =3D ses->tiblob;
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 while (blobptr <=3D blobend) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 type =3D le16_to_cpu(attrptr->type);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV_EOL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance attr type */
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D le16_to_cpu(attrptr->length);
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance attr size */
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Again, there's no check to see whether=
 any of these
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lengths fall within the blob. It would=
 be trivial for an
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0attacker with access to a compromised =
server to craft a
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NTLMSSP response that has a NTLMSSP_AV=
_NB_DOMAIN_NAME
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0field with a huge length, far beyond t=
he end of the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blob. This code will then likely oops =
in cifs_from_ucs2.

OK, will address this.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D NTLMSSP_AV_NB_DOMAIN_NAME)=
 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->domai=
nName =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 kmalloc(attrsize + 1, GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->=
domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_from_=
ucs2(ses->domainName,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (__le16 *)blobptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 attrptr->length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 load_nls_default(), false);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You ca=
n probably break here, right?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /* advance attr =A0=
value */
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobp=
tr;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> =A0static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls=
_table *nls_cp)
>> =A0{
>> @@ -321,7 +403,8 @@ calc_exit_2:
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>> +int
>> +setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_=
cp)
>> =A0{
>> =A0 =A0 =A0 int rc;
>> @@ -333,15 +416,29 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses,=
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
>> +
>> + =A0 =A0 if (ses->server->secType =3D=3D RawNTLMSSP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D find_domain_name(se=
s);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, =
"error %d finding domain name", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto setup=
_ntlmv2_rsp_ret;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_avpair_blob(ses);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error %d buildi=
ng av pair blob", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
>> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
>> - =A0 =A0 if (rc)
>> + =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get v2 hash rc %d",=
 rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_rsp_ret;
>> + =A0 =A0 }
>> =A0 =A0 =A0 CalcNTLMv2_response(ses, resp_buf);
>>
>> =A0 =A0 =A0 /* now calculate the MAC key for NTLMv2 */
>> @@ -352,6 +449,14 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, =
char *resp_buf,
>> =A0 =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_=
buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
>> =A0 =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct ntlm=
v2_resp);
>> +
>> + =A0 =A0 return 0;
>> +
>> +setup_ntlmv2_rsp_ret:
>> + =A0 =A0 kfree(ses->tiblob);
>> + =A0 =A0 ses->tilen =3D 0;
>> +
>> + =A0 =A0 return rc;
>
> So, this blob only gets freed when there's an problem calculating the
> hash? What's the value in keeping this around after session setup is
> done?
>

This blob will get freed in build_ntlmssp_negotiate_blob() once the blo=
b
is copied while building type 3 packet of ntlmssp negotiation.
That is in patch 3/4.

>> =A0}
>>
>> =A0void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>> @@ -365,6 +470,10 @@ void CalcNTLMv2_response(const struct cifsSesIn=
fo *ses,
>> =A0 =A0 =A0 hmac_md5_update(v2_session_response+8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_res=
p) - 8, &context);
>>
>> + =A0 =A0 if (ses->tilen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->tiblob,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen, &context);
>> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^
> =A0 =A0 =A0 =A0nit: that looks like it would fit on one line

Yes, will fix that.

>
>> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); *=
/
>> =A0}
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 14dfa9a..c68f31c 100644
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
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 3f4fa81..c155479 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -367,7 +367,7 @@ extern int cifs_verify_signature(struct smb_hdr =
*,
>> =A0extern int cifs_calculate_session_key(struct session_key *key, co=
nst char *rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const=
 char *pass);
>> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *, char =
*);
>> -extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct =
nls_table *);
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cr=
yptkey,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index c65c341..13c854e 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -603,13 +603,15 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
SesInfo *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
EINVAL;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->sec_kerberos |=
| server->sec_mskerberos)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->se=
cType =3D Kerberos;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (server->sec_ntlms=
sp)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->se=
cType =3D RawNTLMSSP;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EO=
PNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=3D=
 Kerberos) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!serve=
r->sec_kerberos &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 !server->sec_mskerberos)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->secType=
 =3D=3D RawNTLMSSP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!serve=
r->sec_ntlmssp)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -EOPNOTSUPP;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->capabilities &=3D ~CAP_EXTENDED_=
SECURITY;
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
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
