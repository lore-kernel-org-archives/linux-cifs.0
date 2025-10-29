Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B6523EA9C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744298; cv=none; b=ELkkkJtMO9uUCi53e/J1kOv4fNwnO1MeYbEAF1IW/Ql0BgUE1Je2rxhvPD2l2NRw+J6QwScj2YzpREDbyt7hamfTqhbq60iuZKvGQhVi0UTsqNpzHs8umHN31pnCcUYpDXSmd0iz0w4kAtPnst9cie/TNcdRZQ2NK4inMDjYo2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744298; c=relaxed/simple;
	bh=XLo1wvlBO2FUOnu+oYaCbaAvRyZadREWATKwIyWL1HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7T7D8xRz7Ip+6KU2+OcLiodlg+o6BUBP58fX9cUXu8Bpzy4QBtm/0V8jnfKaqJOJv4+kXcI5R3BxO3/WBd79nXCoSik+W3/UhlmxgGFQ23x1sx7j6VqFqMnXf+EVNrrH5DvDY3UzTKDU7ncK8fuSG7u7vEJ7GTX/cGiSXob0w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YzLGu/9r; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YzLGu/9r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=VJLjmfyDt5+9y4iItrcaTHh+lOOl9QB97ndegJs707E=; b=YzLGu/9r6sRyRpCBfl9h/RZa3f
	5ZAgcEH1FXXAjVk7N/m+eH100UxMT7LADQSnEuW8OSEj48NIXvLwiEDdi8NyxNyATMeh27/XQJFtx
	M2zUHu+OPbHLOjtbFhJa5+7oYB+9ElO7nIBC32VjbCg0UgU4ZiAD2njqY9124eJ6Ybahx2i1hHZpt
	o9ONBQ8kfKqNtRb6eP+s7xSCJoOt9AX+TmYJwB9xlcECeBo0eMbSCkyn75kHfCNjJvjXWKinhYmxI
	rysw75nMbeY8sZw0luxbgqMYjhTaycS56ixQUa9URM6ZAYcqWLDtRo6/NGfw3ANKjbGn2joJSu3iV
	8z/2Fkre0ONh1LMXYYIsde2j85paXMZKr8SQWwJpTPMJy4PLAFY0KXleCnkumjmc3OBvpSWI0eBLc
	HqtLSlCjC3ZUmELwKD8YDqGEe9rdEePoqpdLl/hts51Tb4wku4Jsw64t3bzI/NIlNFTQHrTcK7jfs
	/NEYaqPxVBg2mdtzpk7VVlJi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6AX-00BbZS-0z;
	Wed, 29 Oct 2025 13:24:53 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 024/127] smb: smbdirect: introduce smbdirect_connection_negotiate_rdma_resources()
Date: Wed, 29 Oct 2025 14:20:02 +0100
Message-ID: <80272a2f43e929e30b7d8e7e7b32a64332250ded.1761742839.git.metze@samba.org>
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

This is a copy of the same logic used in client and server,
it's inlined there, but they will use the new helper function
soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 5afb27f790a5..7a8a351d0484 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -356,6 +356,68 @@ smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 	return msg;
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
+							  u8 peer_initiator_depth,
+							  u8 peer_responder_resources,
+							  const struct rdma_conn_param *param)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (rdma_protocol_iwarp(sc->ib.dev, sc->rdma.cm_id->port_num) &&
+	    param->private_data_len == 8) {
+		/*
+		 * Legacy clients with only iWarp MPA v1 support
+		 * need a private blob in order to negotiate
+		 * the IRD/ORD values.
+		 */
+		const __be32 *ird_ord_hdr = param->private_data;
+		u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
+		u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
+
+		/*
+		 * cifs.ko sends the legacy IRD/ORD negotiation
+		 * event if iWarp MPA v2 was used.
+		 *
+		 * Here we check that the values match and only
+		 * mark the client as legacy if they don't match.
+		 */
+		if ((u32)param->initiator_depth != ird32 ||
+		    (u32)param->responder_resources != ord32) {
+			/*
+			 * There are broken clients (old cifs.ko)
+			 * using little endian and also
+			 * struct rdma_conn_param only uses u8
+			 * for initiator_depth and responder_resources,
+			 * so we truncate the value to U8_MAX.
+			 *
+			 * smb_direct_accept_client() will then
+			 * do the real negotiation in order to
+			 * select the minimum between client and
+			 * server.
+			 */
+			ird32 = min_t(u32, ird32, U8_MAX);
+			ord32 = min_t(u32, ord32, U8_MAX);
+
+			sc->rdma.legacy_iwarp = true;
+			peer_initiator_depth = (u8)ird32;
+			peer_responder_resources = (u8)ord32;
+		}
+	}
+
+	/*
+	 * negotiate the value by using the minimum
+	 * between client and server if the client provided
+	 * non 0 values.
+	 */
+	if (peer_initiator_depth != 0)
+		sp->initiator_depth = min_t(u8, sp->initiator_depth,
+					    peer_initiator_depth);
+	if (peer_responder_resources != 0)
+		sp->responder_resources = min_t(u8, sp->responder_resources,
+						peer_responder_resources);
+}
+
 static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
 						     int error)
 {
-- 
2.43.0

