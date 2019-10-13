Return-Path: <SRS0=VLZr=YG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A871C4360C
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Oct 2019 16:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1084D20659
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Oct 2019 16:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfJMQFM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Oct 2019 12:05:12 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:53385 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726085AbfJMQFM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 13 Oct 2019 12:05:12 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Oct 2019 12:05:11 EDT
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 6007532EC6_DA348E8B
        for <linux-cifs@vger.kernel.org>; Sun, 13 Oct 2019 15:55:20 +0000 (GMT)
Received: from mail.prodrive-technologies.com (exc04.bk.prodrive.nl [10.1.1.213])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "Prodrive Technologies B.V. OV SSL Issuing CA" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id 6C5303039F_DA348E7F
        for <linux-cifs@vger.kernel.org>; Sun, 13 Oct 2019 15:55:19 +0000 (GMT)
Received: from [10.10.240.28] (10.1.249.1) by EXC04.bk.prodrive.nl
 (10.1.1.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1779.2; Sun, 13
 Oct 2019 17:55:18 +0200
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Subject: Kernel hangs in cifs_reconnect
To:     <linux-cifs@vger.kernel.org>
Organization: Prodrive Technologies
Message-ID: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com>
Date:   Sun, 13 Oct 2019 17:55:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EXC03.bk.prodrive.nl (10.1.1.212) To EXC04.bk.prodrive.nl
 (10.1.1.213)
X-SASI-RCODE: 200
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Our Linux VMs reports call traces about processes being stuck.
I've attached the full dmesg of one of the call traces below.

The machine is running kernel 5.3.1 SMP. All mounts are mounted via the
dfs shares on our domain controller and have the following options in fstab:
nohandlecache,multiuser,sec=krb5,noperm,user=xxxx,file_mode=0600,dir_mode=0700,vers=3.0

According the mount, this unfolds into:
rw,relatime,vers=3.0,sec=krb5,cruid=0,cache=strict,multiuser,uid=0,noforceuid,gid=0,
noforcegid,addr=10.1.1.2,file_mode=0600,dir_mode=0700,soft,nounix,mapposix,
nohandlecache,noperm,rsize=4194304,wsize=4194304,bsize=1048576,
echo_interval=60,actimeo=1,user=xxxx

After this call trace dump, the log keeps filling with:
CIFS VFS: wait timed out after 60000 ms

Hereby the dmesg output:

[72735.369353] INFO: task node_exporter:3853 blocked for more than 120 seconds.
[72735.370371]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72735.370824] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72735.371230] node_exporter   D    0  3853      1 0x00000000
[72735.371246] Call Trace:
[72735.371262]  ? __schedule+0x3e9/0x670
[72735.371265]  ? __switch_to_asm+0x34/0x70
[72735.371267]  schedule+0x39/0xa0
[72735.371268]  schedule_preempt_disabled+0xa/0x10
[72735.371270]  __mutex_lock.isra.7+0x2a1/0x4d0
[72735.371271]  ? __switch_to_asm+0x34/0x70
[72735.371277]  ? __switch_to+0x101/0x3e0
[72735.371453]  ? smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[72735.371467]  smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[72735.371495]  ? wait_for_response.isra.11+0x5b/0xf0 [cifs]
[72735.371509]  smb2_plain_req_init+0x1d9/0x260 [cifs]
[72735.371523]  SMB2_open_init+0x6d/0x870 [cifs]
[72735.371541]  ? smb2_query_info_compound+0x173/0x370 [cifs]
[72735.371553]  ? cifs_small_buf_release+0x16/0x60 [cifs]
[72735.371567]  smb2_query_info_compound+0x173/0x370 [cifs]
[72735.371575]  ? __switch_to_asm+0x40/0x70
[72735.371578]  ? lookup_fast+0xc8/0x2c0
[72735.371580]  ? lookup_fast+0xc8/0x2c0
[72735.371594]  ? smb2_queryfs+0x70/0xf0 [cifs]
[72735.371607]  smb2_queryfs+0x70/0xf0 [cifs]
[72735.371618]  cifs_statfs+0xa9/0x2a0 [cifs]
[72735.371633]  statfs_by_dentry+0x6a/0x90
[72735.371638]  vfs_statfs+0x16/0xc0
[72735.371639]  user_statfs+0x50/0xa0
[72735.371640]  __do_sys_statfs+0x20/0x50
[72735.371643]  do_syscall_64+0x55/0x110
[72735.371648]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[72735.371657] RIP: 0033:0x4a5c20
[72735.371662] Code: Bad RIP value.
[72735.371663] RSP: 002b:000000c0004c5490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[72735.371664] RAX: ffffffffffffffda RBX: 000000c00002c500 RCX: 00000000004a5c20
[72735.371665] RDX: 0000000000000000 RSI: 000000c0004c55c0 RDI: 000000c00036e180
[72735.371665] RBP: 000000c0004c54f0 R08: 0000000000000000 R09: 0000000000000000
[72735.371666] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[72735.371667] R13: 000000000000000d R14: 000000000000000c R15: 0000000000000100
[72735.371676] INFO: task cifsd:997 blocked for more than 120 seconds.
[72735.372090]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72735.372571] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72735.373032] cifsd           D    0   997      2 0x80004000
[72735.373034] Call Trace:
[72735.373039]  ? __schedule+0x3e9/0x670
[72735.373042]  schedule+0x39/0xa0
[72735.373044]  schedule_preempt_disabled+0xa/0x10
[72735.373045]  __mutex_lock.isra.7+0x2a1/0x4d0
[72735.373049]  ? account_entity_enqueue+0x9c/0xc0
[72735.373075]  ? dfs_cache_noreq_find+0x90/0x170 [cifs]
[72735.373089]  dfs_cache_noreq_find+0x90/0x170 [cifs]
[72735.373112]  cifs_reconnect+0xc5/0xd20 [cifs]
[72735.373132]  cifs_handle_standard+0x166/0x190 [cifs]
[72735.373145]  cifs_demultiplex_thread+0xaca/0xc20 [cifs]
[72735.373146]  ? __switch_to+0x7a/0x3e0
[72735.373158]  ? cifs_handle_standard+0x190/0x190 [cifs]
[72735.373160]  kthread+0xf8/0x130
[72735.373166]  ? kthread_create_worker_on_cpu+0x70/0x70
[72735.373168]  ret_from_fork+0x35/0x40
[72856.190414] INFO: task node_exporter:3853 blocked for more than 241 seconds.
[72856.190830]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72856.191171] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72856.191516] node_exporter   D    0  3853      1 0x00000000
[72856.191518] Call Trace:
[72856.191533]  ? __schedule+0x3e9/0x670
[72856.191535]  ? __switch_to_asm+0x34/0x70
[72856.191536]  schedule+0x39/0xa0
[72856.191537]  schedule_preempt_disabled+0xa/0x10
[72856.191539]  __mutex_lock.isra.7+0x2a1/0x4d0
[72856.191540]  ? __switch_to_asm+0x34/0x70
[72856.191542]  ? __switch_to+0x101/0x3e0
[72856.191571]  ? smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[72856.191583]  smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[72856.191595]  ? wait_for_response.isra.11+0x5b/0xf0 [cifs]
[72856.191607]  smb2_plain_req_init+0x1d9/0x260 [cifs]
[72856.191618]  SMB2_open_init+0x6d/0x870 [cifs]
[72856.191631]  ? smb2_query_info_compound+0x173/0x370 [cifs]
[72856.191641]  ? cifs_small_buf_release+0x16/0x60 [cifs]
[72856.191651]  smb2_query_info_compound+0x173/0x370 [cifs]
[72856.191653]  ? __switch_to_asm+0x40/0x70
[72856.191655]  ? lookup_fast+0xc8/0x2c0
[72856.191657]  ? lookup_fast+0xc8/0x2c0
[72856.191669]  ? smb2_queryfs+0x70/0xf0 [cifs]
[72856.191680]  smb2_queryfs+0x70/0xf0 [cifs]
[72856.191688]  cifs_statfs+0xa9/0x2a0 [cifs]
[72856.191690]  statfs_by_dentry+0x6a/0x90
[72856.191691]  vfs_statfs+0x16/0xc0
[72856.191692]  user_statfs+0x50/0xa0
[72856.191693]  __do_sys_statfs+0x20/0x50
[72856.191695]  do_syscall_64+0x55/0x110
[72856.191697]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[72856.191698] RIP: 0033:0x4a5c20
[72856.191701] Code: ff ff ff 48 3b 61 10 0f 86 ba 00 00 00 48 83 ec 40 48 89 6c 24 38 48 8d 6c 24 38 48 8b 44 24 48 48 85 c0 0f 8c 99 00 00 00 48 <3d> 85 00 00 00 0f 8d 8d 00 00 00 48 89 c1 48 c1 e0 04 48 8d 15 c7
[72856.191701] RSP: 002b:000000c0004c5490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[72856.191702] RAX: ffffffffffffffda RBX: 000000c00002c500 RCX: 00000000004a5c20
[72856.191703] RDX: 0000000000000000 RSI: 000000c0004c55c0 RDI: 000000c00036e180
[72856.191703] RBP: 000000c0004c54f0 R08: 0000000000000000 R09: 0000000000000000
[72856.191704] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[72856.191704] R13: 000000000000000d R14: 000000000000000c R15: 0000000000000100
[72856.191720] INFO: task cifsd:997 blocked for more than 241 seconds.
[72856.192084]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72856.192426] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72856.192797] cifsd           D    0   997      2 0x80004000
[72856.192799] Call Trace:
[72856.192802]  ? __schedule+0x3e9/0x670
[72856.192804]  schedule+0x39/0xa0
[72856.192805]  schedule_preempt_disabled+0xa/0x10
[72856.192806]  __mutex_lock.isra.7+0x2a1/0x4d0
[72856.192809]  ? account_entity_enqueue+0x9c/0xc0
[72856.192832]  ? dfs_cache_noreq_find+0x90/0x170 [cifs]
[72856.192844]  dfs_cache_noreq_find+0x90/0x170 [cifs]
[72856.192853]  cifs_reconnect+0xc5/0xd20 [cifs]
[72856.192862]  cifs_handle_standard+0x166/0x190 [cifs]
[72856.192870]  cifs_demultiplex_thread+0xaca/0xc20 [cifs]
[72856.192872]  ? __switch_to+0x7a/0x3e0
[72856.192880]  ? cifs_handle_standard+0x190/0x190 [cifs]
[72856.192881]  kthread+0xf8/0x130
[72856.192883]  ? kthread_create_worker_on_cpu+0x70/0x70
[72856.192884]  ret_from_fork+0x35/0x40
[72856.192899] INFO: task kworker/0:1:21401 blocked for more than 120 seconds.
[72856.193253]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72856.193698] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72856.194073] kworker/0:1     D    0 21401      2 0x80004000
[72856.194097] Workqueue: cifsiod refresh_cache_worker [cifs]
[72856.194097] Call Trace:
[72856.194100]  ? __schedule+0x3e9/0x670
[72856.194101]  schedule+0x39/0xa0
[72856.194102]  schedule_preempt_disabled+0xa/0x10
[72856.194104]  __mutex_lock.isra.7+0x2a1/0x4d0
[72856.194112]  ? __switch_to_asm+0x34/0x70
[72856.194114]  ? __switch_to_asm+0x34/0x70
[72856.194115]  ? __switch_to_asm+0x40/0x70
[72856.194127]  ? refresh_cache_worker+0x2e2/0xee0 [cifs]
[72856.194138]  refresh_cache_worker+0x2e2/0xee0 [cifs]
[72856.194140]  ? __switch_to_asm+0x34/0x70
[72856.194141]  ? __switch_to_asm+0x34/0x70
[72856.194142]  ? __switch_to_asm+0x40/0x70
[72856.194143]  ? __switch_to_asm+0x34/0x70
[72856.194144]  ? __switch_to+0x7a/0x3e0
[72856.194145]  ? __switch_to_asm+0x34/0x70
[72856.194148]  process_one_work+0x191/0x370
[72856.194150]  worker_thread+0x4f/0x3b0
[72856.194151]  ? rescuer_thread+0x340/0x340
[72856.194152]  kthread+0xf8/0x130
[72856.194154]  ? kthread_create_worker_on_cpu+0x70/0x70
[72856.194155]  ret_from_fork+0x35/0x40
[72977.011482] INFO: task node_exporter:3853 blocked for more than 362 seconds.
[72977.012158]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72977.012823] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72977.013440] node_exporter   D    0  3853      1 0x00000000
[72977.013443] Call Trace:
[72977.013452]  ? __schedule+0x3e9/0x670
[72977.013455]  ? __switch_to_asm+0x34/0x70
[72977.013456]  schedule+0x39/0xa0
[72977.013458]  schedule_preempt_disabled+0xa/0x10
[72977.013460]  __mutex_lock.isra.7+0x2a1/0x4d0
[72977.013462]  ? __switch_to_asm+0x34/0x70
[72977.013465]  ? __switch_to+0x101/0x3e0
[72977.013511]  ? smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[72977.013529]  smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[72977.013547]  ? wait_for_response.isra.11+0x5b/0xf0 [cifs]
[72977.013563]  smb2_plain_req_init+0x1d9/0x260 [cifs]
[72977.013580]  SMB2_open_init+0x6d/0x870 [cifs]
[72977.013596]  ? smb2_query_info_compound+0x173/0x370 [cifs]
[72977.013611]  ? cifs_small_buf_release+0x16/0x60 [cifs]
[72977.013626]  smb2_query_info_compound+0x173/0x370 [cifs]
[72977.013629]  ? __switch_to_asm+0x40/0x70
[72977.013633]  ? lookup_fast+0xc8/0x2c0
[72977.013635]  ? lookup_fast+0xc8/0x2c0
[72977.013652]  ? smb2_queryfs+0x70/0xf0 [cifs]
[72977.013669]  smb2_queryfs+0x70/0xf0 [cifs]
[72977.013680]  cifs_statfs+0xa9/0x2a0 [cifs]
[72977.013684]  statfs_by_dentry+0x6a/0x90
[72977.013686]  vfs_statfs+0x16/0xc0
[72977.013687]  user_statfs+0x50/0xa0
[72977.013689]  __do_sys_statfs+0x20/0x50
[72977.013692]  do_syscall_64+0x55/0x110
[72977.013694]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[72977.013696] RIP: 0033:0x4a5c20
[72977.013703] Code: Bad RIP value.
[72977.013704] RSP: 002b:000000c0004c5490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[72977.013706] RAX: ffffffffffffffda RBX: 000000c00002c500 RCX: 00000000004a5c20
[72977.013707] RDX: 0000000000000000 RSI: 000000c0004c55c0 RDI: 000000c00036e180
[72977.013707] RBP: 000000c0004c54f0 R08: 0000000000000000 R09: 0000000000000000
[72977.013708] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[72977.013709] R13: 000000000000000d R14: 000000000000000c R15: 0000000000000100
[72977.013740] INFO: task cifsd:997 blocked for more than 362 seconds.
[72977.014226]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72977.014678] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72977.015176] cifsd           D    0   997      2 0x80004000
[72977.015179] Call Trace:
[72977.015196]  ? __schedule+0x3e9/0x670
[72977.015200]  schedule+0x39/0xa0
[72977.015202]  schedule_preempt_disabled+0xa/0x10
[72977.015203]  __mutex_lock.isra.7+0x2a1/0x4d0
[72977.015207]  ? account_entity_enqueue+0x9c/0xc0
[72977.015231]  ? dfs_cache_noreq_find+0x90/0x170 [cifs]
[72977.015246]  dfs_cache_noreq_find+0x90/0x170 [cifs]
[72977.015259]  cifs_reconnect+0xc5/0xd20 [cifs]
[72977.015274]  cifs_handle_standard+0x166/0x190 [cifs]
[72977.015288]  cifs_demultiplex_thread+0xaca/0xc20 [cifs]
[72977.015290]  ? __switch_to+0x7a/0x3e0
[72977.015309]  ? cifs_handle_standard+0x190/0x190 [cifs]
[72977.015311]  kthread+0xf8/0x130
[72977.015313]  ? kthread_create_worker_on_cpu+0x70/0x70
[72977.015322]  ret_from_fork+0x35/0x40
[72977.015349] INFO: task kworker/0:1:21401 blocked for more than 241 seconds.
[72977.016210]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[72977.016820] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[72977.017520] kworker/0:1     D    0 21401      2 0x80004000
[72977.017551] Workqueue: cifsiod refresh_cache_worker [cifs]
[72977.017553] Call Trace:
[72977.017558]  ? __schedule+0x3e9/0x670
[72977.017559]  schedule+0x39/0xa0
[72977.017561]  schedule_preempt_disabled+0xa/0x10
[72977.017562]  __mutex_lock.isra.7+0x2a1/0x4d0
[72977.017565]  ? __switch_to_asm+0x34/0x70
[72977.017567]  ? __switch_to_asm+0x34/0x70
[72977.017568]  ? __switch_to_asm+0x40/0x70
[72977.017584]  ? refresh_cache_worker+0x2e2/0xee0 [cifs]
[72977.017599]  refresh_cache_worker+0x2e2/0xee0 [cifs]
[72977.017603]  ? __switch_to_asm+0x34/0x70
[72977.017604]  ? __switch_to_asm+0x34/0x70
[72977.017605]  ? __switch_to_asm+0x40/0x70
[72977.017606]  ? __switch_to_asm+0x34/0x70
[72977.017608]  ? __switch_to+0x7a/0x3e0
[72977.017610]  ? __switch_to_asm+0x34/0x70
[72977.017614]  process_one_work+0x191/0x370
[72977.017616]  worker_thread+0x4f/0x3b0
[72977.017618]  ? rescuer_thread+0x340/0x340
[72977.017620]  kthread+0xf8/0x130
[72977.017621]  ? kthread_create_worker_on_cpu+0x70/0x70
[72977.017623]  ret_from_fork+0x35/0x40
[73097.836447] INFO: task node_exporter:3853 blocked for more than 483 seconds.
[73097.836911]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[73097.837353] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[73097.837788] node_exporter   D    0  3853      1 0x00000000
[73097.837790] Call Trace:
[73097.837806]  ? __schedule+0x3e9/0x670
[73097.837809]  ? __switch_to_asm+0x34/0x70
[73097.837810]  schedule+0x39/0xa0
[73097.837811]  schedule_preempt_disabled+0xa/0x10
[73097.837812]  __mutex_lock.isra.7+0x2a1/0x4d0
[73097.837814]  ? __switch_to_asm+0x34/0x70
[73097.837816]  ? __switch_to+0x101/0x3e0
[73097.837844]  ? smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[73097.837857]  smb2_reconnect.part.23+0xe1/0x7a0 [cifs]
[73097.837868]  ? wait_for_response.isra.11+0x5b/0xf0 [cifs]
[73097.837880]  smb2_plain_req_init+0x1d9/0x260 [cifs]
[73097.837892]  SMB2_open_init+0x6d/0x870 [cifs]
[73097.837904]  ? smb2_query_info_compound+0x173/0x370 [cifs]
[73097.837914]  ? cifs_small_buf_release+0x16/0x60 [cifs]
[73097.837925]  smb2_query_info_compound+0x173/0x370 [cifs]
[73097.837927]  ? __switch_to_asm+0x40/0x70
[73097.837929]  ? lookup_fast+0xc8/0x2c0
[73097.837930]  ? lookup_fast+0xc8/0x2c0
[73097.837942]  ? smb2_queryfs+0x70/0xf0 [cifs]
[73097.837953]  smb2_queryfs+0x70/0xf0 [cifs]
[73097.837961]  cifs_statfs+0xa9/0x2a0 [cifs]
[73097.837963]  statfs_by_dentry+0x6a/0x90
[73097.837964]  vfs_statfs+0x16/0xc0
[73097.837965]  user_statfs+0x50/0xa0
[73097.837966]  __do_sys_statfs+0x20/0x50
[73097.837968]  do_syscall_64+0x55/0x110
[73097.837970]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[73097.837971] RIP: 0033:0x4a5c20
[73097.837975] Code: Bad RIP value.
[73097.837976] RSP: 002b:000000c0004c5490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[73097.837977] RAX: ffffffffffffffda RBX: 000000c00002c500 RCX: 00000000004a5c20
[73097.837977] RDX: 0000000000000000 RSI: 000000c0004c55c0 RDI: 000000c00036e180
[73097.837978] RBP: 000000c0004c54f0 R08: 0000000000000000 R09: 0000000000000000
[73097.837978] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[73097.837979] R13: 000000000000000d R14: 000000000000000c R15: 0000000000000100
[73097.837992] INFO: task cifsd:997 blocked for more than 483 seconds.
[73097.838427]       Tainted: G            E     5.3.1-pd-5.3.y #20190925
[73097.838864] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[73097.839333] cifsd           D    0   997      2 0x80004000
[73097.839335] Call Trace:
[73097.839339]  ? __schedule+0x3e9/0x670
[73097.839341]  schedule+0x39/0xa0
[73097.839342]  schedule_preempt_disabled+0xa/0x10
[73097.839349]  __mutex_lock.isra.7+0x2a1/0x4d0
[73097.839353]  ? account_entity_enqueue+0x9c/0xc0
[73097.839376]  ? dfs_cache_noreq_find+0x90/0x170 [cifs]
[73097.839387]  dfs_cache_noreq_find+0x90/0x170 [cifs]
[73097.839397]  cifs_reconnect+0xc5/0xd20 [cifs]
[73097.839406]  cifs_handle_standard+0x166/0x190 [cifs]
[73097.839415]  cifs_demultiplex_thread+0xaca/0xc20 [cifs]
[73097.839416]  ? __switch_to+0x7a/0x3e0
[73097.839425]  ? cifs_handle_standard+0x190/0x190 [cifs]
[73097.839426]  kthread+0xf8/0x130
[73097.839427]  ? kthread_create_worker_on_cpu+0x70/0x70
[73097.839429]  ret_from_fork+0x35/0x40 

--
Martijn de Gouw
Designer
Prodrive Technologies
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200
