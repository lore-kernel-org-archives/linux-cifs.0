Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81D130146A
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 04:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824400; cv=none; b=Axtc6njA2OSCkrdiuAGU3fehOC/JfSUrpoIQ0vdxgyzedm/xOFDFVR5lMC9Vt6LDP3ZwwVTQGgYyEcOsik4xqz09cWaObFVvnwQeZn/EEHu3TGBdShalpD6Jz4fJ7g/BmZfD5Vp68ChtcoIKveKApz/AsJ2z0F576yp1IR4TsGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824400; c=relaxed/simple;
	bh=a4niZBR3NqXVCxmEEdM4gbzE6T5TiwG9k+62K89uHYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FitW3qaL5k/G96DanwpdPFwUDdH0x3fnF3+X3HSHRKgeLsKuLBm3QI4rQr1e3+B61zZCAZULo+YvuwVAWO27vFfT2Nw3kwMCika1OOOnz8koDaZmZ3rU3OuUw+AggYguXtiGnYkaHdqzilaqFPOlz6FtmlYUNFMya2DupOR/cgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FtaA7YEk; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FtaA7YEk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZIEA7m/p4sRFl+N9lWSpTrYU+e/rIgvWYLIQkCdILQ=;
	b=FtaA7YEkKF87twDIMtuME8LH5kDfR7wVC28M2r6XZU+zCOPPWu3ycAWK+H5OZWblbtI6O3
	vev74UuuW5TxpZR81IRM6Tj3Euy3cwIE+dYEnYkfZbmjptSXb0uW0/xcFPvQJ/wdf9hl73
	CzQNnjV3wNudUPT1L/g5m54ird4Fchw=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 06/10] smb/client: introduce smb2_get_err_map()
Date: Thu,  4 Dec 2025 12:58:14 +0800
Message-ID: <20251204045818.2590727-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Preparation for KUnit tests.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index df8db12ff7a9..f5d999f3b569 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -2433,13 +2433,27 @@ static int cmp_smb2_status(const void *_a, const void *_b)
 	return 0;
 }
 
+static struct status_to_posix_error *
+smb2_get_err_map(__le32 smb2_status)
+{
+	struct status_to_posix_error *err_map, key;
+
+	key = (struct status_to_posix_error) {
+		.smb2_status = smb2_status,
+	};
+	err_map = bsearch(&key, smb2_error_map_table, err_map_num,
+			  sizeof(struct status_to_posix_error),
+			  cmp_smb2_status);
+	return err_map;
+}
+
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
-	struct status_to_posix_error *err_map, key;
+	struct status_to_posix_error *err_map;
 
 	if (smb2err == 0) {
 		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
@@ -2453,12 +2467,7 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 		   (smb2err != STATUS_END_OF_FILE)) ||
 		  (cifsFYI & CIFS_RC);
 
-	key = (struct status_to_posix_error) {
-		.smb2_status = smb2err,
-	};
-	err_map = bsearch(&key, smb2_error_map_table, err_map_num,
-			  sizeof(struct status_to_posix_error),
-			  cmp_smb2_status);
+	err_map = smb2_get_err_map(smb2err);
 	if (!err_map)
 		goto out;
 
-- 
2.43.0

