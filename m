Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3E429993A;
	Sun, 12 Oct 2025 15:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281905; cv=none; b=k0VKtQUZfxGp9blqjmIQQLbXE3iEOhG4zZ4IJoUmY7XAqWPaFPsOLMfX7mpv7EGLJ0221a9YBM4xUBNEWbWu7jD9QVEm9K69ntBdJCJBQ3iC4ubLN/bvwsXd5nDEorGOjMklksalgYaJ5fHViccmQvT4gLiL8M2Vu7H8HHBCUTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281905; c=relaxed/simple;
	bh=5IMVy24+l6yn6QhpNLwcgEJtk2PtES/mK4kXXRSryxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXeDBv0gvxe0lGj0boAk5EkW6wrHoY09XaHBx2j4fnfp7NXMPf783UKCLhS2H1/SVclRwwAdTvNgkj/lUxsCQsI7DpTajrXnTjkl9s6CGbNu0ywLqqc7A16MTs4XK7BAh+p4M1bv2mpGa+HpcRm5lcwzVYgXX4a1L5TSE9wa0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281816tdf100ff1
X-QQ-Originating-IP: rOHEstHfkS/VByKis965aKC0rVjZJhEi90ZN/1D9s4k=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13023201029455085192
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
Subject: [PATCH 05/22] smb: move get_rfc1002_len() to common/cifsglob.h
Date: Sun, 12 Oct 2025 23:08:58 +0800
Message-ID: <469E8D614DA0C5C5+20251012150915.2992220-6-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M44hTGryyoPCFRr6Ms8pJI7d0NYxMLzUrj5fb4YvZbM+YIAIzSrOvmMp
	LGPCvm5seUzVUZmBCUi9YACQLsjQE1MxipmK0jUlj/RrtxhbaYiIoPmuh+tT+JUaaDxzC6W
	CzXKRLqUWkVd+Xpv1hk1uCyXl9T0GIV2xqK2es7ZRJssh8oaBo4/o2hnP0pqPgEx7C2Z2cc
	5wwr7lM8Ehu2UQ/nkivKi+81PHr3gvCGN+LpTB92CGFtQo7zPbeJoZ2OstJJL4g0zTs8WHC
	DqHJUU4zj2s7tg6ICPldDICx1268iO2tBksB8Cg0B3B73Y3MJO++gQSNe5L8wCSsY1MAZCf
	bUKuyQB3Tg2dK+RxzZ8WYP+s7Brp9+cOaylMDp8TSD7bb2fGnThwX07bDnTcAp+N6LFQVnE
	xkF2OYdOp+5FP+FiSc/kJzIj87tswupI9B1h9umC63tDDNNmOSDPxGOd/GmzZAbYiHXm83f
	iDWs15sPm0XqPkh3W5uMrZT7dSibpgv1Hh1jN4s4L4Vi35cpWKkhJEHyx5B43lSaPRHWxc1
	iQOuk7beizizy4Rdqeq1ZwSNjbHLJAZxBMXeBEh2krdr5LLKejCioedd4bc5WwlATBHDkiy
	cdPEkTI1RIOw88i1Qd6whZknEMnMLF74qs4tD99iBEW+vHwWQgAn90j6IcMvEmEkSkzQd5o
	HlhbrgjX9JXUNBwlg8dfKyV9iCecTEXU81DUHGzYizys7rmSIjpHRhjvmK+ZpPTeKEtMgko
	2mWdItLOVIg/+7wOWl6dW/BaaTHY1akDSovBvY0VV0PSblpZHG44eZefkmJJagiNU2HOGRz
	XASnKqW/ZPJDQdF0Lwd/PDIoKOHC9Vzd3iaIKQkW2ljB/PAo2T++sv92TEslL45Qlc12rJZ
	sqUxz3yE2aezcoBKNCMjhT/dztZUtCqMnTZnsgOHqTMIt/zyZM66D2fQee3NMI05mHeqiQx
	MMqS6/1jaldlm9QkBpSePFRd1iFHtRZa1/F0FeM+58RT0O/LOijB4BWnE0vLfdYTMBjLr9E
	VKyR4h0b7FKx6lDhnl7CjEPvywKYNf+72NEqlWnQ==
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

