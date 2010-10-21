From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: convert cifs_tcp_ses_lock from a rwlock to
 a spinlock
Date: Thu, 21 Oct 2010 10:53:56 +0530
Message-ID: <4CBFCE6C.8070506@suse.de>
References: <4CBC8B09.2050702@suse.de> <20101018142914.0c1e11ee@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101018142914.0c1e11ee-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

On 10/18/2010 11:59 PM, Jeff Layton wrote:
> On Mon, 18 Oct 2010 23:29:37 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> cifs_tcp_ses_lock is a rwlock with protects the cifs_tcp_ses_list,
>> server->smb_ses_list and the ses->tcon_list. It also protects a few
>> ref counters in server, ses and tcon. In most cases the critical section
>> doesn't seem to be large, in a few cases where it is slightly large, there
>> seem to be really no benefit from concurrent access. I briefly considered RCU
>> mechanism but it appears to me that there is no real need.
>>
>> Replace it with a spinlock and get rid of the last rwlock in the cifs code.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>>  fs/cifs/cifs_debug.c |   12 ++++----
>>  fs/cifs/cifsfs.c     |    8 +++---
>>  fs/cifs/cifsglob.h   |    2 +-
>>  fs/cifs/cifssmb.c    |    6 ++--
>>  fs/cifs/connect.c    |   70 +++++++++++++++++++++++++-------------------------
>>  fs/cifs/misc.c       |   14 +++++-----
>>  fs/cifs/sess.c       |    4 +-
>>  7 files changed, 58 insertions(+), 58 deletions(-)
>>

> 
> Looks reasonable. These codepaths aren't terribly "hot", so this lock
> is fairly low-contention anyway.
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Can this and the subsequent comment fix patch can be queued for 2.6.37
(merge window seems open) if you don't see any issues?


Thanks,

-- 
Suresh Jayaraman
