Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6453A961A
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413629; cv=none; b=V0OQsRVcGE2at5fb2yFKlZdjw1rgELFen29m+irp8TM03Tu9/rwydSTOFM8QYNRKHdo7JN14m6OIKs79o0fNWiGygrCQFWJV3K4SOVoTLGskBpopL/egeG7wWhyNkv4ND+u26bVcMdrV4dggpPzqTc5byxPxUiFE/LX7nKtjleQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413629; c=relaxed/simple;
	bh=tIO/GIU9ggOggBNu7ac0VH4dkvzDCP2eSoBLeA/QmuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X04hqYAb77QkTADSw921wjv7GSf1ziOp7wgOCdtqDiP/JcCeELDQLvFCpZ6nQa/GFrlPTDclE6s3FybAq0MqU/F2fdshL5vVMM/Ftt6olDmXmzqNHDqkMyAtb8hsgE5eLPK8eEB54H74pKtp4tvRTet9YgSDJ3ZgMu7C6HKozdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Fga3GnZu; arc=none smtp.client-ip=91.218.175.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Fga3GnZu"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tIO/GIU9ggOggBNu7ac0VH4dkvzDCP2eSoBLeA/QmuA=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413623; v=1; x=1791018423;
 b=Fga3GnZumi5slU3vcf4DHHkcuU0cdXKGWos1x/0YFganVH//1T1MXSdQ+66uL3MUMlrvHsQ2
 iLGm4C0+II1Q0o3igvPTpJ9vLDKRkLeoM/nxnCZyNTSe3IQEGVjbpOSfj2SoH+VkshJv+opfXLx
 3dcPw83MvlHT6XT4U/E3CP9atbxudQg8brvMfuKfwGmQ/dT9SMyFP2CO3XsqJLNBQi0ZfQw2YsZ
 woBDtMmPVjR2Ih70xLd/oU6tlZKGYCqb1mn07xLrKAVROan3Uv+0jMFtFKU3NBAuONmvjGleQap
 NHU6Lp7LqI4l7JwIweVsQhBUjyv0hYCnAN3asMkz2ygkg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 15f9978a2af7a4b1;
	Sat, 26 Sep 2026 09:07:03 +0000
X-Mizu-Trace-ID: 15f9978a2af7a4b1
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 09/12] smb/server: match rename notify events
Date: Sat, 26 Sep 2026 09:05:15 +0000
Message-ID: <20260926090518.78547-10-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
References: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
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
       ksmbd: Queueing notify event, action 4, name file1
       ksmbd: Queueing notify event, action 5, name file2

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 71 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index ab1867033f26..6b5312b46e39 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -236,6 +236,67 @@ static void ksmbd_notify_save_moved_from(struct ksmbd_notify *notify,
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
 static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -266,10 +327,12 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
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

