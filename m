Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A8340D561;
	Sun, 28 Jun 2026 07:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782630277; cv=none; b=smiVGRlPOcZeQbkQlSDfI3DCxDWyBm29pJ/Q650HpSN5GUhsJ8Xiw52WzsAWyf/MlpUo3VqjyOA/ntoJSR/4snoUikSMRk+vFRnd8fA9yYcTf/Ot3OMkPtRwaZvB6Hjt0lQhx2aNK75Sauw0XLkDYUEDAFC+ZsclDsosB9UBlxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782630277; c=relaxed/simple;
	bh=U91wANWtwmBV4t9/7XOrHHvGG7lONNGcLKnM0lbyy1w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B/cCnjFcxs5b4maJxPG/i/YrmymVi6OoqPZwTqtaGXLED/twDeU82bjaL1SZ68HxtuW9jM6+lWX/jWKNlt2+7iKBlB45LsdScrxmirJgNJdyqINROF2a1x5g63J41NRa4R1vxsDCTeWYiuALu38MuGvCQW946ZLKKR/wnfkBq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=Lx3dSd9D; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="Lx3dSd9D"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4408a6f29;
	Sun, 28 Jun 2026 14:59:11 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	zilin@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>
Subject: [PATCH] smb: client: fix buffer leaks in SMB1 read and write
Date: Sun, 28 Jun 2026 14:59:09 +0800
Message-Id: <20260628065909.3194121-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f0d06661303a2kunm50e272f912919c
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZH0pCVhhCHU4aTU8fQh5OT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktISk
	9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=Lx3dSd9DsWCroZZyiBTipWCpY5e4dEiDS8ywvNzNnXNHNFa1RkSaw7mV6wDHaFGaAyX5Y0JJpeBYGsBLtVP2COUyYvLaxauxcVyap5sqZmWWJEl7dRFLk+XFlEOOhLbS4JuqDeGDNCGxJ2Gx5Dol8+v5luwBNcFhUgKQiKwDqVs=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=cv/LS8FndkUaqSCWCyX5ERgUgoYHmnxyOKFv4jUH42o=;
	h=date:mime-version:subject:message-id:from;

CIFSSMBRead(), CIFSSMBWrite() and CIFSSMBWrite2() allocate a request
buffer before checking whether tcon->ses->server is NULL. If that
defensive check ever fails, the helper returns -ECONNABORTED without
releasing the request buffer.

Fix these leaks by releasing the allocated request buffer before
returning from these error paths. Use cifs_small_buf_release() for the
buffers allocated by small_smb_init() and cifs_buf_release() for the
buffer allocated by smb_init().

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings.

Runtime validation used a temporary fault-injection hook to force
tcon->ses->server to NULL after request-buffer initialization. On the
unfixed kernel, the harness observed two leaked small request buffers and
one leaked large request buffer, with directed kmemleak dumps confirming
the CIFS buffer allocation stacks. After the fix, no CIFS request-buffer
deltas remained.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 fs/smb/client/cifssmb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9e27bfa7376b..024c5d462424 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1681,8 +1681,10 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_small_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;       /* none */
 	pSMB->Fid = netfid;
@@ -1796,8 +1798,10 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = netfid;
@@ -2077,8 +2081,10 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_small_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = netfid;
-- 
2.34.1

