Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA0B3321B8
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 12:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763468801; cv=none; b=biDi0M27kEE/dlIOkSRyj6W3IEPKseUJ5SoC+9EK3e0+9K4A3GiJ0JTdsCmO6iX4SA3pZDq/oMUluwoT5bLOib6MVUTaB0+ESW5GiRNpifPn2ZL/NPt7DV+45V/oJUexiKyQFEGAWvsnozEcrRWN6V86ybGswpeUwdchuhxnLZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763468801; c=relaxed/simple;
	bh=3rX/VqHJTgtzHNXtIEjSPz09uqlbGRqTFLwySHR1ZsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Moq7jXA+IYJB34u1jN5xov3zyIBXWpPMrR+IP6185zA9mc6dglhCF+8tHlpE1fykvBAS5yHeYsNbwcFO+4BM+O+aF+bdsvNJ29x4MHTUZ09zlH8imiP1bsXsQlbw1gJMHD0ipAWDkn4koLuhaEmWcc2GrvXDvlwn4+FLx92dPYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YbZQeBju; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YbZQeBju"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763468797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LSY+cUwPd3WWpMvF8AQl/Mq19oCMrQP4VSfGWu/D1ek=;
	b=YbZQeBjundcW3Qbn+o3x4rzYXdplZ4KyxwjrnIXmLbtP6Y7Ath46rLEyY7aguobrmI1+kn
	JEuKCqR7UZxTIFOSuaPaS+rTSl2Kxru4ELMN216j9X7+4IEB941+a84btaEyMP1EDcf875
	Qzn0YrmeWQ2B99lOaBXJGNn6gK5zfqs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: Replace strcpy + strcat with scnprintf in convert_to_nt_pathname
Date: Tue, 18 Nov 2025 13:25:56 +0100
Message-ID: <20251118122555.75624-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strcpy() is deprecated and using strcat() is discouraged; use the safer
scnprintf() instead.  No functional changes.

Link: https://github.com/KSPP/linux/issues/88
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/server/misc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index cb2a11ffb23f..86411f947989 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -164,6 +164,7 @@ char *convert_to_nt_pathname(struct ksmbd_share_config *share,
 {
 	char *pathname, *ab_pathname, *nt_pathname;
 	int share_path_len = share->path_sz;
+	size_t nt_pathname_len;
 
 	pathname = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
 	if (!pathname)
@@ -180,15 +181,15 @@ char *convert_to_nt_pathname(struct ksmbd_share_config *share,
 		goto free_pathname;
 	}
 
-	nt_pathname = kzalloc(strlen(&ab_pathname[share_path_len]) + 2,
-			      KSMBD_DEFAULT_GFP);
+	nt_pathname_len = strlen(&ab_pathname[share_path_len]) + 2;
+	nt_pathname = kzalloc(nt_pathname_len, KSMBD_DEFAULT_GFP);
 	if (!nt_pathname) {
 		nt_pathname = ERR_PTR(-ENOMEM);
 		goto free_pathname;
 	}
-	if (ab_pathname[share_path_len] == '\0')
-		strcpy(nt_pathname, "/");
-	strcat(nt_pathname, &ab_pathname[share_path_len]);
+	scnprintf(nt_pathname, nt_pathname_len,
+		  ab_pathname[share_path_len] == '\0' ? "/%s" : "%s",
+		  &ab_pathname[share_path_len]);
 
 	ksmbd_conv_path_to_windows(nt_pathname);
 
-- 
2.51.1

