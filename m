Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C5F46C850
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 12:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786624716; cv=none; b=Gj0Y4JHk12ocTrLPYc39hhNE/HRMIevqZ3BjXufR3n8PtpCRoBSfS+2psFYO/G3SvNESVEsCR4punUotYlglHaGHeDGv7PTlaaM8hLNTpuzIU/hzjSK4sOhFpXwa4a+o37fst3eADpVmp6zAPOSbLMWoiveXlYQPXDRpoK5YY2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786624716; c=relaxed/simple;
	bh=SQ7OC/1UWxmATgnpO0kHgENGGzR7V71BWmM7CkFly7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fh00JEUFO3ksauis0dVuJjyJpFk7Xg2GbL+ZJ6ZAYeiJdgND99jj9bxTsce6yentYLYSwIsy1vPnS0yiBeLHkzHAMDYDyu20LWO9mWHsl1MZ3bwTO49w7/+WXzZzUnJ/oPB97iYFT3wja+/jWiBX7UiEa8W0ds9Li4F/Zdk8ieE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mHaQhCLd; arc=none smtp.client-ip=91.218.175.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mHaQhCLd"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SQ7OC/1UWxmATgnpO0kHgENGGzR7V71BWmM7CkFly7I=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786624709; v=1; x=1787229509;
 b=mHaQhCLduI/K6i2Acc33o0Ej7oBNkVLteuiZe66nhde2JSBetIdqgH1IP1TA8/jwBNiZ8Icl
 eEcYh0Nf08HBkdaOQImT5KG7txv/VUZ1N/zc0nybFWVWmMZhyCbO0mQOMfm8r7Rlba5cmL720qa
 0cnnnJmrxAFe7CEWckl6Mvae5BD4n66fQ+qImCV2MDJmjUiDGCRRRa2yg9kYPbwyB7KIDXg2P0U
 oCW0+I69NbZjpy/zGqvH15rcGrF+D5E0omjrcdDmluu3AQ506Y9bxdE5o6qNDvTQ6ZZMraXStn8
 sSQDhyB/pM80HyDY8UyhRigbbGik37pwBykHr9OZuGRhw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.0.104] (220.202.230.161)
	by smtp.migadu.com with ESMTPS id af9236c7547d8ca4;
	Thu, 13 Aug 2026 12:38:19 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <fc4bcb05-866d-471e-b07f-61575d46bb13@chenxiaosong.com>
Date: Thu, 13 Aug 2026 20:38:10 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb/server: fix use-after-free in
 ksmbd_conn_transport_destroy()
To: smfrench@gmail.com, linkinjeon@kernel.org, tom@talpey.com,
 senozhatsky@chromium.org, obnred@gmail.com,
 Bahubali B Gumaji <bahubali.bg@samsung.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring 
and statistics")

在 2026/8/13 18:40, ChenXiaoSong 写道:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Reproducer (Link[1]):
> 
>    1. Build kernel with CONFIG_KASAN=y
>    2. server: systemctl start ksmbd
>    3. client: mount -t cifs //localhost/export /mnt
>    4. client: umount /mnt
>    5. server: modprobe -r ksmbd
> 
> The error message is as follows:
> 
>    ==================================================================
>    BUG: KASAN: slab-use-after-free in proc_remove+0x3e/0x80
>    Read of size 8 at addr ffff88810654e098 by task modprobe/785
>    ...
>    Call Trace:
>     <TASK>
>     __dump_stack+0x19/0x30
>     dump_stack_lvl+0x49/0x60
>     print_address_description+0x7b/0x200
>     print_report+0x5b/0x70
>     kasan_report+0xed/0x130
>     __asan_report_load8_noabort+0x18/0x20
>     proc_remove+0x3e/0x80
>     ksmbd_conn_transport_destroy+0x2b/0x320 [ksmbd]
>     cleanup_module+0x33/0xe00 [ksmbd]
>     __se_sys_delete_module+0x276/0x400
>     __x64_sys_delete_module+0x5f/0x70
>     x64_sys_call+0x2675/0x3030
>     do_syscall_64+0xf0/0x3b0
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    RIP: 0033:0x7f5b56d2b02b
>    ...
>     </TASK>
> 
>    Allocated by task 159:
>     kasan_save_track+0x2f/0x70
>     kasan_save_alloc_info+0x40/0x50
>     __kasan_slab_alloc+0x52/0x70
>     kmem_cache_alloc_noprof+0x168/0x3e0
>     __proc_create+0x20b/0x710
>     proc_create_single_data+0x78/0x150
>     ksmbd_proc_create+0x24/0x30 [ksmbd]
>     ksmbd_conn_transport_init+0x4f/0x80 [ksmbd]
>     server_ctrl_handle_work+0x64/0x2c0 [ksmbd]
>     process_scheduled_works+0x788/0xec0
>     worker_thread+0x894/0xc10
>     kthread+0x2e5/0x3c0
>     ret_from_fork+0x168/0x4f0
>     ret_from_fork_asm+0x1a/0x30
> 
>    Freed by task 785:
>     kasan_save_track+0x2f/0x70
>     kasan_save_free_info+0x4a/0x60
>     __kasan_slab_free+0x47/0x70
>     kmem_cache_free+0x122/0x410
>     pde_put+0xfd/0x160
>     remove_proc_subtree+0x365/0x540
>     proc_remove+0x6a/0x80
>     ksmbd_proc_cleanup+0x1f/0x60 [ksmbd]
>     cleanup_module+0x18/0xe00 [ksmbd]
>     __se_sys_delete_module+0x276/0x400
>     __x64_sys_delete_module+0x5f/0x70
>     x64_sys_call+0x2675/0x3030
>     do_syscall_64+0xf0/0x3b0
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    ==================================================================
> 
> Reported-by: Kyenghwan Hwang <obnred@gmail.com>
> Link[1]: https://lore.kernel.org/linux-cifs/8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com/
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/server/server.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
> index 0ccd123ba418..d619d1f22601 100644
> --- a/fs/smb/server/server.c
> +++ b/fs/smb/server/server.c
> @@ -596,11 +596,16 @@ static int ksmbd_server_shutdown(void)
>   {
>   	WRITE_ONCE(server_conf.state, SERVER_STATE_SHUTTING_DOWN);
>   
> -	ksmbd_proc_cleanup();
>   	class_unregister(&ksmbd_control_class);
>   	ksmbd_workqueue_destroy();
>   	ksmbd_ipc_release();
>   	ksmbd_conn_transport_destroy();
> +	/*
> +	 * ksmbd_conn_transport_destroy() calls delete_proc_clients() and destroys
> +	 * sessions. ksmbd_session_destroy() removes each session's proc entry.
> +	 * Keep the procfs tree alive until these entries have been removed.
> +	 */
> +	ksmbd_proc_cleanup();
>   	ksmbd_crypto_destroy();
>   	ksmbd_free_global_file_table();
>   	destroy_lease_table(NULL);

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

