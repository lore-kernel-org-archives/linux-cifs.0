From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #4)
Date: Wed, 23 Mar 2011 12:32:03 -0500
Message-ID: <AANLkTimtOTGO6YPFwuRJGcZrxRk9VwjtA4kWOB_4RKDd@mail.gmail.com>
References: <1300229732-4902-1-git-send-email-piastry@etersoft.ru>
	<20110322074233.546d4553@corrin.poochiereds.net>
	<AANLkTinGszmNsqFbf5vVstXfEsf5sh+SUZiFexjgBxjY@mail.gmail.com>
	<20110322080409.23461155@corrin.poochiereds.net>
	<AANLkTin_dHLJLpZxnmbCM=ukg7_xBi7YHg_YRaaYUmkj@mail.gmail.com>
	<20110322111711.55365655@corrin.poochiereds.net>
	<AANLkTikMbyg6FK7tgcb-a9kc_2r-rToA2x0AvY_KHQUw@mail.gmail.com>
	<20110322123549.022e590e@corrin.poochiereds.net>
	<AANLkTim=J7Y-b07HHKypfxgXL=jpgVVaZ1hn2201Amny@mail.gmail.com>
	<AANLkTikg4WQrguR_cvvkxXZ8XomO=3ySjPzT67yO_cvk@mail.gmail.com>
	<20110322130334.0680b9a3@corrin.poochiereds.net>
	<AANLkTikSUaLsEk5CNfVMXqLN4z=UGOeyYoMkTGQBLf2A@mail.gmail.com>
	<20110322134246.4b9e497e@corrin.poochiereds.net>
	<AANLkTi=zcYODYnx1q1bzBQtt2z7w1rkRxSTNTrK4u=7d@mail.gmail.com>
	<AANLkTimBdrWfAXZ4Ea_K33PyFN_REfNwcH7JjW71mJnh@mail.gmail.com>
	<AANLkTikPTVfiz4FNwu-i=1pHjE92vQgUh+eJLHY6j9nW@mail.gmail.com>
	<20110323121428.398f4d4c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110323121428.398f4d4c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 23, 2011 at 11:14 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Wed, 23 Mar 2011 12:27:31 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/3/23 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > Pavel,
>> > Jeff and I talked about invalidate_mapping and its uses this
>> > afternoon. =A0A few comments:
>> > 1) =A0 Take a look at what happens on filemap_fdatawait call in
>> > invalidate_mapping to see if it makes sense to return errors throu=
gh
>> > back to some of the callers of invalidate_mapping, in particular,
>> > strict_fsync. =A0If we can't write out the file data (ENOSPC, or h=
ost
>> > down etc.), we want to make sure that the return code gets sent ba=
ck
>> > on any calls that can reasonably expect such an error.
>>
>> vfs_fsync_range has already done filemap_fdatawait call - so, in thi=
s
>> case there is no need to do it again in cifs_invalidate_mapping. The
>> only reason for calling this is to invalidate_inode_pages2 but any
>> error there shouldn't affect fsync behavior, as I think.
>>
>> > 2) If invalidate_inode_pages2 fails (e.g. with EBUSY, because one =
of
>> > the pages couldn't be freed from the mapping because it just got
>> > redirtied right after we flushed it the line before) we set the
>> > mapping to invalid but don't check
>> > =A0 =A0cifs_i->invalid_mapping
>> > in many places. =A0Should we add checks for cifs_i->invalid_mappin=
g in
>> > more places?
>>
>> The one place where we should add such a check is read call, but it
>> needs cifs_revalidate_file instead (that I am going to provide next)
>> before generic_file_aio_read. In this case cifs_revalidate will chec=
k
>> for invalid_mapping and needs to return a error if we could not
>> invalidate all inode pages in cifs_invalidate_mapping (because it
>> returns wrong data to the read call). But as you noticed lseek
>> shouldn't think about this error and it uses cifs_revalidate_file to=
o.
>>
>> So, we may add extra check for -EBUSY error code in callers of
>> cifs_revalidate_{dentry,file} and cifs_invaliadate_mapping and
>> separate them into two groups:
>> 1) that aware about -EBUSY error code and return a error the it's ca=
ller.
>> these are: cifs_d_revalidate, cifs_file_aio_read (future
>> implementation), cifs_file_strict_mmap.
>> 2) that doesn't aware about it and return ok in this case.
>> these are: cifs_getattrs, cifs_lseek, cifs_fsync.
>>
>> Thoughts?
>>
>
> The main reason I think we need to reconsider that error is that I
> spent several months tracking down a rather nasty data corruption bug
> relating to mmap on NFS in RHEL5 a few years ago:
>
> =A0 =A0https://bugzilla.redhat.com/show_bug.cgi?id=3D435291
>
> Part of the problem there was that the NFS client ignored the return
> code from invalidate_inode_pages2. The other part of the problem was =
a
> lack of synchronization between mmap calls and the page fault handler=
=2E
>
> Needless to say, this was not a fun problem to track down. I think yo=
u
> need to be very careful about ignoring errors from
> invalidate_inode_pages2 and think carefully about what a failure ther=
e
> means for all cases.

I agree - need to be careful, but IIRC the NFS problem would be that
it has a launder_page method which is returning an error through
invalidate_inode_pages2 while in the cifs case the data is forced to
be written out through filemap_fdatawrite or filemap_write_and_wait.



--=20
Thanks,

Steve
