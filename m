From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2.6.36-rc7] cifs: cancel_delayed_work() + flush_scheduled_work()
 -> cancel_delayed_work_sync()
Date: Tue, 19 Oct 2010 18:15:21 +0200
Message-ID: <4CBDC419.8060909@kernel.org>
References: <4CBDBF8A.8010106@kernel.org> <20101019121319.16f06b76@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101019121319.16f06b76-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

On 10/19/2010 06:13 PM, Jeff Layton wrote:
> On Tue, 19 Oct 2010 17:55:54 +0200
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
>> flush_scheduled_work() is going away.
>>
>> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>  fs/cifs/cifs_dfs_ref.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> Index: work/fs/cifs/cifs_dfs_ref.c
>> ===================================================================
>> --- work.orig/fs/cifs/cifs_dfs_ref.c
>> +++ work/fs/cifs/cifs_dfs_ref.c
>> @@ -44,8 +44,7 @@ static void cifs_dfs_expire_automounts(s
>>  void cifs_dfs_release_automount_timer(void)
>>  {
>>  	BUG_ON(!list_empty(&cifs_dfs_automount_list));
>> -	cancel_delayed_work(&cifs_dfs_automount_task);
>> -	flush_scheduled_work();
>> +	cancel_delayed_work_sync(&cifs_dfs_automount_task);
>>  }
>>
>>  /**
> 
> Looks like a better way to do this anyhow.
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Yeah, way faster too.  It would be best to route this patch through
cifs tree but I can push it through wq tree too.  Just let me know.

Thanks.

-- 
tejun
