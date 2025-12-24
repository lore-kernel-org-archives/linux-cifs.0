Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5007E279DB6
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 02:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766543592; cv=none; b=n9rDo/HCls55pgEanZnkkFArozi1MJDhNaISbMRY0HRoIEcdFHig6/1FJSQS6F72zI6QEvcj9mk1DvzU3UuSzeBtM5iRjwSfxaiRY+oT3F12XxX3yDUS84vMNVvoIyrtUNrpXKbG/EI2a7hqTCB2zY6vGSJ3u9aM0Wm/1sJ1f8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766543592; c=relaxed/simple;
	bh=Ed0ELxBmxMcOomV7hKTA0H3OfYEL5c23P8g6+wNkOys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcsOEIvUTxTrj4eshUiulzpmu9k5HyGnpHbW4oqCGU6gSJTNIStJfKsJyiYjuWFXR4otRtsquQqLKif0hKKOdmUYiRGUYgpipUBeNqLIAWNtLJmTiZfUzudqTbXvfBQy1XItVwh7AzgsVsH+gSIp6A5wb4USlfFK8U2ZQwJ/nSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nw/Xos5n; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nw/Xos5n"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766543586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1K01ZclCUe44eFbQCVEVG/qFqIh3iiL05dDDlkxydIA=;
	b=nw/Xos5n+/vp/fnGmKuNVn//dcDfRQyXoALlhVl7lF1ga9CpTQUqfcr1uPaZrzo+C3Ski9
	lZulWs6+5IB8vZo2df1++WJkadbmtu2VMCmrz3OIqE+SWpYXfN4CQ+5RfSm+XKuC3GCU3x
	fRElrJ3MTaOQ7keh0h3/eZMytwqrDfk=
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
Subject: [PATCH v5 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Date: Wed, 24 Dec 2025 10:31:43 +0800
Message-ID: <20251224023145.608165-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
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

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 45 +++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index d96448cacf0a..e47564cc3a04 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -29,13 +29,37 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 
 static unsigned int err_map_num = ARRAY_SIZE(smb2_error_map_table);
 
+static int cmp_smb2_status(const void *_a, const void *_b)
+{
+	const struct status_to_posix_error *a = _a, *b = _b;
+
+	if (a->smb2_status < b->smb2_status)
+		return -1;
+	if (a->smb2_status > b->smb2_status)
+		return 1;
+	return 0;
+}
+
+static struct status_to_posix_error *smb2_get_err_map(__le32 smb2_status)
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
-	unsigned int i;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
+	struct status_to_posix_error *err_map;
 
 	if (smb2err == 0) {
 		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
@@ -49,17 +73,16 @@ map_smb2_to_linux_error(char *buf, bool log_err)
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
+	err_map = smb2_get_err_map(smb2err);
+	if (!err_map)
+		goto out;
+
+	rc = err_map->posix_error;
+	if (log_err)
+		pr_notice("Status code returned 0x%08x %s\n", smb2err,
+			  err_map->status_string);
 
+out:
 	/* on error mapping not found  - return EIO */
 
 	cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
-- 
2.43.0

