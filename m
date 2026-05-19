Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BC22F7EF5
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 23:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779234928; cv=none; b=i2HITJmkecRxlSGneJ72JTqTC1g4TpSbBa9PDbNaHJMKJ7KzOIB8rSVGuz0Gd9ro+BCjHzPI46WjKH75rIQF5NLCBQPAOucyap7Ymy1Gh0U5kl1CSkXJZ+eHOU0cPw4XLI7RcZUdVh+O7Z5nbcnoMHcc1VkbUAeA6oSvMlJGRqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779234928; c=relaxed/simple;
	bh=Zp6CHJxs+E4XA+zMTHKV+64A6NYbJM+gugGnaJ9dEqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e5a9Bk1KMRyXXTka9su98DRi66hEaXmOP5NjCwq8Eou1q1U71F0Na5U7j/MHNXj+zLLCjnGnHSvCOJBx7VWfQglNYH7cpWpLnkf78D3f3MvCKjbEg8t823SrJBAZxa8aWCsdHnGsd+uY7khetpuvikGxtcdEvxd+b5Bd36dRzk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=7emsxsUO; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="7emsxsUO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=G1M99H/xVU1n2wW47upMJU5PG51Yr09tny9Udw/r+hU=; b=7emsxsUOGn4rU1vSSQ4/DfpuTA
	x2ERrjqbJUI79n9PndKfjSxq2pSkVhZQVzHSMjXrB7wKePWH+6xQWyaU16V+5eEGc72EUEfhWFWds
	oLKuUJ2AbhTzUT7NQnN7wqyRHnYZKMk6Ov0f+HY6Agr96JBv7m0YV+v0RDdD2xmArI0JdD8QwTNsE
	naR0wYRhF5E850JuvC15gApKgtSLcJKwGzsgUkkr+ufPR6AsV0nGC6JcMKDeBENLDgJj0Nk7xofqO
	64jB7RgGXYgiI2hrud1Cjv/irWx101jwqyDVobJcsJfI8FMLMiqGBXTUjOZqthuLk93HMhVkleq/c
	bm+AUswg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wPU2B-000000005i0-047s;
	Tue, 19 May 2026 20:39:35 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>
Cc: Vaibhav Nagare <vnagare@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix double free in cached_dir_offload_close()
Date: Tue, 19 May 2026 20:39:34 -0300
Message-ID: <20260519233934.684906-1-pc@manguebit.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix double free of @tcon->origin_fullpath where T1 and T3 are
concurrently tearing down @tcon:

  T1

  cifs_umount()
    cifs_put_tlink()
      cifs_put_tcon()
        --tcon->tc_count [refcount=0]
        tconInfoFree()
          free_cached_dirs()
            cancel_delayed_work_sync(&cfids->laundromat_work)
          ...
          kfree(tcon->origin_fullpath) [1]

  T2

  cifs_laundromat_worker()
    ++tcon->tc_count [refcount=1]
    queue_work(serverclose_wq, &cfid->close_work())
    ...

  T3

  cached_dir_offload_close()
    close_cached_dir()
    cifs_put_tcon()
      --tcon->tc_count [refcount=0]
      tconInfoFree()
        ...
        kfree(tcon->origin_fullpath) [2] -> double free

  kernel BUG at mm/slub.c:530!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 27 PID: 4144774 Comm: kworker/27:2 Kdump: loaded Tainted: G L X
  ------ --- 5.14.0-611.9.1.el9_7.x86_64 #1
  Hardware name: HPE ProLiant DL360 Gen11/ProLiant DL360 Gen11, BIOS
  2.50 04/22/2025
  Workqueue: serverclose cached_dir_offload_close [cifs]
  RIP: 0010:__slab_free+0x1d0/0x310
  ...
  Call Trace:
   <TASK>
   ? show_trace_log_lvl+0x1c4/0x2df
   ? show_trace_log_lvl+0x1c4/0x2df
   ? kfree+0x2a6/0x330
   ? __die_body.cold+0x8/0xd
   ? die+0x2b/0x50
   ? do_trap+0xcd/0x120
   ? __slab_free+0x1d0/0x310
   ? do_error_trap+0x65/0x80
   ? __slab_free+0x1d0/0x310
   ? exc_invalid_op+0x4e/0x70
   ? __slab_free+0x1d0/0x310
   ? asm_exc_invalid_op+0x16/0x20
   ? tconInfoFree+0x4b/0xf0 [cifs]
   ? __slab_free+0x1d0/0x310
   ? work_grab_pending+0x43/0xe0
   ? free_cached_dirs+0x1a8/0x1d0 [cifs]
   ? tconInfoFree+0x4b/0xf0 [cifs]
   kfree+0x2a6/0x330
   ? free_cached_dirs+0x1a8/0x1d0 [cifs]
   tconInfoFree+0x4b/0xf0 [cifs]
   cifs_put_tcon+0x169/0x370 [cifs]
   process_one_work+0x193/0x380
   worker_thread+0x281/0x3a0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x101/0x110
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x28/0x50
   </TASK>

Check for TID_EXITING earlier in cifs_put_tcon() to guarantee that
thread which set it will be the only one responsible for tearing down
@tcon.

Make sure that any queued workers in @serverclose_wq and @cfid_put_wq
are processed before leaving free_cached_dirs().  Note that any
cifs_put_tcon() call from the workqueues will turn into a no-op due to
@tcon->status == TID_EXITING, so the refcount bumps won't matter.

Reported-by: Vaibhav Nagare <vnagare@redhat.com>
Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instances drop their dentry")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jay Shin <jaeshin@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cached_dir.c | 4 ++++
 fs/smb/client/connect.c    | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 88d5e9a32f28..47a51b6b397e 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -691,9 +691,11 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			cfid->on_list = false;
 			cfids->num_entries--;
 
+			spin_lock(&tcon->tc_lock);
 			++tcon->tc_count;
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 					    netfs_trace_tcon_ref_get_cached_lease_break);
+			spin_unlock(&tcon->tc_lock);
 			queue_work(cfid_put_wq, &cfid->put_work);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
@@ -851,7 +853,9 @@ void free_cached_dirs(struct cached_fids *cfids)
 	if (cfids == NULL)
 		return;
 
+	flush_workqueue(cfid_put_wq);
 	cancel_delayed_work_sync(&cfids->laundromat_work);
+	flush_workqueue(serverclose_wq);
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dcde25da468d..c55b4c040a30 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2605,6 +2605,11 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
 	spin_lock(&tcon->tc_lock);
+	if (tcon->status == TID_EXITING) {
+		spin_unlock(&tcon->tc_lock);
+		spin_unlock(&cifs_tcp_ses_lock);
+		return;
+	}
 	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count - 1, trace);
 	if (--tcon->tc_count > 0) {
 		spin_unlock(&tcon->tc_lock);
-- 
2.54.0

