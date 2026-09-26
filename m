Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039973A7F46
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413635; cv=none; b=vBHeF8uOMNDuKRzgVKS7CjViV3FIxUev4TxTibueCkEyAfIP+GHvtYN+79OVDLs1BKolCmvmQKslsHV/jE2sKkq+5VYoeeSb4TqPZRiAZjARtnV89Pc79EWvOrAeeJrZHYR9UypPXJAOTFFLTcpFpvMzAL/8fTsBOjsrjM1g+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413635; c=relaxed/simple;
	bh=9l3ZP+MbEFsKUSqQvwOr7MyDoJ+KbFNUHRt8nT+lgMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbkgCOte5rdx8hYBGXiZgYnGiDLQ+mGKo31XEk9PcYJ+2mnalRFwRL9emSbBkOK5DKrbaP8csrLzoRWVOYRvD9SFGWgJ0b95s+yWuiosRjJiLlzn/SU+BVZUoUSGlqz8W3UZXFulrMevT/Nm/VD8TYomPEf5ML7D8ci0+/6DCig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=rIm/WpWS; arc=none smtp.client-ip=95.215.58.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="rIm/WpWS"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9l3ZP+MbEFsKUSqQvwOr7MyDoJ+KbFNUHRt8nT+lgMk=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413630; v=1; x=1791018430;
 b=rIm/WpWSeIuaU22OmtRwNOHsTjMyGvD+8w4SMo9NZnHDS2qi+x0tVJG592rFSE2NmhwvEmrg
 n8M2wOPKam5MDMYRoPRwwBnayF2pyhVFeY8aOV6EuCk8hsIbVG6lEIdebYv8APmckDvHOlQ+EIy
 5IEMAgsZtGAhaAb7Ooakn9TH2/pMF6DumdK8SbeynxaRIF2C0a02KRNRm4x8zvr9mVfUec6Tct0
 tnS6pelQ2EYlVdwxd0h6od53bhUhMOyudMrG9YXc6DGvaOwRkkkcKYsMPPT8E2kdZyvcRxKrthV
 cOI1SWqFpkqDAJUPYGOc0HQKPbs6qWt31HU7hMxmmGzpg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6b21a8bb8b4a0ce8;
	Sat, 26 Sep 2026 09:07:10 +0000
X-Mizu-Trace-ID: 6b21a8bb8b4a0ce8
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 10/12] smb/server: encode notify events
Date: Sat, 26 Sep 2026 09:05:16 +0000
Message-ID: <20260926090518.78547-11-chenxiaosong@chenxiaosong.com>
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

Sort and merge events, then encode their names as UTF-16 records.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 106 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 6b5312b46e39..da30cc058d78 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -12,6 +12,7 @@
 
 #include <linux/fsnotify_backend.h>
 #include <linux/dcache.h>
+#include <linux/list_sort.h>
 #include "glob.h"
 #include "../common/smb2status.h"
 #include "connection.h"
@@ -650,6 +651,111 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 	kfree(notify);
 }
 
+static int ksmbd_notify_event_cmp(void *priv, const struct list_head *a,
+				  const struct list_head *b)
+{
+	struct ksmbd_notify_event *event_a;
+	struct ksmbd_notify_event *event_b;
+
+	event_a = list_entry(a, struct ksmbd_notify_event, list);
+	event_b = list_entry(b, struct ksmbd_notify_event, list);
+
+	if (event_a->when < event_b->when)
+		return -1;
+	if (event_a->when > event_b->when)
+		return 1;
+	return 0;
+}
+
+static void *ksmbd_notify_encode_events(struct ksmbd_work *work,
+					struct list_head *events,
+					u32 max_len, size_t *data_len)
+{
+	struct ksmbd_notify_event *event;
+	u8 *data = NULL;
+	size_t len = 0;
+
+	list_sort(NULL, events, ksmbd_notify_event_cmp);
+
+	list_for_each_entry(event, events, list) {
+		struct file_notify_information *info;
+		struct ksmbd_notify_event *next;
+		size_t alloc_len, buf_len, name_buf_len, record_len;
+		bool last = list_is_last(&event->list, events);
+		__le16 *name;
+		u8 *new_data;
+		int name_len;
+
+		/* Coalesce adjacent, case-sensitive duplicate records. */
+		if (!last) {
+			next = list_next_entry(event, list);
+			if (event->action == next->action &&
+			    event->name_len == next->name_len &&
+			    !memcmp(event->name, next->name, event->name_len))
+				continue;
+		}
+
+		name_buf_len = (event->name_len + 1) * sizeof(__le16);
+		name = kmalloc(name_buf_len, KSMBD_DEFAULT_GFP);
+		if (!name) {
+			pr_err("Failed to allocate notify event name buffer\n");
+			goto fail;
+		}
+
+		name_len = smbConvertToUTF16(name, event->name,
+					     event->name_len,
+					     work->conn->local_nls, 0);
+		name_len *= sizeof(__le16);
+		record_len = sizeof(*info) + name_len;
+		alloc_len = ALIGN(record_len, 4);
+		if (alloc_len > SIZE_MAX - 7 ||
+		    len > SIZE_MAX - alloc_len - 7) {
+			pr_err("Notify event data length overflow\n");
+			kfree(name);
+			goto fail;
+		}
+
+		/*
+		 * Compound response finalization can extend the last iov to an
+		 * 8-byte boundary.  Keep that padding inside this allocation and
+		 * zeroed, while reporting only the protocol payload in data_len.
+		 */
+		buf_len = ALIGN(len + alloc_len, 8);
+		new_data = kvrealloc(data, buf_len, KSMBD_DEFAULT_GFP);
+		if (!new_data) {
+			pr_err("Failed to allocate notify event data, length %zu\n",
+			       buf_len);
+			kfree(name);
+			goto fail;
+		}
+		data = new_data;
+		memset(data + len, 0, buf_len - len);
+
+		info = (struct file_notify_information *)(data + len);
+		info->NextEntryOffset = last ? 0 : cpu_to_le32(alloc_len);
+		info->Action = cpu_to_le32(event->action);
+		info->FileNameLength = cpu_to_le32(name_len);
+		memcpy(info->FileName, name, name_len);
+		kfree(name);
+
+		len += alloc_len;
+		if (len > max_len) {
+			ksmbd_debug(NOTIFY,
+				    "Notify event data length %zu exceeds output buffer %u\n",
+				    len, max_len);
+			goto fail;
+		}
+	}
+
+	*data_len = len;
+	return data;
+
+fail:
+	kvfree(data);
+	*data_len = 0;
+	return NULL;
+}
+
 static struct ksmbd_file *
 ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_req *req,
-- 
2.55.0

