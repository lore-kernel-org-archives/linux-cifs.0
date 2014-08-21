From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/7] cifs: Allow directIO read/write during cache=strict
Date: Thu, 21 Aug 2014 08:24:35 -0500
Message-ID: <CAH2r5mu6LH1YLqWhi4-1dgJH0BQ2CS5Lbym1mGP9EuvgtCP1Wg@mail.gmail.com>
References: <003501cfbc62$fac9f4b0$f05dde10$@samsung.com> <20140821072656.372e613c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140821072656.372e613c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If you are opening O_DIRECT why wouldn't you use oplock, ie still
request oplock, simply to minimize metadata traffic (you don't have to
send stat across the wire).  The reads and writes aren't cached but
the inode metadata would be.

On Thu, Aug 21, 2014 at 6:26 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:
> On Wed, 20 Aug 2014 19:39:11 +0900
> Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>
>> Currently cifs have all or nothing approach for directIO operations.
>> cache=strict mode does not allow directIO while cache=none mode performs
>> all the operations as directIO even when user does not specify O_DIRECT
>> flag. This patch enables strict cache mode to honour directIO semantics.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  fs/cifs/dir.c  |    4 ++++
>>  fs/cifs/file.c |    4 ++++
>>  2 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index 3db0c5f..30e377c 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -497,6 +497,10 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>>               goto out;
>>       }
>>
>> +     if (file->f_flags & O_DIRECT &&
>> +         CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
>> +             file->f_op = &cifs_file_direct_ops;
>> +
>>       file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
>>       if (file_info == NULL) {
>>               if (server->ops->close)
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index bee733e..0d07740 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -467,6 +467,10 @@ int cifs_open(struct inode *inode, struct file *file)
>>       cifs_dbg(FYI, "inode = 0x%p file flags are 0x%x for %s\n",
>>                inode, file->f_flags, full_path);
>>
>> +     if (file->f_flags & O_DIRECT &&
>> +         cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
>> +             file->f_op = &cifs_file_direct_ops;
>> +
>>       if (server->oplocks)
>>               oplock = REQ_OPLOCK;
>>       else
>
> Looks fine for the most part. You should also avoid requesting an
> oplock if you're going to open O_DIRECT since you won't be using it
> anyway.
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>



-- 
Thanks,

Steve
