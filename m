Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1694E1B043E;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=t1kpUiy9vTbnjb19/PKELxsSFkkHJzIhxIqCO0UiuDWmGbratwtW3g7a0+Cda226+ixrEkpS/hWJrALj5StWNt+DiQuMAQurmt3BhbZsnzHI8wT4slx55toAgtjFByBqFe3otzaHIuoP0iEL5qgbFygsyjyo/4nXDn0zZu9ds9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=y8jvzkyAzxyNwmUGiUFU/ZrZFKeYb2sh7YIJFEf7HB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVvrA2uW4zICrizETuB5PKsJW2ULZ8niF3ZuTC4Q3op9wsEKwq37Pp8hHFA4yht++gfUSQnVWmOD3ZG8CmYaGmHs3EhGlWC4xseQr7rZqNKasxjgU103O0b0YQDezVry6t+RozfHGSeUfEyKrRyoDahqY7oHkS9+knB/YsPTY5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLl/i9jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLl/i9jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E27C4CEDD;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684630;
	bh=y8jvzkyAzxyNwmUGiUFU/ZrZFKeYb2sh7YIJFEf7HB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLl/i9jqiCdV9ki4y6XNyFPjqjxl3quCZMB897JpN6RgNfze9zROc7VAelBNQ91YU
	 M6GA+SZPLIzonllwazQcZHF49QaeOy8/sbjb1ursumBobX1KsLL5BkOZ2FcBMQ8xQ5
	 eO91dkSQxvBYuGVVfwiEsZi9d6DT3xSo6RDfopSx5JXxKDl67l3MD5auchQf8hb1Sv
	 zTogvAqctOrxqIKYfkETtnQajw5q4oDDQrCWrYS6Ldi1A+Obx3gplOfkug/ktjIJsp
	 n5nKOUnK35Jc1Hz888yP4mn4p4cSFRobsZH8fCBSWsyXJ6F+NiSXK7TRp2UZmhzEbq
	 Bscp2iOUn+YmA==
Received: by pali.im (Postfix)
	id 9698DC2E; Tue, 31 Dec 2024 23:37:00 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] cifs: Fix and improve cifs_is_path_accessible() function
Date: Tue, 31 Dec 2024 23:36:34 +0100
Message-Id: <20241231223642.15722-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-1-pali@kernel.org>
References: <20241231223642.15722-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Do not call SMBQueryInformation() command for path with SMB wildcard
characters on non-UNICODE connection because server expands wildcards.
Function cifs_is_path_accessible() needs to check if the real path exists
and must not expand wildcard characters.

Do not dynamically allocate memory for small FILE_ALL_INFO structure and
instead allocate it on the stack. This structure is allocated on stack by
all other functions.

When CAP_NT_SMBS was not negotiated then do not issue CIFSSMBQPathInfo()
command. This command returns failure by non-NT Win9x SMB servers, so there
is no need try it. The purpose of cifs_is_path_accessible() function is
just to check if the path is accessible, so SMBQueryInformation() for old
servers is enough.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index d959097ec2d2..bef8e03edf1d 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -520,21 +520,27 @@ static int
 cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
-	int rc;
-	FILE_ALL_INFO *file_info;
+	int rc = -EOPNOTSUPP;
+	FILE_ALL_INFO file_info;
 
-	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (file_info == NULL)
-		return -ENOMEM;
+	if (tcon->ses->capabilities & CAP_NT_SMBS)
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &file_info,
+				      0 /* not legacy */, cifs_sb->local_nls,
+				      cifs_remap(cifs_sb));
 
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_remap(cifs_sb));
+	/*
+	 * Non-UNICODE variant of fallback functions below expands wildcards,
+	 * so they cannot be used for querying paths with wildcard characters.
+	 * Therefore for such paths returns -ENOENT as they cannot exist.
+	 */
+	if ((rc == -EOPNOTSUPP || rc == -EINVAL) &&
+	    !(tcon->ses->capabilities & CAP_UNICODE) &&
+	    strpbrk(full_path, "*?\"><"))
+		rc = -ENOENT;
 
 	if (rc == -EOPNOTSUPP || rc == -EINVAL)
-		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
+		rc = SMBQueryInformation(xid, tcon, full_path, &file_info,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	kfree(file_info);
 	return rc;
 }
 
-- 
2.20.1

