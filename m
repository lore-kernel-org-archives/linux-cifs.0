From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] Implement SMB3 leases support
Date: Sun, 8 Sep 2013 17:54:49 -0500
Message-ID: <CAH2r5mv7J5E7uM+jjd=5vXcDnYudjzSaXvYEs00s4DxkJc9JMg@mail.gmail.com>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
	<CAKywueSL-rv=u_6XFcoBCBU-Ar5Z82SVRKqXscPgSETUWVfE1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSL-rv=u_6XFcoBCBU-Ar5Z82SVRKqXscPgSETUWVfE1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FYI - The 5th patch in the series has a merge error when based on Jeff
and Shirish's serieses.

[PATCH] CIFS: Move creating lease buffer to ops struct

 I will look at it later - but let me know if you already have a
rebased version.

Also would be useful if there were more review feedback on these - but
they seem promising so far.  Let me know if you have gotten any
offlist feedback because I didn't see much on the list on these

On Thu, Sep 5, 2013 at 3:25 PM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 2013/9/6 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> The goal of this patchset is to add SMB3 leases support.
>>
>> The first two patches fixes existing problems in lease break processing code and targeted to stable as well.
>>
>> Then the code is prepared to make adding SMB3 leases easier (patches #3-#6).
>>
>> Finaly in last two patches create lease v2 context is added and epoch value from the response is respected.
>>
>> Pavel Shilovsky (8):
>>   CIFS: Fix memory leak when a lease break comes
>>   CIFS: Fix missing lease break from a client
>>   CIFS: Replace clientCanCache* bools with an integer
>>   CIFS: Store lease state itself rather than a mapped oplock value
>>   CIFS: Move creating lease buffer to ops struct
>>   CIFS: Move parsing lease buffer to ops struct
>>   CIFS: Add create lease v2 context for SMB3
>>   CIFS: Respect epoch value from create lease context v2
>>
>>  fs/cifs/cifsfs.c    |   34 ++++---
>>  fs/cifs/cifsglob.h  |   42 +++++---
>>  fs/cifs/connect.c   |    2 +-
>>  fs/cifs/file.c      |   35 ++++---
>>  fs/cifs/inode.c     |    8 +-
>>  fs/cifs/misc.c      |   12 +--
>>  fs/cifs/smb1ops.c   |   12 ++-
>>  fs/cifs/smb2file.c  |   23 -----
>>  fs/cifs/smb2misc.c  |  182 +++++++++++++++++----------------
>>  fs/cifs/smb2ops.c   |  283 +++++++++++++++++++++++++++++++++++++++++++++++++--
>>  fs/cifs/smb2pdu.c   |   80 ++++-----------
>>  fs/cifs/smb2pdu.h   |   23 +++++
>>  fs/cifs/smb2proto.h |    2 -
>>  13 files changed, 497 insertions(+), 241 deletions(-)
>>
>> --
>> 1.7.10.4
>>
>
> Made some changes in patch #1 and #2 descriptions that can be found in
> for-next branch of my git repository:
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-next.
>
> --
> Best regards,
> Pavel Shilovsky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
