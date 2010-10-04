From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/7 cifs] ntlm authentication and signing - Build a proper
 av/ti pair blob for ntlmv2 without extended security authentication
Date: Mon, 4 Oct 2010 08:36:45 -0500
Message-ID: <AANLkTikPTGdd7rt1Ext=5PQuAuDiGF_ZjnbFEM3v8g1W@mail.gmail.com>
References: <1285771144-23099-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101004064635.5d2eb0ba@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101004064635.5d2eb0ba-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 4, 2010 at 5:46 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 29 Sep 2010 09:39:04 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Build a av pair blob as part of ntlmv2 (without extended security) a=
uth
>> request. =A0Include netbios and dns names for domain and server and
>> a timestamp in the blob.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 83 ++++++++++++++++++++++++++++++++++=
++++++++------
>> =A01 files changed, 72 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 730038a..7ca9c80 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -263,27 +263,88 @@ void calc_lanman_hash(const char *password, co=
nst char *cryptkey, bool encrypt,
>> =A0}
>> =A0#endif /* CIFS_WEAK_PW_HASH */
>>
>> -/* This is just a filler for ntlmv2 type of security mechanisms.
>> - * Older servers are not very particular about the contents of av p=
airs
>> - * in the blob and for sec mechs like ntlmv2, there is no negotiati=
on
>> - * as in ntlmssp, so unless domain and server =A0netbios and dns na=
mes
>> - * are specified, there is no way to obtain name. =A0In case of ntl=
mssp,
>> - * server provides that info in type 2 challenge packet
>> +/* Build a proper attribute value/target info pairs blob.
>> + * Fill in netbios and dns domain name and workstation name
>> + * and client time (total five av pairs and + one end of fields ind=
icator.
>> + * Allocate domain name which gets freed when session struct is dea=
llocated.
>> =A0 */
>> =A0static int
>> -build_avpair_blob(struct cifsSesInfo *ses)
>> +build_avpair_blob(struct cifsSesInfo *ses, const struct nls_table *=
nls_cp)
>> =A0{
>> + =A0 =A0 unsigned int dlen;
>> + =A0 =A0 unsigned int wlen;
>> + =A0 =A0 unsigned int size =3D 6 * sizeof(struct ntlmssp2_name);
>> + =A0 =A0 __le64 =A0curtime;
>> + =A0 =A0 char *defdmname =3D "WORKGROUP";
>> + =A0 =A0 unsigned char *blobptr;
>> =A0 =A0 =A0 struct ntlmssp2_name *attrptr;
>>
>> - =A0 =A0 ses->tilen =3D 2 * sizeof(struct ntlmssp2_name);
>> + =A0 =A0 if (ses->domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 dlen =3D strlen(ses->domainName);
>> + =A0 =A0 else =A0{
>> + =A0 =A0 =A0 =A0 =A0 =A0 dlen =3D strlen(defdmname);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->domainName =3D kmalloc(dlen + 1, GFP_=
KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 strcpy(ses->domainName, defdmname);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 wlen =3D strlen(ses->server->hostname);
>> +
>> + =A0 =A0 ses->tilen =3D size + 2 * (2 * dlen) + 2 * (2 * wlen) + 8;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0A comment explaining the above calculation would be ni=
ce.
>

Yes, will do.

>> =A0 =A0 =A0 ses->tiblob =3D kzalloc(ses->tilen, GFP_KERNEL);
>> =A0 =A0 =A0 if (!ses->tiblob) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Challenge target info allocat=
ion failure");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> =A0 =A0 =A0 }
>> - =A0 =A0 attrptr =3D (struct ntlmssp2_name *) ses->tiblob;
>> - =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
>> +
>> + =A0 =A0 blobptr =3D ses->tiblob;
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_NB_DOMAIN_NAME);
>> + =A0 =A0 attrptr->length =3D cpu_to_le16(2 * dlen);
>> + =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct ntlms=
sp2_name);
>> + =A0 =A0 if (ses->domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->doma=
inName, dlen, nls_cp);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, defdmname=
, dlen, nls_cp);
>> +
>> + =A0 =A0 blobptr +=3D 2 * dlen;
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_NB_COMPUTER_NAME)=
;
>> + =A0 =A0 attrptr->length =3D cpu_to_le16(2 * wlen);
>> + =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct ntlms=
sp2_name);
>> + =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->server->hostname, wl=
en, nls_cp);
>> +
>> + =A0 =A0 blobptr +=3D 2 * wlen;
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_DNS_DOMAIN_NAME);
>> + =A0 =A0 attrptr->length =3D cpu_to_le16(2 * dlen);
>> + =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct ntlms=
sp2_name);
>> + =A0 =A0 if (ses->domainName)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->doma=
inName, dlen, nls_cp);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, defdmname=
, dlen, nls_cp);
>> +
>> + =A0 =A0 blobptr +=3D 2 * dlen;
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_DNS_COMPUTER_NAME=
);
>> + =A0 =A0 attrptr->length =3D cpu_to_le16(2 * wlen);
>> + =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct ntlms=
sp2_name);
>> + =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->server->hostname, wl=
en, nls_cp);
>> +
>> + =A0 =A0 blobptr +=3D 2 * wlen;
>> + =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
>> +
>> + =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_TIMESTAMP);
>> + =A0 =A0 attrptr->length =3D cpu_to_le16(sizeof(__le64));
>> + =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct ntlms=
sp2_name);
>> + =A0 =A0 curtime =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
>> + =A0 =A0 memcpy(blobptr, &curtime, sizeof(__le64));
>>
>> =A0 =A0 =A0 return 0;
>> =A0}
>> @@ -426,7 +487,7 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *=
resp_buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_avpair_blob(ses);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_avpair_blob(ses, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error %d buil=
ding av pair blob", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>
> The rest looks reasonable.
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
