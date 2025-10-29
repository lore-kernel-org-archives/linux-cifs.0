Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B0A261B96
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744231; cv=none; b=Sjdd3hg8YeGbjEc7JsXKS/xY8Z5D/pbbpChboxMO+PK+nqj7hPdUJ9FA9vDdsVBc6luRku5NFF3NXXmly3P5C/LAR9v42Oreic1D3YZauK7YkYqLb/OSP5b1SrArOcni072PHFQn1m1yNJkLeGKe4jyIJonjLv7RQ7syWEWL/dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744231; c=relaxed/simple;
	bh=7ogLJOOcpm7C6jvkJDFUN1hdydUwnUU0bEMpelxt3sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nzfl3vO3QIO6Y5yqqfZKN1t+4ym/1vyrtbSY/QB72TA/8AqowdM1Ss72PPF/acBIlMkGgrKs6RwW/02Dx4wQog1GDQJCdgVq0XWmtLw8+AuLRlaEnixr7BwHeIFoVD9y//WECUxnzZ78eiMNSqePW/dBDe/OMYywkSWiZeXwFxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tdXSfaFV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tdXSfaFV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=clY1ObX7ulWnBwA/LuW26mVgWdqnWOB6Wjwp+FYXykk=; b=tdXSfaFVEbDRDjufTNhJobX4fY
	5Yg7OVZ8x7M9tjVdlOdmbXrfu2MxARshE3oDxJm2i5a85Jxb4f8B440uHup5lIA/SS3UQXTpI166i
	q8WeUsoqzQha+ygrXkGKvmvQK3hkfgmQ8kbxH9/M4VwNUgDo3Y0a8+AEaz2difOivm4QUWd3m9ZUt
	jzxHnSVKGxhLYASqJKSv1Klf4+pMhMnPG8Gxupp6UWG5Nl5vJHtBnvln/rdssEPJqO+zq37b05AOa
	XuwFEjkl/XRheTIqV54yub1HEQCy7gaP3W9TUWetOal8GLt7FunOxNQU51JNkxzgOj/D+zidGNfc9
	Bs3KR9WhDM/8hyVZ4WEJb7By4adtzqZq6Kd81ZExqFd4j6GqGwWVQ0TigsTe/vbpOuTpmeqOd7kR3
	2qG7GMjmIRqT48YChWsRinEZam0bfE+kUhU4WUm3QW2jIYSepvGjssUn94olRJ5QB+5M2Regtq8Ur
	XD+VkoLk59qwYx6s1gERy5Hr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69P-00BbNi-2d;
	Wed, 29 Oct 2025 13:23:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 012/127] smb: smbdirect: introduce smbdirect_connection_schedule_disconnect()
Date: Wed, 29 Oct 2025 14:19:50 +0100
Message-ID: <beb34939d6e613b0eab29039434c126ff7b7a8d9.1761742839.git.metze@samba.org>
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

This is a copy of smbd_disconnect_rdma_connection() and
smb_direct_disconnect_rdma_connection(). It will replace
them in the next steps.

The only difference is that it gets an explicit error passed
in instead of hardcoding -ECONNABORTED.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 70 +++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index ebf47baa5d25..f96355043e16 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -6,6 +6,8 @@
 
 #include "smbdirect_internal.h"
 
+static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
+						     int error);
 static void smbdirect_connection_disconnect_work(struct work_struct *work);
 
 __maybe_unused /* this is temporary while this file is included in orders */
@@ -67,6 +69,74 @@ static void smbdirect_connection_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
+						     int error)
+{
+	/*
+	 * make sure other work (than disconnect_work)
+	 * is not queued again but here we don't block and avoid
+	 * disable[_delayed]_work_sync()
+	 */
+	disable_work(&sc->recv_io.posted.refill_work);
+	disable_work(&sc->mr_io.recovery_work);
+	disable_work(&sc->idle.immediate_work);
+	disable_delayed_work(&sc->idle.timer_work);
+
+	if (sc->first_error == 0)
+		sc->first_error = error;
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
+	switch (sc->status) {
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
+	case SMBDIRECT_SOCKET_ERROR:
+	case SMBDIRECT_SOCKET_DISCONNECTING:
+	case SMBDIRECT_SOCKET_DISCONNECTED:
+	case SMBDIRECT_SOCKET_DESTROYED:
+		/*
+		 * Keep the current error status
+		 */
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_CREATED:
+	case SMBDIRECT_SOCKET_CONNECTED:
+		sc->status = SMBDIRECT_SOCKET_ERROR;
+		break;
+	}
+
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	smbdirect_connection_wake_up_all(sc);
+
+	queue_work(sc->workqueue, &sc->disconnect_work);
+}
+
 static void smbdirect_connection_disconnect_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
-- 
2.43.0

