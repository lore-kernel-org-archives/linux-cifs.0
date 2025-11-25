Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E4E32937D
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093714; cv=none; b=t0rmYED3mHYqqdrB/v6cFedvUhqPPyrdWO6imYBkKJ+qTwd0WkHE6hEM+h9QhzQeYuFTQlV+FfSWGLvqQ02WfpgEH9N3nMKc6jK4Vi2m/7cOsomcSgFJjErQ9Zn0M9GQpsCD8lykoN0oC8TbCVQoLey6ajiQYLgHqNXvYru/FM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093714; c=relaxed/simple;
	bh=M7xQxnNlnpYu1OcdaJotbQlMANcbeb7XtufQUOuJEi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZz19Ps5Pam/978W2B08eNV7UFfDcY7ygr5zrG1Bh+fDGHGcX3z3a2l+cgQo5zmeWu9hqYxst3XQ3oHg8nt0ifzLJTAMlWnFhM6BWz7UJWYbJcqx01bSqet61vsdnFweSdoMX5cQy/JtDVi4Yh5KeMl5yGrCrqDxXMYP8SZuwJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=oP24vBs6; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oP24vBs6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=llXoHEudPzkUluI3KGa1VSbDxHrIcUI2FUX/ww+qN6U=; b=oP24vBs6XMvU/2uFzFqF5pLkTG
	Cv5ilo9nPT0QnyixG5TBv2IeywX/HxcmTCxUiEaVeDoUE0zdgScs9hov1QaNSL9AZAiz79xsxl6bO
	9+ab1vHm6lRI7N773HpheO53MG+11mJsVT0B+m8iSjjaL1981z9WnQjO8QkrdH0W9FZEcgC6FKR5l
	tSumGDB5Q3jpaXF86f3+FdlZMs74WEFDaRh5gy7oIKZHfyA3fiAUUtL1fln/Hnknj6jjay2IdHHj1
	n1MHbi7jcgJtY9bJ1vI4rnjpnWZ57o2UkylJ6MTuoyrZ4+iCHYCqmOIyVkv6FBQ+rXfp8dOfLkjRH
	YlO7+PipYu7fyCEAi1HkOZM6ux8vOYMyM6FkNyMBUhBax7akHQAlBrw1W56w6ilXva4+hwHo2teMX
	Wrfn4xnVOz4crk8pPFqJjYzGl/7tyDBySfOixylOYcaer0XUnvM2Dra0a+jLurTKfpZghqYcMQIDt
	pianR8RHONWitkgX6IBcnG5D;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxMK-00FdHy-0i;
	Tue, 25 Nov 2025 18:01:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 049/145] smb: smbdirect: introduce smbdirect_connection_wait_for_connected()
Date: Tue, 25 Nov 2025 18:54:55 +0100
Message-ID: <22017877c4e0af3df7af7bfae7a13659c1035cfa.1764091285.git.metze@samba.org>
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

This will be used by client and server in order to wait for
the connect/negotiation to finish in order to get a usable
connection.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 3576737ec199..22d6273649a7 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -719,6 +719,74 @@ static void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socke
 						peer_responder_resources);
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	union {
+		struct sockaddr sa;
+		struct sockaddr_storage ss;
+	} src_addr, dst_addr;
+	const struct sockaddr *src = NULL;
+	const struct sockaddr *dst = NULL;
+	char _devname[IB_DEVICE_NAME_MAX] = { 0, };
+	const char *devname = NULL;
+	int ret;
+
+	if (sc->rdma.cm_id) {
+		src_addr.ss = sc->rdma.cm_id->route.addr.src_addr;
+		if (src_addr.sa.sa_family != AF_UNSPEC)
+			src = &src_addr.sa;
+		dst_addr.ss = sc->rdma.cm_id->route.addr.dst_addr;
+		if (dst_addr.sa.sa_family != AF_UNSPEC)
+			dst = &dst_addr.sa;
+
+		if (sc->ib.dev) {
+			memcpy(_devname, sc->ib.dev->name, IB_DEVICE_NAME_MAX);
+			devname = _devname;
+		}
+	}
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"waiting for connection: device: %.*s local: %pISpsfc remote: %pISpsfc\n",
+		IB_DEVICE_NAME_MAX, devname, src, dst);
+
+	ret = wait_event_interruptible_timeout(sc->status_wait,
+					       sc->status == SMBDIRECT_SOCKET_CONNECTED ||
+					       sc->first_error,
+					       msecs_to_jiffies(sp->negotiate_timeout_msec));
+	if (sc->rdma.cm_id) {
+		/*
+		 * Maybe src and dev are updated in the meantime.
+		 */
+		src_addr.ss = sc->rdma.cm_id->route.addr.src_addr;
+		if (src_addr.sa.sa_family != AF_UNSPEC)
+			src = &src_addr.sa;
+		dst_addr.ss = sc->rdma.cm_id->route.addr.dst_addr;
+		if (dst_addr.sa.sa_family != AF_UNSPEC)
+			dst = &dst_addr.sa;
+
+		if (sc->ib.dev) {
+			memcpy(_devname, sc->ib.dev->name, IB_DEVICE_NAME_MAX);
+			devname = _devname;
+		}
+	}
+	if (ret == 0)
+		ret = -ETIMEDOUT;
+	if (ret < 0)
+		smbdirect_socket_schedule_cleanup(sc, ret);
+	if (sc->first_error) {
+		ret = sc->first_error;
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"connection failed %1pe device: %.*s local: %pISpsfc remote: %pISpsfc\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret),
+			IB_DEVICE_NAME_MAX, devname, src, dst);
+		return ret;
+	}
+
+	return 0;
+}
+
 static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
-- 
2.43.0

