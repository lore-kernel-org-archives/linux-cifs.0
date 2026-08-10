Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9687E2D781B
	for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2026 08:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350661; cv=none; b=L9X69Say0CPzSKqe5ZQQ6qyPC3EAdHl7ZQGe34Cn89nxv6hU+qPlQKrFCdeM8MJiEYS0wgXB+rHgsHZ5uW2l385cfAOWF9D7hUmDfJU1aVt00f8w+OonbKYtmG8CD8fc2v6K9JWY89jXMuyDibIpqsLK7tmCNXxr6FNpMVRk/1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350661; c=relaxed/simple;
	bh=jkDRyS+QX2EtDVGdbpYGqMMOifEnwi99w2W25ZaeeCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J/Kpda3VFLXt48LR6qbEYP1AtTMPumucUxyl/j4U4bl1UexrmJUMqJ1/E0EXM/LV+SCL8cqeTa40/zQnPU0kT0b+VPWYSfixezHdD6CreeJBZhbYxHA/gZ3nh9eM5bQHIhR9XkoXrcYEaUhsuzlPQ9kYmPyZIM9bimHXu7NbXHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mizP+abu; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mizP+abu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786350654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q0AL3N9OyxDrvOkRIvbO7pjLEkPoSTS8NY56crWOzTc=;
	b=mizP+abuIC00Ngs0sA0Em6cZsaK+nBcMn4RmwVpmxslx0am7FnAvQwz+faEPtTYioB/4on
	ZoklqYRQTvZ9ij1XxQOyk+9DFO2IFQtV52mCEwE47ijm1Ij0/F0NvO8HzrmxLmPD6T8WuX
	w0pqFIzg1wuJhRXSqhqrdSh9vMCojfhYHqSwvuqMgSusqLl02di3LkEYwAayGiN0PtVakE
	K1y/EVLET12c6MFnqAVOMcFC+GxghB/UxmniduEc0fDxvF8gGRx24I3W55tmwxpoSinUZL
	q4otFXlyK2TYDrpxzAbd/dmADppQaRsv+CZRJFKjoTMd7pVYfJ7C52XFMiV+Ig==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH samba] smbd: break directory leases before sending notify events
Date: Mon, 10 Aug 2026 08:29:55 +0000
Message-ID: <20260810082955.1128900-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. samba: `smb.conf`:
     [global]
         smb3 directory leases = yes
  2. samba:
     systemctl start smb # fedora
  3. Windows 11 File Explorer:
     Mount the share and enter the top-level directory of the mount point.
  4. samba: touch /export/file
  5. Windows 11 File Explorer:
     `file` does not appear in the top-level directory of the mount point.

Windows can keep directory data in a cache while it has a directory
lease. A file change made on the server does not use the SMB request
path, so the lease is not broken.

The server sends a notify event, but Windows may still use the old data.
Some new files are then not shown in File Explorer.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 source3/smbd/notify.c           |  7 ++++++-
 source3/smbd/notifyd/fcn_wait.c |  2 +-
 source3/smbd/notifyd/notifyd.c  |  2 +-
 source3/smbd/proto.h            |  1 +
 source3/smbd/smb2_oplock.c      | 37 +++++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/source3/smbd/notify.c b/source3/smbd/notify.c
index 5970a7a9220..24dcedb9dba 100644
--- a/source3/smbd/notify.c
+++ b/source3/smbd/notify.c
@@ -262,10 +262,15 @@ static struct files_struct *notify_fsp_cb(struct files_struct *fsp,
 					  void *private_data)
 {
 	struct notify_fsp_state *state = private_data;
+	uint32_t action = state->e->action;
 
 	if (fsp == state->notified_fsp) {
 		DBG_DEBUG("notify_callback called for %s\n", fsp_str_dbg(fsp));
-		notify_fsp(fsp, state->when, state->e->action, state->e->path);
+		if (action & NOTIFY_ACTION_DIRLEASE_BREAK) {
+			contend_dirleases_by_fsp(fsp);
+			action &= ~NOTIFY_ACTION_DIRLEASE_BREAK;
+		}
+		notify_fsp(fsp, state->when, action, state->e->path);
 		return fsp;
 	}
 
diff --git a/source3/smbd/notifyd/fcn_wait.c b/source3/smbd/notifyd/fcn_wait.c
index e32240d911a..6b5b6e66d43 100644
--- a/source3/smbd/notifyd/fcn_wait.c
+++ b/source3/smbd/notifyd/fcn_wait.c
@@ -256,7 +256,7 @@ NTSTATUS fcn_wait_recv(
 		*when = evt->msg.when;
 	}
 	if (action != NULL) {
-		*action = evt->msg.action;
+		*action = evt->msg.action & ~NOTIFY_ACTION_DIRLEASE_BREAK;
 	}
 
 	DLIST_REMOVE(state->events, evt);
diff --git a/source3/smbd/notifyd/notifyd.c b/source3/smbd/notifyd/notifyd.c
index 0b07ab3e435..a42a7a9162e 100644
--- a/source3/smbd/notifyd/notifyd.c
+++ b/source3/smbd/notifyd/notifyd.c
@@ -579,7 +579,7 @@ static void notifyd_sys_callback(struct sys_notify_context *ctx,
 
 	msg = (struct notify_trigger_msg) {
 		.when = timespec_current(),
-		.action = ev->action,
+		.action = ev->action | NOTIFY_ACTION_DIRLEASE_BREAK,
 		.filter = filter,
 	};
 
diff --git a/source3/smbd/proto.h b/source3/smbd/proto.h
index 7ced3a3ffd5..012039c7a5f 100644
--- a/source3/smbd/proto.h
+++ b/source3/smbd/proto.h
@@ -730,6 +730,7 @@ void smbd_contend_level2_oplocks_end(files_struct *fsp,
 void contend_dirleases(struct connection_struct *conn,
 		       const struct smb_filename *smb_fname,
 		       const struct smb2_lease *lease);
+void contend_dirleases_by_fsp(struct files_struct *fsp);
 bool init_oplocks(struct smbd_server_connection *sconn);
 void init_kernel_oplocks(struct smbd_server_connection *sconn);
 
diff --git a/source3/smbd/smb2_oplock.c b/source3/smbd/smb2_oplock.c
index 2489090af55..4de33889eff 100644
--- a/source3/smbd/smb2_oplock.c
+++ b/source3/smbd/smb2_oplock.c
@@ -1398,6 +1398,43 @@ void contend_dirleases(struct connection_struct *conn,
 	TALLOC_FREE(lck);
 }
 
+void contend_dirleases_by_fsp(struct files_struct *fsp)
+{
+	struct dirlease_break_state state = {
+		.sconn = fsp->conn->sconn,
+		.file_id = fsp->file_id,
+	};
+	struct share_mode_lock *lck = NULL;
+	uint32_t access_mask, share_mode;
+	bool ok;
+
+	if (!lp_smb3_directory_leases() || !fsp->fsp_flags.is_directory) {
+		return;
+	}
+
+	lck = get_existing_share_mode_lock(talloc_tos(), state.file_id);
+	if (lck == NULL) {
+		return;
+	}
+
+	ok = share_mode_forall_leases(lck, do_dirlease_break_to_none, &state);
+	if (!ok) {
+		DBG_WARNING("share_mode_forall_leases failed\n");
+	}
+
+	share_mode_flags_get(lck,
+			     &access_mask,
+			     &share_mode,
+			     NULL);
+	share_mode_flags_set(lck,
+			     access_mask,
+			     share_mode,
+			     state.total_lease_types,
+			     NULL);
+
+	TALLOC_FREE(lck);
+}
+
 /****************************************************************************
  This function is called on any file modification or lock request. If a file
  is level 2 oplocked then it must tell all other level 2 holders to break to
-- 
2.54.0

