Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792084A1E;
	Tue,  7 Oct 2025 04:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759810410; cv=none; b=Zgh6G8kNTrHMxOdKncxNOvolhlgN0JqU+wHAEFmVK1b6cuHdUhQIhfKL3k5lEEFrXahMepvzXXHxKSDIbpXLU1IILwB4bDXztvkB44K4+MVVElinqlBkVheU+PdzqkWNmJtNAs6FV2oFkqkOroM2E6nvOCBxIqLWRUswj9lhkYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759810410; c=relaxed/simple;
	bh=f1vEoelvEyN2sJH2Sz1pFDZg2yhZJ1SL/e54WNSk89U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H7wYLWYdkIE/HF+y081NAhNX7ledZPjdyxPPPorWLvgOPz1nduBTPwEMjXaHTj0vfv7PzTLNY2H7zji8G2Z/oVJsr6G6UvC021tzw2PTSzBpYTMkQr4An13C/Rfx6oD6SeDxIz0jM2uzjT020Bwx4dYJc725DFGJERpakC0iyQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: Fushuai Wang <wangfushuai@baidu.com>
To: <sfrench@samba.org>, <pc@manguebit.org>, <ronniesahlberg@gmail.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <bharathsm@microsoft.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, Fushuai Wang <wangfushuai@baidu.com>
Subject: [PATCH v3] cifs: Fix copy_to_iter return value check
Date: Tue, 7 Oct 2025 12:12:09 +0800
Message-ID: <20251007041209.99174-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc5.internal.baidu.com (172.31.3.15) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM

The return value of copy_to_iter() function will never be negative,
it is the number of bytes copied, or zero if nothing was copied.
Update the check to treat 0 as an error, and return -1 in that case.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
---
 fs/smb/client/smb2ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 058050f744c0..ac8a5bd6aec4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4650,7 +4650,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int pad_len;
 	struct cifs_io_subrequest *rdata = mid->callback_data;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	int length;
+	size_t copied;
 	bool use_rdma_mr = false;
 
 	if (shdr->Command != SMB2_READ) {
@@ -4763,10 +4763,10 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	} else if (buf_len >= data_offset + data_len) {
 		/* read response payload is in buf */
 		WARN_ONCE(buffer, "read data can be either in buf or in buffer");
-		length = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
-		if (length < 0)
-			return length;
-		rdata->got_bytes = data_len;
+		copied = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
+		if (copied == 0)
+			return -1;
+		rdata->got_bytes = copied;
 	} else {
 		/* read response payload cannot be in both buf and pages */
 		WARN_ONCE(1, "buf can not contain only a part of read data");
-- 
2.36.1

