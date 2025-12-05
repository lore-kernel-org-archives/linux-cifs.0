Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CF22BD5AF
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 04:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909081; cv=none; b=CqsAcYhL9igFTiEgP6HQMN3O83DC5UXgrzqJbtc+6yHqiCJH0I1+ixT652VAjDDJbRz2flfYH6eM8PTNER6ODazw14s7HgB5ZUzVL/BaUBZgIMgImMX6D4/loeNKoJvf0X7uEGyQCWzhaud2t5CS5t6ols4PnU2rohxTwpgWLDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909081; c=relaxed/simple;
	bh=a4niZBR3NqXVCxmEEdM4gbzE6T5TiwG9k+62K89uHYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n201s+rD7jvlIKqeuXCWXa93tRr/dDRkADtK2TFTLrwgT1O93qEREPJ+XqX8a5Y1ucXNAxlcmUJa1a8U3UFrkz5JlpkmyBxSTb6nz7OMnoBEByF0nI3hXFNTPyTIm2Jjbmqzd6KkBn0Nwr/pKwcj7lt6QNHfBNeRx9HpuIHUfyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n3bxJkUo; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n3bxJkUo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764909076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZIEA7m/p4sRFl+N9lWSpTrYU+e/rIgvWYLIQkCdILQ=;
	b=n3bxJkUoDTJ1OZGwTkpi+u46rVifQsjbhcSKBbHaCiUppevfXkvxu0NT718MYRrl/Bdi16
	6j2OcBLjEu43yugNUiZdtk1tuILr53vXxea4rn0E6aL4qnSXrx0MzozW1plGvuHEVStJsu
	GT0fe2Pj9LOWHWf/z174X3ymn6iPAYc=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 7/9] smb/client: introduce smb2_get_err_map()
Date: Fri,  5 Dec 2025 12:29:55 +0800
Message-ID: <20251205042958.2658496-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
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

