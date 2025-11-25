Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4AF32ABCF
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093539; cv=none; b=Cc8eOl7a4YfwT+wK7orDYWdCFxUv/qBZrFkBoybXnVHRDwz8AXic12z5DP4CXyPUX+anie3u/JY5twQe+AG+F2BvdZoAiri51i8irgn68z2tpuic0gcoBdiinw1dOUMhNcNGA8bjmnZfL/DuTScvjNxWiLfQTfFi3NeKrSc2/7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093539; c=relaxed/simple;
	bh=qBlsZy7Uv4ulC8vXJG3zMPe4dNjqfVEnDV+Lt9sltVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDEiR/A9rwxYA/LSm5G0pEqnKdwjoF8+YSkFUIzKqLv4gYXHNnlsJRy2XZUIwhK3AlIpuw/zqXswtFRKrUstqjMa9OtUBwP0CyqTGvxTWfexF/Qwl5mgFUT5LfO7PmdyfuBNA/shOSD2HtsqSrREadr+ciLNk3MUTrDN9L8N3Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=S7SCsGIZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="S7SCsGIZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8134CVNIUz+X5RC0wDtvgK444fg3Xtkyq/hqjNpdpkk=; b=S7SCsGIZjX1oWISDi0TzVfTxAV
	fFncKyf9SLvXxSORnjEuQ5a4DOEuMHTY6rNHIzWp8M3EIPh4Vyq34D7QfQRmm4krdVcKIOY7KKFhr
	azyaWmQ9Dnsi8ATHgKQCYwb746ZwQ3pbJ1P6m5WMguBuJS5alIOLlcUOmtmXSvaENEyIRKCD3uXqN
	Nm3aPBV+IzVLhusnJfxY7T7TXuIeMENlSxkeMf+WnoAndjlqLXR0E+i88AAHRo+Z6jnrDf2cSZ3LB
	XSnN0BXpkbm0PueMCBvSWfRVHPplvIWITL4fNv/LK9D2PowHlH4w3Tliw7nXfK6nnO9GFVxjQWRxM
	qFErhXmODOZANMX2E2tP2hbJPtcGiZh3hOV/Ta23mc2J6ohl8cx2WO1vj9Q8wIhy/oPZFwa6YZLtY
	tHieGK2gcbkz2lQUlXlS3rGWWfBNdw2+ClG1aS4VLB1nRT3nKDSHSE1JBNwG7JbpzJdzF9aQO5XSg
	7iZ/3xIue/tywUr7gGXr8r8l;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJT-00FcpC-1h;
	Tue, 25 Nov 2025 17:58:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 022/145] smb: smbdirect: introduce smbdirect_connection_{alloc,free}_send_io()
Date: Tue, 25 Nov 2025 18:54:28 +0100
Message-ID: <b82b91721f389d390dd6af305ab9450ce989631f.1764091285.git.metze@samba.org>
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

These are more or less copies of smb_direct_{alloc,free}_sendmsg()
in the server.

The only difference is that we use ib_dma_unmap_page() for all sges,
this simplifies the logic and doesn't matter as
ib_dma_unmap_single() and ib_dma_unmap_page() both operate
on dma_addr_t and dma_unmap_single_attrs() is just an
alias for dma_unmap_page_attrs().
We already have in inconsistency like that in the client
code where we use ib_dma_unmap_single(), while we mapped
using ib_dma_map_page().

The new functions will replace the existing once in the next commits and
will also be used in the client.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index f3176bb35977..7a2aaa1747dd 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -6,6 +6,53 @@
 
 #include "smbdirect_internal.h"
 
+__maybe_unused /* this is temporary while this file is included in others */
+static struct smbdirect_send_io *smbdirect_connection_alloc_send_io(struct smbdirect_socket *sc)
+{
+	struct smbdirect_send_io *msg;
+
+	msg = mempool_alloc(sc->send_io.mem.pool, sc->send_io.mem.gfp_mask);
+	if (!msg)
+		return ERR_PTR(-ENOMEM);
+	msg->socket = sc;
+	INIT_LIST_HEAD(&msg->sibling_list);
+	msg->num_sge = 0;
+
+	return msg;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_free_send_io(struct smbdirect_send_io *msg)
+{
+	struct smbdirect_socket *sc = msg->socket;
+	size_t i;
+
+	/*
+	 * The list needs to be empty!
+	 * The caller should take care of it.
+	 */
+	WARN_ON_ONCE(!list_empty(&msg->sibling_list));
+
+	/*
+	 * Note we call ib_dma_unmap_page(), even if some sges are mapped using
+	 * ib_dma_map_single().
+	 *
+	 * The difference between _single() and _page() only matters for the
+	 * ib_dma_map_*() case.
+	 *
+	 * For the ib_dma_unmap_*() case it does not matter as both take the
+	 * dma_addr_t and dma_unmap_single_attrs() is just an alias to
+	 * dma_unmap_page_attrs().
+	 */
+	for (i = 0; i < msg->num_sge; i++)
+		ib_dma_unmap_page(sc->ib.dev,
+				  msg->sge[i].addr,
+				  msg->sge[i].length,
+				  DMA_TO_DEVICE);
+
+	mempool_free(msg, sc->send_io.mem.pool);
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
 {
-- 
2.43.0

