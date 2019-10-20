Return-Path: <SRS0=pW6x=YN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A053CA9EA0
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Oct 2019 08:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 310DB218BA
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Oct 2019 08:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfJTINv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 20 Oct 2019 04:13:51 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:49256 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfJTINv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 20 Oct 2019 04:13:51 -0400
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 8311F32F0D_DAC1738B;
        Sun, 20 Oct 2019 08:13:44 +0000 (GMT)
Received: from mail.prodrive-technologies.com (exc04.bk.prodrive.nl [10.1.1.213])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "Prodrive Technologies B.V. OV SSL Issuing CA" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id BF443303CA_DAC1737F;
        Sun, 20 Oct 2019 08:13:43 +0000 (GMT)
Received: from [10.10.240.113] (10.1.249.1) by EXC04.bk.prodrive.nl
 (10.1.1.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1779.2; Sun, 20
 Oct 2019 10:13:43 +0200
Subject: Re: Kernel hangs in cifs_reconnect
To:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        <linux-cifs@vger.kernel.org>
References: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com>
 <871rveaurv.fsf@suse.com> <87a7a2ynxg.fsf@cjr.nz>
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Organization: Prodrive Technologies
Message-ID: <68a58b8e-3cab-093b-3098-6ee4a6dd3117@prodrive-technologies.com>
Date:   Sun, 20 Oct 2019 10:13:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <87a7a2ynxg.fsf@cjr.nz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EXC03.bk.prodrive.nl (10.1.1.212) To EXC04.bk.prodrive.nl
 (10.1.1.213)
X-SASI-RCODE: 200
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo,

On 15-10-2019 18:27, Paulo Alcantara wrote:
> Aurélien Aptel <aaptel@suse.com> writes:
> 
>> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
>>> Our Linux VMs reports call traces about processes being stuck.
>>> I've attached the full dmesg of one of the call traces below.
>>>
>>> The machine is running kernel 5.3.1 SMP. All mounts are mounted via the
>>> dfs shares on our domain controller and have the following options in fstab:
>>> nohandlecache,multiuser,sec=krb5,noperm,user=xxxx,file_mode=0600,dir_mode=0700,vers=3.0
>>
>> It looks like its DFS related. The DFS cache code takes the reconnect
>> mutex and crashes with no chance to give back the mutex, making all
>> other process hang while waiting for it.
> 
> Yeah, makes sense.
> 
> Martijn,
> 
> Could you please provide us with some debug logs with the following:
> 
> 	# echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> 	# echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> 	# echo 1 > /proc/fs/cifs/cifsFYI
> 	# echo 1 > /sys/module/dns_resolver/parameters/debug
> 
> Besides, if you could also enable KASAN, that would be great.

I recompiled the same kernel with KASAN enabled and have it run again for several days.
See below for the stackdump, I've added some of the messages before and after the event,
but if you need more information, please let me know.

[373004.186807] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 73254 with uid: 999
[373004.186883] fs/cifs/transport.c: Sending smb: smb_len=348
[373004.187349] fs/cifs/connect.c: RFC1002 header 0x1b8
[373004.187358] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[373004.187359] fs/cifs/smb2misc.c: SMB2 len 208
[373004.187370] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[373004.187371] fs/cifs/smb2misc.c: SMB2 len 104
[373004.187381] fs/cifs/smb2misc.c: SMB2 len 124
[373004.187383] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 759
[373004.187386] fs/cifs/smb2ops.c: add 30 credits total=7026
[373004.187401] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=757 state=4
[373004.187404] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=758 state=4
[373004.187405] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=759 state=4
[373004.187407] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373004.187414] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373004.187418] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373004.187451] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 73254) rc = 0
[373031.153835] fs/cifs/smb2pdu.c: In echo request
[373031.153853] fs/cifs/smb2pdu.c: Echo request failed: -11
[373031.153869] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373064.180943] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 73255 with uid: 999
[373064.181026] fs/cifs/transport.c: Sending smb: smb_len=348
[373064.181572] fs/cifs/connect.c: Received no data or error: -104
[373092.592054] fs/cifs/smb2pdu.c: In echo request
[373092.592067] fs/cifs/smb2pdu.c: Echo request failed: -11
[373092.592073] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373096.683689] INFO: task cifsd:789 blocked for more than 120 seconds.
[373096.684890]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373096.685859] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373096.686809] cifsd           D    0   789      2 0x80004000
[373096.686824] Call Trace:
[373096.686838]  ? __schedule+0x540/0xac0
[373096.686841]  ? firmware_map_remove+0xe9/0xe9
[373096.686850]  ? string_nocheck+0xb0/0xd0
[373096.686857]  ? _raw_spin_lock+0x7a/0xd0
[373096.686858]  schedule+0x5e/0x100
[373096.686861]  schedule_preempt_disabled+0xa/0x10
[373096.686863]  __mutex_lock.isra.4+0x484/0x820
[373096.686866]  ? mutex_trylock+0x90/0x90
[373096.686873]  ? irq_work_claim+0x2e/0x50
[373096.686875]  ? irq_work_queue+0x9/0x20
[373096.686878]  ? mutex_lock+0xce/0xe0
[373096.686879]  mutex_lock+0xce/0xe0
[373096.686881]  ? __mutex_lock_slowpath+0x10/0x10
[373096.686934]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373096.686975]  cifs_reconnect+0x16c/0x1360 [cifs]
[373096.687019]  ? smb2_calc_size+0x15c/0x250 [cifs]
[373096.687058]  ? extract_hostname+0xa0/0xa0 [cifs]
[373096.687060]  ? _raw_spin_trylock+0x91/0xe0
[373096.687062]  ? _raw_spin_trylock_bh+0x100/0x100
[373096.687064]  ? ___ratelimit+0x106/0x190
[373096.687104]  cifs_handle_standard+0x252/0x270 [cifs]
[373096.687144]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[373096.687184]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373096.687186]  ? __switch_to_asm+0x40/0x70
[373096.687188]  ? __switch_to_asm+0x34/0x70
[373096.687189]  ? __switch_to_asm+0x40/0x70
[373096.687191]  ? __switch_to_asm+0x34/0x70
[373096.687192]  ? __switch_to_asm+0x40/0x70
[373096.687194]  ? __switch_to_asm+0x34/0x70
[373096.687196]  ? __switch_to_asm+0x40/0x70
[373096.687197]  ? __switch_to_asm+0x34/0x70
[373096.687199]  ? __switch_to_asm+0x40/0x70
[373096.687200]  ? __switch_to_asm+0x34/0x70
[373096.687202]  ? __switch_to_asm+0x40/0x70
[373096.687203]  ? __switch_to_asm+0x34/0x70
[373096.687205]  ? __switch_to_asm+0x40/0x70
[373096.687206]  ? __switch_to_asm+0x34/0x70
[373096.687208]  ? __switch_to_asm+0x40/0x70
[373096.687209]  ? __switch_to_asm+0x34/0x70
[373096.687211]  ? __switch_to_asm+0x40/0x70
[373096.687212]  ? __switch_to_asm+0x34/0x70
[373096.687214]  ? __switch_to_asm+0x40/0x70
[373096.687215]  ? __switch_to_asm+0x34/0x70
[373096.687217]  ? __switch_to_asm+0x40/0x70
[373096.687218]  ? __switch_to_asm+0x34/0x70
[373096.687220]  ? __switch_to_asm+0x40/0x70
[373096.687221]  ? __switch_to_asm+0x34/0x70
[373096.687223]  ? __switch_to_asm+0x40/0x70
[373096.687224]  ? __switch_to_asm+0x34/0x70
[373096.687226]  ? __switch_to_asm+0x40/0x70
[373096.687232]  ? finish_task_switch+0x91/0x370
[373096.687234]  ? __switch_to+0x2ec/0x5e0
[373096.687237]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373096.687239]  ? _raw_write_lock_bh+0xe0/0xe0
[373096.687277]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373096.687280]  kthread+0x192/0x1e0
[373096.687282]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373096.687284]  ret_from_fork+0x35/0x40
[373096.687326] fs/cifs/smb2pdu.c: In echo request
[373096.687354] CIFS VFS: Error -32 sending data on socket to server
[373096.688357] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373096.688369] fs/cifs/smb2pdu.c: Echo request failed: -32
[373096.688375] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373149.926651] fs/cifs/connect.c: Existing tcp session with server found
[373149.926658] fs/cifs/dfs_cache.c: CIFS VFS: in do_refresh_tcon as Xid: 73256 with uid: 0
[373154.022274] fs/cifs/smb2pdu.c: In echo request
[373154.022290] fs/cifs/smb2pdu.c: Echo request failed: -11
[373154.022298] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373158.121876] fs/cifs/smb2pdu.c: In echo request
[373158.121904] CIFS VFS: Error -32 sending data on socket to server
[373158.123065] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373158.123079] fs/cifs/smb2pdu.c: Echo request failed: -32
[373158.123089] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373161.358480] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 73257 with uid: 11025
[373161.358496] fs/cifs/dir.c: name: \KAES6309
[373161.358500] fs/cifs/inode.c: Update attributes: \KAES6309 inode 0x00000000ae3f689c count 1 dentry: 0x00000000661f7ca9 d_time 4379115881 jiffies 4388191018
[373161.358503] fs/cifs/inode.c: Getting info on \KAES6309
[373161.358682] fs/cifs/transport.c: Sending smb: smb_len=388
[373215.456445] fs/cifs/smb2pdu.c: In echo request
[373215.456461] fs/cifs/smb2pdu.c: Echo request failed: -11
[373215.456467] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373217.504315] INFO: task cifsd:789 blocked for more than 241 seconds.
[373217.505647]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373217.506642] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373217.507653] cifsd           D    0   789      2 0x80004000
[373217.507657] Call Trace:
[373217.507664]  ? __schedule+0x540/0xac0
[373217.507667]  ? firmware_map_remove+0xe9/0xe9
[373217.507670]  ? string_nocheck+0xb0/0xd0
[373217.507676]  ? _raw_spin_lock+0x7a/0xd0
[373217.507677]  schedule+0x5e/0x100
[373217.507680]  schedule_preempt_disabled+0xa/0x10
[373217.507682]  __mutex_lock.isra.4+0x484/0x820
[373217.507685]  ? mutex_trylock+0x90/0x90
[373217.507688]  ? irq_work_claim+0x2e/0x50
[373217.507690]  ? irq_work_queue+0x9/0x20
[373217.507693]  ? mutex_lock+0xce/0xe0
[373217.507694]  mutex_lock+0xce/0xe0
[373217.507696]  ? __mutex_lock_slowpath+0x10/0x10
[373217.507750]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373217.507791]  cifs_reconnect+0x16c/0x1360 [cifs]
[373217.507834]  ? smb2_calc_size+0x15c/0x250 [cifs]
[373217.507873]  ? extract_hostname+0xa0/0xa0 [cifs]
[373217.507875]  ? _raw_spin_trylock+0x91/0xe0
[373217.507877]  ? _raw_spin_trylock_bh+0x100/0x100
[373217.507879]  ? ___ratelimit+0x106/0x190
[373217.507919]  cifs_handle_standard+0x252/0x270 [cifs]
[373217.507959]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[373217.507999]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373217.508001]  ? __switch_to_asm+0x40/0x70
[373217.508003]  ? __switch_to_asm+0x34/0x70
[373217.508004]  ? __switch_to_asm+0x40/0x70
[373217.508006]  ? __switch_to_asm+0x34/0x70
[373217.508008]  ? __switch_to_asm+0x40/0x70
[373217.508009]  ? __switch_to_asm+0x34/0x70
[373217.508011]  ? __switch_to_asm+0x40/0x70
[373217.508012]  ? __switch_to_asm+0x34/0x70
[373217.508014]  ? __switch_to_asm+0x40/0x70
[373217.508015]  ? __switch_to_asm+0x34/0x70
[373217.508017]  ? __switch_to_asm+0x40/0x70
[373217.508018]  ? __switch_to_asm+0x34/0x70
[373217.508020]  ? __switch_to_asm+0x40/0x70
[373217.508021]  ? __switch_to_asm+0x34/0x70
[373217.508023]  ? __switch_to_asm+0x40/0x70
[373217.508024]  ? __switch_to_asm+0x34/0x70
[373217.508026]  ? __switch_to_asm+0x40/0x70
[373217.508028]  ? __switch_to_asm+0x34/0x70
[373217.508029]  ? __switch_to_asm+0x40/0x70
[373217.508031]  ? __switch_to_asm+0x34/0x70
[373217.508032]  ? __switch_to_asm+0x40/0x70
[373217.508034]  ? __switch_to_asm+0x34/0x70
[373217.508035]  ? __switch_to_asm+0x40/0x70
[373217.508037]  ? __switch_to_asm+0x34/0x70
[373217.508038]  ? __switch_to_asm+0x40/0x70
[373217.508040]  ? __switch_to_asm+0x34/0x70
[373217.508041]  ? __switch_to_asm+0x40/0x70
[373217.508044]  ? finish_task_switch+0x91/0x370
[373217.508046]  ? __switch_to+0x2ec/0x5e0
[373217.508049]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373217.508050]  ? _raw_write_lock_bh+0xe0/0xe0
[373217.508090]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373217.508092]  kthread+0x192/0x1e0
[373217.508094]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373217.508096]  ret_from_fork+0x35/0x40
[373217.508118] INFO: task cifsd:16935 blocked for more than 120 seconds.
[373217.509148]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373217.510152] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373217.511174] cifsd           D    0 16935      2 0x80004000
[373217.511177] Call Trace:
[373217.511181]  ? __schedule+0x540/0xac0
[373217.511184]  ? firmware_map_remove+0xe9/0xe9
[373217.511187]  ? vsnprintf+0x870/0x870
[373217.511189]  ? _raw_spin_lock+0x7a/0xd0
[373217.511191]  schedule+0x5e/0x100
[373217.511193]  schedule_preempt_disabled+0xa/0x10
[373217.511194]  __mutex_lock.isra.4+0x484/0x820
[373217.511197]  ? mutex_trylock+0x90/0x90
[373217.511226]  ? up+0x32/0x70
[373217.511229]  ? irq_work_claim+0x2e/0x50
[373217.511231]  ? irq_work_queue+0x9/0x20
[373217.511234]  ? vprintk_emit+0x11d/0x2e0
[373217.511236]  ? mutex_lock+0xce/0xe0
[373217.511238]  mutex_lock+0xce/0xe0
[373217.511240]  ? __mutex_lock_slowpath+0x10/0x10
[373217.511290]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373217.511330]  cifs_reconnect+0x16c/0x1360 [cifs]
[373217.511371]  ? extract_hostname+0xa0/0xa0 [cifs]
[373217.511374]  ? _raw_spin_trylock+0x91/0xe0
[373217.511376]  ? _raw_spin_trylock_bh+0x100/0x100
[373217.511379]  ? aa_sk_perm+0xe4/0x1f0
[373217.511382]  ? inet_release+0xc0/0xc0
[373217.511384]  ? ___ratelimit+0x106/0x190
[373217.511423]  cifs_readv_from_socket+0x319/0x390 [cifs]
[373217.511463]  cifs_read_from_socket+0x9d/0xe0 [cifs]
[373217.511503]  ? cifs_readv_from_socket+0x390/0x390 [cifs]
[373217.511507]  ? refcount_sub_and_test_checked+0xae/0x140
[373217.511548]  ? cifs_small_buf_get+0x37/0x50 [cifs]
[373217.511588]  ? allocate_buffers+0x10a/0x170 [cifs]
[373217.511627]  cifs_demultiplex_thread+0x241/0x13e0 [cifs]
[373217.511667]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373217.511671]  ? sched_clock+0x5/0x10
[373217.511673]  ? __switch_to_asm+0x40/0x70
[373217.511675]  ? __switch_to_asm+0x34/0x70
[373217.511677]  ? __switch_to_asm+0x40/0x70
[373217.511678]  ? __switch_to_asm+0x34/0x70
[373217.511681]  ? __switch_to_asm+0x40/0x70
[373217.511683]  ? __switch_to_asm+0x34/0x70
[373217.511684]  ? __switch_to_asm+0x40/0x70
[373217.511686]  ? __switch_to_asm+0x34/0x70
[373217.511687]  ? __switch_to_asm+0x40/0x70
[373217.511689]  ? __switch_to_asm+0x34/0x70
[373217.511690]  ? __switch_to_asm+0x40/0x70
[373217.511692]  ? __switch_to_asm+0x34/0x70
[373217.511693]  ? __switch_to_asm+0x40/0x70
[373217.511695]  ? __switch_to_asm+0x34/0x70
[373217.511696]  ? __switch_to_asm+0x40/0x70
[373217.511698]  ? __switch_to_asm+0x34/0x70
[373217.511700]  ? __switch_to_asm+0x40/0x70
[373217.511701]  ? __switch_to_asm+0x34/0x70
[373217.511703]  ? __switch_to_asm+0x40/0x70
[373217.511704]  ? __switch_to_asm+0x34/0x70
[373217.511706]  ? __switch_to_asm+0x40/0x70
[373217.511707]  ? __switch_to_asm+0x34/0x70
[373217.511709]  ? __switch_to_asm+0x40/0x70
[373217.511710]  ? __switch_to_asm+0x34/0x70
[373217.511712]  ? __switch_to_asm+0x40/0x70
[373217.511713]  ? __switch_to_asm+0x34/0x70
[373217.511716]  ? finish_task_switch+0xf6/0x370
[373217.511717]  ? __switch_to+0x2ec/0x5e0
[373217.511720]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373217.511722]  ? _raw_write_lock_bh+0xe0/0xe0
[373217.511761]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373217.511763]  kthread+0x192/0x1e0
[373217.511766]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373217.511768]  ret_from_fork+0x35/0x40
[373219.552028] fs/cifs/smb2pdu.c: In echo request
[373219.552061] CIFS VFS: Error -32 sending data on socket to server
[373219.553244] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373219.553254] fs/cifs/smb2pdu.c: Echo request failed: -32
[373219.553261] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373276.894645] fs/cifs/smb2pdu.c: In echo request
[373276.894669] fs/cifs/smb2pdu.c: Echo request failed: -11
[373276.894675] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373280.986191] fs/cifs/smb2pdu.c: In echo request
[373280.986219] CIFS VFS: Error -32 sending data on socket to server
[373280.987409] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373280.987420] fs/cifs/smb2pdu.c: Echo request failed: -32
[373280.987426] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373338.324793] fs/cifs/smb2pdu.c: In echo request
[373338.324832] fs/cifs/smb2pdu.c: Echo request failed: -11
[373338.324838] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373338.324918] INFO: task cifsd:789 blocked for more than 362 seconds.
[373338.326236]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373338.327346] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373338.328455] cifsd           D    0   789      2 0x80004000
[373338.328458] Call Trace:
[373338.328465]  ? __schedule+0x540/0xac0
[373338.328468]  ? firmware_map_remove+0xe9/0xe9
[373338.328471]  ? string_nocheck+0xb0/0xd0
[373338.328475]  ? _raw_spin_lock+0x7a/0xd0
[373338.328477]  schedule+0x5e/0x100
[373338.328479]  schedule_preempt_disabled+0xa/0x10
[373338.328481]  __mutex_lock.isra.4+0x484/0x820
[373338.328484]  ? mutex_trylock+0x90/0x90
[373338.328488]  ? irq_work_claim+0x2e/0x50
[373338.328490]  ? irq_work_queue+0x9/0x20
[373338.328492]  ? mutex_lock+0xce/0xe0
[373338.328494]  mutex_lock+0xce/0xe0
[373338.328496]  ? __mutex_lock_slowpath+0x10/0x10
[373338.328547]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373338.328588]  cifs_reconnect+0x16c/0x1360 [cifs]
[373338.328631]  ? smb2_calc_size+0x15c/0x250 [cifs]
[373338.328670]  ? extract_hostname+0xa0/0xa0 [cifs]
[373338.328672]  ? _raw_spin_trylock+0x91/0xe0
[373338.328674]  ? _raw_spin_trylock_bh+0x100/0x100
[373338.328676]  ? ___ratelimit+0x106/0x190
[373338.328716]  cifs_handle_standard+0x252/0x270 [cifs]
[373338.328758]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[373338.328813]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373338.328818]  ? __switch_to_asm+0x40/0x70
[373338.328824]  ? __switch_to_asm+0x34/0x70
[373338.328828]  ? __switch_to_asm+0x40/0x70
[373338.328834]  ? __switch_to_asm+0x34/0x70
[373338.328840]  ? __switch_to_asm+0x40/0x70
[373338.328843]  ? __switch_to_asm+0x34/0x70
[373338.328849]  ? __switch_to_asm+0x40/0x70
[373338.328853]  ? __switch_to_asm+0x34/0x70
[373338.328859]  ? __switch_to_asm+0x40/0x70
[373338.328871]  ? __switch_to_asm+0x34/0x70
[373338.328873]  ? __switch_to_asm+0x40/0x70
[373338.328874]  ? __switch_to_asm+0x34/0x70
[373338.328876]  ? __switch_to_asm+0x40/0x70
[373338.328877]  ? __switch_to_asm+0x34/0x70
[373338.328879]  ? __switch_to_asm+0x40/0x70
[373338.328880]  ? __switch_to_asm+0x34/0x70
[373338.328882]  ? __switch_to_asm+0x40/0x70
[373338.328883]  ? __switch_to_asm+0x34/0x70
[373338.328885]  ? __switch_to_asm+0x40/0x70
[373338.328886]  ? __switch_to_asm+0x34/0x70
[373338.328888]  ? __switch_to_asm+0x40/0x70
[373338.328889]  ? __switch_to_asm+0x34/0x70
[373338.328891]  ? __switch_to_asm+0x40/0x70
[373338.328893]  ? __switch_to_asm+0x34/0x70
[373338.328894]  ? __switch_to_asm+0x40/0x70
[373338.328896]  ? __switch_to_asm+0x34/0x70
[373338.328897]  ? __switch_to_asm+0x40/0x70
[373338.328900]  ? finish_task_switch+0x91/0x370
[373338.328903]  ? __switch_to+0x2ec/0x5e0
[373338.328905]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373338.328907]  ? _raw_write_lock_bh+0xe0/0xe0
[373338.328947]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373338.328949]  kthread+0x192/0x1e0
[373338.328952]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373338.328954]  ret_from_fork+0x35/0x40
[373338.328975] INFO: task cifsd:16935 blocked for more than 241 seconds.
[373338.330061]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373338.331156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373338.332283] cifsd           D    0 16935      2 0x80004000
[373338.332286] Call Trace:
[373338.332296]  ? __schedule+0x540/0xac0
[373338.332298]  ? firmware_map_remove+0xe9/0xe9
[373338.332301]  ? vsnprintf+0x870/0x870
[373338.332304]  ? _raw_spin_lock+0x7a/0xd0
[373338.332306]  schedule+0x5e/0x100
[373338.332308]  schedule_preempt_disabled+0xa/0x10
[373338.332310]  __mutex_lock.isra.4+0x484/0x820
[373338.332312]  ? mutex_trylock+0x90/0x90
[373338.332315]  ? up+0x32/0x70
[373338.332319]  ? irq_work_claim+0x2e/0x50
[373338.332320]  ? irq_work_queue+0x9/0x20
[373338.332323]  ? vprintk_emit+0x11d/0x2e0
[373338.332325]  ? mutex_lock+0xce/0xe0
[373338.332326]  mutex_lock+0xce/0xe0
[373338.332328]  ? __mutex_lock_slowpath+0x10/0x10
[373338.332381]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373338.332421]  cifs_reconnect+0x16c/0x1360 [cifs]
[373338.332461]  ? extract_hostname+0xa0/0xa0 [cifs]
[373338.332463]  ? _raw_spin_trylock+0x91/0xe0
[373338.332465]  ? _raw_spin_trylock_bh+0x100/0x100
[373338.332467]  ? aa_sk_perm+0xe4/0x1f0
[373338.332470]  ? inet_release+0xc0/0xc0
[373338.332472]  ? ___ratelimit+0x106/0x190
[373338.332511]  cifs_readv_from_socket+0x319/0x390 [cifs]
[373338.332551]  cifs_read_from_socket+0x9d/0xe0 [cifs]
[373338.332590]  ? cifs_readv_from_socket+0x390/0x390 [cifs]
[373338.332594]  ? refcount_sub_and_test_checked+0xae/0x140
[373338.332635]  ? cifs_small_buf_get+0x37/0x50 [cifs]
[373338.332674]  ? allocate_buffers+0x10a/0x170 [cifs]
[373338.332713]  cifs_demultiplex_thread+0x241/0x13e0 [cifs]
[373338.332755]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373338.332774]  ? sched_clock+0x5/0x10
[373338.332776]  ? __switch_to_asm+0x40/0x70
[373338.332778]  ? __switch_to_asm+0x34/0x70
[373338.332779]  ? __switch_to_asm+0x40/0x70
[373338.332781]  ? __switch_to_asm+0x34/0x70
[373338.332782]  ? __switch_to_asm+0x40/0x70
[373338.332784]  ? __switch_to_asm+0x34/0x70
[373338.332786]  ? __switch_to_asm+0x40/0x70
[373338.332787]  ? __switch_to_asm+0x34/0x70
[373338.332791]  ? __switch_to_asm+0x40/0x70
[373338.332798]  ? __switch_to_asm+0x34/0x70
[373338.332802]  ? __switch_to_asm+0x40/0x70
[373338.332808]  ? __switch_to_asm+0x34/0x70
[373338.332810]  ? __switch_to_asm+0x40/0x70
[373338.332813]  ? __switch_to_asm+0x34/0x70
[373338.332822]  ? __switch_to_asm+0x40/0x70
[373338.332828]  ? __switch_to_asm+0x34/0x70
[373338.332830]  ? __switch_to_asm+0x40/0x70
[373338.332834]  ? __switch_to_asm+0x34/0x70
[373338.332840]  ? __switch_to_asm+0x40/0x70
[373338.332856]  ? __switch_to_asm+0x34/0x70
[373338.332858]  ? __switch_to_asm+0x40/0x70
[373338.332859]  ? __switch_to_asm+0x34/0x70
[373338.332861]  ? __switch_to_asm+0x40/0x70
[373338.332862]  ? __switch_to_asm+0x34/0x70
[373338.332864]  ? __switch_to_asm+0x40/0x70
[373338.332865]  ? __switch_to_asm+0x34/0x70
[373338.332868]  ? finish_task_switch+0xf6/0x370
[373338.332870]  ? __switch_to+0x2ec/0x5e0
[373338.332872]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373338.332874]  ? _raw_write_lock_bh+0xe0/0xe0
[373338.332913]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373338.332923]  kthread+0x192/0x1e0
[373338.332927]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373338.332930]  ret_from_fork+0x35/0x40
[373338.332958] INFO: task kworker/2:1:31242 blocked for more than 120 seconds.
[373338.334112]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373338.335285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373338.336617] kworker/2:1     D    0 31242      2 0x80004000
[373338.336700] Workqueue: cifsiod refresh_cache_worker [cifs]
[373338.336702] Call Trace:
[373338.336709]  ? __schedule+0x540/0xac0
[373338.336714]  ? firmware_map_remove+0xe9/0xe9
[373338.336717]  ? _raw_read_lock_irq+0x40/0x40
[373338.336721]  schedule+0x5e/0x100
[373338.336725]  schedule_preempt_disabled+0xa/0x10
[373338.336728]  __mutex_lock.isra.4+0x484/0x820
[373338.336733]  ? mutex_trylock+0x90/0x90
[373338.336737]  ? dynamic_emit_prefix+0x29/0x220
[373338.336740]  ? __dynamic_pr_debug+0xf8/0x140
[373338.336744]  ? dynamic_emit_prefix+0x220/0x220
[373338.336770]  ? mutex_lock+0xce/0xe0
[373338.336773]  mutex_lock+0xce/0xe0
[373338.336777]  ? __mutex_lock_slowpath+0x10/0x10
[373338.336856]  refresh_cache_worker+0x48f/0x14a0 [cifs]
[373338.336864]  ? __switch_to_asm+0x40/0x70
[373338.336875]  ? __switch_to_asm+0x40/0x70
[373338.336883]  ? __switch_to_asm+0x34/0x70
[373338.336885]  ? __switch_to_asm+0x40/0x70
[373338.336888]  ? __switch_to_asm+0x34/0x70
[373338.336891]  ? __switch_to_asm+0x40/0x70
[373338.336964]  ? find_root_ses.isra.9+0x320/0x320 [cifs]
[373338.336968]  ? __switch_to_asm+0x40/0x70
[373338.336976]  ? __switch_to_asm+0x40/0x70
[373338.336979]  ? __switch_to_asm+0x34/0x70
[373338.336981]  ? __switch_to_asm+0x40/0x70
[373338.336984]  ? __switch_to_asm+0x34/0x70
[373338.336991]  ? __switch_to_asm+0x40/0x70
[373338.336994]  ? __switch_to_asm+0x34/0x70
[373338.336998]  ? __switch_to_asm+0x40/0x70
[373338.337004]  ? __switch_to_asm+0x40/0x70
[373338.337007]  ? __switch_to_asm+0x34/0x70
[373338.337010]  ? finish_task_switch+0xf6/0x370
[373338.337016]  ? __switch_to+0x2ec/0x5e0
[373338.337019]  ? __schedule+0x562/0xac0
[373338.337023]  ? read_word_at_a_time+0xe/0x20
[373338.337028]  ? strscpy+0xca/0x1d0
[373338.337034]  process_one_work+0x373/0x6e0
[373338.337040]  worker_thread+0x78/0x5b0
[373338.337047]  ? rescuer_thread+0x5e0/0x5e0
[373338.337050]  kthread+0x192/0x1e0
[373338.337054]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373338.337058]  ret_from_fork+0x35/0x40
[373342.420422] fs/cifs/smb2pdu.c: In echo request
[373342.420455] CIFS VFS: Error -32 sending data on socket to server
[373342.421797] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373342.421809] fs/cifs/smb2pdu.c: Echo request failed: -32
[373342.421816] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373399.758993] fs/cifs/smb2pdu.c: In echo request
[373399.759010] fs/cifs/smb2pdu.c: Echo request failed: -11
[373399.759017] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373403.854642] fs/cifs/smb2pdu.c: In echo request
[373403.854666] CIFS VFS: Error -32 sending data on socket to server
[373403.856180] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373403.856195] fs/cifs/smb2pdu.c: Echo request failed: -32
[373403.856202] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373459.145452] INFO: task cifsd:789 blocked for more than 483 seconds.
[373459.147021]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373459.148332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373459.149648] cifsd           D    0   789      2 0x80004000
[373459.149657] Call Trace:
[373459.149682]  ? __schedule+0x540/0xac0
[373459.149687]  ? firmware_map_remove+0xe9/0xe9
[373459.149690]  ? string_nocheck+0xb0/0xd0
[373459.149694]  ? _raw_spin_lock+0x7a/0xd0
[373459.149698]  schedule+0x5e/0x100
[373459.149700]  schedule_preempt_disabled+0xa/0x10
[373459.149703]  __mutex_lock.isra.4+0x484/0x820
[373459.149706]  ? mutex_trylock+0x90/0x90
[373459.149714]  ? irq_work_claim+0x2e/0x50
[373459.149716]  ? irq_work_queue+0x9/0x20
[373459.149719]  ? mutex_lock+0xce/0xe0
[373459.149720]  mutex_lock+0xce/0xe0
[373459.149722]  ? __mutex_lock_slowpath+0x10/0x10
[373459.149775]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373459.149818]  cifs_reconnect+0x16c/0x1360 [cifs]
[373459.149870]  ? smb2_calc_size+0x15c/0x250 [cifs]
[373459.149909]  ? extract_hostname+0xa0/0xa0 [cifs]
[373459.149911]  ? _raw_spin_trylock+0x91/0xe0
[373459.149913]  ? _raw_spin_trylock_bh+0x100/0x100
[373459.149915]  ? ___ratelimit+0x106/0x190
[373459.149960]  cifs_handle_standard+0x252/0x270 [cifs]
[373459.150001]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[373459.150041]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373459.150043]  ? __switch_to_asm+0x40/0x70
[373459.150045]  ? __switch_to_asm+0x34/0x70
[373459.150047]  ? __switch_to_asm+0x40/0x70
[373459.150050]  ? __switch_to_asm+0x34/0x70
[373459.150051]  ? __switch_to_asm+0x40/0x70
[373459.150053]  ? __switch_to_asm+0x34/0x70
[373459.150055]  ? __switch_to_asm+0x40/0x70
[373459.150058]  ? __switch_to_asm+0x34/0x70
[373459.150061]  ? __switch_to_asm+0x40/0x70
[373459.150063]  ? __switch_to_asm+0x34/0x70
[373459.150066]  ? __switch_to_asm+0x40/0x70
[373459.150068]  ? __switch_to_asm+0x34/0x70
[373459.150070]  ? __switch_to_asm+0x40/0x70
[373459.150072]  ? __switch_to_asm+0x34/0x70
[373459.150074]  ? __switch_to_asm+0x40/0x70
[373459.150077]  ? __switch_to_asm+0x34/0x70
[373459.150078]  ? __switch_to_asm+0x40/0x70
[373459.150080]  ? __switch_to_asm+0x34/0x70
[373459.150081]  ? __switch_to_asm+0x40/0x70
[373459.150083]  ? __switch_to_asm+0x34/0x70
[373459.150084]  ? __switch_to_asm+0x40/0x70
[373459.150086]  ? __switch_to_asm+0x34/0x70
[373459.150087]  ? __switch_to_asm+0x40/0x70
[373459.150089]  ? __switch_to_asm+0x34/0x70
[373459.150090]  ? __switch_to_asm+0x40/0x70
[373459.150092]  ? __switch_to_asm+0x34/0x70
[373459.150093]  ? __switch_to_asm+0x40/0x70
[373459.150102]  ? finish_task_switch+0x91/0x370
[373459.150104]  ? __switch_to+0x2ec/0x5e0
[373459.150106]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373459.150108]  ? _raw_write_lock_bh+0xe0/0xe0
[373459.150149]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373459.150152]  kthread+0x192/0x1e0
[373459.150154]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373459.150156]  ret_from_fork+0x35/0x40
[373459.150175] INFO: task cifsd:16935 blocked for more than 362 seconds.
[373459.151549]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373459.152979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373459.154378] cifsd           D    0 16935      2 0x80004000
[373459.154381] Call Trace:
[373459.154387]  ? __schedule+0x540/0xac0
[373459.154483]  ? firmware_map_remove+0xe9/0xe9
[373459.154487]  ? vsnprintf+0x870/0x870
[373459.154491]  ? _raw_spin_lock+0x7a/0xd0
[373459.154494]  schedule+0x5e/0x100
[373459.154497]  schedule_preempt_disabled+0xa/0x10
[373459.154499]  __mutex_lock.isra.4+0x484/0x820
[373459.154502]  ? mutex_trylock+0x90/0x90
[373459.154511]  ? up+0x32/0x70
[373459.154514]  ? irq_work_claim+0x2e/0x50
[373459.154515]  ? irq_work_queue+0x9/0x20
[373459.154518]  ? vprintk_emit+0x11d/0x2e0
[373459.154520]  ? mutex_lock+0xce/0xe0
[373459.154521]  mutex_lock+0xce/0xe0
[373459.154524]  ? __mutex_lock_slowpath+0x10/0x10
[373459.154576]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373459.154616]  cifs_reconnect+0x16c/0x1360 [cifs]
[373459.154658]  ? extract_hostname+0xa0/0xa0 [cifs]
[373459.154661]  ? _raw_spin_trylock+0x91/0xe0
[373459.154663]  ? _raw_spin_trylock_bh+0x100/0x100
[373459.154671]  ? aa_sk_perm+0xe4/0x1f0
[373459.154677]  ? inet_release+0xc0/0xc0
[373459.154679]  ? ___ratelimit+0x106/0x190
[373459.154717]  cifs_readv_from_socket+0x319/0x390 [cifs]
[373459.154757]  cifs_read_from_socket+0x9d/0xe0 [cifs]
[373459.154796]  ? cifs_readv_from_socket+0x390/0x390 [cifs]
[373459.154799]  ? refcount_sub_and_test_checked+0xae/0x140
[373459.154840]  ? cifs_small_buf_get+0x37/0x50 [cifs]
[373459.154881]  ? allocate_buffers+0x10a/0x170 [cifs]
[373459.154920]  cifs_demultiplex_thread+0x241/0x13e0 [cifs]
[373459.154960]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373459.154963]  ? sched_clock+0x5/0x10
[373459.154965]  ? __switch_to_asm+0x40/0x70
[373459.154966]  ? __switch_to_asm+0x34/0x70
[373459.154969]  ? __switch_to_asm+0x40/0x70
[373459.154971]  ? __switch_to_asm+0x34/0x70
[373459.154972]  ? __switch_to_asm+0x40/0x70
[373459.154974]  ? __switch_to_asm+0x34/0x70
[373459.154975]  ? __switch_to_asm+0x40/0x70
[373459.154977]  ? __switch_to_asm+0x34/0x70
[373459.154978]  ? __switch_to_asm+0x40/0x70
[373459.154980]  ? __switch_to_asm+0x34/0x70
[373459.154981]  ? __switch_to_asm+0x40/0x70
[373459.154983]  ? __switch_to_asm+0x34/0x70
[373459.154984]  ? __switch_to_asm+0x40/0x70
[373459.154986]  ? __switch_to_asm+0x34/0x70
[373459.154988]  ? __switch_to_asm+0x40/0x70
[373459.154989]  ? __switch_to_asm+0x34/0x70
[373459.154991]  ? __switch_to_asm+0x40/0x70
[373459.154992]  ? __switch_to_asm+0x34/0x70
[373459.154994]  ? __switch_to_asm+0x40/0x70
[373459.154995]  ? __switch_to_asm+0x34/0x70
[373459.154997]  ? __switch_to_asm+0x40/0x70
[373459.154998]  ? __switch_to_asm+0x34/0x70
[373459.155000]  ? __switch_to_asm+0x40/0x70
[373459.155001]  ? __switch_to_asm+0x34/0x70
[373459.155003]  ? __switch_to_asm+0x40/0x70
[373459.155005]  ? __switch_to_asm+0x34/0x70
[373459.155007]  ? finish_task_switch+0xf6/0x370
[373459.155010]  ? __switch_to+0x2ec/0x5e0
[373459.155013]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373459.155014]  ? _raw_write_lock_bh+0xe0/0xe0
[373459.155054]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373459.155056]  kthread+0x192/0x1e0
[373459.155059]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373459.155061]  ret_from_fork+0x35/0x40
[373459.155082] INFO: task kworker/2:1:31242 blocked for more than 241 seconds.
[373459.156633]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373459.158106] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373459.159698] kworker/2:1     D    0 31242      2 0x80004000
[373459.159755] Workqueue: cifsiod refresh_cache_worker [cifs]
[373459.159757] Call Trace:
[373459.159763]  ? __schedule+0x540/0xac0
[373459.159765]  ? firmware_map_remove+0xe9/0xe9
[373459.159768]  ? _raw_read_lock_irq+0x40/0x40
[373459.159770]  schedule+0x5e/0x100
[373459.159772]  schedule_preempt_disabled+0xa/0x10
[373459.159774]  __mutex_lock.isra.4+0x484/0x820
[373459.159777]  ? mutex_trylock+0x90/0x90
[373459.159780]  ? dynamic_emit_prefix+0x29/0x220
[373459.159782]  ? __dynamic_pr_debug+0xf8/0x140
[373459.159783]  ? dynamic_emit_prefix+0x220/0x220
[373459.159786]  ? mutex_lock+0xce/0xe0
[373459.159787]  mutex_lock+0xce/0xe0
[373459.159790]  ? __mutex_lock_slowpath+0x10/0x10
[373459.159833]  refresh_cache_worker+0x48f/0x14a0 [cifs]
[373459.159836]  ? __switch_to_asm+0x40/0x70
[373459.159838]  ? __switch_to_asm+0x40/0x70
[373459.159840]  ? __switch_to_asm+0x34/0x70
[373459.159842]  ? __switch_to_asm+0x40/0x70
[373459.159844]  ? __switch_to_asm+0x34/0x70
[373459.159846]  ? __switch_to_asm+0x40/0x70
[373459.159888]  ? find_root_ses.isra.9+0x320/0x320 [cifs]
[373459.159890]  ? __switch_to_asm+0x40/0x70
[373459.159891]  ? __switch_to_asm+0x40/0x70
[373459.159893]  ? __switch_to_asm+0x34/0x70
[373459.159895]  ? __switch_to_asm+0x40/0x70
[373459.159896]  ? __switch_to_asm+0x34/0x70
[373459.159898]  ? __switch_to_asm+0x40/0x70
[373459.159899]  ? __switch_to_asm+0x34/0x70
[373459.159901]  ? __switch_to_asm+0x40/0x70
[373459.159902]  ? __switch_to_asm+0x40/0x70
[373459.159904]  ? __switch_to_asm+0x34/0x70
[373459.159907]  ? finish_task_switch+0xf6/0x370
[373459.159909]  ? __switch_to+0x2ec/0x5e0
[373459.159911]  ? __schedule+0x562/0xac0
[373459.159915]  ? read_word_at_a_time+0xe/0x20
[373459.159916]  ? strscpy+0xca/0x1d0
[373459.159921]  process_one_work+0x373/0x6e0
[373459.159924]  worker_thread+0x78/0x5b0
[373459.159927]  ? rescuer_thread+0x5e0/0x5e0
[373459.159929]  kthread+0x192/0x1e0
[373459.159931]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373459.159933]  ret_from_fork+0x35/0x40
[373460.878890] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 73258 with uid: 11025
[373460.878909] fs/cifs/dir.c: name: \KAES6309
[373460.878913] fs/cifs/inode.c: Update attributes: \KAES6309 inode 0x00000000ae3f689c count 1 dentry: 0x00000000661f7ca9 d_time 4379115881 jiffies 4388265905
[373460.878916] fs/cifs/inode.c: Getting info on \KAES6309
[373460.879081] fs/cifs/transport.c: Sending smb: smb_len=388
[373461.193169] fs/cifs/smb2pdu.c: In echo request
[373461.193186] fs/cifs/smb2pdu.c: Echo request failed: -11
[373461.193192] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373465.288778] fs/cifs/smb2pdu.c: In echo request
[373465.288811] CIFS VFS: Error -32 sending data on socket to server
[373465.290238] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373465.290249] fs/cifs/smb2pdu.c: Echo request failed: -32
[373465.290256] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373522.627361] fs/cifs/smb2pdu.c: In echo request
[373522.627379] fs/cifs/smb2pdu.c: Echo request failed: -11
[373522.627386] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373526.722979] fs/cifs/smb2pdu.c: In echo request
[373526.723013] CIFS VFS: Error -32 sending data on socket to server
[373526.724550] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373526.724562] fs/cifs/smb2pdu.c: Echo request failed: -32
[373526.724568] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373579.965997] INFO: task cifsd:789 blocked for more than 604 seconds.
[373579.967521]       Tainted: G            E     5.3.1-pd-5.3.y #20191015
[373579.968896] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[373579.970287] cifsd           D    0   789      2 0x80004000
[373579.970291] Call Trace:
[373579.970321]  ? __schedule+0x540/0xac0
[373579.970324]  ? firmware_map_remove+0xe9/0xe9
[373579.970327]  ? string_nocheck+0xb0/0xd0
[373579.970334]  ? _raw_spin_lock+0x7a/0xd0
[373579.970336]  schedule+0x5e/0x100
[373579.970338]  schedule_preempt_disabled+0xa/0x10
[373579.970340]  __mutex_lock.isra.4+0x484/0x820
[373579.970343]  ? mutex_trylock+0x90/0x90
[373579.970357]  ? irq_work_claim+0x2e/0x50
[373579.970359]  ? irq_work_queue+0x9/0x20
[373579.970362]  ? mutex_lock+0xce/0xe0
[373579.970363]  mutex_lock+0xce/0xe0
[373579.970365]  ? __mutex_lock_slowpath+0x10/0x10
[373579.970418]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[373579.970459]  cifs_reconnect+0x16c/0x1360 [cifs]
[373579.970503]  ? smb2_calc_size+0x15c/0x250 [cifs]
[373579.970542]  ? extract_hostname+0xa0/0xa0 [cifs]
[373579.970544]  ? _raw_spin_trylock+0x91/0xe0
[373579.970546]  ? _raw_spin_trylock_bh+0x100/0x100
[373579.970548]  ? ___ratelimit+0x106/0x190
[373579.970588]  cifs_handle_standard+0x252/0x270 [cifs]
[373579.970628]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[373579.970672]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373579.970674]  ? __switch_to_asm+0x40/0x70
[373579.970675]  ? __switch_to_asm+0x34/0x70
[373579.970677]  ? __switch_to_asm+0x40/0x70
[373579.970678]  ? __switch_to_asm+0x34/0x70
[373579.970680]  ? __switch_to_asm+0x40/0x70
[373579.970681]  ? __switch_to_asm+0x34/0x70
[373579.970683]  ? __switch_to_asm+0x40/0x70
[373579.970684]  ? __switch_to_asm+0x34/0x70
[373579.970686]  ? __switch_to_asm+0x40/0x70
[373579.970687]  ? __switch_to_asm+0x34/0x70
[373579.970689]  ? __switch_to_asm+0x40/0x70
[373579.970690]  ? __switch_to_asm+0x34/0x70
[373579.970692]  ? __switch_to_asm+0x40/0x70
[373579.970693]  ? __switch_to_asm+0x34/0x70
[373579.970695]  ? __switch_to_asm+0x40/0x70
[373579.970697]  ? __switch_to_asm+0x34/0x70
[373579.970698]  ? __switch_to_asm+0x40/0x70
[373579.970700]  ? __switch_to_asm+0x34/0x70
[373579.970701]  ? __switch_to_asm+0x40/0x70
[373579.970703]  ? __switch_to_asm+0x34/0x70
[373579.970704]  ? __switch_to_asm+0x40/0x70
[373579.970706]  ? __switch_to_asm+0x34/0x70
[373579.970707]  ? __switch_to_asm+0x40/0x70
[373579.970709]  ? __switch_to_asm+0x34/0x70
[373579.970710]  ? __switch_to_asm+0x40/0x70
[373579.970712]  ? __switch_to_asm+0x34/0x70
[373579.970713]  ? __switch_to_asm+0x40/0x70
[373579.970724]  ? finish_task_switch+0x91/0x370
[373579.970732]  ? __switch_to+0x2ec/0x5e0
[373579.970735]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[373579.970736]  ? _raw_write_lock_bh+0xe0/0xe0
[373579.970775]  ? cifs_handle_standard+0x270/0x270 [cifs]
[373579.970780]  kthread+0x192/0x1e0
[373579.970782]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[373579.970786]  ret_from_fork+0x35/0x40
[373584.061557] fs/cifs/smb2pdu.c: In echo request
[373584.061573] fs/cifs/smb2pdu.c: Echo request failed: -11
[373584.061578] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373588.157191] fs/cifs/smb2pdu.c: In echo request
[373588.157233] CIFS VFS: Error -32 sending data on socket to server
[373588.158699] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[373588.158710] fs/cifs/smb2pdu.c: Echo request failed: -32
[373588.158718] fs/cifs/connect.c: Unable to send echo request to server: stor02.bk.prodrive.nl
[373645.495852] fs/cifs/smb2pdu.c: In echo request
[373645.495870] fs/cifs/smb2pdu.c: Echo request failed: -11
[373645.495876] fs/cifs/connect.c: Unable to send echo request to server: DC02
[373649.591382] fs/cifs/smb2pdu.c: In echo request
 
The last part repeated over and over again in the log.

Gr, Martijn de Gouw
-- 
Martijn de Gouw
Designer
Prodrive Technologies
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200 
