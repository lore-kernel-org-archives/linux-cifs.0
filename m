Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109281DFDA1
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426479; cv=none; b=Znj3kY+lbL+zK6xG0OIHKxGpUpCRN4bGAc61lZWPEhE5bsRqijy1RIcBhep8q5zoS3Ie6ssvWdr2CJc1075vGC4cQ3J1joCLPXm1vQIA8P7XZpbnrbir2X5oublGrkpM1LEyjJxAd70dsc7aZYugHyo+Ys8CnKUmmP5nHf6lQAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426479; c=relaxed/simple;
	bh=5IMVy24+l6yn6QhpNLwcgEJtk2PtES/mK4kXXRSryxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyO2+3bqWcPJGedfel2oW7DssXhy8DYlQ5ZS5wdc6EupC4g5bPuLtsg75EKn2Q7IeW0NHUeArlx0Y+HZR5EKtgDn2eJEH3HxMirJtZwdd/kp22bc45QryeL7Bf3CxUa/c2qYKtn6IqzESdMt701s48PYXg5UaUCKPydzmx+Qzy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T4t4Shxs; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T4t4Shxs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760426475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sMNPglpdgoGB8wQfeguwrRs8YhYyT3Z1NJvOmvtHP14=;
	b=T4t4ShxsSR3ZAMPO7LS+6C29t9Gwm2Bthlqb6xXZY3oR9ug47x3C8gIVouh8+0a4TnSU15
	wRnsAaMSZNTU8JV51svL+bt/5oa9Jtdm4re2hwqN/PEWKMEmmXhKBgiye6z5hju6dFkRId
	9cTJzdhu4TiQSMqLykRNEZkrP33QB3Y=
From: chenxiaosong.chenxiaosong@linux.dev
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	christophe.jaillet@wanadoo.fr,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 05/22] smb: move get_rfc1002_len() to common/cifsglob.h
Date: Tue, 14 Oct 2025 15:19:00 +0800
Message-ID: <20251014071917.3004573-6-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Rename get_rfc1002_length() to get_rfc1002_len(), then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/cifsglob.h      | 6 ------
 fs/smb/client/cifssmb.c       | 6 +++---
 fs/smb/client/cifstransport.c | 8 ++++----
 fs/smb/client/connect.c       | 2 +-
 fs/smb/common/cifsglob.h      | 5 +++++
 fs/smb/server/smb_common.h    | 5 -----
 6 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 88a428e3903a..81f77eb9a01e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -675,12 +675,6 @@ struct cifs_mnt_data {
 	int flags;
 };
 
-static inline unsigned int
-get_rfc1002_length(void *buf)
-{
-	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
-}
-
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2881efcbe09a..9a346d67e298 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -614,7 +614,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 
 	iov[0].iov_len = 4;
 	iov[0].iov_base = smb;
-	iov[1].iov_len = get_rfc1002_length(smb);
+	iov[1].iov_len = get_rfc1002_len(smb);
 	iov[1].iov_base = (char *)smb + 4;
 
 	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback, NULL,
@@ -1435,7 +1435,7 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 	rdata->iov[0].iov_base = smb;
 	rdata->iov[0].iov_len = 4;
 	rdata->iov[1].iov_base = (char *)smb + 4;
-	rdata->iov[1].iov_len = get_rfc1002_length(smb);
+	rdata->iov[1].iov_len = get_rfc1002_len(smb);
 
 	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
 			     cifs_readv_callback, NULL, rdata, 0, NULL);
@@ -1800,7 +1800,7 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 	/* 4 for RFC1001 length + 1 for BCC */
 	iov[0].iov_len = 4;
 	iov[0].iov_base = smb;
-	iov[1].iov_len = get_rfc1002_length(smb) + 1;
+	iov[1].iov_len = get_rfc1002_len(smb) + 1;
 	iov[1].iov_base = (char *)smb + 4;
 
 	rqst.rq_iov = iov;
diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
index e98b95eff8c9..4c4f5befb6d3 100644
--- a/fs/smb/client/cifstransport.c
+++ b/fs/smb/client/cifstransport.c
@@ -165,7 +165,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 	int resp_buf_type;
 
 	iov[0].iov_base = in_buf;
-	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
+	iov[0].iov_len = get_rfc1002_len(in_buf) + 4;
 	flags |= CIFS_NO_RSP_BUF;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_dbg(NOISY, "SendRcvNoRsp flags %d rc %d\n", flags, rc);
@@ -177,7 +177,7 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = get_rfc1002_length(mid->resp_buf) + 4;
+	unsigned int len = get_rfc1002_len(mid->resp_buf) + 4;
 
 	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
@@ -370,7 +370,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	*pbytes_returned = get_rfc1002_length(midQ->resp_buf);
+	*pbytes_returned = get_rfc1002_len(midQ->resp_buf);
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
@@ -554,7 +554,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	*pbytes_returned = get_rfc1002_length(midQ->resp_buf);
+	*pbytes_returned = get_rfc1002_len(midQ->resp_buf);
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dd12f3eb61dc..22f37ae7a66a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1299,7 +1299,7 @@ cifs_demultiplex_thread(void *p)
 		 * The right amount was read from socket - 4 bytes,
 		 * so we can now interpret the length field.
 		 */
-		pdu_length = get_rfc1002_length(buf);
+		pdu_length = get_rfc1002_len(buf);
 
 		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/cifsglob.h
index eda5e666a761..371160fec1cd 100644
--- a/fs/smb/common/cifsglob.h
+++ b/fs/smb/common/cifsglob.h
@@ -40,6 +40,11 @@ struct smb_version_values {
 	size_t		create_posix_size;
 };
 
+static inline unsigned int get_rfc1002_len(void *buf)
+{
+	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
+}
+
 static inline void inc_rfc1001_len(void *buf, int count)
 {
 	be32_add_cpu((__be32 *)buf, count);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index dac783b46545..9c0db206624b 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -423,9 +423,4 @@ unsigned int ksmbd_server_side_copy_max_chunk_size(void);
 unsigned int ksmbd_server_side_copy_max_total_size(void);
 bool is_asterisk(char *p);
 __le32 smb_map_generic_desired_access(__le32 daccess);
-
-static inline unsigned int get_rfc1002_len(void *buf)
-{
-	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
-}
 #endif /* __SMB_COMMON_H__ */
-- 
2.43.0

