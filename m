From: Chengyu Song <csong84@gatech.edu>
Subject: Re: [PATCH 1/1] cifs: potential missing check for posix_lock_file_wait
Date: Wed, 25 Mar 2015 13:26:19 -0400
Message-ID: <DA9C1BDB-D7FC-41A9-BB37-A81FDA5321BA@gatech.edu>
References: <1427242729-11515-1-git-send-email-csong84@gatech.edu> <CAH2r5mvpaoSDYesP7=v9zoVqqNunpqs1k34F8KivoXRVkGHtww@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Steve French <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>, taesoo@gatech.edu,
	changwoo@gatech.edu, sanidhya@gatech.edu,
	Byoungyoung Lee <blee@gatech.edu>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mvpaoSDYesP7=v9zoVqqNunpqs1k34F8KivoXRVkGHtww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


> On Mar 24, 2015, at 10:29 PM, Steve French <smfrench@gmail.com> wrote:
> 
> On Tue, Mar 24, 2015 at 7:18 PM, Chengyu Song <csong84@gatech.edu> wrote:
>> posix_lock_file_wait may fail under certain circumstances, and its result is
>> usually checked/returned. But given the complexity of cifs, I'm not sure if
>> the result is intentially left unchecked and always expected to succeed.
>> 
>> Signed-off-by: Chengyu Song <csong84@gatech.edu>
>> ---
>> fs/cifs/file.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index a94b3e6..beef67b 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1553,8 +1553,8 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
>>                rc = server->ops->mand_unlock_range(cfile, flock, xid);
>> 
>> out:
>> -       if (flock->fl_flags & FL_POSIX)
>> -               posix_lock_file_wait(file, flock);
>> +       if (flock->fl_flags & FL_POSIX && !rc)
>> +               rc = posix_lock_file_wait(file, flock);
>>        return rc;
>> }
>> 
> 
> This is interesting.   Useful comparisons include
> 
> For network file systems you could
> - enforce byte range locks only at the server
> - enforce locks only on the client, and don't send to the server
> - do both
> 
> Since cifs byte range locks are often emulated (except when Unix
> Extensions are enabled, e.g. on mounts to Samba), we do the latter by
> default, as does fs/9p (although they do it in a different order,
> trying to grab the local byte range lock first).
> 
> But another interesting comparison point is nfs, where the code for v3
> vs. v4 looks different. Take a look at nfsv3 (see fs/nfs/file.c) where
> the choice is made to either do the posix_lock_file_wait (if 'local'
> locking only) or if sending locks to the server then don't call to set
> the local lock. Alternatively nfs4proc.c handles it differently.
> 
> There may not be a perfect answer on this one but was wondering if you
> have experimented with what happens when you mount with "nobrl" (which
> is the cifs mount option which causes locks not to be sent to the
> server, and thus only evaulted locally).  My suspicion is that you can
> demonstrate a failure if you mount with nobrl (without your patch).
> 

Maybe it's better to provide more context. We're developing a static checker that
cross check different implementations of filesystems, and this is a warning we get
from that tool as it is the only place where the return value of posix_lock_file_wait
is not checked/forwarded. So I have not experimented with mounting options.

And I guess another thing is, for the path of posix_lock == false, posix_lock_file_wait
is never invoked if any error happens. But for CIFSSMBPosixLock, its return value
is never checked and posix_lock_file_wait is always invoked.

Thanks,
Chengyu