Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E96150981
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731966642; cv=none; b=sNA/zwMJpxTDetsTQwXOVfEBtoAR7qnELpTXFRPGnRvXpz9mKMeEPG/p7SoWbcynhb/meYOtitrVTj4aKKYQS2mcbTt6+qJLWql9cjfg0vv+2kufxubgA0RK3VRaesByMDnkNwSPqaGt+iI5b2DGmj5lqrx8rhKgM2JEt5u7Gb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731966642; c=relaxed/simple;
	bh=7pC8WWnGKllVk08rsivXIGIXn5W5VeUS81Y+LAEFC2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWTMx5pSHEE+pvAaUM8p+/aXdGHaz6fnOIRRP/VDMNDGBSlFgqxProvqoMxtbdOkCuKt5lR89nvYmNoSLIN0dYdAN9zvq1F0gc6pHME3xVDzKFfZsCww9AIjjY9T5PKzdxGX//N2akw2I6VZmeS1aFBi2/cg55eQNY0xkd5d/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=HPa9+boQ; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=ek9Ij43w; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="HPa9+boQ";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="ek9Ij43w"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731966633; h=from : to : cc : subject : date : message-id :
 in-reply-to : references : mime-version : content-transfer-encoding :
 from; bh=4X/4KUZHzHMJg5arCl99IYVtwmYw+uOMDXcdr9WHh/0=;
 b=HPa9+boQPZRSnEC5WCEx8eBYp6MLIv0iWXKIheJiA85IoyEWVNMjeRSzbcsWcAz3xTYkz
 qT+VdzgRtBa6oSsBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731966633; h=from : to
 : cc : subject : date : message-id : in-reply-to : references :
 mime-version : content-transfer-encoding : from;
 bh=4X/4KUZHzHMJg5arCl99IYVtwmYw+uOMDXcdr9WHh/0=;
 b=ek9Ij43wRHvp+SMi/XJ8MJ4OnT8riKUCECD3ytl+PeUBZpDkA59w17uYjQJvHcZqTlbwR
 2DJ+v90ad6TAQb+KUFqVZNMTYbM3LtFfd45PHzmjlgf0tQypn75H9LG1LFd0RjI6FJRpDy0
 9cuo1tRs/FTIUAbS/L4fQwOl2bunmZCm8B1c+fEoBplgIi9RgHck4n6ucy8OUZKMAdLBwWm
 BhCJaMQ3UR/ZMzjGZoR516kbo/I4eItFojf99V6ENa84VA0aQEJGXRvABJaDVuT8gwii9Sj
 3KgaBio2FCz3wXD2YHIbC7anevtzLBZHk0c6SjXzwWcpHtg1j6orsymP4eEw==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id 9759583E7;
	Mon, 18 Nov 2024 13:50:33 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH v2 2/4] smb: Don't leak cfid when reconnect races with open_cached_dir
Date: Mon, 18 Nov 2024 13:50:26 -0800
Message-ID: <20241118215028.1066662-3-paul@darkrain42.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241118215028.1066662-1-paul@darkrain42.org>
References: <20241118215028.1066662-1-paul@darkrain42.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

open_cached_dir() may either race with the tcon reconnection even before
compound_send_recv() or directly trigger a reconnection via
SMB2_open_init() or SMB_query_info_init().

The reconnection process invokes invalidate_all_cached_dirs() via
cifs_mark_open_files_invalid(), which removes all cfids from the
cfids->entries list but doesn't drop a ref if has_lease isn't true. This
results in the currently-being-constructed cfid not being on the list,
but still having a refcount of 2. It leaks if returned from
open_cached_dir().

Fix this by setting cfid->has_lease when the ref is actually taken; the
cfid will not be used by other threads until it has a valid time.

Addresses these kmemleaks:

unreferenced object 0xffff8881090c4000 (size 1024):
  comm "bash", pid 1860, jiffies 4295126592
  hex dump (first 32 bytes):
    00 01 00 00 00 00 ad de 22 01 00 00 00 00 ad de  ........".......
    00 ca 45 22 81 88 ff ff f8 dc 4f 04 81 88 ff ff  ..E"......O.....
  backtrace (crc 6f58c20f):
    [<ffffffff8b895a1e>] __kmalloc_cache_noprof+0x2be/0x350
    [<ffffffff8bda06e3>] open_cached_dir+0x993/0x1fb0
    [<ffffffff8bdaa750>] cifs_readdir+0x15a0/0x1d50
    [<ffffffff8b9a853f>] iterate_dir+0x28f/0x4b0
    [<ffffffff8b9a9aed>] __x64_sys_getdents64+0xfd/0x200
    [<ffffffff8cf6da05>] do_syscall_64+0x95/0x1a0
    [<ffffffff8d00012f>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
unreferenced object 0xffff8881044fdcf8 (size 8):
  comm "bash", pid 1860, jiffies 4295126592
  hex dump (first 8 bytes):
    00 cc cc cc cc cc cc cc                          ........
  backtrace (crc 10c106a9):
    [<ffffffff8b89a3d3>] __kmalloc_node_track_caller_noprof+0x363/0x480
    [<ffffffff8b7d7256>] kstrdup+0x36/0x60
    [<ffffffff8bda0700>] open_cached_dir+0x9b0/0x1fb0
    [<ffffffff8bdaa750>] cifs_readdir+0x15a0/0x1d50
    [<ffffffff8b9a853f>] iterate_dir+0x28f/0x4b0
    [<ffffffff8b9a9aed>] __x64_sys_getdents64+0xfd/0x200
    [<ffffffff8cf6da05>] do_syscall_64+0x95/0x1a0
    [<ffffffff8d00012f>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

And addresses these BUG splats when unmounting the SMB filesystem:

BUG: Dentry ffff888140590ba0{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
WARNING: CPU: 3 PID: 3433 at fs/dcache.c:1536 umount_check+0xd0/0x100
Modules linked in:
CPU: 3 UID: 0 PID: 3433 Comm: bash Not tainted 6.12.0-rc4-g850925a8133c-dirty #49
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
RIP: 0010:umount_check+0xd0/0x100
Code: 8d 7c 24 40 e8 31 5a f4 ff 49 8b 54 24 40 41 56 49 89 e9 45 89 e8 48 89 d9 41 57 48 89 de 48 c7 c7 80 e7 db ac e8 f0 72 9a ff <0f> 0b 58 31 c0 5a 5b 5d 41 5c 41 5d 41 5e 41 5f e9 2b e5 5d 01 41
RSP: 0018:ffff88811cc27978 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888140590ba0 RCX: ffffffffaaf20bae
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff8881f6fb6f40
RBP: ffff8881462ec000 R08: 0000000000000001 R09: ffffed1023984ee3
R10: ffff88811cc2771f R11: 00000000016cfcc0 R12: ffff888134383e08
R13: 0000000000000002 R14: ffff8881462ec668 R15: ffffffffaceab4c0
FS:  00007f23bfa98740(0000) GS:ffff8881f6f80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556de4a6f808 CR3: 0000000123c80000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 d_walk+0x6a/0x530
 shrink_dcache_for_umount+0x6a/0x200
 generic_shutdown_super+0x52/0x2a0
 kill_anon_super+0x22/0x40
 cifs_kill_sb+0x159/0x1e0
 deactivate_locked_super+0x66/0xe0
 cleanup_mnt+0x140/0x210
 task_work_run+0xfb/0x170
 syscall_exit_to_user_mode+0x29f/0x2b0
 do_syscall_64+0xa1/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f23bfb93ae7
Code: ff ff ff ff c3 66 0f 1f 44 00 00 48 8b 0d 11 93 0d 00 f7 d8 64 89 01 b8 ff ff ff ff eb bf 0f 1f 44 00 00 b8 50 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 92 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffee9138598 EFLAGS: 00000246 ORIG_RAX: 0000000000000050
RAX: 0000000000000000 RBX: 0000558f1803e9a0 RCX: 00007f23bfb93ae7
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000558f1803e9a0
RBP: 0000558f1803e600 R08: 0000000000000007 R09: 0000558f17fab610
R10: d91d5ec34ab757b0 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000015 R15: 0000000000000000
 </TASK>
irq event stamp: 1163486
hardirqs last  enabled at (1163485): [<ffffffffac98d344>] _raw_spin_unlock_irqrestore+0x34/0x60
hardirqs last disabled at (1163486): [<ffffffffac97dcfc>] __schedule+0xc7c/0x19a0
softirqs last  enabled at (1163482): [<ffffffffab79a3ee>] __smb_send_rqst+0x3de/0x990
softirqs last disabled at (1163480): [<ffffffffac2314f1>] release_sock+0x21/0xf0
---[ end trace 0000000000000000 ]---

VFS: Busy inodes after unmount of cifs (cifs)
------------[ cut here ]------------
kernel BUG at fs/super.c:661!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 3433 Comm: bash Tainted: G        W          6.12.0-rc4-g850925a8133c-dirty #49
Tainted: [W]=WARN
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
RIP: 0010:generic_shutdown_super+0x290/0x2a0
Code: e8 15 7c f7 ff 48 8b 5d 28 48 89 df e8 09 7c f7 ff 48 8b 0b 48 89 ee 48 8d 95 68 06 00 00 48 c7 c7 80 7f db ac e8 00 69 af ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90
RSP: 0018:ffff88811cc27a50 EFLAGS: 00010246
RAX: 000000000000003e RBX: ffffffffae994420 RCX: 0000000000000027
RDX: 0000000000000000 RSI: ffffffffab06180e RDI: ffff8881f6eb18c8
RBP: ffff8881462ec000 R08: 0000000000000001 R09: ffffed103edd6319
R10: ffff8881f6eb18cb R11: 00000000016d3158 R12: ffff8881462ec9c0
R13: ffff8881462ec050 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f23bfa98740(0000) GS:ffff8881f6e80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8364005d68 CR3: 0000000123c80000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 kill_anon_super+0x22/0x40
 cifs_kill_sb+0x159/0x1e0
 deactivate_locked_super+0x66/0xe0
 cleanup_mnt+0x140/0x210
 task_work_run+0xfb/0x170
 syscall_exit_to_user_mode+0x29f/0x2b0
 do_syscall_64+0xa1/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f23bfb93ae7
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:generic_shutdown_super+0x290/0x2a0
Code: e8 15 7c f7 ff 48 8b 5d 28 48 89 df e8 09 7c f7 ff 48 8b 0b 48 89 ee 48 8d 95 68 06 00 00 48 c7 c7 80 7f db ac e8 00 69 af ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90
RSP: 0018:ffff88811cc27a50 EFLAGS: 00010246
RAX: 000000000000003e RBX: ffffffffae994420 RCX: 0000000000000027
RDX: 0000000000000000 RSI: ffffffffab06180e RDI: ffff8881f6eb18c8
RBP: ffff8881462ec000 R08: 0000000000000001 R09: ffffed103edd6319
R10: ffff8881f6eb18cb R11: 00000000016d3158 R12: ffff8881462ec9c0
R13: ffff8881462ec050 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f23bfa98740(0000) GS:ffff8881f6e80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8364005d68 CR3: 0000000123c80000 CR4: 0000000000350ef0

This reproduces eventually with an SMB mount and two shells running
these loops concurrently

- while true; do
      cd ~; sleep 1;
      for i in {1..3}; do cd /mnt/test/subdir;
          echo $PWD; sleep 1; cd ..; echo $PWD; sleep 1;
      done;
      echo ...;
  done
- while true; do
      iptables -F OUTPUT; mount -t cifs -a;
      for _ in {0..2}; do ls /mnt/test/subdir/ | wc -l; done;
      iptables -I OUTPUT -p tcp --dport 445 -j DROP;
      sleep 10
      echo "unmounting"; umount -l -t cifs -a; echo "done unmounting";
      sleep 20
      echo "recovering"; iptables -F OUTPUT;
      sleep 10;
  done

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Fixes: 5c86919455c1 ("smb: client: fix use-after-free in smb2_query_info_compound()")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/smb/client/cached_dir.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 585e1dc72432..59f07adf28d3 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -57,10 +57,20 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	cfid->cfids = cfids;
 	cfids->num_entries++;
 	list_add(&cfid->entry, &cfids->entries);
 	cfid->on_list = true;
 	kref_get(&cfid->refcount);
+	/*
+	 * Set @cfid->has_lease to true during construction so that the lease
+	 * reference can be put in cached_dir_lease_break() due to a potential
+	 * lease break right after the request is sent or while @cfid is still
+	 * being cached, or if a reconnection is triggered during construction.
+	 * Concurrent processes won't be to use it yet due to @cfid->time being
+	 * zero.
+	 */
+	cfid->has_lease = true;
+
 	spin_unlock(&cfids->cfid_list_lock);
 	return cfid;
 }
 
 static struct dentry *
@@ -174,16 +184,16 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (cfid == NULL) {
 		kfree(utf16_path);
 		return -ENOENT;
 	}
 	/*
-	 * Return cached fid if it has a lease.  Otherwise, it is either a new
-	 * entry or laundromat worker removed it from @cfids->entries.  Caller
-	 * will put last reference if the latter.
+	 * Return cached fid if it is valid (has a lease and has a time).
+	 * Otherwise, it is either a new entry or laundromat worker removed it
+	 * from @cfids->entries.  Caller will put last reference if the latter.
 	 */
 	spin_lock(&cfids->cfid_list_lock);
-	if (cfid->has_lease) {
+	if (cfid->has_lease && cfid->time) {
 		spin_unlock(&cfids->cfid_list_lock);
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
 	}
@@ -265,19 +275,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		goto oshr_free;
 
 	smb2_set_related(&rqst[1]);
 
-	/*
-	 * Set @cfid->has_lease to true before sending out compounded request so
-	 * its lease reference can be put in cached_dir_lease_break() due to a
-	 * potential lease break right after the request is sent or while @cfid
-	 * is still being cached.  Concurrent processes won't be to use it yet
-	 * due to @cfid->time being zero.
-	 */
-	cfid->has_lease = true;
-
 	if (retries) {
 		smb2_set_replay(server, &rqst[0]);
 		smb2_set_replay(server, &rqst[1]);
 	}
 
-- 
2.45.2

