From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
 (try #2)
Date: Mon, 29 Nov 2010 15:16:15 +0300
Message-ID: <AANLkTim48MNa0D6be78DD8PPT7gBpqC1QK3YD6fJBMv3@mail.gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<1290931972-2770-4-git-send-email-piastryyy@gmail.com>
	<20101128063604.7d9cdded@tlielax.poochiereds.net>
	<20101128065100.51c8a404@tlielax.poochiereds.net>
	<AANLkTimO9t_wXPZRWXx856-wkG-EwRWTizrCKSo4e2SY@mail.gmail.com>
	<20101129063713.0b71ac09@tlielax.poochiereds.net>
	<4CF39901.3010108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF39901.3010108-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/29 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 11/29/2010 05:07 PM, Jeff Layton wrote:
>> On Mon, 29 Nov 2010 13:58:05 +0300
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> 2010/11/28 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>>> On Sun, 28 Nov 2010 06:36:04 -0500
>>>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>
>>>>> On Sun, 28 Nov 2010 11:12:49 +0300
>>>>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>
>>>>>> On strict cache mode if we don't have Exclusive oplock we write =
a data to
>>>>>> the server through cifs_user_write. Then if we Level II oplock s=
tore it in
>>>>>> the cache, otherwise - invalidate inode pages affected by this w=
riting.
>>>>>>
>>>>>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>>> ---
>>>>>> =EF=BF=BDfs/cifs/cifsfs.c | =EF=BF=BD 40 +++++++++++++++++++++++=
+++++++++++++----
>>>>>> =EF=BF=BD1 files changed, 36 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>>>>>> index bbb5294..901c82b 100644
>>>>>> --- a/fs/cifs/cifsfs.c
>>>>>> +++ b/fs/cifs/cifsfs.c
>>>>>> @@ -598,12 +598,44 @@ static ssize_t cifs_file_aio_read(struct k=
iocb *iocb, const struct iovec *iov,
>>>>>> =EF=BF=BDstatic ssize_t cifs_file_aio_write(struct kiocb *iocb, =
const struct iovec *iov,
>>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BDunsigned long nr_segs, loff_t pos)
>>>>>> =EF=BF=BD{
>>>>>> - =EF=BF=BD struct inode *inode =3D iocb->ki_filp->f_path.dentry=
->d_inode;
>>>>>> + =EF=BF=BD struct inode *inode;
>>>>>> + =EF=BF=BD struct cifs_sb_info *cifs_sb;
>>>>>> =EF=BF=BD =EF=BF=BD ssize_t written;
>>>>>>
>>>>>> - =EF=BF=BD written =3D generic_file_aio_write(iocb, iov, nr_seg=
s, pos);
>>>>>> - =EF=BF=BD if (!CIFS_I(inode)->clientCanCacheAll)
>>>>>> - =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD filemap_fdat=
awrite(inode->i_mapping);
>>>>>> + =EF=BF=BD inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>>>>>> +
>>>>>> + =EF=BF=BD if (CIFS_I(inode)->clientCanCacheAll)
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD return gener=
ic_file_aio_write(iocb, iov, nr_segs, pos);
>>>>>> +
>>>>>> + =EF=BF=BD cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_=
sb);
>>>>>> +
>>>>>> + =EF=BF=BD if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)=
 =3D=3D 0) {
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD int rc;
>>>>>> +
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD written =3D =
generic_file_aio_write(iocb, iov, nr_segs, pos);
>>>>>> +
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD rc =3D filem=
ap_fdatawrite(inode->i_mapping);
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD if (rc)
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD cFYI(1, "cifs_file_aio_write: %d rc on %p in=
ode",
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDrc, inode);
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD return writt=
en;
>>>>>> + =EF=BF=BD }
>>>>>> +
>>>>>> + =EF=BF=BD /* in strict cache mode we need to write the data to=
 the server exactly
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BDfrom the pos to pos+len-1 rather =
than flush all affected pages
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BDbecause it may cause a error with=
 mandatory locks on these pages but
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BDnot on the region from pos to ppo=
s+len-1 */
>>>>>
>>>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD Again, please fix the comment style=
=2E Here: ^^^^
>>>>>
>>>>>> + =EF=BF=BD written =3D cifs_user_write(iocb->ki_filp, iov->iov_=
base,
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD iov->iov_len, &pos);
>>>>>> +
>>>>>> + =EF=BF=BD iocb->ki_pos =3D pos;
>>>>>> +
>>>>>> + =EF=BF=BD /* if we were successful - invalidate inode pages th=
e write affected */
>>>>>> + =EF=BF=BD if (written > 0)
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD invalidate_m=
apping_pages(inode->i_mapping,
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD (pos-wr=
itten) >> PAGE_CACHE_SHIFT,
>>>>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD (pos-1)=
 >> PAGE_CACHE_SHIFT);
>>>>>> +
>>>>>> =EF=BF=BD =EF=BF=BD return written;
>>>>>> =EF=BF=BD}
>>>>>>
>>>>>
>>>>> May god have mercy on anyone who tries to mix strictcache and mma=
p.
>>>>>
>>>>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> (cc'ing Suresh so he can comment)
>>>>
>>>> Actually...I'm going to withdraw my Reviewed-by tag here for now. =
This
>>>> bare invalidate_mapping_pages doesn't deal with fscache.
>>>>
>>>> I think I need to understand what's intended when someone specifie=
s
>>>> strictcache and fsc before I can ack this. The simple answer would=
 be
>>>> that they are mutually exclusive, but if that's the case then the =
patch
>>>> that adds the mount option needs to deal with that appropriately.
>>>
>>>
>>> I don't think they can live together. I think we should do smth lik=
e a
>>> following in mount options parsing:
>>>
>>> ...
>>> if (opt =3D=3D fscache) {
>>> =C2=A0 =C2=A0vol->fscahe =3D 1;
>>> =C2=A0 =C2=A0vol->strictcache =3D 0;
>>> }
>>> ...
>>> if (opt =3D=3D strictcache) {
>>> =C2=A0 vol->strictcache =3D 1;
>>> =C2=A0 vol->fscache =3D 0;
>>> }
>>>
>>> So, if user specify both only the last will affect the client
>>> behavior. Also we should add this information into cifs manpage.
>>> Thoughts?
>>>
>>
>> That would one way to deal with it.
>>
>> On the other hand though...fscache allows you to keep more data cach=
ed
>> than you have RAM. This could be useful in a strictcache situation a=
s
>> well. Consider the case of an application on a client that has a lot=
 of
>> large files open for read. The server may grant oplocks on all of th=
em.
>> fscache would allow for fewer round trips to the server in such a ca=
se.
>>
>> So, another way to deal with it would be to simply invalidate the
>> fscache whenever you'd invalidate the in-ram cache. I'm not sure wha=
t
>> to do for the cifs_file_aio_write case where you're invalidating jus=
t a
>> small range however.
>>
>
> Yes, we seem to have those two options while the later has the advant=
age
> that Jeff mentioned. I think we could do the later without much of a
> problme. We just need to retire the cookies and get new ones
> (relinquishing with retire set to 1) i.e. by calling
> cifs_fscache_reset_inode_cookie(). FS-Cache does not provide data
> invalidation by itself. For the cifs_file_aio_write case too we could
> set invalid_mapping and get fresh cookies.
>

Ok, I am going to provide these changes.

--=20
Best regards,
Pavel Shilovsky.
