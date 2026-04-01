Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B8E391E43
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 07:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028641; cv=none; b=OCvqEOhmsO9ysUCtIbDb3OUOTMYVrrWZDpSs+Wmmo+FElmAlXi7gWGKf0H0D4PVDfmd6L8QDvbaxPf5XJAwBV/7hvT8Ng7COe1qicASO6tzrxlJWqytoy21tsQf+jZdxi6wjQobZ0YOKkIg4pV84jktwkRgAaSdeeeZVO3I31js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028641; c=relaxed/simple;
	bh=37s9BAMChlsw1vd8Vht5Td0zZB01i1HA3cEULgDTxDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPOoKU0MiOsrB32ERTlks8qs+xQNm1ztjiIWLdX0gWfcTE0TW0E9OCALm0le1I4yh+jO4+wj4BZoGleFGnPCiGb3w/ueOx4Vw+RJAJWPEX0MAPw+UTA+OOBqMOHUIwD+fdHKjV6H3Ux7T0zRmM72IcDyDymtHpcWQhCbyKcaY+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KxbMaLVS; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KxbMaLVS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUhnCZpKE2DPEEh//Dt0gZgFhg0CqKS9OPgHq0m9bbc=;
	b=KxbMaLVS9y9GboBT2Uh9Ssnh6DTAnYYAZEM8gS1hcOsKfNkaDdXN8F3zjPbZJk+tRs92iv
	MRl5Vpk6+HldLSm0SG1h1imDsdDgAsLuNEh6nxYoAua2DQQ5R9X6409hSGiTE/3fEy6h75
	q42YJThtnI+m7Ubnhp2kHK+mHRHduq0=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 06/12] smb/client: check if ntstatus_to_dos_map is sorted
Date: Wed,  1 Apr 2026 07:29:06 +0000
Message-ID: <20260401072912.355072-7-huiwen.he@linux.dev>
In-Reply-To: <20260401072912.355072-1-huiwen.he@linux.dev>
References: <20260401072912.355072-1-huiwen.he@linux.dev>
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
index fb985d2fc0d9..0a945f9bf8de 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -256,3 +256,35 @@ map_and_check_smb_error(struct TCP_Server_Info *server,
 
 	return rc;
 }
+
+#define DEFINE_CHECK_SORT_FUNC(__array, __field)			\
+static int __array ## _is_sorted(void)					\
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
2.52.0

