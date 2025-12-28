Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4247D1F956
	for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766933537; cv=none; b=Eh+HdkLWS8BK3Dtpci8ypTb8MBwOLM4B9WOif08gjUetgHrA1m4+PDkdctbEw7ygI5SYEenFkmGy9oQTTzTNgTGEyewoDPt1seFCNK0aUEpLLeUCPfsyWO9SrjHiI8FvNsC+AXagoi9+cKCjk+ijsWo2lyE3Nsz3uqxNlZ+PyJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766933537; c=relaxed/simple;
	bh=qm2JZappdTQwDX38NRRN9vF42MbcVSSU2zSpoppKoL8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o+h0BsF8R64EMGhddgrXwh8svRbxTL2RezcnbjF6vM0RO1CQK788aQV5bWmJog6eLxk7IVsBvAF0dDsodMvlDNZxJTRMr8fnEwRwJ3vf7Yztn37ZVNqmy3XRxLjaSDsYK4I+D0/Pl6MbzhELv7XEkoLVQXRAqRDFHBdhRrUDkTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eI4HB82B; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eI4HB82B"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766933528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ox0EgXS1Ta/V/+1VAk8WjpO/tvKW0jolPIJ/JGKt2M8=;
	b=eI4HB82BABYRzl6ZgxqQ73akjkIQdAU7cObda+++a3r2Y4zJSSrFdlrCElGFu4pVmwcVq+
	ep6oxAd2RlS0+c7mPSSQY1HDhjaMtXMrkGc1UtBhPXPnKOBi+CQ51H4NsVRhFha0zF26QR
	qAeWMuYq1IcbrPx16J2ER3Q2vF38CLM=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: call ksmbd_session_rpc_close() on error path in create_smb2_pipe()
Date: Sun, 28 Dec 2025 22:51:01 +0800
Message-ID: <20251228145101.1010774-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

When ksmbd_iov_pin_rsp() fails, we should call ksmbd_session_rpc_close().

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 469b70757dba..571e9d5657c1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2281,7 +2281,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 {
 	struct smb2_create_rsp *rsp;
 	struct smb2_create_req *req;
-	int id;
+	int id = -1;
 	int err;
 	char *name;
 
@@ -2338,6 +2338,9 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 		break;
 	}
 
+	if (id >= 0)
+		ksmbd_session_rpc_close(work->sess, id);
+
 	if (!IS_ERR(name))
 		kfree(name);
 
-- 
2.43.0

