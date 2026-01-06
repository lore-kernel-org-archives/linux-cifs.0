Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA6D309F04
	for <linux-cifs@vger.kernel.org>; Tue,  6 Jan 2026 07:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767683805; cv=none; b=MjzxTGmYKfyQGUMCN5jnmq0+ZgX+R0JtP5wRXfXrcMMFrm23JipiJmGfBGnHGOnEFWogbr29eLUklljc/GUEk8MN1L23BFxOzMUBlRgQIIQOedPvmsqdc4owJuR0FUH+rmubXUvNUm2iMhaoLgl0cP+Y5BIk9kW1jpcK5/6GevM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767683805; c=relaxed/simple;
	bh=R5lpGhLWq+yLwBWadybpPuFLPC6OAxKRk7GrpdZAJaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THKitlKsQuX8ysH4a+5LiurqZCyC8EXG6h9CDmMEPJNinXmz3QFJNyW7P6YMH6aYLscR3iszArEAZc3SaKb9mEheJeh/fyQ1qTL1ISa02nijjYdFDk9yAaX1QK0Esr7HsQDRTUKvGTIjQsY9T6ORFji9UvfYYhMcf1QHtUcfX8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ehNqhm6Z; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ehNqhm6Z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767683801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZtMpa5/JzFh6t6dQhjhEZ3/5F2sCA1RwrE0M0bCwLG4=;
	b=ehNqhm6Zf7P/4Wyzj2i0Ce9xHF6V6wggYY9Z3F3ce75SQQnYYtZt2H9Kx6ICFQKGC1Vo4B
	jywPh3CNvL3eUdsq4r4fSSw8rOQpsZKm/C4Z7M3UksvRBkecD5iCAaabuJmA3Gtbjj6YAX
	j9tTL6p3urUEEpgCuhoiAPLH7X52YbI=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v8 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Date: Tue,  6 Jan 2026 15:15:06 +0800
Message-ID: <20260106071507.1420900-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The smb2_error_map_table array currently has 1740 elements. When searching
for the last element, the original loop-based search method requires 1740
comparisons, while binary search algorithm requires only 10 comparisons.

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 46 ++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index c36cfe707bf1..090bbd10623d 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -30,13 +30,36 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 #include "smb2_mapping_table.c"
 };
 
+static __always_inline int cmp_smb2_status(const void *_key, const void *_pivot)
+{
+	__u32 key = *(__u32 *)_key;
+	const struct status_to_posix_error *pivot = _pivot;
+
+	if (key < pivot->smb2_status)
+		return -1;
+	if (key > pivot->smb2_status)
+		return 1;
+	return 0;
+}
+
+static const struct status_to_posix_error *smb2_get_err_map(__u32 smb2_status)
+{
+	const struct status_to_posix_error *err_map;
+
+	err_map = __inline_bsearch(&smb2_status, smb2_error_map_table,
+				   ARRAY_SIZE(smb2_error_map_table),
+				   sizeof(struct status_to_posix_error),
+				   cmp_smb2_status);
+	return err_map;
+}
+
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	unsigned int i;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
+	const struct status_to_posix_error *err_map;
 
 	if (smb2err == 0) {
 		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
@@ -50,21 +73,20 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 		   (smb2err != STATUS_END_OF_FILE)) ||
 		  (cifsFYI & CIFS_RC);
 
-	for (i = 0; i < sizeof(smb2_error_map_table) /
-			sizeof(struct status_to_posix_error); i++) {
-		if (smb2_error_map_table[i].smb2_status == smb2err) {
-			if (log_err)
-				pr_notice("Status code returned 0x%08x %s\n", smb2err,
-					  smb2_error_map_table[i].status_string);
-			rc = smb2_error_map_table[i].posix_error;
-			break;
-		}
-	}
+	err_map = smb2_get_err_map(le32_to_cpu(smb2err));
+	if (!err_map)
+		goto out;
+
+	rc = err_map->posix_error;
+	if (log_err)
+		pr_notice("Status code returned 0x%08x %s\n",
+			  err_map->smb2_status, err_map->status_string);
 
+out:
 	/* on error mapping not found  - return EIO */
 
 	cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
-		 __le32_to_cpu(smb2err), rc);
+		 le32_to_cpu(smb2err), rc);
 
 	trace_smb3_cmd_err(le32_to_cpu(shdr->Id.SyncId.TreeId),
 			   le64_to_cpu(shdr->SessionId),
-- 
2.43.0

