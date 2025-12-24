Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960872877E6
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 02:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766543589; cv=none; b=rcyBm6/AIecCrX5KiKY8JVDJhAfA0sChZlqmiqVRU5+IaU63NuAXoHRKkDMGFcBBfPb1LpM6Y5Vrz7G/RXZgdW7DyPslKor2CZBMHiMejr9z7Il0lZkOTts0XAZR//eh4yECIlLh4pZnUbsVfhNo/Cb/SnDohTrYoQ5UNJ5K8vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766543589; c=relaxed/simple;
	bh=Hdk6vY5vIA4QtbQRoaraahy2pGFx4Ug2AsKAT8i9Md4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLULIOlaChiF3yyFZIzu17urtqyM0GiMO8cct7W3+3bNNrRd7D2S0yMP8VUE0q1vDBY671Jwvqu8J0JXcbPY/sSx2fj2e1eqBHx2qbeR4z/rDq9n7cx1dQUONgGkmBbOmPR5f4tiEz9SFdmnVNKH6t5iKEzHKMAp8Hj3N0Wr9Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=veRN6C5V; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="veRN6C5V"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766543582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ax6yydEznHWcK83ziKqbtA/oLWpxTg6hwcumxazEyhE=;
	b=veRN6C5VbIy5Gc4wr3UqoROWqMSBT5asc3KVDdhLQufie1t23KQAQzEdylK03zNSRAD0uz
	FWmFAslZIm1FqcSoIFUtSbcFkheuRVwyIBBkev7VUGUbnHocd3OVwDAJpLQCw2NhjGaC4x
	ho2tO2R3Zze2QAu0dA+rO/BNRzXWX2A=
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
Subject: [PATCH v5 3/5] smb/client: check whether smb2_error_map_table is sorted in ascending order
Date: Wed, 24 Dec 2025 10:31:42 +0800
Message-ID: <20251224023145.608165-4-chenxiaosong.chenxiaosong@linux.dev>
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

Although the array is sorted at build time, verify the ordering again
when cifs.ko is loaded to avoid potential regressions introduced by
future script changes.

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c       |  5 +++++
 fs/smb/client/smb2maperror.c | 19 +++++++++++++++++++
 fs/smb/client/smb2proto.h    |  1 +
 3 files changed, 25 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index d9664634144d..b6646672799f 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1907,6 +1907,11 @@ static int __init
 init_cifs(void)
 {
 	int rc = 0;
+
+	rc = smb2_init_maperror();
+	if (rc)
+		return rc;
+
 	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
 /*
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 573d74cd510d..d96448cacf0a 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -27,6 +27,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 #include "smb2_mapping_table.c"
 };
 
+static unsigned int err_map_num = ARRAY_SIZE(smb2_error_map_table);
+
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
@@ -72,3 +74,20 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 		smb_EIO1(smb_eio_trace_smb2_received_error, le32_to_cpu(smb2err));
 	return rc;
 }
+
+int smb2_init_maperror(void)
+{
+	unsigned int i;
+
+	/* Check whether the array is sorted in ascending order */
+	for (i = 1; i < err_map_num; i++) {
+		if (smb2_error_map_table[i].smb2_status >=
+		    smb2_error_map_table[i - 1].smb2_status)
+			continue;
+
+		pr_err("smb2_error_map_table array order is incorrect\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 063c9f83bbcd..95f4413aee42 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -23,6 +23,7 @@ struct smb_rqst;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
+extern int smb2_init_maperror(void);
 extern int smb2_check_message(char *buf, unsigned int pdu_len, unsigned int length,
 			      struct TCP_Server_Info *server);
 extern unsigned int smb2_calc_size(void *buf);
-- 
2.43.0

