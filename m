Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5606E246BB9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744292; cv=none; b=YFjf2G+x3BiYFgwvsvQ6jZ3fetMtVehme8wbwwGUH3GVlwnJWTELkbO+PvFE/+W74C9BYhO0+7AB+26hEtMl0orsdGLq+dE1re+BSS96pb00x4LESMIbUJhrWFzsPMlIyK5mr7478A4llCZtx9DqVjXKW+dgh+vhvBUnkCKn7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744292; c=relaxed/simple;
	bh=RB0/MLdcLeg/mon0FSRopCFnoj/G+wibX0u+gcaABoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EttKUHvUK9OVxkqilyQ08XRaRfBGqSkXsqOS0eW70yWH5Ms55Pxiq+Yxa8xyoqHY/fVHTHYvLh7XjyoHLCMCpOji/U0t7Xq8Eb5qDnG8KC8dZcXJbpdYF0xBfWsPevVqjb0Wmg76VNNGvnqUtcFB3kS+baM/F8bhR9u9Im/WOfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gYLi09CS; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gYLi09CS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=e32+HEKZsRvIZhe8SJt6PWjWzu0O/6ukW3cbEH/tlGc=; b=gYLi09CSizA1UK7puNO46Q8DpG
	zYlK027IE66R6MWGVvalHhE+B/vtM4lhUyb+jvJ2ENfftnKnoRAQQPJOq2gt80vRHppNa0X2+fkj2
	5G5GXYJsITC/6veNJhemrr3EPNh5Svz2snZ93O4uantTlxXyXD2PGDawlHLggozpivw4g9sqCGp05
	deolZkpc0ZSe7bEuS2FueSJTgy4Ykgr8KNXnuw1gSg+ZFHIxdJfGGecjBuNi8dVGnC/TUqxuz3/LI
	7uglx06DOLYphqGH1wxn0ycmZ4mvNtGEgXgluvRHgNhUKCSmJtRUadj1LhGerOC3MX91Zp9s5aEvT
	eLVr3+eDifPcSp42INZ2DjNULG3o3j4QyR64Vw7B6EBVb/u62brUuKdvfil4Iaz5ZXwCl87+tmjD6
	Jr4FLZGiTQR1yEfpJPIwqV1v6IUaE9eN8TKFXBGcFv+bXm+mGw1Cx+i1bisrS53zYp7TXuUUQ4xwh
	WH35SVLFGVuErz4QI5j4+IpZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6AR-00BbYJ-1J;
	Wed, 29 Oct 2025 13:24:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 023/127] smb: smbdirect: introduce smbdirect_connection_qp_event_handler()
Date: Wed, 29 Oct 2025 14:20:01 +0100
Message-ID: <0379d74442c68fbdb99fdd1d4f05cf01a77bf16c.1761742839.git.metze@samba.org>
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

This is basically a copy of smbd_qp_async_error_upcall()
in the client and smb_direct_qpair_handler() in the server.
They will be replaced by the new common function soon,
which will allow more code to be moved as well.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 1113a7e9d575..5afb27f790a5 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -101,6 +101,31 @@ static void smbdirect_connection_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_qp_event_handler(struct ib_event *event, void *context)
+{
+	struct smbdirect_socket *sc = context;
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+		"%s on device %.*s socket %p (cm_id=%p) status %s first_error %1pe\n",
+		ib_event_msg(event->event),
+		IB_DEVICE_NAME_MAX,
+		event->device->name,
+		sc, sc->rdma.cm_id,
+		smbdirect_socket_status_string(sc->status),
+		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+
+	switch (event->event) {
+	case IB_EVENT_CQ_ERR:
+	case IB_EVENT_QP_FATAL:
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+		break;
+
+	default:
+		break;
+	}
+}
+
 static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
 
 __maybe_unused /* this is temporary while this file is included in orders */
@@ -331,7 +356,6 @@ smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 	return msg;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
 						     int error)
 {
-- 
2.43.0

