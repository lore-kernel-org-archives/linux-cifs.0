Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.208
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661169;
	b=WE33tGL1D9O3jYaVLeWQb/QVD6nIGmXrpyTWnk/h8Gl40sMexhX4GBC2ziV/9ofbbgZn
	 kdM1gX6sA55OiWKn0yNs9dxlcFviCL5YBc2pxTsdVMIQGQ1ucRBhBwYKnuecu8iMzvb6v
	 b/UuD2Zw+1o2X/qoGkx8C5yjoTSBx51wT6m4bU1D3LCLna6EqIppRLqCoJk1nepXA6iol
	 x+ysjixc9+MO6tcbxUG20ZRiW2l86lGGT0lG7oIuWpNztTZ5CI2qrqpppiDZoKLD6DttV
	 JRJvCyFGCjrjvq7IdzWGctV08Zj/3B4J+69o02TV7kAWEh4SrVAQW5JBJAP6PwclbaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661169;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RYR5bqmGgFakZS61p+XnWG8J6UlCyx1aSPA7g9a7FcI=;
	b=NTtRN/407n2xgMU5h5iDpe3TwZp39zXPWY3/vLd013um3RFcgKHoDR3b+Yi25Q5Wpq4K
	 I7krHYFKIuTXWqzr9puBL2aTsLs1YKvpCIMW4iniin6JuPIRMoDb8/eiCLlhHseo8+dNr
	 ExDFbZzdKQvM6AgOQrcOdUbuSUPtAK08q4wTxIwTjLK2WY1ZTTmupG+5/7R2Ih70L5qPk
	 PVXa+AHsAL9ZivUXNLrlKt+BwsQswszDK/S0uBwdVYlDT/wuSSbqnyZ96bqXAF3FzJfuh
	 ZHtxLmk1vE0V0FpE/0lw/hbw4+KdZagWaM/9mPHWICZBZt1mRDYyYNZPtj0VMbivK2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SSnUfoIO;
	arc=none smtp.remote-ip=91.218.175.208
Received: from mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202D6606A31D
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 09:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 202D6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SSnUfoIO
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IFZw6AYX/YiNO5CfFcNnEfZjwNsawdEWiJtgLDk9jwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792661165; v=1; x=1793265965;
 b=SSnUfoIOoSXN2ySTlOGmZOSGt7Q95HS4J5ZkrGUxmu5v6UzAbvt8+3MPNvC0RKxhL1oK1KAE
 hLJsvNy5K73tu3pKSsd8ImlE8i1YaS5srhOGCh54qsnFV11gxH7QCjh9W8R6c9nvJEVwEDFpKHk
 HnfiXa5qBEuUdrU1I/zlybvM=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id be996a28e414fce4;
	Thu, 22 Oct 2026 09:26:05 +0000
X-Mizu-Trace-ID: be996a28e414fce4
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	tj@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/4] ksmbd: route WRITE requests to an unbound workqueue
Date: Thu, 22 Oct 2026 17:25:12 +0800
Message-ID: <20261022092514.2590010-3-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022092514.2590010-1-huiwen.he@linux.dev>
References: <20261022092514.2590010-1-huiwen.he@linux.dev>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

WRITE requests from one connection can accumulate on a busy per-CPU
pool, limiting throughput even when other CPUs are available.

Route eligible single-channel WRITEs to a CPU-scoped, non-strict
unbound workqueue, while retaining per-CPU execution for other requests.

Tested with fio on a 128-CPU server with a local 4-vCPU client VM
(tmpfs, 16 jobs, QD32 per job, libaio, direct=0, cache=none;
mixed=50/50 R/W). Throughput (MiB/s) and paired changes are medians
of four runs.

A: write_wq=0; B: write_wq=1.

  Block  Ch  Workload      A MiB/s    B MiB/s  B/A change
  -----  --  ---------  ---------  ---------  ----------
  4KiB    1  READ          292.64     290.73      -0.71%
  4KiB    1  WRITE         219.55     193.01     -12.03%
  4KiB    1  mixed         236.85     238.67      +0.46%
  4KiB    2  READ          401.12     404.46      +2.12%
  4KiB    2  WRITE         325.75     334.67      +4.22%
  4KiB    2  mixed         345.04     338.24      -2.46%
  4KiB    4  READ          463.80     453.28      -1.41%
  4KiB    4  WRITE         415.65     415.69      -0.14%
  4KiB    4  mixed         397.76     396.75      -1.35%
  64KiB   1  READ         2152.98    2162.74      +4.12%
  64KiB   1  WRITE        1808.18    1976.37      +9.34%
  64KiB   1  mixed        1961.47    1974.08      +0.53%
  64KiB   2  READ         3345.74    3246.35      -2.93%
  64KiB   2  WRITE        3223.25    3222.85      -0.14%
  64KiB   2  mixed        3285.02    3283.75      +0.36%
  64KiB   4  READ         4213.09    4227.13      +0.34%
  64KiB   4  WRITE        3016.62    3089.17      +1.82%
  64KiB   4  mixed        3950.03    3877.03      -2.00%
  1MiB    1  READ         2142.63    2126.23      -0.99%
  1MiB    1  WRITE        2184.30    3452.84     +58.30%
  1MiB    1  mixed        2827.65    2961.50      +5.88%
  1MiB    2  READ         3960.96    3887.33      -1.99%
  1MiB    2  WRITE        4063.92    4158.22      +2.37%
  1MiB    2  mixed        4613.54    4631.33      +0.39%
  1MiB    4  READ         6750.79    6707.91      -1.49%
  1MiB    4  WRITE        3566.57    3557.26      +0.64%
  1MiB    4  mixed        5471.26    5444.00      +0.42%

Mixed workloads show no consistent gain: interleaved READs keep later
WRITEs per-CPU until the connection becomes idle.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 fs/smb/server/connection.h    |  4 ++
 fs/smb/server/ksmbd_work.c    | 53 ++++++++++++++++++++++++
 fs/smb/server/ksmbd_work.h    |  2 +
 fs/smb/server/server.c        | 77 ++++++++++++++++++++++++++++++++++-
 fs/smb/server/smb2pdu.c       |  6 +++
 fs/smb/server/transport_tcp.c |  5 +++
 fs/smb/server/transport_tcp.h |  1 +
 7 files changed, 147 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 63484c8efbbd..a92e0fea0f06 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -59,6 +59,10 @@ struct ksmbd_conn {
 	struct smb_version_cmds		*cmds;
 	unsigned int			max_cmds;
 	struct mutex			srv_mutex;
+	/* RX-only: keep WRITEs per-CPU until idle is observed. */
+	bool				write_wq_blocked;
+	/* Sticky across channel removal; accessed with READ/WRITE_ONCE. */
+	bool				multichannel_seen;
 	int				status;
 	unsigned int			cli_cap;
 	bool				stop_called;
diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index d307aefe0aec..e1b87bc0c949 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/module.h>
 
 #include "server.h"
 #include "connection.h"
@@ -17,6 +18,23 @@
 static struct kmem_cache *work_cache;
 static struct workqueue_struct *ksmbd_wq;
 
+/* Load-time switch for the WRITE request routing policy. */
+bool ksmbd_write_wq_enabled;
+module_param_named(write_wq, ksmbd_write_wq_enabled, bool, 0444);
+MODULE_PARM_DESC(write_wq,
+		 "Route eligible WRITEs to an unbound workqueue; load-time only");
+
+static struct workqueue_struct *ksmbd_write_wq;
+
+/* Only the sole receiver calls this for newly admitted requests. */
+bool ksmbd_queue_request(struct ksmbd_work *work, bool use_write_wq)
+{
+	struct workqueue_struct *wq = use_write_wq ? ksmbd_write_wq : ksmbd_wq;
+
+	/* No work/conn access after publication: the consumer may free both. */
+	return queue_work(wq, &work->work);
+}
+
 static int ksmbd_reserve_iov(struct ksmbd_work *work, int need_iov_cnt)
 {
 	struct kvec *new;
@@ -110,14 +128,49 @@ int ksmbd_work_pool_init(void)
 
 int ksmbd_workqueue_init(void)
 {
+	struct workqueue_attrs *attrs;
+	int ret = -ENOMEM;
+
 	ksmbd_wq = alloc_workqueue("ksmbd-io", WQ_PERCPU, 0);
 	if (!ksmbd_wq)
 		return -ENOMEM;
+	if (!ksmbd_write_wq_enabled)
+		return 0;
+
+	ksmbd_write_wq = alloc_workqueue("ksmbd-write", WQ_UNBOUND, 0);
+	if (!ksmbd_write_wq)
+		goto destroy_io_wq;
+	attrs = alloc_workqueue_attrs();
+	if (!attrs)
+		goto destroy_write_wq;
+	attrs->affn_scope = WQ_AFFN_CPU;
+	attrs->affn_strict = false;
+	ret = apply_workqueue_attrs(ksmbd_write_wq, attrs);
+	free_workqueue_attrs(attrs);
+	if (ret)
+		goto destroy_write_wq;
+
+	/* Set the initial policy before exposing writable sysfs attributes. */
+	ret = workqueue_sysfs_register(ksmbd_write_wq);
+	if (ret)
+		goto destroy_write_wq;
 	return 0;
+
+destroy_write_wq:
+	destroy_workqueue(ksmbd_write_wq);
+	ksmbd_write_wq = NULL;
+destroy_io_wq:
+	destroy_workqueue(ksmbd_wq);
+	ksmbd_wq = NULL;
+	return ret;
 }
 
 void ksmbd_workqueue_destroy(void)
 {
+	if (ksmbd_write_wq) {
+		destroy_workqueue(ksmbd_write_wq);
+		ksmbd_write_wq = NULL;
+	}
 	destroy_workqueue(ksmbd_wq);
 	ksmbd_wq = NULL;
 }
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 0844aa929f55..9f87b6c4393a 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -156,6 +156,8 @@ int ksmbd_work_pool_init(void);
 int ksmbd_workqueue_init(void);
 void ksmbd_workqueue_destroy(void);
 bool ksmbd_queue_work(struct ksmbd_work *work);
+extern bool ksmbd_write_wq_enabled;
+bool ksmbd_queue_request(struct ksmbd_work *work, bool use_write_wq);
 int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 			   void *aux_buf, unsigned int aux_size);
 int ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0069d4e6a60a..5347eba916ed 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -12,6 +12,7 @@
 #include <linux/sysfs.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/unaligned.h>
 
 #include "server.h"
 #include "smb_common.h"
@@ -19,6 +20,7 @@
 #include "../common/smb2status.h"
 #include "connection.h"
 #include "transport_ipc.h"
+#include "transport_tcp.h"
 #include "mgmt/user_session.h"
 #include "crypto_ctx.h"
 #include "auth.h"
@@ -372,6 +374,79 @@ static void handle_ksmbd_work(struct work_struct *wk)
 	ksmbd_conn_r_count_dec(conn);
 }
 
+enum ksmbd_wq_class {
+	KSMBD_WQ_LOCAL,
+	KSMBD_WQ_WRITE,
+	KSMBD_WQ_BLOCK_WRITE,
+};
+
+/*
+ * Classify a complete RFC1002-framed request for workqueue placement only.
+ * Check bounds before inspecting fields; leave protocol validation to the worker.
+ */
+static enum ksmbd_wq_class ksmbd_smb2_wq_classify(void *buf)
+{
+	const struct smb2_hdr *hdr = smb_get_msg(buf);
+	const struct smb2_write_req *req = (const void *)hdr;
+	unsigned int len = get_rfc1002_len(buf);
+
+	if (len < sizeof(*hdr) || hdr->ProtocolId != SMB2_PROTO_NUMBER ||
+	    hdr->NextCommand ||
+	    (hdr->Flags & (SMB2_FLAGS_SERVER_TO_REDIR | SMB2_FLAGS_ASYNC_COMMAND |
+			   SMB2_FLAGS_RELATED_OPERATIONS | SMB2_FLAGS_SIGNED)))
+		return KSMBD_WQ_BLOCK_WRITE;
+
+	switch (get_unaligned_le16(&hdr->Command)) {
+	case SMB2_WRITE_HE:
+		if (len < sizeof(*req) || !req->Length ||
+		    req->Channel != SMB2_CHANNEL_NONE || req->Flags)
+			return KSMBD_WQ_BLOCK_WRITE;
+		return KSMBD_WQ_WRITE;
+	case SMB2_NEGOTIATE_HE:
+	case SMB2_SESSION_SETUP_HE:
+	case SMB2_LOGOFF_HE:
+	case SMB2_TREE_CONNECT_HE:
+	case SMB2_TREE_DISCONNECT_HE:
+	case SMB2_CREATE_HE:
+	case SMB2_CLOSE_HE:
+	case SMB2_FLUSH_HE:
+	case SMB2_CANCEL_HE:
+	case SMB2_ECHO_HE:
+	case SMB2_QUERY_INFO_HE:
+	case SMB2_SET_INFO_HE:
+		/* Keep these commands per-CPU without blocking the WRITE queue. */
+		return KSMBD_WQ_LOCAL;
+	default:
+		/* READ and unclassified traffic also keep later WRITEs per-CPU. */
+		return KSMBD_WQ_BLOCK_WRITE;
+	}
+}
+
+/*
+ * RX-only placement policy. The current request already holds r_count.
+ * READ or unclassified traffic keeps later WRITEs per-CPU until RX
+ * observes r_count == 1. This does not drain or move work already queued.
+ * Extra oplock/notify references can delay rearming, never hasten it.
+ */
+static bool ksmbd_use_write_wq(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+	enum ksmbd_wq_class wq_class = KSMBD_WQ_BLOCK_WRITE;
+
+	if (!ksmbd_write_wq_enabled)
+		return false;
+
+	if (ksmbd_transport_is_tcp(conn->transport))
+		wq_class = ksmbd_smb2_wq_classify(work->request_buf);
+	if (wq_class == KSMBD_WQ_BLOCK_WRITE)
+		conn->write_wq_blocked = true;
+	else if (conn->write_wq_blocked && atomic_read(&conn->r_count) == 1)
+		conn->write_wq_blocked = false;
+
+	return wq_class == KSMBD_WQ_WRITE && !conn->write_wq_blocked &&
+		!READ_ONCE(conn->multichannel_seen);
+}
+
 /**
  * queue_ksmbd_work() - queue a smb request to worker thread queue
  *		for processing smb command and sending response
@@ -403,7 +478,7 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	/* update activity on connection */
 	conn->last_active = jiffies;
 	INIT_WORK(&work->work, handle_ksmbd_work);
-	ksmbd_queue_work(work);
+	ksmbd_queue_request(work, ksmbd_use_write_wq(work));
 	return 0;
 }
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b7ce67094626..54ecdd096bd2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -125,6 +125,12 @@ static int register_session_channel(struct ksmbd_session *sess,
 	if (xa_is_err(old)) {
 		kfree_sensitive(chann);
 		rc = xa_err(old);
+		goto out;
+	}
+	if (ksmbd_write_wq_enabled && count) {
+		/* Remember the extra channel even if binding later fails. */
+		xa_for_each(&sess->ksmbd_chann_list, index, chann)
+			WRITE_ONCE(chann->conn->multichannel_seen, true);
 	}
 out:
 	up_write(&sess->chann_lock);
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 4968cfc1a572..5a2aad35739d 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -719,3 +719,8 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.shutdown	= ksmbd_tcp_shutdown,
 	.free_transport = ksmbd_tcp_free_transport,
 };
+
+bool ksmbd_transport_is_tcp(struct ksmbd_transport *t)
+{
+	return t->ops == &ksmbd_tcp_transport_ops;
+}
diff --git a/fs/smb/server/transport_tcp.h b/fs/smb/server/transport_tcp.h
index 1e51675ee1b2..4095854ee91d 100644
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -9,6 +9,7 @@
 int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
 struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
 void ksmbd_free_transport(struct ksmbd_transport *kt);
+bool ksmbd_transport_is_tcp(struct ksmbd_transport *t);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
 
-- 
2.43.0

