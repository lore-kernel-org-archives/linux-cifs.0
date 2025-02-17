Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9E7178372;
	Mon, 17 Feb 2025 07:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739776916; cv=none; b=dHyd/zwGKIYnfxTwJIve1I0WB/2U4xdVl+dYI2A75qKdUWwu4do9z5rQ88xMl0pAlJWDADC8j/sFcrabwUBYY4ba3+EuVPEWfazrjMR/W/vslXqRQSs249GkwJnLo7+dirhvTlWd3ZJhZxb+sNLRuQYNLYM+cJ9lKaBrAd6ZM18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739776916; c=relaxed/simple;
	bh=CVQiVUcgmeNnwv6lfuzAw+pFG6pLRSsqUBtUeRDKPZs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tMvYwPxYa1UW+Ml6ZOc6WNqx5K2ZFhADCxkcKwAeB6N13H7MDNHO046QSXq62Pl4TAvwSSiFbPLh+6b+iWzptyde2UR7AjgaZ9yAX41qYoxqS+Hia8+L8a7MhfYfq3k6JxmIVcRKpcxKW/PjxVXumRPx3zW570MjfYJ/lFAN3ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nRG34CVb; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nRG34CVb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=3aFSJ
	paA65rGudcKu6mywA7zQDBYNPBT3Nwf6w7L0Wo=; b=nRG34CVb0cOwDOqI1q7jt
	VpkEZ8+NlrRpQgljPWNw6Hu1ZAUSF3mhrRArVO6PwpEQ9T7MmYLa6vGToF5r9wUX
	PJwLS7+kG4cIo5cRR7MPvChgBKtu10fcgifjJ6etB6zdgDz06DU3C44DiTAgVsv4
	nubIbc7sCwI/0BAcPN1FmE=
Received: from icess-ProLiant-DL380-Gen10.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD33_tK47JnqX+pMg--.30402S4;
	Mon, 17 Feb 2025 15:20:43 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: Add check for next_buffer in receive_encrypted_standard()
Date: Mon, 17 Feb 2025 15:20:38 +0800
Message-Id: <20250217072038.2311858-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD33_tK47JnqX+pMg--.30402S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrWruF1UXFW7Jw1Utw4Utwb_yoWftrc_AF
	WkuFykXa45JF1qkw4jyw1jvrnxAw4rAw4xuF1UXrs3Ary3urs3tw4DX3Z5CFy29FZYqrW5
	GwsFkws8CFs7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNvtCUUUUUU==
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/1tbiqAzybmeuC3GXKQABs0

Add check for the return value of cifs_buf_get() and cifs_small_buf_get()
in receive_encrypted_standard() to prevent null pointer dereference.

Fixes: eec04ea11969 ("smb: client: fix OOB in receive_encrypted_standard()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 fs/smb/client/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ec36bed54b0b..2ca8fe196051 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4964,6 +4964,10 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
+		if (!next_buffer) {
+			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
+			return -1;
+		}
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 
-- 
2.25.1

