Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C275432D43D
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093561; cv=none; b=RfqG25PTcshHi0CWhEkO1NPrRnIahTbhUKAgL7AOhgSgvM2EXdt/og+c1jre8JZh2FGsKFF29yNtwHrlt/Cjp+pIxJW5WyRvqcbe7XFFSwPagJr3bEFNlYcKWLJDIeRLZVlZz11DTIfgTxz0/owscUVSLRXrbL+k15fMyDx78yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093561; c=relaxed/simple;
	bh=euS04MTF5eRijwDhn4JRbv2+XIPYrn53TIiaZusRMe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUNDldNyLHCiTacl+ufkNyLrTxupbC4eCrEJDxt+tLRoRb8n7V5rORMv6FAPFFOrtih4zLKeQSG4+dtS52EH39abgJTl6M2HAKiBle7MnUlf5bpOUnHyguIukw+1mUu0AS1l0SCauCZ3ZU2Oue/9J90/HDNnPMxALrhmQiJpTP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=V/C6twYR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="V/C6twYR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Qy+2XmKfn5UFc2FXYoOcogtXoKuAzm2rZgwa0pF54SA=; b=V/C6twYR7DHnwuoiUvMi2xN52/
	HXzQUEj+j1RWlqnhdJXNDIzoxYa0kzN/cU2b4jZPxc0LQeLwzbSyXvFFv4tww4D9BXe7pinHeXFZc
	Qp9AeHRvSmIapJGni52z7U+aJfe/M92+8pgVKXhKUPe08tQqSXvMfo5GUHxXAyMcAXuJR95FOZ1uf
	1BgqNfxyGK5n83/Sd/BQj3QbTAAjNvWqCToJkPSGJJv6tg6iruEfLl20iJBvMQ5VLDYQhhlexGQm4
	PubTvFiOyhyjFo1r/7e5w8X3WiZDufbrwuUktLsuxSLazC2TTLeyK9bEfmEsi/YVJkncJfMhquduR
	Zgkw2HkFFFW74GYAHwEeThDV637OpIH7G9LcwAK5qBIwX8xiazN5OHhMWutJTRXak+YaJ7V9s5qQt
	tOVH+WVfwbRAbYgYnwsNU5GidPXOB3lEOsusdm+SgM2/at+KRaK/+TalogJVB/nN/9MUMKh0THqxZ
	+Sn1ZgGiMoj4u4ZZ0UaHL6k+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJq-00Fcsu-2C;
	Tue, 25 Nov 2025 17:59:15 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 026/145] smb: smbdirect: introduce smbdirect_connection_qp_event_handler()
Date: Tue, 25 Nov 2025 18:54:32 +0100
Message-ID: <f388ebbba66c8ed4769221a98b27aaf9ca7a58d3.1764091285.git.metze@samba.org>
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
 .../common/smbdirect/smbdirect_connection.c   | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 8c056d363b23..989f55993eee 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -19,6 +19,31 @@ struct smbdirect_map_sges {
 static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 					    struct smbdirect_map_sges *state);
 
+__maybe_unused /* this is temporary while this file is included in others */
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
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		break;
+
+	default:
+		break;
+	}
+}
+
 static void smbdirect_connection_destroy_mem_pools(struct smbdirect_socket *sc);
 
 __maybe_unused /* this is temporary while this file is included in others */
-- 
2.43.0

