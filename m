Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2843F37E313;
	Wed, 21 Jan 2026 20:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769026067; cv=none; b=qZfNYRXrORGTONTebouehonQnCNVjQsAXPBCtG3QQt7ls+rOSXuJY+ywjwGfcSK3Olc27IgbvHDy5aO0rmcKTXhAYk9pOs2ITGL++jbCRlcY1Lcp7XJkyuys8uJj+MfpVLSc9XqU2XmParLJmcY3ndCSIz+SB5heL9vdGAxyGMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769026067; c=relaxed/simple;
	bh=jKQoXfl2OJnitpHnQM1OlTYGDMLxVdTjDqsWo2r/tgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fx+N12m3NqJ+OD5ZPGxFepc8FMphigz9Ijv7+/fHaq75x1nArDmQXNsfq/qOqXvAAk20aR6hJA3JTI3m6aogvT2hoSBorHpoENuozQI8R4rtVKmZY/yWS6yh5Fn3uDpXv55m8DgO5ux0aNDIljQ19m4NlTM0kgKmNtzRnR4RvZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wfqZgSJp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wfqZgSJp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=13W8oztvU2EDWvkCh3AsnafihVEB7J2KdK3Lip9lz9Y=; b=wfqZgSJpK5ci3rQ7hzqPaBfcsc
	Do1WTiFFdT/A8cQ0epWCg/VIrl7LlkG4WDSK2L2AnNGkqxEVAWuYZKZEIEpRa8rs8ZO2zIMhW0L+S
	UaPnSWzVLtgz8jmO8QNRUT0JL+PRmKNq9lIokHqcoQC9G+C15k2NGd257eslh1JN9i5er7VKJxows
	eLSygg8PXSyL/rcj082Zc7OqadwN3mBd+qvUz1jMu7A8IpXGofbW78PhgILTwumgVrN0z8EtCpjGv
	MD9QSU+uTCUy1IRURZFOhG4nUQW8ZBNvulrmJR5WiaRPFZT8NZjnSN00Dip9aFuGXnOyWKzBhJV29
	DqAiWziUwFeCyAkj1j6ti9lZeZ7sDPaQV/+SlIkdCXjC/5OYprQKKjhizPfhfytbux0eArgUgS4M7
	a2F0cV8CwBym/zJGfB6xpnCDwD78UwcjtrObI4UGP7DWyieQ2KUnNUQTli8K7jC/F064GYOE11PYg
	2wqrZrvD1+OYIP7wPsPDfksp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieUQ-00000001ek8-0ecm;
	Wed, 21 Jan 2026 20:07:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-rdma@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [RFC PATCH 2/3] smb: client: make use of rdma_restrict_node_type()
Date: Wed, 21 Jan 2026 21:07:12 +0100
Message-ID: <7f532425cfeb7f1c53449b6725872c4fed14a523.1769025321.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769025321.git.metze@samba.org>
References: <cover.1769025321.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For smbdirect it required to use different ports depending
on the RDMA protocol. E.g. for iWarp 5445 is needed
(as tcp port 445 already used by the raw tcp transport for SMB),
while InfiniBand, RoCEv1 and RoCEv2 use port 445, as they
use an independent port range (even for RoCEv2, which uses udp
port 4791 itself).

And cifs.ko uses 5445 with a fallback to 445, which
means depending on the available interfaces, it tries
5445 in the RoCE range or may tries iWarp with 445
as a fallback. This leads to strange error messages
and strange network captures.

To avoid these problems they will be able to
use rdma_restrict_node_type(RDMA_NODE_RNIC) before
trying port 5445 and rdma_restrict_node_type(RDMA_NODE_IB_CA)
before trying port 445. It means we'll get early
-ENODEV early from rdma_resolve_addr() without any
network traffic and timeouts.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 2900b02f90cd..e69bce88cc9c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -903,6 +903,7 @@ static struct rdma_cm_id *smbd_create_id(
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct rdma_cm_id *id;
+	u8 node_type = RDMA_NODE_UNSPECIFIED;
 	int rc;
 	__be16 *sport;
 
@@ -914,6 +915,31 @@ static struct rdma_cm_id *smbd_create_id(
 		return id;
 	}
 
+	switch (port) {
+	case SMBD_PORT:
+		/*
+		 * only allow iWarp devices
+		 * for port 5445.
+		 */
+		node_type = RDMA_NODE_RNIC;
+		break;
+	case SMB_PORT:
+		/*
+		 * only allow InfiniBand, RoCEv1 or RoCEv2
+		 * devices for port 445.
+		 *
+		 * (Basically don't allow iWarp devices)
+		 */
+		node_type = RDMA_NODE_IB_CA;
+		break;
+	}
+	rc = rdma_restrict_node_type(id, node_type);
+	if (rc) {
+		log_rdma_event(ERR, "rdma_restrict_node_type(%u) failed %i\n",
+			       node_type, rc);
+		goto out;
+	}
+
 	if (dstaddr->sa_family == AF_INET6)
 		sport = &((struct sockaddr_in6 *)dstaddr)->sin6_port;
 	else
-- 
2.43.0

