Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC6E72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046190; cv=none; b=RDvp6wTKyrDHe0Ye670Tn2i5cuZ+AltpTf/MPcniGVsyIYPJ1GRXIp4c5Zjy1rLuJU7Ch4Rjs3HhPV5/AagQnnRYpjhp987HhZ/qDpBhbagP6iyOGjl6GGNBin4CzQCD0UFSmUxXkaeV4t3wU8a/L33B7shKFP47uI+xgHdOefE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046190; c=relaxed/simple;
	bh=1iCka0K1aW8pk2fAGXTXpIVBwT2W6kU1ka97da1sit8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HvzKkwNF5Fsg3/gLh+zFbON3sdV1Z3cNBu9wEISxOMsZJ1pbGVBFv6mYcZGZ8Hqn25wU4MyMOze3V/PWcynfNqcn5wXcfOopgPfeQDgru6VDVepevqu4Wh6uw4iMR3l7/hWSa/3PlJ5zzD8iHYRjIMJfNogYWMsivDG0g+8J4iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OsZVHo4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OsZVHo4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C065F1F000E9;
	Sun, 21 Jun 2026 12:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046189;
	bh=fkEwc2Ipi4iJLSzzSRePl5mfB3gUBdJXhSG6j3j7jdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsZVHo4ZEHgl4FMYtM/liQf5tpYSlvly0IiKj4lFvw4tkBVvk3r/CcVMpA1vXf2En
	 Rt8DTyblzxonYM4DgzC9RPjqCcIWDaXM/kEpzMdXgEpkasqpq9LlsFdeKh0fl89km0
	 d+FVr8Of9DoR0bRucCl+xb7MKm8Rm0NMBJqqXHaOdtkxF7IkDQAIlN/8QZEgwqpu+A
	 +DMH4jSWXDkHjj5puE/aBUtAU3w0k9t7praVqOpY313i15PsRg8FhDFW9q2Zb/XKhE
	 mkF5k5GJXMuN4Us4DK8uHut6JO0nlnNp4ZdxYx+Wf4z9Z0d7/y3EwozLTklysiBlYn
	 fSqsBwbjkAWnQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 29/29] ksmbd: fix UBSAN array-index-out-of-bounds in decode_compress_ctxt()
Date: Sun, 21 Jun 2026 21:48:44 +0900
Message-Id: <20260621124844.6235-29-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

decode_compress_ctxt() walks CompressionAlgorithms[] using the client
supplied CompressionAlgorithmCount. That field is declared in
struct smb2_compression_capabilities_context as a fixed 4-element array,
but the number of algorithms is actually variable and clients such as
Windows advertise more than four (e.g. LZ77, LZ77+Huffman, LZNT1,
Pattern_V1 and LZ4).

The on-wire context length is already validated, so the access is within
the received buffer, but indexing the statically sized [4] array makes
UBSAN report an out-of-bounds access:

  UBSAN: array-index-out-of-bounds in smb2pdu.c:1122:48
  index 4 is out of range for type '__le16 [4]'
  Call Trace:
   smb2_handle_negotiate+0xda7/0xde0 [ksmbd]
   ksmbd_smb_negotiate_common+0x27b/0x3e0 [ksmbd]
   smb2_negotiate_request+0x14/0x20 [ksmbd]
   handle_ksmbd_work+0x181/0x500 [ksmbd]

Walk the algorithms through a pointer so the fixed-array bounds check is
not applied, while keeping the existing length validation that bounds the
loop to the data actually received.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 778677ec3361..8198590c9345 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1094,6 +1094,7 @@ static __le32 decode_compress_ctxt(struct ksmbd_conn *conn,
 				   int ctxt_len)
 {
 	int alg_cnt, algs_size, i;
+	__le16 *algs;
 
 	if (sizeof(struct smb2_neg_context) + 10 > ctxt_len) {
 		pr_err("Invalid SMB2_COMPRESSION_CAPABILITIES context length\n");
@@ -1118,8 +1119,15 @@ static __le32 decode_compress_ctxt(struct ksmbd_conn *conn,
 		return STATUS_INVALID_PARAMETER;
 	}
 
+	/*
+	 * CompressionAlgorithms[] is declared as a fixed 4-element array, but
+	 * the actual element count is variable (clients such as Windows may
+	 * advertise more). The on-wire length was validated above, so walk the
+	 * algorithms through a pointer to avoid a fixed-array bounds check.
+	 */
+	algs = pneg_ctxt->CompressionAlgorithms;
 	for (i = 0; i < alg_cnt; i++) {
-		__le16 alg = pneg_ctxt->CompressionAlgorithms[i];
+		__le16 alg = algs[i];
 
 		/*
 		 * LZ77 is the required general-purpose codec. Pattern_V1 is an
-- 
2.25.1

