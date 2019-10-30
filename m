Return-Path: <SRS0=jcY3=YX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4A5CA9EC5
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 19:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9396820856
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Oct 2019 19:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="zwYa2Hp2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfJ3Tdk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Oct 2019 15:33:40 -0400
Received: from mx.cjr.nz ([51.158.111.142]:32208 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfJ3Tdk (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 30 Oct 2019 15:33:40 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 25BEA81014;
        Wed, 30 Oct 2019 19:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1572464012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=orFb4P88FzibxLZNhOPdCkrxVCMafDvdN/EzbJJsylg=;
        b=zwYa2Hp2idH0Y11iolX/4QMprSVfhlg402QODPMx2/i5TmrJMpMaM5/hQVRhXt7hlil+gl
        4DIGQP09aiYX0ON+cuxWQ3lQO3tTMuVxpZP/gQXC9BSexOqsw91oQBjuilyuDwo5cEJlj2
        vs4fNvHay0MYmoetfOzWM+ahFkqRW2qNCD3cLo1oIJHP8z7ajnG413XawEa/mvgVAnQzqs
        x1yUs5lSGd5JYd1M1BOG6Rb2sObBQbDvCt4VDbUikHxgS0d9gTrjy/V7t3X3Bqsn7QjI+P
        4iQBYi7uV8E03d41TGhL/bUfuF1aZ0lAx6gdi06nlIZ8uh0XjlgvZtDuwvsVVA==
Date:   Wed, 30 Oct 2019 19:33:19 +0000
In-Reply-To: <7d19b448-1342-fd50-55ee-d2a46da6d431@prodrive-technologies.com>
References: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com> <871rveaurv.fsf@suse.com> <87a7a2ynxg.fsf@cjr.nz> <68a58b8e-3cab-093b-3098-6ee4a6dd3117@prodrive-technologies.com> <9c5eeb76-7895-5938-355f-f5d43c5affe5@prodrive-technologies.com> <87pnif4nfd.fsf@cjr.nz> <7d19b448-1342-fd50-55ee-d2a46da6d431@prodrive-technologies.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Kernel hangs in cifs_reconnect
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        =?ISO-8859-1?Q?Aur=E9lien_Aptel?= <aaptel@suse.com>,
        linux-cifs@vger.kernel.org
From:   Paulo Alcantara <pc@cjr.nz>
Message-ID: <A557F010-414C-4B98-9AD1-408054F8CC66@cjr.nz>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On October 30, 2019 7:17:25 PM UTC, Martijn de Gouw <martijn=2Ede=2Egouw@pr=
odrive-technologies=2Ecom> wrote:
>Hi Paulo,
>
>On 29-10-2019 15:49, Paulo Alcantara wrote:
>> Hi Martijn,
>>=20
>> Martijn de Gouw <martijn=2Ede=2Egouw@prodrive-technologies=2Ecom> write=
s:
>>=20
>>> Anybody any idea on what goes wrong here?
>>=20
>> Looks like an use-after-free bug in cifs_reconnect()=2E cifs superblock
>> gets freed due to automount expiration and then we dereference it in
>> dfs_cache_noreq_find()=2E
>>=20
>>> Is any of the recently posted patches related to my issue, because
>I'm
>>> more that willing to test out patches if needed=2E
>>=20
>> Could you please test it again with below patch?
>
>Again cifs stopped working, it looks more like a live/dead lock to me
>than a use-after-free=2E
>I cut the dmesg from the moment the echo to DC02 starts failing=2E
>
>[70939=2E980125] fs/cifs/smb2pdu=2Ec: In echo request
>[70939=2E980137] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[70939=2E980143] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[70960=2E106599] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
53
>with uid: 999
>[70960=2E106697] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[70960=2E116162] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[70960=2E116170] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[70960=2E116171] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[70960=2E116185] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[70960=2E116186] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[70960=2E116196] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[70960=2E116197] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4066
>[70960=2E116200] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[70960=2E116218] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4064 state=3D4
>[70960=2E116227] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4065 state=3D4
>[70960=2E116230] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4066 state=3D4
>[70960=2E116234] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[70960=2E116242] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[70960=2E116247] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[70960=2E116290] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13353) rc =3D 0
>[70960=2E116319] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
54
>with uid: 999
>[70960=2E116429] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[70960=2E116829] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[70960=2E116834] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[70960=2E116835] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[70960=2E116842] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[70960=2E116843] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[70960=2E116856] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[70960=2E116857] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 74
>[70960=2E116859] fs/cifs/smb2ops=2Ec: add 30 credits total=3D897
>[70960=2E116872] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D72
>state=3D4
>[70960=2E116874] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D73
>state=3D4
>[70960=2E116876] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D74
>state=3D4
>[70960=2E116877] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[70960=2E116882] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[70960=2E116887] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[70960=2E116954] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13354) rc =3D 0
>[71001=2E418549] fs/cifs/smb2pdu=2Ec: In echo request
>[71001=2E418565] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[71001=2E418570] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[71020=2E097059] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
55
>with uid: 999
>[71020=2E097165] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[71020=2E097760] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71020=2E097767] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71020=2E097768] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71020=2E097777] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71020=2E097778] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71020=2E097788] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71020=2E097789] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4069
>[71020=2E097796] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[71020=2E098387] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4067 state=3D4
>[71020=2E098395] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4068 state=3D4
>[71020=2E098398] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4069 state=3D4
>[71020=2E098405] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71020=2E098414] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71020=2E098419] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71020=2E098461] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13355) rc =3D 0
>[71020=2E098488] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
56
>with uid: 999
>[71020=2E098556] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[71020=2E098915] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71020=2E098921] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71020=2E098922] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71020=2E098932] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71020=2E098932] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71020=2E098942] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71020=2E098944] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 77
>[71020=2E098946] fs/cifs/smb2ops=2Ec: add 30 credits total=3D924
>[71020=2E098956] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D75
>state=3D4
>[71020=2E098958] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D76
>state=3D4
>[71020=2E098959] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D77
>state=3D4
>[71020=2E098961] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71020=2E098968] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71020=2E098973] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71020=2E099011] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13356) rc =3D 0
>[71044=2E418723] INFO: task node_exporter:7214 blocked for more than 120
>seconds=2E
>[71044=2E420037]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71044=2E421491] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71044=2E422762] node_exporter   D    0  7214      1 0x00000000
>[71044=2E422781] Call Trace:
>[71044=2E422806]  ? __schedule+0x540/0xac0
>[71044=2E422813]  ? firmware_map_remove+0xe9/0xe9
>[71044=2E422821]  ? vsnprintf+0x32c/0x870
>[71044=2E422826]  ? _raw_spin_lock+0x7a/0xd0
>[71044=2E422829]  schedule+0x5e/0x100
>[71044=2E422837]  schedule_preempt_disabled+0xa/0x10
>[71044=2E422840]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71044=2E422844]  ? mutex_trylock+0x90/0x90
>[71044=2E422848]  ? string_nocheck+0xb0/0xd0
>[71044=2E422854]  ? pointer+0x387/0x460
>[71044=2E422859]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71044=2E422863]  ? _raw_write_lock_bh+0xe0/0xe0
>[71044=2E422868]  ? mutex_lock+0xce/0xe0
>[71044=2E422871]  mutex_lock+0xce/0xe0
>[71044=2E422875]  ? __mutex_lock_slowpath+0x10/0x10
>[71044=2E422892]  ? find_nls+0x7d/0xa0
>[71044=2E422976]  smb2_reconnect=2Epart=2E21+0x218/0xbd0 [cifs]
>[71044=2E422992]  ? deref_stack_reg+0x88/0xd0
>[71044=2E422995]  ? 0xffffffffa1e00000
>[71044=2E423065]  ? SMB2_tcon+0xab0/0xab0 [cifs]
>[71044=2E423067]  ? unwind_next_frame+0x90a/0x980
>[71044=2E423070]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71044=2E423081]  ? __module_text_address+0x11/0xa0
>[71044=2E423087]  ? __is_insn_slot_addr+0x1b/0x70
>[71044=2E423094]  ? is_bpf_text_address+0xa/0x20
>[71044=2E423101]  ? kernel_text_address+0xe2/0xf0
>[71044=2E423104]  ? __kernel_text_address+0xe/0x30
>[71044=2E423108]  ? unwind_get_return_address+0x2f/0x50
>[71044=2E423114]  ? create_prof_cpu_mask+0x20/0x20
>[71044=2E423120]  ? arch_stack_walk+0x92/0xe0
>[71044=2E423125]  ? stack_trace_save+0x8a/0xb0
>[71044=2E423195]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
>[71044=2E423272]  SMB2_open_init+0x143/0x12b0 [cifs]
>[71044=2E423339]  ? cifs_statfs+0x13a/0x420 [cifs]
>[71044=2E423352]  ? statfs_by_dentry+0xa5/0xf0
>[71044=2E423354]  ? vfs_statfs+0x28/0x110
>[71044=2E423357]  ? __do_sys_statfs+0x64/0xc0
>[71044=2E423413]  ? smb2_parse_contexts+0x270/0x270 [cifs]
>[71044=2E423416]  ? _raw_write_trylock+0xe0/0xe0
>[71044=2E423419]  ? _raw_spin_lock+0x7a/0xd0
>[71044=2E423421]  ? _raw_write_trylock+0xe0/0xe0
>[71044=2E423429]  ? memset+0x1f/0x40
>[71044=2E423433]  ? stack_access_ok+0x35/0x90
>[71044=2E423437]  ? deref_stack_reg+0x88/0xd0
>[71044=2E423439]  ? stack_access_ok+0x35/0x90
>[71044=2E423442]  ? deref_stack_reg+0x88/0xd0
>[71044=2E423446]  ? __read_once_size_nocheck=2Econstprop=2E6+0x10/0x10
>[71044=2E423450]  ? put_dec_trunc8+0x73/0x110
>[71044=2E423453]  ? number+0x356/0x4b0
>[71044=2E423456]  ? widen_string+0x23/0xf0
>[71044=2E423517]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71044=2E423558]  smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71044=2E423601]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
>[71044=2E423604]  ? pointer+0x460/0x460
>[71044=2E423606]  ? kernel_text_address+0xe2/0xf0
>[71044=2E423608]  ? va_format=2Eisra=2E12+0xee/0x100
>[71044=2E423612]  ? vsnprintf+0x870/0x870
>[71044=2E423614]  ? string_nocheck+0xb0/0xd0
>[71044=2E423616]  ? pointer+0x387/0x460
>[71044=2E423619]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71044=2E423620]  ? _raw_write_lock_bh+0xe0/0xe0
>[71044=2E423622]  ? _raw_spin_lock+0x7a/0xd0
>[71044=2E423624]  ? _raw_write_trylock+0xe0/0xe0
>[71044=2E423626]  ? up+0x32/0x70
>[71044=2E423630]  ? __switch_to_asm+0x34/0x70
>[71044=2E423636]  ? dynamic_emit_prefix+0x29/0x220
>[71044=2E423684]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
>[71044=2E423735]  smb2_queryfs+0xd9/0x1c0 [cifs]
>[71044=2E423776]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
>[71044=2E423780]  ? vfs_mknod+0xc0/0x320
>[71044=2E423785]  ? map_id_up+0x12f/0x1d0
>[71044=2E423787]  ? make_kprojid+0x20/0x20
>[71044=2E423789]  ? _raw_spin_lock+0x7a/0xd0
>[71044=2E423837]  cifs_statfs+0x13a/0x420 [cifs]
>[71044=2E423844]  statfs_by_dentry+0xa5/0xf0
>[71044=2E423848]  vfs_statfs+0x28/0x110
>[71044=2E423851]  user_statfs+0x91/0xf0
>[71044=2E423853]  ? vfs_statfs+0x110/0x110
>[71044=2E423855]  ? __schedule+0x562/0xac0
>[71044=2E423857]  __do_sys_statfs+0x64/0xc0
>[71044=2E423859]  ? user_statfs+0xf0/0xf0
>[71044=2E423865]  do_syscall_64+0x73/0x190
>[71044=2E423868]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71044=2E423875] RIP: 0033:0x4a5c20
>[71044=2E423880] Code: Bad RIP value=2E
>[71044=2E423882] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX:
>0000000000000089
>[71044=2E423888] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX:
>00000000004a5c20
>[71044=2E423890] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI:
>000000c0001c43c0
>[71044=2E423892] RBP: 000000c0003414f0 R08: 0000000000000000 R09:
>0000000000000000
>[71044=2E423893] R10: 0000000000000000 R11: 0000000000000206 R12:
>ffffffffffffffff
>[71044=2E423894] R13: 000000000000001f R14: 000000000000001e R15:
>0000000000000100
>[71044=2E423926] INFO: task cifsd:9136 blocked for more than 120 seconds=
=2E
>[71044=2E425076]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71044=2E426421] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71044=2E427718] cifsd           D    0  9136      2 0x80004000
>[71044=2E427721] Call Trace:
>[71044=2E427738]  ? __schedule+0x540/0xac0
>[71044=2E427745]  ? firmware_map_remove+0xe9/0xe9
>[71044=2E427752]  ? _raw_spin_lock+0x7a/0xd0
>[71044=2E427757]  schedule+0x5e/0x100
>[71044=2E427765]  schedule_preempt_disabled+0xa/0x10
>[71044=2E427775]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71044=2E427781]  ? mutex_trylock+0x90/0x90
>[71044=2E427787]  ? irq_work_claim+0x2e/0x50
>[71044=2E427792]  ? vprintk_emit+0x11d/0x2e0
>[71044=2E427795]  ? mutex_lock+0xce/0xe0
>[71044=2E427797]  mutex_lock+0xce/0xe0
>[71044=2E427800]  ? __mutex_lock_slowpath+0x10/0x10
>[71044=2E427877]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
>[71044=2E427951]  cifs_reconnect+0x18c/0x1510 [cifs]
>[71044=2E427970]  ? ___ratelimit+0x106/0x190
>[71044=2E428050]  ? smb2_calc_size+0x15c/0x250 [cifs]
>[71044=2E428107]  ? extract_hostname+0xa0/0xa0 [cifs]
>[71044=2E428121]  ? _raw_spin_trylock+0x91/0xe0
>[71044=2E428129]  ? _raw_spin_trylock_bh+0x100/0x100
>[71044=2E428134]  ? ___ratelimit+0x106/0x190
>[71044=2E428179]  cifs_handle_standard+0x252/0x270 [cifs]
>[71044=2E428224]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
>[71044=2E428267]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71044=2E428272]  ? __switch_to_asm+0x40/0x70
>[71044=2E428276]  ? __switch_to_asm+0x34/0x70
>[71044=2E428278]  ? __switch_to_asm+0x40/0x70
>[71044=2E428280]  ? __switch_to_asm+0x34/0x70
>[71044=2E428281]  ? __switch_to_asm+0x40/0x70
>[71044=2E428283]  ? __switch_to_asm+0x34/0x70
>[71044=2E428284]  ? __switch_to_asm+0x40/0x70
>[71044=2E428286]  ? __switch_to_asm+0x34/0x70
>[71044=2E428287]  ? __switch_to_asm+0x40/0x70
>[71044=2E428289]  ? __switch_to_asm+0x34/0x70
>[71044=2E428290]  ? __switch_to_asm+0x40/0x70
>[71044=2E428292]  ? __switch_to_asm+0x34/0x70
>[71044=2E428293]  ? __switch_to_asm+0x40/0x70
>[71044=2E428295]  ? __switch_to_asm+0x34/0x70
>[71044=2E428296]  ? __switch_to_asm+0x40/0x70
>[71044=2E428298]  ? __switch_to_asm+0x34/0x70
>[71044=2E428299]  ? __switch_to_asm+0x40/0x70
>[71044=2E428301]  ? __switch_to_asm+0x34/0x70
>[71044=2E428303]  ? __switch_to_asm+0x40/0x70
>[71044=2E428304]  ? __switch_to_asm+0x34/0x70
>[71044=2E428306]  ? __switch_to_asm+0x40/0x70
>[71044=2E428307]  ? __switch_to_asm+0x34/0x70
>[71044=2E428309]  ? __switch_to_asm+0x40/0x70
>[71044=2E428310]  ? __switch_to_asm+0x34/0x70
>[71044=2E428312]  ? __switch_to_asm+0x40/0x70
>[71044=2E428313]  ? __switch_to_asm+0x34/0x70
>[71044=2E428317]  ? finish_task_switch+0xf6/0x370
>[71044=2E428319]  ? __switch_to+0x2ec/0x5e0
>[71044=2E428321]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71044=2E428323]  ? _raw_write_lock_bh+0xe0/0xe0
>[71044=2E428375]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71044=2E428378]  kthread+0x192/0x1e0
>[71044=2E428381]  ? kthread_create_worker_on_cpu+0xc0/0xc0
>[71044=2E428384]  ret_from_fork+0x35/0x40
>[71062=2E848999] fs/cifs/smb2pdu=2Ec: In echo request
>[71062=2E849014] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[71062=2E849025] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[71080=2E092803] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
57
>with uid: 999
>[71080=2E092915] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[71080=2E097568] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71080=2E097580] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71080=2E097581] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71080=2E097591] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71080=2E097592] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71080=2E097601] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71080=2E097603] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4072
>[71080=2E097605] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[71080=2E097741] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4070 state=3D4
>[71080=2E097749] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4071 state=3D4
>[71080=2E097752] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4072 state=3D4
>[71080=2E097758] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71080=2E097767] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71080=2E097771] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71080=2E097812] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13357) rc =3D 0
>[71080=2E097992] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
58
>with uid: 999
>[71080=2E098070] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[71080=2E098487] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71080=2E098492] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71080=2E098493] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71080=2E098500] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71080=2E098501] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71080=2E098510] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71080=2E098512] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 80
>[71080=2E098514] fs/cifs/smb2ops=2Ec: add 30 credits total=3D951
>[71080=2E098609] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D78
>state=3D4
>[71080=2E098610] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D79
>state=3D4
>[71080=2E098612] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D80
>state=3D4
>[71080=2E098613] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71080=2E098619] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71080=2E098624] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71080=2E098655] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13358) rc =3D 0
>[71105=2E853107] fs/cifs/connect=2Ec: Existing tcp session with server
>found
>[71105=2E853114] fs/cifs/dfs_cache=2Ec: CIFS VFS: in do_refresh_tcon as
>Xid: 13359 with uid: 0
>[71116=2E587766] fs/cifs/inode=2Ec: CIFS VFS: in
>cifs_revalidate_dentry_attr as Xid: 13360 with uid: 11025
>[71116=2E587834] fs/cifs/dir=2Ec: name: \SOMEDIRX
>[71116=2E587842] fs/cifs/inode=2Ec: Update attributes: \SOMEDIRX inode
>0x000000009f726d03 count 1 dentry: 0x00000000d22e461a d_time 4312598279
>jiffies 4312672891
>[71116=2E587847] fs/cifs/inode=2Ec: Getting info on \SOMEDIRX
>[71116=2E588001] fs/cifs/transport=2Ec: Sending smb: smb_len=3D388
>[71124=2E283416] fs/cifs/smb2pdu=2Ec: In echo request
>[71124=2E283434] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[71124=2E283442] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[71140=2E087648] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
61
>with uid: 999
>[71140=2E087743] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[71140=2E088088] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71140=2E088095] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71140=2E088096] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71140=2E088106] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71140=2E088107] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71140=2E088116] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71140=2E088118] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4075
>[71140=2E088120] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[71140=2E088137] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4073 state=3D4
>[71140=2E088141] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4074 state=3D4
>[71140=2E088144] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4075 state=3D4
>[71140=2E088147] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71140=2E088153] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71140=2E088158] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71140=2E088190] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13361) rc =3D 0
>[71140=2E088218] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
62
>with uid: 999
>[71140=2E088304] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[71140=2E088643] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71140=2E088647] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71140=2E088648] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71140=2E088655] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71140=2E088656] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71140=2E088664] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71140=2E088665] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 83
>[71140=2E088667] fs/cifs/smb2ops=2Ec: add 30 credits total=3D978
>[71140=2E088680] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D81
>state=3D4
>[71140=2E088682] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D82
>state=3D4
>[71140=2E088684] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D83
>state=3D4
>[71140=2E088686] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71140=2E088692] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71140=2E088696] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71140=2E088728] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13362) rc =3D 0
>[71165=2E239724] INFO: task node_exporter:7214 blocked for more than 241
>seconds=2E
>[71165=2E240866]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71165=2E241935] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71165=2E243018] node_exporter   D    0  7214      1 0x00000000
>[71165=2E243022] Call Trace:
>[71165=2E243028]  ? __schedule+0x540/0xac0
>[71165=2E243031]  ? firmware_map_remove+0xe9/0xe9
>[71165=2E243035]  ? vsnprintf+0x32c/0x870
>[71165=2E243038]  ? _raw_spin_lock+0x7a/0xd0
>[71165=2E243040]  schedule+0x5e/0x100
>[71165=2E243042]  schedule_preempt_disabled+0xa/0x10
>[71165=2E243044]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71165=2E243047]  ? mutex_trylock+0x90/0x90
>[71165=2E243049]  ? string_nocheck+0xb0/0xd0
>[71165=2E243051]  ? pointer+0x387/0x460
>[71165=2E243054]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71165=2E243056]  ? _raw_write_lock_bh+0xe0/0xe0
>[71165=2E243059]  ? mutex_lock+0xce/0xe0
>[71165=2E243060]  mutex_lock+0xce/0xe0
>[71165=2E243062]  ? __mutex_lock_slowpath+0x10/0x10
>[71165=2E243065]  ? find_nls+0x7d/0xa0
>[71165=2E243133]  smb2_reconnect=2Epart=2E21+0x218/0xbd0 [cifs]
>[71165=2E243137]  ? deref_stack_reg+0x88/0xd0
>[71165=2E243139]  ? 0xffffffffa1e00000
>[71165=2E243180]  ? SMB2_tcon+0xab0/0xab0 [cifs]
>[71165=2E243181]  ? unwind_next_frame+0x90a/0x980
>[71165=2E243183]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71165=2E243187]  ? __module_text_address+0x11/0xa0
>[71165=2E243189]  ? __is_insn_slot_addr+0x1b/0x70
>[71165=2E243193]  ? is_bpf_text_address+0xa/0x20
>[71165=2E243195]  ? kernel_text_address+0xe2/0xf0
>[71165=2E243197]  ? __kernel_text_address+0xe/0x30
>[71165=2E243200]  ? unwind_get_return_address+0x2f/0x50
>[71165=2E243203]  ? create_prof_cpu_mask+0x20/0x20
>[71165=2E243207]  ? arch_stack_walk+0x92/0xe0
>[71165=2E243210]  ? stack_trace_save+0x8a/0xb0
>[71165=2E243251]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
>[71165=2E243294]  SMB2_open_init+0x143/0x12b0 [cifs]
>[71165=2E243332]  ? cifs_statfs+0x13a/0x420 [cifs]
>[71165=2E243336]  ? statfs_by_dentry+0xa5/0xf0
>[71165=2E243338]  ? vfs_statfs+0x28/0x110
>[71165=2E243340]  ? __do_sys_statfs+0x64/0xc0
>[71165=2E243382]  ? smb2_parse_contexts+0x270/0x270 [cifs]
>[71165=2E243384]  ? _raw_write_trylock+0xe0/0xe0
>[71165=2E243385]  ? _raw_spin_lock+0x7a/0xd0
>[71165=2E243387]  ? _raw_write_trylock+0xe0/0xe0
>[71165=2E243389]  ? memset+0x1f/0x40
>[71165=2E243391]  ? stack_access_ok+0x35/0x90
>[71165=2E243393]  ? deref_stack_reg+0x88/0xd0
>[71165=2E243396]  ? stack_access_ok+0x35/0x90
>[71165=2E243399]  ? deref_stack_reg+0x88/0xd0
>[71165=2E243402]  ? __read_once_size_nocheck=2Econstprop=2E6+0x10/0x10
>[71165=2E243404]  ? put_dec_trunc8+0x73/0x110
>[71165=2E243406]  ? number+0x356/0x4b0
>[71165=2E243408]  ? widen_string+0x23/0xf0
>[71165=2E243449]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71165=2E243490]  smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71165=2E243533]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
>[71165=2E243535]  ? pointer+0x460/0x460
>[71165=2E243537]  ? kernel_text_address+0xe2/0xf0
>[71165=2E243539]  ? va_format=2Eisra=2E12+0xee/0x100
>[71165=2E243541]  ? vsnprintf+0x870/0x870
>[71165=2E243543]  ? string_nocheck+0xb0/0xd0
>[71165=2E243545]  ? pointer+0x387/0x460
>[71165=2E243547]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71165=2E243549]  ? _raw_write_lock_bh+0xe0/0xe0
>[71165=2E243551]  ? _raw_spin_lock+0x7a/0xd0
>[71165=2E243552]  ? _raw_write_trylock+0xe0/0xe0
>[71165=2E243555]  ? up+0x32/0x70
>[71165=2E243558]  ? __switch_to_asm+0x34/0x70
>[71165=2E243561]  ? dynamic_emit_prefix+0x29/0x220
>[71165=2E243602]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
>[71165=2E243644]  smb2_queryfs+0xd9/0x1c0 [cifs]
>[71165=2E243688]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
>[71165=2E243764]  ? vfs_mknod+0xc0/0x320
>[71165=2E243770]  ? map_id_up+0x12f/0x1d0
>[71165=2E243774]  ? make_kprojid+0x20/0x20
>[71165=2E243777]  ? _raw_spin_lock+0x7a/0xd0
>[71165=2E243818]  cifs_statfs+0x13a/0x420 [cifs]
>[71165=2E243825]  statfs_by_dentry+0xa5/0xf0
>[71165=2E243829]  vfs_statfs+0x28/0x110
>[71165=2E243835]  user_statfs+0x91/0xf0
>[71165=2E243838]  ? vfs_statfs+0x110/0x110
>[71165=2E243844]  ? __schedule+0x562/0xac0
>[71165=2E243847]  __do_sys_statfs+0x64/0xc0
>[71165=2E243854]  ? user_statfs+0xf0/0xf0
>[71165=2E243859]  do_syscall_64+0x73/0x190
>[71165=2E243863]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71165=2E243866] RIP: 0033:0x4a5c20
>[71165=2E243873] Code: Bad RIP value=2E
>[71165=2E243876] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX:
>0000000000000089
>[71165=2E243881] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX:
>00000000004a5c20
>[71165=2E243883] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI:
>000000c0001c43c0
>[71165=2E243885] RBP: 000000c0003414f0 R08: 0000000000000000 R09:
>0000000000000000
>[71165=2E243886] R10: 0000000000000000 R11: 0000000000000206 R12:
>ffffffffffffffff
>[71165=2E243887] R13: 000000000000001f R14: 000000000000001e R15:
>0000000000000100
>[71165=2E243905] INFO: task cifsd:9136 blocked for more than 241 seconds=
=2E
>[71165=2E245022]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71165=2E246156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71165=2E247272] cifsd           D    0  9136      2 0x80004000
>[71165=2E247274] Call Trace:
>[71165=2E247281]  ? __schedule+0x540/0xac0
>[71165=2E247284]  ? firmware_map_remove+0xe9/0xe9
>[71165=2E247287]  ? _raw_spin_lock+0x7a/0xd0
>[71165=2E247289]  schedule+0x5e/0x100
>[71165=2E247291]  schedule_preempt_disabled+0xa/0x10
>[71165=2E247293]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71165=2E247296]  ? mutex_trylock+0x90/0x90
>[71165=2E247300]  ? irq_work_claim+0x2e/0x50
>[71165=2E247303]  ? vprintk_emit+0x11d/0x2e0
>[71165=2E247305]  ? mutex_lock+0xce/0xe0
>[71165=2E247306]  mutex_lock+0xce/0xe0
>[71165=2E247308]  ? __mutex_lock_slowpath+0x10/0x10
>[71165=2E247358]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
>[71165=2E247398]  cifs_reconnect+0x18c/0x1510 [cifs]
>[71165=2E247402]  ? ___ratelimit+0x106/0x190
>[71165=2E247444]  ? smb2_calc_size+0x15c/0x250 [cifs]
>[71165=2E247484]  ? extract_hostname+0xa0/0xa0 [cifs]
>[71165=2E247486]  ? _raw_spin_trylock+0x91/0xe0
>[71165=2E247487]  ? _raw_spin_trylock_bh+0x100/0x100
>[71165=2E247490]  ? ___ratelimit+0x106/0x190
>[71165=2E247533]  cifs_handle_standard+0x252/0x270 [cifs]
>[71165=2E247575]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
>[71165=2E247616]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71165=2E247618]  ? __switch_to_asm+0x40/0x70
>[71165=2E247620]  ? __switch_to_asm+0x34/0x70
>[71165=2E247621]  ? __switch_to_asm+0x40/0x70
>[71165=2E247623]  ? __switch_to_asm+0x34/0x70
>[71165=2E247624]  ? __switch_to_asm+0x40/0x70
>[71165=2E247626]  ? __switch_to_asm+0x34/0x70
>[71165=2E247627]  ? __switch_to_asm+0x40/0x70
>[71165=2E247629]  ? __switch_to_asm+0x34/0x70
>[71165=2E247630]  ? __switch_to_asm+0x40/0x70
>[71165=2E247632]  ? __switch_to_asm+0x34/0x70
>[71165=2E247633]  ? __switch_to_asm+0x40/0x70
>[71165=2E247635]  ? __switch_to_asm+0x34/0x70
>[71165=2E247637]  ? __switch_to_asm+0x40/0x70
>[71165=2E247638]  ? __switch_to_asm+0x34/0x70
>[71165=2E247640]  ? __switch_to_asm+0x40/0x70
>[71165=2E247641]  ? __switch_to_asm+0x34/0x70
>[71165=2E247643]  ? __switch_to_asm+0x40/0x70
>[71165=2E247644]  ? __switch_to_asm+0x34/0x70
>[71165=2E247646]  ? __switch_to_asm+0x40/0x70
>[71165=2E247647]  ? __switch_to_asm+0x34/0x70
>[71165=2E247649]  ? __switch_to_asm+0x40/0x70
>[71165=2E247651]  ? __switch_to_asm+0x34/0x70
>[71165=2E247653]  ? __switch_to_asm+0x40/0x70
>[71165=2E247659]  ? __switch_to_asm+0x34/0x70
>[71165=2E247678]  ? __switch_to_asm+0x40/0x70
>[71165=2E247680]  ? __switch_to_asm+0x34/0x70
>[71165=2E247683]  ? finish_task_switch+0xf6/0x370
>[71165=2E247685]  ? __switch_to+0x2ec/0x5e0
>[71165=2E247688]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71165=2E247690]  ? _raw_write_lock_bh+0xe0/0xe0
>[71165=2E247731]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71165=2E247735]  kthread+0x192/0x1e0
>[71165=2E247737]  ? kthread_create_worker_on_cpu+0xc0/0xc0
>[71165=2E247739]  ret_from_fork+0x35/0x40
>[71185=2E717885] fs/cifs/smb2pdu=2Ec: In echo request
>[71185=2E717900] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[71185=2E717906] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[71200=2E086057] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
63
>with uid: 999
>[71200=2E086149] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[71200=2E086716] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71200=2E086725] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71200=2E086726] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71200=2E086740] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71200=2E086741] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71200=2E086751] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71200=2E086752] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4078
>[71200=2E086755] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[71200=2E086770] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4076 state=3D4
>[71200=2E086775] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4077 state=3D4
>[71200=2E086777] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4078 state=3D4
>[71200=2E086781] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71200=2E086786] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71200=2E086791] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71200=2E086824] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13363) rc =3D 0
>[71200=2E086841] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
64
>with uid: 999
>[71200=2E086938] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[71200=2E087336] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71200=2E087342] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71200=2E087343] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71200=2E087352] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71200=2E087353] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71200=2E087362] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71200=2E087364] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 86
>[71200=2E087366] fs/cifs/smb2ops=2Ec: add 30 credits total=3D1005
>[71200=2E087379] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D84
>state=3D4
>[71200=2E087381] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D85
>state=3D4
>[71200=2E087383] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D86
>state=3D4
>[71200=2E087384] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71200=2E087391] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71200=2E087395] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71200=2E087428] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13364) rc =3D 0
>[71247=2E152290] fs/cifs/smb2pdu=2Ec: In echo request
>[71247=2E152306] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[71247=2E152313] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[71260=2E080476] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
65
>with uid: 999
>[71260=2E080564] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[71260=2E080923] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71260=2E080931] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71260=2E080932] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71260=2E080946] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71260=2E080947] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71260=2E080958] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71260=2E080959] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4081
>[71260=2E080962] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[71260=2E080975] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4079 state=3D4
>[71260=2E080979] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4080 state=3D4
>[71260=2E080982] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4081 state=3D4
>[71260=2E080985] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71260=2E080991] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71260=2E080996] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71260=2E081032] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13365) rc =3D 0
>[71260=2E081163] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
66
>with uid: 999
>[71260=2E081228] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[71260=2E081798] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71260=2E081804] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71260=2E081805] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71260=2E081814] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71260=2E081814] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71260=2E081824] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71260=2E081826] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 89
>[71260=2E081828] fs/cifs/smb2ops=2Ec: add 30 credits total=3D1032
>[71260=2E081841] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D87
>state=3D4
>[71260=2E081843] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D88
>state=3D4
>[71260=2E081845] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D89
>state=3D4
>[71260=2E081847] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71260=2E081854] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71260=2E081904] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71260=2E081936] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13366) rc =3D 0
>[71286=2E060785] INFO: task node_exporter:7214 blocked for more than 362
>seconds=2E
>[71286=2E061989]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71286=2E063131] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71286=2E064284] node_exporter   D    0  7214      1 0x00000000
>[71286=2E064287] Call Trace:
>[71286=2E064294]  ? __schedule+0x540/0xac0
>[71286=2E064297]  ? firmware_map_remove+0xe9/0xe9
>[71286=2E064301]  ? vsnprintf+0x32c/0x870
>[71286=2E064304]  ? _raw_spin_lock+0x7a/0xd0
>[71286=2E064306]  schedule+0x5e/0x100
>[71286=2E064308]  schedule_preempt_disabled+0xa/0x10
>[71286=2E064310]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71286=2E064312]  ? mutex_trylock+0x90/0x90
>[71286=2E064315]  ? string_nocheck+0xb0/0xd0
>[71286=2E064317]  ? pointer+0x387/0x460
>[71286=2E064319]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71286=2E064321]  ? _raw_write_lock_bh+0xe0/0xe0
>[71286=2E064324]  ? mutex_lock+0xce/0xe0
>[71286=2E064325]  mutex_lock+0xce/0xe0
>[71286=2E064327]  ? __mutex_lock_slowpath+0x10/0x10
>[71286=2E064331]  ? find_nls+0x7d/0xa0
>[71286=2E064381]  smb2_reconnect=2Epart=2E21+0x218/0xbd0 [cifs]
>[71286=2E064386]  ? deref_stack_reg+0x88/0xd0
>[71286=2E064392]  ? 0xffffffffa1e00000
>[71286=2E064434]  ? SMB2_tcon+0xab0/0xab0 [cifs]
>[71286=2E064436]  ? unwind_next_frame+0x90a/0x980
>[71286=2E064438]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71286=2E064442]  ? __module_text_address+0x11/0xa0
>[71286=2E064444]  ? __is_insn_slot_addr+0x1b/0x70
>[71286=2E064447]  ? is_bpf_text_address+0xa/0x20
>[71286=2E064450]  ? kernel_text_address+0xe2/0xf0
>[71286=2E064451]  ? __kernel_text_address+0xe/0x30
>[71286=2E064454]  ? unwind_get_return_address+0x2f/0x50
>[71286=2E064457]  ? create_prof_cpu_mask+0x20/0x20
>[71286=2E064460]  ? arch_stack_walk+0x92/0xe0
>[71286=2E064463]  ? stack_trace_save+0x8a/0xb0
>[71286=2E064505]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
>[71286=2E064548]  SMB2_open_init+0x143/0x12b0 [cifs]
>[71286=2E064586]  ? cifs_statfs+0x13a/0x420 [cifs]
>[71286=2E064590]  ? statfs_by_dentry+0xa5/0xf0
>[71286=2E064592]  ? vfs_statfs+0x28/0x110
>[71286=2E064594]  ? __do_sys_statfs+0x64/0xc0
>[71286=2E064636]  ? smb2_parse_contexts+0x270/0x270 [cifs]
>[71286=2E064638]  ? _raw_write_trylock+0xe0/0xe0
>[71286=2E064640]  ? _raw_spin_lock+0x7a/0xd0
>[71286=2E064641]  ? _raw_write_trylock+0xe0/0xe0
>[71286=2E064643]  ? memset+0x1f/0x40
>[71286=2E064646]  ? stack_access_ok+0x35/0x90
>[71286=2E064648]  ? deref_stack_reg+0x88/0xd0
>[71286=2E064650]  ? stack_access_ok+0x35/0x90
>[71286=2E064652]  ? deref_stack_reg+0x88/0xd0
>[71286=2E064654]  ? __read_once_size_nocheck=2Econstprop=2E6+0x10/0x10
>[71286=2E064656]  ? put_dec_trunc8+0x73/0x110
>[71286=2E064658]  ? number+0x356/0x4b0
>[71286=2E064660]  ? widen_string+0x23/0xf0
>[71286=2E064705]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71286=2E064770]  smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71286=2E064817]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
>[71286=2E064821]  ? pointer+0x460/0x460
>[71286=2E064827]  ? kernel_text_address+0xe2/0xf0
>[71286=2E064835]  ? va_format=2Eisra=2E12+0xee/0x100
>[71286=2E064841]  ? vsnprintf+0x870/0x870
>[71286=2E064854]  ? string_nocheck+0xb0/0xd0
>[71286=2E064869]  ? pointer+0x387/0x460
>[71286=2E064875]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71286=2E064886]  ? _raw_write_lock_bh+0xe0/0xe0
>[71286=2E064888]  ? _raw_spin_lock+0x7a/0xd0
>[71286=2E064889]  ? _raw_write_trylock+0xe0/0xe0
>[71286=2E064892]  ? up+0x32/0x70
>[71286=2E064896]  ? __switch_to_asm+0x34/0x70
>[71286=2E064898]  ? dynamic_emit_prefix+0x29/0x220
>[71286=2E064940]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
>[71286=2E064982]  smb2_queryfs+0xd9/0x1c0 [cifs]
>[71286=2E065029]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
>[71286=2E065035]  ? vfs_mknod+0xc0/0x320
>[71286=2E065038]  ? map_id_up+0x12f/0x1d0
>[71286=2E065040]  ? make_kprojid+0x20/0x20
>[71286=2E065042]  ? _raw_spin_lock+0x7a/0xd0
>[71286=2E065081]  cifs_statfs+0x13a/0x420 [cifs]
>[71286=2E065088]  statfs_by_dentry+0xa5/0xf0
>[71286=2E065091]  vfs_statfs+0x28/0x110
>[71286=2E065093]  user_statfs+0x91/0xf0
>[71286=2E065095]  ? vfs_statfs+0x110/0x110
>[71286=2E065099]  ? __schedule+0x562/0xac0
>[71286=2E065103]  __do_sys_statfs+0x64/0xc0
>[71286=2E065105]  ? user_statfs+0xf0/0xf0
>[71286=2E065109]  do_syscall_64+0x73/0x190
>[71286=2E065112]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71286=2E065116] RIP: 0033:0x4a5c20
>[71286=2E065121] Code: Bad RIP value=2E
>[71286=2E065122] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX:
>0000000000000089
>[71286=2E065125] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX:
>00000000004a5c20
>[71286=2E065127] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI:
>000000c0001c43c0
>[71286=2E065131] RBP: 000000c0003414f0 R08: 0000000000000000 R09:
>0000000000000000
>[71286=2E065133] R10: 0000000000000000 R11: 0000000000000206 R12:
>ffffffffffffffff
>[71286=2E065134] R13: 000000000000001f R14: 000000000000001e R15:
>0000000000000100
>[71286=2E065156] INFO: task cifsd:9136 blocked for more than 362 seconds=
=2E
>[71286=2E066326]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71286=2E068159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71286=2E069395] cifsd           D    0  9136      2 0x80004000
>[71286=2E069399] Call Trace:
>[71286=2E069405]  ? __schedule+0x540/0xac0
>[71286=2E069408]  ? firmware_map_remove+0xe9/0xe9
>[71286=2E069411]  ? _raw_spin_lock+0x7a/0xd0
>[71286=2E069413]  schedule+0x5e/0x100
>[71286=2E069416]  schedule_preempt_disabled+0xa/0x10
>[71286=2E069417]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71286=2E069420]  ? mutex_trylock+0x90/0x90
>[71286=2E069424]  ? irq_work_claim+0x2e/0x50
>[71286=2E069427]  ? vprintk_emit+0x11d/0x2e0
>[71286=2E069430]  ? mutex_lock+0xce/0xe0
>[71286=2E069431]  mutex_lock+0xce/0xe0
>[71286=2E069433]  ? __mutex_lock_slowpath+0x10/0x10
>[71286=2E069485]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
>[71286=2E069526]  cifs_reconnect+0x18c/0x1510 [cifs]
>[71286=2E069530]  ? ___ratelimit+0x106/0x190
>[71286=2E069572]  ? smb2_calc_size+0x15c/0x250 [cifs]
>[71286=2E069611]  ? extract_hostname+0xa0/0xa0 [cifs]
>[71286=2E069613]  ? _raw_spin_trylock+0x91/0xe0
>[71286=2E069615]  ? _raw_spin_trylock_bh+0x100/0x100
>[71286=2E069617]  ? ___ratelimit+0x106/0x190
>[71286=2E069657]  cifs_handle_standard+0x252/0x270 [cifs]
>[71286=2E069697]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
>[71286=2E069737]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71286=2E069739]  ? __switch_to_asm+0x40/0x70
>[71286=2E069741]  ? __switch_to_asm+0x34/0x70
>[71286=2E069742]  ? __switch_to_asm+0x40/0x70
>[71286=2E069744]  ? __switch_to_asm+0x34/0x70
>[71286=2E069746]  ? __switch_to_asm+0x40/0x70
>[71286=2E069748]  ? __switch_to_asm+0x34/0x70
>[71286=2E069750]  ? __switch_to_asm+0x40/0x70
>[71286=2E069752]  ? __switch_to_asm+0x34/0x70
>[71286=2E069753]  ? __switch_to_asm+0x40/0x70
>[71286=2E069755]  ? __switch_to_asm+0x34/0x70
>[71286=2E069756]  ? __switch_to_asm+0x40/0x70
>[71286=2E069758]  ? __switch_to_asm+0x34/0x70
>[71286=2E069759]  ? __switch_to_asm+0x40/0x70
>[71286=2E069761]  ? __switch_to_asm+0x34/0x70
>[71286=2E069762]  ? __switch_to_asm+0x40/0x70
>[71286=2E069764]  ? __switch_to_asm+0x34/0x70
>[71286=2E069765]  ? __switch_to_asm+0x40/0x70
>[71286=2E069767]  ? __switch_to_asm+0x34/0x70
>[71286=2E069768]  ? __switch_to_asm+0x40/0x70
>[71286=2E069770]  ? __switch_to_asm+0x34/0x70
>[71286=2E069772]  ? __switch_to_asm+0x40/0x70
>[71286=2E069773]  ? __switch_to_asm+0x34/0x70
>[71286=2E069775]  ? __switch_to_asm+0x40/0x70
>[71286=2E069776]  ? __switch_to_asm+0x34/0x70
>[71286=2E069778]  ? __switch_to_asm+0x40/0x70
>[71286=2E069779]  ? __switch_to_asm+0x34/0x70
>[71286=2E069782]  ? finish_task_switch+0xf6/0x370
>[71286=2E069784]  ? __switch_to+0x2ec/0x5e0
>[71286=2E069786]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71286=2E069788]  ? _raw_write_lock_bh+0xe0/0xe0
>[71286=2E069828]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71286=2E069830]  kthread+0x192/0x1e0
>[71286=2E069832]  ? kthread_create_worker_on_cpu+0xc0/0xc0
>[71286=2E069834]  ret_from_fork+0x35/0x40
>[71286=2E069842] INFO: task kworker/0:0:16069 blocked for more than 120
>seconds=2E
>[71286=2E071059]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71286=2E072279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71286=2E073534] kworker/0:0     D    0 16069      2 0x80004000
>[71286=2E073585] Workqueue: cifsiod refresh_cache_worker [cifs]
>[71286=2E073586] Call Trace:
>[71286=2E073590]  ? __schedule+0x540/0xac0
>[71286=2E073592]  ? firmware_map_remove+0xe9/0xe9
>[71286=2E073595]  ? _raw_read_lock_irq+0x40/0x40
>[71286=2E073597]  ? _raw_spin_lock+0x7a/0xd0
>[71286=2E073599]  schedule+0x5e/0x100
>[71286=2E073601]  schedule_preempt_disabled+0xa/0x10
>[71286=2E073603]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71286=2E073606]  ? mutex_trylock+0x90/0x90
>[71286=2E073609]  ? dynamic_emit_prefix+0x29/0x220
>[71286=2E073610]  ? __dynamic_pr_debug+0xf8/0x140
>[71286=2E073612]  ? dynamic_emit_prefix+0x220/0x220
>[71286=2E073618]  ? update_dl_rq_load_avg+0x2c3/0x4d0
>[71286=2E073620]  ? mutex_lock+0xce/0xe0
>[71286=2E073621]  mutex_lock+0xce/0xe0
>[71286=2E073623]  ? __mutex_lock_slowpath+0x10/0x10
>[71286=2E073665]  refresh_cache_worker+0x48f/0x14a0 [cifs]
>[71286=2E073668]  ? __switch_to_asm+0x40/0x70
>[71286=2E073670]  ? __switch_to_asm+0x40/0x70
>[71286=2E073672]  ? __switch_to_asm+0x34/0x70
>[71286=2E073673]  ? __switch_to_asm+0x40/0x70
>[71286=2E073675]  ? __switch_to_asm+0x34/0x70
>[71286=2E073676]  ? __switch_to_asm+0x40/0x70
>[71286=2E073718]  ? find_root_ses=2Eisra=2E9+0x320/0x320 [cifs]
>[71286=2E073720]  ? __switch_to_asm+0x40/0x70
>[71286=2E073722]  ? __switch_to_asm+0x40/0x70
>[71286=2E073723]  ? __switch_to_asm+0x34/0x70
>[71286=2E073725]  ? __switch_to_asm+0x40/0x70
>[71286=2E073728]  ? __switch_to_asm+0x34/0x70
>[71286=2E073729]  ? __switch_to_asm+0x40/0x70
>[71286=2E073731]  ? __switch_to_asm+0x34/0x70
>[71286=2E073732]  ? __switch_to_asm+0x40/0x70
>[71286=2E073734]  ? __switch_to_asm+0x40/0x70
>[71286=2E073736]  ? __switch_to_asm+0x34/0x70
>[71286=2E073738]  ? finish_task_switch+0xf6/0x370
>[71286=2E073741]  ? __switch_to+0x2ec/0x5e0
>[71286=2E073742]  ? __schedule+0x562/0xac0
>[71286=2E073745]  ? read_word_at_a_time+0xe/0x20
>[71286=2E073747]  ? strscpy+0xca/0x1d0
>[71286=2E073753]  process_one_work+0x373/0x6e0
>[71286=2E073756]  worker_thread+0x78/0x5b0
>[71286=2E073759]  ? rescuer_thread+0x5e0/0x5e0
>[71286=2E073760]  kthread+0x192/0x1e0
>[71286=2E073762]  ? kthread_create_worker_on_cpu+0xc0/0xc0
>[71286=2E073764]  ret_from_fork+0x35/0x40
>[71308=2E590706] fs/cifs/smb2pdu=2Ec: In echo request
>[71308=2E590730] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[71308=2E590743] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[71320=2E544886] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
67
>with uid: 999
>[71320=2E544989] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[71320=2E545462] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71320=2E545477] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71320=2E545479] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71320=2E545495] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71320=2E545496] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71320=2E545512] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71320=2E545515] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4084
>[71320=2E545517] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[71320=2E545533] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4082 state=3D4
>[71320=2E545539] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4083 state=3D4
>[71320=2E545542] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4084 state=3D4
>[71320=2E545548] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71320=2E545555] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71320=2E545559] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71320=2E545620] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13367) rc =3D 0
>[71320=2E548354] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
68
>with uid: 999
>[71320=2E548525] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[71320=2E548816] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71320=2E548826] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71320=2E548828] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71320=2E548844] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71320=2E548846] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71320=2E548864] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71320=2E548867] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 92
>[71320=2E548870] fs/cifs/smb2ops=2Ec: add 30 credits total=3D1059
>[71320=2E548887] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D90
>state=3D4
>[71320=2E548890] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D91
>state=3D4
>[71320=2E548891] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D92
>state=3D4
>[71320=2E548893] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71320=2E548900] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71320=2E548904] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71320=2E548937] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13368) rc =3D 0
>[71370=2E021141] fs/cifs/smb2pdu=2Ec: In echo request
>[71370=2E021164] fs/cifs/smb2pdu=2Ec: Echo request failed: -11
>[71370=2E021172] fs/cifs/connect=2Ec: Unable to send echo request to
>server: DC02
>[71380=2E065094] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
69
>with uid: 999
>[71380=2E065186] fs/cifs/transport=2Ec: Sending smb: smb_len=3D372
>[71380=2E065747] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71380=2E065757] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71380=2E065758] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71380=2E065771] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71380=2E065773] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71380=2E065786] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71380=2E065789] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 4087
>[71380=2E065792] fs/cifs/smb2ops=2Ec: add 3 credits total=3D512
>[71380=2E065826] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5
>mid=3D4085 state=3D4
>[71380=2E065831] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16
>mid=3D4086 state=3D4
>[71380=2E065834] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6
>mid=3D4087 state=3D4
>[71380=2E065837] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71380=2E065843] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71380=2E065848] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71380=2E065881] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13369) rc =3D 0
>[71380=2E065908] fs/cifs/cifsfs=2Ec: CIFS VFS: in cifs_statfs as Xid: 133=
70
>with uid: 999
>[71380=2E065966] fs/cifs/transport=2Ec: Sending smb: smb_len=3D348
>[71380=2E066494] fs/cifs/connect=2Ec: RFC1002 header 0x1b8
>[71380=2E066501] fs/cifs/smb2misc=2Ec: SMB2 data length 56 offset 152
>[71380=2E066503] fs/cifs/smb2misc=2Ec: SMB2 len 208
>[71380=2E066516] fs/cifs/smb2misc=2Ec: SMB2 data length 32 offset 72
>[71380=2E066517] fs/cifs/smb2misc=2Ec: SMB2 len 104
>[71380=2E066532] fs/cifs/smb2misc=2Ec: SMB2 len 124
>[71380=2E066534] fs/cifs/smb2misc=2Ec: Calculated size 124 length 128
>mismatch mid 95
>[71380=2E066536] fs/cifs/smb2ops=2Ec: add 30 credits total=3D1086
>[71380=2E067649] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D5 mid=
=3D93
>state=3D4
>[71380=2E067652] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D16 mi=
d=3D94
>state=3D4
>[71380=2E067656] fs/cifs/transport=2Ec: cifs_sync_mid_result: cmd=3D6 mid=
=3D95
>state=3D4
>[71380=2E067658] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71380=2E067667] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71380=2E067672] fs/cifs/misc=2Ec: Null buffer passed to
>cifs_small_buf_release
>[71380=2E067707] fs/cifs/cifsfs=2Ec: CIFS VFS: leaving cifs_statfs (xid =
=3D
>13370) rc =3D 0
>[71406=2E881866] INFO: task node_exporter:7214 blocked for more than 483
>seconds=2E
>[71406=2E883327]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71406=2E884700] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71406=2E886064] node_exporter   D    0  7214      1 0x00000000
>[71406=2E886068] Call Trace:
>[71406=2E886075]  ? __schedule+0x540/0xac0
>[71406=2E886080]  ? firmware_map_remove+0xe9/0xe9
>[71406=2E886087]  ? vsnprintf+0x32c/0x870
>[71406=2E886091]  ? _raw_spin_lock+0x7a/0xd0
>[71406=2E886095]  schedule+0x5e/0x100
>[71406=2E886098]  schedule_preempt_disabled+0xa/0x10
>[71406=2E886104]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71406=2E886106]  ? mutex_trylock+0x90/0x90
>[71406=2E886108]  ? string_nocheck+0xb0/0xd0
>[71406=2E886111]  ? pointer+0x387/0x460
>[71406=2E886113]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71406=2E886115]  ? _raw_write_lock_bh+0xe0/0xe0
>[71406=2E886121]  ? mutex_lock+0xce/0xe0
>[71406=2E886122]  mutex_lock+0xce/0xe0
>[71406=2E886124]  ? __mutex_lock_slowpath+0x10/0x10
>[71406=2E886126]  ? find_nls+0x7d/0xa0
>[71406=2E886194]  smb2_reconnect=2Epart=2E21+0x218/0xbd0 [cifs]
>[71406=2E886206]  ? deref_stack_reg+0x88/0xd0
>[71406=2E886210]  ? 0xffffffffa1e00000
>[71406=2E886254]  ? SMB2_tcon+0xab0/0xab0 [cifs]
>[71406=2E886258]  ? unwind_next_frame+0x90a/0x980
>[71406=2E886260]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71406=2E886263]  ? __module_text_address+0x11/0xa0
>[71406=2E886265]  ? __is_insn_slot_addr+0x1b/0x70
>[71406=2E886272]  ? is_bpf_text_address+0xa/0x20
>[71406=2E886274]  ? kernel_text_address+0xe2/0xf0
>[71406=2E886275]  ? __kernel_text_address+0xe/0x30
>[71406=2E886278]  ? unwind_get_return_address+0x2f/0x50
>[71406=2E886280]  ? create_prof_cpu_mask+0x20/0x20
>[71406=2E886288]  ? arch_stack_walk+0x92/0xe0
>[71406=2E886291]  ? stack_trace_save+0x8a/0xb0
>[71406=2E886337]  smb2_plain_req_init+0x2fe/0x3d0 [cifs]
>[71406=2E886381]  SMB2_open_init+0x143/0x12b0 [cifs]
>[71406=2E886420]  ? cifs_statfs+0x13a/0x420 [cifs]
>[71406=2E886424]  ? statfs_by_dentry+0xa5/0xf0
>[71406=2E886426]  ? vfs_statfs+0x28/0x110
>[71406=2E886428]  ? __do_sys_statfs+0x64/0xc0
>[71406=2E886470]  ? smb2_parse_contexts+0x270/0x270 [cifs]
>[71406=2E886475]  ? _raw_write_trylock+0xe0/0xe0
>[71406=2E886476]  ? _raw_spin_lock+0x7a/0xd0
>[71406=2E886478]  ? _raw_write_trylock+0xe0/0xe0
>[71406=2E886480]  ? memset+0x1f/0x40
>[71406=2E886482]  ? stack_access_ok+0x35/0x90
>[71406=2E886484]  ? deref_stack_reg+0x88/0xd0
>[71406=2E886486]  ? stack_access_ok+0x35/0x90
>[71406=2E886488]  ? deref_stack_reg+0x88/0xd0
>[71406=2E886491]  ? __read_once_size_nocheck=2Econstprop=2E6+0x10/0x10
>[71406=2E886493]  ? put_dec_trunc8+0x73/0x110
>[71406=2E886495]  ? number+0x356/0x4b0
>[71406=2E886497]  ? widen_string+0x23/0xf0
>[71406=2E886538]  ? smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71406=2E886580]  smb2_query_info_compound+0x242/0x4d0 [cifs]
>[71406=2E886622]  ? smb2_query_symlink+0xc70/0xc70 [cifs]
>[71406=2E886624]  ? pointer+0x460/0x460
>[71406=2E886626]  ? kernel_text_address+0xe2/0xf0
>[71406=2E886628]  ? va_format=2Eisra=2E12+0xee/0x100
>[71406=2E886630]  ? vsnprintf+0x870/0x870
>[71406=2E886632]  ? string_nocheck+0xb0/0xd0
>[71406=2E886634]  ? pointer+0x387/0x460
>[71406=2E886636]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71406=2E886638]  ? _raw_write_lock_bh+0xe0/0xe0
>[71406=2E886640]  ? _raw_spin_lock+0x7a/0xd0
>[71406=2E886641]  ? _raw_write_trylock+0xe0/0xe0
>[71406=2E886644]  ? up+0x32/0x70
>[71406=2E886647]  ? __switch_to_asm+0x34/0x70
>[71406=2E886649]  ? dynamic_emit_prefix+0x29/0x220
>[71406=2E886691]  ? smb2_queryfs+0xd9/0x1c0 [cifs]
>[71406=2E886744]  smb2_queryfs+0xd9/0x1c0 [cifs]
>[71406=2E886789]  ? smb2_query_eas+0x4f0/0x4f0 [cifs]
>[71406=2E886792]  ? vfs_mknod+0xc0/0x320
>[71406=2E886795]  ? map_id_up+0x12f/0x1d0
>[71406=2E886797]  ? make_kprojid+0x20/0x20
>[71406=2E886799]  ? _raw_spin_lock+0x7a/0xd0
>[71406=2E886836]  cifs_statfs+0x13a/0x420 [cifs]
>[71406=2E886839]  statfs_by_dentry+0xa5/0xf0
>[71406=2E886842]  vfs_statfs+0x28/0x110
>[71406=2E886844]  user_statfs+0x91/0xf0
>[71406=2E886846]  ? vfs_statfs+0x110/0x110
>[71406=2E886848]  ? __schedule+0x562/0xac0
>[71406=2E886850]  __do_sys_statfs+0x64/0xc0
>[71406=2E886852]  ? user_statfs+0xf0/0xf0
>[71406=2E886856]  do_syscall_64+0x73/0x190
>[71406=2E886858]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[71406=2E886860] RIP: 0033:0x4a5c20
>[71406=2E886864] Code: Bad RIP value=2E
>[71406=2E886865] RSP: 002b:000000c000341490 EFLAGS: 00000206 ORIG_RAX:
>0000000000000089
>[71406=2E886867] RAX: ffffffffffffffda RBX: 000000c00002ea00 RCX:
>00000000004a5c20
>[71406=2E886868] RDX: 0000000000000000 RSI: 000000c0003415c0 RDI:
>000000c0001c43c0
>[71406=2E886869] RBP: 000000c0003414f0 R08: 0000000000000000 R09:
>0000000000000000
>[71406=2E886871] R10: 0000000000000000 R11: 0000000000000206 R12:
>ffffffffffffffff
>[71406=2E886871] R13: 000000000000001f R14: 000000000000001e R15:
>0000000000000100
>[71406=2E886897] INFO: task cifsd:9136 blocked for more than 483 seconds=
=2E
>[71406=2E888219]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71406=2E889666] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71406=2E891125] cifsd           D    0  9136      2 0x80004000
>[71406=2E891130] Call Trace:
>[71406=2E891138]  ? __schedule+0x540/0xac0
>[71406=2E891147]  ? firmware_map_remove+0xe9/0xe9
>[71406=2E891156]  ? _raw_spin_lock+0x7a/0xd0
>[71406=2E891161]  schedule+0x5e/0x100
>[71406=2E891168]  schedule_preempt_disabled+0xa/0x10
>[71406=2E891173]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71406=2E891179]  ? mutex_trylock+0x90/0x90
>[71406=2E891192]  ? irq_work_claim+0x2e/0x50
>[71406=2E891207]  ? vprintk_emit+0x11d/0x2e0
>[71406=2E891216]  ? mutex_lock+0xce/0xe0
>[71406=2E891228]  mutex_lock+0xce/0xe0
>[71406=2E891232]  ? __mutex_lock_slowpath+0x10/0x10
>[71406=2E891317]  dfs_cache_noreq_find+0xa7/0x190 [cifs]
>[71406=2E891378]  cifs_reconnect+0x18c/0x1510 [cifs]
>[71406=2E891383]  ? ___ratelimit+0x106/0x190
>[71406=2E891439]  ? smb2_calc_size+0x15c/0x250 [cifs]
>[71406=2E891505]  ? extract_hostname+0xa0/0xa0 [cifs]
>[71406=2E891510]  ? _raw_spin_trylock+0x91/0xe0
>[71406=2E891513]  ? _raw_spin_trylock_bh+0x100/0x100
>[71406=2E891516]  ? ___ratelimit+0x106/0x190
>[71406=2E891574]  cifs_handle_standard+0x252/0x270 [cifs]
>[71406=2E891631]  cifs_demultiplex_thread+0x124a/0x13e0 [cifs]
>[71406=2E891692]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71406=2E891696]  ? __switch_to_asm+0x40/0x70
>[71406=2E891698]  ? __switch_to_asm+0x34/0x70
>[71406=2E891701]  ? __switch_to_asm+0x40/0x70
>[71406=2E891703]  ? __switch_to_asm+0x34/0x70
>[71406=2E891706]  ? __switch_to_asm+0x40/0x70
>[71406=2E891709]  ? __switch_to_asm+0x34/0x70
>[71406=2E891712]  ? __switch_to_asm+0x40/0x70
>[71406=2E891715]  ? __switch_to_asm+0x34/0x70
>[71406=2E891718]  ? __switch_to_asm+0x40/0x70
>[71406=2E891720]  ? __switch_to_asm+0x34/0x70
>[71406=2E891723]  ? __switch_to_asm+0x40/0x70
>[71406=2E891725]  ? __switch_to_asm+0x34/0x70
>[71406=2E891727]  ? __switch_to_asm+0x40/0x70
>[71406=2E891729]  ? __switch_to_asm+0x34/0x70
>[71406=2E891732]  ? __switch_to_asm+0x40/0x70
>[71406=2E891734]  ? __switch_to_asm+0x34/0x70
>[71406=2E891737]  ? __switch_to_asm+0x40/0x70
>[71406=2E891739]  ? __switch_to_asm+0x34/0x70
>[71406=2E891741]  ? __switch_to_asm+0x40/0x70
>[71406=2E891744]  ? __switch_to_asm+0x34/0x70
>[71406=2E891746]  ? __switch_to_asm+0x40/0x70
>[71406=2E891749]  ? __switch_to_asm+0x34/0x70
>[71406=2E891751]  ? __switch_to_asm+0x40/0x70
>[71406=2E891753]  ? __switch_to_asm+0x34/0x70
>[71406=2E891756]  ? __switch_to_asm+0x40/0x70
>[71406=2E891758]  ? __switch_to_asm+0x34/0x70
>[71406=2E891763]  ? finish_task_switch+0xf6/0x370
>[71406=2E891767]  ? __switch_to+0x2ec/0x5e0
>[71406=2E891772]  ? _raw_spin_lock_irqsave+0x8d/0xf0
>[71406=2E891774]  ? _raw_write_lock_bh+0xe0/0xe0
>[71406=2E891946]  ? cifs_handle_standard+0x270/0x270 [cifs]
>[71406=2E891951]  kthread+0x192/0x1e0
>[71406=2E891955]  ? kthread_create_worker_on_cpu+0xc0/0xc0
>[71406=2E891958]  ret_from_fork+0x35/0x40
>[71406=2E891970] INFO: task kworker/0:0:16069 blocked for more than 241
>seconds=2E
>[71406=2E894262]       Tainted: G            E     5=2E3=2E11-pd-5=2E3=2E=
y
>#20191029
>[71406=2E896328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>disables this message=2E
>[71406=2E898113] kworker/0:0     D    0 16069      2 0x80004000
>[71406=2E898203] Workqueue: cifsiod refresh_cache_worker [cifs]
>[71406=2E898211] Call Trace:
>[71406=2E898220]  ? __schedule+0x540/0xac0
>[71406=2E898224]  ? firmware_map_remove+0xe9/0xe9
>[71406=2E898228]  ? _raw_read_lock_irq+0x40/0x40
>[71406=2E898231]  ? _raw_spin_lock+0x7a/0xd0
>[71406=2E898234]  schedule+0x5e/0x100
>[71406=2E898239]  schedule_preempt_disabled+0xa/0x10
>[71406=2E898242]  __mutex_lock=2Eisra=2E4+0x484/0x820
>[71406=2E898247]  ? mutex_trylock+0x90/0x90
>[71406=2E898251]  ? dynamic_emit_prefix+0x29/0x220
>[71406=2E898255]  ? __dynamic_pr_debug+0xf8/0x140
>[71406=2E898260]  ? dynamic_emit_prefix+0x220/0x220
>[71406=2E898271]  ? update_dl_rq_load_avg+0x2c3/0x4d0
>[71406=2E898277]  ? mutex_lock+0xce/0xe0
>[71406=2E898280]  mutex_lock+0xce/0xe0
>[71406=2E898283]  ? __mutex_lock_slowpath+0x10/0x10
>[71406=2E898362]  refresh_cache_worker+0x48f/0x14a0 [cifs]
>[71406=2E898370]  ? __switch_to_asm+0x40/0x70
>[71406=2E898373]  ? __switch_to_asm+0x40/0x70
>[71406=2E898376]  ? __switch_to_asm+0x34/0x70
>[71406=2E898378]  ? __switch_to_asm+0x40/0x70
>[71406=2E898383]  ? __switch_to_asm+0x34/0x70
>[71406=2E898389]  ? __switch_to_asm+0x40/0x70
>[71406=2E898467]  ? find_root_ses=2Eisra=2E9+0x320/0x320 [cifs]
>[71406=2E898472]  ? __switch_to_asm+0x40/0x70
>[71406=2E898476]  ? __switch_to_asm+0x40/0x70
>[71406=2E898479]  ? __switch_to_asm+0x34/0x70
>[71406=2E898484]  ? __switch_to_asm+0x40/0x70
>[71406=2E898488]  ? __switch_to_asm+0x34/0x70
>[71406=2E898490]  ? __switch_to_asm+0x40/0x70
>[71406=2E898499]  ? __switch_to_asm+0x34/0x70
>[71406=2E898502]  ? __switch_to_asm+0x40/0x70
>[71406=2E898505]  ? __switch_to_asm+0x40/0x70
>[71406=2E898508]  ? __switch_to_asm+0x34/0x70
>[71406=2E898516]  ? finish_task_switch+0xf6/0x370
>[71406=2E898519]  ? __switch_to+0x2ec/0x5e0
>[71406=2E898523]  ? __schedule+0x562/0xac0
>[71406=2E898530]  ? read_word_at_a_time+0xe/0x20
>[71406=2E898533]  ? strscpy+0xca/0x1d0
>[71406=2E898539]  process_one_work+0x373/0x6e0
>[71406=2E898547]  worker_thread+0x78/0x5b0
>[71406=2E898552]  ? rescuer_thread+0x5e0/0x5e0
>[71406=2E898555]  kthread+0x192/0x1e0
>[71406=2E898559]  ? kthread_create_worker_on_cpu+0xc0/0xc0
>[71406=2E898563]  ret_from_fork+0x35/0x40
>[71417=2E962152] fs/cifs/inode=2Ec: CIFS VFS: in
>cifs_revalidate_dentry_attr as Xid: 13371 with uid: 11025
>[71417=2E962171] fs/cifs/dir=2Ec: name: \SOMEDIRX
>[71417=2E962177] fs/cifs/inode=2Ec: Update attributes: \SOMEDIRX inode
>0x000000009f726d03 count 1 dentry: 0x00000000d22e461a d_time 4312598279
>jiffies 4312748242
>[71417=2E962180] fs/cifs/inode=2Ec: Getting info on \SOMEDIRX
>[71417=2E962367] fs/cifs/transport=2Ec: Sending smb: smb_len=3D388=20
>
>Gr, Martijn

Yeah, thats another issue indeed=2E Thanks for the report=2E

I will look into it and let you know=2E

Paulo
