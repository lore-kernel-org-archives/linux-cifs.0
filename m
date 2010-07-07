From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: allow ntlmv2 ntlmssp authentication
Date: Wed, 7 Jul 2010 11:52:16 -0500
Message-ID: <AANLkTildpOmttZwCEHMiN9LRLaVuc01Srqe7UaEGu0hu@mail.gmail.com>
References: <1278126963-16111-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100707072517.1446d70e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-N0cyB0Tf/z2923ynj/IuLw@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707072517.1446d70e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 7, 2010 at 6:25 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, =A02 Jul 2010 22:16:03 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> Have kept ntlmv1 ntlmssp as a default, ntlmv2 ntlmssp can
>> be made default only by making code change.
>>
>>
>> From 3d8a8960a6d164e2bacd2a4fc96456453042e049 Mon Sep 17 00:00:00 20=
01
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Date: Fri, 2 Jul 2010 21:54:51 -0500
>> Subject: [PATCH] add ntlvm2 ntlmssp authentication
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 48 ++++++++++++++++++++++++++++++++++=
++++++++++----
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 ++
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A01 -
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 39 ++++++++++++++++++++++++++=
+++++++++++--
>> =A04 files changed, 83 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 847628d..ebfafec 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -378,6 +378,44 @@ calc_exit_2:
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> +static void
>> +find_domain_name(struct cifsSesInfo *ses)
>> +{
>> + =A0 =A0 unsigned int attrsize;
>> + =A0 =A0 unsigned int type;
>> + =A0 =A0 unsigned char *blobptr;
>> + =A0 =A0 struct ntlmssp2_name *attrptr;
>> +
>> + =A0 =A0 if (ses->server->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 blobptr =3D ses->server->tiblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobp=
tr;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 while ((type =3D attrptr->type) !=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance=
 attr type */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrsize =3D attrptr->leng=
th;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D 2; /* advance=
 attr size */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (type =3D=3D 0x2) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Magic numbers like this should be turn=
ed into names.

Yes, will make the change.

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
 =A0 =A0 =A0 =A0 =A0 return;
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blobptr +=3D attrsize; /* =
advance attr =A0value */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 attrptr =3D (struct ntlmss=
p2_name *) blobptr;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return;
>> +}
>> +
>
> Is it possible that you'll need to pick other UCS2 fields than the
> domain out of a NTLMSSP blob? If so, it might be better to turn the
> above function into a "copy the field of type X out of the blob"
> function.

I have not seen enough responses where a server does not
return a domain name field in the AV pairs it sends in type 2
message of NTLMSSP protocol.
NTLM v2 protocol is supposed to use server name in case of
servers of with local accounts.  I will have to do some code
changes and testing to determine whether authentication
succeeds or not using server name instead of domain name
returned in type 2 challenge packet.

>
>> =A0void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_=
cp)
>> =A0{
>> @@ -390,10 +428,9 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, =
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
>> + =A0 =A0 if (!ses->domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 find_domain_name(ses);
>>
>> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
>> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
>> @@ -421,6 +458,9 @@ void CalcNTLMv2_response(const struct cifsSesInf=
o *ses,
>>
>> =A0 =A0 =A0 hmac_md5_update(v2_session_response+8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_res=
p) - 8, &context);
>> + =A0 =A0 if (ses->server->tilen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->server->tiblob,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen, &conte=
xt);
>>
>> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); *=
/
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 3c55e10..db6c5da 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -188,6 +188,8 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from t=
his server */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> =A0 =A0 =A0 /* extended security flavors that server supports */
>> + =A0 =A0 unsigned int tilen; /* length of the target info blob */
>> + =A0 =A0 unsigned char *tiblob; /* target info blob in challenge re=
sponse */
>
> All of this is for NTLMSSP session setup, correct? If so, is the
> TCP_Server_Info really the right place for this? Will this break if I
> have more than one session on the same socket?

I think it will not break authentication but will break signing (and
perhaps sealing).
What would be a good place to hang is per session, per user information=
?

>
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberos; =A0 =A0 =A0 =A0 =A0 /* support=
s plain Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_mskerberos; =A0 =A0 =A0 =A0 /* supports =
legacy MS Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberosu2u; =A0 =A0 =A0 =A0/* supports =
U2U Kerberos */
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
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 0a57cb7..d1ec053 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area,=
 int bleft,
>> =A0static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
struct cifsSesInfo *ses)
>> =A0{
>> + =A0 =A0 unsigned int tioffset; /* challeng message target info are=
a */
>> + =A0 =A0 unsigned int tilen; /* challeng message target info area l=
ength =A0*/
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
>> + =A0 =A0 ses->server->tilen =3D tilen;
>> + =A0 =A0 if (tilen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tiblob =3D kmalloc(tilen, GFP=
_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->tiblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge targe=
t info allocation failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->tiblob, =A0bcc_ptr + t=
ioffset, tilen);
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> @@ -451,10 +466,12 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s=
truct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c=
onst struct nls_table *nls_cp, bool first)
>> =A0{
>> + =A0 =A0 unsigned int size;
>> =A0 =A0 =A0 AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSAGE=
 *)pbuffer;
>> =A0 =A0 =A0 __u32 flags;
>> =A0 =A0 =A0 unsigned char *tmp;
>> =A0 =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZE];
>> + =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
>>
>> =A0 =A0 =A0 memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
>> =A0 =A0 =A0 sec_blob->MessageType =3D NtLmAuthenticate;
>> @@ -477,6 +494,7 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.Length =3D 0;
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.MaximumLength =3D 0;
>>
>> +#if 1
> =A0^^^^^^^
> Why are you adding code that's always compiled out?

Right now we are using ntlmv1 as a default authentication mechanism in =
NTLMSSP.
I am not sure whether we can just switch to ntlmv2 as an
authentication mechanism.
I think in case of Windows servers, an LmCompatibilityLevel registry
setting of 0 through 5
will accept NTLMv2 response but not sure how it is handled by other
servers i.e. are
there servers out there who will/can't handle ntlmv2 authentication
mechanism within
NTLMSSP.

>
>> =A0 =A0 =A0 /* calculate session key, =A0BB what about adding simila=
r ntlmv2 path? */
>> =A0 =A0 =A0 SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_=
session_key);
>> =A0 =A0 =A0 if (first)
>> @@ -491,6 +509,25 @@ static int build_ntlmssp_auth_blob(unsigned cha=
r *pbuffer,
>>
>> =A0 =A0 =A0 tmp +=3D CIFS_SESS_KEY_SIZE;
>>
>> +#else
>> + =A0 =A0 sec_blob->NtChallengeResponse.BufferOffset =3D cpu_to_le32=
(tmp - pbuffer);
>> + =A0 =A0 setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
>> + =A0 =A0 size =3D =A0sizeof(struct ntlmv2_resp);
>> + =A0 =A0 memcpy(tmp, (char *)&ntlmv2_response, size);
>> + =A0 =A0 tmp +=3D size;
>> + =A0 =A0 if (ses->server->tilen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->server->tiblob, ses->serv=
er->tilen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->server->tiblob);
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D ses->server->tilen;
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 0;
>> +
>> + =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(size =
+
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->serve=
r->tilen);
>> + =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(size + ses->server->tilen);
>> +#endif
>> +
>> =A0 =A0 =A0 if (ses->domainName =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D 0;
>> @@ -501,7 +538,6 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses=
->domainName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D cpu_to_l=
e16(len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.MaximumLength =3D c=
pu_to_le16(len);
>> @@ -518,7 +554,6 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses=
->userName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cpu_=
to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D cpu_to_le1=
6(len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.MaximumLength =3D cpu=
_to_le16(len);
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
