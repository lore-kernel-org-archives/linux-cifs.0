Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AF72D7803
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744445; cv=none; b=gSOhsmv10CXfdmN8H2YFUfQbC8zgiHOBxZ+zKKY0ggsVatAtjjk0afAVfFRo2MtNFoHvI+pIgiopOLSjiLQHkY0WzcXvd+AGNvDtG675jeuIvggLIiGAmRUctv3Kr/07o6cEIxMkban3TJjjjxHFVxMHZZnrNsAonZ4wsovPBP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744445; c=relaxed/simple;
	bh=2HfVhOa2sOWPdsuH6UPGU3BDig6nBDCdpzCuPSoN6t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKEzS3bNGh7R99OIuhUFB0HQIjuM+OuB8UgB4MIyrBYWlrBo8CDC8kmjy7cVn1szdMxyGGixEfmy1HxKusqODf9FEPHSO9sGIrRrKzzjNVEDlakcMa05jeTAWTAiP3XI8kuhLYnSkdt7Cixl4fQJEHJQlJ6hgwIqiRUoukFq0ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=o56IoTfU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="o56IoTfU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4QMjJ0ckSSZ/diCiAYLUR2n0QuYBLbxmEbvZbAGjKMk=; b=o56IoTfU53lYiCLzyEHEuqAsP5
	dtuQN4yEHzekIS2WpOuzjszZi4BGAyw2UjpF/zYTZAo3DXM6+Fh3Jb9j1lrKW0m8szcnLXRSYM0QM
	N9wvVG2GZQo5QtZR0VaLwcfxYlmzmYdZiQnqJbLHJJqywc8X0rcV1phGStnCjkeLY70xKtxiR9vU9
	aUUx8AJFvrtJIDWPGS5VYNt/NmNoOfj94A1FKXvxvChOIgMZLpYCyt4pQz6ZUfD78UatDksgwZiSO
	0OJyrhAH6bmcdBt0PDmIRvmwhY9/EfYqgkEA39PDCObcQycaXqfsqJfosi4FVE5QaUUlogp8b2Gry
	A/At5xt88A5q4vM1OSCZy94SIPtUASPiH+MbpRnShQyFCiOEfxVA8x0FE2I006r94jk0qF7Uhxwum
	dKc9GYQDeuKtw4W+CVSNnOa6NkGcIy75A4dXxOZLi9mOyxtQ75g0dAy58ra9E6X9cP/yPdw+NaZcp
	3Z3abixu4IzuPdZNGzkwppKi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Ct-00BbvN-29;
	Wed, 29 Oct 2025 13:27:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 049/127] smb: smbdirect: introduce smbdirect_socket_init_{new,accepting}() and helpers
Date: Wed, 29 Oct 2025 14:20:27 +0100
Message-ID: <bb62e62200d42b3775561db4af8e184dadfd9e1f.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
---
 .../common/smbdirect/smbdirect_connection.c   | 145 ++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 5670e442e129..34be36cf5d00 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -67,6 +67,151 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	INIT_DELAYED_WORK(&sc->idle.timer_work, smbdirect_connection_idle_timer_work);
 }
 
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
+	return 1;
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
+{
+	struct rdma_cm_id *id;
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
+	sc->rdma.cm_id = id;
+
+	INIT_WORK(&sc->disconnect_work, smbdirect_connection_disconnect_work);
+
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
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
+	INIT_WORK(&sc->disconnect_work, smbdirect_connection_disconnect_work);
+
+	return 0;
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
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
+__maybe_unused /* this is temporary while this file is included in orders */
+static const struct smbdirect_socket_parameters *
+smbdirect_socket_get_current_parameters(struct smbdirect_socket *sc)
+{
+	return &sc->parameters;
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
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
+__maybe_unused /* this is temporary while this file is included in orders */
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
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 					 void *private_ptr,
-- 
2.43.0

