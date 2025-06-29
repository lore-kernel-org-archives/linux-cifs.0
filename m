Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3A6FB9
	for <linux-cifs@vger.kernel.org>; Sun, 29 Jun 2025 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751217139; cv=none; b=UsOQWrKO2TcmmHyXNq/yjeAT5ywgHiOoWAf5yTHKKTpEwAySkFtUtfAYsrwSyaDaYIVHHrq/gZozrWhH3PZReGjSRmmdExHl95IZ++HMFUV0uJ2OQD6h9HL2mmINwHY4usM2hqHfdS/p1fLNdE1dDprlRw0GjPYR9KCmcWatakA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751217139; c=relaxed/simple;
	bh=2niOZ0kgtqg04wDFBW38TvZarsM2atm/M+/j5CzIYWI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H/IdgPLuRt9s3giu9hKLBKoJWY5Ld5xMLBxieXlQpIdsHPjocTra8KEvNsDZbMF0hwRRZFCosmPf7n6p71j2AsGahCdAtdXFENp3t/ZPTYdVfdFmxZWegqYItbA6JLSYVb8L8L+jv9SP+BEX5jHUA5XyQxrSPPGMsPNsM6Zehac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=RI7VZ12o; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="RI7VZ12o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1751216706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2wQ9gt86mWKGc+zWQCJ+GDpJBhEXmLjNeXE6aH1tKZ4=;
	b=RI7VZ12okoZnpVxAXBWE14ce2KGQ2Bm34p3ChiREUolJKyAQin6/3rjRPDqydfqH2w1l6m
	JNOSv0cCi6ZNzilcpNOXy+hZck0Dn7rbom/sL2GZzLybwnkoBI1amdqh5ycXEX7iIpGvRK
	HVCVPaOmkwXV83OVkYhYCnylVHgxuVbrjvRacjTugMgJ1uw7KttweGZevYCbqcj3GuivOZ
	tYsLvHsxdClWNQpFOjXeDX25jlf420wV6708xh74CL3ae5QDlIxp6X5smqPQ7G13oY2VEg
	3rqNLdHO4e4DaYbUTfl+S0pirH3oWGWcbuUnD4dmqjmBhc+rzKjVVOA6plNAbw==
From: Philipp Kerling <pkerling@casix.org>
To: linux-cifs@vger.kernel.org
Cc: Philipp Kerling <pkerling@casix.org>
Subject: [PATCH] smb: client: fix readdir returning wrong type with POSIX extensions
Date: Sun, 29 Jun 2025 19:05:05 +0200
Message-Id: <20250629170505.11631-1-pkerling@rx2.rx-server.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SMB 3.1.1 POSIX Extensions are negotiated, userspace applications
using readdir() or getdents() calls without stat() on each individual file
(such as a simple "ls" or "find") would misidentify file types and exhibit
strange behavior such as not descending into directories. The reason for
this behavior is an oversight in the cifs_posix_to_fattr conversion
function. Instead of extracting the entry type for cf_dtype from the
properly converted cf_mode field, it tries to extract the type from the
PDU. While the wire representation of the entry mode is similar in
structure to POSIX stat(), the assignments of the entry types are
different. Applying the S_DT macro to cf_mode instead yields the correct
result. This is also what the equivalent function
smb311_posix_info_to_fattr in inode.c already does for stat() etc.; which
is why "ls -l" would give the correct file type but "ls" would not (as
identified by the colors).

Signed-off-by: Philipp Kerling <pkerling@casix.org>
---
 fs/smb/client/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index ba0193cf9033..4e5460206397 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -264,7 +264,7 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 	/* The Mode field in the response can now include the file type as well */
 	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode),
 					    fattr->cf_cifsattrs & ATTR_DIRECTORY);
-	fattr->cf_dtype = S_DT(le32_to_cpu(info->Mode));
+	fattr->cf_dtype = S_DT(fattr->cf_mode);
 
 	switch (fattr->cf_mode & S_IFMT) {
 	case S_IFLNK:
-- 
2.50.0

