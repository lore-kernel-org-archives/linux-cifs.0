Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113493218DD
	for <linux-cifs@vger.kernel.org>; Wed, 31 Dec 2025 13:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767186645; cv=none; b=IVqXrl/qYcB9m50coclJAeCA0C+K6vtrxQ2oz0Tz5FiSSL7NNrLoYvfGN3bK5Muz7sxz4cN80yunoWSvdrG9SjH6Y5hGchTFETXG1NE5UkxdVMvyzhQggvK9WsKF2OKeT+9nq2AhEgPJvwkjuK3gCSqlUBsoPZt3q+xQBATKikE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767186645; c=relaxed/simple;
	bh=USoFn8sbq+YG1isZNm8v3GzH/QN1t6/YoNJkI13qfO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyc/ITlauGeIAVa6TVQM/mPLdNC9iHRFdq1xlzsZ3Zk1xpbC+jBDmnMcACHB1BsMg67CkWlhNuhoX6Com5IWLH9K4CIxHdRPV6PJiMd/U18KCga9ivkZ7Tm0JRFKyf9zjMBHBAFhiaoULtKkpp9lYGXcIAt8RdC9qGjyZnwywuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AMsdpeMd; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AMsdpeMd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767186641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VCft8OL3ctdguK/cJMKTNLCxOzKOc7JeR82Pj4VpWaA=;
	b=AMsdpeMdSS7htAqKAQ+dwH1vg9BolcGhtbM75zKv+EAtgJkHL/ZOGdAz54RPEv4Fqv194c
	rPuOe45NR8YUvZ3UbKGOcmDh8Lhnrt/V8SuEQ7ounzfNDkrM9ipH47T8oTwMnrpTRujekb
	e7rJQsXCtRyQfKI+GKjx7+YypP2WRvY=
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
Subject: [PATCH v7 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Date: Wed, 31 Dec 2025 21:09:17 +0800
Message-ID: <20251231130918.1168557-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
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
 fs/smb/client/smb2maperror.c | 44 +++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index c36cfe707bf1..93d52a8cd1fe 100644
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
+static struct status_to_posix_error *smb2_get_err_map(__u32 smb2_status)
+{
+	struct status_to_posix_error *err_map;
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
+	struct status_to_posix_error *err_map;
 
 	if (smb2err == 0) {
 		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
@@ -50,17 +73,16 @@ map_smb2_to_linux_error(char *buf, bool log_err)
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
+		pr_notice("Status code returned 0x%08x %s\n", smb2err,
+			  err_map->status_string);
 
+out:
 	/* on error mapping not found  - return EIO */
 
 	cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
-- 
2.43.0

