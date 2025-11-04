Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0D829BDBC
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 11:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762255014; cv=none; b=EOj8I2emGi5TtUq2y7qeGshA/Nt2IqJ6eOhHuL2Moybba6diUMUbKLQgbivBJbVFq+69z06o8deOsubXpPN0Ap06yOEXw/5r5pLWQv59QUnq1d5T/kPPgtP0G2NDq65ZZ7TOdLOgpIDwwzooBdShLGajIZ4k9SpRyHkkXiBeQG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762255014; c=relaxed/simple;
	bh=IDGK6rVj6fS2WAahhdnkJwfKFLBRsY0QlYIpi0N4Khw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZrV0c+Gfwh6J3ocjjEuB9Vsti2EvUrWA+D52xt8K+jSXLplPYYP7sBfYfmm6gQRXAHRewHt299tKYsABl9a7o0iignVZqs7/ILzpOetNuiB6lwQ2i/brpXW4h/kyjRsbyxwDIsDJ26nTx41M+qBm5W1i1nAT/pLkz2pU8vZa9lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YX/t7H43; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YX/t7H43"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=qU1tnJ0/MPcxw9b1Y6p1pDscT9rIC7FnI932WdChdbU=; b=YX/t7H43ffN3EBN0KXWtDFKjFU
	+akjcEsE+8/X4TFnLRTx4Nf3ssZuHSkbClOB0hN20YjnuqjwFgIv07PGn0GpyVsTuL2nazYJBEIWN
	5HL8iE89WRnEro4jq8jT6rWlSGAKF7zUJLM4ARLBpyDHFf8ZlER98scf/gSJAxYi+eTRIFRQp1FhF
	6750elrJB+BczL3NazF7VoOsirE6l70EowS0HhsPf1oj5NPo2iueddP5+hfy0s2L7eukyplO7dQWW
	4e5jhfX5dzYfU0BkpAAvBT5hF9KBXXI0eP2F86aAre8vEbDBAXtoEoPJlzg5cwtfVFEIIuXwtJyMq
	bM2OxsT2AQrURX+IsaLx5crNk/Z3HWGYQ8FL3FvvpaAillfffr3xXRJGKZpc1mhG6oqTgVn3bbnH+
	TU3vnOdr8AlgEVEUTia+nUmNIJtWA1QZlU2TBHgXbMqAxy3XbmquSNLWpNvfBuJnG0wyAKupNp9EU
	t4nVRtOyeB2Jt4lTg7imhD3z;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vGEbV-00CW5C-30;
	Tue, 04 Nov 2025 10:49:34 +0000
Message-ID: <8f1cd9a8-d292-4129-abed-9e6082ee397b@samba.org>
Date: Tue, 4 Nov 2025 11:49:33 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 000/127] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>,
 David Howells <dhowells@redhat.com>
References: <cover.1761742839.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cover.1761742839.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I already used these debugging features:

CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_KASAN=y
CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=y
CONFIG_KASAN_GENERIC=y
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
CONFIG_KASAN_EXTRA_INFO=y

But now I turned on a lot more debugging features:

CONFIG_PRINTK_CALLER=y
CONFIG_STACKTRACE_BUILD_ID=y
CONFIG_DEBUG_INFO_COMPRESSED_ZSTD=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0xffffffff
CONFIG_PAGE_EXTENSION=y
CONFIG_PAGE_OWNER=y
CONFIG_PAGE_TABLE_CHECK=y
CONFIG_DEBUG_PAGE_REF=y
CONFIG_PTDUMP_DEBUGFS=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=0
CONFIG_WQ_WATCHDOG=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RAW_LOCK_NESTING=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
CONFIG_DEBUG_IRQFLAGS=y
CONFIG_PROVE_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACE_PREEMPT_TOGGLE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y

And that luckily revealed some cases where
I called functions which might sleep in a
ib_post_recv completion function that
is called in a softirq as the client uses
IB_POLL_SOFTIRQ.

I means that I needed to deferr some of the
smbdirect_connect_negotiate_recv_done and
smbdirect_accept_negotiate_recv_done logic
to the workqueue.

And I added some includes to smbdirect_socket.h,
as some sparc cross compile bot was complaining
about a failing build.

I also did a few minor changes like using
sc->ib.dev consistently.

As well as setting sc->first_error as early as possible.

I took the current ksmbd-for-next-next at
commit 2bd117c715790585d69a06bd5f795520fc67ce86
and rebased it on v6.18-rc4 and then removed my patches
and added the modified once on top.

The result can be found in my for-6.19/fs-smb-20251104-v3 branch,
at commit a73e9e7470238121b87b2128da2ed1fff9fd6d4b:
git fetch https://git.samba.org/metze/linux/wip.git for-6.19/fs-smb-20251104-v3
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-6.19/fs-smb-20251104-v3

The whole diff between the old and new patchset
follows below:

The new branch should replace ksmbd-for-next-next...

Thanks!
metze

  fs/smb/common/smbdirect/smbdirect_accept.c     | 154 +++++++++++++++-------
  fs/smb/common/smbdirect/smbdirect_connect.c    | 171 +++++++++++++++++--------
  fs/smb/common/smbdirect/smbdirect_connection.c |  91 +++++++++++--
  fs/smb/common/smbdirect/smbdirect_socket.h     |  15 +++
  4 files changed, 316 insertions(+), 115 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/smbdirect/smbdirect_accept.c
index 0ed3f43a7397..3455e7327663 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/common/smbdirect/smbdirect_accept.c
@@ -192,25 +192,14 @@ static int smbdirect_accept_init_params(struct smbdirect_socket *sc)
  	return 0;
  }

+static void smbdirect_accept_negotiate_recv_work(struct work_struct *work);
+
  static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc)
  {
  	struct smbdirect_recv_io *recv_io =
  		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
  	struct smbdirect_socket *sc = recv_io->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_negotiate_req *nreq;
-	u16 min_version;
-	u16 max_version;
-	u16 credits_requested;
-	u32 preferred_send_size;
-	u32 max_receive_size;
-	u32 max_fragmented_size;
-	struct smbdirect_send_io *send_io = NULL;
-	struct smbdirect_negotiate_resp *nrep;
-	struct ib_send_wr send_wr;
-	u32 ntstatus;
-	int posted;
-	int ret;
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;

  	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_RECV))) {
  		if (wc->status != IB_WC_WR_FLUSH_ERR)
@@ -235,18 +224,98 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
  			 msecs_to_jiffies(sp->keepalive_interval_msec));

-	ib_dma_sync_single_for_cpu(wc->qp->device,
+	ib_dma_sync_single_for_cpu(sc->ib.dev,
  				   recv_io->sge.addr,
  				   recv_io->sge.length,
  				   DMA_FROM_DEVICE);

-	if (wc->byte_len < sizeof(*nreq)) {
+	if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"wc->byte_len=%u < %zu\n",
-			wc->byte_len, sizeof(*nreq));
+			wc->byte_len, sizeof(struct smbdirect_negotiate_req));
  		goto error;
  	}

+	/*
+	 * We continue via the workqueue as we may have
+	 * complex work that might sleep.
+	 *
+	 * The work should already/still be disabled,
+	 * but smbdirect_connection_put_recv_io() disables
+	 * it again.
+	 *
+	 * Note that smbdirect_connection_put_recv_io()
+	 * only moved recv_io into the free list, but
+	 * we didn't call smbdirect_connection_recv_io_refill()
+	 * yet, so it won't be reused, but the cleanup code
+	 * on disconnect is able to find it, disables
+	 * recv_io->complex_work again.
+	 */
+	smbdirect_connection_put_recv_io(recv_io);
+	INIT_WORK(&recv_io->complex_work, smbdirect_accept_negotiate_recv_work);
+	queue_work(sc->workqueue, &recv_io->complex_work);
+	return;
+
+error:
+	/*
+	 * recv_io.posted.refill_work is still disabled,
+	 * so smbdirect_connection_put_recv_io() won't
+	 * start it.
+	 */
+	smbdirect_connection_put_recv_io(recv_io);
+	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+}
+
+static void smbdirect_accept_negotiate_recv_work(struct work_struct *work)
+{
+	struct smbdirect_recv_io *recv_io =
+		container_of(work, struct smbdirect_recv_io, complex_work);
+	struct smbdirect_socket *sc = recv_io->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_negotiate_req *nreq;
+	u16 min_version;
+	u16 max_version;
+	u16 credits_requested;
+	u32 preferred_send_size;
+	u32 max_receive_size;
+	u32 max_fragmented_size;
+	struct smbdirect_send_io *send_io = NULL;
+	struct smbdirect_negotiate_resp *nrep;
+	struct ib_send_wr send_wr;
+	u32 ntstatus;
+	int posted;
+	int ret;
+
+	/*
+	 * make sure we won't start again...
+	 */
+	disable_work(work);
+
+	/*
+	 * Note recv_io is already part of the free list,
+	 * as smbdirect_connect_negotiate_recv_done() called
+	 * smbdirect_connection_put_recv_io(), but
+	 * it won't be reused before we call
+	 * smbdirect_connection_recv_io_refill() below.
+	 */
+
+	if (unlikely(sc->first_error))
+		return;
+
+	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING) {
+		/*
+		 * Something went wrong...
+		 */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe local: %pISpsfc remote: %pISpsfc\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			&sc->rdma.cm_id->route.addr.src_addr,
+			&sc->rdma.cm_id->route.addr.dst_addr);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
+	}
+
  	nreq = (struct smbdirect_negotiate_req *)recv_io->packet;
  	min_version = le16_to_cpu(nreq->min_version);
  	max_version = le16_to_cpu(nreq->max_version);
@@ -281,7 +350,8 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  	if (credits_requested == 0) {
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"invalid: credits_requested == 0\n");
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	if (max_receive_size < SMBDIRECT_MIN_RECEIVE_SIZE) {
@@ -289,7 +359,8 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  			"invalid: max_receive_size=%u < %u\n",
  			max_receive_size,
  			SMBDIRECT_MIN_RECEIVE_SIZE);
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	if (max_fragmented_size < SMBDIRECT_MIN_FRAGMENTED_SIZE) {
@@ -297,7 +368,8 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  			"invalid: max_fragmented_size=%u < %u\n",
  			max_fragmented_size,
  			SMBDIRECT_MIN_FRAGMENTED_SIZE);
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	/*
@@ -327,12 +399,6 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  	 */
  	sp->max_fragmented_send_size = max_fragmented_size;

-	/*
-	 * Give recv_io back to the recv_io.free.list,
-	 * so that the refill can also post it.
-	 */
-	smbdirect_connection_put_recv_io(recv_io);
-
  	/*
  	 * Prepare for receiving data_transfer messages
  	 */
@@ -350,7 +416,8 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"smbdirect_connection_recv_io_refill() failed %1pe\n",
  			SMBDIRECT_DEBUG_ERR_PTR(posted));
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	/*
@@ -365,11 +432,11 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  	send_io = smbdirect_connection_alloc_send_io(sc);
  	if (IS_ERR(send_io)) {
  		ret = PTR_ERR(send_io);
-		send_io = NULL;
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"smbdirect_connection_alloc_send_io() failed %1pe\n",
  			SMBDIRECT_DEBUG_ERR_PTR(ret));
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, ret);
+		return;
  	}
  	send_io->cqe.done = smbdirect_accept_negotiate_send_done;

@@ -430,7 +497,9 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"ib_dma_mapping_error() failed %1pe\n",
  			SMBDIRECT_DEBUG_ERR_PTR(ret));
-		goto error;
+		smbdirect_connection_free_send_io(send_io);
+		smbdirect_connection_schedule_disconnect(sc, ret);
+		return;
  	}

  	send_io->sge[0].length = sizeof(*nrep);
@@ -455,30 +524,19 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  		smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
  			"smbdirect_connection_post_send_wr() failed %1pe\n",
  			SMBDIRECT_DEBUG_ERR_PTR(ret));
-		goto error;
+		/*
+		 * Note smbdirect_connection_free_send_io()
+		 * does ib_dma_unmap_page()
+		 */
+		smbdirect_connection_free_send_io(send_io);
+		smbdirect_connection_schedule_disconnect(sc, ret);
+		return;
  	}

  	/*
  	 * smbdirect_accept_negotiate_send_done
  	 * will do all remaining work...
  	 */
-	return;
-
-error:
-	/*
-	 * recv_io.posted.refill_work is still disabled,
-	 * so smbdirect_connection_put_recv_io() won't
-	 * start it.
-	 */
-	if (recv_io)
-		smbdirect_connection_put_recv_io(recv_io);
-	/*
-	 * Note smbdirect_connection_free_send_io()
-	 * does ib_dma_unmap_page()
-	 */
-	if (send_io)
-		smbdirect_connection_free_send_io(send_io);
-	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
  }

  static void smbdirect_accept_negotiate_send_done(struct ib_cq *cq, struct ib_wc *wc)
diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/common/smbdirect/smbdirect_connect.c
index eb8e903c9fce..b9544a6ef59b 100644
--- a/fs/smb/common/smbdirect/smbdirect_connect.c
+++ b/fs/smb/common/smbdirect/smbdirect_connect.c
@@ -536,23 +536,14 @@ static void smbdirect_connect_negotiate_send_done(struct ib_cq *cq, struct ib_wc
  	}
  }

+static void smbdirect_connect_negotiate_recv_work(struct work_struct *work);
+
  static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc *wc)
  {
  	struct smbdirect_recv_io *recv_io =
  		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
  	struct smbdirect_socket *sc = recv_io->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_negotiate_resp *nrep;
-	u16 negotiated_version;
-	u16 credits_requested;
-	u16 credits_granted;
-	u32 status;
-	u32 max_readwrite_size;
-	u32 preferred_send_size;
-	u32 max_receive_size;
-	u32 max_fragmented_size;
-	int posted;
-	int ret;
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;

  	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_RECV))) {
  		if (wc->status != IB_WC_WR_FLUSH_ERR)
@@ -574,18 +565,96 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
  			 msecs_to_jiffies(sp->keepalive_interval_msec));

-	ib_dma_sync_single_for_cpu(wc->qp->device,
+	ib_dma_sync_single_for_cpu(sc->ib.dev,
  				   recv_io->sge.addr,
  				   recv_io->sge.length,
  				   DMA_FROM_DEVICE);

-	if (wc->byte_len < sizeof(*nrep)) {
+	if (wc->byte_len < sizeof(struct smbdirect_negotiate_resp)) {
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"wc->byte_len=%u < %zu\n",
-			wc->byte_len, sizeof(*nrep));
+			wc->byte_len, sizeof(struct smbdirect_negotiate_resp));
  		goto error;
  	}

+	/*
+	 * We continue via the workqueue as we may have
+	 * complex work that might sleep.
+	 *
+	 * The work should already/still be disabled,
+	 * but smbdirect_connection_put_recv_io() disables
+	 * it again.
+	 *
+	 * Note that smbdirect_connection_put_recv_io()
+	 * only moved recv_io into the free list, but
+	 * we didn't call smbdirect_connection_recv_io_refill()
+	 * yet, so it won't be reused, but the cleanup code
+	 * on disconnect is able to find it, disables
+	 * recv_io->complex_work again.
+	 */
+	smbdirect_connection_put_recv_io(recv_io);
+	INIT_WORK(&recv_io->complex_work, smbdirect_connect_negotiate_recv_work);
+	queue_work(sc->workqueue, &recv_io->complex_work);
+	return;
+
+error:
+	/*
+	 * recv_io.posted.refill_work is still disabled,
+	 * so smbdirect_connection_put_recv_io() won't
+	 * start it.
+	 */
+	smbdirect_connection_put_recv_io(recv_io);
+	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+}
+
+static void smbdirect_connect_negotiate_recv_work(struct work_struct *work)
+{
+	struct smbdirect_recv_io *recv_io =
+		container_of(work, struct smbdirect_recv_io, complex_work);
+	struct smbdirect_socket *sc = recv_io->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_negotiate_resp *nrep;
+	u16 negotiated_version;
+	u16 credits_requested;
+	u16 credits_granted;
+	u32 status;
+	u32 max_readwrite_size;
+	u32 preferred_send_size;
+	u32 max_receive_size;
+	u32 max_fragmented_size;
+	int posted;
+	int ret;
+
+	/*
+	 * make sure we won't start again...
+	 */
+	disable_work(work);
+
+	/*
+	 * Note recv_io is already part of the free list,
+	 * as smbdirect_connect_negotiate_recv_done() called
+	 * smbdirect_connection_put_recv_io(), but
+	 * it won't be reused before we call
+	 * smbdirect_connection_recv_io_refill() below.
+	 */
+
+	if (unlikely(sc->first_error))
+		return;
+
+	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING) {
+		/*
+		 * Something went wrong...
+		 */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe local: %pISpsfc remote: %pISpsfc\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			&sc->rdma.cm_id->route.addr.src_addr,
+			&sc->rdma.cm_id->route.addr.dst_addr);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
+	}
+
  	nrep = (struct smbdirect_negotiate_resp *)recv_io->packet;
  	negotiated_version = le16_to_cpu(nrep->negotiated_version);
  	credits_requested = le16_to_cpu(nrep->credits_requested);
@@ -623,7 +692,16 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"invalid: negotiated_version=0x%x\n",
  			negotiated_version);
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNREFUSED);
+		return;
+	}
+
+	if (status != 0) {
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"invalid: status=0x%x != 0x0\n",
+			status);
+		smbdirect_connection_schedule_disconnect(sc, -ECONNREFUSED);
+		return;
  	}

  	if (max_receive_size < SMBDIRECT_MIN_RECEIVE_SIZE) {
@@ -631,7 +709,8 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  			"invalid: max_receive_size=%u < %u\n",
  			max_receive_size,
  			SMBDIRECT_MIN_RECEIVE_SIZE);
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	if (max_fragmented_size < SMBDIRECT_MIN_FRAGMENTED_SIZE) {
@@ -639,19 +718,22 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  			"invalid: max_fragmented_size=%u < %u\n",
  			max_fragmented_size,
  			SMBDIRECT_MIN_FRAGMENTED_SIZE);
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	if (credits_granted == 0) {
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"invalid: credits_granted == 0\n");
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	if (credits_requested == 0) {
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"invalid: credits_requested == 0\n");
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	if (preferred_send_size > sp->max_recv_size) {
@@ -659,14 +741,8 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  			"invalid: preferred_send_size=%u < max_recv_size=%u\n",
  			preferred_send_size,
  			sp->max_recv_size);
-		goto error;
-	}
-
-	if (status != 0) {
-		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
-			"invalid: status=0x%x != 0x0\n",
-			status);
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	/*
@@ -701,7 +777,8 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  			"invalid: max_readwrite_size=%u < PAGE_SIZE(%lu)\n",
  			max_readwrite_size,
  			PAGE_SIZE);
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}
  	sp->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;

@@ -716,11 +793,14 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  	 */
  	sp->max_fragmented_send_size = max_fragmented_size;

-	/*
-	 * Give recv_io back to the recv_io.free.list,
-	 * so that the refill can also post it.
-	 */
-	smbdirect_connection_put_recv_io(recv_io);
+	ret = smbdirect_connection_create_mr_list(sc);
+	if (ret) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_create_mr_list() failed %1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		smbdirect_connection_schedule_disconnect(sc, ret);
+		return;
+	}

  	/*
  	 * Prepare for receiving data_transfer messages
@@ -731,14 +811,6 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  		recv_io->cqe.done = smbdirect_connection_recv_io_done;
  	recv_io = NULL;

-	ret = smbdirect_connection_create_mr_list(sc);
-	if (ret) {
-		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-			"smbdirect_connection_create_mr_list() failed %1pe\n",
-			SMBDIRECT_DEBUG_ERR_PTR(ret));
-		goto error;
-	}
-
  	/*
  	 * We should at least post 1 smbdirect_recv_io!
  	 */
@@ -747,7 +819,8 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
  			"smbdirect_connection_recv_io_refill() failed %1pe\n",
  			SMBDIRECT_DEBUG_ERR_PTR(ret));
-		goto error;
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		return;
  	}

  	/*
@@ -756,18 +829,6 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
  	 * the waiter.
  	 */
  	smbdirect_connection_negotiation_done(sc);
-
-	return;
-
-error:
-	/*
-	 * recv_io.posted.refill_work is still disabled,
-	 * so smbdirect_connection_put_recv_io() won't
-	 * start it.
-	 */
-	if (recv_io)
-		smbdirect_connection_put_recv_io(recv_io);
-	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
  }

  __SMBDIRECT_PUBLIC__
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index ae9626888b5c..cc22e8b2f4d3 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -742,6 +742,8 @@ int smbdirect_connection_create_mem_pools(struct smbdirect_socket *sc)
  			goto err;
  		recv_io->socket = sc;
  		recv_io->sge.length = 0;
+		INIT_WORK(&recv_io->complex_work, __smbdirect_socket_disabled_work);
+		disable_work_sync(&recv_io->complex_work);
  		list_add_tail(&recv_io->list, &sc->recv_io.free.list);
  	}

@@ -757,6 +759,10 @@ void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc)
  	struct smbdirect_recv_io *recv_io, *next_io;

  	list_for_each_entry_safe(recv_io, next_io, &sc->recv_io.free.list, list) {
+		/*
+		 * The work should already be disabled
+		 */
+		disable_work_sync(&recv_io->complex_work);
  		list_del(&recv_io->list);
  		mempool_free(recv_io, sc->recv_io.mem.pool);
  	}
@@ -833,9 +839,10 @@ struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_sock
  	unsigned long flags;

  	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
-	msg = list_first_entry_or_null(&sc->recv_io.free.list,
-				       struct smbdirect_recv_io,
-				       list);
+	if (likely(!sc->first_error))
+		msg = list_first_entry_or_null(&sc->recv_io.free.list,
+					       struct smbdirect_recv_io,
+					       list);
  	if (likely(msg)) {
  		list_del(&msg->list);
  		sc->statistics.get_receive_buffer++;
@@ -851,6 +858,11 @@ void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
  	struct smbdirect_socket *sc = msg->socket;
  	unsigned long flags;

+	/*
+	 * Should already be disabled anyway.
+	 */
+	disable_work(&msg->complex_work);
+
  	if (likely(msg->sge.length != 0)) {
  		ib_dma_unmap_single(sc->ib.dev,
  				    msg->sge.addr,
@@ -874,6 +886,11 @@ static void smbdirect_connection_reassembly_append_recv_io(struct smbdirect_sock
  {
  	unsigned long flags;

+	/*
+	 * The work should already/still be disabled
+	 */
+	disable_work(&msg->complex_work);
+
  	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
  	list_add_tail(&msg->list, &sc->recv_io.reassembly.list);
  	sc->recv_io.reassembly.queue_length++;
@@ -968,6 +985,14 @@ __SMBDIRECT_PRIVATE__
  void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
  					      int error)
  {
+	struct smbdirect_recv_io *recv_io, *recv_tmp;
+	unsigned long flags;
+
+	if (sc->first_error == 0)
+		sc->first_error = error;
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
  	/*
  	 * make sure other work (than disconnect_work)
  	 * is not queued again but here we don't block and avoid
@@ -979,10 +1004,19 @@ void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
  	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
  	disable_delayed_work(&sc->idle.timer_work);

-	if (sc->first_error == 0)
-		sc->first_error = error;
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
+	/*
+	 * If any complex work was scheduled we
+	 * should disable it (only happens during
+	 * negotiation)...
+	 *
+	 * Note that sc->first_error is set before,
+	 * so any future smbdirect_connection_get_recv_io()
+	 * will see it and return NULL.
+	 */
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.list, list)
+		disable_work(&recv_io->complex_work);
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);

  	switch (sc->status) {
  	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
@@ -1037,12 +1071,17 @@ static void smbdirect_connection_disconnect_work(struct work_struct *work)
  {
  	struct smbdirect_socket *sc =
  		container_of(work, struct smbdirect_socket, disconnect_work);
+	struct smbdirect_recv_io *recv_io, *recv_tmp;
+	unsigned long flags;

  	/*
  	 * This should not never be called in an interrupt!
  	 */
  	WARN_ON_ONCE(in_interrupt());

+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
  	/*
  	 * make sure this and other work is not queued again
  	 * but here we don't block and avoid
@@ -1055,8 +1094,19 @@ static void smbdirect_connection_disconnect_work(struct work_struct *work)
  	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
  	disable_delayed_work(&sc->idle.timer_work);

-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
+	/*
+	 * If any complex work was scheduled we
+	 * should disable it (only happens during
+	 * negotiation)...
+	 *
+	 * Note that sc->first_error is set before,
+	 * so any future smbdirect_connection_get_recv_io()
+	 * will see it and return NULL.
+	 */
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.list, list)
+		disable_work(&recv_io->complex_work);
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);

  	switch (sc->status) {
  	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
@@ -1216,6 +1266,24 @@ static void smbdirect_connection_destroy(struct smbdirect_socket *sc)
  	disable_work_sync(&sc->idle.immediate_work);
  	disable_delayed_work_sync(&sc->idle.timer_work);

+	/*
+	 * If any complex work was scheduled we
+	 * should disable it (only happens during
+	 * negotiation)...
+	 *
+	 * Note was already set in sc->first_error in
+	 * smbdirect_connection_schedule_disconnect() or
+	 * smbdirect_connection_disconnect_work(), both
+	 * before time before:
+	 * spin_lock_irqsave(&sc->recv_io.free.lock, flags),
+	 * so any future smbdirect_connection_get_recv_io()
+	 * will see it and return NULL. And we don't
+	 * need to get the lock here again, while
+	 * trying disable_work_sync().
+	 */
+	list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.list, list)
+		disable_work_sync(&recv_io->complex_work);
+
  	if (sc->rdma.cm_id)
  		rdma_lock_handler(sc->rdma.cm_id);

@@ -1231,9 +1299,8 @@ static void smbdirect_connection_destroy(struct smbdirect_socket *sc)
  	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
  	list_splice_tail_init(&sc->recv_io.reassembly.list, &all_list);
  	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-	list_for_each_entry_safe(recv_io, recv_tmp, &all_list, list) {
+	list_for_each_entry_safe(recv_io, recv_tmp, &all_list, list)
  		smbdirect_connection_put_recv_io(recv_io);
-	}
  	sc->recv_io.reassembly.data_length = 0;

  	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
@@ -2002,7 +2069,7 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
  	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
  			 msecs_to_jiffies(sp->keepalive_interval_msec));

-	ib_dma_sync_single_for_cpu(wc->qp->device,
+	ib_dma_sync_single_for_cpu(sc->ib.dev,
  				   recv_io->sge.addr,
  				   recv_io->sge.length,
  				   DMA_FROM_DEVICE);
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 65f25fc4b4a7..ef151ff1c02a 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -6,6 +6,13 @@
  #ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
  #define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__

+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/kref.h>
+#include <linux/mempool.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
  #include <rdma/rw.h>

  enum smbdirect_socket_status {
@@ -617,6 +624,14 @@ struct smbdirect_recv_io {
  #define SMBDIRECT_RECV_IO_MAX_SGE 1
  	struct ib_sge sge;

+	/*
+	 * We may need to handle complex
+	 * work that might sleep and are
+	 * not allowed to run in an interrupt
+	 * context.
+	 */
+	struct work_struct complex_work;
+
  	/* Link to free or reassembly list */
  	struct list_head list;


