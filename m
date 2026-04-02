Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90173EC2CE
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139602; cv=none; b=qpp+oE6+hYSkPiB2tROF3y/atBWBgANaxJaUpKJ999W/q/cF3JdV1mKHx1+71Qc5kcmIV6M98OniUGKY2Y4PWlQxeZYZD4BDfjoxPu/bIdp6McwY+wekUFs/pE7CzOavjC1lD2q3Cn6iewKmtgGx1ucxU8L93C7zaZWigwVcSs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139602; c=relaxed/simple;
	bh=AdCAV8ae+czHkmacruOayVt3fhwt/uR1WOb2UB+8y3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYX4qo1yvUoXtWbW8heuwe7CHjdHsUr+jxIQMNlaYiKBdHbXc62itwhRboTzP1lDpK87zTHF8rHw6j49BdAnYBhKhpNzJv2BWiJ9+HJKpEQXiHp42xfi0reMTBd39FKJcub3HAjCfUM9YTjTMOJB4HLPafnvEOk9hNV1CF0ya2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q5Sm5OvQ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q5Sm5OvQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775139598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlRuE40CiHaHcbqmS8foEXRLt6XZb3Aw4UDwDwu2hl4=;
	b=Q5Sm5OvQQaFbTXLbKBdRP9wdk1HyfAh+DMGsVkdG6W0Qg/K+J3GgE9DBr4IqRp4uacUFQR
	l7ettg6MKb1yveAS+wDS6BIzHHYqa2uUrWDZC8A5Q8K+B/2iqVtAIfSh123UdOkSktrnnz
	+s+2wgmbbbIfdYroGU9VmOV3CBaDk90=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v3 06/13] smb/client: check if ntstatus_to_dos_map is sorted
Date: Thu,  2 Apr 2026 14:18:32 +0000
Message-ID: <20260402141839.461257-7-huiwen.he@linux.dev>
In-Reply-To: <20260402141839.461257-1-huiwen.he@linux.dev>
References: <20260402141839.461257-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Although the array is sorted at build time, verify the ordering again
when cifs.ko is loaded to avoid potential regressions introduced by
future script changes.

We are going to define 3 functions to check the sort results, introduce the
macro DEFINE_CHECK_SORT_FUNC() to reduce duplicate code.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c       |  6 ++++++
 fs/smb/client/smb1maperror.c | 32 ++++++++++++++++++++++++++++++++
 fs/smb/client/smb1proto.h    |  1 +
 3 files changed, 39 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index f4bed8d4a072..0541706c36c5 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1915,6 +1915,12 @@ init_cifs(void)
 {
 	int rc = 0;
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
+	rc = smb1_init_maperror();
+	if (rc)
+		return rc;
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+
 	rc = smb2_init_maperror();
 	if (rc)
 		return rc;
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index fb985d2fc0d9..66ceebbe535e 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -256,3 +256,35 @@ map_and_check_smb_error(struct TCP_Server_Info *server,
 
 	return rc;
 }
+
+#define DEFINE_CHECK_SORT_FUNC(__array, __field)			\
+static int __init __array ## _is_sorted(void)				\
+{									\
+	unsigned int i;							\
+									\
+	/* Check whether the array is sorted in ascending order */	\
+	for (i = 1; i < ARRAY_SIZE(__array); i++) {			\
+		if (__array[i].__field >=				\
+		    __array[i - 1].__field)				\
+			continue;					\
+									\
+		pr_err(#__array " array order is incorrect\n");		\
+		return -EINVAL;						\
+	}								\
+									\
+	return 0;							\
+}
+
+/* ntstatus_to_dos_map_is_sorted */
+DEFINE_CHECK_SORT_FUNC(ntstatus_to_dos_map, ntstatus);
+
+int __init smb1_init_maperror(void)
+{
+	int rc;
+
+	rc = ntstatus_to_dos_map_is_sorted();
+	if (rc)
+		return rc;
+
+	return rc;
+}
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 42569bbcf6fd..dd98d04e837a 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -234,6 +234,7 @@ int cifs_verify_signature(struct smb_rqst *rqst,
  * smb1maperror.c
  */
 int map_smb_to_linux_error(char *buf, bool logErr);
+int smb1_init_maperror(void);
 int map_and_check_smb_error(struct TCP_Server_Info *server,
 			    struct mid_q_entry *mid, bool logErr);
 
-- 
2.53.0

