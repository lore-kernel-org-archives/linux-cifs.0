Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B391990C7
	for <linux-cifs@vger.kernel.org>; Tue, 23 Dec 2025 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766449209; cv=none; b=R2XyI/J7nUD8BeNvMzGSSZ89LY4YmI3Wa+6bq6jEshTtUA4rn8esqcqBFi0MKrEkS0R3kpe9S/9fiK/JCzw9aAFUJPBIudJCL+MOxdt0TC3PUyfROk0ugJG5l0husQhKdfNfBjX7JtyYK5/hrCkdndHoRrQDbDxtxdwlD4dE6c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766449209; c=relaxed/simple;
	bh=7pUuEIqNSWm4io05zoz5XQc4h9nHm7vqIWppJtQS7ng=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=OmCyIPJLtofx0CpxxCdVW4+ldXuLArGomUFajYNXGMpdh15OPSlVY3XbVouj2faheH8zTjTDpGZBMFuhBF7nhbVsm6yEyYhZG6ZJQdIun7xX5bcKsloOrs3u0vpcG9cmZo0Mk2eym8RJ5ZroU+q0iczLRQvML1SoW516mKJzptg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U9IiKKS4; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U9IiKKS4"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b5ed9e7500so323122985a.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 16:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766449206; x=1767054006; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4v3LipYjiAHFVfRVXQ15C1pC6/puxu+fzH1mN1MQdwM=;
        b=U9IiKKS4diBPgA7fB39nhnqR5jlzM66gYMS/a3Nj9vG+xOtGJSYC5px9PnMohYfq7j
         VGBESe6ltSTgB8brGXGVBvC7ItHk+nv47L0zPbzzNUEFz+hxxXcKZRX3LSDO2J2NIDye
         EE0GvGwTnqf/YIHhQ9eqh7SQEI2tr9LY2X9XinlYga5VCziMFn0RqDSh9ch95RTu1RNC
         mvWzoxIYvz3IKusHbFn+iB5sjtAxe4iRk2ZMNXCWAhk0NMCMdYBRvUujBTav/z0ga3B6
         oSY5mmVfPBusyFwewd6yGXYbS/MChlJOF+N6tQtiUSmS+qjQe0nqZsU0Cvi6E99PZMNa
         UBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766449206; x=1767054006;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4v3LipYjiAHFVfRVXQ15C1pC6/puxu+fzH1mN1MQdwM=;
        b=Shmz1UeajtalffM8PHmQAny6iJZIgJ0VPKxyzPb0CWszARSh0/dH8ljhdhbu0lwa2x
         x8MYgySqreRC2+FSJtuNJBSLacdmWTQ3m7xmwvotY/eP5sXQpbwRM1+/oRGl8Ya7krRs
         jvJywaa3hkxrGrM407+zNcazfnr7nB+nLFoi4xKf7zlNisn9dI4mP+PR3ybv/zHYSURL
         vyS1914VLwx5w3OYy+ORWpMgpPdRNdYMdHFyJJ1VexmUA6CHINKgtN20y27DPEuTlLk1
         95wKZtqc0nD6aFXV8B5GrPhLXZp04ikniLVy6iVOCK9Ti21SX/k36wQ+HMknwVUm+a6n
         vWYA==
X-Forwarded-Encrypted: i=1; AJvYcCV6yi3poTFZotpVLuHlVGmxSiuJUMs9Sd6mpwHUZBm7gDarzMnahAqLUsmCpR3W2+A2UqKLZhbWa1e5@vger.kernel.org
X-Gm-Message-State: AOJu0YwHOU8/tsmbEl7Ao7SvbjEwkQjVSj90KLaI6o19y+dZ0TnyC30f
	HcleGEHJczd9trH0YsFSfWZYLXYgvt4FWcbNFRcSWnaLlX9aEn0eGPZ/vTvoDCn0bNlYeI7FaDs
	lUPmFJHATG1uD3l1KesqkJvztBUSLzB8=
X-Gm-Gg: AY/fxX68DkmWHaFyzH+FxxDTdbN5aI6a1wIWnZ/l5EirCR9saJVpbuh1aHc1smyPTkI
	dz39jCKozk/LJmqJllRazmTfNte4bb85g6VaAhKmwuTQnFhWQ+DrgQB17o+8BGo+67EbAW/CczG
	DoePQrzI9aJxKiwoP21Quoj6oqsUFJv84AZqroPepUvO0RE/izwanEK6s7+pPFX+Ld1dNZdU76S
	HXpvFPSPpPt0Qa4MT8AoGk+TPfCFbJaKmcOnePkKZFR4/lN6l+tnLTF440Xlez8q4XcMHWamhCE
	aHYbNR9IJ+0WaszqqAX4gLqmWzkV43uLKCZo0E4RHSTfnnA6m0UG08DCAfytJLzuFxR16aXU8o1
	DycW5a6QP85nHoMGGC1Eph3NZlbibPXX/T4J7Xo0u04wZy17UVbq7qWox2Dqa
X-Google-Smtp-Source: AGHT+IG7h4FDeNU1iHQ/ahgPAEtboESM4mvrKeCA+5Gkt4OSF+47IKbgwejAh8Bd9/OG+GFi6JInogwC7CgB4inN8H4=
X-Received: by 2002:a05:620a:c55:b0:8a2:7cda:f040 with SMTP id
 af79cd13be357-8c08fd27d9fmr1811343585a.51.1766449206284; Mon, 22 Dec 2025
 16:20:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 22 Dec 2025 18:19:55 -0600
X-Gm-Features: AQt7F2rYkrIPfOWkLcAPbijrWSeCnsNqunADCMfNso52L7NpNAaY1zVwNtJDGtw
Message-ID: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
Subject: generic/013 failure to Samba
To: ChenXiaoSong <chenxiaosong@kylinos.cn>, David Howells <dhowells@redhat.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Do you see this dmesg when running generic/013 to Samba (with 6.19-rc2)?

21943.198920] UBSAN: array-index-out-of-bounds in
fs/smb/client/smb2ops.c:1912:27
[21943.198930] index 1 is out of range for type 'srv_copychunk [*]'
[21943.198938] CPU: 6 UID: 0 PID: 13663 Comm: fsstress Kdump: loaded
Not tainted 6.19.
0-rc2+ #16 PREEMPT(voluntary)
[21943.198944] Hardware name: LENOVO 21KAS0JB00/21KAS0JB00, BIOS
R2FET63W (1.43 ) 03/2
0/2025
[21943.198947] Call Trace:
[21943.198951]  <TASK>
[21943.198960]  dump_stack_lvl+0x5f/0x90
[21943.198972]  dump_stack+0x10/0x18
[21943.198976]  ubsan_epilogue+0x9/0x39
[21943.198982]  __ubsan_handle_out_of_bounds.cold+0x50/0x55
[21943.198996]  smb2_copychunk_range+0xa2e/0xc50 [cifs]
[21943.199074]  smb3_fallocate+0xaa3/0xf90 [cifs]
[21943.199116]  ? cap_inode_need_killpriv+0x1e/0x40
[21943.199123]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199128]  ? security_inode_need_killpriv+0x4f/0x140
[21943.199135]  ? aa_file_perm+0x68/0x5e0
[21943.199141]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199146]  cifs_fallocate+0xfe/0x1a0 [cifs]
[21943.199202]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199204]  ? common_file_perm+0x5d/0x1e0
[21943.199209]  vfs_fallocate+0x178/0x3c0
[21943.199218]  __x64_sys_fallocate+0x4a/0xc0
[21943.199221]  ? __do_sys_newfstatat+0x57/0x90
[21943.199227]  x64_sys_call+0x163c/0x2360
[21943.199231]  do_syscall_64+0x82/0x4d0
[21943.199243]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199245]  ? __x64_sys_newfstatat+0x1c/0x30
[21943.199248]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199250]  ? x64_sys_call+0x1510/0x2360
[21943.199252]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199255]  ? do_syscall_64+0xbf/0x4d0
[21943.199259]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199262]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199264]  ? do_syscall_64+0x271/0x4d0
[21943.199268]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199271]  ? __x64_sys_newfstatat+0x1c/0x30
[21943.199273]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199276]  ? x64_sys_call+0x1510/0x2360
[21943.199278]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199280]  ? do_syscall_64+0xbf/0x4d0
[21943.199284]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199287]  ? do_user_addr_fault+0x2ee/0x830
[21943.199293]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199295]  ? irqentry_exit+0xa5/0x600
[21943.199300]  ? srso_alias_return_thunk+0x5/0xfbef5
[21943.199303]  ? exc_page_fault+0x90/0x1b0
[21943.199306]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[21943.199308] RIP: 0033:0x74b2186a0186
[21943.199312] Code: 47 ba 04 00 00 00 48 8b 05 87 3c 19 00 64 89 10
48 c7 c2 ff ff ff
 ff c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48 8b 45 10 0f 05 <48> 89
c2 48 3d 00 f0 ff
 ff 77 0f c9 48 89 d0 c3 66 2e 0f 1f 84 00
[21943.199314] RSP: 002b:00007ffd142f3610 EFLAGS: 00000202 ORIG_RAX:
000000000000011d
[21943.199318] RAX: ffffffffffffffda RBX: 00007ffd142f3710 RCX: 000074b2186a0186
[21943.199320] RDX: 000000000095c82c RSI: 0000000000000020 RDI: 0000000000000004
[21943.199322] RBP: 00007ffd142f3620 R08: 0000000000000000 R09: 0000000000000000
[21943.199324] R10: 00000000000011e7 R11: 0000000000000202 R12: 0000000000000004
[21943.199325] R13: 00000000000011e7 R14: 0000000000000054 R15: 0000000000000020
[21943.199331]  </TASK>


-- 
Thanks,

Steve
