Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A9B35F162
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199067; cv=none; b=sg2pfndUXsAL5GsYaHJBtkZ8oO5gTst/A7RoygMj95rJYFvzXXsKMP1xXTq6owKhTTF+K0A/dtV89LMreLdH8Ui3A4yhxjXjZs9VVNmSibpBP2gcTkgGpw6TEsAxcEgycT3UiFhXduAwSplJOvZXB1mkuZcyk/eH4R1h/8tP6SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199067; c=relaxed/simple;
	bh=BnxEon0C+GvlELTDYq1cALKiI1I9EJZ2sESXUBWTMS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a4s+InNrkfNkNiYUfCqdGw65P+T+ekPfvpNdLcY1RzStNlFT8q6VUSOAjggo2cEMxY+FrGIRrkrFLl5yvs9frkV2UaL2kwMCFj8anr/lCviSfNr9DEMBkj5kstwZhP5RrUSqs0MlCJQOcly73cCqIA5AcI6YqsoAakfYxcv3rG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bruqKmNA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bruqKmNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1731F000C5;
	Sat, 17 Oct 2026 01:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199065;
	bh=ZlfGf/Z1dMeNml7ISfEH6oIjxYdgPDVqNDKvrIkqnk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bruqKmNA+H3bu/sm44GrFAXd2TfGwSmiLIExCg41M92WirCzbhH8pfGKk43yYPKSS
	 1wu9wYgRtav7Kuv7tlH3oGM3gcUm6nLUjaQP3qI68Zxgjhw9ADycoRm15LUFAgMgxt
	 FrKwM/87P1MGPNKAdhtattVShn3i7WvmHyy1EUeNLHzVTi1w27QVwdTe0wPU3DmtZd
	 JmFpnJZcFif9Gsv5AS+FLEdf/N8ZglaenIwKmMKYYuSzdZQPX/wDHyI9roLeOChB9L
	 DzDZEP8/0UDejXZFqCgxj5vzJd61vmgjci5uoPY6NXgZUZEal/cXaN0PQ8hxvsDDXn
	 7M3mlDJ0ZgJ9w==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 12/22] ksmbd: validate POSIX negotiate contexts
Date: Sat, 17 Oct 2026 10:03:34 +0900
Message-Id: <20261017010344.11478-12-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The POSIX negotiate context currently enables extensions without
checking its payload, and duplicate contexts are accepted.

Reject duplicate contexts and invalid payload lengths. Enable POSIX
extensions only for the published tag, and use the same tag constant
when building the negotiate response.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 856648d93f6e..17bd7413e137 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1431,23 +1431,7 @@ static void build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 {
 	pneg_ctxt->ContextType = SMB2_POSIX_EXTENSIONS_AVAILABLE;
 	pneg_ctxt->DataLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
-	/* SMB2_CREATE_TAG_POSIX is "0x93AD25509CB411E7B42383DE968BCD7C" */
-	pneg_ctxt->Name[0] = 0x93;
-	pneg_ctxt->Name[1] = 0xAD;
-	pneg_ctxt->Name[2] = 0x25;
-	pneg_ctxt->Name[3] = 0x50;
-	pneg_ctxt->Name[4] = 0x9C;
-	pneg_ctxt->Name[5] = 0xB4;
-	pneg_ctxt->Name[6] = 0x11;
-	pneg_ctxt->Name[7] = 0xE7;
-	pneg_ctxt->Name[8] = 0xB4;
-	pneg_ctxt->Name[9] = 0x23;
-	pneg_ctxt->Name[10] = 0x83;
-	pneg_ctxt->Name[11] = 0xDE;
-	pneg_ctxt->Name[12] = 0x96;
-	pneg_ctxt->Name[13] = 0x8B;
-	pneg_ctxt->Name[14] = 0xCD;
-	pneg_ctxt->Name[15] = 0x7C;
+	memcpy(pneg_ctxt->Name, SMB2_CREATE_TAG_POSIX, POSIX_CTXT_DATA_LEN);
 }
 
 static unsigned int assemble_neg_contexts(struct ksmbd_conn *conn,
@@ -1753,6 +1737,7 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 	unsigned int neg_ctxt_cnt = le16_to_cpu(req->NegotiateContextCount);
 	__le32 status = STATUS_INVALID_PARAMETER;
 	int compress_ctxt_cnt = 0, rdma_transform_ctxt_cnt = 0;
+	bool posix_ctxt_seen = false;
 
 	ksmbd_debug(SMB, "decoding %d negotiate contexts\n", neg_ctxt_cnt);
 	if (len_of_smb <= offset) {
@@ -1825,7 +1810,14 @@ static __le32 deassemble_neg_contexts(struct ksmbd_conn *conn,
 		} else if (pctx->ContextType == SMB2_POSIX_EXTENSIONS_AVAILABLE) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_POSIX_EXTENSIONS_AVAILABLE context\n");
-			conn->posix_ext_supported = true;
+			if (posix_ctxt_seen || clen != POSIX_CTXT_DATA_LEN) {
+				status = STATUS_INVALID_PARAMETER;
+				break;
+			}
+			posix_ctxt_seen = true;
+			if (!memcmp((char *)pctx + sizeof(*pctx),
+				    SMB2_CREATE_TAG_POSIX, POSIX_CTXT_DATA_LEN))
+				conn->posix_ext_supported = true;
 		} else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES) {
 			ksmbd_debug(SMB,
 				    "deassemble SMB2_SIGNING_CAPABILITIES context\n");
-- 
2.25.1

