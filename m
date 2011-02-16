From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken lanman (lm) auth code
Date: Wed, 16 Feb 2011 08:46:03 -0600
Message-ID: <AANLkTinVM2j9kVjreWy+Tk6VFONTo=zEj=s1k-07YViF@mail.gmail.com>
References: <1297811443-4848-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110216075346.2b69c431@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110216075346.2b69c431-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Feb 16, 2011 at 6:53 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 15 Feb 2011 17:10:43 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Fix lanman (lm) authentication code.
>>
>> Change lm response length back to 24 from 16.
>> Parse lanmani mount option.
>> Add code to add odd parity bit to each of the eight bytes of a DES k=
ey.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h | =A0 =A03 ++-
>> =A0fs/cifs/connect.c =A0| =A0 =A03 +++
>> =A0fs/cifs/sess.c =A0 =A0 | =A0 =A08 ++++----
>> =A0fs/cifs/smbdes.c =A0 | =A0 19 ++++++++++++++++++-
>> =A04 files changed, 27 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 17afb0f..0b5c950 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -710,7 +710,8 @@ require use of the stronger protocol */
>> =A0#define =A0 CIFSSEC_MUST_SEAL =A00x40040 /* not supported yet */
>> =A0#define =A0 CIFSSEC_MUST_NTLMSSP =A0 =A0 =A0 0x80080 /* raw ntlms=
sp with ntlmv2 */
>>
>> -#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFS=
SEC_MAY_NTLMV2)
>> +#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_SIGN | \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSEC_MAY_NTLM | CIFSSEC=
_MAY_NTLMV2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
> =A0 =A0 =A0 =A0Won't this change enable lanman auth by default? Is th=
at
> =A0 =A0 =A0 =A0intended?

I think it depends on what server sends in negprot response, the
minimun dialect it supports.
If the dialect is greater than Lanman2.1, the default auth mech for
cifs client is NTLM (ntlmv1)
if the dialect is less than or upto Lanman2.1, default auth mech for
cifs client is LANMAN (lm).

>
>> =A0#define =A0 CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
>> =A0#define =A0 CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTL=
MV2 | CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 | CIFS=
SEC_MAY_NTLMSSP)
>> =A0/*
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 8d6c17a..e3494df 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1014,6 +1014,9 @@ cifs_parse_mount_options(char *options, const =
char *devname,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB is=
 there a better way to do this? */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->sec=
=46lg |=3D CIFSSEC_MAY_NTLMV2;
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(value,=
 "lanmani", 7) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->secFl=
g |=3D CIFSSEC_MAY_LANMAN |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 CIFSSEC_MUST_SIGN;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(valu=
e, "lanman", 6) =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->sec=
=46lg |=3D CIFSSEC_MAY_LANMAN;
>> =A0#endif
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 1adc962..1676570 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -656,13 +656,13 @@ ssetup_ntlmssp_authenticate:
>>
>> =A0 =A0 =A0 if (type =3D=3D LANMAN) {
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> - =A0 =A0 =A0 =A0 =A0 =A0 char lnm_session_key[CIFS_SESS_KEY_SIZE];
>> + =A0 =A0 =A0 =A0 =A0 =A0 char lnm_session_key[CIFS_AUTH_RESP_SIZE];
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.hdr.Flags2 &=3D ~SMBFLG2_UNICO=
DE;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* no capabilities flags in old lanman n=
egotiation */
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 pSMB->old_req.PasswordLength =3D cpu_to_le=
16(CIFS_SESS_KEY_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 pSMB->old_req.PasswordLength =3D cpu_to_le=
16(CIFS_AUTH_RESP_SIZE);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Calculate hash with password and copy=
 into bcc_ptr.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Encryption Key (stored as in cryptk=
ey) gets used if the
>> @@ -675,8 +675,8 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 true : false, lnm_session_key);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->flags |=3D CIFS_SES_LANMAN;
>> - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)lnm_session_key, C=
IFS_SESS_KEY_SIZE);
>> - =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)lnm_session_key, C=
IFS_AUTH_RESP_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* can not sign if LANMAN negotiated so =
no need
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 to calculate signing key? but what if se=
rver
>> diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
>> index 0472148..dcfc379 100644
>> --- a/fs/cifs/smbdes.c
>> +++ b/fs/cifs/smbdes.c
>> @@ -299,6 +299,20 @@ dohash(char *out, char *in, char *key, int forw=
)
>> =A0 =A0 =A0 kfree(ki);
>> =A0}
>>
>> +static int
>> +odd_parity(unsigned char c)
>> +{
>> + =A0 =A0 int i;
>> + =A0 =A0 int val =3D 0x80;
>> + =A0 =A0 int count =3D 0;
>> +
>> + =A0 =A0 for (i =3D 0; i < 7; ++i)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (c & (val >> i))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++count;
>> +
>> + =A0 =A0 return count % 2;
>> +}
>> +
>> =A0static void
>> =A0str_to_key(unsigned char *str, unsigned char *key)
>> =A0{
>> @@ -312,8 +326,11 @@ str_to_key(unsigned char *str, unsigned char *k=
ey)
>> =A0 =A0 =A0 key[5] =3D ((str[4] & 0x1F) << 2) | (str[5] >> 6);
>> =A0 =A0 =A0 key[6] =3D ((str[5] & 0x3F) << 1) | (str[6] >> 7);
>> =A0 =A0 =A0 key[7] =3D str[6] & 0x7F;
>> - =A0 =A0 for (i =3D 0; i < 8; i++)
>> + =A0 =A0 for (i =3D 0; i < 8; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] =3D (key[i] << 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!odd_parity(key[i]))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] |=3D 0x1;
>> + =A0 =A0 }
>> =A0}
>>
>> =A0static void
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
