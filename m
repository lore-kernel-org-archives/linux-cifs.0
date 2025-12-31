Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F0F2773C1
	for <linux-cifs@vger.kernel.org>; Wed, 31 Dec 2025 13:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767186643; cv=none; b=bmubufv7h2Zi/zx5zowD4Vwd03986n+1rneONeTics43o96KDB9Pv0eSDyRPkN+HoGC1kW1oiG17koN8aYzcOIie2JGeIVPiYI+/aPgt9pg2WXbMY11BwWVHs14gtihysVaRmO5atVdwZoA24n2r5N3GW/qFspeQx+gFfjKAf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767186643; c=relaxed/simple;
	bh=NNWs6ghkFXscbVak6/W0KV3ggIvdFtJTuDh+4xqyTeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmvbSHnfTqQNYomaG6fm71llSP6Rdz1n9yyw1oVL4sNwH4/2ySlEbS6fVpf6vz5DIB3tx2W+2ICcOU8eyH7h91Bu7TPtlrnDTDAd0LslErbe/Ttb+NpP/n99by5JRSFzkDRLFsWuGJw3Wg5uToLEXaN6CDSmv+NDobaIHlLtnoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b/CB6gHD; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b/CB6gHD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767186638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iB0AUif6v10k2JKSToll4C37E0LJoqTkkT/EcwmvVFA=;
	b=b/CB6gHDsB+i2dQCqm/OcBJB1ZKbdJLxdl5AkLMXnwjaIGwvlXsyT8E4F6UUSFEHzgZCWS
	TtItkEk4qkBaD49yTJO3vb1j6WZtcB9GkD54r2PT5sEbx78YODxah8Fymapiu1V16Yl3OQ
	Oj6zC5P4Dd2gAhRmslPCRcxp6lPEz54=
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
Subject: [PATCH v7 3/5] smb/client: check whether smb2_error_map_table is sorted in ascending order
Date: Wed, 31 Dec 2025 21:09:16 +0800
Message-ID: <20251231130918.1168557-4-chenxiaosong.chenxiaosong@linux.dev>
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

Although the array is sorted at build time, verify the ordering again
when cifs.ko is loaded to avoid potential regressions introduced by
future script changes.

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c       |  5 +++++
 fs/smb/client/smb2maperror.c | 17 +++++++++++++++++
 fs/smb/client/smb2proto.h    |  1 +
 3 files changed, 23 insertions(+)

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
index 42fec9abeac7..c36cfe707bf1 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -75,3 +75,20 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 		smb_EIO1(smb_eio_trace_smb2_received_error, le32_to_cpu(smb2err));
 	return rc;
 }
+
+int __init smb2_init_maperror(void)
+{
+	unsigned int i;
+
+	/* Check whether the array is sorted in ascending order */
+	for (i = 1; i < ARRAY_SIZE(smb2_error_map_table); i++) {
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
index 063c9f83bbcd..cbaecbf4c205 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -23,6 +23,7 @@ struct smb_rqst;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
+int smb2_init_maperror(void);
 extern int smb2_check_message(char *buf, unsigned int pdu_len, unsigned int length,
 			      struct TCP_Server_Info *server);
 extern unsigned int smb2_calc_size(void *buf);
-- 
2.43.0

