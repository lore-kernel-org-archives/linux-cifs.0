Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E2D36E47A
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 07:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783926730; cv=none; b=C29nnHTGro45rdzWtyXHNWehKUXrjlD1K32rk6JqPe/kSAqmrRWOWRLbatmaS1P+93hesxtIUlehPuDCN1pfZGTyHReDLE19xQ4EdFCHANpAER2coMBWvQFYrh47x6iKYRWHErn3614jRKqRjJpJbkE1fnvBl96JycDYG6RR7oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783926730; c=relaxed/simple;
	bh=lcT477c2XzOESg10n6ywFtHr8k7NG3Bt2tdCLso1iK4=;
	h=To:Cc:Subject:Date:From:Content-Type:Message-Id:Mime-Version:
	 References:In-Reply-To; b=RjHtMnRn9f5yF6oExkg6c9WUSUsL4l+R1jaGK81JVpFkBdDVQRaWwRYzW+ctUSEIR1Cz+tfj3Bg9WTnLoBkMnFFyKsci0LLF+WA/3ZLfFDTLyW16wT16KUdHT2BSZDHx/OMnItC0rHpWjAzneGfSGXfzG0omcFxNmg6ocsroPWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=LFRqK08+; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="LFRqK08+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783926722;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=a59FzSWI0PTjOIY9Ww6ZlQcf4iDu4ztOfrph6pTbz6g=;
 b=LFRqK08+IfTg/HUkP18NL/Rl6qQoyBV/3D502MPQmN2BeDI/nuhlzihkzMuHTiechJ+ocV
 imT5/r8o84ALehc54Ej/mjw6q3t5QUQvKg9LHyfeAFJmE/2H6h977ofMzuzDpIPM7Nkj8+
 +0ECTTohsHHtWGXYpLoX7+BQrhDbs4uRPa/wO86x6rxU2FrRB4Kh/XwRvWcDXK8dkA7fgx
 mOHDr9obA55CY5lOXmrKlsC7gcvggnS56vK4KypDm0Csdj3F189bzFCn2ilf5jv+6t6O8X
 KBi1pfc9KlCjGrwEtQw/Z933yeQp2FoCPUqMdAJ8nSn+mOG1AY8Sf6aRNr6X8w==
To: <linux-cifs@vger.kernel.org>
Cc: <linkinjeon@kernel.org>, <smfrench@gmail.com>, 
	<senozhatsky@chromium.org>, <tom@talpey.com>, 
	<linux-kernel@vger.kernel.org>, "Wang Zhaolong" <wangzhaolong@fnnas.com>
Subject: [RFC 1/3] ksmbd: add read payload infrastructure
Date: Mon, 13 Jul 2026 15:11:38 +0800
X-Lms-Return-Path: <lba+26a548fc0+17f062+vger.kernel.org+wangzhaolong@fnnas.com>
From: "wang zhaolong" <wangzhaolong@fnnas.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Received: from localhost.localdomain ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 15:11:59 +0800
Message-Id: <20260713071141.3909087-2-wangzhaolong@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.3
References: <20260713071141.3909087-1-wangzhaolong@fnnas.com>
In-Reply-To: <20260713071141.3909087-1-wangzhaolong@fnnas.com>
X-Original-From: wang zhaolong <wangzhaolong@fnnas.com>

From: Wang Zhaolong <wangzhaolong@fnnas.com>

ksmbd currently copies SMB READ data into an allocated auxiliary buffer
before sending the response. A splice-based path needs to keep page-backed
file data separate from the SMB header while still accounting for it in the
RFC1002 length.

Add a work-owned READ payload made of bio_vecs and an ownership-transfer
helper for response pinning. Add a transport operation and a TCP
implementation that sends the header followed by the payload with
MSG_SPLICE_PAGES while the connection lock prevents interleaving.

Handle positive short sends and shut down the socket if a partially emitted
PDU fails. The existing READ path remains unchanged until the payload
collector is wired up.

Signed-off-by: Wang Zhaolong <wangzhaolong@fnnas.com>
---
 fs/smb/server/connection.c    | 25 ++++++++++++---
 fs/smb/server/connection.h    |  4 +++
 fs/smb/server/ksmbd_work.c    | 45 +++++++++++++++++++++++++++
 fs/smb/server/ksmbd_work.h    | 12 ++++++++
 fs/smb/server/transport_tcp.c | 58 +++++++++++++++++++++++++++++++++++
 5 files changed, 139 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 9e8fdb39e5a2..97ad736bf87a 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -351,10 +351,12 @@ int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
 }
 
 int ksmbd_conn_write(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
+	unsigned int head_len;
+	unsigned int pdu_len;
 	int sent;
 
 	if (!work->response_buf) {
 		pr_err("NULL response header\n");
 		return -EINVAL;
@@ -364,16 +366,29 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 		return 0;
 
 	if (!work->iov_idx)
 		return -EINVAL;
 
+	pdu_len = get_rfc1002_len(work->iov[0].iov_base) + 4;
 	ksmbd_conn_lock(conn);
-	sent = conn->transport->ops->writev(conn->transport, work->iov,
-			work->iov_cnt,
-			get_rfc1002_len(work->iov[0].iov_base) + 4,
-			work->need_invalidate_rkey,
-			work->remote_key);
+	if (work->read_payload) {
+		if (WARN_ON_ONCE(work->read_payload->len > pdu_len)) {
+			sent = -EINVAL;
+		} else if (WARN_ON_ONCE(!conn->transport->ops->write_read_payload)) {
+			sent = -EOPNOTSUPP;
+		} else {
+			head_len = pdu_len - work->read_payload->len;
+			sent = conn->transport->ops->write_read_payload(conn->transport,
+					work->iov, work->iov_cnt, head_len,
+					work->read_payload);
+		}
+	} else {
+		sent = conn->transport->ops->writev(conn->transport, work->iov,
+				work->iov_cnt, pdu_len,
+				work->need_invalidate_rkey,
+				work->remote_key);
+	}
 	ksmbd_conn_unlock(conn);
 
 	if (sent < 0) {
 		pr_err("Failed to send message: %d\n", sent);
 		return sent;
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index ec75633b7da0..a44e382138a7 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -138,10 +138,14 @@ struct ksmbd_transport_ops {
 	int (*read)(struct ksmbd_transport *t, char *buf,
 		    unsigned int size, int max_retries);
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
+	int (*write_read_payload)(struct ksmbd_transport *t,
+				  struct kvec *iovs, int niov,
+				  unsigned int head_len,
+				  struct ksmbd_read_payload *payload);
 	int (*rdma_read)(struct ksmbd_transport *t,
 			 void *buf, unsigned int len,
 			 struct smbdirect_buffer_descriptor_v1 *desc,
 			 unsigned int desc_len);
 	int (*rdma_write)(struct ksmbd_transport *t,
diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index e2c2f45264be..05361f6aa8fb 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *   Copyright (C) 2019 Samsung Electronics Co., Ltd.
  */
 
+#include <linux/bvec.h>
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
@@ -14,10 +15,23 @@
 #include "mgmt/ksmbd_ida.h"
 
 static struct kmem_cache *work_cache;
 static struct workqueue_struct *ksmbd_wq;
 
+void ksmbd_read_payload_release(struct ksmbd_read_payload *payload)
+{
+	unsigned int i;
+
+	if (!payload)
+		return;
+
+	for (i = 0; i < payload->nr_bvecs; i++)
+		put_page(payload->bvec[i].bv_page);
+	kvfree(payload->bvec);
+	kfree(payload);
+}
+
 static int ksmbd_reserve_iov(struct ksmbd_work *work, int need_iov_cnt)
 {
 	struct kvec *new;
 	int new_alloc_cnt = work->iov_alloc_cnt;
 
@@ -74,10 +88,11 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	list_for_each_entry_safe(ar, tmp, &work->aux_read_list, entry) {
 		kvfree(ar->buf);
 		list_del(&ar->entry);
 		kfree(ar);
 	}
+	ksmbd_read_payload_release(work->read_payload);
 
 	kfree(work->tr_buf);
 	kvfree(work->compress_buf);
 	kvfree(work->request_buf);
 	if (work->iov != work->iov_inline)
@@ -179,10 +194,40 @@ int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 			   void *aux_buf, unsigned int aux_size)
 {
 	return __ksmbd_iov_pin_rsp(work, ib, len, aux_buf, aux_size);
 }
 
+/**
+ * ksmbd_iov_pin_rsp_read_payload() - attach a page-backed READ payload
+ * @work: smb work that owns the response
+ * @ib: response header
+ * @len: response header length
+ * @payload: payload whose ownership transfers to @work only on success
+ *
+ * Return: 0 on success, otherwise a negative error with ownership retained by
+ * the caller.
+ */
+int ksmbd_iov_pin_rsp_read_payload(struct ksmbd_work *work, void *ib, int len,
+				   struct ksmbd_read_payload *payload)
+{
+	int ret;
+
+	if (!payload || !payload->bvec || !payload->nr_bvecs || !payload->len)
+		return -EINVAL;
+	if (WARN_ON_ONCE(work->read_payload) ||
+	    WARN_ON_ONCE(payload->len > INT_MAX))
+		return -EINVAL;
+
+	ret = __ksmbd_iov_pin_rsp(work, ib, len, NULL, 0);
+	if (ret)
+		return ret;
+
+	inc_rfc1001_len(work->iov[0].iov_base, payload->len);
+	work->read_payload = payload;
+	return 0;
+}
+
 int allocate_interim_rsp_buf(struct ksmbd_work *work)
 {
 	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE, KSMBD_DEFAULT_GFP);
 	if (!work->response_buf)
 		return -ENOMEM;
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 88104f0cf363..c0e1370e2599 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -10,10 +10,11 @@
 #include <linux/workqueue.h>
 
 struct ksmbd_conn;
 struct ksmbd_session;
 struct ksmbd_tree_connect;
+struct bio_vec;
 
 #define KSMBD_WORK_INLINE_IOVS	4
 
 enum {
 	KSMBD_WORK_ACTIVE = 0,
@@ -24,10 +25,17 @@ enum {
 struct aux_read {
 	void *buf;
 	struct list_head entry;
 };
 
+struct ksmbd_read_payload {
+	struct bio_vec		*bvec;
+	unsigned int		nr_bvecs;
+	unsigned int		nr_alloc;
+	size_t			len;
+};
+
 /* one of these for every pending CIFS request at the connection */
 struct ksmbd_work {
 	/* Server corresponding to this mid */
 	struct ksmbd_conn               *conn;
 	struct ksmbd_session            *sess;
@@ -37,10 +45,11 @@ struct ksmbd_work {
 	void                            *request_buf;
 	/* Response buffer */
 	void                            *response_buf;
 
 	struct list_head		aux_read_list;
+	struct ksmbd_read_payload *read_payload;
 
 	struct kvec			*iov;
 	int				iov_alloc_cnt;
 	int				iov_cnt;
 	int				iov_idx;
@@ -142,8 +151,11 @@ int ksmbd_work_pool_init(void);
 int ksmbd_workqueue_init(void);
 void ksmbd_workqueue_destroy(void);
 bool ksmbd_queue_work(struct ksmbd_work *work);
 int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 			   void *aux_buf, unsigned int aux_size);
+int ksmbd_iov_pin_rsp_read_payload(struct ksmbd_work *work, void *ib, int len,
+				   struct ksmbd_read_payload *payload);
+void ksmbd_read_payload_release(struct ksmbd_read_payload *payload);
 int ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len);
 int allocate_interim_rsp_buf(struct ksmbd_work *work);
 #endif /* __KSMBD_WORK_H__ */
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 13b711ea575d..3095898d74d1 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -425,10 +425,67 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
 	struct msghdr smb_msg = {.msg_flags = MSG_NOSIGNAL};
 
 	return kernel_sendmsg(TCP_TRANS(t)->sock, &smb_msg, iov, nvecs, size);
 }
 
+static int ksmbd_tcp_send_iter(struct socket *sock, struct iov_iter *iter,
+			       unsigned int flags, bool *sent_any)
+{
+	struct msghdr msg = { .msg_flags = MSG_NOSIGNAL | flags };
+	int sent = 0;
+
+	while (iov_iter_count(iter)) {
+		int ret;
+
+		msg.msg_iter = *iter;
+		ret = sock_sendmsg(sock, &msg);
+		if (ret <= 0)
+			return ret ?: -EPIPE;
+		*sent_any = true;
+		iov_iter_advance(iter, ret);
+		sent += ret;
+	}
+	return sent;
+}
+
+static int ksmbd_tcp_write_read_payload(struct ksmbd_transport *t,
+					struct kvec *iov, int nvecs,
+					unsigned int head_len,
+					struct ksmbd_read_payload *payload)
+{
+	struct tcp_transport *tcp = TCP_TRANS(t);
+	struct iov_iter iter;
+	bool sent_any = false;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < payload->nr_bvecs; i++) {
+		if (!sendpages_ok(payload->bvec[i].bv_page,
+				  payload->bvec[i].bv_len,
+				  payload->bvec[i].bv_offset))
+			return -EOPNOTSUPP;
+	}
+
+	iov_iter_kvec(&iter, ITER_SOURCE, iov, nvecs, head_len);
+	ret = ksmbd_tcp_send_iter(tcp->sock, &iter, MSG_MORE, &sent_any);
+	if (ret < 0)
+		goto out;
+	iov_iter_bvec(&iter, ITER_SOURCE, payload->bvec, payload->nr_bvecs,
+		      payload->len);
+	ret = ksmbd_tcp_send_iter(tcp->sock, &iter, MSG_SPLICE_PAGES,
+				  &sent_any);
+	if (ret >= 0)
+		return head_len + ret;
+out:
+	/* A partially emitted RFC1002 PDU makes this TCP stream unusable. */
+	if (sent_any) {
+		ksmbd_conn_set_exiting(t->conn);
+		kernel_sock_shutdown(tcp->sock, SHUT_RDWR);
+	}
+	return ret;
+}
+
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 {
 	free_transport(TCP_TRANS(t));
 	if (server_conf.max_connections)
 		atomic_dec(&active_num_conn);
@@ -677,8 +734,9 @@ int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
 }
 
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
+	.write_read_payload = ksmbd_tcp_write_read_payload,
 	.disconnect	= ksmbd_tcp_disconnect,
 	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.47.3
