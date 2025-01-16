Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3742153808
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2025 17:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737048558; cv=none; b=PneJPQT33nbT2VIq6kSEbawewCCTM3yXVEq9FlKIXli8rWu7V5C9KEsLGbEYuFwd/VH9d6H4Mc+VIZx9t6Z+hBRwgQwfmdFejuk1wkbnwvCQB05dBc5/g7Iax0KxmAM3j7WLAL3qNJE4JDV8pao78N06NfIKYQYBJ9qtZ9Kg+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737048558; c=relaxed/simple;
	bh=IQPkDgs4YGUZuEIxC3lWZToVzJd7Cc3jEeDyW3vtdOc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jC0AKVu4CM8+zaC3uv2bP5LtpkT4LFdhCiGSA5NPu6A47G5djTFsliCW4N6j3SYF3Lor6/cqEKxgcXnlDz7yrnqJcnEYJAx4GUb0/eEt/7e+LoEqLV6lmgfcKbQSx23BZq/5WKG0FaQAZC009pzRc9CcV3+/F6n4YaINV0icaaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=pO3gb4Gd; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="pO3gb4Gd"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1737048549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+hSPk+3DVF0gL4XnbUKolfibpFStM/xRRZw3MUaKlhc=;
	b=pO3gb4GdJ08y8WPuq2pFRrlAp0CNL8v56kZT4DuOY6x4G+p6lirldWaQZfqgMupp7W5+jU
	XHtIGRzFwVFEUIP3hTgk+s2OpPa7/C76PrDT3N+iFBcK+5ZW0FPER1IBB3SX4ZNVLALaiA
	IhMtZCM7sObaox64RMNBG1U50UBzgQWqGZn9E9RBInocgQf1Giv9QdusaWhzmhtF0Mypci
	oaR6jLieWhVrkxFdVc58qZuqp8Uqt58yxCdGpRkPLdZLKBQZz7/1jjb/os5KByao1/iS44
	ah2JuI6FQ2d6Ju4PSKJAZDs7bYoiVDCdmO8xlHIvjx6Ph9c05a6X9sTKVUbuBQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Jay Shin <jaeshin@redhat.com>
Subject: [PATCH] smb: client: fix oops due to unset link speed
Date: Thu, 16 Jan 2025 14:29:03 -0300
Message-ID: <20250116172903.666243-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It isn't guaranteed that NETWORK_INTERFACE_INFO::LinkSpeed will always
be set by the server, so the client must handle any values and then
prevent oopses like below from happening:

Oops: divide error: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 1323 Comm: cat Not tainted 6.13.0-rc7 #2
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-3.fc41
04/01/2014
RIP: 0010:cifs_debug_data_proc_show+0xa45/0x1460 [cifs] Code: 00 00 48
89 df e8 3b cd 1b c1 41 f6 44 24 2c 04 0f 84 50 01 00 00 48 89 ef e8
e7 d0 1b c1 49 8b 44 24 18 31 d2 49 8d 7c 24 28 <48> f7 74 24 18 48 89
c3 e8 6e cf 1b c1 41 8b 6c 24 28 49 8d 7c 24
RSP: 0018:ffffc90001817be0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88811230022c RCX: ffffffffc041bd99
RDX: 0000000000000000 RSI: 0000000000000567 RDI: ffff888112300228
RBP: ffff888112300218 R08: fffff52000302f5f R09: ffffed1022fa58ac
R10: ffff888117d2c566 R11: 00000000fffffffe R12: ffff888112300200
R13: 000000012a15343f R14: 0000000000000001 R15: ffff888113f2db58
FS: 00007fe27119e740(0000) GS:ffff888148600000(0000)
knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe2633c5000 CR3: 0000000124da0000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body.cold+0x19/0x27
 ? die+0x2e/0x50
 ? do_trap+0x159/0x1b0
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? do_error_trap+0x90/0x130
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? exc_divide_error+0x39/0x50
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? asm_exc_divide_error+0x1a/0x20
 ? cifs_debug_data_proc_show+0xa39/0x1460 [cifs]
 ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
 ? seq_read_iter+0x42e/0x790
 seq_read_iter+0x19a/0x790
 proc_reg_read_iter+0xbe/0x110
 ? __pfx_proc_reg_read_iter+0x10/0x10
 vfs_read+0x469/0x570
 ? do_user_addr_fault+0x398/0x760
 ? __pfx_vfs_read+0x10/0x10
 ? find_held_lock+0x8a/0xa0
 ? __pfx_lock_release+0x10/0x10
 ksys_read+0xd3/0x170
 ? __pfx_ksys_read+0x10/0x10
 ? __rcu_read_unlock+0x50/0x270
 ? mark_held_locks+0x1a/0x90
 do_syscall_64+0xbb/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe271288911
Code: 00 48 8b 15 01 25 10 00 f7 d8 64 89 02 b8 ff ff ff ff eb bd e8
20 ad 01 00 f3 0f 1e fa 80 3d b5 a7 10 00 00 74 13 31 c0 0f 05 <48> 3d
00 f0 ff ff 77 4f c3 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec
RSP: 002b:00007ffe87c079d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000040000 RCX: 00007fe271288911
RDX: 0000000000040000 RSI: 00007fe2633c6000 RDI: 0000000000000003
RBP: 00007ffe87c07a00 R08: 0000000000000000 R09: 00007fe2713e6380
R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000040000
R13: 00007fe2633c6000 R14: 0000000000000003 R15: 0000000000000000
 </TASK>

Fix this by setting cifs_server_iface::speed to a sane value (1Gbps)
by default when link speed is unset.

Cc: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
Reported-by: Frank Sorenson <sorenson@redhat.com>
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 87cb1872db28..9790ff2cc5b3 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -658,7 +658,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 
 	while (bytes_left >= (ssize_t)sizeof(*p)) {
 		memset(&tmp_iface, 0, sizeof(tmp_iface));
-		tmp_iface.speed = le64_to_cpu(p->LinkSpeed);
+		/* default to 1Gbps when link speed is unset */
+		tmp_iface.speed = le64_to_cpu(p->LinkSpeed) ?: 1000000000;
 		tmp_iface.rdma_capable = le32_to_cpu(p->Capability & RDMA_CAPABLE) ? 1 : 0;
 		tmp_iface.rss_capable = le32_to_cpu(p->Capability & RSS_CAPABLE) ? 1 : 0;
 
-- 
2.47.1

