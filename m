Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642972D248D;
	Sun, 12 Oct 2025 16:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285972; cv=none; b=jxHuIG0/3PoQyZV+lw7DxkxIpq0vY4xe/YwUIJTLXgbQO6C1Z1pGY9e/x6/72pOJfLKPNdD4VGpLdt+LGsA7DUZ8Ott12XDAJ1EhepcnR6f2q8Ewr+8l+igCE+16g5iXvgMRMVy89C8Pe432lSz+MXJn/9iuuBhn9f8LjGv+SYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285972; c=relaxed/simple;
	bh=5IMVy24+l6yn6QhpNLwcgEJtk2PtES/mK4kXXRSryxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0koCfYpkVFzqi4iwh84mQQPfH5rLA8a7gluRNvPkNgVJ/2doP3qQM1WX4xrSeAjNeDx0ZzfCCQ7Ctrd4n2Ej6LAC0W6qkyBxiPTpHiZx3WHE0lYP60X5UahOCCWbWNQgl0CJorKR2iK0EY0pe2Gd8COAusvLEofIHBgH8Erhfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285903t1fc4f44f
X-QQ-Originating-IP: umaOsC16BBfxQUm5u2FVaiAr2fyegtrcWzBtt0jEarM=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:22 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1845786713367488962
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
Subject: [PATCH v2 05/22] smb: move get_rfc1002_len() to common/cifsglob.h
Date: Mon, 13 Oct 2025 00:17:32 +0800
Message-ID: <264D015A28B88B5E+20251012161749.2994033-6-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: ND1mcvCvQRzZH5zgRsMpE8wSYanijexAHaR+21docniaQZ0PZNp8SYxC
	6xZOx7Us4Xf/3bqlPYhRE1ikPQ1bd4Ivx1gipPWTHcOrypmiijdJLVaH1Nb3UP9rGiefSvN
	ZovO7WPHOZ6D3pEh6GhcOMRhC/lpg5RJ1/2nnDFJg0SlITZYfd5dHmLM+XMkrXf+Ak7Sowr
	ntd97Gb3ibF5QBB5mPpF6UulyjdBSTMYqfxav/D/DplGX1mWgkxUCctPqmBviqrDEJwnCb1
	KxGMPheUnZL3O0rMyEU3Y3aNvJHAK4xiWZONzXw/DaVc28L8M8V6QnTbXhqJ7z9HeF1eOMY
	+TF/MHxP0TKiGQje/b/4cdxSOZAX90MRuRAoqEYwdKfzW38/InqT94AyQSUqzEHJWAJT/Z/
	pJWVPdUBri1SpQPnKWCp+NRypAmWa2icTWzhTNuR2EnVP0mXvnXCOTTEMf0RoCqlhimgOXg
	k7ilPXsX1iKlV6iGhqtFT7Ifwg+wSkhUWX6984cXUWJBboCxwVKWvH/DiE+OnlLEQ7I6Kfe
	eT9Jhkva28eLIMRErXnk4Q0HwcXLcYojDcLs+KfMPuvJfYzeZqdwESJScHP2a3F20XFWYS7
	rKAoMCkhKDj7K89jX4BufAJsqgFikFzYHZK01cq4uC2a5y56XfxXJDuFJYPFFzTbgs4Et+o
	HumpfUlL8Jtof9m9GkTlLTWWv4naSLH8eoVK0nYNGmJSPy4c6YT4vbW0KBqKuAZHj0BGnL6
	4DMThAJOGgF/kR4TOsXfwBWyKzeNVX4G8vDYcUy9y+Xg06CtlkZcQpzwXHKa6bHU4f9dY+S
	YTXP4U0mqEnQ8stIThWFPLNdqX/spLNYPz2mcnpYnUqaagGsXbb6Dykj26s2hAt1ZaqiWsJ
	ehCWN5bsnSqtywfZi6lZ103ii/xLNbMJ65QUEX6dKfYyLuim7hciGZ4NA3jkTkbkYblPVh4
	c6idAkK+I69gjh5EKYHnx5sec2X5A1NF642h2cuQOG9JFPbsPl48B8Zb6Gsis/kRM8jUiYE
	Hh8wRLtIHcCsNVzN8a549sp00cIbBaL+WcSMhstnbBofT7XP6hiQQ64/IqKgE=
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
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

