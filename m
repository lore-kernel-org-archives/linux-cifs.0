From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/1] cifs: potential missing check for posix_lock_file_wait
Date: Wed, 20 May 2015 13:16:21 -0500
Message-ID: <CAH2r5mtWswgO0D63aJLuEOWaoBSy3=D0Cm0gvHwhErMg8OZ0OA@mail.gmail.com>
References: <1427242729-11515-1-git-send-email-csong84@gatech.edu> <20150403081125.7ad668b6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chengyu Song <csong84@gatech.edu>,
	Steve French <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>, taesoo@gatech.edu,
	changwoo@gatech.edu, sanidhya@gatech.edu,
	Byoungyoung Lee <blee@gatech.edu>,
	Pavel Shilovsky <piastryyy@gmail.com>
To: Jeff Layton <jeff.layton@primarydata.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150403081125.7ad668b6@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Apr 3, 2015 at 7:11 AM, Jeff Layton <jeff.layton@primarydata.com> wrote:
> On Tue, 24 Mar 2015 20:18:49 -0400
> Chengyu Song <csong84@gatech.edu> wrote:
>
>> posix_lock_file_wait may fail under certain circumstances, and its result is
>> usually checked/returned. But given the complexity of cifs, I'm not sure if
>> the result is intentially left unchecked and always expected to succeed.
>>
>> Signed-off-by: Chengyu Song <csong84@gatech.edu>
>> ---
>>  fs/cifs/file.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index a94b3e6..beef67b 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1553,8 +1553,8 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
>>               rc = server->ops->mand_unlock_range(cfile, flock, xid);
>>
>>  out:
>> -     if (flock->fl_flags & FL_POSIX)
>> -             posix_lock_file_wait(file, flock);
>> +     if (flock->fl_flags & FL_POSIX && !rc)
>> +             rc = posix_lock_file_wait(file, flock);
>>       return rc;
>>  }
>>
>
> (cc'ing Pavel since he wrote a lot of this code)
>
> I think your patch looks correct -- if we (for instance) get a memory
> allocation failure while trying to set the local lock then I think we
> probably don't want to return success. So...
>
>     Acked-by: Jeff Layton <jeff.layton@primarydata.com>



-- 
Thanks,

Steve
