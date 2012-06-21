From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 02/24] CIFS: Rename 7 error codes to NT_ style
Date: Thu, 21 Jun 2012 11:54:14 +0400
Message-ID: <CAKywueR8xNTunkFE6h8VQn7hb+uK=8x=38V_LFBaLswZ3nx9GA@mail.gmail.com>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
	<1340202664-28696-3-git-send-email-pshilovsky@samba.org>
	<20120620180028.052b33ac@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120620180028.052b33ac-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/21 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Wed, 20 Jun 2012 18:30:42 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> and consider such codes as CIFS errors.
>>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0fs/cifs/nterr.c | =A0 =A06 +++---
>> =A0fs/cifs/nterr.h | =A0 26 ++++++++++++++------------
>> =A02 files changed, 17 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/cifs/nterr.c b/fs/cifs/nterr.c
>> index 819fd99..908a3c7 100644
>> --- a/fs/cifs/nterr.c
>> +++ b/fs/cifs/nterr.c
>> @@ -31,7 +31,7 @@ const struct nt_err_code_struct nt_errs[] =3D {
>> =A0 =A0 =A0 {"NT_STATUS_INVALID_INFO_CLASS", NT_STATUS_INVALID_INFO_=
CLASS},
>> =A0 =A0 =A0 {"NT_STATUS_INFO_LENGTH_MISMATCH", NT_STATUS_INFO_LENGTH=
_MISMATCH},
>> =A0 =A0 =A0 {"NT_STATUS_ACCESS_VIOLATION", NT_STATUS_ACCESS_VIOLATIO=
N},
>> - =A0 =A0 {"STATUS_BUFFER_OVERFLOW", STATUS_BUFFER_OVERFLOW},
>> + =A0 =A0 {"STATUS_BUFFER_OVERFLOW", NT_STATUS_BUFFER_OVERFLOW},
>
> Should you also change the text version of these names? Since we prin=
t
> those when debugging, then it might be nice to have them match the
> actual #define names.

Yes, it makes sense. I've fixed it in smb2-mount branch and will
respost when we finish with other patches from the series.

--=20
Best regards,
Pavel Shilovsky.
