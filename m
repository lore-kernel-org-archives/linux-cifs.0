Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DF41F1932
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 02:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783479418; cv=none; b=EuWiDpRt5ozUbGh04h97FzvoVCkze78Ly2ev4uuCMaIeaPGOTrEjrvfn59WnF0gI0iCoMuZhmnG6zW+Qb04ShTjbxIaXViWbmJ6FckSdjWHTvmZuVuhJX1Y09wXFKYtK8svu4MXioxX8DJqZ+13mV22/K0tFk9uxom5Jv5MTEp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783479418; c=relaxed/simple;
	bh=4vgQasOaifXl4ygxUDUchMpUD6VsN2AGERIBtelXD60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5xbfEKXXDbq+kr5NRTJfwOm71r8oAZoxIY2GoTeMg1+aI+gZ77ze2m8FDm4qOpYhFpzwSVVRHPmj8lJ2KOVncc8Ed7aLBRx2Fvmto5KaQ1P/wYo24sZ4Y4zClVSILZJl81obKoFd/FFSp+WdVzAIpn67LbukjR/MtuGk6dBrTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=sBFIpThI; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="sBFIpThI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783479414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=272OOld/E5dmQe35awJvyLWQ3hE4pezDYvXMN5XXvME=;
	b=sBFIpThIU2odnHJXeNvqscUmorp+8j8iNiQy7pCXwkutl26zjWb8aVsn6QO080ePBvF0d1
	igN6V8kFwrexYelUHCqQXogxyECBVacCXgIr7zQtyxvFWc/q19M4eTMeejM2wFVKJN1mYy
	RESTB5tNs3e6KinHUleHrxNAfyhps+oYOiJpRBT0PEFul5eKhe0G15SNHmUUnsKT7WpnUO
	RX3M85+hz3+kg5xI91PM9ebZfxQwuMqT4WxooWYj9qtntgLW2w+s4m878/rCgf5RxKKFfW
	ebI4JApGDNp1KU1ExyPjt3VtckG9cHNdUoi5yGlSvf4ohigzuRqdKgQ9vXDsfQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 3/3] smb/server: use MSG_EOR for async interim response
Date: Wed,  8 Jul 2026 02:56:15 +0000
Message-ID: <20260708025615.145390-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
References: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Two kernel_sendmsg() calls can still use the same TCP skb if the first skb
can take more data. This can happen when ksmbd sends two SMB2 responses
very close to each other.

Without MSG_EOR, TCP can append the next sendmsg data to the previous skb.
Then STATUS_PENDING and the later response can be put into the same TCP
skb. MSG_EOR marks the skb as end of record, so TCP will not collapse the
next sendmsg data into it.

Example:

  smbtorture //${server_ip}/export -U${username}%${password} smb2.compound_async.write_write

  Client request:

    Write Request Len:64 Off:0, File: compound_async_write_write; Write Request Len:64 Off:64

  Before this patch, server responses:

    Write Response, File: compound_async_write_write
    Write Response
      SMB2, STATUS_PENDING, Write Response, MessageId 7
      SMB2, Write Response, MessageId 7

  After this patch:

    Write Response, File: compound_async_write_write
    Write Response, Error: STATUS_PENDING
    Write Response

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c    | 9 +++++++++
 fs/smb/server/connection.h    | 2 ++
 fs/smb/server/smb2pdu.c       | 4 ++--
 fs/smb/server/transport_tcp.c | 2 +-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index d5b35087556e..89746284fd7b 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -392,6 +392,15 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	return __ksmbd_conn_write(work, &write);
 }
 
+int ksmbd_conn_write_eor(struct ksmbd_work *work)
+{
+	struct ksmbd_transport_write write = {
+		.msg_flags = MSG_EOR,
+	};
+
+	return __ksmbd_conn_write(work, &write);
+}
+
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
 			 struct smbdirect_buffer_descriptor_v1 *desc,
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 62df151ca554..fa09d37d5745 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -138,6 +138,7 @@ struct ksmbd_transport_write {
 	int		size;
 	bool		need_invalidate_rkey;
 	unsigned int	remote_key;
+	int		msg_flags;
 };
 
 struct ksmbd_transport_ops {
@@ -182,6 +183,7 @@ int ksmbd_conn_wq_init(void);
 void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
+int ksmbd_conn_write_eor(struct ksmbd_work *work);
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
 			 struct smbdirect_buffer_descriptor_v1 *desc,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 35f8476bbb6d..d644134d50f0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -867,7 +867,7 @@ static void smb2_send_interim_compound_prefix(struct ksmbd_work *work)
 	    work->conn->ops->set_sign_rsp)
 		work->conn->ops->set_sign_rsp(work);
 
-	err = ksmbd_conn_write(work);
+	err = ksmbd_conn_write_eor(work);
 	if (err)
 		ksmbd_debug(SMB, "failed to send compound interim prefix: %d\n",
 			    err);
@@ -908,7 +908,7 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
 
-	ksmbd_conn_write(in_work);
+	ksmbd_conn_write_eor(in_work);
 	ksmbd_free_work_struct(in_work);
 }
 
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 448f24d44b6b..cf81585d6861 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -421,7 +421,7 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 			    const struct ksmbd_transport_write *write)
 {
 	struct msghdr smb_msg = {
-		.msg_flags = MSG_NOSIGNAL,
+		.msg_flags = MSG_NOSIGNAL | write->msg_flags,
 	};
 
 	return kernel_sendmsg(TCP_TRANS(t)->sock, &smb_msg, write->iov,
-- 
2.54.0

