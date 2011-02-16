From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken lanman (lm) auth code (try #2)
Date: Wed, 16 Feb 2011 14:17:35 -0600
Message-ID: <AANLkTimpCL0FwYG7-ksiEYKLrZQ8GTTNjFe=DMMUG9AM@mail.gmail.com>
References: <1297871414-11560-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110216143102.37d2119e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110216143102.37d2119e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Feb 16, 2011 at 1:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 16 Feb 2011 09:50:14 -0600
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
>> =A0fs/cifs/connect.c | =A0 =A03 +++
>> =A0fs/cifs/sess.c =A0 =A0| =A0 =A08 ++++----
>> =A0fs/cifs/smbdes.c =A0| =A0 19 ++++++++++++++++++-
>> =A03 files changed, 25 insertions(+), 5 deletions(-)
>>
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
>> index 0472148..7bdf42c 100644
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
>
> I think the above can be replaced by:
>
> =A0 =A0~(hweight8(c) & 1)
>
> ...which would likely be a lot more efficient and would make use of
> specialized hardware on CPUs that support it.
>

Yes, that works.  Thanks.
Will resubmit both the patches.

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
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] |=3D 0x1; /* add od=
d parity bit */
>> + =A0 =A0 }
>> =A0}
>>
>> =A0static void
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
