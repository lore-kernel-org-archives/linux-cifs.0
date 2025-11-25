Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40468318152
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093734; cv=none; b=lS46v4hZY+lOFBGgHs4dAg8a2vlWuDpDMPqOdfyyLpM6hInDE4Pk8fL3ZXmnFL3U4fhK/9382YOtD71e370/zgWCb2gvpJSnORUiAW9S5CmtROQHCSBMPyfpuXWQ1NX81P6nycHyCprPjr24o1Fm0jfjMDmQMCoYuO7uykgJMBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093734; c=relaxed/simple;
	bh=PedZSCq9pktUdgxmrV7WbS93uXAkEmA/btKM12AU3IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr6Aaa68Vy1qDmAi86WLLv+/uDalMBEIeKFtvQYUirZ669WU05pXkBx9LW/98wcMcwyiT21m/wvnS/BADJk+szFsoboIh4pS0rPZh7EfX4EGFsycctLJgpCjyBA9L5vq674bp27hhLeF4uEklU3DC4felUJITXpYXWvMLVdNpCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=m7MmtTcs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="m7MmtTcs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=A0I/QA0xErnYoO06kLZpUTD+W4CB710pzAa75VypprQ=; b=m7MmtTcswPKtdOFRDvwmibgxFd
	NO1rf0VPY68tJJyGNA8Bxiz3qp7MJVnyy3blQ/UHVA+pJGhsA17JwbfMF6E3tbnq4FQ/sI7LaroaN
	4cwGxxJvuxIWJhBK+3pdYu9OOMiXL2rhXkuB1/E/dOPVLCrpxzkV+l6AerwYXpye5aMi/JT1mzZue
	g2Lk3SNBq831jFNbUGwyrzbX1asTpZ3elr+pkCCz317VtUrdDG4cYizhXUoxalChhG14+ooz6JPJj
	g5FPIRepMx4BpiulTTePA01JVAqaW0GkQqRl0Jik6q4nhleOYQIybrOjhVPL7J65eMHKc4Jn6j6gH
	Tkzi1WnOwIpiqa1bGSu0n1mKfCTBxcwNwaUzVqW9M1HH8GCLHlg1vpoVpFKmrUlPwRz7ofePyH9Ok
	H3RlGhfnKHgZXlFWYO3sVWkzbZQIKZP9eb6xvkoGqbe8RbKY9NRwzACLEz4+0zQovsoyQA3VccCKR
	jzCmqHu2kAqUMlZbm8ceFNS1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxMc-00FdLr-2H;
	Tue, 25 Nov 2025 18:02:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 052/145] smb: smbdirect: introduce smbdirect_socket_init_{new,accepting}() and helpers
Date: Tue, 25 Nov 2025 18:54:58 +0100
Message-ID: <5664e678aef563fb7279db865851bf5e34122ab3.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These will be used in order to initialize struct smbdirect_socket
with rdma.cm_id being valid from the start in order to hold
a reference to the correct net namespace, this will allow
us to implement async connecting and accepting logic in
the next steps.

This comes with some related helper functions in
order to initialize the socket without the need
to access internals of struct smbdirect_socket:

  smbdirect_socket_set_initial_parameters
  smbdirect_socket_get_current_parameters
  smbdirect_socket_set_kernel_settings
  smbdirect_socket_set_custom_workqueue

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 157 ++++++++++++++++++++-
 1 file changed, 155 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index ed82238c76c0..56ab5a8da447 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -24,6 +24,159 @@ static bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 
 static void smbdirect_socket_cleanup_work(struct work_struct *work);
 
+static int smbdirect_socket_rdma_event_handler(struct rdma_cm_id *id,
+					       struct rdma_cm_event *event)
+{
+	struct smbdirect_socket *sc = id->context;
+	int ret = -ESTALE;
+
+	/*
+	 * This should be replaced before any real work
+	 * starts! So it should never be called!
+	 */
+
+	if (event->event == RDMA_CM_EVENT_DEVICE_REMOVAL)
+		ret = -ENETDOWN;
+	if (IS_ERR(SMBDIRECT_DEBUG_ERR_PTR(event->status)))
+		ret = event->status;
+	pr_err("%s (first_error=%1pe, expected=%s) => event=%s status=%d => ret=%1pe\n",
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+		rdma_event_msg(sc->rdma.expected_event),
+		rdma_event_msg(event->event),
+		event->status,
+		SMBDIRECT_DEBUG_ERR_PTR(ret));
+	WARN_ONCE(1, "%s should not be called!\n", __func__);
+	sc->rdma.cm_id = NULL;
+	return -ESTALE;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
+{
+	struct rdma_cm_id *id;
+	int ret;
+
+	smbdirect_socket_init(sc);
+
+	id = rdma_create_id(net,
+			    smbdirect_socket_rdma_event_handler,
+			    sc,
+			    RDMA_PS_TCP,
+			    IB_QPT_RC);
+	if (IS_ERR(id)) {
+		pr_err("%s: rdma_create_id() failed %1pe\n", __func__, id);
+		return PTR_ERR(id);
+	}
+
+	ret = rdma_set_afonly(id, 1);
+	if (ret) {
+		rdma_destroy_id(id);
+		pr_err("%s: rdma_set_afonly() failed %1pe\n", __func__, errname(ret));
+		return ret;
+	}
+
+	sc->rdma.cm_id = id;
+
+	INIT_WORK(&sc->disconnect_work, smbdirect_socket_cleanup_work);
+
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_socket_init_accepting(struct rdma_cm_id *id, struct smbdirect_socket *sc)
+{
+	smbdirect_socket_init(sc);
+
+	sc->rdma.cm_id = id;
+	sc->rdma.cm_id->context = sc;
+	sc->rdma.cm_id->event_handler = smbdirect_socket_rdma_event_handler;
+
+	sc->ib.dev = sc->rdma.cm_id->device;
+
+	INIT_WORK(&sc->disconnect_work, smbdirect_socket_cleanup_work);
+
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
+						   const struct smbdirect_socket_parameters *sp)
+{
+	/*
+	 * This is only allowed before connect or accept
+	 */
+	WARN_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED,
+		  "status=%s first_error=%1pe",
+		  smbdirect_socket_status_string(sc->status),
+		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+	if (sc->status != SMBDIRECT_SOCKET_CREATED)
+		return -EINVAL;
+
+	/*
+	 * Make a copy of the callers parameters
+	 * from here we only work on the copy
+	 *
+	 * TODO: do we want consistency checking?
+	 */
+	sc->parameters = *sp;
+
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static const struct smbdirect_socket_parameters *
+smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc)
+{
+	return &sc->parameters;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_socket_set_kernel_settings(struct smbdirect_socket *sc,
+						enum ib_poll_context poll_ctx,
+						gfp_t gfp_mask)
+{
+	/*
+	 * This is only allowed before connect or accept
+	 */
+	WARN_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED,
+		  "status=%s first_error=%1pe",
+		  smbdirect_socket_status_string(sc->status),
+		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+	if (sc->status != SMBDIRECT_SOCKET_CREATED)
+		return -EINVAL;
+
+	sc->ib.poll_ctx = poll_ctx;
+
+	sc->send_io.mem.gfp_mask = gfp_mask;
+	sc->recv_io.mem.gfp_mask = gfp_mask;
+	sc->rw_io.mem.gfp_mask = gfp_mask;
+
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_socket_set_custom_workqueue(struct smbdirect_socket *sc,
+						 struct workqueue_struct *workqueue)
+{
+	/*
+	 * This is only allowed before connect or accept
+	 */
+	WARN_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED,
+		  "status=%s first_error=%1pe",
+		  smbdirect_socket_status_string(sc->status),
+		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+	if (sc->status != SMBDIRECT_SOCKET_CREATED)
+		return -EINVAL;
+
+	/*
+	 * Remember the callers workqueue
+	 */
+	sc->workqueue = workqueue;
+
+	return 0;
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 					    const struct smbdirect_socket_parameters *sp,
@@ -35,12 +188,12 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	 * Make a copy of the callers parameters
 	 * from here we only work on the copy
 	 */
-	sc->parameters = *sp;
+	smbdirect_socket_set_initial_parameters(sc, sp);
 
 	/*
 	 * Remember the callers workqueue
 	 */
-	sc->workqueue = workqueue;
+	smbdirect_socket_set_custom_workqueue(sc, workqueue);
 
 	INIT_WORK(&sc->disconnect_work, smbdirect_socket_cleanup_work);
 
-- 
2.43.0

