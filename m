Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC5534CF5;
	Fri, 22 Nov 2024 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732289501; cv=none; b=HXIUwSEOqXVP35QZtkJ4J6b4ayTa5n2sK/MmFZx61FPQnnK59t+Esg+v4/VYXX88rlzWm2bV/lZkDAmq5gH3FyOqVb7q6Yxqw0GIoyAEM6hObHR3D6EkUK2L1i28FQD39pGf9b8ilfEIlfdzVuz9srwebDk2/r2QM0KrjEthEI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732289501; c=relaxed/simple;
	bh=hCFHgMLo7sNYwDywbs1fYqLz3c9Z/HbwJFsp1ejUIp4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AxQnoH3B15BjgeNF9hFlYLjedpxO2WwRpbelF1HKT4YRhKAqgXXY7ji4fCuWyCOyzwNXpzPAHh6EBfUG/Lzi974afcYZgOoBjkvlxiTVDiZ60KjI337mpil0Phgv4DohfhutaaoniSiz8H4MoUpS/TtJmszPEc1tV27pzVQMB6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=HA/B51wb; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="HA/B51wb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732289499; x=1763825499;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Tsn9RFmGQbXdrr+mw0qy7JKc6sqBehJRetVocjosvZY=;
  b=HA/B51wbNjOUZb1IyY9T9l67q7M6bNpIa+rhBeWFjiJ3L/YDMGCslaOA
   uNjafCgHmYJbPybpJcC1eSyYK7mL0wMBKEGG6ZnkYqhUPDUsfud4AUty0
   IAa67CPq7hwwiKo8uea1vWB6/IQJkvPwNTX+et6rbvPjiDUYmPx93U0Zb
   U=;
X-IronPort-AV: E=Sophos;i="6.12,176,1728950400"; 
   d="scan'208";a="445178229"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:31:34 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:58234]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.101:2525] with esmtp (Farcaster)
 id c2b526e1-9df4-4ab2-9649-033129729f2e; Fri, 22 Nov 2024 15:31:34 +0000 (UTC)
X-Farcaster-Flow-ID: c2b526e1-9df4-4ab2-9649-033129729f2e
Received: from EX19MTAUWC002.ant.amazon.com (10.250.64.143) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 22 Nov 2024 15:31:34 +0000
Received: from email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Fri, 22 Nov 2024 15:31:34 +0000
Received: from dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com [10.15.1.225])
	by email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com (Postfix) with ESMTP id 9F6C740DC6;
	Fri, 22 Nov 2024 15:31:33 +0000 (UTC)
Received: by dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com (Postfix, from userid 23907357)
	id 5DB702404; Fri, 22 Nov 2024 16:31:33 +0100 (CET)
From: Mahmoud Adam <mngyadam@amazon.com>
To: <gregkh@linuxfoundation.org>
CC: <stfrench@microsoft.com>, <pali@kernel.org>, <stable@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>
Subject: [PATCH 5.4/5.10/5.15] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Fri, 22 Nov 2024 16:29:43 +0100
Message-ID: <20241122152943.76044-1-mngyadam@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

upstream e2a8910af01653c1c268984855629d71fb81f404 commit.

ReparseDataLength is sum of the InodeType size and DataBuffer size.
So to get DataBuffer size it is needed to subtract InodeType's size from
ReparseDataLength.

Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuffer
at position after the end of the buffer because it does not subtract
InodeType size from the length. Fix this problem and correctly subtract
variable len.

Member InodeType is present only when reparse buffer is large enough. Check
for ReparseDataLength before accessing InodeType to prevent another invalid
memory access.

Major and minor rdev values are present also only when reparse buffer is
large enough. Check for reparse buffer size before calling reparse_mkdev().

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[use variable name symlink_buf, the other buf->InodeType accesses are
not used in current version so skip]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
---
This fixes CVE-2024-49996.
 fs/cifs/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6c30fff8a029e..ee9a1e6550e3c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2971,6 +2971,12 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
 
 	/* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
 	len = le16_to_cpu(symlink_buf->ReparseDataLength);
+	if (len < sizeof(symlink_buf->InodeType)) {
+		cifs_dbg(VFS, "srv returned malformed nfs buffer\n");
+		return -EIO;
+	}
+
+	len -= sizeof(symlink_buf->InodeType);
 
 	if (le64_to_cpu(symlink_buf->InodeType) != NFS_SPECFILE_LNK) {
 		cifs_dbg(VFS, "%lld not a supported symlink type\n",
-- 
2.40.1

