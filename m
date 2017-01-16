From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: initialize file_info_lock
Date: Mon, 16 Jan 2017 12:44:23 -0600
Message-ID: <CAH2r5mtNZMAV_5Vzx_z78VgUayTcbne3=30CqrNfHEP3ssQgxg@mail.gmail.com>
References: <1484316016-15901-1-git-send-email-rabin.vincent@axis.com> <1484569535.2719.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484569535.2719.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

thx - merged into cifs-2.6.git for-next

On Mon, Jan 16, 2017 at 6:25 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2017-01-13 at 15:00 +0100, Rabin Vincent wrote:
>> From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
>>
>> file_info_lock is not initalized in initiate_cifs_search(), leading to the
>> following splat after a simple "mount.cifs ... dir && ls dir/":
>>
>>  BUG: spinlock bad magic on CPU#0, ls/486
>>   lock: 0xffff880009301110, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>>  CPU: 0 PID: 486 Comm: ls Not tainted 4.9.0 #27
>>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>>   ffffc900042f3db0 ffffffff81327533 0000000000000000 ffff880009301110
>>   ffffc900042f3dd0 ffffffff810baf75 ffff880009301110 ffffffff817ae077
>>   ffffc900042f3df0 ffffffff810baff6 ffff880009301110 ffff880008d69900
>>  Call Trace:
>>   [<ffffffff81327533>] dump_stack+0x65/0x92
>>   [<ffffffff810baf75>] spin_dump+0x85/0xe0
>>   [<ffffffff810baff6>] spin_bug+0x26/0x30
>>   [<ffffffff810bb159>] do_raw_spin_lock+0xe9/0x130
>>   [<ffffffff8159ad2f>] _raw_spin_lock+0x1f/0x30
>>   [<ffffffff8127e50d>] cifs_closedir+0x4d/0x100
>>   [<ffffffff81181cfd>] __fput+0x5d/0x160
>>   [<ffffffff81181e3e>] ____fput+0xe/0x10
>>   [<ffffffff8109410e>] task_work_run+0x7e/0xa0
>>   [<ffffffff81002512>] exit_to_usermode_loop+0x92/0xa0
>>   [<ffffffff810026f9>] syscall_return_slowpath+0x49/0x50
>>   [<ffffffff8159b484>] entry_SYSCALL_64_fastpath+0xa7/0xa9
>>
>> Fixes: 3afca265b5f53a0 ("Clarify locking of cifs file and tcon structures and make more granular")
>> Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
>> ---
>>  fs/cifs/readdir.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
>> index 8f6a2a5..a27fc87 100644
>> --- a/fs/cifs/readdir.c
>> +++ b/fs/cifs/readdir.c
>> @@ -285,6 +285,7 @@ initiate_cifs_search(const unsigned int xid, struct file *file)
>>                       rc = -ENOMEM;
>>                       goto error_exit;
>>               }
>> +             spin_lock_init(&cifsFile->file_info_lock);
>>               file->private_data = cifsFile;
>>               cifsFile->tlink = cifs_get_tlink(tlink);
>>               tcon = tlink_tcon(tlink);
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
