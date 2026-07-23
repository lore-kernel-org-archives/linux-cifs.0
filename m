Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB55E21773D
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776712; cv=none; b=d5TDPIvZhJnr6el61+CWywCiGu4FczfVn58Qq2CvNRbDio/BPqQjsd4GcQoZGw8hxQEZ2lqZ6OkLDT7GM1sQ02EoaLzxLAyanpjSBjYaxyxb4C/cS56KzunMeAT5OEZtNTowhgezD7UAk1mCiXbyFMWRq9r6vCk3OwuX9AsSd48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776712; c=relaxed/simple;
	bh=Mi+m4+U1RBKqkoR2+LD3WjRuTzDs5CL1TX2Kxg55QjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iERXb5dZCe4ix10C/bHMDGGAWqgW/S3gSGpvR2LWI6cGz92N8ccVJ/bTdry8zKbVpNnPY2MycsjdfqnqrQmef9bBwWeMhiNdyrXZ6wQp97kDVpUw0ewBpPRWj5xs92yneLnfsVmg9VDiYzZCqg8H8GpPGvD0GFgjrl04hYgLofo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=B8WW2NZv; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="B8WW2NZv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GtQ2II4cfbwArMrCFa6TbBH7eq8a7EmSLBB2mSF4S7E=;
	b=B8WW2NZvypzoVbf96M7s4+YLehf9tDih0QElpmaNpPe7RET9fVkjS89jTYzPwONMrCxBXD
	bpRW4HURAbI9gHzYVhNRAEeQ8HcIG4nV9yg3nP2qaOWGiTJH1+Cs6nAK2wknAxCIjO5Gb0
	oKy8xusdH7JDz33/nIk419tISp4JVfhFEMbjYNPz9vMI9aB48GyumYkNaUS8Rj8M7u/PU0
	DujVQNufm0+RHctoaxGwBvOZPRMDYWK6tNMg70iPPN//tqSAwn70om/Lk1HOpyaDE9MLGT
	OpvB3LIbyIBtKOcCwfP9b7OCSTI/4VhTpixnI0KQR0R+Djt4DBvjL1Fs1ZccsA==
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
Subject: [RFC PATCH 09/11] smb/server: encode notify events
Date: Thu, 23 Jul 2026 03:16:37 +0000
Message-ID: <20260723031644.312866-10-chenxiaosong@chenxiaosong.com>
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

Sort and merge events, then encode their names as UTF-16 records.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 99 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index ac253e7326c2..6fff7b5584b9 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -11,6 +11,7 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/jiffies.h>
 #include <linux/ktime.h>
+#include <linux/list_sort.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
@@ -504,6 +505,104 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
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
+		size_t alloc_len, name_buf_len, record_len;
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
+		if (len > SIZE_MAX - alloc_len) {
+			pr_err("Notify event data length overflow\n");
+			kfree(name);
+			goto fail;
+		}
+
+		new_data = kvrealloc(data, len + alloc_len, KSMBD_DEFAULT_GFP);
+		if (!new_data) {
+			pr_err("Failed to allocate notify event data, length %zu\n",
+			       len + alloc_len);
+			kfree(name);
+			goto fail;
+		}
+		data = new_data;
+		memset(data + len, 0, alloc_len);
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
2.54.0

