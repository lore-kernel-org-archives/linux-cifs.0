Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664698498
	for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 04:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="q7JaF2Xj"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702699813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1MWkrAALI2O2O/9VtX/7hA45pQY69vm6tgh+X3v3yN8=;
	b=q7JaF2XjCqICkrLEQR9ESP+LS8dONwuKE/6aDnPptQa9tGCQaIGaQC8YAqiTzuBFNkpWhl
	o1gG+R3OoOwQEok7RHGDwERpal59WfFlH8ueu2W7Jm2PCvXL/uldPdrxH2tCPuvs6eG2VH
	p9cj4iUCDHjnuhfIWDWLbtSEP20N3DxRWDDI8XLBXnJ0eNzdgrwnFRYCh3y5ounlIqMRnW
	sIk/ss6uxgjgiY2ztQrz/kNS/QMJICVtxngu8Ca/BO6bLIjbSi9Ed8zp5Di3pv05/pUjtY
	OwA7PIoxQajzl5wN9xCLYMhJjbK8YcaZ9WvJeoBs5EFzWlU1NMv+vXH2emv8yA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702699813; a=rsa-sha256;
	cv=none;
	b=cqOIYyg1hoC9pu0GKbSMSfQwdj1EMHWxP+gRiHYKC7UxA/JOiGMb8+bqLPk/oZBxOOsV4u
	1ww1PvAKgMYdNfrjUMjDY0ntTM2OhQZ9aQ492X2choryX7yMeLh7IGG2EuxD7tXfg/TiTl
	QU4pXJCAM9aBJ3PGR+ikuz8JQV+nZ8CScIlPFxU1f2QIrh5Sd5zxv0CpvaPZkON5texW26
	tPWP9mMyrPUgiobCMpupccB4wZZG1XO1nBfR5UAG3sG1niecO5SjqplqNSp4NaDN1u9ZWE
	DQslQEHFDsI2i+WVsSgmLJwpRB4e4WGj/4Q98CzcdHlzkSxNGj8LmNiT28gXHA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702699813; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=1MWkrAALI2O2O/9VtX/7hA45pQY69vm6tgh+X3v3yN8=;
	b=I5ulei8nKOGXCkIeOHA8kyRvyGfLb0BTFEPtRGLxGYwmAO3VAoJzwTZvjyM4ZjSf4BY8WT
	+80IwJsPiak7rOHJmR/bOj8eWxFGyZhkCYR3abJXU0eQGQF3aKrK5kmAPUCMrkfzqCiEHr
	ofSbrEng1TFfYMFYI1VjdLQP9ChKTdHWfNElWAkGa20daFc+ezdaj2tJCWy4esZYoOc9K6
	ZwX97rk2Mm3LMyb5pIxOSQQpDGrSrdeZ4eFkQu/BM1zlVCJ7n4+GjtqdI/s7A8PSsSCXPm
	l7eseVoJOm916X28sYvMybNmyYfqUMQXFBlWe089aoWw3YwGpZWzzLxZ8hiBrg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/2] smb: client: fix potential OOB in cifs_dump_detail()
Date: Sat, 16 Dec 2023 01:10:04 -0300
Message-ID: <20231216041005.7948-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate SMB message with ->check_message() before calling
->calc_smb_size().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifs_debug.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 5596c9f30ccb..60027f5aebe8 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -40,11 +40,13 @@ void cifs_dump_detail(void *buf, struct TCP_Server_Info *server)
 #ifdef CONFIG_CIFS_DEBUG2
 	struct smb_hdr *smb = buf;
 
-	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d\n",
-		 smb->Command, smb->Status.CifsError,
-		 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cifs_dbg(VFS, "smb buf %p len %u\n", smb,
-		 server->ops->calc_smb_size(smb));
+	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d Wct: %d\n",
+		 smb->Command, smb->Status.CifsError, smb->Flags,
+		 smb->Flags2, smb->Mid, smb->Pid, smb->WordCount);
+	if (!server->ops->check_message(buf, server->total_read, server)) {
+		cifs_dbg(VFS, "smb buf %p len %u\n", smb,
+			 server->ops->calc_smb_size(smb));
+	}
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
-- 
2.43.0

