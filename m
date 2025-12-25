Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AA91DE89A
	for <linux-cifs@vger.kernel.org>; Thu, 25 Dec 2025 02:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766628717; cv=none; b=sKJA8CNxmpD0wVNWvsVvaReUr+XJHOv2EfMP/dvHQqPFCWcYIcopGcwGMA6n5Ho6jBS8tPyQUiQYHotM7YWw5ha48YaaRshQeUPT6bpyc/9/E/O7n3ddUZIDZL8Ol8oUe5K6M7pfM584Ckj04jNdFaOvGa8lPLZ0JitRQQTD85k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766628717; c=relaxed/simple;
	bh=WbdxjAad2JdENKQZWFAYLPEg0mmxeR9eK1hEth/+AtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksqqZMeN+D0cKy+tpHAN8d60YteY6u40VJLVa9Sns35ys6NTXox+Wq84PMuEKa2Fc6FCE1vg1srBAiBB21BGcuf64YPW3zoR8bcdTBxxwnCrjrzHG2ZQgLZmeQq0n14grdFDq1IVFNuyW02RoutvP1DlVeLkb6p+wnvqq4DD9pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ut+PIdcF; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ut+PIdcF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766628714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGxqa6Dis+NnvWijecQJsmpN+Kt+xmwenu+TF1WYDRA=;
	b=Ut+PIdcFodRIqTR8L2TcPxm9jd0Zh1+YDcHVsAtQ3p33CZOHwHFAAvVCeMeU0PEw43NfFF
	Xb/PI85qcyC9VpImmtjpkZo2AGFLPH4HTi4Ae6WlBxaxo9cubaBGBlTnyEfcaejofEv+vp
	OYHHx53wk3YGEdHTtXIjDvpRD+SQwbE=
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
Subject: [PATCH v6 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Date: Thu, 25 Dec 2025 10:10:34 +0800
Message-ID: <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
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
 fs/smb/client/smb2maperror.c | 46 +++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 3731e32c22a3..b0241e6adbb6 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -27,13 +27,38 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 #include "smb2_mapping_table.c"
 };
 
+static __always_inline int cmp_smb2_status(const void *_a, const void *_b)
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
+	err_map = __inline_bsearch(&key, smb2_error_map_table,
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
@@ -47,17 +72,16 @@ map_smb2_to_linux_error(char *buf, bool log_err)
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

