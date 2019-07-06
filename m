Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6EEC0650E
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 11:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0906A2089C
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 11:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfGFLLn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 07:11:43 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:53439 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbfGFLLn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Jul 2019 07:11:43 -0400
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 1720D32EC3_D2081ECB;
        Sat,  6 Jul 2019 11:11:40 +0000 (GMT)
Received: from mail.prodrive-technologies.com (mdb-dag.prodrive.nl [10.1.1.212])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "Prodrive Technologies B.V. OV SSL Issuing CA" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id 1F4DF3028F_D2081EBF;
        Sat,  6 Jul 2019 11:11:39 +0000 (GMT)
Received: from [10.10.240.30] (10.1.249.1) by EXC03.bk.prodrive.nl
 (10.1.1.212) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Sat, 6
 Jul 2019 13:11:38 +0200
Subject: Re: Many processes end up in uninterruptible sleep accessing cifs
 mounts
To:     Pavel Shilovsky <piastryyy@gmail.com>
CC:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com>
 <875zojx70t.fsf@suse.com>
 <1fc4f6d0-6cdc-69a5-4359-23484d6bdfc9@prodrive-technologies.com>
 <8736jmxcwi.fsf@suse.com>
 <5d4fd393-9c6c-c407-462e-441cd46bbdd8@prodrive-technologies.com>
 <CAKywueTpgXyFMxveRj6Hm-=vuCC6xh1z0W9bqAFcpCiREe6Vwg@mail.gmail.com>
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Organization: Prodrive Technologies
Message-ID: <325128ce-6ef7-9a18-a626-ee3505037c2c@prodrive-technologies.com>
Date:   Sat, 6 Jul 2019 13:11:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKywueTpgXyFMxveRj6Hm-=vuCC6xh1z0W9bqAFcpCiREe6Vwg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EXC03.bk.prodrive.nl (10.1.1.212) To EXC03.bk.prodrive.nl
 (10.1.1.212)
X-SASI-RCODE: 200
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

On 04-07-2019 23:34, Pavel Shilovsky wrote:
> Hi Martijn,
> 
> Thanks for reporting the problem. Have you tried v5.1.5 kernel and
> above? That one has many reconnect fixes. If yes, could you please
> provide the kernel stack / panic traces when running new versions of
> the kernel?

I can try to run them for a while on a less critical server. But even if that machine runs fine, there is not really a guarantee the cifs issue we have right now is solved for our critical machines, causing me to be very hesitated to upgrade those.

Btw, here is another kernel dump, generated today. Please note that on this machine the cifs mounts are not really used, all 'action'
performed on these mounts is the check if they are still mounted (by puppet).


[36247.367572] INFO: task node_exporter:3567 blocked for more than 120 seconds.
[36247.367613]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36247.367630] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36247.367648] node_exporter   D    0  3567      1 0x00000000
[36247.367650] Call Trace:
[36247.367668]  ? __schedule+0x338/0x850
[36247.367671]  ? preempt_count_add+0x67/0xb0
[36247.367673]  schedule+0x3c/0x90
[36247.367675]  schedule_preempt_disabled+0x14/0x20
[36247.367676]  __mutex_lock.isra.7+0x19f/0x540
[36247.367680]  ? try_module_get+0x68/0x100
[36247.367792]  ? smb2_reconnect+0x1d7/0x4b0 [cifs]
[36247.367803]  smb2_reconnect+0x1d7/0x4b0 [cifs]
[36247.367824]  smb2_plain_req_init+0x30/0x240 [cifs]
[36247.367826]  ? __switch_to_asm+0x34/0x70
[36247.367827]  ? __switch_to_asm+0x40/0x70
[36247.367836]  SMB2_open_init+0x6d/0x7c0 [cifs]
[36247.367846]  ? smb2_queryfs+0x13d/0x350 [cifs]
[36247.367848]  ? lookup_fast+0xc8/0x2e0
[36247.367857]  smb2_queryfs+0x13d/0x350 [cifs]
[36247.367861]  ? lookup_fast+0xc8/0x2e0
[36247.367863]  ? ___cache_free+0x31/0x2e0
[36247.367865]  ? terminate_walk+0x93/0x100
[36247.367873]  ? cifs_statfs+0xad/0x300 [cifs]
[36247.367880]  cifs_statfs+0xad/0x300 [cifs]
[36247.367894]  statfs_by_dentry+0x6a/0x90
[36247.367895]  vfs_statfs+0x16/0xc0
[36247.367897]  user_statfs+0x50/0xa0
[36247.367898]  __do_sys_statfs+0x20/0x50
[36247.367902]  do_syscall_64+0x55/0x100
[36247.367903]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36247.367905] RIP: 0033:0x4a5c20
[36247.367936] Code: Bad RIP value.
[36247.367937] RSP: 002b:000000c0003ef490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[36247.367938] RAX: ffffffffffffffda RBX: 000000c00002a000 RCX: 00000000004a5c20
[36247.367939] RDX: 0000000000000000 RSI: 000000c0003ef5c0 RDI: 000000c0004510e0
[36247.367940] RBP: 000000c0003ef4f0 R08: 0000000000000000 R09: 0000000000000000
[36247.367940] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[36247.367941] R13: 0000000000000088 R14: 0000000000000087 R15: 0000000000000100
[36247.367954] INFO: task kworker/1:2:32265 blocked for more than 120 seconds.
[36247.367973]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36247.367989] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36247.368008] kworker/1:2     D    0 32265      2 0x80000000
[36247.368020] Workqueue: cifsiod smb2_reconnect_server [cifs]
[36247.368021] Call Trace:
[36247.368023]  ? __schedule+0x338/0x850
[36247.368025]  schedule+0x3c/0x90
[36247.368026]  schedule_preempt_disabled+0x14/0x20
[36247.368028]  __mutex_lock.isra.7+0x19f/0x540
[36247.368037]  ? SMB2_sess_auth_rawntlmssp_authenticate+0x69/0x170 [cifs]
[36247.368046]  ? SMB2_sess_setup+0x17f/0x2c0 [cifs]
[36247.368054]  ? cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
[36247.368055]  ? _raw_spin_unlock+0x16/0x30
[36247.368062]  cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
[36247.368071]  smb2_reconnect+0x2d6/0x4b0 [cifs]
[36247.368073]  ? _raw_spin_unlock+0x16/0x30
[36247.368074]  ? preempt_count_add+0x67/0xb0
[36247.368083]  smb2_reconnect_server+0x1bb/0x350 [cifs]
[36247.368090]  process_one_work+0x188/0x3a0
[36247.368092]  worker_thread+0x4c/0x3a0
[36247.368094]  ? preempt_count_add+0x67/0xb0
[36247.368095]  ? process_one_work+0x3a0/0x3a0
[36247.368097]  kthread+0xf8/0x130
[36247.368099]  ? kthread_create_worker_on_cpu+0x70/0x70
[36247.368101]  ret_from_fork+0x35/0x40
[36247.368103] INFO: task puppet:3836 blocked for more than 120 seconds.
[36247.368119]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36247.368135] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36247.368158] puppet          D    0  3836    541 0x00000000
[36247.368159] Call Trace:
[36247.368161]  ? __schedule+0x338/0x850
[36247.368163]  schedule+0x3c/0x90
[36247.368164]  schedule_preempt_disabled+0x14/0x20
[36247.368165]  __mutex_lock.isra.7+0x19f/0x540
[36247.368166]  ? __switch_to_asm+0x34/0x70
[36247.368167]  ? __switch_to_asm+0x40/0x70
[36247.368169]  ? try_module_get+0x68/0x100
[36247.368178]  ? smb2_reconnect+0x1d7/0x4b0 [cifs]
[36247.368186]  smb2_reconnect+0x1d7/0x4b0 [cifs]
[36247.368188]  ? _raw_spin_unlock_irq+0x1d/0x30
[36247.368189]  ? finish_task_switch+0x7d/0x290
[36247.368190]  ? __switch_to_asm+0x40/0x70
[36247.368198]  smb2_plain_req_init+0x30/0x240 [cifs]
[36247.368199]  ? _raw_spin_lock_irqsave+0x25/0x50
[36247.368208]  SMB2_open_init+0x6d/0x7c0 [cifs]
[36247.368209]  ? _raw_spin_lock+0x13/0x30
[36247.368218]  ? cifs_mid_q_entry_release+0x15/0x40 [cifs]
[36247.368227]  ? SMB2_open+0x150/0x520 [cifs]
[36247.368235]  SMB2_open+0x150/0x520 [cifs]
[36247.368238]  ? sched_clock+0x5/0x10
[36247.368247]  ? open_shroot+0x12f/0x200 [cifs]
[36247.368255]  open_shroot+0x12f/0x200 [cifs]
[36247.368258]  ? __follow_mount_rcu.isra.31+0x3c/0xf0
[36247.368267]  smb2_query_path_info+0x93/0x220 [cifs]
[36247.368269]  ? walk_component+0x48/0x360
[36247.368278]  cifs_get_inode_info+0x580/0xb10 [cifs]
[36247.368286]  ? filename_lookup+0xf8/0x1a0
[36247.368294]  ? build_path_from_dentry_optional_prefix+0x1e9/0x440 [cifs]
[36247.368303]  cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
[36247.368311]  cifs_getattr+0x5b/0x1b0 [cifs]
[36247.368313]  vfs_statx+0x89/0xe0
[36247.368315]  __do_sys_newlstat+0x39/0x70
[36247.368318]  do_syscall_64+0x55/0x100
[36247.368320]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36247.368321] RIP: 0033:0x7f562d3a0335
[36247.368323] Code: Bad RIP value.
[36247.368324] RSP: 002b:00007ffc6bbc4398 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[36247.368325] RAX: ffffffffffffffda RBX: 00007ffc6bbc43b0 RCX: 00007f562d3a0335
[36247.368326] RDX: 00007ffc6bbc43b0 RSI: 00007ffc6bbc43b0 RDI: 000055e4e5e1bd50
[36247.368326] RBP: 000055e4e2eb65e0 R08: 0000000000000002 R09: 000055e4e2eb69e0
[36247.368327] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[36247.368328] R13: 000055e4e2ef7258 R14: 000055e4e2ef8810 R15: 000055e4e2f92ad0
[36368.186922] INFO: task node_exporter:3567 blocked for more than 120 seconds.
[36368.186988]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36368.187039] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36368.187097] node_exporter   D    0  3567      1 0x00000000
[36368.187102] Call Trace:
[36368.187117]  ? __schedule+0x338/0x850
[36368.187123]  ? preempt_count_add+0x67/0xb0
[36368.187128]  schedule+0x3c/0x90
[36368.187133]  schedule_preempt_disabled+0x14/0x20
[36368.187138]  __mutex_lock.isra.7+0x19f/0x540
[36368.187175]  ? try_module_get+0x68/0x100
[36368.187232]  ? smb2_reconnect+0x1d7/0x4b0 [cifs]
[36368.187265]  smb2_reconnect+0x1d7/0x4b0 [cifs]
[36368.187300]  smb2_plain_req_init+0x30/0x240 [cifs]
[36368.187304]  ? __switch_to_asm+0x34/0x70
[36368.187307]  ? __switch_to_asm+0x40/0x70
[36368.187337]  SMB2_open_init+0x6d/0x7c0 [cifs]
[36368.187372]  ? smb2_queryfs+0x13d/0x350 [cifs]
[36368.187375]  ? lookup_fast+0xc8/0x2e0
[36368.187405]  smb2_queryfs+0x13d/0x350 [cifs]
[36368.187410]  ? lookup_fast+0xc8/0x2e0
[36368.187416]  ? ___cache_free+0x31/0x2e0
[36368.187421]  ? terminate_walk+0x93/0x100
[36368.187449]  ? cifs_statfs+0xad/0x300 [cifs]
[36368.187471]  cifs_statfs+0xad/0x300 [cifs]
[36368.187477]  statfs_by_dentry+0x6a/0x90
[36368.187482]  vfs_statfs+0x16/0xc0
[36368.187486]  user_statfs+0x50/0xa0
[36368.187491]  __do_sys_statfs+0x20/0x50
[36368.187499]  do_syscall_64+0x55/0x100
[36368.187503]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36368.187507] RIP: 0033:0x4a5c20
[36368.187517] Code: Bad RIP value.
[36368.187519] RSP: 002b:000000c0003ef490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[36368.187523] RAX: ffffffffffffffda RBX: 000000c00002a000 RCX: 00000000004a5c20
[36368.187526] RDX: 0000000000000000 RSI: 000000c0003ef5c0 RDI: 000000c0004510e0
[36368.187528] RBP: 000000c0003ef4f0 R08: 0000000000000000 R09: 0000000000000000
[36368.187530] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[36368.187532] R13: 0000000000000088 R14: 0000000000000087 R15: 0000000000000100
[36368.187572] INFO: task kworker/1:2:32265 blocked for more than 120 seconds.
[36368.187627]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36368.187677] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36368.187735] kworker/1:2     D    0 32265      2 0x80000000
[36368.187771] Workqueue: cifsiod smb2_reconnect_server [cifs]
[36368.187773] Call Trace:
[36368.187780]  ? __schedule+0x338/0x850
[36368.187785]  schedule+0x3c/0x90
[36368.187790]  schedule_preempt_disabled+0x14/0x20
[36368.187795]  __mutex_lock.isra.7+0x19f/0x540
[36368.187826]  ? SMB2_sess_auth_rawntlmssp_authenticate+0x69/0x170 [cifs]
[36368.187855]  ? SMB2_sess_setup+0x17f/0x2c0 [cifs]
[36368.187880]  ? cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
[36368.187885]  ? _raw_spin_unlock+0x16/0x30
[36368.187908]  cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
[36368.187936]  smb2_reconnect+0x2d6/0x4b0 [cifs]
[36368.187942]  ? _raw_spin_unlock+0x16/0x30
[36368.187947]  ? preempt_count_add+0x67/0xb0
[36368.187976]  smb2_reconnect_server+0x1bb/0x350 [cifs]
[36368.187984]  process_one_work+0x188/0x3a0
[36368.187990]  worker_thread+0x4c/0x3a0
[36368.187994]  ? preempt_count_add+0x67/0xb0
[36368.187998]  ? process_one_work+0x3a0/0x3a0
[36368.188001]  kthread+0xf8/0x130
[36368.188005]  ? kthread_create_worker_on_cpu+0x70/0x70
[36368.188009]  ret_from_fork+0x35/0x40
[36368.188014] INFO: task puppet:3836 blocked for more than 120 seconds.
[36368.188064]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36368.188114] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36368.188182] puppet          D    0  3836    541 0x00000000
[36368.188186] Call Trace:
[36368.188191]  ? __schedule+0x338/0x850
[36368.188196]  schedule+0x3c/0x90
[36368.188200]  schedule_preempt_disabled+0x14/0x20
[36368.188205]  __mutex_lock.isra.7+0x19f/0x540
[36368.188208]  ? __switch_to_asm+0x34/0x70
[36368.188211]  ? __switch_to_asm+0x40/0x70
[36368.188215]  ? try_module_get+0x68/0x100
[36368.188244]  ? smb2_reconnect+0x1d7/0x4b0 [cifs]
[36368.188271]  smb2_reconnect+0x1d7/0x4b0 [cifs]
[36368.188277]  ? _raw_spin_unlock_irq+0x1d/0x30
[36368.188280]  ? finish_task_switch+0x7d/0x290
[36368.188283]  ? __switch_to_asm+0x40/0x70
[36368.188310]  smb2_plain_req_init+0x30/0x240 [cifs]
[36368.188314]  ? _raw_spin_lock_irqsave+0x25/0x50
[36368.188342]  SMB2_open_init+0x6d/0x7c0 [cifs]
[36368.188346]  ? _raw_spin_lock+0x13/0x30
[36368.188376]  ? cifs_mid_q_entry_release+0x15/0x40 [cifs]
[36368.188405]  ? SMB2_open+0x150/0x520 [cifs]
[36368.188432]  SMB2_open+0x150/0x520 [cifs]
[36368.188440]  ? sched_clock+0x5/0x10
[36368.188470]  ? open_shroot+0x12f/0x200 [cifs]
[36368.188497]  open_shroot+0x12f/0x200 [cifs]
[36368.188503]  ? __follow_mount_rcu.isra.31+0x3c/0xf0
[36368.188534]  smb2_query_path_info+0x93/0x220 [cifs]
[36368.188539]  ? walk_component+0x48/0x360
[36368.188569]  cifs_get_inode_info+0x580/0xb10 [cifs]
[36368.188574]  ? filename_lookup+0xf8/0x1a0
[36368.188601]  ? build_path_from_dentry_optional_prefix+0x1e9/0x440 [cifs]
[36368.188630]  cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
[36368.188659]  cifs_getattr+0x5b/0x1b0 [cifs]
[36368.188664]  vfs_statx+0x89/0xe0
[36368.188670]  __do_sys_newlstat+0x39/0x70
[36368.188677]  do_syscall_64+0x55/0x100
[36368.188681]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36368.188684] RIP: 0033:0x7f562d3a0335
[36368.188689] Code: Bad RIP value.
[36368.188691] RSP: 002b:00007ffc6bbc4398 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[36368.188695] RAX: ffffffffffffffda RBX: 00007ffc6bbc43b0 RCX: 00007f562d3a0335
[36368.188696] RDX: 00007ffc6bbc43b0 RSI: 00007ffc6bbc43b0 RDI: 000055e4e5e1bd50
[36368.188698] RBP: 000055e4e2eb65e0 R08: 0000000000000002 R09: 000055e4e2eb69e0
[36368.188700] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[36368.188702] R13: 000055e4e2ef7258 R14: 000055e4e2ef8810 R15: 000055e4e2f92ad0
[36489.006262] INFO: task node_exporter:3567 blocked for more than 120 seconds.
[36489.006300]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36489.006329] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36489.006458] node_exporter   D    0  3567      1 0x00000000
[36489.006461] Call Trace:
[36489.006470]  ? __schedule+0x338/0x850
[36489.006474]  ? preempt_count_add+0x67/0xb0
[36489.006476]  schedule+0x3c/0x90
[36489.006478]  schedule_preempt_disabled+0x14/0x20
[36489.006480]  __mutex_lock.isra.7+0x19f/0x540
[36489.006485]  ? try_module_get+0x68/0x100
[36489.006515]  ? smb2_reconnect+0x1d7/0x4b0 [cifs]
[36489.006531]  smb2_reconnect+0x1d7/0x4b0 [cifs]
[36489.006547]  smb2_plain_req_init+0x30/0x240 [cifs]
[36489.006549]  ? __switch_to_asm+0x34/0x70
[36489.006550]  ? __switch_to_asm+0x40/0x70
[36489.006565]  SMB2_open_init+0x6d/0x7c0 [cifs]
[36489.006581]  ? smb2_queryfs+0x13d/0x350 [cifs]
[36489.006583]  ? lookup_fast+0xc8/0x2e0
[36489.006597]  smb2_queryfs+0x13d/0x350 [cifs]
[36489.006599]  ? lookup_fast+0xc8/0x2e0
[36489.006602]  ? ___cache_free+0x31/0x2e0
[36489.006604]  ? terminate_walk+0x93/0x100
[36489.006619]  ? cifs_statfs+0xad/0x300 [cifs]
[36489.006632]  cifs_statfs+0xad/0x300 [cifs]
[36489.006635]  statfs_by_dentry+0x6a/0x90
[36489.006637]  vfs_statfs+0x16/0xc0
[36489.006639]  user_statfs+0x50/0xa0
[36489.006641]  __do_sys_statfs+0x20/0x50
[36489.006645]  do_syscall_64+0x55/0x100
[36489.006647]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36489.006649] RIP: 0033:0x4a5c20
[36489.006654] Code: Bad RIP value.
[36489.006655] RSP: 002b:000000c0003ef490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[36489.006657] RAX: ffffffffffffffda RBX: 000000c00002a000 RCX: 00000000004a5c20
[36489.006658] RDX: 0000000000000000 RSI: 000000c0003ef5c0 RDI: 000000c0004510e0
[36489.006659] RBP: 000000c0003ef4f0 R08: 0000000000000000 R09: 0000000000000000
[36489.006660] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[36489.006661] R13: 0000000000000088 R14: 0000000000000087 R15: 0000000000000100
[36489.006675] INFO: task kworker/1:2:32265 blocked for more than 120 seconds.
[36489.006812]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36489.006940] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36489.007076] kworker/1:2     D    0 32265      2 0x80000000
[36489.007100] Workqueue: cifsiod smb2_reconnect_server [cifs]
[36489.007101] Call Trace:
[36489.007105]  ? __schedule+0x338/0x850
[36489.007107]  schedule+0x3c/0x90
[36489.007109]  schedule_preempt_disabled+0x14/0x20
[36489.007111]  __mutex_lock.isra.7+0x19f/0x540
[36489.007124]  ? SMB2_sess_auth_rawntlmssp_authenticate+0x69/0x170 [cifs]
[36489.007134]  ? SMB2_sess_setup+0x17f/0x2c0 [cifs]
[36489.007141]  ? cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
[36489.007143]  ? _raw_spin_unlock+0x16/0x30
[36489.007150]  cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
[36489.007159]  smb2_reconnect+0x2d6/0x4b0 [cifs]
[36489.007161]  ? _raw_spin_unlock+0x16/0x30
[36489.007163]  ? preempt_count_add+0x67/0xb0
[36489.007172]  smb2_reconnect_server+0x1bb/0x350 [cifs]
[36489.007176]  process_one_work+0x188/0x3a0
[36489.007178]  worker_thread+0x4c/0x3a0
[36489.007179]  ? preempt_count_add+0x67/0xb0
[36489.007180]  ? process_one_work+0x3a0/0x3a0
[36489.007181]  kthread+0xf8/0x130
[36489.007183]  ? kthread_create_worker_on_cpu+0x70/0x70
[36489.007184]  ret_from_fork+0x35/0x40
[36489.007186] INFO: task puppet:3836 blocked for more than 120 seconds.
[36489.007294]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36489.007409] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36489.007540] puppet          D    0  3836    541 0x00000000
[36489.007541] Call Trace:
[36489.007545]  ? __schedule+0x338/0x850
[36489.007548]  schedule+0x3c/0x90
[36489.007550]  schedule_preempt_disabled+0x14/0x20
[36489.007552]  __mutex_lock.isra.7+0x19f/0x540
[36489.007553]  ? __switch_to_asm+0x34/0x70
[36489.007555]  ? __switch_to_asm+0x40/0x70
[36489.007558]  ? try_module_get+0x68/0x100
[36489.007580]  ? smb2_reconnect+0x1d7/0x4b0 [cifs]
[36489.007594]  smb2_reconnect+0x1d7/0x4b0 [cifs]
[36489.007596]  ? _raw_spin_unlock_irq+0x1d/0x30
[36489.007598]  ? finish_task_switch+0x7d/0x290
[36489.007600]  ? __switch_to_asm+0x40/0x70
[36489.007613]  smb2_plain_req_init+0x30/0x240 [cifs]
[36489.007615]  ? _raw_spin_lock_irqsave+0x25/0x50
[36489.007628]  SMB2_open_init+0x6d/0x7c0 [cifs]
[36489.007630]  ? _raw_spin_lock+0x13/0x30
[36489.007644]  ? cifs_mid_q_entry_release+0x15/0x40 [cifs]
[36489.007658]  ? SMB2_open+0x150/0x520 [cifs]
[36489.007672]  SMB2_open+0x150/0x520 [cifs]
[36489.007677]  ? sched_clock+0x5/0x10
[36489.007692]  ? open_shroot+0x12f/0x200 [cifs]
[36489.007707]  open_shroot+0x12f/0x200 [cifs]
[36489.007711]  ? __follow_mount_rcu.isra.31+0x3c/0xf0
[36489.007727]  smb2_query_path_info+0x93/0x220 [cifs]
[36489.007729]  ? walk_component+0x48/0x360
[36489.007745]  cifs_get_inode_info+0x580/0xb10 [cifs]
[36489.007748]  ? filename_lookup+0xf8/0x1a0
[36489.007762]  ? build_path_from_dentry_optional_prefix+0x1e9/0x440 [cifs]
[36489.007778]  cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
[36489.007791]  cifs_getattr+0x5b/0x1b0 [cifs]
[36489.007794]  vfs_statx+0x89/0xe0
[36489.007797]  __do_sys_newlstat+0x39/0x70
[36489.007801]  do_syscall_64+0x55/0x100
[36489.007802]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36489.007805] RIP: 0033:0x7f562d3a0335
[36489.007808] Code: Bad RIP value.
[36489.007809] RSP: 002b:00007ffc6bbc4398 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[36489.007811] RAX: ffffffffffffffda RBX: 00007ffc6bbc43b0 RCX: 00007f562d3a0335
[36489.007812] RDX: 00007ffc6bbc43b0 RSI: 00007ffc6bbc43b0 RDI: 000055e4e5e1bd50
[36489.007813] RBP: 000055e4e2eb65e0 R08: 0000000000000002 R09: 000055e4e2eb69e0
[36489.007814] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[36489.007815] R13: 000055e4e2ef7258 R14: 000055e4e2ef8810 R15: 000055e4e2f92ad0
[36609.825705] INFO: task node_exporter:3567 blocked for more than 120 seconds.
[36609.825836]       Tainted: G            E     4.20.17-pd-4.20.y #20190611
[36609.825869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36609.825908] node_exporter   D    0  3567      1 0x00000000
[36609.825910] Call Trace:
[36609.825919]  ? __schedule+0x338/0x850
[36609.825922]  ? preempt_count_add+0x67/0xb0
[36609.825925]  schedule+0x3c/0x90
[36609.825927]  schedule_preempt_disabled+0x14/0x20
[36609.825929]  __mutex_lock.isra.7+0x19f/0x540
[36609.825933]  ? try_module_get+0x68/0x100
[36609.825960]  ? smb2_reconnect+0x1d7/0x4b0 [cifs]
[36609.825979]  smb2_reconnect+0x1d7/0x4b0 [cifs]
[36609.825999]  smb2_plain_req_init+0x30/0x240 [cifs]
[36609.826001]  ? __switch_to_asm+0x34/0x70
[36609.826002]  ? __switch_to_asm+0x40/0x70
[36609.826020]  SMB2_open_init+0x6d/0x7c0 [cifs]
[36609.826039]  ? smb2_queryfs+0x13d/0x350 [cifs]
[36609.826040]  ? lookup_fast+0xc8/0x2e0
[36609.826057]  smb2_queryfs+0x13d/0x350 [cifs]
[36609.826060]  ? lookup_fast+0xc8/0x2e0
[36609.826064]  ? ___cache_free+0x31/0x2e0
[36609.826066]  ? terminate_walk+0x93/0x100
[36609.826084]  ? cifs_statfs+0xad/0x300 [cifs]
[36609.826099]  cifs_statfs+0xad/0x300 [cifs]
[36609.826103]  statfs_by_dentry+0x6a/0x90
[36609.826104]  vfs_statfs+0x16/0xc0
[36609.826106]  user_statfs+0x50/0xa0
[36609.826108]  __do_sys_statfs+0x20/0x50
[36609.826113]  do_syscall_64+0x55/0x100
[36609.826115]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[36609.826117] RIP: 0033:0x4a5c20
[36609.826123] Code: Bad RIP value.
[36609.826124] RSP: 002b:000000c0003ef490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[36609.826126] RAX: ffffffffffffffda RBX: 000000c00002a000 RCX: 00000000004a5c20
[36609.826127] RDX: 0000000000000000 RSI: 000000c0003ef5c0 RDI: 000000c0004510e0
[36609.826128] RBP: 000000c0003ef4f0 R08: 0000000000000000 R09: 0000000000000000
[36609.826129] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[36609.826130] R13: 0000000000000088 R14: 0000000000000087 R15: 0000000000000100
[73117.654990] CIFS VFS: Send error in SessSetup = -126

Regards, Martijn

> 
> --
> Best regards,
> Pavel Shilovsky
> 
> чт, 4 июл. 2019 г. в 06:36, Martijn de Gouw
> <martijn.de.gouw@prodrive-technologies.com>:
>>
>> Hi,
>>
>> On 04-07-2019 13:22, Aurélien Aptel wrote:
>>> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
>>>>> Are there any kernel oops/panic with stack traces and register dumps in
>>>>> the log?
>>>>>
>>>>> You can inspect the kernel stack trace of the hung processes (to see where
>>>>> they are stuck) by printing the file /proc/<pid>/stack.
>>>>
>>>> These are the stacks of all processes that are D, most of them being df.
>>>> I also attached the cifs Stats output below.
>>>
>>> Ok thanks. What about Oops or BUG or panic in dmesg logs, did you see
>>> any?
>>
>> I did find the following messages in the dmesg of one of the servers:
>>
>> [    4.797893] FS-Cache: Duplicate cookie detected
>> [    4.797915] FS-Cache: O-cookie c=000000001a791554 [p=00000000fb6f31ee fl=222 nc=0 na=1]
>> [    4.797934] FS-Cache: O-cookie d=0000000020a06fab n=00000000654600e7
>> [    4.797949] FS-Cache: O-key=[8] '020001bd0a010102'
>> [    4.797963] FS-Cache: N-cookie c=000000005d0bf4a5 [p=00000000fb6f31ee fl=2 nc=0 na=1]
>> [    4.797982] FS-Cache: N-cookie d=0000000020a06fab n=000000004e1e47aa
>> [    4.797997] FS-Cache: N-key=[8] '020001bd0a010102'
>> [    4.798643] FS-Cache: Duplicate cookie detected
>> [    4.798659] FS-Cache: O-cookie c=000000001a791554 [p=00000000fb6f31ee fl=222 nc=0 na=1]
>> [    4.798679] FS-Cache: O-cookie d=0000000020a06fab n=00000000654600e7
>> [    4.798695] FS-Cache: O-key=[8] '020001bd0a010102'
>> [    4.798714] FS-Cache: N-cookie c=00000000cbe44971 [p=00000000fb6f31ee fl=2 nc=0 na=1]
>> [    4.798733] FS-Cache: N-cookie d=0000000020a06fab n=00000000ab0e78a6
>> [    4.798747] FS-Cache: N-key=[8] '020001bd0a010102'
>> [    4.906667] FS-Cache: Netfs 'nfs' registered for caching
>> [12738.729173] CIFS VFS: Send error in SessSetup = -126
>> [99125.480751] CIFS VFS: Send error in SessSetup = -126
>> [185517.295175] CIFS VFS: Send error in SessSetup = -126
>> [250515.749714] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> [250515.749740] BUG: unable to handle kernel paging request at ffff8ec52a6fe1d0
>> [250515.749757] PGD 1b2602067 P4D 1b2602067 PUD 42dbff063 PMD 42a357063 PTE 800000042a6fe063
>> [250515.749779] Oops: 0011 [#1] PREEMPT SMP PTI
>> [250515.749792] CPU: 1 PID: 796 Comm: cifsd Tainted: G            E     4.20.17-pd-4.20.y #20190611
>> [250515.749812] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/19/2018
>> [250515.749844] RIP: 0010:0xffff8ec52a6fe1d0
>> [250515.749860] Code: ff ff 00 00 00 00 fd 01 00 00 00 7d 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <d0> e1 6f 2a c5 8e ff ff d0 e1 6f 2a c5 8e ff ff 80 70 82 2b c5 8e
>> [250515.749914] RSP: 0018:ffff9e60c2e2bdc0 EFLAGS: 00010202
>> [250515.749927] RAX: ffff8ec52a6fe1d0 RBX: ffff8ec526fce800 RCX: dead000000000200
>> [250515.749944] RDX: ffff8ec52d3e6800 RSI: 0000000000000246 RDI: ffff8ec52a6fe198
>> [250515.749962] RBP: ffff8ec52d3e6800 R08: 0000000000000002 R09: ffff8ec52a6fe170
>> [250515.749979] R10: ffff9e60c2e2bc10 R11: ffff8ec527088000 R12: ffff8ec526fce9c0
>> [250515.749997] R13: ffff8ec52d3e6800 R14: ffff9e60c2e2bdd8 R15: ffff8ec52d3e6b80
>> [250515.750014] FS:  0000000000000000(0000) GS:ffff8ec52fa80000(0000) knlGS:0000000000000000
>> [250515.750033] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [250515.750048] CR2: ffff8ec52a6fe1d0 CR3: 000000042a53c005 CR4: 00000000003606e0
>> [250515.750100] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [250515.750102] CIFS VFS: No task to wake, unknown frame received! NumMids 3
>> [250515.750119] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [250515.750120] Call Trace:
>> [250515.750149] 00000000: 424d53fe 00010040 00000000 00000005  .SMB@...........
>> [250515.750193]  ? cifs_reconnect+0x337/0x880 [cifs]
>> [250515.750201]  ? cifs_handle_standard+0x169/0x190 [cifs]
>> [250515.750216] 00000010: 10000009 00000098 00000db2 00000000  ................
>> [250515.750234]  ? cifs_demultiplex_thread+0x9e5/0xbc0 [cifs]
>> [250515.750240] 00000020: 0000025c 00000001 640002e9 0000c81d  \..........d....
>> [250515.750259]  ? finish_task_switch+0x7d/0x290
>> [250515.750271] 00000030: 5a9e63f3 6204a9b0 587058e3 0d45419b  .c.Z...b.XpX.AE.
>> [250515.750295]  ? cifs_handle_standard+0x190/0x190 [cifs]
>> [250515.750728] CIFS VFS: No task to wake, unknown frame received! NumMids 3
>> [250515.751200]  ? kthread+0xf8/0x130
>> [250515.751639] 00000000: 424d53fe 00010040 00000000 00000010  .SMB@...........
>> [250515.752102]  ? kthread_create_worker_on_cpu+0x70/0x70
>> [250515.752554] 00000010: 0000000d 00000068 00000db3 00000000  ....h...........
>> [250515.752997]  ? ret_from_fork+0x35/0x40
>> [250515.753429] 00000020: 0000025c 00000001 640002e9 0000c81d  \..........d....
>> [250515.753874] Modules linked in: cpufreq_userspace(E) cpufreq_powersave(E) cpufreq_conservative(E) arc4(E) ecb(E) md4(E) nfsv3(E) nfs_acl(E) nfs(E) sha512_ssse3(E) sha512_generic(E) lockd(E) cmac(E) grace(E) hmac(E) nls_utf8(E) cifs(E) ccm(E) dns_resolver(E) fscache(E) vmw_vsock_vmci_transport(E) vsock(E) sb_edac(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) vmw_balloon(E) aes_x86_64(E) joydev(E) evdev(E) crypto_simd(E) vmwgfx(E) serio_raw(E) cryptd(E) glue_helper(E) ttm(E) sg(E) vmw_vmci(E) drm_kms_helper(E) drm(E) button(E) ac(E) auth_rpcgss(E) sunrpc(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E) sr_mod(E) cdrom(E) ata_generic(E) sd_mod(E) ata_piix(E) crc32c_intel(E) psmouse(E) libata(E) vmw_pvscsi(E) vmxnet3(E) scsi_mod(E) i2c_piix4(E)
>> [250515.754336] 00000030: 49d4fd21 858665a2 fde5288f 01d2d919  !..I.e...(......
>> [250515.754766] CR2: ffff8ec52a6fe1d0
>> [250515.758927] CIFS VFS: No task to wake, unknown frame received! NumMids 3
>> [250515.759389] ---[ end trace 92ea62cd080150de ]---
>> [250515.759879] 00000000: 424d53fe 00010040 00000000 00030006  .SMB@...........
>> [250515.760357] RIP: 0010:0xffff8ec52a6fe1d0
>> [250515.761841] Code: ff ff 00 00 00 00 fd 01 00 00 00 7d 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <d0> e1 6f 2a c5 8e ff ff d0 e1 6f 2a c5 8e ff ff 80 70 82 2b c5 8e
>> [250515.763287] RSP: 0018:ffff9e60c2e2bdc0 EFLAGS: 00010202
>> [250515.763778] RAX: ffff8ec52a6fe1d0 RBX: ffff8ec526fce800 RCX: dead000000000200
>> [250515.764060] 00000010: 0000000d 00000000 00000db4 00000000  ................
>> [250515.764310] RDX: ffff8ec52d3e6800 RSI: 0000000000000246 RDI: ffff8ec52a6fe198
>> [250515.764311] RBP: ffff8ec52d3e6800 R08: 0000000000000002 R09: ffff8ec52a6fe170
>> [250515.764312] R10: ffff9e60c2e2bc10 R11: ffff8ec527088000 R12: ffff8ec526fce9c0
>> [250515.764314] R13: ffff8ec52d3e6800 R14: ffff9e60c2e2bdd8 R15: ffff8ec52d3e6b80
>> [250515.765491] 00000020: 0000025c 00000001 640002e9 0000c81d  \..........d....
>> [250515.765836] FS:  0000000000000000(0000) GS:ffff8ec52fa80000(0000) knlGS:0000000000000000
>> [250515.767899] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [250515.768367] CR2: ffff8ec52a6fe1d0 CR3: 000000042a53c005 CR4: 00000000003606e0
>> [250515.768919] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [250515.769419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [250515.769591] 00000030: 879543e1 572c0574 e53861ba 97ccc40b  .C..t.,W.a8.....
>> [271909.743603] CIFS VFS: Send error in SessSetup = -126
>> [358301.908585] CIFS VFS: Send error in SessSetup = -126
>> [444693.566453] CIFS VFS: Send error in SessSetup = -126
>> [531086.090040] CIFS VFS: Send error in SessSetup = -126
>> [617477.785390] CIFS VFS: Send error in SessSetup = -126
>> [703869.556705] CIFS VFS: Send error in SessSetup = -126
>> [790261.656853] CIFS VFS: Send error in SessSetup = -126
>> [876653.496928] CIFS VFS: Send error in SessSetup = -126
>> [963045.816742] CIFS VFS: Send error in SessSetup = -126
>> [1049437.566219] CIFS VFS: Send error in SessSetup = -126
>>
>>
>> And from another server:
>> [    4.253091] FS-Cache: Duplicate cookie detected
>> [    4.253120] FS-Cache: O-cookie c=000000004cc29d26 [p=0000000017dbbbc0 fl=222 nc=0 na=1]
>> [    4.253153] FS-Cache: O-cookie d=00000000e8e68765 n=0000000012869fa7
>> [    4.253179] FS-Cache: O-key=[8] '020001bd0a010102'
>> [    4.253201] FS-Cache: N-cookie c=00000000c3bbbddd [p=0000000017dbbbc0 fl=2 nc=0 na=1]
>> [    4.253235] FS-Cache: N-cookie d=00000000e8e68765 n=00000000335882b3
>> [    4.253262] FS-Cache: N-key=[8] '020001bd0a010102'
>> [    4.254107] FS-Cache: Duplicate cookie detected
>> [    4.254130] FS-Cache: O-cookie c=000000004cc29d26 [p=0000000017dbbbc0 fl=222 nc=0 na=1]
>> [    4.254161] FS-Cache: O-cookie d=00000000e8e68765 n=0000000012869fa7
>> [    4.254185] FS-Cache: O-key=[8] '020001bd0a010102'
>> [    4.254230] FS-Cache: N-cookie c=000000000ec2f0bb [p=0000000017dbbbc0 fl=2 nc=0 na=1]
>> [    4.254261] FS-Cache: N-cookie d=00000000e8e68765 n=0000000024706210
>> [    4.254285] FS-Cache: N-key=[8] '020001bd0a010102'
>> [    4.329147] CIFS VFS: BAD_NETWORK_NAME: \\stor02.bk.prodrive.nl\userdata$
>> [    4.330107] CIFS VFS: cifs_mount failed w/return code = -2
>> [65206.127542] CIFS VFS: Send error in SessSetup = -126
>> [151597.808064] CIFS VFS: Send error in SessSetup = -126
>> [237989.956447] CIFS VFS: Send error in SessSetup = -126
>> [324380.937984] CIFS VFS: Send error in SessSetup = -126
>> [402750.869518] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> [402750.869594] BUG: unable to handle kernel paging request at ffff909bf61609d0
>> [402750.869650] PGD 1ac02067 P4D 1ac02067 PUD 1385f5063 PMD 136142063 PTE 8000000136160063
>> [402750.869716] Oops: 0011 [#1] PREEMPT SMP PTI
>> [402750.869753] CPU: 0 PID: 797 Comm: cifsd Tainted: G            E     4.20.17-pd-4.20.y #20190611
>> [402750.869818] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/19/2018
>> [402750.869926] CIFS VFS: No task to wake, unknown frame received! NumMids 3
>> [402750.869947] RIP: 0010:0xffff909bf61609d0
>> [402750.870013] 00000000: 424d53fe 00010040 00000000 00000005  .SMB@...........
>> [402750.870198] Code: ff ff 00 00 00 00 4e 01 00 00 00 7d 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <d0> 09 16 f6 9b 90 ff ff d0 09 16 f6 9b 90 ff ff c0 40 1f f2 9b 90
>> [402750.870275] 00000010: 10000009 00000098 000002b5 00000000  ................
>> [402750.870450] RSP: 0000:ffffa18d41adbd28 EFLAGS: 00010202
>> [402750.870469] 00000020: 000001cd 00000001 44000cd9 0000c824  ...........D$...
>> [402750.870509] RAX: ffff909bf61609d0 RBX: ffff909bf6c3f800 RCX: dead000000000200
>> [402750.870511] RDX: ffff909bf74fa980 RSI: 0000000000000246 RDI: ffff909bf6160998
>> [402750.870530] 00000030: 79955e4a 0dacb8eb 025edebd 4efa7788  J^.y......^..w.N
>> [402750.870582] RBP: ffff909bf74fa980 R08: 0000000000000000 R09: ffff909bf6c3f970
>> [402750.870585] R10: ffffa18d406a7cc0 R11: 0000000000000000 R12: ffff909bf6c3f9c0
>> [402750.870605] CIFS VFS: No task to wake, unknown frame received! NumMids 3
>> [402750.870656] R13: ffff909bf74fa980 R14: ffffa18d41adbd40 R15: ffff909bf74fa100
>> [402750.870660] FS:  0000000000000000(0000) GS:ffff909bf9c00000(0000) knlGS:0000000000000000
>> [402750.870677] 00000000: 424d53fe 00010040 00000000 00000010  .SMB@...........
>> [402750.870731] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [402750.870733] CR2: ffff909bf61609d0 CR3: 0000000136e56004 CR4: 00000000003606f0
>> [402750.870752] 00000010: 0000000d 00000068 000002b6 00000000  ....h...........
>> [402750.870888] 00000020: 000001cd 00000001 44000cd9 0000c824  ...........D$...
>> [402750.870894] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [402750.870907] 00000030: f063942a cae9f6e1 d5327c26 91fc6f33  *.c.....&|2.3o..
>> [402750.872321] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [402750.872324] Call Trace:
>> [402750.872381]  ? cifs_reconnect+0x337/0x880 [cifs]
>> [402750.872410]  ? cifs_readv_from_socket+0x211/0x260 [cifs]
>> [402750.875687]  ? cifs_read_from_socket+0x4a/0x70 [cifs]
>> [402750.876128]  ? _raw_spin_unlock_irqrestore+0x20/0x40
>> [402750.876555]  ? try_to_wake_up+0x54/0x540
>> [402750.876991]  ? cifs_small_buf_get+0x16/0x20 [cifs]
>> [402750.877426]  ? cifs_demultiplex_thread+0xdd/0xbc0 [cifs]
>> [402750.877834]  ? finish_task_switch+0x7d/0x290
>> [402750.878252]  ? cifs_handle_standard+0x190/0x190 [cifs]
>> [402750.878651]  ? kthread+0xf8/0x130
>> [402750.879034]  ? kthread_create_worker_on_cpu+0x70/0x70
>> [402750.879412]  ? ret_from_fork+0x35/0x40
>> [402750.879786] Modules linked in: cpufreq_conservative(E) cpufreq_powersave(E) cpufreq_userspace(E) arc4(E) ecb(E) md4(E) sha512_ssse3(E) sha512_generic(E) cmac(E) hmac(E) nfsv3(E) nfs_acl(E) nls_utf8(E) nfs(E) lockd(E) grace(E) cifs(E) ccm(E) dns_resolver(E) fscache(E) sb_edac(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) crypto_simd(E) joydev(E) cryptd(E) vmw_balloon(E) evdev(E) glue_helper(E) serio_raw(E) vmwgfx(E) ttm(E) drm_kms_helper(E) sg(E) drm(E) vmw_vsock_vmci_transport(E) vsock(E) vmw_vmci(E) ac(E) button(E) auth_rpcgss(E) sunrpc(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E) sr_mod(E) cdrom(E) sd_mod(E) ata_generic(E) ata_piix(E) vmw_pvscsi(E) libata(E) crc32c_intel(E) psmouse(E) vmxnet3(E) i2c_piix4(E) scsi_mod(E)
>> [402750.883384] CR2: ffff909bf61609d0
>> [402750.883783] ---[ end trace 08b06875e82513eb ]---
>> [402750.884200] RIP: 0010:0xffff909bf61609d0
>> [402750.884598] Code: ff ff 00 00 00 00 52 01 00 00 00 7d 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <d0> 09 16 f6 9b 90 ff ff d0 09 16 f6 9b 90 ff ff c0 40 1f f2 9b 90
>> [402750.885822] RSP: 0000:ffffa18d41adbd28 EFLAGS: 00010202
>> [402750.886229] RAX: ffff909bf61609d0 RBX: ffff909bf6c3f800 RCX: dead000000000200
>> [402750.886651] RDX: ffff909bf74fa980 RSI: 0000000000000246 RDI: ffff909bf6160998
>> [402750.887065] RBP: ffff909bf74fa980 R08: 0000000000000000 R09: ffff909bf6c3f970
>> [402750.887478] R10: ffffa18d406a7cc0 R11: 0000000000000000 R12: ffff909bf6c3f9c0
>> [402750.887883] R13: ffff909bf74fa980 R14: ffffa18d41adbd40 R15: ffff909bf74fa100
>> [402750.888285] FS:  0000000000000000(0000) GS:ffff909bf9c00000(0000) knlGS:0000000000000000
>> [402750.888692] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [402750.889093] CR2: ffff909bf61609d0 CR3: 0000000136e56004 CR4: 00000000003606f0
>> [402750.889559] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [402750.889972] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [410772.901264] CIFS VFS: Send error in SessSetup = -126
>> [497165.194662] CIFS VFS: Send error in SessSetup = -126
>> [583557.492304] CIFS VFS: Send error in SessSetup = -126
>> [669948.937016] CIFS VFS: Send error in SessSetup = -126
>> [756341.390112] CIFS VFS: Send error in SessSetup = -126
>> [842733.557002] CIFS VFS: Send error in SessSetup = -126
>> [929125.303428] CIFS VFS: Send error in SessSetup = -126
>> [1015516.629380] CIFS VFS: Send error in SessSetup = -126
>> [1101908.464697] CIFS VFS: Send error in SessSetup = -126
>> [1188300.531261] CIFS VFS: Send error in SessSetup = -126
>> [1274692.583049] CIFS VFS: Send error in SessSetup = -126
>>
>>
>>>
>>> The individual stack dumps are pretty useful. Here is my theory:
>>>
>>>> pid: 9505
>>>> syscall: 4 0x56550a2ec470 0x7ffede42e9a0 0x7ffede42e9a0 0x83a 0x3 0x20
>>>> 0x7ffede42e8f8 0x7f7f8928f295
>>>> [<0>] open_shroot+0x43/0x200 [cifs]
>>>> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
>>>
>>> Almost all of the processes have the same stack trace. They are stuck at
>>> open_shroot()+0x43 which is probably
>>>
>>>       mutex_lock(&tcon->crfid.fid_mutex);
>>>
>>> Then there are only 2 other processes stuck somewhere in the same code path
>>> (open_shroot) but deeper, meaning they have the locks that the other
>>> processes are waiting for:
>>>
>>>
>>>> pid: 22858
>>>> syscall: 4 0x564b46285d10 0x7ffcea3f9a80 0x7ffcea3f9a80 0x83a 0x3 0x20
>>>> 0x7ffcea3f99d8 0x7f6cc78c7295
>>>> [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
>>>> [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
>>>> [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
>>>> [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
>>>> [<0>] SMB2_open+0x150/0x520 [cifs]
>>>> [<0>] open_shroot+0x12f/0x200 [cifs]
>>>> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
>>>> [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
>>>> [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
>>>> [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
>>>> [<0>] vfs_statx+0x89/0xe0
>>>> [<0>] __do_sys_newstat+0x39/0x70
>>>> [<0>] do_syscall_64+0x55/0x100
>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> [<0>] 0xffffffffffffffff
>>>
>>>
>>>> pid: 20027
>>>> syscall: 4 0x55a3c7d767d0 0x7ffe51432ab0 0x7ffe51432ab0 0x83a
>>>> 0x55a3c7d75c40 0x20 0x7ffe51432a08 0x7f5f7c4e7295
>>>> [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
>>>> [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
>>>> [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
>>>> [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
>>>> [<0>] SMB2_open+0x150/0x520 [cifs]
>>>> [<0>] open_shroot+0x12f/0x200 [cifs]
>>>> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
>>>> [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
>>>> [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
>>>> [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
>>>> [<0>] vfs_statx+0x89/0xe0
>>>> [<0>] __do_sys_newstat+0x39/0x70
>>>> [<0>] do_syscall_64+0x55/0x100
>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> [<0>] 0xffffffffffffffff
>>>
>>> Due to timeouts maybe the Open request needs
>>> to reconnect the server/ses/tcon and to do this it calls
>>> cifs_mark_open_files_invalid() and gets stuck somewhere there.
>>>
>>>           spin_lock(&tcon->open_file_lock);
>>>           list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
>>>                   open_file = list_entry(tmp, struct cifsFileInfo, tlist);
>>>                   open_file->invalidHandle = true;
>>>                   open_file->oplock_break_cancelled = true;
>>>           }
>>>           spin_unlock(&tcon->open_file_lock);
>>>
>>>           mutex_lock(&tcon->crfid.fid_mutex); <=== most likely here
>>>           tcon->crfid.is_valid = false;
>>>           memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
>>>           mutex_unlock(&tcon->crfid.fid_mutex);
>>>
>>> I think these processes are trying to lock the same lock twice: one in
>>> open_shroot() and since Open ends up having to reconnect, once again in
>>> mark_open_files_invalid(). I think it's the same lock because I don't
>>> see why the tcon pointers would be different in those 2 spots. Kernel
>>> mutexes are not reentrant so this is a deadlock.
>>
>> Is there anything we can do about this? Is this maybe already fixed in newer kernels?
>>
>> Regards, Martijn
>>
>>>
>>> Cheers,
>>>
>>
>> --
>> Martijn de Gouw
>> Designer
>> Prodrive Technologies
>> Mobile: +31 63 17 76 161
>> Phone:  +31 40 26 76 200

-- 
Martijn de Gouw
Designer
Prodrive Technologies
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200 
