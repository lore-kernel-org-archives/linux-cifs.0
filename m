Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27229CB52
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501795; cv=none; b=VUpXZNgpL/hmeo6aukwsNdkqEQlk2KxfarC0Wl6rdvKsvdZu9c7VAY2gZXYCOrXuOWbqdHJtEEByLHzG/Rm+TFQ0VaZQ3Z9vfcbHszUBPbplHBTj1EKKfsF2iuul29RR2Ul/2GU6j3W/4pi0ZLiWxjWkkuQZfUpHgLJoE+fy7dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501795; c=relaxed/simple;
	bh=dkeoQacstzTJgouRm/s9+4nwCXbKGIVW3zKgSzMSPJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d56765QgPnUvUQ0sCwKWxYSra8n4E7diuQhj244UC58ps9sAga+s02wrk+8X8nIYfJG2rQVJuydtZItIyeOvJ70KynsfV3JOUMFDUMw+146u4aRI5eFDs6aZQGlrMiONKLUM8LjnSoQ7GqIsTyZ1/WbvRwjwEokOJh9aq8GIquY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=I7A4qYI+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="I7A4qYI+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=OqiquKw8uRrBjet7no24r9z4f5vNNHYmqJ8s33/fcSU=; b=I7A4qYI+1sX1rgGvaj7BNwA6KN
	nZR3Yq6kASGwK+xjJNs7VVbd99aJzFoUYzBI12SytHHERcQAOPtQ0ezgK4r6j4yG5sA+Bl6ao9tZn
	2zAn/ey+NNgLNZ8lrCZpBRaMa7ORF+mfSBfwNNaNq50lpySOdXW3UJmdx8CSKuLQPstB9Kt40tPTD
	cBtabooGaiPr7domRfWyB2Yd7es30DY0Pj0Z2L1j5ORN1ttev8Q90ERq6Bm4rVrhFo5RtEUKqJ7g3
	+DJv8fP9wfM9PIZTOFKpaB/43rxraBkun3vWyiesGRoCzvZTTToRjzA0B5I53b3mAutzov2J4XXwV
	nYA7LA5FfELbz1Q3BezrzH916K3LGjG8h6FuryQwMybJs7FwNK4EGNmcG2PUBumc5eqrWGsDd9YHi
	HX+HxK8oOcWurVIUULr2GbnJReDaRlExxH4WmU+RDe7z9OcntptTt16W0ekqkgxSWXip1V7lE8+E4
	9Xjfjn+2up3uoihv0R6Jtqeq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji3y-001OX9-0O;
	Wed, 06 Aug 2025 17:36:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 02/18] smb: smbdirect: add SMBDIRECT_RECV_IO_MAX_SGE
Date: Wed,  6 Aug 2025 19:35:48 +0200
Message-ID: <cab6668f747df91f0e8b6225f4ad75b8a790696e.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow the client and server specific defines to be
replaced.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 3ae834ca3af1..7270fcee1048 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -92,6 +92,13 @@ struct smbdirect_socket {
 struct smbdirect_recv_io {
 	struct smbdirect_socket *socket;
 	struct ib_cqe cqe;
+
+	/*
+	 * For now we only use a single SGE
+	 * as we have just one large buffer
+	 * per posted recv.
+	 */
+#define SMBDIRECT_RECV_IO_MAX_SGE 1
 	struct ib_sge sge;
 
 	/* Link to free or reassembly list */
-- 
2.43.0

