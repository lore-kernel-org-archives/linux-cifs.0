From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v4 5/5] CIFS: Separate protocol specific part from setlk
Date: Wed, 16 May 2012 22:57:18 +0400
Message-ID: <CAKywueTrEXy4epakk=LJZU2XtOUizxuCygHjdEF9AOSQHuCDOg@mail.gmail.com>
References: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
	<1337162254-13121-6-git-send-email-piastry@etersoft.ru>
	<20120516143134.7871db3f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120516143134.7871db3f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 16 May 2012 13:57:34 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0 =A04 ++--
>> =A01 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 9c2d85d..ed9b5a8 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1357,8 +1357,8 @@ cifs_setlk(struct file *file, =A0struct file_l=
ock *flock, __u32 type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, curr=
ent->tgid, length,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock->=
fl_start, 0, 1, type, wait_flag, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_mandatory_lock(xid, cfile, flo=
ck->fl_start, length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0type, 1, 0, wait_flag);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>
> You can probably roll this in with patch #4 since it's a very similar
> change and so small...
>
> Looks fine though. I guess at some point you'll need to add a
> ops->mandatory_lock or something?

Yes - it will be the next step.

--=20
Best regards,
Pavel Shilovsky.
