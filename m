Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E223FBA5;
	Sun, 26 Jan 2025 07:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737877003; cv=none; b=Lc0TXfXGGyY3L/YZUvL8Rbj6zS9cSk1ipC9vd3tTN9E6jzMim8608WzeVtPeMDZTZFNz50CiNqFHAnnNyIDBrVF4CEfQWzcj5FDOgx+eo6kY4X0IrlB1/2/DYU5MAhSUKmwPm0kJ1mKu1lM9BD6hQOo3mJpuRgo0yEyZub59vvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737877003; c=relaxed/simple;
	bh=lpwzF+Xxfvl4WJjlYfjHNY0lCSTviDH0HXGBeLEgELU=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=FLlLbj5NhnAEzgxXYhqjGYjbxL9W55YFXojU4epybmUqV1UUM1JvoDATeUvf/JBFzx7Q5UlZnEJHXyJfuV9OvMGtC081TN0BXsjUB8F2cumPetIbbhJfbbnqmd1tJCZMbKWzu6JUKweqOdKRvtaSoT9FWNE1ic9n3VzQiaCbumc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4YgjwT1ddrzRlyn;
	Sun, 26 Jan 2025 15:34:01 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id C0C26180216;
	Sun, 26 Jan 2025 15:36:35 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 26 Jan 2025 15:36:35 +0800
Message-ID: <3bd10acc-2d7f-019a-3182-82ab647bc15a@huawei.com>
Date: Sun, 26 Jan 2025 15:36:26 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To: <stable@vger.kernel.org>, <sfrench@samba.org>
CC: <linux-cifs@vger.kernel.org>, yangerkun <yangerkun@huawei.com>, yi zhang
	<yi.zhang@huawei.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
Subject: [BUG REPORT] cifs: Deadlock due to network reconnection during file
 writing
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500010.china.huawei.com (7.202.181.71)

In the code of the LTS branch that is being maintained (from linux-5.4 to
linux-6.6), a deadlock occurs in the network reconnection scenario When
multiple processes or threads write to the same file concurrently.

Take the code of linux-5.10 as an example. The simplified deadlock process
is as follows:

```
Process 1                           Process 2
lock_page() - [1]
   wait_on_page_writeback() - [2] Waiting for writeback, blocked by [4]

                                     lock_page()     - [3] Blocked by [1]
                                       end_page_writeback() - [4] Won't execute
```

Based on my research, I'm going to use two detailed scenarios to illustrate
the issue.

Scenarios 1:

```
P1 (dd)                 P2 (cifsd)          P3 (cifsiod)

cifs_writepages
   wdata_prepare_pages
     lock_page - [1]
      wait_on_page_writeback - [2] Waiting for writeback, blocked by [4]
       wait_on_page_bit
                       cifs_demultiplex_thread
                       cifs_read_from_socket
                       cifs_readv_from_socket
                       - If another process triggers reconnect at this point
                         cifs_reconnect
                         - mid->mid_state updated to MID_RETRY_NEEDED
                         smb2_writev_callback mid_entry->callback()
                          - mid_state leads to wdata->result = -EAGAIN
                          wdata->result = -EAGAIN
                          queue_work(cifsiod_wq, &wdata->work);
                                          cifs_writev_complete - worker function
                                            - wdata->result == -EAGAIN Condition satisfied
                                            cifs_writev_requeue
                                              lock_page - [3] Blocked by [1]
                                            end_page_writeback
                                            - [4] Won't execute
     unlock_page
```

Mainline refactoring commit d08089f649a0 ("cifs: Change the I/O paths to use
an iterator rather than a page list") unlock folio while waiting for the
writeback to complete. This patch is introduced in v6.3-rc1. Therefore, scenario 1
only affects LTS versions from linux-5.4 to linux-6.1.

Call stack trace:

```
     cat /proc/34/stack
     [<0>] __lock_page+0x147/0x3a0
     [<0>] cifs_writev_requeue.cold+0x185/0x28e
     [<0>] process_one_work+0x1df/0x3b0
     [<0>] worker_thread+0x4a/0x3c0
     [<0>] kthread+0x125/0x160
     [<0>] ret_from_fork+0x22/0x30

     # cat /proc/465/stack
     [<0>] wait_on_page_bit+0x106/0x2e0
     [<0>] wait_on_page_writeback+0x25/0xd0
     [<0>] cifs_writepages+0x5ee/0xf60
     [<0>] do_writepages+0x43/0xe0
     [<0>] __filemap_fdatawrite_range+0xcd/0x110
     [<0>] file_write_and_wait_range+0x40/0x90
     [<0>] cifs_strict_fsync+0x35/0x470
     [<0>] do_fsync+0x38/0x70
     [<0>] __x64_sys_fsync+0x10/0x20
     [<0>] do_syscall_64+0x33/0x40
     [<0>] entry_SYSCALL_64_after_hwframe+0x67/0xd1

     [  369.826215] INFO: task kworker/1:1:34 blocked for more than 122 seconds.
     [  369.828964]       Not tainted 5.10.0+ #164
     [  369.830623] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
     [  369.835104] task:kworker/1:1     state:D stack:13472 pid:   34 ppid:     2 flags:0x00004000
     [  369.838448] Workqueue: cifsiod cifs_writev_complete
     [  369.840242] Call Trace:
     [  369.841219]  __schedule+0x401/0x8e0
     [  369.842568]  schedule+0x49/0x130
     [  369.843785]  io_schedule+0x12/0x40
     [  369.845079]  __lock_page+0x147/0x3a0
     [  369.846444]  ? add_to_page_cache_lru+0x180/0x180
     [  369.847963]  cifs_writev_requeue.cold+0x185/0x28e
     [  369.849193]  process_one_work+0x1df/0x3b0
     [  369.850248]  worker_thread+0x4a/0x3c0
     [  369.851216]  ? process_one_work+0x3b0/0x3b0
     [  369.852308]  kthread+0x125/0x160
     [  369.853167]  ? kthread_park+0x90/0x90
     [  369.854142]  ret_from_fork+0x22/0x30
     [  369.855054] INFO: task kworker/u8:3:96 blocked for more than 122 seconds.
     [  369.856781]       Not tainted 5.10.0+ #164
     [  369.857851] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
     [  369.859419] task:kworker/u8:3    state:D stack:12744 pid:   96 ppid:     2 flags:0x00004000
     [  369.861041] Workqueue: writeback wb_workfn (flush-cifs-2)
     [  369.862095] Call Trace:
     [  369.862583]  __schedule+0x401/0x8e0
     [  369.863280]  schedule+0x49/0x130
     [  369.863912]  io_schedule+0x12/0x40
     [  369.864604]  __lock_page+0x147/0x3a0
     [  369.865322]  ? add_to_page_cache_lru+0x180/0x180
     [  369.866246]  cifs_writepages+0x620/0xf60
     [  369.867005]  do_writepages+0x43/0xe0
     [  369.867737]  ? __blk_mq_try_issue_directly+0x121/0x1c0
     [  369.868750]  __writeback_single_inode+0x3d/0x320
     [  369.869589]  writeback_sb_inodes+0x20d/0x480
     [  369.870367]  __writeback_inodes_wb+0x4c/0xe0
     [  369.871148]  wb_writeback+0x201/0x2f0
     [  369.871797]  wb_workfn+0x38a/0x4e0
     [  369.872427]  ? check_preempt_curr+0x47/0x70
     [  369.873191]  ? ttwu_do_wakeup.isra.0+0x17/0x170
     [  369.873999]  process_one_work+0x1df/0x3b0
     [  369.874741]  worker_thread+0x4a/0x3c0
     [  369.875421]  ? process_one_work+0x3b0/0x3b0
     [  369.876180]  kthread+0x125/0x160
     [  369.876761]  ? kthread_park+0x90/0x90
     [  369.877431]  ret_from_fork+0x22/0x30
     [  369.878106] INFO: task a.out:465 blocked for more than 122 seconds.
     [  369.879225]       Not tainted 5.10.0+ #164
     [  369.879945] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
     [  369.881316] task:a.out           state:D stack:12752 pid:  465 ppid:   386 flags:0x00000002
     [  369.882791] Call Trace:
     [  369.883263]  __schedule+0x401/0x8e0
     [  369.883884]  schedule+0x49/0x130
     [  369.884447]  io_schedule+0x12/0x40
     [  369.885054]  wait_on_page_bit+0x106/0x2e0
     [  369.885795]  ? add_to_page_cache_lru+0x180/0x180
     [  369.886631]  wait_on_page_writeback+0x25/0xd0
     [  369.887427]  cifs_writepages+0x5ee/0xf60
     [  369.888151]  do_writepages+0x43/0xe0
     [  369.888789]  ? __generic_file_write_iter+0xfd/0x1d0
     [  369.889663]  __filemap_fdatawrite_range+0xcd/0x110
     [  369.890523]  file_write_and_wait_range+0x40/0x90
     [  369.891360]  cifs_strict_fsync+0x35/0x470
     [  369.892094]  do_fsync+0x38/0x70
     [  369.892657]  __x64_sys_fsync+0x10/0x20
     [  369.893336]  do_syscall_64+0x33/0x40
     [  369.893978]  entry_SYSCALL_64_after_hwframe+0x67/0xd1
     [  369.894883] RIP: 0033:0x7f660e208950
     [  369.895538] RSP: 002b:00007fff52b27b78 EFLAGS: 00000202 ORIG_RAX: 000000000000004a
     [  369.896882] RAX: ffffffffffffffda RBX: 00007fff52b28cb8 RCX: 00007f660e208950
     [  369.898139] RDX: 0000000000001000 RSI: 00007fff52b27b80 RDI: 0000000000000003
     [  369.899395] RBP: 00007fff52b28ba0 R08: 0000000000000410 R09: 0000000000000001
     [  369.900661] R10: 00007f660e11c400 R11: 0000000000000202 R12: 0000000000000000
     [  369.901925] R13: 00007fff52b28cc8 R14: 00007f660e328000 R15: 000055b5aeb6fdd8
     [  369.903202] INFO: task sync:468 blocked for more than 122 seconds.
     [  369.904311]       Not tainted 5.10.0+ #164
     [  369.905034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
     [  369.906457] task:sync            state:D stack:13632 pid:  468 ppid:   386 flags:0x00004002
     [  369.907930] Call Trace:
     [  369.908369]  __schedule+0x401/0x8e0
     [  369.908984]  schedule+0x49/0x130
     [  369.909582]  io_schedule+0x12/0x40
     [  369.910208]  wait_on_page_bit+0x106/0x2e0
     [  369.910918]  ? add_to_page_cache_lru+0x180/0x180
     [  369.911758]  wait_on_page_writeback+0x25/0xd0
     [  369.912560]  __filemap_fdatawait_range+0x83/0x110
     [  369.913408]  ? __add_pages+0x6f/0x1b0
     [  369.914089]  filemap_fdatawait_keep_errors+0x1a/0x50
     [  369.914957]  sync_inodes_sb+0x208/0x2a0
     [  369.915666]  ? __x64_sys_tee+0xd0/0xd0
     [  369.916344]  iterate_supers+0x90/0xe0
     [  369.916983]  ksys_sync+0x40/0xb0
     [  369.917590]  __do_sys_sync+0xa/0x20
     [  369.918240]  do_syscall_64+0x33/0x40
     [  369.918884]  entry_SYSCALL_64_after_hwframe+0x67/0xd1
     [  369.919800] RIP: 0033:0x7f746d820987
     [  369.920451] RSP: 002b:00007ffce853fd78 EFLAGS: 00000206 ORIG_RAX: 00000000000000a2
     [  369.921798] RAX: ffffffffffffffda RBX: 00007ffce853fed8 RCX: 00007f746d820987
     [  369.923063] RDX: 00007f746d8f4801 RSI: 00007ffce8541f71 RDI: 00007f746d8b05ad
     [  369.924339] RBP: 0000000000000001 R08: 000000000000ffff R09: 0000000000000000
     [  369.925605] R10: 00007f746d7308a0 R11: 0000000000000206 R12: 000055b8487470fb
     [  369.926866] R13: 0000000000000000 R14: 0000000000000000 R15: 000055b848749ce0
     [  369.928138] Kernel panic - not syncing: hung_task: blocked tasks
     [  369.929191] CPU: 3 PID: 35 Comm: khungtaskd Not tainted 5.10.0+ #164
     [  369.952450] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
     [  369.956984] Call Trace:
     [  369.957973]  dump_stack+0x57/0x6e
     [  369.959273]  panic+0x115/0x2f1
     [  369.960476]  watchdog.cold+0xb5/0xb5
     [  369.961884]  ? hungtask_pm_notify+0x40/0x40
     [  369.963310]  kthread+0x125/0x160
     [  369.964354]  ? kthread_park+0x90/0x90
     [  369.965551]  ret_from_fork+0x22/0x30
     [  369.967673] Kernel Offset: 0xd600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
     [  369.971025] ---[ end Kernel panic - not syncing: hung_task: blocked tasks ]---
```

Scenarios 2:

   Scenario 2 occurs in strict cache mode

```
P1 (dd)                 P2 (cifsd)          P3 (cifsiod)

cifs_strict_writev
  cifs_zap_mapping - If something breaks the oplock
   cifs_revalidate_mapping
    cifs_invalidate_mapping
     invalidate_inode_pages2
      invalidate_inode_pages2_range
       lock_page - [1]
       wait_on_page_writeback - [2] Waiting for writeback, blocked by [4]
        wait_on_page_bit
                       cifs_demultiplex_thread
                       cifs_read_from_socket
                       cifs_readv_from_socket
                       - If another process triggers reconnect at this point
                         cifs_reconnect
                         - mid->mid_state updated to MID_RETRY_NEEDED
                         smb2_writev_callback mid_entry->callback()
                          - mid_state leads to wdata->result = -EAGAIN
                          wdata->result = -EAGAIN
                          queue_work(cifsiod_wq, &wdata->work);
                                          cifs_writev_complete - worker function
                                            - wdata->result == -EAGAIN Condition satisfied
                                            cifs_writev_requeue
                                              lock_page - [3] Blocked by [1]
                                            end_page_writeback
                                            - [4] Won't execute
       unlock_page
```

Mainline refactoring commit 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
directly terminates the file write instead of resending data when smb2_writev_callback()
detects a write failure, thus avoiding this problem. This patch is introduced
in v6.10-rc1. Therefore, scenario 2 affects LTS versions from linux-5.4
to linux-6.6.

```
cat /proc/522/stack
[<0>] wait_on_page_bit+0x106/0x150
[<0>] invalidate_inode_pages2_range+0x2cc/0x580
[<0>] cifs_invalidate_mapping+0x2c/0x50 [cifs]
[<0>] cifs_revalidate_mapping+0x4c/0x90 [cifs]
[<0>] cifs_strict_writev+0x17a/0x250 [cifs]
[<0>] __vfs_write+0x14f/0x1b0
[<0>] vfs_write+0xb6/0x1a0
[<0>] ksys_write+0x57/0xd0
[<0>] do_syscall_64+0x63/0x250
[<0>] entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[<0>] 0xffffffffffffffff

cat /proc/33/stack
[<0>] __lock_page+0x10c/0x160
[<0>] cifs_writev_requeue.cold+0x17e/0x239 [cifs]
[<0>] process_one_work+0x1a9/0x3f0
[<0>] worker_thread+0x50/0x3c0
[<0>] kthread+0x117/0x130
[<0>] ret_from_fork+0x35/0x40
[<0>] 0xffffffffffffffff
```


The root cause of the deadlock problem is that the page/folio is locked again in
cifs_writev_requeue(). In order to safely fix it on the LTS branches, I would
like to clarify the following questions:,

1. Whether resending is necessary. If retransmission is not required, simply
terminating the write would avoids this problem. Is this an acceptable solution?

2. Is it necessary to lock the page/folio in cifs_writev_requeue()? Based on
my code screening (possibly missing), there seems to be no process that modifies
a page when it is marked as PG_writeback.Therefore, the page does not need to be
locked during wait_on_page_writeback().
