Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5462EBB9A;
	Sun, 12 Oct 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282656; cv=none; b=i1uUhb7b8Vu/KSeANu20pGyrcO4s40QrroFCW/B21GlG74JmRcVvZzM9LFARt/WCdrBUZavtqmIB5cNnL86QCgUP0tvGMqnqlpb8pkNEwz02Yzw6dXJT1mDxLWgKMC6yesMglP6VY9ZzQaa+cF3mSmAgyKKTCpR4I4Ng4DZhfVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282656; c=relaxed/simple;
	bh=5IMVy24+l6yn6QhpNLwcgEJtk2PtES/mK4kXXRSryxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n815vfTWhhiG/4BSgRYKZX5/o9P8U4v0Z0KAyBtGUKKTM2Ddte+VE6JsQWtijJkeakeRPxZpOKcB0EqrWeJUSl8hRKTpj/1QmEkkhPzk3S1ydgVirhz5TWx/l7REsYPcgLkQ0aDR/qnHe+H6ZzaLwCPlz3p+dMs4pFnKop7akHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282597t6d2e04f9
X-QQ-Originating-IP: /6nZrIqZTTL9/noKQDA3h9hikjc1eWO5ztcDzmIheqE=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:16 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 463370740963289350
From: chenxiaosong@chenxiaosong.com
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
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH RESEND 05/22] smb: move get_rfc1002_len() to common/cifsglob.h
Date: Sun, 12 Oct 2025 23:22:30 +0800
Message-ID: <A15A011B492599D1+20251012152247.2992573-6-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MAu4Ycv3XufafByMU3k5EG89I2X8BQEcOBGhdpXwGAmlkp+N+RT9Mur+
	+/fEPYIG89MIBsLnlsMauXKEKjh8fdc+g0dQiOp9i8UOcvxgQqo8d+6Ck2GtNbRpS7XbuTC
	/crqzduXwf/kWozJb7X1GUF3xh6/HGCJeEwkstlyihzIgeRaCKb5eXPUzhSAjNqbcfA36En
	eUKLo9XYzOfNjzujBeDvpFzr+Vs76sQ8l7MUeOmRZPAMEepyaLC5IV063FGAIhHDlC0nGej
	XG9m0PHN1lMuVLvGg6nV9lzsXjy67+FnRR8B8tEUlcjgG1Mv0ODdCRarOMmT9Tg+sRrri+K
	apfSuTVV36LynutrFlsQA+V0rDSfIwK9utZlUoWIQSNbLkKKYz8JSS8ru5UY9tTu50+aDyN
	KBDST4wGa2UEVvd+GySvnTCLg1da60AHLB0tZ3G+xuqcNDS3O+Qg37Qp2fDwBJ3CCrdiHey
	OO1P/XoEbkc+ZaR7CX6fZnQk9DriL/Ja856oSXKlnTbr9zmoooIFq8gArKZ7mYHqMWrxGdb
	d66WBAK6VD8THfu96U83DGs3fYiSnpQKVXldyOJu6dnh5XTXN6QIUYKWUKk7fegdAzPGkoh
	12OOBVUCR4OleOKEWNiUB+1P76zOtiJlCIgNrIhGi4u2R06TlKk5iK8KVJhQ62wwF+cw9A6
	y+SVb0pNtq5vVAG3s099qQCuy8NXLgy4D3l9BKOZMyUseXLl/ig+SfqNcIWHJTkc+dlZM3V
	nxk25v3Tf+aQMOMszfb/nKsBy3iqZW0FIEdCnrU8XiSK+A8RNw7vtoRCi9i1v86NVQRIYcU
	mVs72wVLNfGuQasp+ju6Sh+mcPL530Niijp+5HOheY71VZ8uweu3zR6rfo2GYiix33eOgGJ
	pdfeFBN7miiFcHlkUwXrYpj72gI6mxkJASn/tqzHGlnb5LrqU1QpkkJlRPUpLfB6t43BupD
	sP78vV9XUHTSxU+SIDxCi4fyVDRXS6P4UmmaYmaW96UpbdC2VS67+cv7pjcHwWHqMwFPXwJ
	lxpTD//8uf5VulLh7SPI5Pp8k2IBr5J/Aoehu7bGvXVvk/aeprAHviA+GmAsLmka7s1Ik+R
	sgUoDiegUiDGlzgygLD0MY=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

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

