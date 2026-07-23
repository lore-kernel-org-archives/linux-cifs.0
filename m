Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D054353A68
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776706; cv=none; b=Qg1mZyke9QPv+ycJ/8JHdOJ2Tb+Ie+dJLvhv+zWev4nuQUujKgQjX5QpCcE+MFyuPF+D0GVDFvWDzUc2FPskj24Uu7x1v3f5Dr9Za+AnIrjU96kDjjtQT+aIs9DJtZTB0ZG2MbtvN+SO8OyWvumWl5/ifmuCxp8NPjuH16i4nQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776706; c=relaxed/simple;
	bh=ke5i3zK3DUo8DmxoZxv4NXNXJhCIvgL1ij9jTW4suEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAbbUSt6cho6Ql88H3v3urbVDg1D0UyT5Hliqyvk6oaJsEhQKXKn9aEdhiY9FEiQ+j+9xfMQQgrsGpfjpVmL/kkAvfsn4f+tEDqsefnarAEa/spcPegpd+f+4Q8efNmEI+AHkQK2Aw2dZUkBd/FbSBBZ6NRlSLLCbOz7oodvaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=IqWCkaBi; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="IqWCkaBi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OqyYnRMKdr3chW5jNwE5pq8lEt9HVD/yGOXmDq3EcZg=;
	b=IqWCkaBiYtgkDAb/9OBBcKTe2qPny287gS0iFx+gtYk4s3YDYvcUl/Z+5fqLGs1AekDrZk
	ZjrDFkKgq0qfJrGYgK84jmbgpo1Ng8YKkAx9TkuK6cb6wcnLwXrSVLau43OiK3NOJltfpU
	7GxEtr3cYLYUsgmyiiMHuq+uAwFS3zO1TkxzAFISflDRkL2FtMvlVKVVpaW/n79cVhAydo
	U5XZ/VSNZ9ykBG5a3cf+rPNvEkQ/PxG92/7GVrUmkyrpIKcn6Ofkuzf+BYFzZYvIzF0LMX
	fJAeQO7qeOHfMJuTpR7EbjGz/kao24DGTZk38lw0np0ZqGby2gzXHEJkVIUQFw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 08/11] smb/server: match rename notify events
Date: Thu, 23 Jul 2026 03:16:36 +0000
Message-ID: <20260723031644.312866-9-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

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
       ksmbd: Queueing notify event, action 4, name file1
       ksmbd: Queueing notify event, action 5, name file2

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 71 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 80c1eb089b60..ac253e7326c2 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -230,6 +230,67 @@ static void ksmbd_notify_save_moved_from(struct ksmbd_notify *notify,
 			 msecs_to_jiffies(KSMBD_NOTIFY_MOVED_FROM_MSECS));
 }
 
+static bool
+ksmbd_notify_handle_rename(struct ksmbd_notify *notify, u32 mask,
+				 u32 cookie, const struct qstr *file_name)
+{
+	struct ksmbd_notify_event *from, *to;
+	u32 from_mask;
+
+	to = ksmbd_notify_alloc_event(FILE_ACTION_RENAMED_NEW_NAME, file_name,
+				      KSMBD_DEFAULT_GFP);
+	if (!to)
+		return false;
+
+	spin_lock(&notify->lock);
+	if (!notify->moved_from_event ||
+	    notify->moved_from_cookie != cookie) {
+		spin_unlock(&notify->lock);
+		kfree(to);
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
+		kfree(from);
+		from = NULL;
+	}
+
+	if (!ksmbd_notify_filter_match(notify, mask)) {
+		ksmbd_debug(NOTIFY, "Filtered rename destination %.*s\n",
+			    file_name ? file_name->len : 0,
+			    file_name ? (const char *)file_name->name : "");
+		kfree(to);
+		to = NULL;
+	}
+
+	if (from)
+		ksmbd_notify_queue_event(notify, from);
+	if (to)
+		ksmbd_notify_queue_event(notify, to);
+
+	return true;
+}
+
 static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -264,10 +325,12 @@ static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
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
2.54.0

