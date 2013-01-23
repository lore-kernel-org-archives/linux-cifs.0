From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
Date: Tue, 22 Jan 2013 23:59:23 -0600
Message-ID: <CAH2r5mtSTOWc7Caf3UA=SGY3_PoR-xFOyXHd4OiYZSGXa5W_YQ@mail.gmail.com>
References: <1358900459-26277-1-git-send-email-dinggnu@gmail.com>
	<20130122203603.1bd26363@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Cong Ding <dinggnu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130122203603.1bd26363-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Tue, Jan 22, 2013 at 7:36 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 22 Jan 2013 19:20:58 -0500
> Cong Ding <dinggnu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> When it goes to error through line 144, the memory allocated to *devname is
>> not freed, and the caller doesn't free it either in line 250. So we free the
>> memroy of *devname in function cifs_compose_mount_options() when it goes to
>> error.
>>
>> Signed-off-by: Cong Ding <dinggnu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  fs/cifs/cifs_dfs_ref.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
>> index ce5cbd7..210fce2 100644
>> --- a/fs/cifs/cifs_dfs_ref.c
>> +++ b/fs/cifs/cifs_dfs_ref.c
>> @@ -226,6 +226,8 @@ compose_mount_options_out:
>>  compose_mount_options_err:
>>       kfree(mountdata);
>>       mountdata = ERR_PTR(rc);
>> +     kfree(*devname);
>> +     *devname = NULL;
>>       goto compose_mount_options_out;
>>  }
>>
>
> Nice catch. Looks correct to me. Should this also go to stable?
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



-- 
Thanks,

Steve
