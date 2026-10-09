Received: from mvsmtppost29.nm.naver.com (mvsmtppost29.nm.naver.com [61.247.196.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EAA4BE43B
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.247.196.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791554662; cv=none; b=sWhhVLrQit4ovmTRflJmtD18Z57q4b8/N9bcaNub0nLPiRDrUtLhaMf9+WvBfHLHWib6FZPzlalks3R7a8XcRE+bUvIceW8gGpLvm6K0/CUBj0WLEQZcnIyFE4xgkYhTmOhTaA+EWSBkTNAXEcHcHsV17t9G1/Q6FOd6vawbG9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791554662; c=relaxed/simple;
	bh=KG087Ep85YSM3sVgCbiidI3d8CyJ9wmLa7oOsHwXRGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9ryGaRskYc6jHLWJyGRojINlp0gD5CUdwdK4n5xvJlRq4OJASU9fchBxzyzRIrBxjhLYEPFdA1/nZxXNLemRcMslIlC+++PKNwLpmo2jAaSY5tDRFiwzSGs6xb9DztoG9UGXuIe4nrF2QocxzcB9c03FpUPatelZtzbobdTa2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=kcCU/YkS; arc=none smtp.client-ip=61.247.196.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="kcCU/YkS"
Received: from cvsendbo012.nm ([10.112.24.38])
  by mvsmtppost29.nm.naver.com with ESMTP id EbPBbnbhQ8aNGGaWuPvDLw
  for <linux-cifs@vger.kernel.org>;
  Fri, 09 Oct 2026 13:54:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791554050; bh=KG087Ep85YSM3sVgCbiidI3d8CyJ9wmLa7oOsHwXRGs=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=kcCU/YkSuiA697kXg1thwBwiH8z02X7eL4rhrDb3PMR7yXpfTLOvoUsjN1WZRGA3V
	 6u5rguoqc2sbHe4IKyPo15b5cLAuDiAXMbHNGgOUiC+GMH3a0KwBq3HskWsAHCcAhd
	 0Z074o68fFcJQXanNh3K5+kOM4sTJXj1Sf0EmxY9EmND7ZmB0427qRTkzBz99veXRg
	 GX05Lny322MpL15MPtor+jnRrvSEum7k0uH2nwH924utGqKN/YQrCWSXX7DGp6+e4h
	 DTWMxZo5JJFf7tkPho1Ibvb2X1BVtJBm0kwVprv37Z4U78EbLtemU+fRjyd5uxpExr
	 9daIwRh/Lf7CQ==
X-Session-ID: mkIl4ksFTCWHVLA-VIeY1g
X-Works-Send-Opt: OlRwpzGdjHmdKHFOMr39Ko3YKHmZjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: lZKZFxulFqJZ+HmmFxMw+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp009.nm.naver.com with ESMTP id mkIl4ksFTCWHVLA-VIeY1g
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Fri, 09 Oct 2026 13:54:10 -0000
From: Sung Byeongchan <tjdqudcks0424@naver.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: hold TCP session for async decrypt work
Date: Fri,  9 Oct 2026 22:53:59 +0900
Message-ID: <20261009135400.722291-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007062936.25827-1-tjdqudcks0424@naver.com>
References: <20261007062936.25827-1-tjdqudcks0424@naver.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Large encrypted reads may be queued to the global decrypt workqueue.  The
work item stores a TCP_Server_Info pointer, but does not hold a server
reference while queued.

If a multichannel mount removes a secondary channel before the worker runs,
the final reference can be dropped and the demultiplex thread can free the
server.  smb2_decrypt_offload() then accesses the freed server object.

Acquire a reference only while srv_count is nonzero under
cifs_tcp_ses_lock, which serializes the acquisition against the final put
without resurrecting a server already being torn down.  Do not queue the
work if acquisition fails.  Let each queued worker own one reference
until its final server use, and release the transferred small buffer and
reference if queue_work() unexpectedly rejects the work item.

The unmodified kernel reproduced the same KASAN use-after-free in three
fresh encrypted multichannel runs.  With this change, the same race and
subsequent encrypted I/O, unmount, remount, and cleanup completed without a
sanitizer report in three fresh runs.  Encrypted multichannel,
single-channel, and unencrypted controls also passed.

The demonstrated impact is a client-kernel use-after-free and crash caused
by an SMB peer able to coordinate encrypted responses and channel teardown.
No controlled write, information disclosure, privilege escalation, or code
execution was demonstrated.

Fixes: 35cf94a39728 ("smb3: allow parallelizing decryption of reads")
Cc: stable@vger.kernel.org
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
Changes in v2:
- Do not increment a zero srv_count or queue work during teardown.
- Add cleanup for failed reference acquisition and queue_work() failure.
- Revalidate the UAF, fix, recovery, and controls in three fresh runs.

 fs/smb/client/smb2ops.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 583ab4c4d7738..51cfd0bc21b8e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5245,6 +5245,20 @@ struct smb2_decrypt_work {
 	unsigned int len;
 };
 
+static bool smb2_try_get_server_ref(struct TCP_Server_Info *server)
+{
+	bool acquired = false;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	if (server->srv_count) {
+		server->srv_count++;
+		acquired = true;
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return acquired;
+}
+
 
 static void smb2_decrypt_offload(struct work_struct *work)
 {
@@ -5305,6 +5319,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 free_pages:
 	netfs_free_folioq_buffer(dw->buffer);
 	cifs_small_buf_release(dw->buf);
+	cifs_put_tcp_session(dw->server, false);
 	kfree(dw);
 }
 
@@ -5381,10 +5396,20 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 
 	if ((server->min_offload) && (server->in_flight > 1) &&
 	    (server->pdu_size >= server->min_offload)) {
+		if (!smb2_try_get_server_ref(server)) {
+			rc = -ESHUTDOWN;
+			goto free_pages;
+		}
+
 		dw->buf = server->smallbuf;
 		server->smallbuf = (char *)cifs_small_buf_get();
 
-		queue_work(decrypt_wq, &dw->decrypt);
+		if (!queue_work(decrypt_wq, &dw->decrypt)) {
+			cifs_small_buf_release(dw->buf);
+			cifs_put_tcp_session(server, false);
+			rc = -EIO;
+			goto free_pages;
+		}
 		*num_mids = 0; /* worker thread takes care of finding mid */
 		return -1;
 	}
-- 
2.43.0

