From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix broken sec=ntlmv2/i sec option (try #2)
Date: Thu, 25 Aug 2011 06:39:22 -0500
Message-ID: <CADT32eJSqTdsQL+oc0ibUVt0Qy+jpNyqRCxteWOdEQoXXx3n8Q@mail.gmail.com>
References: <1314245146-1401-1-git-send-email-shirishpargaonkarp@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314245146-1401-1-git-send-email-shirishpargaonkarp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 24, 2011 at 11:05 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Fix sec=3Dntlmv2/i authentication option during mount of Samba shares=
=2E
>
> cifs client was coding ntlmv2 response incorrectly.
> All that is needed in temp as specified in MS-NLMP seciton 3.3.2
>
> "Define ComputeResponse(NegFlg, ResponseKeyNT, ResponseKeyLM,
> CHALLENGE_MESSAGE.ServerChallenge, ClientChallenge, Time, ServerName)
>
> as
> Set temp to ConcatenationOf(Responserversion, HiResponserversion,
> Z(6), Time, ClientChallenge, Z(4), ServerName, Z(4)"
>
> is MsvAvNbDomainName.
>
>
> For sec=3Dntlmsspi, build_av_pair is not used, a blob is plucked from
> type 2 response sent by the server to use in authentication.
>
> I tested sec=3Dntlmv2/i and sec=3Dntlmssp/i mount options against
> Samba (3.6) and Windows - XP, 2003 Server and 7.
> They all worked.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 54 ++++++++++-------------------------=
--------------
> =A01 files changed, 11 insertions(+), 43 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index e76bfeb..30acd22 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -351,9 +351,7 @@ static int
> =A0build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nl=
s_cp)
> =A0{
> =A0 =A0 =A0 =A0unsigned int dlen;
> - =A0 =A0 =A0 unsigned int wlen;
> - =A0 =A0 =A0 unsigned int size =3D 6 * sizeof(struct ntlmssp2_name);
> - =A0 =A0 =A0 __le64 =A0curtime;
> + =A0 =A0 =A0 unsigned int size =3D 2 * sizeof(struct ntlmssp2_name);
> =A0 =A0 =A0 =A0char *defdmname =3D "WORKGROUP";
> =A0 =A0 =A0 =A0unsigned char *blobptr;
> =A0 =A0 =A0 =A0struct ntlmssp2_name *attrptr;
> @@ -365,15 +363,14 @@ build_avpair_blob(struct cifs_ses *ses, const s=
truct nls_table *nls_cp)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0dlen =3D strlen(ses->domainName);
> - =A0 =A0 =A0 wlen =3D strlen(ses->server->hostname);
>
> - =A0 =A0 =A0 /* The length of this blob is a size which is
> - =A0 =A0 =A0 =A0* six times the size of a structure which holds name=
/size +
> - =A0 =A0 =A0 =A0* two times the unicode length of a domain name +
> - =A0 =A0 =A0 =A0* two times the unicode length of a server name +
> - =A0 =A0 =A0 =A0* size of a timestamp (which is 8 bytes).
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* The length of this blob is two times the size of a
> + =A0 =A0 =A0 =A0* structure (av pair) which holds name/size
> + =A0 =A0 =A0 =A0* ( for NTLMSSP_AV_NB_DOMAIN_NAME followed by NTLMSS=
P_AV_EOL ) +
> + =A0 =A0 =A0 =A0* unicode length of a netbios domain name
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 ses->auth_key.len =3D size + 2 * (2 * dlen) + 2 * (2 * =
wlen) + 8;
> + =A0 =A0 =A0 ses->auth_key.len =3D size + 2 * dlen;
> =A0 =A0 =A0 =A0ses->auth_key.response =3D kzalloc(ses->auth_key.len, =
GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!ses->auth_key.response) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.len =3D 0;
> @@ -384,44 +381,15 @@ build_avpair_blob(struct cifs_ses *ses, const s=
truct nls_table *nls_cp)
> =A0 =A0 =A0 =A0blobptr =3D ses->auth_key.response;
> =A0 =A0 =A0 =A0attrptr =3D (struct ntlmssp2_name *) blobptr;
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* As defined in MS-NTLM 3.3.2, just this av pair fie=
ld
> + =A0 =A0 =A0 =A0* is sufficient as part of the temp
> + =A0 =A0 =A0 =A0*/
> =A0 =A0 =A0 =A0attrptr->type =3D cpu_to_le16(NTLMSSP_AV_NB_DOMAIN_NAM=
E);
> =A0 =A0 =A0 =A0attrptr->length =3D cpu_to_le16(2 * dlen);
> =A0 =A0 =A0 =A0blobptr =3D (unsigned char *)attrptr + sizeof(struct n=
tlmssp2_name);
> =A0 =A0 =A0 =A0cifs_strtoUCS((__le16 *)blobptr, ses->domainName, dlen=
, nls_cp);
>
> - =A0 =A0 =A0 blobptr +=3D 2 * dlen;
> - =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
> -
> - =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_NB_COMPUTER_NA=
ME);
> - =A0 =A0 =A0 attrptr->length =3D cpu_to_le16(2 * wlen);
> - =A0 =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct nt=
lmssp2_name);
> - =A0 =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->server->hostname,=
 wlen, nls_cp);
> -
> - =A0 =A0 =A0 blobptr +=3D 2 * wlen;
> - =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
> -
> - =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_DNS_DOMAIN_NAM=
E);
> - =A0 =A0 =A0 attrptr->length =3D cpu_to_le16(2 * dlen);
> - =A0 =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct nt=
lmssp2_name);
> - =A0 =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->domainName, dlen,=
 nls_cp);
> -
> - =A0 =A0 =A0 blobptr +=3D 2 * dlen;
> - =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
> -
> - =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_DNS_COMPUTER_N=
AME);
> - =A0 =A0 =A0 attrptr->length =3D cpu_to_le16(2 * wlen);
> - =A0 =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct nt=
lmssp2_name);
> - =A0 =A0 =A0 cifs_strtoUCS((__le16 *)blobptr, ses->server->hostname,=
 wlen, nls_cp);
> -
> - =A0 =A0 =A0 blobptr +=3D 2 * wlen;
> - =A0 =A0 =A0 attrptr =3D (struct ntlmssp2_name *) blobptr;
> -
> - =A0 =A0 =A0 attrptr->type =3D cpu_to_le16(NTLMSSP_AV_TIMESTAMP);
> - =A0 =A0 =A0 attrptr->length =3D cpu_to_le16(sizeof(__le64));
> - =A0 =A0 =A0 blobptr =3D (unsigned char *)attrptr + sizeof(struct nt=
lmssp2_name);
> - =A0 =A0 =A0 curtime =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME)=
);
> - =A0 =A0 =A0 memcpy(blobptr, &curtime, sizeof(__le64));
> -
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> --
> 1.6.0.2
>
>

This is the code we had before, hardcoded, for raw ntlmv2
before code was changed to add ntlmv2 within ntlmssp.

Regards,

Shirish
