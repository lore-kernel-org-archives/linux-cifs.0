From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken lanman (lm) auth code
Date: Tue, 15 Feb 2011 17:37:06 -0600
Message-ID: <AANLkTin4D+EMeTo90Zf92w8uD8t=Kmysy3XigjQdbp4O@mail.gmail.com>
References: <1297811443-4848-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297811443-4848-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a candidate for merge late in this cycle - so any "tested-by"
or "reviewed-by" would be appreciated to help decide whether to
include it this late.

On Tue, Feb 15, 2011 at 5:10 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Fix lanman (lm) authentication code.
>
> Change lm response length back to 24 from 16.
> Parse lanmani mount option.
> Add code to add odd parity bit to each of the eight bytes of a DES ke=
y.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 =A03 ++-
> =A0fs/cifs/connect.c =A0| =A0 =A03 +++
> =A0fs/cifs/sess.c =A0 =A0 | =A0 =A08 ++++----
> =A0fs/cifs/smbdes.c =A0 | =A0 19 ++++++++++++++++++-
> =A04 files changed, 27 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 17afb0f..0b5c950 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -710,7 +710,8 @@ require use of the stronger protocol */
> =A0#define =A0 CIFSSEC_MUST_SEAL =A0 =A00x40040 /* not supported yet =
*/
> =A0#define =A0 CIFSSEC_MUST_NTLMSSP 0x80080 /* raw ntlmssp with ntlmv=
2 */
>
> -#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSS=
EC_MAY_NTLMV2)
> +#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_SIGN | \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSEC_MAY_NTLM | CIFS=
SEC_MAY_NTLMV2)
> =A0#define =A0 CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
> =A0#define =A0 CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLM=
V2 | CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 | CIFSS=
EC_MAY_NTLMSSP)
> =A0/*
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8d6c17a..e3494df 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1014,6 +1014,9 @@ cifs_parse_mount_options(char *options, const c=
har *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB =
is there a better way to do this? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->s=
ecFlg |=3D CIFSSEC_MAY_NTLMV2;
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(val=
ue, "lanmani", 7) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->se=
cFlg |=3D CIFSSEC_MAY_LANMAN |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFSSEC_MUST_SIGN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(va=
lue, "lanman", 6) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->s=
ecFlg |=3D CIFSSEC_MAY_LANMAN;
> =A0#endif
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 1adc962..1676570 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -656,13 +656,13 @@ ssetup_ntlmssp_authenticate:
>
> =A0 =A0 =A0 =A0if (type =3D=3D LANMAN) {
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char lnm_session_key[CIFS_SESS_KEY_SIZE=
];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char lnm_session_key[CIFS_AUTH_RESP_SIZ=
E];
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req.hdr.Flags2 &=3D ~SMBFLG2_UNI=
CODE;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* no capabilities flags in old lanman=
 negotiation */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->old_req.PasswordLength =3D cpu_to=
_le16(CIFS_SESS_KEY_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->old_req.PasswordLength =3D cpu_to=
_le16(CIFS_AUTH_RESP_SIZE);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Calculate hash with password and co=
py into bcc_ptr.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Encryption Key (stored as in cryptk=
ey) gets used if the
> @@ -675,8 +675,8 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0true : false, lnm_session_key);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->flags |=3D CIFS_SES_LANMAN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)lnm_session_key=
, CIFS_SESS_KEY_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)lnm_session_key=
, CIFS_AUTH_RESP_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* can not sign if LANMAN negotiated s=
o no need
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to calculate signing key? but what if =
server
> diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
> index 0472148..dcfc379 100644
> --- a/fs/cifs/smbdes.c
> +++ b/fs/cifs/smbdes.c
> @@ -299,6 +299,20 @@ dohash(char *out, char *in, char *key, int forw)
> =A0 =A0 =A0 =A0kfree(ki);
> =A0}
>
> +static int
> +odd_parity(unsigned char c)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 int val =3D 0x80;
> + =A0 =A0 =A0 int count =3D 0;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < 7; ++i)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (c & (val >> i))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++count;
> +
> + =A0 =A0 =A0 return count % 2;
> +}
> +
> =A0static void
> =A0str_to_key(unsigned char *str, unsigned char *key)
> =A0{
> @@ -312,8 +326,11 @@ str_to_key(unsigned char *str, unsigned char *ke=
y)
> =A0 =A0 =A0 =A0key[5] =3D ((str[4] & 0x1F) << 2) | (str[5] >> 6);
> =A0 =A0 =A0 =A0key[6] =3D ((str[5] & 0x3F) << 1) | (str[6] >> 7);
> =A0 =A0 =A0 =A0key[7] =3D str[6] & 0x7F;
> - =A0 =A0 =A0 for (i =3D 0; i < 8; i++)
> + =A0 =A0 =A0 for (i =3D 0; i < 8; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0key[i] =3D (key[i] << 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!odd_parity(key[i]))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] |=3D 0x1;
> + =A0 =A0 =A0 }
> =A0}
>
> =A0static void
> --
> 1.6.0.2
>
>



--=20
Thanks,

Steve
