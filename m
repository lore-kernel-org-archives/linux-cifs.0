Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD41728DB76
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034395; cv=none; b=gELlJgSAQ88wcNAJd7qhpkItzaCwOUpQxVTPCZFu5jqaQrCtK/iZxWQMXlD/ZPoFDihkyeACbvUILrJEhuFMf4aKnvW5/BZ7JuxaA5X/0Qsn4CrYYgkl3lQdmc/VjT9RJF7gUCU+G4htlFZ0wQmCjNOCeYqKBp3+9KNytKYPOSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034395; c=relaxed/simple;
	bh=GpiP28Us9v7/dQoXwcAvnftubvrrsWxq7Q4tJTESinM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9RoXIlEfX9lSHvTJNsIcoYEty0PP+a97aNcLbyEBbVYnp6G73yt07ARLJQQroBZGL27TnooXnrvaq5mdSM4zf4DSIHC8SA21xHBdc4Qjw2WRAAqV7P/PdK1QeO3WfhmWw+UhacmvHmi4VQL4htU2aj5bPvxMkoNYDtDeAJOwDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DiwuZtef; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DiwuZtef"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CCS9W0lF6HDGhdijp7vL3LJGT24noIkWUUQS/1Ee9+o=;
	b=DiwuZtefwmRjosS4G3m/zgSo4os8lASEHXhzKRmEptvCFSwTuOrgFjUgOvI0vvNeeGWC/g
	bOwgSfCZVORWtcADEYriWvevVhEHtgQkULv/g1UfydRcYqSdLI+nQFEGgUmfiS1LSTdjIG
	diedbrD7++7ye4STa1Kh6+w5OV8UM4A=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 06/10] smb/client: use bsearch() to find target status code
Date: Sat,  6 Dec 2025 23:18:22 +0800
Message-ID: <20251206151826.2932970-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The smb2_error_map_table array currently has 1742 elements. When searching
for the last element, the original loop-based search method requires 1742
comparisons, while binary search algorithm requires only 10 comparisons.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 1bd4196386dd..df8db12ff7a9 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -2437,9 +2437,9 @@ int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	unsigned int i;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
+	struct status_to_posix_error *err_map, key;
 
 	if (smb2err == 0) {
 		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
@@ -2453,17 +2453,21 @@ map_smb2_to_linux_error(char *buf, bool log_err)
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
+	key = (struct status_to_posix_error) {
+		.smb2_status = smb2err,
+	};
+	err_map = bsearch(&key, smb2_error_map_table, err_map_num,
+			  sizeof(struct status_to_posix_error),
+			  cmp_smb2_status);
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

