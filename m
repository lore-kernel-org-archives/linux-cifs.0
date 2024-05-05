Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9889417CD
	for <linux-cifs@vger.kernel.org>; Sun,  5 May 2024 04:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714882242; cv=none; b=rS5Jp/JoUMOYmsccimDPPBncCB9qZJOH3N6koJgDpeakC8F3bNN7A+q5GTLyoz6+tDOw/eijzoR4F83PB8k+C2h16OHo5prj2ETERWyEI6qT9sc3XUvRuiT1xu3HPO3wSukr2k9i0Q/wZiPH/ZNO1u+W7PqRGgCo0YpzjvMGD/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714882242; c=relaxed/simple;
	bh=2m5bqym9g+rx+OtMaCiCXOEyzjpFqEPBFh1MGmPD90E=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rPQF1zaD6EbLPA+JQLsXwopydN0lJMEAVmcTw0mem/YqgoF5qHNTOruDyyd7zdBwmAyN1zoWZimS1xRCtrb66VPqmT7PYdzqzioieQRqHUphcCJx0/9oZc7hM5duuT8HttKXlEEKJDND4VYcUeJnPGN2SSveAQ1L1gzUKECjYuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RwH8216T; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RwH8216T"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2db7c6b5598so11333221fa.1
        for <linux-cifs@vger.kernel.org>; Sat, 04 May 2024 21:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714882237; x=1715487037; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b7guo9wSA4gCfCDWQ+9qH+RBV3jKEe2PqgYhgR7g430=;
        b=RwH8216TZcFtaVCnc4sKtrlPvzY0Q9Fzz3EMKI+rDByEZfqGyo0Ikc9rnndVE/1OV5
         zVl1WQWqemHFKM5vvzovFcIn05XqqSiwEC1567KJ4u5/DS+nYtUB0dUydWNmA7nBqUAS
         ZDRBcd0gQOZAzXBZk9QV68MCn3fuI7JNfDBBnkfcTgvbP2co2Rp6lMYAOfqu8vRWBfWX
         z/riq9Y9qKEQWApZ+Sk12geG60aTqp46dA5ZvYvmjsPloSpG/PvvM8bexe0yAMVBSZgX
         uQw6NFKODEMHYywxgFpzc0lfmWvoDC1VXiIPDtQYTeK4ue5lYCa9JNQjB1771VQRtlwZ
         R0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714882237; x=1715487037;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7guo9wSA4gCfCDWQ+9qH+RBV3jKEe2PqgYhgR7g430=;
        b=Y2Rdtbhqv+H13tzMeYeeAlOcipnhxThVmDtps5rf9Cgeo6s7EYaVWe6b7tXyo0yOJM
         o9o3eurLCIOTy849l/dH6GaYMlm01SSgY8hJ8IIKVC3dKFCByq0ri9pUCMlLZyAILkRq
         jt/tBbiQPbP2RxEIKlfRiPusroIYEB3WKH3La7MHEgAx32r1Lzb8SGghYUKW5NAzdt3q
         xNp/gi8CTl6bqYACM9DyR0mI5xFj7e33Y793DBfLy1jylBQ86IunvknjbXfb69G1VF+i
         0MUMiLVdyYDFKrMsLAgXIDtwecENeokWJM8OE3qqTOhZ4wsT8xEbIIki3KS0YqSOlFgn
         3s9g==
X-Gm-Message-State: AOJu0Yz5sUCN3FOuVr+Wlv8hZWvvd3KtqQUpZIkMTmT0WASTa2XHxaR/
	rBvCb26dfAiLRk+C44oC71fql8jui/ZtQDaL9rYcTUyfc0WheefPuqB/bpycY6N06rMzj6g0pK/
	3vCG7AdvXmh/x2yD7ylBRpA7/QfWsUSF3
X-Google-Smtp-Source: AGHT+IF+bXSDd9yuZMXNXoqxSSxVD5bQlGMAIs9/dDv8lfiSD/dIHVvcQrAKCFWoAeFN7WxlAVvVTtrHryDrRmxF62U=
X-Received: by 2002:a19:6454:0:b0:51e:eac7:d69b with SMTP id
 b20-20020a196454000000b0051eeac7d69bmr4600171lfj.27.1714882236896; Sat, 04
 May 2024 21:10:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 4 May 2024 23:10:24 -0500
Message-ID: <CAH2r5mvWFvVu1kymbh2qrQXyfVJRz7Sf3iT6zhOt0rTujTW9+Q@mail.gmail.com>
Subject: rmmod cifs error
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

I saw this doing "unmount /mnt/test ; rmmod cifs" after running a
'full xfstest run' with current mainline against ksmbd.  Have you seen
this before? Any ideas?

[20769.458158] run fstests generic/502 at 2024-05-04 16:55:46
[20770.643121] run fstests generic/503 at 2024-05-04 16:55:48
[20772.047150] CIFS: Attempting to mount //10.0.0.10/scratch
[43069.416552] Key type cifs.idmap unregistered
[43069.416615] Key type cifs.spnego unregistered
[43069.547744] =============================================================================
[43069.548091] BUG cifs_small_rq (Not tainted): Objects remaining in
cifs_small_rq on __kmem_cache_shutdown()
[43069.548097] -----------------------------------------------------------------------------

[43069.548100] Slab 0x00000000c3bca063 objects=32 used=1
fp=0x0000000074f47125
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.548109] CPU: 6 PID: 13873 Comm: rmmod Not tainted 6.9.0-rc6 #1
[43069.548114] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.548119] Call Trace:
[43069.548122]  <TASK>
[43069.548126]  dump_stack_lvl+0x79/0xb0
[43069.548143]  slab_err+0xb6/0xf0
[43069.548158]  ? __lock_acquire+0x2689/0x31c0
[43069.548166]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.548175]  ? do_raw_spin_lock+0xf8/0x190
[43069.548183]  __kmem_cache_shutdown+0x176/0x310
[43069.548198]  kmem_cache_destroy+0x65/0x1a0
[43069.548209]  exit_cifs+0x65/0x460 [cifs]
[43069.548382]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.548390]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.548395]  ? mark_held_locks+0x24/0x90
[43069.548403]  ? __x64_sys_close+0x54/0xa0
[43069.548409]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.548416]  ? kasan_quarantine_put+0x97/0x1f0
[43069.548427]  ? mark_held_locks+0x24/0x90
[43069.548439]  do_syscall_64+0x78/0x180
[43069.548447]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.548454] RIP: 0033:0x7f25b50bdd4b
[43069.548460] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.548465] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.548472] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.548476] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.548480] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.548483] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.548487] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.548508]  </TASK>
[43069.548510] Disabling lock debugging due to kernel taint
[43069.548514] Object 0x00000000f92344d7 @offset=5632
[43069.548517] =============================================================================
[43069.548519] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.548522] -----------------------------------------------------------------------------

[43069.548524] Slab 0x000000003e783061 objects=32 used=1
fp=0x00000000e9d9a99b
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.548529] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.548533] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.548535] Call Trace:
[43069.548537]  <TASK>
[43069.548539]  dump_stack_lvl+0x79/0xb0
[43069.548544]  slab_err+0xb6/0xf0
[43069.548550]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.548554]  ? do_raw_spin_unlock+0x8d/0x100
[43069.548559]  __kmem_cache_shutdown+0x176/0x310
[43069.548565]  kmem_cache_destroy+0x65/0x1a0
[43069.548570]  exit_cifs+0x65/0x460 [cifs]
[43069.548725]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.548730]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.548733]  ? mark_held_locks+0x24/0x90
[43069.548738]  ? __x64_sys_close+0x54/0xa0
[43069.548742]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.548746]  ? kasan_quarantine_put+0x97/0x1f0
[43069.548750]  ? mark_held_locks+0x24/0x90
[43069.548756]  do_syscall_64+0x78/0x180
[43069.548760]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.548764] RIP: 0033:0x7f25b50bdd4b
[43069.548767] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.548771] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.548774] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.548777] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.548780] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.548782] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.548784] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.548791]  </TASK>
[43069.548796] Object 0x000000001ea3d3e5 @offset=1536
[43069.548799] =============================================================================
[43069.548801] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.548803] -----------------------------------------------------------------------------

[43069.548805] Slab 0x00000000df780979 objects=32 used=1
fp=0x0000000055c1ab0c
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.548809] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.548812] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.548815] Call Trace:
[43069.548816]  <TASK>
[43069.548818]  dump_stack_lvl+0x79/0xb0
[43069.548823]  slab_err+0xb6/0xf0
[43069.548829]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.548833]  ? do_raw_spin_unlock+0x8d/0x100
[43069.548838]  __kmem_cache_shutdown+0x176/0x310
[43069.548844]  kmem_cache_destroy+0x65/0x1a0
[43069.548850]  exit_cifs+0x65/0x460 [cifs]
[43069.549018]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.549022]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.549026]  ? mark_held_locks+0x24/0x90
[43069.549031]  ? __x64_sys_close+0x54/0xa0
[43069.549034]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.549038]  ? kasan_quarantine_put+0x97/0x1f0
[43069.549043]  ? mark_held_locks+0x24/0x90
[43069.549049]  do_syscall_64+0x78/0x180
[43069.549053]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.549057] RIP: 0033:0x7f25b50bdd4b
[43069.549060] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.549063] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.549067] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.549070] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.549072] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.549075] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.549077] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.549084]  </TASK>
[43069.549089] Object 0x00000000c50b80d8 @offset=6144
[43069.549092] =============================================================================
[43069.549094] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.549096] -----------------------------------------------------------------------------

[43069.549098] Slab 0x00000000214adb68 objects=32 used=1
fp=0x00000000d0cdfe51
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.549103] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.549106] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.549107] Call Trace:
[43069.549109]  <TASK>
[43069.549111]  dump_stack_lvl+0x79/0xb0
[43069.549116]  slab_err+0xb6/0xf0
[43069.549122]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.549126]  ? do_raw_spin_unlock+0x8d/0x100
[43069.549130]  __kmem_cache_shutdown+0x176/0x310
[43069.549137]  kmem_cache_destroy+0x65/0x1a0
[43069.549142]  exit_cifs+0x65/0x460 [cifs]
[43069.549296]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.549301]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.549304]  ? mark_held_locks+0x24/0x90
[43069.549309]  ? __x64_sys_close+0x54/0xa0
[43069.549312]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.549316]  ? kasan_quarantine_put+0x97/0x1f0
[43069.549320]  ? mark_held_locks+0x24/0x90
[43069.549326]  do_syscall_64+0x78/0x180
[43069.549330]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.549335] RIP: 0033:0x7f25b50bdd4b
[43069.549337] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.549341] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.549344] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.549347] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.549349] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.549351] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.549354] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.549360]  </TASK>
[43069.549364] Object 0x000000005a4f4045 @offset=7680
[43069.549367] =============================================================================
[43069.549369] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.549371] -----------------------------------------------------------------------------

[43069.549373] Slab 0x000000009299b178 objects=32 used=1
fp=0x00000000c449daa1
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.549377] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.549380] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.549382] Call Trace:
[43069.549384]  <TASK>
[43069.549386]  dump_stack_lvl+0x79/0xb0
[43069.549391]  slab_err+0xb6/0xf0
[43069.549397]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.549402]  ? do_raw_spin_unlock+0x8d/0x100
[43069.549407]  __kmem_cache_shutdown+0x176/0x310
[43069.549413]  kmem_cache_destroy+0x65/0x1a0
[43069.549418]  exit_cifs+0x65/0x460 [cifs]
[43069.549573]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.549577]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.549580]  ? mark_held_locks+0x24/0x90
[43069.549585]  ? __x64_sys_close+0x54/0xa0
[43069.549588]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.549592]  ? kasan_quarantine_put+0x97/0x1f0
[43069.549597]  ? mark_held_locks+0x24/0x90
[43069.549603]  do_syscall_64+0x78/0x180
[43069.549607]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.549611] RIP: 0033:0x7f25b50bdd4b
[43069.549614] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.549617] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.549621] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.549624] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.549626] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.549629] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.549631] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.549638]  </TASK>
[43069.549643] Object 0x000000004d22b885 @offset=9216
[43069.549646] =============================================================================
[43069.549648] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.549651] -----------------------------------------------------------------------------

[43069.549652] Slab 0x0000000039ac8184 objects=32 used=1
fp=0x000000003494909d
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.549657] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.549660] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.549662] Call Trace:
[43069.549664]  <TASK>
[43069.549666]  dump_stack_lvl+0x79/0xb0
[43069.549670]  slab_err+0xb6/0xf0
[43069.549676]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.549681]  ? do_raw_spin_unlock+0x8d/0x100
[43069.549685]  __kmem_cache_shutdown+0x176/0x310
[43069.549691]  kmem_cache_destroy+0x65/0x1a0
[43069.549697]  exit_cifs+0x65/0x460 [cifs]
[43069.549851]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.549855]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.549859]  ? mark_held_locks+0x24/0x90
[43069.549863]  ? __x64_sys_close+0x54/0xa0
[43069.549867]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.549871]  ? kasan_quarantine_put+0x97/0x1f0
[43069.549876]  ? mark_held_locks+0x24/0x90
[43069.549882]  do_syscall_64+0x78/0x180
[43069.549886]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.549890] RIP: 0033:0x7f25b50bdd4b
[43069.549893] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.549896] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.549900] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.549902] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.549905] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.549907] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.549910] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.549917]  </TASK>
[43069.549921] Object 0x000000006d356e19 @offset=3072
[43069.549924] =============================================================================
[43069.549926] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.549929] -----------------------------------------------------------------------------

[43069.549931] Slab 0x000000008c7d4f98 objects=32 used=1
fp=0x00000000bf6e5aae
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.549935] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.549938] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.549940] Call Trace:
[43069.549942]  <TASK>
[43069.549944]  dump_stack_lvl+0x79/0xb0
[43069.549948]  slab_err+0xb6/0xf0
[43069.549954]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.549959]  ? do_raw_spin_unlock+0x8d/0x100
[43069.549963]  __kmem_cache_shutdown+0x176/0x310
[43069.549969]  kmem_cache_destroy+0x65/0x1a0
[43069.549975]  exit_cifs+0x65/0x460 [cifs]
[43069.550138]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.550142]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.550146]  ? mark_held_locks+0x24/0x90
[43069.550150]  ? __x64_sys_close+0x54/0xa0
[43069.550154]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.550158]  ? kasan_quarantine_put+0x97/0x1f0
[43069.550162]  ? mark_held_locks+0x24/0x90
[43069.550168]  do_syscall_64+0x78/0x180
[43069.550172]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.550177] RIP: 0033:0x7f25b50bdd4b
[43069.550179] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.550183] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.550186] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.550189] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.550191] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.550194] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.550196] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.550203]  </TASK>
[43069.550207] Object 0x000000000fa84f6b @offset=1024
[43069.550210] =============================================================================
[43069.550212] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.550215] -----------------------------------------------------------------------------

[43069.550216] Slab 0x00000000dbc4c940 objects=32 used=1
fp=0x000000007903ed13
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.550221] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.550224] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.550226] Call Trace:
[43069.550228]  <TASK>
[43069.550229]  dump_stack_lvl+0x79/0xb0
[43069.550234]  slab_err+0xb6/0xf0
[43069.550240]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.550245]  ? do_raw_spin_unlock+0x8d/0x100
[43069.550249]  __kmem_cache_shutdown+0x176/0x310
[43069.550255]  kmem_cache_destroy+0x65/0x1a0
[43069.550261]  exit_cifs+0x65/0x460 [cifs]
[43069.550414]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.550418]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.550422]  ? mark_held_locks+0x24/0x90
[43069.550426]  ? __x64_sys_close+0x54/0xa0
[43069.550430]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.550433]  ? kasan_quarantine_put+0x97/0x1f0
[43069.550438]  ? mark_held_locks+0x24/0x90
[43069.550444]  do_syscall_64+0x78/0x180
[43069.550448]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.550452] RIP: 0033:0x7f25b50bdd4b
[43069.550455] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.550458] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.550462] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.550465] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.550467] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.550469] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.550472] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.550479]  </TASK>
[43069.550483] Object 0x000000005df1fc39 @offset=7680
[43069.550485] =============================================================================
[43069.550487] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.550490] -----------------------------------------------------------------------------

[43069.550492] Slab 0x000000009bfcbe94 objects=32 used=1
fp=0x0000000051ba06de
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.550496] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.550499] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.550501] Call Trace:
[43069.550503]  <TASK>
[43069.550505]  dump_stack_lvl+0x79/0xb0
[43069.550509]  slab_err+0xb6/0xf0
[43069.550515]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.550520]  ? do_raw_spin_unlock+0x8d/0x100
[43069.550524]  __kmem_cache_shutdown+0x176/0x310
[43069.550530]  kmem_cache_destroy+0x65/0x1a0
[43069.550536]  exit_cifs+0x65/0x460 [cifs]
[43069.550691]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.550695]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.550699]  ? mark_held_locks+0x24/0x90
[43069.550704]  ? __x64_sys_close+0x54/0xa0
[43069.550707]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.550711]  ? kasan_quarantine_put+0x97/0x1f0
[43069.550715]  ? mark_held_locks+0x24/0x90
[43069.550721]  do_syscall_64+0x78/0x180
[43069.550725]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.550730] RIP: 0033:0x7f25b50bdd4b
[43069.550732] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.550736] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.550739] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.550742] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.550744] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.550747] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.550749] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.550756]  </TASK>
[43069.550761] Object 0x000000007e641d2e @offset=8192
[43069.550763] =============================================================================
[43069.550765] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.550768] -----------------------------------------------------------------------------

[43069.550770] Slab 0x000000005d611d8a objects=32 used=1
fp=0x00000000f2b2273f
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.550774] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.550777] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.550779] Call Trace:
[43069.550781]  <TASK>
[43069.550783]  dump_stack_lvl+0x79/0xb0
[43069.550787]  slab_err+0xb6/0xf0
[43069.550793]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.550798]  ? do_raw_spin_unlock+0x8d/0x100
[43069.550802]  __kmem_cache_shutdown+0x176/0x310
[43069.550808]  kmem_cache_destroy+0x65/0x1a0
[43069.550814]  exit_cifs+0x65/0x460 [cifs]
[43069.550967]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.550972]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.550975]  ? mark_held_locks+0x24/0x90
[43069.550980]  ? __x64_sys_close+0x54/0xa0
[43069.550983]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.550994]  ? kasan_quarantine_put+0x97/0x1f0
[43069.550999]  ? mark_held_locks+0x24/0x90
[43069.551005]  do_syscall_64+0x78/0x180
[43069.551009]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.551014] RIP: 0033:0x7f25b50bdd4b
[43069.551016] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.551020] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.551023] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.551026] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.551028] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.551031] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.551033] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.551040]  </TASK>
[43069.551045] Object 0x00000000387d1dd2 @offset=4096
[43069.551047] =============================================================================
[43069.551049] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.551052] -----------------------------------------------------------------------------

[43069.551054] Slab 0x000000001b2ee585 objects=32 used=2
fp=0x000000005d08c8ce
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.551058] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.551061] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.551063] Call Trace:
[43069.551065]  <TASK>
[43069.551067]  dump_stack_lvl+0x79/0xb0
[43069.551072]  slab_err+0xb6/0xf0
[43069.551078]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.551082]  ? do_raw_spin_unlock+0x8d/0x100
[43069.551087]  __kmem_cache_shutdown+0x176/0x310
[43069.551093]  kmem_cache_destroy+0x65/0x1a0
[43069.551098]  exit_cifs+0x65/0x460 [cifs]
[43069.551253]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.551257]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.551261]  ? mark_held_locks+0x24/0x90
[43069.551266]  ? __x64_sys_close+0x54/0xa0
[43069.551269]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.551273]  ? kasan_quarantine_put+0x97/0x1f0
[43069.551278]  ? mark_held_locks+0x24/0x90
[43069.551283]  do_syscall_64+0x78/0x180
[43069.551288]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.551292] RIP: 0033:0x7f25b50bdd4b
[43069.551295] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.551298] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.551301] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.551304] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.551306] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.551309] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.551311] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.551318]  </TASK>
[43069.551323] Object 0x0000000085af2a9b @offset=8192
[43069.551325] Object 0x000000004b2efd7a @offset=12288
[43069.551327] =============================================================================
[43069.551329] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.551332] -----------------------------------------------------------------------------

[43069.551334] Slab 0x00000000ee7fd84c objects=32 used=1
fp=0x000000007320e380
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.551338] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.551341] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.551343] Call Trace:
[43069.551345]  <TASK>
[43069.551347]  dump_stack_lvl+0x79/0xb0
[43069.551351]  slab_err+0xb6/0xf0
[43069.551358]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.551362]  ? do_raw_spin_unlock+0x8d/0x100
[43069.551366]  __kmem_cache_shutdown+0x176/0x310
[43069.551373]  kmem_cache_destroy+0x65/0x1a0
[43069.551378]  exit_cifs+0x65/0x460 [cifs]
[43069.551532]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.551536]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.551540]  ? mark_held_locks+0x24/0x90
[43069.551545]  ? __x64_sys_close+0x54/0xa0
[43069.551548]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.551552]  ? kasan_quarantine_put+0x97/0x1f0
[43069.551556]  ? mark_held_locks+0x24/0x90
[43069.551562]  do_syscall_64+0x78/0x180
[43069.551566]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.551571] RIP: 0033:0x7f25b50bdd4b
[43069.551573] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.551577] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.551580] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.551583] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.551585] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.551588] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.551590] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.551597]  </TASK>
[43069.551601] Object 0x000000004eae45f6 @offset=3584
[43069.551604] =============================================================================
[43069.551606] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.551608] -----------------------------------------------------------------------------

[43069.551610] Slab 0x00000000c15c251a objects=32 used=1
fp=0x00000000e6784a72
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.551614] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.551617] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.551619] Call Trace:
[43069.551621]  <TASK>
[43069.551623]  dump_stack_lvl+0x79/0xb0
[43069.551627]  slab_err+0xb6/0xf0
[43069.551633]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.551638]  ? do_raw_spin_unlock+0x8d/0x100
[43069.551642]  __kmem_cache_shutdown+0x176/0x310
[43069.551649]  kmem_cache_destroy+0x65/0x1a0
[43069.551654]  exit_cifs+0x65/0x460 [cifs]
[43069.551808]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.551813]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.551816]  ? mark_held_locks+0x24/0x90
[43069.551821]  ? __x64_sys_close+0x54/0xa0
[43069.551825]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.551828]  ? kasan_quarantine_put+0x97/0x1f0
[43069.551833]  ? mark_held_locks+0x24/0x90
[43069.551839]  do_syscall_64+0x78/0x180
[43069.551843]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.551847] RIP: 0033:0x7f25b50bdd4b
[43069.551850] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.551853] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.551857] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.551859] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.551862] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.551864] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.551867] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.551873]  </TASK>
[43069.551879] Object 0x00000000e7624370 @offset=4096
[43069.551881] =============================================================================
[43069.551883] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.551886] -----------------------------------------------------------------------------

[43069.551888] Slab 0x00000000a2e5a32b objects=32 used=1
fp=0x00000000c47e553f
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.551892] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.551895] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.551897] Call Trace:
[43069.551899]  <TASK>
[43069.551901]  dump_stack_lvl+0x79/0xb0
[43069.551905]  slab_err+0xb6/0xf0
[43069.551912]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.551916]  ? do_raw_spin_unlock+0x8d/0x100
[43069.551921]  __kmem_cache_shutdown+0x176/0x310
[43069.551927]  kmem_cache_destroy+0x65/0x1a0
[43069.551932]  exit_cifs+0x65/0x460 [cifs]
[43069.552093]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.552098]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.552101]  ? mark_held_locks+0x24/0x90
[43069.552106]  ? __x64_sys_close+0x54/0xa0
[43069.552109]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.552113]  ? kasan_quarantine_put+0x97/0x1f0
[43069.552118]  ? mark_held_locks+0x24/0x90
[43069.552124]  do_syscall_64+0x78/0x180
[43069.552128]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.552132] RIP: 0033:0x7f25b50bdd4b
[43069.552135] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.552138] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.552142] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.552145] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.552147] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.552149] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.552152] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.552159]  </TASK>
[43069.552164] Object 0x00000000fe3fd465 @offset=15872
[43069.552166] =============================================================================
[43069.552168] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.552171] -----------------------------------------------------------------------------

[43069.552172] Slab 0x000000000f0fb5cd objects=32 used=1
fp=0x0000000033f6e4e0
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.552177] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.552180] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.552182] Call Trace:
[43069.552184]  <TASK>
[43069.552186]  dump_stack_lvl+0x79/0xb0
[43069.552190]  slab_err+0xb6/0xf0
[43069.552196]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.552201]  ? do_raw_spin_unlock+0x8d/0x100
[43069.552205]  __kmem_cache_shutdown+0x176/0x310
[43069.552211]  kmem_cache_destroy+0x65/0x1a0
[43069.552217]  exit_cifs+0x65/0x460 [cifs]
[43069.552371]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.552375]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.552379]  ? mark_held_locks+0x24/0x90
[43069.552384]  ? __x64_sys_close+0x54/0xa0
[43069.552387]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.552391]  ? kasan_quarantine_put+0x97/0x1f0
[43069.552395]  ? mark_held_locks+0x24/0x90
[43069.552401]  do_syscall_64+0x78/0x180
[43069.552405]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.552409] RIP: 0033:0x7f25b50bdd4b
[43069.552412] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.552415] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.552419] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.552422] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.552424] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.552426] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.552429] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.552436]  </TASK>
[43069.552441] Object 0x000000003aadef4d @offset=14336
[43069.552443] =============================================================================
[43069.552445] BUG cifs_small_rq (Tainted: G    B             ):
Objects remaining in cifs_small_rq on __kmem_cache_shutdown()
[43069.552448] -----------------------------------------------------------------------------

[43069.552449] Slab 0x0000000064dc475e objects=32 used=1
fp=0x00000000be31bda9
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.552454] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.552457] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.552459] Call Trace:
[43069.552460]  <TASK>
[43069.552462]  dump_stack_lvl+0x79/0xb0
[43069.552467]  slab_err+0xb6/0xf0
[43069.552473]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.552477]  ? do_raw_spin_unlock+0x8d/0x100
[43069.552482]  __kmem_cache_shutdown+0x176/0x310
[43069.552488]  kmem_cache_destroy+0x65/0x1a0
[43069.552493]  exit_cifs+0x65/0x460 [cifs]
[43069.552650]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.552654]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.552657]  ? mark_held_locks+0x24/0x90
[43069.552662]  ? __x64_sys_close+0x54/0xa0
[43069.552665]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.552669]  ? kasan_quarantine_put+0x97/0x1f0
[43069.552674]  ? mark_held_locks+0x24/0x90
[43069.552680]  do_syscall_64+0x78/0x180
[43069.552684]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.552688] RIP: 0033:0x7f25b50bdd4b
[43069.552691] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.552694] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.552698] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.552700] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.552703] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.552705] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.552708] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.552714]  </TASK>
[43069.552719] Object 0x0000000015c7497a @offset=15872
[43069.552783] ------------[ cut here ]------------
[43069.552786] kmem_cache_destroy cifs_small_rq: Slab cache still has
objects when called from exit_cifs+0x65/0x460 [cifs]
[43069.552946] WARNING: CPU: 6 PID: 13873 at mm/slab_common.c:497
kmem_cache_destroy+0x10d/0x1a0
[43069.552953] Modules linked in: loop cmac nls_utf8 cifs(-) cifs_arc4
nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver
nfs lockd grace netfs nf_conntrack_netbios_ns nf_conntrack_broadcast
xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT
nf_reject_ipv4 xt_conntrack ebtable_nat ip6table_nat ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_nat iptable_mangle
iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter sunrpc kvm_intel kvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3
sha1_ssse3 bochs drm_vram_helper drm_ttm_helper ttm drm_kms_helper drm
virtio_balloon floppy ip_tables xfs virtio_net crc32c_intel
net_failover sha256_ssse3 virtio_blk virtio_console failover
qemu_fw_cfg
[43069.553069] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B
   6.9.0-rc6 #1
[43069.553260] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.553263] RIP: 0010:kmem_cache_destroy+0x10d/0x1a0
[43069.553268] Code: 48 89 ef 5b 5d 41 5c 41 5d e9 0f 08 09 00 48 8b
55 60 48 8b 4c 24 20 48 c7 c6 20 01 b6 a5 48 c7 c7 98 9d 38 a6 e8 d3
87 be ff <0f> 0b 48 c7 c7 a0 dd 9d a6 e8 d5 4c 12 01 5b 5d 41 5c 41 5d
e9 8a
[43069.553272] RSP: 0018:ff110001325e7df8 EFLAGS: 00010282
[43069.553276] RAX: dffffc0000000000 RBX: 1fe22000264bcfc6 RCX: 0000000000000027
[43069.553279] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff110004cb3319c8
[43069.553281] RBP: ff1100011c4dc780 R08: ffffffffa440d70e R09: ffe21c0099666339
[43069.553284] R10: ff110004cb3319cb R11: 0000000000000001 R12: 0000000000045010
[43069.553287] R13: 00000000000000b0 R14: 0000000000000000 R15: 0000000000000000
[43069.553290] FS:  00007f25b4f9d280(0000) GS:ff110004cb300000(0000)
knlGS:0000000000000000
[43069.553293] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[43069.553296] CR2: 0000555e19fdfd58 CR3: 000000012da70003 CR4: 0000000000371ef0
[43069.553305] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[43069.553308] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[43069.553311] Call Trace:
[43069.553313]  <TASK>
[43069.553315]  ? __warn+0xa4/0x220
[43069.553321]  ? kmem_cache_destroy+0x10d/0x1a0
[43069.553326]  ? report_bug+0x1d4/0x1e0
[43069.553332]  ? handle_bug+0x42/0x80
[43069.553336]  ? exc_invalid_op+0x18/0x50
[43069.553341]  ? asm_exc_invalid_op+0x1a/0x20
[43069.553347]  ? irq_work_claim+0x1e/0x40
[43069.553354]  ? kmem_cache_destroy+0x10d/0x1a0
[43069.553359]  ? kmem_cache_destroy+0x10d/0x1a0
[43069.553364]  exit_cifs+0x65/0x460 [cifs]
[43069.553494]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.553499]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.553503]  ? mark_held_locks+0x24/0x90
[43069.553508]  ? __x64_sys_close+0x54/0xa0
[43069.553512]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.553516]  ? kasan_quarantine_put+0x97/0x1f0
[43069.553520]  ? mark_held_locks+0x24/0x90
[43069.553526]  do_syscall_64+0x78/0x180
[43069.553530]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.553535] RIP: 0033:0x7f25b50bdd4b
[43069.553538] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.553541] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.553545] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.553548] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.553550] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.553553] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.553555] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.553562]  </TASK>
[43069.553564] irq event stamp: 9810
[43069.553565] hardirqs last  enabled at (9809): [<ffffffffa569d848>]
_raw_spin_unlock_irq+0x28/0x50
[43069.553570] hardirqs last disabled at (9810): [<ffffffffa569d543>]
_raw_spin_lock_irq+0x53/0x60
[43069.553574] softirqs last  enabled at (9692): [<ffffffffa41645fc>]
__irq_exit_rcu+0xfc/0x120
[43069.553579] softirqs last disabled at (9671): [<ffffffffa41645fc>]
__irq_exit_rcu+0xfc/0x120
[43069.553583] ---[ end trace 0000000000000000 ]---
[43069.614650] =============================================================================
[43069.614657] BUG cifs_mpx_ids (Tainted: G    B   W         ):
Objects remaining in cifs_mpx_ids on __kmem_cache_shutdown()
[43069.614662] -----------------------------------------------------------------------------

[43069.614663] Slab 0x00000000cfd8415b objects=32 used=1
fp=0x00000000bb9d9202
flags=0x17ffffe0000a40(workingset|slab|head|node=0|zone=2|lastcpupid=0x3fffff)
[43069.614672] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B   W
   6.9.0-rc6 #1
[43069.614676] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.614679] Call Trace:
[43069.614682]  <TASK>
[43069.614686]  dump_stack_lvl+0x79/0xb0
[43069.614696]  slab_err+0xb6/0xf0
[43069.614703]  ? do_raw_spin_lock+0x100/0x190
[43069.614709]  ? __pfx_do_raw_spin_lock+0x10/0x10
[43069.614714]  ? do_raw_spin_lock+0xf8/0x190
[43069.614718]  __kmem_cache_shutdown+0x176/0x310
[43069.614725]  kmem_cache_destroy+0x65/0x1a0
[43069.614735]  exit_cifs+0x7d/0x460 [cifs]
[43069.614882]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.614888]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.614891]  ? mark_held_locks+0x24/0x90
[43069.614897]  ? __x64_sys_close+0x54/0xa0
[43069.614901]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.614905]  ? kasan_quarantine_put+0x97/0x1f0
[43069.614910]  ? mark_held_locks+0x24/0x90
[43069.614916]  do_syscall_64+0x78/0x180
[43069.614921]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.614926] RIP: 0033:0x7f25b50bdd4b
[43069.614931] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.614934] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.614939] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.614942] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.614945] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.614947] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.614950] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.614956]  </TASK>
[43069.614961] Object 0x00000000b8ccc787 @offset=7936
[43069.614967] ------------[ cut here ]------------
[43069.614969] kmem_cache_destroy cifs_mpx_ids: Slab cache still has
objects when called from exit_cifs+0x7d/0x460 [cifs]
[43069.615194] WARNING: CPU: 6 PID: 13873 at mm/slab_common.c:497
kmem_cache_destroy+0x10d/0x1a0
[43069.615202] Modules linked in: loop cmac nls_utf8 cifs(-) cifs_arc4
nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver
nfs lockd grace netfs nf_conntrack_netbios_ns nf_conntrack_broadcast
xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT
nf_reject_ipv4 xt_conntrack ebtable_nat ip6table_nat ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_nat iptable_mangle
iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter sunrpc kvm_intel kvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3
sha1_ssse3 bochs drm_vram_helper drm_ttm_helper ttm drm_kms_helper drm
virtio_balloon floppy ip_tables xfs virtio_net crc32c_intel
net_failover sha256_ssse3 virtio_blk virtio_console failover
qemu_fw_cfg
[43069.615308] CPU: 6 PID: 13873 Comm: rmmod Tainted: G    B   W
   6.9.0-rc6 #1
[43069.615311] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[43069.615313] RIP: 0010:kmem_cache_destroy+0x10d/0x1a0
[43069.615318] Code: 48 89 ef 5b 5d 41 5c 41 5d e9 0f 08 09 00 48 8b
55 60 48 8b 4c 24 20 48 c7 c6 20 01 b6 a5 48 c7 c7 98 9d 38 a6 e8 d3
87 be ff <0f> 0b 48 c7 c7 a0 dd 9d a6 e8 d5 4c 12 01 5b 5d 41 5c 41 5d
e9 8a
[43069.615322] RSP: 0018:ff110001325e7df8 EFLAGS: 00010282
[43069.615325] RAX: dffffc0000000000 RBX: 1fe22000264bcfc6 RCX: ffffffffa42ea6de
[43069.615328] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ff110004cb336c40
[43069.615331] RBP: ff1100011c4dcc80 R08: 0000000000000001 R09: ffe21c00264bcf8d
[43069.615334] R10: ff110001325e7c6f R11: 0000000000000000 R12: 0000000000045010
[43069.615336] R13: 00000000000000b0 R14: 0000000000000000 R15: 0000000000000000
[43069.615339] FS:  00007f25b4f9d280(0000) GS:ff110004cb300000(0000)
knlGS:0000000000000000
[43069.615343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[43069.615345] CR2: 0000555e19fdfd58 CR3: 000000012da70003 CR4: 0000000000371ef0
[43069.615353] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[43069.615356] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[43069.615359] Call Trace:
[43069.615361]  <TASK>
[43069.615363]  ? __warn+0xa4/0x220
[43069.615369]  ? kmem_cache_destroy+0x10d/0x1a0
[43069.615374]  ? report_bug+0x1d4/0x1e0
[43069.615380]  ? handle_bug+0x42/0x80
[43069.615385]  ? exc_invalid_op+0x18/0x50
[43069.615389]  ? asm_exc_invalid_op+0x1a/0x20
[43069.615396]  ? tick_nohz_tick_stopped+0x1e/0x40
[43069.615402]  ? kmem_cache_destroy+0x10d/0x1a0
[43069.615407]  ? kmem_cache_destroy+0x10d/0x1a0
[43069.615413]  exit_cifs+0x7d/0x460 [cifs]
[43069.615542]  __do_sys_delete_module.constprop.0+0x23f/0x450
[43069.615546]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[43069.615550]  ? mark_held_locks+0x24/0x90
[43069.615555]  ? __x64_sys_close+0x54/0xa0
[43069.615559]  ? lockdep_hardirqs_on_prepare+0x139/0x200
[43069.615562]  ? kasan_quarantine_put+0x97/0x1f0
[43069.615568]  ? mark_held_locks+0x24/0x90
[43069.615574]  do_syscall_64+0x78/0x180
[43069.615578]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[43069.615583] RIP: 0033:0x7f25b50bdd4b
[43069.615586] Code: 73 01 c3 48 8b 0d 3d 11 0c 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 11 0c 00 f7 d8 64 89
01 48
[43069.615589] RSP: 002b:00007ffcfd0f6f08 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[43069.615593] RAX: ffffffffffffffda RBX: 0000555e19fd57a0 RCX: 00007f25b50bdd4b
[43069.615596] RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000555e19fd5808
[43069.615598] RBP: 0000000000000000 R08: 00007ffcfd0f5e81 R09: 0000000000000000
[43069.615600] R10: 00007f25b512fae0 R11: 0000000000000206 R12: 00007ffcfd0f7130
[43069.615603] R13: 00007ffcfd0f86ea R14: 0000555e19fd5260 R15: 0000555e19fd57a0
[43069.615609]  </TASK>
[43069.615611] irq event stamp: 9810
[43069.615613] hardirqs last  enabled at (9809): [<ffffffffa569d848>]
_raw_spin_unlock_irq+0x28/0x50
[43069.615618] hardirqs last disabled at (9810): [<ffffffffa569d543>]
_raw_spin_lock_irq+0x53/0x60
[43069.615622] softirqs last  enabled at (9692): [<ffffffffa41645fc>]
__irq_exit_rcu+0xfc/0x120
[43069.615627] softirqs last disabled at (9671): [<ffffffffa41645fc>]
__irq_exit_rcu+0xfc/0x120
[43069.615631] ---[ end trace 0000000000000000 ]---


-- 
Thanks,

Steve
