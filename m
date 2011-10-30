From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] CIFS: Fix the VFS brlock cache usage in posix locking case
Date: Sun, 30 Oct 2011 09:56:09 -0500
Message-ID: <CAH2r5mvqcrW6y3ekAEs78Qq2tA2SdjhtfqX7k3f5y24HHdjBDA@mail.gmail.com>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
	<20111030014835.12928ab3@corrin.poochiereds.net>
	<CAKywueSzd0yjGzs99yaAUJZ1fD7LiPTt4s3TZa45oCGQprQ6nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSzd0yjGzs99yaAUJZ1fD7LiPTt4s3TZa45oCGQprQ6nQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Oct 30, 2011 at 4:26 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> 2011/10/30 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> On Sat, 29 Oct 2011 17:17:57 +0400
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>>> Request to the cache in FL_POSIX case only.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> ---
>>> =A0fs/cifs/file.c | =A0 10 ++++++++--
>>> =A01 files changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>>> index 91e05f2..c1f063c 100644
>>> --- a/fs/cifs/file.c
>>> +++ b/fs/cifs/file.c
>>> @@ -793,6 +793,9 @@ cifs_posix_lock_test(struct file *file, struct =
file_lock *flock)
>>> =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.de=
ntry->d_inode);
>>> =A0 =A0 =A0 unsigned char saved_type =3D flock->fl_type;
>>>
>>> + =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> +
>>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>> =A0 =A0 =A0 posix_test_lock(file, flock);
>>>
>>> @@ -809,12 +812,15 @@ static int
>>> =A0cifs_posix_lock_set(struct file *file, struct file_lock *flock)
>>> =A0{
>>> =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(file->f_path.de=
ntry->d_inode);
>>> - =A0 =A0 int rc;
>>> + =A0 =A0 int rc =3D 1;
>>> +
>>> + =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>>
>>> =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
>>> =A0 =A0 =A0 if (!cinode->can_cache_brlcks) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>> =A0 =A0 =A0 }
>>> =A0 =A0 =A0 rc =3D posix_lock_file_wait(file, flock);
>>> =A0 =A0 =A0 mutex_unlock(&cinode->lock_mutex);
>>
>> Hmm... I do have an open samba.org bug to allow flock() to work on c=
ifs
>> as well. Would that be doable with your new locking code? In any cas=
e,
>> this seems ok:
>>
>> Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
> Thanks for the review.
>
> Do you mean https://bugzilla.samba.org/show_bug.cgi?id=3D6843 ?
>
> I don't see any problems with implementing flock() on top of the new
> locking code. We will treat it as usual brlock from 0 to offset_max -
> the only difference is when we negotiate posix locking we should call
> flock_lock_file_wait rather than posix_lock_file_wait (add such a
> check in cifs_posix_lock_test and cifs_posix_lock_set).

yes


--=20
Thanks,

Steve
