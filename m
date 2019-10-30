Return-Path: <SRS0=jcY3=YX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7150CA9EC5
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 19:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73C2B204FD
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 19:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfJ3TRd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Oct 2019 15:17:33 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:54077 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbfJ3TRd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 30 Oct 2019 15:17:33 -0400
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 9FBED32F53_DB9E1C6B;
        Wed, 30 Oct 2019 19:17:26 +0000 (GMT)
Received: from mail.prodrive-technologies.com (exc04.bk.prodrive.nl [10.1.1.213])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "Prodrive Technologies B.V. OV SSL Issuing CA" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id 4842530E89_DB9E1C6F;
        Wed, 30 Oct 2019 19:17:26 +0000 (GMT)
Received: from [10.10.240.93] (10.1.249.1) by EXC04.bk.prodrive.nl
 (10.1.1.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1779.2; Wed, 30
 Oct 2019 20:17:25 +0100
Subject: Re: Kernel hangs in cifs_reconnect
To:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        <linux-cifs@vger.kernel.org>
References: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com>
 <871rveaurv.fsf@suse.com> <87a7a2ynxg.fsf@cjr.nz>
 <68a58b8e-3cab-093b-3098-6ee4a6dd3117@prodrive-technologies.com>
 <9c5eeb76-7895-5938-355f-f5d43c5affe5@prodrive-technologies.com>
 <87pnif4nfd.fsf@cjr.nz>
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Organization: Prodrive Technologies
Message-ID: <7d19b448-1342-fd50-55ee-d2a46da6d431@prodrive-technologies.com>
Date:   Wed, 30 Oct 2019 20:17:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87pnif4nfd.fsf@cjr.nz>
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

Hi Paulo,

On 29-10-2019 15:49, Paulo Alcantara wrote:
> Hi Martijn,
> 
> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> 
>> Anybody any idea on what goes wrong here?
> 
> Looks like an use-after-free bug in cifs_reconnect(). cifs superblock
> gets freed due to automount expiration and then we dereference it in
> dfs_cache_noreq_find().
> 
>> Is any of the recently posted patches related to my issue, because I'm
>> more that willing to test out patches if needed.
> 
> Could you please test it again with below patch?

Again cifs stopped working, it looks more like a live/dead lock to me than a use-after-free.
I cut the dmesg from the moment the echo to DC02 starts failing.

[70939.980125] fs/cifs/smb2pdu.c: In echo request
[70939.980137] fs/cifs/smb2pdu.c: Echo request failed: -11
[70939.980143] fs/cifs/connect.c: Unable to send echo request to server: DC02
[70960.106599] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13353 with uid: 999
[70960.106697] fs/cifs/transport.c: Sending smb: smb_len=372
[70960.116162] fs/cifs/connect.c: RFC1002 header 0x1b8
[70960.116170] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[70960.116171] fs/cifs/smb2misc.c: SMB2 len 208
[70960.116185] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[70960.116186] fs/cifs/smb2misc.c: SMB2 len 104
[70960.116196] fs/cifs/smb2misc.c: SMB2 len 124
[70960.116197] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4066
[70960.116200] fs/cifs/smb2ops.c: add 3 credits total=512
[70960.116218] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4064 state=4
[70960.116227] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4065 state=4
[70960.116230] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4066 state=4
[70960.116234] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[70960.116242] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[70960.116247] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[70960.116290] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13353) rc = 0
[70960.116319] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13354 with uid: 999
[70960.116429] fs/cifs/transport.c: Sending smb: smb_len=348
[70960.116829] fs/cifs/connect.c: RFC1002 header 0x1b8
[70960.116834] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[70960.116835] fs/cifs/smb2misc.c: SMB2 len 208
[70960.116842] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[70960.116843] fs/cifs/smb2misc.c: SMB2 len 104
[70960.116856] fs/cifs/smb2misc.c: SMB2 len 124
[70960.116857] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 74
[70960.116859] fs/cifs/smb2ops.c: add 30 credits total=897
[70960.116872] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=72 state=4
[70960.116874] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=73 state=4
[70960.116876] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=74 state=4
[70960.116877] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[70960.116882] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[70960.116887] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[70960.116954] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13354) rc = 0
[71001.418549] fs/cifs/smb2pdu.c: In echo request
[71001.418565] fs/cifs/smb2pdu.c: Echo request failed: -11
[71001.418570] fs/cifs/connect.c: Unable to send echo request to server: DC02
[71020.097059] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13355 with uid: 999
[71020.097165] fs/cifs/transport.c: Sending smb: smb_len=372
[71020.097760] fs/cifs/connect.c: RFC1002 header 0x1b8
[71020.097767] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71020.097768] fs/cifs/smb2misc.c: SMB2 len 208
[71020.097777] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71020.097778] fs/cifs/smb2misc.c: SMB2 len 104
[71020.097788] fs/cifs/smb2misc.c: SMB2 len 124
[71020.097789] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4069
[71020.097796] fs/cifs/smb2ops.c: add 3 credits total=512
[71020.098387] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4067 state=4
[71020.098395] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4068 state=4
[71020.098398] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4069 state=4
[71020.098405] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71020.098414] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71020.098419] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71020.098461] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13355) rc = 0
[71020.098488] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13356 with uid: 999
[71020.098556] fs/cifs/transport.c: Sending smb: smb_len=348
[71020.098915] fs/cifs/connect.c: RFC1002 header 0x1b8
[71020.098921] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71020.098922] fs/cifs/smb2misc.c: SMB2 len 208
[71020.098932] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71020.098932] fs/cifs/smb2misc.c: SMB2 len 104
[71020.098942] fs/cifs/smb2misc.c: SMB2 len 124
[71020.098944] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 77
[71020.098946] fs/cifs/smb2ops.c: add 30 credits total=924
[71020.098956] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=75 state=4
[71020.098958] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=76 state=4
[71020.098959] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=77 state=4
[71020.098961] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71020.098968] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71020.098973] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71020.099011] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13356) rc = 0
[71044.418723] INFO: task node_exporter:7214 blocked for more than 120 seconds.
[71044.420037]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71044.421491] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71044.422762] node_exporter   D    0  7214      1 0x00000000
[71044.422781] Call Trace:
[71044.422806]  ? __schedule+0x540/0xac0
[71044.422813]  ? firmware_map_remove+0xe9/0xe9
[71044.422821]  ? vsnprintf+0x32c/0x870
[71044.422826]  ? _raw_spin_lock+0x7a/0xd0
[71044.422829]  schedule+0x5e/0x100
[71044.422837]  schedule_preempt_disabled+0xa/0x10
[71044.422840]  __mutex_lock.isra.4+0x484/0x820
[71044.422844]  ? mutex_trylock+0x90/0x90
[71044.422848]  ? string_nocheck+0xb0/0xd0
[71044.422854]  ? pointer+0x387/0x460
[71044.422859]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71044.422863]  ? _raw_write_lock_bh+0xe0/0xe0
[71044.422868]  ? mutex_lock+0xce/0xe0
[71044.422871]  mutex_lock+0xce/0xe0
[71044.422875]  ? __mutex_lock_slowpath+0x10/0x10
[71044.422892]  ? find_nls+0x7d/0xa0
[71044.422976]  smb2_reconnect.part.21+0x218/0xbd0 [cifs]
[71044.422992]  ? deref_stack_reg+0x88/0xd0
[71044.422995]  ? 0xffffffffa1e00000
[71044.423065]  ? SMB2_tcon+0xab0/0xab0 [cifs]
[71044.423067]  ? unwind_next_frame+0x90a/0x980
[71044.423070]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71044.423081]  ? __module_text_address+0x11/0xa0
[71044.423087]  ? __is_insn_slot_addr+0x1b/0x70
[71044.423094]  ? is_bpf_text_address+0xa/0x20
[71044.423101]  ? kernel_text_address+0xe2/0xf0
[71044.423104]  ? __kernel_text_address+0xe/0x30
[71044.423108]  ? unwind_get_return_address+0x2f/0x50
[71044.423114]  ? create_prof_cpu_mask+0x20/0x20
[71044.423120]  ? arch_stack_walk+0x92/0xe0
[71044.423125]  ? stack_trace_save+0x8a/0xb0
[71044.423195]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
[71044.423272]  SMB2_open_init+0x143/0x12b0 [cifs]
[71044.423339]  ? cifs_statfs+0x13a/0x420 [cifs]
[71044.423352]  ? statfs_by_dentry+0xa5/0xf0
[71044.423354]  ? vfs_statfs+0x28/0x110
[71044.423357]  ? __do_sys_statfs+0x64/0xc0
[71044.423413]  ? smb2_parse_contexts+0x270/0x270 [cifs]
[71044.423416]  ? _raw_write_trylock+0xe0/0xe0
[71044.423419]  ? _raw_spin_lock+0x7a/0xd0
[71044.423421]  ? _raw_write_trylock+0xe0/0xe0
[71044.423429]  ? memset+0x1f/0x40
[71044.423433]  ? stack_access_ok+0x35/0x90
[71044.423437]  ? deref_stack_reg+0x88/0xd0
[71044.423439]  ? stack_access_ok+0x35/0x90
[71044.423442]  ? deref_stack_reg+0x88/0xd0
[71044.423446]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[71044.423450]  ? put_dec_trunc8+0x73/0x110
[71044.423453]  ? number+0x356/0x4b0
[71044.423456]  ? widen_string+0x23/0xf0
[71044.423517]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
[71044.423558]  smb2_query_info_compound+0x242/0x4d0 [cifs]
[71044.423601]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
[71044.423604]  ? pointer+0x460/0x460
[71044.423606]  ? kernel_text_address+0xe2/0xf0
[71044.423608]  ? va_format.isra.12+0xee/0x100
[71044.423612]  ? vsnprintf+0x870/0x870
[71044.423614]  ? string_nocheck+0xb0/0xd0
[71044.423616]  ? pointer+0x387/0x460
[71044.423619]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71044.423620]  ? _raw_write_lock_bh+0xe0/0xe0
[71044.423622]  ? _raw_spin_lock+0x7a/0xd0
[71044.423624]  ? _raw_write_trylock+0xe0/0xe0
[71044.423626]  ? up+0x32/0x70
[71044.423630]  ? __switch_to_asm+0x34/0x70
[71044.423636]  ? dynamic_emit_prefix+0x29/0x220
[71044.423684]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
[71044.423735]  smb2_queryfs+0xd9/0x1c0 [cifs]
[71044.423776]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
[71044.423780]  ? vfs_mknod+0xc0/0x320
[71044.423785]  ? map_id_up+0x12f/0x1d0
[71044.423787]  ? make_kprojid+0x20/0x20
[71044.423789]  ? _raw_spin_lock+0x7a/0xd0
[71044.423837]  cifs_statfs+0x13a/0x420 [cifs]
[71044.423844]  statfs_by_dentry+0xa5/0xf0
[71044.423848]  vfs_statfs+0x28/0x110
[71044.423851]  user_statfs+0x91/0xf0
[71044.423853]  ? vfs_statfs+0x110/0x110
[71044.423855]  ? __schedule+0x562/0xac0
[71044.423857]  __do_sys_statfs+0x64/0xc0
[71044.423859]  ? user_statfs+0xf0/0xf0
[71044.423865]  do_syscall_64+0x73/0x190
[71044.423868]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71044.423875] RIP: 0033:0x4a5c20
[71044.423880] Code: Bad RIP value.
[71044.423882] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[71044.423888] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX: 00000000004a5c20
[71044.423890] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI: 000000c0001c43c0
[71044.423892] RBP: 000000c0003414f0 R08: 0000000000000000 R09: 0000000000000000
[71044.423893] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[71044.423894] R13: 000000000000001f R14: 000000000000001e R15: 0000000000000100
[71044.423926] INFO: task cifsd:9136 blocked for more than 120 seconds.
[71044.425076]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71044.426421] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71044.427718] cifsd           D    0  9136      2 0x80004000
[71044.427721] Call Trace:
[71044.427738]  ? __schedule+0x540/0xac0
[71044.427745]  ? firmware_map_remove+0xe9/0xe9
[71044.427752]  ? _raw_spin_lock+0x7a/0xd0
[71044.427757]  schedule+0x5e/0x100
[71044.427765]  schedule_preempt_disabled+0xa/0x10
[71044.427775]  __mutex_lock.isra.4+0x484/0x820
[71044.427781]  ? mutex_trylock+0x90/0x90
[71044.427787]  ? irq_work_claim+0x2e/0x50
[71044.427792]  ? vprintk_emit+0x11d/0x2e0
[71044.427795]  ? mutex_lock+0xce/0xe0
[71044.427797]  mutex_lock+0xce/0xe0
[71044.427800]  ? __mutex_lock_slowpath+0x10/0x10
[71044.427877]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[71044.427951]  cifs_reconnect+0x18c/0x1510 [cifs]
[71044.427970]  ? ___ratelimit+0x106/0x190
[71044.428050]  ? smb2_calc_size+0x15c/0x250 [cifs]
[71044.428107]  ? extract_hostname+0xa0/0xa0 [cifs]
[71044.428121]  ? _raw_spin_trylock+0x91/0xe0
[71044.428129]  ? _raw_spin_trylock_bh+0x100/0x100
[71044.428134]  ? ___ratelimit+0x106/0x190
[71044.428179]  cifs_handle_standard+0x252/0x270 [cifs]
[71044.428224]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[71044.428267]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71044.428272]  ? __switch_to_asm+0x40/0x70
[71044.428276]  ? __switch_to_asm+0x34/0x70
[71044.428278]  ? __switch_to_asm+0x40/0x70
[71044.428280]  ? __switch_to_asm+0x34/0x70
[71044.428281]  ? __switch_to_asm+0x40/0x70
[71044.428283]  ? __switch_to_asm+0x34/0x70
[71044.428284]  ? __switch_to_asm+0x40/0x70
[71044.428286]  ? __switch_to_asm+0x34/0x70
[71044.428287]  ? __switch_to_asm+0x40/0x70
[71044.428289]  ? __switch_to_asm+0x34/0x70
[71044.428290]  ? __switch_to_asm+0x40/0x70
[71044.428292]  ? __switch_to_asm+0x34/0x70
[71044.428293]  ? __switch_to_asm+0x40/0x70
[71044.428295]  ? __switch_to_asm+0x34/0x70
[71044.428296]  ? __switch_to_asm+0x40/0x70
[71044.428298]  ? __switch_to_asm+0x34/0x70
[71044.428299]  ? __switch_to_asm+0x40/0x70
[71044.428301]  ? __switch_to_asm+0x34/0x70
[71044.428303]  ? __switch_to_asm+0x40/0x70
[71044.428304]  ? __switch_to_asm+0x34/0x70
[71044.428306]  ? __switch_to_asm+0x40/0x70
[71044.428307]  ? __switch_to_asm+0x34/0x70
[71044.428309]  ? __switch_to_asm+0x40/0x70
[71044.428310]  ? __switch_to_asm+0x34/0x70
[71044.428312]  ? __switch_to_asm+0x40/0x70
[71044.428313]  ? __switch_to_asm+0x34/0x70
[71044.428317]  ? finish_task_switch+0xf6/0x370
[71044.428319]  ? __switch_to+0x2ec/0x5e0
[71044.428321]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71044.428323]  ? _raw_write_lock_bh+0xe0/0xe0
[71044.428375]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71044.428378]  kthread+0x192/0x1e0
[71044.428381]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[71044.428384]  ret_from_fork+0x35/0x40
[71062.848999] fs/cifs/smb2pdu.c: In echo request
[71062.849014] fs/cifs/smb2pdu.c: Echo request failed: -11
[71062.849025] fs/cifs/connect.c: Unable to send echo request to server: DC02
[71080.092803] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13357 with uid: 999
[71080.092915] fs/cifs/transport.c: Sending smb: smb_len=372
[71080.097568] fs/cifs/connect.c: RFC1002 header 0x1b8
[71080.097580] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71080.097581] fs/cifs/smb2misc.c: SMB2 len 208
[71080.097591] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71080.097592] fs/cifs/smb2misc.c: SMB2 len 104
[71080.097601] fs/cifs/smb2misc.c: SMB2 len 124
[71080.097603] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4072
[71080.097605] fs/cifs/smb2ops.c: add 3 credits total=512
[71080.097741] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4070 state=4
[71080.097749] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4071 state=4
[71080.097752] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4072 state=4
[71080.097758] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71080.097767] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71080.097771] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71080.097812] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13357) rc = 0
[71080.097992] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13358 with uid: 999
[71080.098070] fs/cifs/transport.c: Sending smb: smb_len=348
[71080.098487] fs/cifs/connect.c: RFC1002 header 0x1b8
[71080.098492] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71080.098493] fs/cifs/smb2misc.c: SMB2 len 208
[71080.098500] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71080.098501] fs/cifs/smb2misc.c: SMB2 len 104
[71080.098510] fs/cifs/smb2misc.c: SMB2 len 124
[71080.098512] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 80
[71080.098514] fs/cifs/smb2ops.c: add 30 credits total=951
[71080.098609] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=78 state=4
[71080.098610] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=79 state=4
[71080.098612] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=80 state=4
[71080.098613] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71080.098619] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71080.098624] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71080.098655] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13358) rc = 0
[71105.853107] fs/cifs/connect.c: Existing tcp session with server found
[71105.853114] fs/cifs/dfs_cache.c: CIFS VFS: in do_refresh_tcon as Xid: 13359 with uid: 0
[71116.587766] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 13360 with uid: 11025
[71116.587834] fs/cifs/dir.c: name: \SOMEDIRX
[71116.587842] fs/cifs/inode.c: Update attributes: \SOMEDIRX inode 0x000000009f726d03 count 1 dentry: 0x00000000d22e461a d_time 4312598279 jiffies 4312672891
[71116.587847] fs/cifs/inode.c: Getting info on \SOMEDIRX
[71116.588001] fs/cifs/transport.c: Sending smb: smb_len=388
[71124.283416] fs/cifs/smb2pdu.c: In echo request
[71124.283434] fs/cifs/smb2pdu.c: Echo request failed: -11
[71124.283442] fs/cifs/connect.c: Unable to send echo request to server: DC02
[71140.087648] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13361 with uid: 999
[71140.087743] fs/cifs/transport.c: Sending smb: smb_len=372
[71140.088088] fs/cifs/connect.c: RFC1002 header 0x1b8
[71140.088095] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71140.088096] fs/cifs/smb2misc.c: SMB2 len 208
[71140.088106] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71140.088107] fs/cifs/smb2misc.c: SMB2 len 104
[71140.088116] fs/cifs/smb2misc.c: SMB2 len 124
[71140.088118] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4075
[71140.088120] fs/cifs/smb2ops.c: add 3 credits total=512
[71140.088137] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4073 state=4
[71140.088141] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4074 state=4
[71140.088144] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4075 state=4
[71140.088147] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71140.088153] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71140.088158] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71140.088190] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13361) rc = 0
[71140.088218] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13362 with uid: 999
[71140.088304] fs/cifs/transport.c: Sending smb: smb_len=348
[71140.088643] fs/cifs/connect.c: RFC1002 header 0x1b8
[71140.088647] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71140.088648] fs/cifs/smb2misc.c: SMB2 len 208
[71140.088655] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71140.088656] fs/cifs/smb2misc.c: SMB2 len 104
[71140.088664] fs/cifs/smb2misc.c: SMB2 len 124
[71140.088665] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 83
[71140.088667] fs/cifs/smb2ops.c: add 30 credits total=978
[71140.088680] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=81 state=4
[71140.088682] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=82 state=4
[71140.088684] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=83 state=4
[71140.088686] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71140.088692] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71140.088696] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71140.088728] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13362) rc = 0
[71165.239724] INFO: task node_exporter:7214 blocked for more than 241 seconds.
[71165.240866]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71165.241935] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71165.243018] node_exporter   D    0  7214      1 0x00000000
[71165.243022] Call Trace:
[71165.243028]  ? __schedule+0x540/0xac0
[71165.243031]  ? firmware_map_remove+0xe9/0xe9
[71165.243035]  ? vsnprintf+0x32c/0x870
[71165.243038]  ? _raw_spin_lock+0x7a/0xd0
[71165.243040]  schedule+0x5e/0x100
[71165.243042]  schedule_preempt_disabled+0xa/0x10
[71165.243044]  __mutex_lock.isra.4+0x484/0x820
[71165.243047]  ? mutex_trylock+0x90/0x90
[71165.243049]  ? string_nocheck+0xb0/0xd0
[71165.243051]  ? pointer+0x387/0x460
[71165.243054]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71165.243056]  ? _raw_write_lock_bh+0xe0/0xe0
[71165.243059]  ? mutex_lock+0xce/0xe0
[71165.243060]  mutex_lock+0xce/0xe0
[71165.243062]  ? __mutex_lock_slowpath+0x10/0x10
[71165.243065]  ? find_nls+0x7d/0xa0
[71165.243133]  smb2_reconnect.part.21+0x218/0xbd0 [cifs]
[71165.243137]  ? deref_stack_reg+0x88/0xd0
[71165.243139]  ? 0xffffffffa1e00000
[71165.243180]  ? SMB2_tcon+0xab0/0xab0 [cifs]
[71165.243181]  ? unwind_next_frame+0x90a/0x980
[71165.243183]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71165.243187]  ? __module_text_address+0x11/0xa0
[71165.243189]  ? __is_insn_slot_addr+0x1b/0x70
[71165.243193]  ? is_bpf_text_address+0xa/0x20
[71165.243195]  ? kernel_text_address+0xe2/0xf0
[71165.243197]  ? __kernel_text_address+0xe/0x30
[71165.243200]  ? unwind_get_return_address+0x2f/0x50
[71165.243203]  ? create_prof_cpu_mask+0x20/0x20
[71165.243207]  ? arch_stack_walk+0x92/0xe0
[71165.243210]  ? stack_trace_save+0x8a/0xb0
[71165.243251]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
[71165.243294]  SMB2_open_init+0x143/0x12b0 [cifs]
[71165.243332]  ? cifs_statfs+0x13a/0x420 [cifs]
[71165.243336]  ? statfs_by_dentry+0xa5/0xf0
[71165.243338]  ? vfs_statfs+0x28/0x110
[71165.243340]  ? __do_sys_statfs+0x64/0xc0
[71165.243382]  ? smb2_parse_contexts+0x270/0x270 [cifs]
[71165.243384]  ? _raw_write_trylock+0xe0/0xe0
[71165.243385]  ? _raw_spin_lock+0x7a/0xd0
[71165.243387]  ? _raw_write_trylock+0xe0/0xe0
[71165.243389]  ? memset+0x1f/0x40
[71165.243391]  ? stack_access_ok+0x35/0x90
[71165.243393]  ? deref_stack_reg+0x88/0xd0
[71165.243396]  ? stack_access_ok+0x35/0x90
[71165.243399]  ? deref_stack_reg+0x88/0xd0
[71165.243402]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[71165.243404]  ? put_dec_trunc8+0x73/0x110
[71165.243406]  ? number+0x356/0x4b0
[71165.243408]  ? widen_string+0x23/0xf0
[71165.243449]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
[71165.243490]  smb2_query_info_compound+0x242/0x4d0 [cifs]
[71165.243533]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
[71165.243535]  ? pointer+0x460/0x460
[71165.243537]  ? kernel_text_address+0xe2/0xf0
[71165.243539]  ? va_format.isra.12+0xee/0x100
[71165.243541]  ? vsnprintf+0x870/0x870
[71165.243543]  ? string_nocheck+0xb0/0xd0
[71165.243545]  ? pointer+0x387/0x460
[71165.243547]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71165.243549]  ? _raw_write_lock_bh+0xe0/0xe0
[71165.243551]  ? _raw_spin_lock+0x7a/0xd0
[71165.243552]  ? _raw_write_trylock+0xe0/0xe0
[71165.243555]  ? up+0x32/0x70
[71165.243558]  ? __switch_to_asm+0x34/0x70
[71165.243561]  ? dynamic_emit_prefix+0x29/0x220
[71165.243602]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
[71165.243644]  smb2_queryfs+0xd9/0x1c0 [cifs]
[71165.243688]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
[71165.243764]  ? vfs_mknod+0xc0/0x320
[71165.243770]  ? map_id_up+0x12f/0x1d0
[71165.243774]  ? make_kprojid+0x20/0x20
[71165.243777]  ? _raw_spin_lock+0x7a/0xd0
[71165.243818]  cifs_statfs+0x13a/0x420 [cifs]
[71165.243825]  statfs_by_dentry+0xa5/0xf0
[71165.243829]  vfs_statfs+0x28/0x110
[71165.243835]  user_statfs+0x91/0xf0
[71165.243838]  ? vfs_statfs+0x110/0x110
[71165.243844]  ? __schedule+0x562/0xac0
[71165.243847]  __do_sys_statfs+0x64/0xc0
[71165.243854]  ? user_statfs+0xf0/0xf0
[71165.243859]  do_syscall_64+0x73/0x190
[71165.243863]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71165.243866] RIP: 0033:0x4a5c20
[71165.243873] Code: Bad RIP value.
[71165.243876] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[71165.243881] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX: 00000000004a5c20
[71165.243883] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI: 000000c0001c43c0
[71165.243885] RBP: 000000c0003414f0 R08: 0000000000000000 R09: 0000000000000000
[71165.243886] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[71165.243887] R13: 000000000000001f R14: 000000000000001e R15: 0000000000000100
[71165.243905] INFO: task cifsd:9136 blocked for more than 241 seconds.
[71165.245022]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71165.246156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71165.247272] cifsd           D    0  9136      2 0x80004000
[71165.247274] Call Trace:
[71165.247281]  ? __schedule+0x540/0xac0
[71165.247284]  ? firmware_map_remove+0xe9/0xe9
[71165.247287]  ? _raw_spin_lock+0x7a/0xd0
[71165.247289]  schedule+0x5e/0x100
[71165.247291]  schedule_preempt_disabled+0xa/0x10
[71165.247293]  __mutex_lock.isra.4+0x484/0x820
[71165.247296]  ? mutex_trylock+0x90/0x90
[71165.247300]  ? irq_work_claim+0x2e/0x50
[71165.247303]  ? vprintk_emit+0x11d/0x2e0
[71165.247305]  ? mutex_lock+0xce/0xe0
[71165.247306]  mutex_lock+0xce/0xe0
[71165.247308]  ? __mutex_lock_slowpath+0x10/0x10
[71165.247358]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[71165.247398]  cifs_reconnect+0x18c/0x1510 [cifs]
[71165.247402]  ? ___ratelimit+0x106/0x190
[71165.247444]  ? smb2_calc_size+0x15c/0x250 [cifs]
[71165.247484]  ? extract_hostname+0xa0/0xa0 [cifs]
[71165.247486]  ? _raw_spin_trylock+0x91/0xe0
[71165.247487]  ? _raw_spin_trylock_bh+0x100/0x100
[71165.247490]  ? ___ratelimit+0x106/0x190
[71165.247533]  cifs_handle_standard+0x252/0x270 [cifs]
[71165.247575]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[71165.247616]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71165.247618]  ? __switch_to_asm+0x40/0x70
[71165.247620]  ? __switch_to_asm+0x34/0x70
[71165.247621]  ? __switch_to_asm+0x40/0x70
[71165.247623]  ? __switch_to_asm+0x34/0x70
[71165.247624]  ? __switch_to_asm+0x40/0x70
[71165.247626]  ? __switch_to_asm+0x34/0x70
[71165.247627]  ? __switch_to_asm+0x40/0x70
[71165.247629]  ? __switch_to_asm+0x34/0x70
[71165.247630]  ? __switch_to_asm+0x40/0x70
[71165.247632]  ? __switch_to_asm+0x34/0x70
[71165.247633]  ? __switch_to_asm+0x40/0x70
[71165.247635]  ? __switch_to_asm+0x34/0x70
[71165.247637]  ? __switch_to_asm+0x40/0x70
[71165.247638]  ? __switch_to_asm+0x34/0x70
[71165.247640]  ? __switch_to_asm+0x40/0x70
[71165.247641]  ? __switch_to_asm+0x34/0x70
[71165.247643]  ? __switch_to_asm+0x40/0x70
[71165.247644]  ? __switch_to_asm+0x34/0x70
[71165.247646]  ? __switch_to_asm+0x40/0x70
[71165.247647]  ? __switch_to_asm+0x34/0x70
[71165.247649]  ? __switch_to_asm+0x40/0x70
[71165.247651]  ? __switch_to_asm+0x34/0x70
[71165.247653]  ? __switch_to_asm+0x40/0x70
[71165.247659]  ? __switch_to_asm+0x34/0x70
[71165.247678]  ? __switch_to_asm+0x40/0x70
[71165.247680]  ? __switch_to_asm+0x34/0x70
[71165.247683]  ? finish_task_switch+0xf6/0x370
[71165.247685]  ? __switch_to+0x2ec/0x5e0
[71165.247688]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71165.247690]  ? _raw_write_lock_bh+0xe0/0xe0
[71165.247731]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71165.247735]  kthread+0x192/0x1e0
[71165.247737]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[71165.247739]  ret_from_fork+0x35/0x40
[71185.717885] fs/cifs/smb2pdu.c: In echo request
[71185.717900] fs/cifs/smb2pdu.c: Echo request failed: -11
[71185.717906] fs/cifs/connect.c: Unable to send echo request to server: DC02
[71200.086057] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13363 with uid: 999
[71200.086149] fs/cifs/transport.c: Sending smb: smb_len=372
[71200.086716] fs/cifs/connect.c: RFC1002 header 0x1b8
[71200.086725] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71200.086726] fs/cifs/smb2misc.c: SMB2 len 208
[71200.086740] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71200.086741] fs/cifs/smb2misc.c: SMB2 len 104
[71200.086751] fs/cifs/smb2misc.c: SMB2 len 124
[71200.086752] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4078
[71200.086755] fs/cifs/smb2ops.c: add 3 credits total=512
[71200.086770] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4076 state=4
[71200.086775] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4077 state=4
[71200.086777] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4078 state=4
[71200.086781] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71200.086786] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71200.086791] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71200.086824] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13363) rc = 0
[71200.086841] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13364 with uid: 999
[71200.086938] fs/cifs/transport.c: Sending smb: smb_len=348
[71200.087336] fs/cifs/connect.c: RFC1002 header 0x1b8
[71200.087342] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71200.087343] fs/cifs/smb2misc.c: SMB2 len 208
[71200.087352] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71200.087353] fs/cifs/smb2misc.c: SMB2 len 104
[71200.087362] fs/cifs/smb2misc.c: SMB2 len 124
[71200.087364] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 86
[71200.087366] fs/cifs/smb2ops.c: add 30 credits total=1005
[71200.087379] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=84 state=4
[71200.087381] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=85 state=4
[71200.087383] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=86 state=4
[71200.087384] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71200.087391] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71200.087395] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71200.087428] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13364) rc = 0
[71247.152290] fs/cifs/smb2pdu.c: In echo request
[71247.152306] fs/cifs/smb2pdu.c: Echo request failed: -11
[71247.152313] fs/cifs/connect.c: Unable to send echo request to server: DC02
[71260.080476] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13365 with uid: 999
[71260.080564] fs/cifs/transport.c: Sending smb: smb_len=372
[71260.080923] fs/cifs/connect.c: RFC1002 header 0x1b8
[71260.080931] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71260.080932] fs/cifs/smb2misc.c: SMB2 len 208
[71260.080946] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71260.080947] fs/cifs/smb2misc.c: SMB2 len 104
[71260.080958] fs/cifs/smb2misc.c: SMB2 len 124
[71260.080959] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4081
[71260.080962] fs/cifs/smb2ops.c: add 3 credits total=512
[71260.080975] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4079 state=4
[71260.080979] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4080 state=4
[71260.080982] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4081 state=4
[71260.080985] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71260.080991] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71260.080996] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71260.081032] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13365) rc = 0
[71260.081163] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13366 with uid: 999
[71260.081228] fs/cifs/transport.c: Sending smb: smb_len=348
[71260.081798] fs/cifs/connect.c: RFC1002 header 0x1b8
[71260.081804] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71260.081805] fs/cifs/smb2misc.c: SMB2 len 208
[71260.081814] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71260.081814] fs/cifs/smb2misc.c: SMB2 len 104
[71260.081824] fs/cifs/smb2misc.c: SMB2 len 124
[71260.081826] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 89
[71260.081828] fs/cifs/smb2ops.c: add 30 credits total=1032
[71260.081841] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=87 state=4
[71260.081843] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=88 state=4
[71260.081845] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=89 state=4
[71260.081847] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71260.081854] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71260.081904] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71260.081936] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13366) rc = 0
[71286.060785] INFO: task node_exporter:7214 blocked for more than 362 seconds.
[71286.061989]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71286.063131] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71286.064284] node_exporter   D    0  7214      1 0x00000000
[71286.064287] Call Trace:
[71286.064294]  ? __schedule+0x540/0xac0
[71286.064297]  ? firmware_map_remove+0xe9/0xe9
[71286.064301]  ? vsnprintf+0x32c/0x870
[71286.064304]  ? _raw_spin_lock+0x7a/0xd0
[71286.064306]  schedule+0x5e/0x100
[71286.064308]  schedule_preempt_disabled+0xa/0x10
[71286.064310]  __mutex_lock.isra.4+0x484/0x820
[71286.064312]  ? mutex_trylock+0x90/0x90
[71286.064315]  ? string_nocheck+0xb0/0xd0
[71286.064317]  ? pointer+0x387/0x460
[71286.064319]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71286.064321]  ? _raw_write_lock_bh+0xe0/0xe0
[71286.064324]  ? mutex_lock+0xce/0xe0
[71286.064325]  mutex_lock+0xce/0xe0
[71286.064327]  ? __mutex_lock_slowpath+0x10/0x10
[71286.064331]  ? find_nls+0x7d/0xa0
[71286.064381]  smb2_reconnect.part.21+0x218/0xbd0 [cifs]
[71286.064386]  ? deref_stack_reg+0x88/0xd0
[71286.064392]  ? 0xffffffffa1e00000
[71286.064434]  ? SMB2_tcon+0xab0/0xab0 [cifs]
[71286.064436]  ? unwind_next_frame+0x90a/0x980
[71286.064438]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71286.064442]  ? __module_text_address+0x11/0xa0
[71286.064444]  ? __is_insn_slot_addr+0x1b/0x70
[71286.064447]  ? is_bpf_text_address+0xa/0x20
[71286.064450]  ? kernel_text_address+0xe2/0xf0
[71286.064451]  ? __kernel_text_address+0xe/0x30
[71286.064454]  ? unwind_get_return_address+0x2f/0x50
[71286.064457]  ? create_prof_cpu_mask+0x20/0x20
[71286.064460]  ? arch_stack_walk+0x92/0xe0
[71286.064463]  ? stack_trace_save+0x8a/0xb0
[71286.064505]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
[71286.064548]  SMB2_open_init+0x143/0x12b0 [cifs]
[71286.064586]  ? cifs_statfs+0x13a/0x420 [cifs]
[71286.064590]  ? statfs_by_dentry+0xa5/0xf0
[71286.064592]  ? vfs_statfs+0x28/0x110
[71286.064594]  ? __do_sys_statfs+0x64/0xc0
[71286.064636]  ? smb2_parse_contexts+0x270/0x270 [cifs]
[71286.064638]  ? _raw_write_trylock+0xe0/0xe0
[71286.064640]  ? _raw_spin_lock+0x7a/0xd0
[71286.064641]  ? _raw_write_trylock+0xe0/0xe0
[71286.064643]  ? memset+0x1f/0x40
[71286.064646]  ? stack_access_ok+0x35/0x90
[71286.064648]  ? deref_stack_reg+0x88/0xd0
[71286.064650]  ? stack_access_ok+0x35/0x90
[71286.064652]  ? deref_stack_reg+0x88/0xd0
[71286.064654]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[71286.064656]  ? put_dec_trunc8+0x73/0x110
[71286.064658]  ? number+0x356/0x4b0
[71286.064660]  ? widen_string+0x23/0xf0
[71286.064705]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
[71286.064770]  smb2_query_info_compound+0x242/0x4d0 [cifs]
[71286.064817]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
[71286.064821]  ? pointer+0x460/0x460
[71286.064827]  ? kernel_text_address+0xe2/0xf0
[71286.064835]  ? va_format.isra.12+0xee/0x100
[71286.064841]  ? vsnprintf+0x870/0x870
[71286.064854]  ? string_nocheck+0xb0/0xd0
[71286.064869]  ? pointer+0x387/0x460
[71286.064875]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71286.064886]  ? _raw_write_lock_bh+0xe0/0xe0
[71286.064888]  ? _raw_spin_lock+0x7a/0xd0
[71286.064889]  ? _raw_write_trylock+0xe0/0xe0
[71286.064892]  ? up+0x32/0x70
[71286.064896]  ? __switch_to_asm+0x34/0x70
[71286.064898]  ? dynamic_emit_prefix+0x29/0x220
[71286.064940]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
[71286.064982]  smb2_queryfs+0xd9/0x1c0 [cifs]
[71286.065029]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
[71286.065035]  ? vfs_mknod+0xc0/0x320
[71286.065038]  ? map_id_up+0x12f/0x1d0
[71286.065040]  ? make_kprojid+0x20/0x20
[71286.065042]  ? _raw_spin_lock+0x7a/0xd0
[71286.065081]  cifs_statfs+0x13a/0x420 [cifs]
[71286.065088]  statfs_by_dentry+0xa5/0xf0
[71286.065091]  vfs_statfs+0x28/0x110
[71286.065093]  user_statfs+0x91/0xf0
[71286.065095]  ? vfs_statfs+0x110/0x110
[71286.065099]  ? __schedule+0x562/0xac0
[71286.065103]  __do_sys_statfs+0x64/0xc0
[71286.065105]  ? user_statfs+0xf0/0xf0
[71286.065109]  do_syscall_64+0x73/0x190
[71286.065112]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71286.065116] RIP: 0033:0x4a5c20
[71286.065121] Code: Bad RIP value.
[71286.065122] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[71286.065125] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX: 00000000004a5c20
[71286.065127] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI: 000000c0001c43c0
[71286.065131] RBP: 000000c0003414f0 R08: 0000000000000000 R09: 0000000000000000
[71286.065133] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[71286.065134] R13: 000000000000001f R14: 000000000000001e R15: 0000000000000100
[71286.065156] INFO: task cifsd:9136 blocked for more than 362 seconds.
[71286.066326]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71286.068159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71286.069395] cifsd           D    0  9136      2 0x80004000
[71286.069399] Call Trace:
[71286.069405]  ? __schedule+0x540/0xac0
[71286.069408]  ? firmware_map_remove+0xe9/0xe9
[71286.069411]  ? _raw_spin_lock+0x7a/0xd0
[71286.069413]  schedule+0x5e/0x100
[71286.069416]  schedule_preempt_disabled+0xa/0x10
[71286.069417]  __mutex_lock.isra.4+0x484/0x820
[71286.069420]  ? mutex_trylock+0x90/0x90
[71286.069424]  ? irq_work_claim+0x2e/0x50
[71286.069427]  ? vprintk_emit+0x11d/0x2e0
[71286.069430]  ? mutex_lock+0xce/0xe0
[71286.069431]  mutex_lock+0xce/0xe0
[71286.069433]  ? __mutex_lock_slowpath+0x10/0x10
[71286.069485]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[71286.069526]  cifs_reconnect+0x18c/0x1510 [cifs]
[71286.069530]  ? ___ratelimit+0x106/0x190
[71286.069572]  ? smb2_calc_size+0x15c/0x250 [cifs]
[71286.069611]  ? extract_hostname+0xa0/0xa0 [cifs]
[71286.069613]  ? _raw_spin_trylock+0x91/0xe0
[71286.069615]  ? _raw_spin_trylock_bh+0x100/0x100
[71286.069617]  ? ___ratelimit+0x106/0x190
[71286.069657]  cifs_handle_standard+0x252/0x270 [cifs]
[71286.069697]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[71286.069737]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71286.069739]  ? __switch_to_asm+0x40/0x70
[71286.069741]  ? __switch_to_asm+0x34/0x70
[71286.069742]  ? __switch_to_asm+0x40/0x70
[71286.069744]  ? __switch_to_asm+0x34/0x70
[71286.069746]  ? __switch_to_asm+0x40/0x70
[71286.069748]  ? __switch_to_asm+0x34/0x70
[71286.069750]  ? __switch_to_asm+0x40/0x70
[71286.069752]  ? __switch_to_asm+0x34/0x70
[71286.069753]  ? __switch_to_asm+0x40/0x70
[71286.069755]  ? __switch_to_asm+0x34/0x70
[71286.069756]  ? __switch_to_asm+0x40/0x70
[71286.069758]  ? __switch_to_asm+0x34/0x70
[71286.069759]  ? __switch_to_asm+0x40/0x70
[71286.069761]  ? __switch_to_asm+0x34/0x70
[71286.069762]  ? __switch_to_asm+0x40/0x70
[71286.069764]  ? __switch_to_asm+0x34/0x70
[71286.069765]  ? __switch_to_asm+0x40/0x70
[71286.069767]  ? __switch_to_asm+0x34/0x70
[71286.069768]  ? __switch_to_asm+0x40/0x70
[71286.069770]  ? __switch_to_asm+0x34/0x70
[71286.069772]  ? __switch_to_asm+0x40/0x70
[71286.069773]  ? __switch_to_asm+0x34/0x70
[71286.069775]  ? __switch_to_asm+0x40/0x70
[71286.069776]  ? __switch_to_asm+0x34/0x70
[71286.069778]  ? __switch_to_asm+0x40/0x70
[71286.069779]  ? __switch_to_asm+0x34/0x70
[71286.069782]  ? finish_task_switch+0xf6/0x370
[71286.069784]  ? __switch_to+0x2ec/0x5e0
[71286.069786]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71286.069788]  ? _raw_write_lock_bh+0xe0/0xe0
[71286.069828]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71286.069830]  kthread+0x192/0x1e0
[71286.069832]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[71286.069834]  ret_from_fork+0x35/0x40
[71286.069842] INFO: task kworker/0:0:16069 blocked for more than 120 seconds.
[71286.071059]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71286.072279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71286.073534] kworker/0:0     D    0 16069      2 0x80004000
[71286.073585] Workqueue: cifsiod refresh_cache_worker [cifs]
[71286.073586] Call Trace:
[71286.073590]  ? __schedule+0x540/0xac0
[71286.073592]  ? firmware_map_remove+0xe9/0xe9
[71286.073595]  ? _raw_read_lock_irq+0x40/0x40
[71286.073597]  ? _raw_spin_lock+0x7a/0xd0
[71286.073599]  schedule+0x5e/0x100
[71286.073601]  schedule_preempt_disabled+0xa/0x10
[71286.073603]  __mutex_lock.isra.4+0x484/0x820
[71286.073606]  ? mutex_trylock+0x90/0x90
[71286.073609]  ? dynamic_emit_prefix+0x29/0x220
[71286.073610]  ? __dynamic_pr_debug+0xf8/0x140
[71286.073612]  ? dynamic_emit_prefix+0x220/0x220
[71286.073618]  ? update_dl_rq_load_avg+0x2c3/0x4d0
[71286.073620]  ? mutex_lock+0xce/0xe0
[71286.073621]  mutex_lock+0xce/0xe0
[71286.073623]  ? __mutex_lock_slowpath+0x10/0x10
[71286.073665]  refresh_cache_worker+0x48f/0x14a0 [cifs]
[71286.073668]  ? __switch_to_asm+0x40/0x70
[71286.073670]  ? __switch_to_asm+0x40/0x70
[71286.073672]  ? __switch_to_asm+0x34/0x70
[71286.073673]  ? __switch_to_asm+0x40/0x70
[71286.073675]  ? __switch_to_asm+0x34/0x70
[71286.073676]  ? __switch_to_asm+0x40/0x70
[71286.073718]  ? find_root_ses.isra.9+0x320/0x320 [cifs]
[71286.073720]  ? __switch_to_asm+0x40/0x70
[71286.073722]  ? __switch_to_asm+0x40/0x70
[71286.073723]  ? __switch_to_asm+0x34/0x70
[71286.073725]  ? __switch_to_asm+0x40/0x70
[71286.073728]  ? __switch_to_asm+0x34/0x70
[71286.073729]  ? __switch_to_asm+0x40/0x70
[71286.073731]  ? __switch_to_asm+0x34/0x70
[71286.073732]  ? __switch_to_asm+0x40/0x70
[71286.073734]  ? __switch_to_asm+0x40/0x70
[71286.073736]  ? __switch_to_asm+0x34/0x70
[71286.073738]  ? finish_task_switch+0xf6/0x370
[71286.073741]  ? __switch_to+0x2ec/0x5e0
[71286.073742]  ? __schedule+0x562/0xac0
[71286.073745]  ? read_word_at_a_time+0xe/0x20
[71286.073747]  ? strscpy+0xca/0x1d0
[71286.073753]  process_one_work+0x373/0x6e0
[71286.073756]  worker_thread+0x78/0x5b0
[71286.073759]  ? rescuer_thread+0x5e0/0x5e0
[71286.073760]  kthread+0x192/0x1e0
[71286.073762]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[71286.073764]  ret_from_fork+0x35/0x40
[71308.590706] fs/cifs/smb2pdu.c: In echo request
[71308.590730] fs/cifs/smb2pdu.c: Echo request failed: -11
[71308.590743] fs/cifs/connect.c: Unable to send echo request to server: DC02
[71320.544886] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13367 with uid: 999
[71320.544989] fs/cifs/transport.c: Sending smb: smb_len=372
[71320.545462] fs/cifs/connect.c: RFC1002 header 0x1b8
[71320.545477] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71320.545479] fs/cifs/smb2misc.c: SMB2 len 208
[71320.545495] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71320.545496] fs/cifs/smb2misc.c: SMB2 len 104
[71320.545512] fs/cifs/smb2misc.c: SMB2 len 124
[71320.545515] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4084
[71320.545517] fs/cifs/smb2ops.c: add 3 credits total=512
[71320.545533] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4082 state=4
[71320.545539] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4083 state=4
[71320.545542] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4084 state=4
[71320.545548] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71320.545555] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71320.545559] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71320.545620] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13367) rc = 0
[71320.548354] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13368 with uid: 999
[71320.548525] fs/cifs/transport.c: Sending smb: smb_len=348
[71320.548816] fs/cifs/connect.c: RFC1002 header 0x1b8
[71320.548826] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71320.548828] fs/cifs/smb2misc.c: SMB2 len 208
[71320.548844] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71320.548846] fs/cifs/smb2misc.c: SMB2 len 104
[71320.548864] fs/cifs/smb2misc.c: SMB2 len 124
[71320.548867] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 92
[71320.548870] fs/cifs/smb2ops.c: add 30 credits total=1059
[71320.548887] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=90 state=4
[71320.548890] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=91 state=4
[71320.548891] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=92 state=4
[71320.548893] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71320.548900] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71320.548904] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71320.548937] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13368) rc = 0
[71370.021141] fs/cifs/smb2pdu.c: In echo request
[71370.021164] fs/cifs/smb2pdu.c: Echo request failed: -11
[71370.021172] fs/cifs/connect.c: Unable to send echo request to server: DC02
[71380.065094] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13369 with uid: 999
[71380.065186] fs/cifs/transport.c: Sending smb: smb_len=372
[71380.065747] fs/cifs/connect.c: RFC1002 header 0x1b8
[71380.065757] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71380.065758] fs/cifs/smb2misc.c: SMB2 len 208
[71380.065771] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71380.065773] fs/cifs/smb2misc.c: SMB2 len 104
[71380.065786] fs/cifs/smb2misc.c: SMB2 len 124
[71380.065789] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 4087
[71380.065792] fs/cifs/smb2ops.c: add 3 credits total=512
[71380.065826] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=4085 state=4
[71380.065831] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=4086 state=4
[71380.065834] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=4087 state=4
[71380.065837] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71380.065843] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71380.065848] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71380.065881] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13369) rc = 0
[71380.065908] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 13370 with uid: 999
[71380.065966] fs/cifs/transport.c: Sending smb: smb_len=348
[71380.066494] fs/cifs/connect.c: RFC1002 header 0x1b8
[71380.066501] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[71380.066503] fs/cifs/smb2misc.c: SMB2 len 208
[71380.066516] fs/cifs/smb2misc.c: SMB2 data length 32 offset 72
[71380.066517] fs/cifs/smb2misc.c: SMB2 len 104
[71380.066532] fs/cifs/smb2misc.c: SMB2 len 124
[71380.066534] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 95
[71380.066536] fs/cifs/smb2ops.c: add 30 credits total=1086
[71380.067649] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=93 state=4
[71380.067652] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=94 state=4
[71380.067656] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=95 state=4
[71380.067658] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71380.067667] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71380.067672] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[71380.067707] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 13370) rc = 0
[71406.881866] INFO: task node_exporter:7214 blocked for more than 483 seconds.
[71406.883327]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71406.884700] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71406.886064] node_exporter   D    0  7214      1 0x00000000
[71406.886068] Call Trace:
[71406.886075]  ? __schedule+0x540/0xac0
[71406.886080]  ? firmware_map_remove+0xe9/0xe9
[71406.886087]  ? vsnprintf+0x32c/0x870
[71406.886091]  ? _raw_spin_lock+0x7a/0xd0
[71406.886095]  schedule+0x5e/0x100
[71406.886098]  schedule_preempt_disabled+0xa/0x10
[71406.886104]  __mutex_lock.isra.4+0x484/0x820
[71406.886106]  ? mutex_trylock+0x90/0x90
[71406.886108]  ? string_nocheck+0xb0/0xd0
[71406.886111]  ? pointer+0x387/0x460
[71406.886113]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71406.886115]  ? _raw_write_lock_bh+0xe0/0xe0
[71406.886121]  ? mutex_lock+0xce/0xe0
[71406.886122]  mutex_lock+0xce/0xe0
[71406.886124]  ? __mutex_lock_slowpath+0x10/0x10
[71406.886126]  ? find_nls+0x7d/0xa0
[71406.886194]  smb2_reconnect.part.21+0x218/0xbd0 [cifs]
[71406.886206]  ? deref_stack_reg+0x88/0xd0
[71406.886210]  ? 0xffffffffa1e00000
[71406.886254]  ? SMB2_tcon+0xab0/0xab0 [cifs]
[71406.886258]  ? unwind_next_frame+0x90a/0x980
[71406.886260]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71406.886263]  ? __module_text_address+0x11/0xa0
[71406.886265]  ? __is_insn_slot_addr+0x1b/0x70
[71406.886272]  ? is_bpf_text_address+0xa/0x20
[71406.886274]  ? kernel_text_address+0xe2/0xf0
[71406.886275]  ? __kernel_text_address+0xe/0x30
[71406.886278]  ? unwind_get_return_address+0x2f/0x50
[71406.886280]  ? create_prof_cpu_mask+0x20/0x20
[71406.886288]  ? arch_stack_walk+0x92/0xe0
[71406.886291]  ? stack_trace_save+0x8a/0xb0
[71406.886337]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
[71406.886381]  SMB2_open_init+0x143/0x12b0 [cifs]
[71406.886420]  ? cifs_statfs+0x13a/0x420 [cifs]
[71406.886424]  ? statfs_by_dentry+0xa5/0xf0
[71406.886426]  ? vfs_statfs+0x28/0x110
[71406.886428]  ? __do_sys_statfs+0x64/0xc0
[71406.886470]  ? smb2_parse_contexts+0x270/0x270 [cifs]
[71406.886475]  ? _raw_write_trylock+0xe0/0xe0
[71406.886476]  ? _raw_spin_lock+0x7a/0xd0
[71406.886478]  ? _raw_write_trylock+0xe0/0xe0
[71406.886480]  ? memset+0x1f/0x40
[71406.886482]  ? stack_access_ok+0x35/0x90
[71406.886484]  ? deref_stack_reg+0x88/0xd0
[71406.886486]  ? stack_access_ok+0x35/0x90
[71406.886488]  ? deref_stack_reg+0x88/0xd0
[71406.886491]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[71406.886493]  ? put_dec_trunc8+0x73/0x110
[71406.886495]  ? number+0x356/0x4b0
[71406.886497]  ? widen_string+0x23/0xf0
[71406.886538]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
[71406.886580]  smb2_query_info_compound+0x242/0x4d0 [cifs]
[71406.886622]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
[71406.886624]  ? pointer+0x460/0x460
[71406.886626]  ? kernel_text_address+0xe2/0xf0
[71406.886628]  ? va_format.isra.12+0xee/0x100
[71406.886630]  ? vsnprintf+0x870/0x870
[71406.886632]  ? string_nocheck+0xb0/0xd0
[71406.886634]  ? pointer+0x387/0x460
[71406.886636]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71406.886638]  ? _raw_write_lock_bh+0xe0/0xe0
[71406.886640]  ? _raw_spin_lock+0x7a/0xd0
[71406.886641]  ? _raw_write_trylock+0xe0/0xe0
[71406.886644]  ? up+0x32/0x70
[71406.886647]  ? __switch_to_asm+0x34/0x70
[71406.886649]  ? dynamic_emit_prefix+0x29/0x220
[71406.886691]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
[71406.886744]  smb2_queryfs+0xd9/0x1c0 [cifs]
[71406.886789]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
[71406.886792]  ? vfs_mknod+0xc0/0x320
[71406.886795]  ? map_id_up+0x12f/0x1d0
[71406.886797]  ? make_kprojid+0x20/0x20
[71406.886799]  ? _raw_spin_lock+0x7a/0xd0
[71406.886836]  cifs_statfs+0x13a/0x420 [cifs]
[71406.886839]  statfs_by_dentry+0xa5/0xf0
[71406.886842]  vfs_statfs+0x28/0x110
[71406.886844]  user_statfs+0x91/0xf0
[71406.886846]  ? vfs_statfs+0x110/0x110
[71406.886848]  ? __schedule+0x562/0xac0
[71406.886850]  __do_sys_statfs+0x64/0xc0
[71406.886852]  ? user_statfs+0xf0/0xf0
[71406.886856]  do_syscall_64+0x73/0x190
[71406.886858]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[71406.886860] RIP: 0033:0x4a5c20
[71406.886864] Code: Bad RIP value.
[71406.886865] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX: 0000000000000089
[71406.886867] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX: 00000000004a5c20
[71406.886868] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI: 000000c0001c43c0
[71406.886869] RBP: 000000c0003414f0 R08: 0000000000000000 R09: 0000000000000000
[71406.886871] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
[71406.886871] R13: 000000000000001f R14: 000000000000001e R15: 0000000000000100
[71406.886897] INFO: task cifsd:9136 blocked for more than 483 seconds.
[71406.888219]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71406.889666] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71406.891125] cifsd           D    0  9136      2 0x80004000
[71406.891130] Call Trace:
[71406.891138]  ? __schedule+0x540/0xac0
[71406.891147]  ? firmware_map_remove+0xe9/0xe9
[71406.891156]  ? _raw_spin_lock+0x7a/0xd0
[71406.891161]  schedule+0x5e/0x100
[71406.891168]  schedule_preempt_disabled+0xa/0x10
[71406.891173]  __mutex_lock.isra.4+0x484/0x820
[71406.891179]  ? mutex_trylock+0x90/0x90
[71406.891192]  ? irq_work_claim+0x2e/0x50
[71406.891207]  ? vprintk_emit+0x11d/0x2e0
[71406.891216]  ? mutex_lock+0xce/0xe0
[71406.891228]  mutex_lock+0xce/0xe0
[71406.891232]  ? __mutex_lock_slowpath+0x10/0x10
[71406.891317]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
[71406.891378]  cifs_reconnect+0x18c/0x1510 [cifs]
[71406.891383]  ? ___ratelimit+0x106/0x190
[71406.891439]  ? smb2_calc_size+0x15c/0x250 [cifs]
[71406.891505]  ? extract_hostname+0xa0/0xa0 [cifs]
[71406.891510]  ? _raw_spin_trylock+0x91/0xe0
[71406.891513]  ? _raw_spin_trylock_bh+0x100/0x100
[71406.891516]  ? ___ratelimit+0x106/0x190
[71406.891574]  cifs_handle_standard+0x252/0x270 [cifs]
[71406.891631]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
[71406.891692]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71406.891696]  ? __switch_to_asm+0x40/0x70
[71406.891698]  ? __switch_to_asm+0x34/0x70
[71406.891701]  ? __switch_to_asm+0x40/0x70
[71406.891703]  ? __switch_to_asm+0x34/0x70
[71406.891706]  ? __switch_to_asm+0x40/0x70
[71406.891709]  ? __switch_to_asm+0x34/0x70
[71406.891712]  ? __switch_to_asm+0x40/0x70
[71406.891715]  ? __switch_to_asm+0x34/0x70
[71406.891718]  ? __switch_to_asm+0x40/0x70
[71406.891720]  ? __switch_to_asm+0x34/0x70
[71406.891723]  ? __switch_to_asm+0x40/0x70
[71406.891725]  ? __switch_to_asm+0x34/0x70
[71406.891727]  ? __switch_to_asm+0x40/0x70
[71406.891729]  ? __switch_to_asm+0x34/0x70
[71406.891732]  ? __switch_to_asm+0x40/0x70
[71406.891734]  ? __switch_to_asm+0x34/0x70
[71406.891737]  ? __switch_to_asm+0x40/0x70
[71406.891739]  ? __switch_to_asm+0x34/0x70
[71406.891741]  ? __switch_to_asm+0x40/0x70
[71406.891744]  ? __switch_to_asm+0x34/0x70
[71406.891746]  ? __switch_to_asm+0x40/0x70
[71406.891749]  ? __switch_to_asm+0x34/0x70
[71406.891751]  ? __switch_to_asm+0x40/0x70
[71406.891753]  ? __switch_to_asm+0x34/0x70
[71406.891756]  ? __switch_to_asm+0x40/0x70
[71406.891758]  ? __switch_to_asm+0x34/0x70
[71406.891763]  ? finish_task_switch+0xf6/0x370
[71406.891767]  ? __switch_to+0x2ec/0x5e0
[71406.891772]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[71406.891774]  ? _raw_write_lock_bh+0xe0/0xe0
[71406.891946]  ? cifs_handle_standard+0x270/0x270 [cifs]
[71406.891951]  kthread+0x192/0x1e0
[71406.891955]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[71406.891958]  ret_from_fork+0x35/0x40
[71406.891970] INFO: task kworker/0:0:16069 blocked for more than 241 seconds.
[71406.894262]       Tainted: G            E     5.3.11-pd-5.3.y #20191029
[71406.896328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[71406.898113] kworker/0:0     D    0 16069      2 0x80004000
[71406.898203] Workqueue: cifsiod refresh_cache_worker [cifs]
[71406.898211] Call Trace:
[71406.898220]  ? __schedule+0x540/0xac0
[71406.898224]  ? firmware_map_remove+0xe9/0xe9
[71406.898228]  ? _raw_read_lock_irq+0x40/0x40
[71406.898231]  ? _raw_spin_lock+0x7a/0xd0
[71406.898234]  schedule+0x5e/0x100
[71406.898239]  schedule_preempt_disabled+0xa/0x10
[71406.898242]  __mutex_lock.isra.4+0x484/0x820
[71406.898247]  ? mutex_trylock+0x90/0x90
[71406.898251]  ? dynamic_emit_prefix+0x29/0x220
[71406.898255]  ? __dynamic_pr_debug+0xf8/0x140
[71406.898260]  ? dynamic_emit_prefix+0x220/0x220
[71406.898271]  ? update_dl_rq_load_avg+0x2c3/0x4d0
[71406.898277]  ? mutex_lock+0xce/0xe0
[71406.898280]  mutex_lock+0xce/0xe0
[71406.898283]  ? __mutex_lock_slowpath+0x10/0x10
[71406.898362]  refresh_cache_worker+0x48f/0x14a0 [cifs]
[71406.898370]  ? __switch_to_asm+0x40/0x70
[71406.898373]  ? __switch_to_asm+0x40/0x70
[71406.898376]  ? __switch_to_asm+0x34/0x70
[71406.898378]  ? __switch_to_asm+0x40/0x70
[71406.898383]  ? __switch_to_asm+0x34/0x70
[71406.898389]  ? __switch_to_asm+0x40/0x70
[71406.898467]  ? find_root_ses.isra.9+0x320/0x320 [cifs]
[71406.898472]  ? __switch_to_asm+0x40/0x70
[71406.898476]  ? __switch_to_asm+0x40/0x70
[71406.898479]  ? __switch_to_asm+0x34/0x70
[71406.898484]  ? __switch_to_asm+0x40/0x70
[71406.898488]  ? __switch_to_asm+0x34/0x70
[71406.898490]  ? __switch_to_asm+0x40/0x70
[71406.898499]  ? __switch_to_asm+0x34/0x70
[71406.898502]  ? __switch_to_asm+0x40/0x70
[71406.898505]  ? __switch_to_asm+0x40/0x70
[71406.898508]  ? __switch_to_asm+0x34/0x70
[71406.898516]  ? finish_task_switch+0xf6/0x370
[71406.898519]  ? __switch_to+0x2ec/0x5e0
[71406.898523]  ? __schedule+0x562/0xac0
[71406.898530]  ? read_word_at_a_time+0xe/0x20
[71406.898533]  ? strscpy+0xca/0x1d0
[71406.898539]  process_one_work+0x373/0x6e0
[71406.898547]  worker_thread+0x78/0x5b0
[71406.898552]  ? rescuer_thread+0x5e0/0x5e0
[71406.898555]  kthread+0x192/0x1e0
[71406.898559]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[71406.898563]  ret_from_fork+0x35/0x40
[71417.962152] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 13371 with uid: 11025
[71417.962171] fs/cifs/dir.c: name: \SOMEDIRX
[71417.962177] fs/cifs/inode.c: Update attributes: \SOMEDIRX inode 0x000000009f726d03 count 1 dentry: 0x00000000d22e461a d_time 4312598279 jiffies 4312748242
[71417.962180] fs/cifs/inode.c: Getting info on \SOMEDIRX
[71417.962367] fs/cifs/transport.c: Sending smb: smb_len=388 

Gr, Martijn
-- 
Martijn de Gouw
Designer
Prodrive Technologies
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200 
