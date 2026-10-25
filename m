Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917382;
	b=X5X5PR0J1c+vxQzfpGfpY2TtLPCojrRZwiowjvB2IGnbj0dAgs7NttAqNWk7LOul1eEr
	 awoFgr9n0CvP3/gVHpjyyZ/U8NcBlSf4K+lgvZ6cIP+XU0MRZtKzOtnbKZC754BDv51JH
	 llnPSxQ4ediY0T6MaF5WH6XVR8yFJTSgdUDUsiALgLyO0Zu+gnViJFTqA6Nfl5WVhtu1f
	 /9gvIU6E9ylh7OPfjqohukXKXN/J28g4OtWbD/eyPpVXG+vVwpOwdTP3DYsU7pmrrk22X
	 44pFZqLZUCCr1LF0/5/UwTxKT0SdNhOWctkkHGQfjAAp11XbKAPoSQS1J9PhJ6aExCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917382;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=82LY8MBzoZKjgTJZIacJUGtR+VFSm2BpFohTXbKyA2M=;
	b=b1Ih90QPgxk5g4uwi2Vp2NmBO/3dnLK7JsD3K4q0H029+NgUPCgGimTFr9SmwRoNH1X8
	 zyR0sWMMKpw7TARJd7Jfe9J0Z/m8vsJPLWa2TyOnYDQSqeF4WE8fRru6YXAXz7UKNG5DA
	 e34K0B95m91gPd+Idq/ZylRQheOX76m12wKfMoiLNcaXdNhdDbapVj1daGQizsYug2SkB
	 8FH03FrQ1WjJJAXeT9eP4RkkO8xy/g63Sy3rYIXb4sxTB0eNEUz6Ntl4FfwlaY/5UxB2D
	 8NbwdmKrEVtBwp9fNXZecMuhj+cqePRxLh1Q+MCTaZWZc+Yr5SssgJhlKv0Vp1ykq7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b="FT1oXx/d";
	arc=none smtp.remote-ip=91.218.175.70
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D7B606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07D7B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=FT1oXx/d
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EsXPELo6+R1ifwBsFI9kpVlRRCil1CZyB/DOh/04xC0=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917380; v=1; x=1793522180;
 b=FT1oXx/dgwkDSkPZlb6MPBBdH4B/lAgetdwwCF8wnC6SLSTFYaDOqs36WLZkvw8SQwO6j2qr
 z0IWwZUpt6M00I57EUKshxtEW+qr/wyaTHr5wCTUh7Uxgia/fT52g0EgSRmes+GJpulqBAlUPQL
 eF4SFKjOAsub27RaAgFBpPauM8NTYsm02x3f6V5OkETKO04/bPQNSxTVTIR9weGBU/WhgPr4kve
 DfvKEGjGaP1UyBZG5ZjObu6wlM822SKpRE8aWGE09AP9aJT0z25PEK/YVlNnM94z9YuCHTTAwPo
 BqQsGoF5cRnITvEC3mplmltJKssoAYIii8HvgTne5IVHQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 78aaf0021faad61b;
	Sun, 25 Oct 2026 08:36:19 +0000
X-Mizu-Trace-ID: 78aaf0021faad61b
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 10/13] smb/server: encode notify events
Date: Sun, 25 Oct 2026 08:34:47 +0000
Message-ID: <20261025083450.212604-11-chenxiaosong@chenxiaosong.com>
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

Sort and merge events, then encode their names as UTF-16 records.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 106 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index e4996730c679..e93ce85cc3a4 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -12,6 +12,7 @@
 
 #include <linux/fsnotify_backend.h>
 #include <linux/dcache.h>
+#include <linux/list_sort.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include "glob.h"
@@ -728,6 +729,111 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
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

