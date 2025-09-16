Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A2021CC4D
	for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758029749; cv=none; b=ixMAkQnBk4eehzpZbj9aIU+JmXHNzGLtVg0YKPr7tSmX41KS9uwdTx8B0btE22rqBghsh2sGQISmLh75oJEouYqcFDmUHciSlyk1pycasV/fOqVcuMDku+Kzh+pc9VFUocoUFDKAFuaTQ3Sr/fbKo7TZywXlVwgQZJRTx/ZlknA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758029749; c=relaxed/simple;
	bh=ch28Ne7cqYIgKhLtJvPY0dOzOkwEPRSsiaw+vGkKj04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCSVPGsrXQ8m1UbaLDSFcr5bZ3KwO7oEtu2cvUbNBpJaARknyRSqOoiEVrCUVGYeEz3IUkb4ZpSEHWkoeO9tsU1rLr76Ta8Y5RTwz8qKkaWW0Mxrcwz2dRl5FuITeyHreaixw/+g5E7MSHYphefs+ZdmhzAxI0/yMyW7suuLgmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMf9nGHo; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMf9nGHo"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-266914a33e5so18461085ad.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 06:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758029747; x=1758634547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qVCR3EP4JoXWjobFtFLSHg6oQ+5KbS13iCbjIrNP6Q=;
        b=ZMf9nGHogyQlX5R+Y+k1XHHFYkwh7q7pSmPCDYybT+dJZGCSUwhVTv8tf8m7mTFuq6
         6qKrg0mVfnJOnck7y+EHPztUABiIHotXbfo0fkx/G8j2Q2CtRJ2AbSu+Mvsx/UF1URvN
         tJKScXfFvGf707yG3yx9XqGirQ5m3qXrxn1qbVCP3Ho+DiIDhAB0axiXPtMuyITJqr1a
         /G25jbJOhg4RfR0IA1W5ew820GWw6vLQffFlsE4g0iVgRht1Jb21VGbp3jky3R5cfWGf
         G1oJ/zG18f1u15bHdr1yYNnNARmMzc7ZrcltGxFl9o4dH2X/gapMHo7bS1CG6Ktpo6bD
         seng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758029747; x=1758634547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3qVCR3EP4JoXWjobFtFLSHg6oQ+5KbS13iCbjIrNP6Q=;
        b=H39UYNHl5n86G06XxmpLId9TqSLQi34bx94tNNN+GwNcZs//mGOgvcjk2Slnq38afM
         q1Yh8VSiS4hYzfc4VhG8Gq5PUT2GcciiQGVeJy+oLSGJq6R5SPgm3BmBWw/19wcyLZR3
         qsuTfwqa3qMfvWjJf9LbTwEq1BfyYUIj/zwQKYijMecdoFlOJ7liUJb2T0m6SZn+KJEc
         QZMKWLK4lModlI6HFAyIV0wFLhzfpRqJW+DyENMaXQXU4FWHTK+RkDshLktnyLtc3UGW
         eG/GMjbvEBJaHS77VcSCeIprrq4AEf4WMnhQu4putj6DgF2pHOWh/20q/d4QUQLye4c+
         RJag==
X-Gm-Message-State: AOJu0YzeJF4otN4jiY4g8M924C8crKFRWREkGVycOtVDq/5FgXYb0io1
	0hoOSudE3IKMoXuM82Ei96fG/Kxl75lVlGRIzJ8N/XMkMl1pBMxeJRSs
X-Gm-Gg: ASbGncuTQNBMoz2Q3teFxFHwnfd/yRL0M3LN19hI4WyU5GweJkN0GkLCDgiezT+4yM2
	2224jr/tiAaXwpWOewf+7gzFpjFzixKpeZWX8ushOOTBIGdiigdNVNuul2IfCWUdTvo4ctiiMs8
	9oY8+nqs26l8aEHt+aR+kmaFBODgKEp3jtbDlW2jaP2NReS+e8j75VDijnOeMAelx9qK5lZMK4O
	zuM78y/nfi8XEQ/I6dMc0KZIziCcTlLkMBDekMANoB1xARu0ym/EJvIoImvk0j5/iMk6y8oWUKA
	trwq7G0m3af+Z/m87Q0DwhaURlDjUf79L6KGTMzkpyjaBTuhGS26507Oh08cSljJDufuPCWmc9U
	HCUuCR4PiV1R1EURJ
X-Google-Smtp-Source: AGHT+IHoG1qmKHBxtBIpDfG8G1R+sPIstdiZzcD1AwIcqMAVjfEIV4zkZNbocPdHtPfc18o+PY6nTA==
X-Received: by 2002:a17:903:46c3:b0:264:3519:80d0 with SMTP id d9443c01a7336-264351981e4mr117498715ad.33.1758029746517;
        Tue, 16 Sep 2025 06:35:46 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267943346f1sm51578905ad.14.2025.09.16.06.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:35:46 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [RFC PATCH 2/2] smb: client: add directory change tracking via SMB2 Change Notify
Date: Tue, 16 Sep 2025 22:34:37 +0900
Message-ID: <20250916133437.713064-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916133437.713064-1-ekffu200098@gmail.com>
References: <20250916133437.713064-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement directory change tracking using SMB2 Change Notify protocol
to enable real-time monitoring of remote directories. Applications using
inotify now receive immediate notifications when files are created,
deleted, or renamed on SMB2+ shares.

This implementation begins by detecting tracking opportunities during
regular SMB operations. In the current version, the readdir() serves as
the detection point - when directory contents are accessed on SMB2+
servers, we check the inode's fsnotify_mask for active inotify watches.
If watches exist and directory is not already being tracked, we obtain a
new FiieId and send a SMB2_CHANGE_NOTIFY request that waits for changes.

Based on the server's response status, we convert CHANGE_NOTIFY response
to fsnotify events and deliver to application on success, mark for
future reconnection on network errors, or discard the response and
marked entries for broken. If tracking can continue, we resend
SMB2_CHANGE_NOTIFY for continuous monitoring.

Entries marked for reconnection are restored during SMB2 reconnection.
In the current version, smb2_reconnect() serves as restoration point -
when connection is reestablished, we obtain new FileIds and request
Change Notify requests for these entries.

Entries marked for unmount during unmount. In the current version,
cifs_umount() serves as unmount marking point. Entries marked for clean
are remove as soon as possible by the worker. Workers also run
periodically; currently every 30s; to check and remove untracking
directories.

This feature is controlled by CONFIG_CIFS_DIR_CHANGE_TRACKING with
experimental.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 fs/smb/client/Kconfig   |  17 ++
 fs/smb/client/Makefile  |   2 +
 fs/smb/client/connect.c |   6 +
 fs/smb/client/notify.c  | 535 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/client/notify.h  |  19 ++
 fs/smb/client/readdir.c |   9 +
 fs/smb/client/smb2pdu.c |   6 +
 7 files changed, 594 insertions(+)
 create mode 100644 fs/smb/client/notify.c
 create mode 100644 fs/smb/client/notify.h

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index a4c02199fef4..0e3911936e0c 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -218,4 +218,21 @@ config CIFS_COMPRESSION
 	  Say Y here if you want SMB traffic to be compressed.
 	  If unsure, say N.
 
++config CIFS_DIR_CHANGE_TRACKING
+	bool "Directory change tracking (Experimental)"
+	depends on CIFS && FSNOTIFY=y
+	default n
+	help
+          Enables automatic tracking of directory changes for SMB2 or later
+          using the SMB2 Change Notify protocol. File managers and applications
+          monitoring directories via inotify will receive real-time updates
+          when files are created, deleted, or renamed on the server.
+
+          This feature maintains persistent connections to track changes.
+          Each monitored directory consumes server resources and may increase
+          network traffic.
+
+          Say Y here if you want real-time directory monitoring.
+          If unsure, say N.
+
 endif
diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 4c97b31a25c2..85253bc1b4b0 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -35,3 +35,5 @@ cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
 cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o cifstransport.o
 
 cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
+
+cifs-$(CONFIG_CIFS_DIR_CHANGE_TRACKING) += notify.o
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dd12f3eb61dc..eebf729df16a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -51,6 +51,9 @@
 #endif
 #include "fs_context.h"
 #include "cifs_swn.h"
+#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
+#include "notify.h"
+#endif
 
 /* FIXME: should these be tunable? */
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
@@ -4154,6 +4157,9 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	cancel_delayed_work_sync(&cifs_sb->prune_tlinks);
 
 	if (cifs_sb->master_tlink) {
+#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
+		stop_track_sb_dir_changes(cifs_sb);
+#endif
 		tcon = cifs_sb->master_tlink->tl_tcon;
 		if (tcon) {
 			spin_lock(&tcon->sb_list_lock);
diff --git a/fs/smb/client/notify.c b/fs/smb/client/notify.c
new file mode 100644
index 000000000000..e38345965744
--- /dev/null
+++ b/fs/smb/client/notify.c
@@ -0,0 +1,535 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Directory change notification tracking for SMB
+ *
+ * Copyright (c) 2025, Sang-Heon Jeon <ekffu200098@gmail.com>
+ *
+ * References:
+ * MS-SMB2 "2.2.35 SMB2 CHANGE_NOTIFY Request"
+ * MS-SMB2 "2.2.36 SMB2 CHANGE_NOTIFY Response"
+ * MS-SMB2 "2.7.1 FILE_NOTIFY_INFORMATION"
+ * MS-SMB2 "3.3.5.19 Receiving and SMB2 CHANGE_NOTIFY Request"
+ * MS-FSCC "2.6 File Attributes"
+ */
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/fsnotify.h>
+#include "notify.h"
+#include "cifsproto.h"
+#include "smb2proto.h"
+#include "cached_dir.h"
+#include "cifs_debug.h"
+#include "cifspdu.h"
+#include "cifs_unicode.h"
+#include "../common/smb2pdu.h"
+#include "../common/smb2status.h"
+
+#define CLEANUP_INTERVAL (30 * HZ)
+#define CLEANUP_IMMEDIATE 0
+
+enum notify_state {
+	NOTIFY_STATE_RECONNECT = BIT(0),
+	NOTIFY_STATE_UMOUNT = BIT(1),
+	NOTIFY_STATE_NOMASK = BIT(2),
+	NOTIFY_STATE_BROKEN_REQ = BIT(3),
+	NOTIFY_STATE_BROKEN_RSP = BIT(4),
+};
+
+struct notify_info {
+	struct inode *inode;
+	const char *path;
+	__le16 *utf16_path;
+	struct cifs_fid cifs_fid;
+	atomic_t state;
+	struct list_head list;
+};
+
+static int request_change_notify(struct notify_info *info);
+static void notify_cleanup_worker(struct work_struct *work);
+
+static LIST_HEAD(notify_list);
+static DEFINE_SPINLOCK(notify_list_lock);
+static DECLARE_DELAYED_WORK(notify_cleanup_work, notify_cleanup_worker);
+
+static bool is_resumeable(struct notify_info *info)
+{
+	return atomic_read(&info->state) == NOTIFY_STATE_RECONNECT;
+}
+
+static bool is_active(struct notify_info *info)
+{
+	return atomic_read(&info->state) == 0;
+}
+
+static void set_state(struct notify_info *info, int state)
+{
+	atomic_or(state, &info->state);
+	if (!is_resumeable(info))
+		mod_delayed_work(cifsiod_wq, &notify_cleanup_work,
+			CLEANUP_IMMEDIATE);
+}
+
+static void clear_state(struct notify_info *info, int state)
+{
+	atomic_and(~state, &info->state);
+}
+
+static int fsnotify_send(__u32 mask,
+			 struct inode *parent,
+			 struct file_notify_information *fni,
+			 u32 cookie)
+{
+	char *name = cifs_strndup_from_utf16(fni->FileName,
+				le32_to_cpu(fni->FileNameLength), true,
+				CIFS_SB(parent->i_sb)->local_nls);
+	struct qstr qstr;
+	int rc = 0;
+
+	if (!name)
+		return -ENOMEM;
+
+	qstr.name = (const unsigned char *)name;
+	qstr.len = strlen(name);
+
+	rc = fsnotify_name(mask, NULL, FSNOTIFY_EVENT_NONE, parent,
+			&qstr, cookie);
+	cifs_dbg(FYI, "fsnotify mask=%u, name=%s, cookie=%u, w/return=%d",
+		mask, name, cookie, rc);
+	kfree(name);
+	return rc;
+}
+
+static bool is_fsnotify_masked(struct inode *inode)
+{
+	if (!inode)
+		return false;
+
+	/* Minimal validation of file explore inotify */
+	return inode->i_fsnotify_mask &
+		(FS_CREATE | FS_DELETE | FS_MOVED_FROM | FS_MOVED_TO);
+}
+
+static void handle_file_notify_information(struct notify_info *info,
+					   char *buf,
+					   unsigned int buf_len)
+{
+	struct file_notify_information *fni;
+	unsigned int next_entry_offset;
+	u32 cookie;
+	bool has_cookie = false;
+
+	do {
+		fni = (struct file_notify_information *)buf;
+		next_entry_offset = le32_to_cpu(fni->NextEntryOffset);
+		if (next_entry_offset > buf_len) {
+			cifs_dbg(FYI, "invalid fni->NextEntryOffset=%u",
+				next_entry_offset);
+			break;
+		}
+
+		switch (le32_to_cpu(fni->Action)) {
+		case FILE_ACTION_ADDED:
+			fsnotify_send(FS_CREATE, info->inode, fni, 0);
+			break;
+		case FILE_ACTION_REMOVED:
+			fsnotify_send(FS_DELETE, info->inode, fni, 0);
+			break;
+		case FILE_ACTION_RENAMED_OLD_NAME:
+			if (!has_cookie)
+				cookie = fsnotify_get_cookie();
+			has_cookie = !has_cookie;
+			fsnotify_send(FS_MOVED_FROM, info->inode, fni, cookie);
+			break;
+		case FILE_ACTION_RENAMED_NEW_NAME:
+			if (!has_cookie)
+				cookie = fsnotify_get_cookie();
+			has_cookie = !has_cookie;
+			fsnotify_send(FS_MOVED_TO, info->inode, fni, cookie);
+			break;
+		default:
+			/* Does not occur, so no need to handle */
+			break;
+		}
+
+		buf += next_entry_offset;
+		buf_len -= next_entry_offset;
+	} while (buf_len > 0 && next_entry_offset > 0);
+}
+
+static void handle_smb2_change_notify_rsp(struct notify_info *info,
+					  struct mid_q_entry *mid)
+{
+	struct smb2_change_notify_rsp *rsp = mid->resp_buf;
+	struct kvec rsp_iov;
+	unsigned int buf_offset, buf_len;
+	int rc;
+
+	switch (rsp->hdr.Status) {
+	case STATUS_SUCCESS:
+		break;
+	case STATUS_NOTIFY_ENUM_DIR:
+		goto proceed;
+	case STATUS_USER_SESSION_DELETED:
+	case STATUS_NETWORK_NAME_DELETED:
+	case STATUS_NETWORK_SESSION_EXPIRED:
+		set_state(info, NOTIFY_STATE_RECONNECT);
+		return;
+	default:
+		set_state(info, NOTIFY_STATE_BROKEN_RSP);
+		return;
+	}
+
+	rsp_iov.iov_base = mid->resp_buf;
+	rsp_iov.iov_len = mid->resp_buf_size;
+	buf_offset = le16_to_cpu(rsp->OutputBufferOffset);
+	buf_len = le32_to_cpu(rsp->OutputBufferLength);
+
+	rc = smb2_validate_iov(buf_offset, buf_len, &rsp_iov,
+				sizeof(struct file_notify_information));
+	if (rc) {
+		cifs_dbg(FYI, "stay tracking, w/smb2_validate_iov=%d", rc);
+		goto proceed;
+	}
+
+	handle_file_notify_information(info,
+		(char *)rsp + buf_offset, buf_len);
+proceed:
+	request_change_notify(info);
+	return;
+}
+
+static void change_notify_callback(struct mid_q_entry *mid)
+{
+	struct notify_info *info = mid->callback_data;
+
+	if (!is_active(info))
+		return;
+
+	if (!is_fsnotify_masked(info->inode)) {
+		set_state(info, NOTIFY_STATE_NOMASK);
+		return;
+	}
+
+	if (!mid->resp_buf) {
+		if (mid->mid_state != MID_RETRY_NEEDED) {
+			cifs_dbg(FYI, "stop tracking, w/mid_state=%d",
+				mid->mid_state);
+			set_state(info, NOTIFY_STATE_BROKEN_RSP);
+			return;
+		}
+
+		set_state(info, NOTIFY_STATE_RECONNECT);
+		return;
+	}
+
+	handle_smb2_change_notify_rsp(info, mid);
+}
+
+static int request_change_notify(struct notify_info *info)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(info->inode->i_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct smb_rqst rqst;
+	struct kvec iov[1];
+	unsigned int xid;
+	int rc;
+
+	if (!tcon) {
+		cifs_dbg(FYI, "missing tcon while request change notify");
+		return -EINVAL;
+	}
+
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	memset(&iov, 0, sizeof(iov));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	xid = get_xid();
+	rc = SMB2_notify_init(xid, &rqst, tcon, tcon->ses->server,
+		info->cifs_fid.persistent_fid, info->cifs_fid.volatile_fid,
+		FILE_NOTIFY_CHANGE_FILE_NAME | FILE_NOTIFY_CHANGE_DIR_NAME,
+		false);
+	free_xid(xid);
+	if (rc) {
+		set_state(info, NOTIFY_STATE_BROKEN_REQ);
+		return rc;
+	}
+
+	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
+		change_notify_callback, NULL, info, 0, NULL);
+	cifs_small_buf_release(rqst.rq_iov[0].iov_base);
+
+	if (rc)
+		set_state(info, NOTIFY_STATE_BROKEN_REQ);
+	return rc;
+}
+
+
+static void free_notify_info(struct notify_info *info)
+{
+	kfree(info->utf16_path);
+	kfree(info->path);
+	kfree(info);
+}
+
+static void cleanup_pending_mid(struct notify_info *info,
+				struct cifs_tcon *tcon)
+{
+	LIST_HEAD(dispose_list);
+	struct TCP_Server_Info *server;
+	struct mid_q_entry *mid, *nmid;
+
+	if (!tcon->ses || !tcon->ses->server)
+		return;
+
+	server = tcon->ses->server;
+
+	spin_lock(&server->mid_queue_lock);
+	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
+		if (mid->callback_data == info) {
+			mid->deleted_from_q = true;
+			list_move(&mid->qhead, &dispose_list);
+		}
+	}
+	spin_unlock(&server->mid_queue_lock);
+
+	list_for_each_entry_safe(mid, nmid, &dispose_list, qhead) {
+		list_del_init(&mid->qhead);
+		release_mid(mid);
+	}
+}
+
+static void close_fid(struct notify_info *info)
+{
+	struct cifs_tcon *tcon;
+
+	unsigned int xid;
+	int rc;
+
+	if (!info->cifs_fid.persistent_fid && !info->cifs_fid.volatile_fid)
+		return;
+
+	tcon = cifs_sb_master_tcon(CIFS_SB(info->inode->i_sb));
+	if (!tcon) {
+		cifs_dbg(FYI, "missing master tcon while close");
+		return;
+	}
+
+	xid = get_xid();
+	rc = SMB2_close(xid, tcon, info->cifs_fid.persistent_fid,
+		info->cifs_fid.volatile_fid);
+	if (rc) {
+		cifs_dbg(FYI, "cleanup pending mid, w/SMB2_close=%d", rc);
+		cleanup_pending_mid(info, tcon);
+	}
+	free_xid(xid);
+}
+
+static int setup_fid(struct notify_info *info)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(info->inode->i_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct cifs_open_parms oparms;
+	__u8 oplock = 0;
+	unsigned int xid;
+	int rc = 0;
+
+	if (!tcon) {
+		cifs_dbg(FYI, "missing master tcon while open");
+		return -EINVAL;
+	}
+
+	xid = get_xid();
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.path = info->path,
+		.desired_access = GENERIC_READ,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &info->cifs_fid,
+		.cifs_sb = cifs_sb,
+		.reconnect = false,
+	};
+	rc = SMB2_open(xid, &oparms, info->utf16_path, &oplock,
+			NULL, NULL, NULL, NULL);
+	free_xid(xid);
+	return rc;
+}
+
+static bool is_already_tracking(struct inode *dir_inode)
+{
+	struct notify_info *entry, *nentry;
+
+	spin_lock(&notify_list_lock);
+	list_for_each_entry_safe(entry, nentry, &notify_list, list) {
+		if (is_active(entry)) {
+			if (entry->inode == dir_inode) {
+				spin_unlock(&notify_list_lock);
+				return true;
+			}
+
+			/* Extra check since we must keep iterating */
+			if (!is_fsnotify_masked(entry->inode))
+				set_state(entry, NOTIFY_STATE_NOMASK);
+		}
+	}
+	spin_unlock(&notify_list_lock);
+
+	return false;
+}
+
+static bool is_tracking_supported(struct cifs_sb_info *cifs_sb)
+{
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
+	if (!tcon->ses || !tcon->ses->server)
+		return false;
+	return tcon->ses->server->dialect >= SMB20_PROT_ID;
+}
+
+int start_track_dir_changes(const char *path,
+			    struct inode *dir_inode,
+			    struct cifs_sb_info *cifs_sb)
+{
+	struct notify_info *info;
+	int rc;
+
+	if (!is_tracking_supported(cifs_sb))
+		return -EINVAL;
+
+	if (!is_fsnotify_masked(dir_inode))
+		return -EINVAL;
+
+	if (is_already_tracking(dir_inode))
+		return 1;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->path = kstrdup(path, GFP_KERNEL);
+	if (!info->path) {
+		free_notify_info(info);
+		return -ENOMEM;
+	}
+	info->utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!info->utf16_path) {
+		free_notify_info(info);
+		return -ENOMEM;
+	}
+	info->inode = dir_inode;
+
+	rc = setup_fid(info);
+	if (rc) {
+		free_notify_info(info);
+		return rc;
+	}
+	rc = request_change_notify(info);
+	if (rc) {
+		close_fid(info);
+		free_notify_info(info);
+		return rc;
+	}
+
+	spin_lock(&notify_list_lock);
+	list_add(&info->list, &notify_list);
+	spin_unlock(&notify_list_lock);
+	return rc;
+}
+
+void stop_track_sb_dir_changes(struct cifs_sb_info *cifs_sb)
+{
+	struct notify_info *entry, *nentry;
+
+	if (!list_empty(&notify_list)) {
+		spin_lock(&notify_list_lock);
+		list_for_each_entry_safe(entry, nentry, &notify_list, list) {
+			if (cifs_sb == CIFS_SB(entry->inode->i_sb)) {
+				set_state(entry, NOTIFY_STATE_UMOUNT);
+				continue;
+			}
+
+			/* Extra check since we must keep iterating */
+			if (!is_fsnotify_masked(entry->inode))
+				set_state(entry, NOTIFY_STATE_NOMASK);
+		}
+		spin_unlock(&notify_list_lock);
+	}
+}
+
+void resume_track_dir_changes(void)
+{
+	LIST_HEAD(resume_list);
+	struct notify_info *entry, *nentry;
+	struct cifs_tcon *tcon;
+
+	if (list_empty(&notify_list))
+		return;
+
+	spin_lock(&notify_list_lock);
+	list_for_each_entry_safe(entry, nentry, &notify_list, list) {
+		if (!is_fsnotify_masked(entry->inode)) {
+			set_state(entry, NOTIFY_STATE_NOMASK);
+			continue;
+		}
+
+		if (is_resumeable(entry)) {
+			tcon = cifs_sb_master_tcon(CIFS_SB(entry->inode->i_sb));
+			spin_lock(&tcon->tc_lock);
+			if (tcon->status == TID_GOOD) {
+				spin_unlock(&tcon->tc_lock);
+				list_move(&entry->list, &resume_list);
+				continue;
+			}
+			spin_unlock(&tcon->tc_lock);
+		}
+	}
+	spin_unlock(&notify_list_lock);
+
+	list_for_each_entry_safe(entry, nentry, &resume_list, list) {
+		if (setup_fid(entry)) {
+			list_del(&entry->list);
+			free_notify_info(entry);
+			continue;
+		}
+
+		if (request_change_notify(entry)) {
+			list_del(&entry->list);
+			close_fid(entry);
+			free_notify_info(entry);
+			continue;
+		}
+
+		clear_state(entry, NOTIFY_STATE_RECONNECT);
+	}
+
+	if (!list_empty(&resume_list)) {
+		spin_lock(&notify_list_lock);
+		list_splice(&resume_list, &notify_list);
+		spin_unlock(&notify_list_lock);
+	}
+}
+
+static void notify_cleanup_worker(struct work_struct *work)
+{
+	LIST_HEAD(cleanup_list);
+	struct notify_info *entry, *nentry;
+
+	if (list_empty(&notify_list))
+		return;
+
+	spin_lock(&notify_list_lock);
+	list_for_each_entry_safe(entry, nentry, &notify_list, list) {
+		if (!is_resumeable(entry) && !is_active(entry))
+			list_move(&entry->list, &cleanup_list);
+	}
+	spin_unlock(&notify_list_lock);
+
+	list_for_each_entry_safe(entry, nentry, &cleanup_list, list) {
+		list_del(&entry->list);
+		close_fid(entry);
+		free_notify_info(entry);
+	}
+	mod_delayed_work(cifsiod_wq, &notify_cleanup_work, CLEANUP_INTERVAL);
+}
diff --git a/fs/smb/client/notify.h b/fs/smb/client/notify.h
new file mode 100644
index 000000000000..088efba4dce9
--- /dev/null
+++ b/fs/smb/client/notify.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Directory change notification tracking for SMB
+ *
+ * Copyright (c) 2025, Sang-Heon Jeon <ekffu200098@gmail.com>
+ */
+
+#ifndef _SMB_NOTIFY_H
+#define _SMB_NOTIFY_H
+
+#include "cifsglob.h"
+
+int start_track_dir_changes(const char *path,
+			    struct inode *dir_inode,
+			    struct cifs_sb_info *cifs_sb);
+void stop_track_sb_dir_changes(struct cifs_sb_info *cifs_sb);
+void resume_track_dir_changes(void);
+
+#endif /* _SMB_NOTIFY_H */
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 4e5460206397..455e5be37116 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -24,6 +24,9 @@
 #include "fs_context.h"
 #include "cached_dir.h"
 #include "reparse.h"
+#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
+#include "notify.h"
+#endif
 
 /*
  * To be safe - for UCS to UTF-8 with strings loaded with the rare long
@@ -1070,6 +1073,9 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	if (rc)
 		goto cache_not_found;
 
+#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
+	start_track_dir_changes(full_path, d_inode(file_dentry(file)), cifs_sb);
+#endif
 	mutex_lock(&cfid->dirents.de_mutex);
 	/*
 	 * If this was reading from the start of the directory
@@ -1151,6 +1157,9 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		cifs_dbg(FYI, "Could not find entry\n");
 		goto rddir2_exit;
 	}
+#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
+	start_track_dir_changes(full_path, d_inode(file_dentry(file)), cifs_sb);
+#endif
 	cifs_dbg(FYI, "loop through %d times filling dir for net buf %p\n",
 		 num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
 	max_len = tcon->ses->server->ops->calc_smb_size(
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4e922cb32110..58a1ddc39ee6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -45,6 +45,9 @@
 #include "cached_dir.h"
 #include "compress.h"
 #include "fs_context.h"
+#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
+#include "notify.h"
+#endif
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -466,6 +469,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 
 	atomic_inc(&tconInfoReconnectCount);
+#ifdef CONFIG_CIFS_DIR_CHANGE_TRACKING
+	resume_track_dir_changes();
+#endif
 out:
 	/*
 	 * Check if handle based operation so we know whether we can continue
-- 
2.43.0

