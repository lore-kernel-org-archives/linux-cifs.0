Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4E2E0B5C
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104578; cv=none; b=K6PLxQmJEw7pLqiCFki8bzphcM99R2VDmnpOlqNKjdTgzgr6Patke6bAGEXnPKoR9XD7SIu5eVnSfh/SOdgyXaaLPMm4Jv4Z6zj5hSNN14hj2Taj2fdT2foohfrFmo4FYSM499N6gfQWD8ou7Ue1cwssuUXBL3grSu6NSyychho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104578; c=relaxed/simple;
	bh=EgFvQ1ThShhtsftzCV2RX5mzEOJ8cRVoVOOPlFgLonA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KGv4+OyW4Z2CqnphCTzocTHXZKqkz9Dc8wzMVp/3T1KUDM/CjB5WGJDkPlBe4LVNMKhwbRqm9Q4dbrsGC1DbN6MUUvGfRq7slRVdPme6YtcwP+ILTrXpsn4NE9uPwCEf+m2bt1FJeJk5jyH/9Tt0aFCR7EjG78fLWpG50OKdiKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4ugA2Fr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4ugA2Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EEC1F00898;
	Wed, 10 Jun 2026 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104577;
	bh=cdPKUpTYs9Qsgli9fer8Iz9fT5FhsHz6VZkCAYlZOYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4ugA2FrXC40obLm7Rd0+RCHtyvbr3TzMxwpXdad2CebU3ra9OdiT1lOgNULCQRDt
	 Key+MbWtzGDG09ZasDS8X482NZpAwIbBXanrCHyxOyIX0nJc3RVUtvuN5yMFQOY1KS
	 2uZbmcZCHtvksdndyNsCl7QcUb6xHDpYLXibxwbV6QXcQzRg61DeMQRU0BhGEmT/uj
	 NJgyfrRbUO3MlDnICrTfghEbGo2u59DJ69JwQ6D9/MTz2whCyK85yQiZBS8bJUl51z
	 fujKs651KHzS/i/aqc2/KWkQG6kAJ5VuoQDdlrkEy9iOko7PEPygLPnrjHwS/AHHh2
	 eqOQ2wnFTrJdA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/5] cifs: negotiate chained SMB2 compression capabilities
Date: Thu, 11 Jun 2026 00:15:41 +0900
Message-Id: <20260610151543.25218-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260610151543.25218-1-linkinjeon@kernel.org>
References: <20260610151543.25218-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise LZ77 and Pattern_V1 with chained transform support in the
SMB 3.1.1 compression negotiate context. Validate the server's returned
algorithm list and flags, then retain the negotiated capabilities for a
future compressed transform receive implementation.

This patch only negotiates capabilities. It does not request compressed
READ responses or add a compressed transform receive path.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/smb2pdu.c  | 44 ++++++++++++++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd..a3ac4aa4bbc6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -789,6 +789,8 @@ struct TCP_Server_Info {
 	struct {
 		bool requested; /* "compress" mount option set*/
 		bool enabled; /* actually negotiated with server */
+		bool chained; /* chained transforms were negotiated */
+		bool pattern; /* Pattern_V1 chained payloads were negotiated */
 		__le16 alg; /* preferred alg negotiated with server */
 	} compression;
 	__u16	signing_algorithm;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index fbeb2156ddb6..a79d8e6091d0 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -636,10 +636,16 @@ build_compression_ctxt(struct smb2_compression_capabilities_context *pneg_ctxt)
 	pneg_ctxt->DataLength =
 		cpu_to_le16(sizeof(struct smb2_compression_capabilities_context)
 			  - sizeof(struct smb2_neg_context));
-	pneg_ctxt->CompressionAlgorithmCount = cpu_to_le16(3);
+	/*
+	 * Pattern_V1 is useful only as part of a chained transform. LZ77 remains
+	 * the preferred general-purpose algorithm selected by this client.
+	 */
+	pneg_ctxt->CompressionAlgorithmCount = cpu_to_le16(4);
+	pneg_ctxt->Flags = SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED;
 	pneg_ctxt->CompressionAlgorithms[0] = SMB3_COMPRESS_LZ77;
 	pneg_ctxt->CompressionAlgorithms[1] = SMB3_COMPRESS_LZ77_HUFF;
 	pneg_ctxt->CompressionAlgorithms[2] = SMB3_COMPRESS_LZNT1;
+	pneg_ctxt->CompressionAlgorithms[3] = SMB3_COMPRESS_PATTERN;
 }
 
 static unsigned int
@@ -827,9 +833,12 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 			 struct smb2_compression_capabilities_context *ctxt)
 {
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
-	__le16 alg;
+	unsigned int count, i;
 
 	server->compression.enabled = false;
+	server->compression.chained = false;
+	server->compression.pattern = false;
+	server->compression.alg = SMB3_COMPRESS_NONE;
 
 	/*
 	 * Caller checked that DataLength remains within SMB boundary. We still
@@ -841,20 +850,37 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 		return;
 	}
 
-	if (le16_to_cpu(ctxt->CompressionAlgorithmCount) != 1) {
+	count = le16_to_cpu(ctxt->CompressionAlgorithmCount);
+	if (!count || count > ARRAY_SIZE(ctxt->CompressionAlgorithms) ||
+	    len < 8 + count * sizeof(__le16)) {
 		pr_warn_once("invalid SMB3 compress algorithm count\n");
 		return;
 	}
 
-	alg = ctxt->CompressionAlgorithms[0];
-
-	/* 'NONE' (0) compressor type is never negotiated */
-	if (alg == 0 || le16_to_cpu(alg) > 3) {
-		pr_warn_once("invalid compression algorithm '%u'\n", alg);
+	if (ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_NONE &&
+	    ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED) {
+		pr_warn_once("invalid SMB3 compression flags\n");
 		return;
 	}
 
-	server->compression.alg = alg;
+	for (i = 0; i < count; i++) {
+		/* Record the intersection supported by the shared SMB codec. */
+		if (ctxt->CompressionAlgorithms[i] == SMB3_COMPRESS_LZ77)
+			server->compression.alg = SMB3_COMPRESS_LZ77;
+		else if (ctxt->CompressionAlgorithms[i] == SMB3_COMPRESS_PATTERN)
+			server->compression.pattern = true;
+	}
+	if (server->compression.alg != SMB3_COMPRESS_LZ77)
+		return;
+
+	/*
+	 * Pattern_V1 cannot appear in an unchained transform even if a broken
+	 * peer lists it in the algorithm array.
+	 */
+	server->compression.chained =
+		ctxt->Flags == SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED;
+	if (!server->compression.chained)
+		server->compression.pattern = false;
 	server->compression.enabled = true;
 }
 
-- 
2.25.1

