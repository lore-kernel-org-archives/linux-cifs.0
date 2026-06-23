Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20636729C;
	Tue, 23 Jun 2026 01:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179209; cv=none; b=GbFnMlMOGPYmkBwbnvSz8j4zcev+bt5xq0ynhG78Y8kyFHZwEXYKgbSfbqNkaKWyJRpm901Wc0Wvb8fQeIY1YnR1jWovUS57pvTdgnlicGJO10LS7zGYFOdOXAJ6qzeKmgpRf1b6SkQU0SBpPwYTSBfvNrfXTWrAq6d1vczffiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179209; c=relaxed/simple;
	bh=v/tKung0ZLiWYJyU6JpZYrP+6goQaAF2CvQCcsq1G4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hbxhPkHG3zrwRHGR993Vh6NCdXlQJhMd8+OPFbwJ4EdOH2JklyUzptHoAbErHjivdMWN6JL4uN5zlDJQYXwpvYKYpNP9m9qp1MYb/i/Ns42lUgXAGf6WQnt43TdOQfOSmhvrbCovq7R2ARQmgEr0xKFCvKTHH13ULxTFeSMTUSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=M9z3UsKY; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="M9z3UsKY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=c1
	VwIGKvdf4wrFnYi7phDF5+7a2hnYBrcFFUcphi/LQ=; b=M9z3UsKYlky2ykjdEt
	NCrOZ3V637+AU5B+0dy/x3LyB4Ra74kP+g9rhFTpGaRxDAW5zkPuHe1LOPiM+Ngo
	PCjXNTcOXfj0mpXeHLdX1v12MOPRt9oEulMHny+qVcTUe5WJIM/JKXMPSLIyUYEk
	CKSWc32a6P8qhpHZA192P9iD8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCnZdRC5Tlq63HuFA--.41645S2;
	Tue, 23 Jun 2026 09:45:41 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilov@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Tue, 23 Jun 2026 09:45:38 +0800
Message-Id: <20260623014538.1705722-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnZdRC5Tlq63HuFA--.41645S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr48AF18Xr1rGw47Kw4fuFg_yoW8XFW8pF
	4Uta47Kry5Xr12k3WDAa9xGa45uws7uF18K397t3W0qFnaqF40kasIyrnF9ry5Cay8u34a
	yFWvya1qv3WS9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piyE_tUUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7gVz4Wo55UVubwAA3L

receive_encrypted_standard() allocates next_buffer before checking
whether the number of compound PDUs already reached MAX_COMPOUND. If
the limit check fails, the function returns immediately and the newly
allocated next_buffer is not assigned to server->smallbuf/server->bigbuf,
making it leaked.

Move the MAX_COMPOUND check before allocating next_buffer.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 fs/smb/client/smb2ops.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a8f8feeeccb5..c39944dd40bb 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5111,6 +5111,12 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+
+	if (*num_mids >= MAX_COMPOUND) {
+		cifs_server_dbg(VFS, "too many PDUs in compound\n");
+		return -1;
+	}
+
 	if (next_cmd) {
 		if (WARN_ON_ONCE(next_cmd > pdu_length))
 			return -1;
@@ -5134,10 +5140,6 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 
-- 
2.25.1

