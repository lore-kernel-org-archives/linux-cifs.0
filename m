From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix broken lanman (lm) auth code (try #4)
Date: Wed, 16 Feb 2011 23:23:43 -0600
Message-ID: <AANLkTi=ZVzbtfhfOk7W8nrDo7z+r1-sEnBrm_K5onWyA@mail.gmail.com>
References: <1297901128-23418-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110216205215.40c6b7c3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110216205215.40c6b7c3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Feb 16, 2011 at 7:52 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 16 Feb 2011 18:05:28 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Fix lanman (lm) authentication code.
>>
>> Change lm response length back to 24 from 16.
>> Add code to add odd parity bit to each of the eight bytes of a DES k=
ey.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/sess.c =A0 | =A0 =A08 ++++----
>> =A0fs/cifs/smbdes.c | =A0 =A05 ++++-
>> =A02 files changed, 8 insertions(+), 5 deletions(-)
>>
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
>> index 0472148..0ab5def 100644
>> --- a/fs/cifs/smbdes.c
>> +++ b/fs/cifs/smbdes.c
>> @@ -312,8 +312,11 @@ str_to_key(unsigned char *str, unsigned char *k=
ey)
>> =A0 =A0 =A0 key[5] =3D ((str[4] & 0x1F) << 2) | (str[5] >> 6);
>> =A0 =A0 =A0 key[6] =3D ((str[5] & 0x3F) << 1) | (str[6] >> 7);
>> =A0 =A0 =A0 key[7] =3D str[6] & 0x7F;
>> - =A0 =A0 for (i =3D 0; i < 8; i++)
>> + =A0 =A0 for (i =3D 0; i < 8; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] =3D (key[i] << 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (~(hweight8(key[i]) & 1))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] |=3D 0x1; /* add od=
d parity bit */
>> + =A0 =A0 }
>
> This doesn't look right:
>
> hweight8 will return an unsigned int. You & that with 1, so you'll
> either get 0x1 (for odd number of bits) or 0x0 (for even). Then take
> the one's compliment of that and you'll either have 0xfffffffe (odd) =
or
> 0xffffffff (even), both of which will return true.
>
> I think you'll need to do this differently -- perhaps something like
> this which also has the advantage of avoiding the if statement:
>
> =A0 =A0 =A0 =A0/* set the odd parity bit */
> =A0 =A0 =A0 =A0key[i] |=3D (~(hweight8(key[i]) & 1)) & 1;
>
> ...though be sure to step through the bitwise logic by hand to make
> sure I've got it right. There may also be more efficient ways to do
> this that I don't see right offhand.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

I think this code determines whether a number is even or not, it does
not check whether a character has even or odd parity, e.g. 0x52
is even but has odd parity and so an odd parity bit need not be added
at the 0th bit.
I think I should go back to the function odd_parity that for sure retur=
ns
false if a character does not have odd parity.
