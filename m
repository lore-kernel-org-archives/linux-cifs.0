Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917376;
	b=z2ZUF3smLVRUAnUh7cyJCnKvOiz5ZbTlx9/6CA6OhJcYJrNqcM6W7Px0w4bHqkww6Mcc
	 wmsG7WKYcRS5NdD5Lj2g+6OC/26rx4lJ6Z2sv4MpS8UT1kuCSti2h7Z0PbrCfvmqI02wH
	 rfQ4XwGflSojjFL40jbTTSe3//BTOfhl2E/W+h8SnoJTb9+PZ0MW5tP5+ifYGZRZxskBM
	 FbUX+Obx9T4HpEKdJkG6KldB2iyyHiitqWg3mcx0tS7StH5555RAXGgxEJ8iDxsd3KNuN
	 V88yVdLxChotDyXWZk2zDL7hP2AkxWblTw+2A94sBJcaoQN2KmMCnZlxK+HRcMOQtNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917376;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7t9DrpiwX8uFni7j9Mo+MgNZfsERkLjeVPfcy3hdb/g=;
	b=hPCAodszyLafeVA/yLc09itf6BT30UC+LAfmxmW7TKiGEcvApNvNtrei5XcdJLjeWNoK
	 4IJuSF1Vu7O+082pejI2e4eDRlHacQfDKZgQ/1Mq2jSo1ilNn6SMiGBRAjJpMoEdpm7pS
	 etxxZVGAjXUaebMexqaxiqQ/H2uCzAaHVORkZlHlF3ewZ3h42tfI2oSC8BNANSbgfISCo
	 K5a3JzJ0r5uMv/tBz3d5XrGdX+tDktEkFcK7ISjvsNQ/yFNfl7Z9B4Urc/sZOU7+Pz0LX
	 lwzUoPfdNFMoeyFhPijkK9e/Wh3qsr9oMu3NiTvnf44qupQKqBQ2EMgelca7th40VhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=k8KhjZMp;
	arc=none smtp.remote-ip=95.215.58.170
Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B747606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:36:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B747606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=k8KhjZMp
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3r7q8++3ekbLSpSdCuHlB3cW1LTgz/xSxvv1zj2af4w=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917373; v=1; x=1793522173;
 b=k8KhjZMpC1SBEb5UVU3qMNPWiH4zGBK0/rhW5yvDnUdg6APjg45vtqEXzpSKh1NkeDVjULTV
 iGxOdd6QHKQQxeo2sZ647d2FV8t9cC8T2w12FP+aWITtkm0sd0J3spoeFVYNPZvicbHbAIhU4x1
 O/llbs9IF23EztCWL271Z87Ulw3kX3K43buMdY6yxSMvisLMREFnM/QpJ+zn3J2nKKy7zkGgb/2
 YcG9ooX64Q808uad8JDP/NlcTDuiLYvvbPGgqg7006CDDqSXj8nUXMSJuQKw/CDSgCKJxL+NFVw
 9/pJS+133x/brERmiCenX/FGLdX0NIK7eHXUdiOT06kzw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8f8f6fd046939bcc;
	Sun, 25 Oct 2026 08:36:13 +0000
X-Mizu-Trace-ID: 8f8f6fd046939bcc
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 09/13] smb/server: match rename notify events
Date: Sun, 25 Oct 2026 08:34:46 +0000
Message-ID: <20261025083450.212604-10-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
References: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Match old and new rename names by cookie. Save both names as events.

Example:

  1. client: smbinfo notify /mnt
  2. server: ksmbd.control --debug=notify
  3. server: touch /export/file1
  4. server: mv /export/file1 /export/file2
     server debug log:
       ksmbd: fid 5:5, notify event: mask=0x00000040 inode=2 name=file1 cookie=974
       ksmbd: Saved moved from, mask 0x40, name file1, cookie 974
       ksmbd: fid 5:5, notify event: mask=0x00000080 inode=2 name=file2 cookie=974
       ksmbd: Matched rename file1 to file2, cookie 974

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 98 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 88 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 77cb58ba950f..e4996730c679 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -203,23 +203,40 @@ ksmbd_notify_alloc_event(struct ksmbd_notify *notify, u32 action,
 }
 
 static void
-ksmbd_notify_queue_event(struct ksmbd_notify *notify,
-			 struct ksmbd_notify_event *event)
+ksmbd_notify_queue_events(struct ksmbd_notify *notify,
+			  struct ksmbd_notify_event *event,
+			  struct ksmbd_notify_event *next)
 {
-	ksmbd_debug(NOTIFY, "Queueing notify event, action %u, name %s\n",
-		    event->action, event->name);
+	if (!event && !next)
+		return;
 
 	spin_lock(&notify->lock);
 	if (notify->overflow) {
 		spin_unlock(&notify->lock);
 		ksmbd_notify_free_event(notify, event);
+		ksmbd_notify_free_event(notify, next);
 		return;
 	}
-	list_add_tail(&event->list, &notify->events);
-	notify->num_events++;
+	if (event) {
+		list_add_tail(&event->list, &notify->events);
+		notify->num_events++;
+	}
+	if (next) {
+		list_add_tail(&next->list, &notify->events);
+		notify->num_events++;
+	}
 	spin_unlock(&notify->lock);
 }
 
+static void
+ksmbd_notify_queue_event(struct ksmbd_notify *notify,
+			 struct ksmbd_notify_event *event)
+{
+	ksmbd_debug(NOTIFY, "Queueing notify event, action %u, name %s\n",
+		    event->action, event->name);
+	ksmbd_notify_queue_events(notify, event, NULL);
+}
+
 static void
 ksmbd_notify_trigger_removed(struct ksmbd_notify *notify,
 			     struct ksmbd_notify_event *event)
@@ -284,6 +301,65 @@ static void ksmbd_notify_save_moved_from(struct ksmbd_notify *notify,
 			 msecs_to_jiffies(KSMBD_NOTIFY_MOVED_FROM_MSECS));
 }
 
+static bool
+ksmbd_notify_handle_rename(struct ksmbd_notify *notify, u32 mask,
+				 u32 cookie, const struct qstr *file_name)
+{
+	struct ksmbd_notify_event *from, *to;
+	u32 from_mask;
+
+	to = ksmbd_notify_alloc_event(notify, FILE_ACTION_RENAMED_NEW_NAME, file_name,
+				      KSMBD_DEFAULT_GFP);
+	if (!to)
+		return true;
+
+	spin_lock(&notify->lock);
+	if (!notify->moved_from_event ||
+	    notify->moved_from_cookie != cookie) {
+		spin_unlock(&notify->lock);
+		ksmbd_notify_free_event(notify, to);
+		ksmbd_debug(NOTIFY,
+			    "No rename source for destination %.*s, cookie %u\n",
+			    file_name ? file_name->len : 0,
+			    file_name ? (const char *)file_name->name : "",
+			    cookie);
+		return false;
+	}
+	from = notify->moved_from_event;
+	from_mask = notify->moved_from_mask;
+	notify->moved_from_event = NULL;
+	notify->moved_from_mask = 0;
+	notify->moved_from_cookie = 0;
+	cancel_delayed_work(&notify->moved_from_work);
+	spin_unlock(&notify->lock);
+
+	from->action = FILE_ACTION_RENAMED_OLD_NAME;
+	ksmbd_debug(NOTIFY, "Matched rename %.*s to %.*s, cookie %u\n",
+		    (int)from->name_len, from->name,
+		    file_name ? file_name->len : 0,
+		    file_name ? (const char *)file_name->name : "", cookie);
+
+	if (!ksmbd_notify_filter_match(notify, from_mask)) {
+		ksmbd_debug(NOTIFY, "Filtered rename source %.*s\n",
+			    (int)from->name_len, from->name);
+		ksmbd_notify_free_event(notify, from);
+		from = NULL;
+	}
+
+	if (!ksmbd_notify_filter_match(notify, mask)) {
+		ksmbd_debug(NOTIFY, "Filtered rename destination %.*s\n",
+			    file_name ? file_name->len : 0,
+			    file_name ? (const char *)file_name->name : "");
+		ksmbd_notify_free_event(notify, to);
+		to = NULL;
+	}
+
+	/* A waiter must not take only the first half of a rename pair. */
+	ksmbd_notify_queue_events(notify, from, to);
+
+	return true;
+}
+
 static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -318,10 +394,12 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 		return 0;
 	}
 
-	if (mask & FS_MOVED_TO)
-		return 0;
-
-	if (mask & FS_CREATE) {
+	if (mask & FS_MOVED_TO) {
+		if (ksmbd_notify_handle_rename(notify, mask, cookie,
+					       file_name))
+			return 0;
+		action = FILE_ACTION_ADDED;
+	} else if (mask & FS_CREATE) {
 		action = FILE_ACTION_ADDED;
 	} else if (mask & FS_DELETE) {
 		action = FILE_ACTION_REMOVED;
-- 
2.55.0

