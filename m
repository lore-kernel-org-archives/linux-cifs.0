Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7868240DB2E
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 10:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786617689; cv=none; b=l+LbprvixHBKifFrj88NJBOCExoEmN7ySM6gWnTHhw0aBRMLSYRu+hDKZ7jBau8WuV+hne+XLZkn1nvCyNanlzlVjAjQ43WfCK1rg5Egd2SxaxoYRCN6hrm7qN3HsiGLcMpEwt6Y0elk29w+CpSKKXWcFkO5ljMmgZLPBEnaDS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786617689; c=relaxed/simple;
	bh=tODWp/ny09wbM0oAUnm1s+AbOryUQjizNkBbOSi77Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bqoc1sr3fyNtly+vZWJsZaq6LJuxBWRv5IkMs/Z/gMw3j0EtBT9VccGvASOSaGBkEUuydSz3LcHRIQodD3lLP2XUOYnLP/H/myVHuisPPrN7Cl//ZbM9qK9GbEnq1MZXYQJ+SM8OqVmLi1NG7E4iZOmxDaFYGCa/HbXr/JcRCiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=m1PxJsob; arc=none smtp.client-ip=95.215.58.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="m1PxJsob"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tODWp/ny09wbM0oAUnm1s+AbOryUQjizNkBbOSi77Zw=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786617681; v=1; x=1787222481;
 b=m1PxJsobWDiGeYygMljOfkGlPU4zX8zh9lhE4IuzsdfFs2eqA0FlEmS+RE7TixxLvZjEjXTb
 s/VSYqd51LjgFFodzh2RzOAfnthap1I/umQyg56o5VIWIiCxcYDjxcPmUXl0KPZjjnw36rpZfgu
 0eihASx9KjG+r4ufFX9/jhBok/WsVq6hlxFg97NlOssp7yTq4y1PNbWgKrOmpQi8OyAk2zJrd3w
 Eh1Q64GvWKd3HgU2lBURX64iEgoLGpcPFlTd9mO3V8j4Q46jEY3B7Ki3IOr8cdB/o5F+7pQ8if2
 esO/TYLZGxAvG+Z4fO3tRf3NLoJq2LWLpUaHMbUIVD25g==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 49769a1975749408;
	Thu, 13 Aug 2026 10:41:11 +0000
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	obnred@gmail.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: fix use-after-free in ksmbd_conn_transport_destroy()
Date: Thu, 13 Aug 2026 10:40:42 +0000
Message-ID: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer (Link[1]):

  1. Build kernel with CONFIG_KASAN=y
  2. server: systemctl start ksmbd
  3. client: mount -t cifs //localhost/export /mnt
  4. client: umount /mnt
  5. server: modprobe -r ksmbd

The error message is as follows:

  ==================================================================
  BUG: KASAN: slab-use-after-free in proc_remove+0x3e/0x80
  Read of size 8 at addr ffff88810654e098 by task modprobe/785
  ...
  Call Trace:
   <TASK>
   __dump_stack+0x19/0x30
   dump_stack_lvl+0x49/0x60
   print_address_description+0x7b/0x200
   print_report+0x5b/0x70
   kasan_report+0xed/0x130
   __asan_report_load8_noabort+0x18/0x20
   proc_remove+0x3e/0x80
   ksmbd_conn_transport_destroy+0x2b/0x320 [ksmbd]
   cleanup_module+0x33/0xe00 [ksmbd]
   __se_sys_delete_module+0x276/0x400
   __x64_sys_delete_module+0x5f/0x70
   x64_sys_call+0x2675/0x3030
   do_syscall_64+0xf0/0x3b0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f5b56d2b02b
  ...
   </TASK>

  Allocated by task 159:
   kasan_save_track+0x2f/0x70
   kasan_save_alloc_info+0x40/0x50
   __kasan_slab_alloc+0x52/0x70
   kmem_cache_alloc_noprof+0x168/0x3e0
   __proc_create+0x20b/0x710
   proc_create_single_data+0x78/0x150
   ksmbd_proc_create+0x24/0x30 [ksmbd]
   ksmbd_conn_transport_init+0x4f/0x80 [ksmbd]
   server_ctrl_handle_work+0x64/0x2c0 [ksmbd]
   process_scheduled_works+0x788/0xec0
   worker_thread+0x894/0xc10
   kthread+0x2e5/0x3c0
   ret_from_fork+0x168/0x4f0
   ret_from_fork_asm+0x1a/0x30

  Freed by task 785:
   kasan_save_track+0x2f/0x70
   kasan_save_free_info+0x4a/0x60
   __kasan_slab_free+0x47/0x70
   kmem_cache_free+0x122/0x410
   pde_put+0xfd/0x160
   remove_proc_subtree+0x365/0x540
   proc_remove+0x6a/0x80
   ksmbd_proc_cleanup+0x1f/0x60 [ksmbd]
   cleanup_module+0x18/0xe00 [ksmbd]
   __se_sys_delete_module+0x276/0x400
   __x64_sys_delete_module+0x5f/0x70
   x64_sys_call+0x2675/0x3030
   do_syscall_64+0xf0/0x3b0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  ==================================================================

Reported-by: Kyenghwan Hwang <obnred@gmail.com>
Link[1]: https://lore.kernel.org/linux-cifs/8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com/
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/server.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0ccd123ba418..d619d1f22601 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -596,11 +596,16 @@ static int ksmbd_server_shutdown(void)
 {
 	WRITE_ONCE(server_conf.state, SERVER_STATE_SHUTTING_DOWN);
 
-	ksmbd_proc_cleanup();
 	class_unregister(&ksmbd_control_class);
 	ksmbd_workqueue_destroy();
 	ksmbd_ipc_release();
 	ksmbd_conn_transport_destroy();
+	/*
+	 * ksmbd_conn_transport_destroy() calls delete_proc_clients() and destroys
+	 * sessions. ksmbd_session_destroy() removes each session's proc entry.
+	 * Keep the procfs tree alive until these entries have been removed.
+	 */
+	ksmbd_proc_cleanup();
 	ksmbd_crypto_destroy();
 	ksmbd_free_global_file_table();
 	destroy_lease_table(NULL);
-- 
2.54.0

