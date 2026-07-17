Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191B143F0BA
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 07:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273869; cv=none; b=TrZC6eGb7bwIO6pIeH5NxPxuIsPH3pyKNSiff7k8nFeOur5HVi4fwagBkO3VfaWXLyXGJOJhwI7Le/MMipM98hm0Y9BrAwOpLxsBoXHsIbb7iMAPbD7byUoHRRFGBT1hvU+n1tQYAcRzhiEhnpMPC2A13Bq1IM0zEo/yxSXZruQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273869; c=relaxed/simple;
	bh=flT1Aq7D8HhRSODl16o8+oT9VxC0mrYCIXll+BHJCts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hallgaTvNB6H1kU8cTdQqEipQwKQNsloyKn9GLeZXzL03XT9u+yHjxZZ/vjuf/SQc0Dq9YKZG2++1Bc3H0YWTNsZTwvULmhHDNqVmq7rmTDtpH+yewIfXMKhWaQqG7pl066iG7j4ap3bRZjLEfqkUqyA3YOgrES4Z6krMD+GnSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V3qmQb9y; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3qmQb9y"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493c733f15aso65020955e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 00:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784273863; x=1784878663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=as4aS6dkGeOvyj1LIgUE8fsdtYdplVP3IyYkJ7CdMCM=;
        b=V3qmQb9yzx2GhjV9qOeI6cx8l/V4BKTxoCWkysXp+waWeqLFdi5MTHHzMTDSiFAK46
         D8eYx19vuiuudPh4/Kgch52ihhi70PUjtKVOIgJmCWlkzORnVRmRUlqCk8/sn2v3fSGL
         cp4oY6+2YD4EQmEGMSD1PrRkxsWc984ncc84HvIaZaiLecNg/7scBxwpguw6G3fneU7E
         NFgfmH/5vdgbR8fuAyqPHKiT/4lvJOBfbTgtXZFddqAD+ioQ2ogggtBGB3MNrLwYt6XP
         HNAtd6P6XUY4k7q2fhrmUhzPZYct5Y15ZBjGryXL1EABrEvx68AHTUFZFChsMbCA7GWq
         oDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784273863; x=1784878663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=as4aS6dkGeOvyj1LIgUE8fsdtYdplVP3IyYkJ7CdMCM=;
        b=OCrUR/0HFhOngs7Nl9jV+u5aOiDSkrCU2HxAvDhrV2gUJQSTWHJv9RjX9LcHr3MvT/
         SAeJyuy/2hkKitKdcoRROur+KEQPHLhrH9qlkACR44TfCtDbu6EfBb6XPKK58gQj3pgI
         e32Q8TZTAyH70Xc+jUFQuwSscutNsdEeHGHWr3FqTLBiMQHzt0HiQKcBVQAazGos40uo
         SeOSqKEyjDCKTa07b5w/U9LbfecHwX/naX5YgSTFs4qaSVyPHGwYs9wyKVLXbaVNSI3a
         uWDfUL5VdFkfmaUVNwcnkCGAPVE1YCZ+3/LAyyM0eAm2bGc+XUkjDiJf7+SkbSZUgpac
         uRDw==
X-Forwarded-Encrypted: i=1; AHgh+Rr9qzgzDQL+2vL+XFplGiFkCM66sCYU5gtJ+0dDFzVEHHT712uQVU5BtU0FnE3Jb4N4SCgmCdAADXhn@vger.kernel.org
X-Gm-Message-State: AOJu0YwWTgXSdrWhnEgiXOimbCq6foSKZGjvkhsyIj+uXH+jVH8GODZO
	zSpaJYJlj/XIhWhX1gQ5E09zq0srQ5OvNcy9hsTAVQFzGG4e7VQGEAiQ
X-Gm-Gg: AfdE7cntZt8HuCnAI/5JZlrbthTlGB0ZEkNX7QMYcTeRykKlrCM1nkhxHMCqsJB/gUg
	RMjDTNRNSYRzp8fQ8yZls2UnKh/m4678WH+bf/GxmBBLQ5/D7lJ5irEVywdp5PPXV0NYvLdBuP5
	Dk83Tajjgs8/D7AgRsk/2Fzm+4CO/BnFcTPcfpsNNU3DdDWJsaouFHf+vYd53NleZVrQDKJoyiu
	eVlL9eNWXt8S5boVIPi2cpDk4+dofUeifd7Ep/IT+ESrUl41Rj/abo/qgE8BZx2nVh6yYz+Q36l
	pLb4Nm6fsSas8xlf05kjZwIi45NAyGWmdidCqCsx8Kic8/FuUvNeEJ1UuuET3UHtig2NLjEFdUZ
	Wa/OfXxq7ssCz1Z35shzS6xxc1Uvrv+4nzDCYaze+lwL3WsNuiuBAlBMeHWFAGUkeC4B5gwBCfX
	9SQjx50aWEUdwpeezKQUQdIbKkfbrBiwGb
X-Received: by 2002:a05:600c:154e:b0:495:405c:38d3 with SMTP id 5b1f17b1804b1-4954a3df9f9mr18155315e9.9.1784273862684;
        Fri, 17 Jul 2026 00:37:42 -0700 (PDT)
Received: from localhost.localdomain ([82.67.171.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2e83ddsm24530655e9.10.2026.07.17.00.37.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Jul 2026 00:37:42 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: linkinjeon@kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: fix AsyncId zeroed before use in smb2_lock() cancel response
Date: Fri, 17 Jul 2026 09:37:20 +0200
Message-ID: <20260717073721.7487-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

release_async_work() zeroes work->async_id before the CANCELLED path
calls smb2_send_interim_resp(work, STATUS_CANCELLED), which reads
work->async_id to build the response's AsyncId field. The cancellation
response for a cancelled blocked-lock request is sent with AsyncId=0
instead of the id the client received in the original STATUS_PENDING
response for this request.

Checked against every other release_async_work() call site in this
file: smb2_read()/smb2_write() don't send a further async response
afterward (their status goes out on the synchronous path instead), and
smb2_notify()'s two async paths already transfer the id to a separate
struct before releasing, so this reordering is scoped to smb2_lock()
only.

Send the STATUS_CANCELLED response while work->async_id is still valid,
then release the async work afterward.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
---
 fs/smb/server/smb2pdu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 602b60417..d55f8a328 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9307,22 +9307,25 @@ int smb2_lock(struct ksmbd_work *work)
 				spin_unlock(&fp->f_lock);
 
 				list_del(&smb_lock->llist);
-				release_async_work(work);
-
-				if (work->state == KSMBD_WORK_ACTIVE)
-					goto retry;
-
-				locks_free_lock(flock);
 
 				if (work->state == KSMBD_WORK_CANCELLED) {
 					rsp->hdr.Status = STATUS_CANCELLED;
 					kfree(smb_lock);
 					smb2_send_interim_resp(work,
 							STATUS_CANCELLED);
+					release_async_work(work);
+					locks_free_lock(flock);
 					work->send_no_response = 1;
 					goto out;
 				}
 
+				release_async_work(work);
+
+				if (work->state == KSMBD_WORK_ACTIVE)
+					goto retry;
+
+				locks_free_lock(flock);
+
 				rsp->hdr.Status =
 					STATUS_RANGE_NOT_LOCKED;
 				kfree(smb_lock);

base-commit: b0532660f76e08c75143d9d030a9e8c4f2e2bb1e
-- 
2.43.0

