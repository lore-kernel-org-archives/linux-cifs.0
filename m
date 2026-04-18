Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568EB34D38B;
	Sat, 18 Apr 2026 22:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776550419; cv=none; b=XQvqmY65rsPCyrjlkOa2WIsvoagAFSGctcpybqeIyR+7N5xM4K71lI90tEbqJZnRihsFqwt56D6sOMlFJEqL0jz424SYLU6r60Dg44cgxB38z70V3h6RBmxt3oViQvt3bsHQIzyH/fa+osJBsGJbk7xX2U1n9cBkEN1IXN53edY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776550419; c=relaxed/simple;
	bh=eTsIDIxopVM+5A5oT4iuxnfMSgbLRaGCewtHDCKsjCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7PewkhAoz1OIKcLAqstwSYQr/iiRA9V3bVTMpQE5eYXMS32ws02X2jT2XYrxBmarACIVvg9RcMfLKU6mMnEVJDFhaJTxRfXM+DInCgxzfqLlNUOMzhRyyjLwXHUtKR9WQD3yVtYV0nbXziFE7dLRtIx9NH1wb7dTFjPMi6HJwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lry040TP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lry040TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC561C2BCB4;
	Sat, 18 Apr 2026 22:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776550419;
	bh=eTsIDIxopVM+5A5oT4iuxnfMSgbLRaGCewtHDCKsjCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lry040TP3pMbpX4EAV0kFVFUECdbwIjtTxYVh9s+nwRLkU97NPInG6w871CRgzhjr
	 hLBoUDbX61RCXdvZWJ9UVKPAMOUIr0ynyFRs3EeAGfUbbXd8XTGL/2je92xapTFjhs
	 nmxI+qYgPVfrzyublsVwTPVTM/sIn+WfTx/lx9PCIDxjxA9vD10nkl93B+mY4gvX6S
	 9Gv8p3ELObZOkAiURNWBCWFG+LbqkRAnsfI3l4rVAVERLQvxqZpgf6kfpLDtZM5zGV
	 Hk18WYZHKQfNWoPUvTmQ1wJs5NjuNtdSVfgQeB7s7pUYuVVAyZz7tOnnvAv7bw9gn2
	 oHp4t5z4dQC3w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: linux-crypto@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 4/4] smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()
Date: Sat, 18 Apr 2026 15:13:11 -0700
Message-ID: <20260418221311.67583-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418221311.67583-1-ebiggers@kernel.org>
References: <20260418221311.67583-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the crypto library API is now being used instead of crypto_shash,
all structs for MAC computation are now just fixed-size structs
allocated on the stack; no dynamic allocations are ever required.
Besides being much more efficient, this also means that the
'allocate_crypto' argument to smb2_calc_signature() and
smb3_calc_signature() is no longer used.  Remove this unused argument.

Acked-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/smb2transport.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 0176185a1efcb..41009039b4cbe 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -202,12 +202,11 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 
 	return tcon;
 }
 
 static int
-smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
-		    bool allocate_crypto)
+smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int rc;
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
@@ -438,12 +437,11 @@ generate_smb311signingkey(struct cifs_ses *ses,
 
 	return generate_smb3signingkey(ses, server, &triplet);
 }
 
 static int
-smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
-		    bool allocate_crypto)
+smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
@@ -451,11 +449,11 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct aes_cmac_ctx cmac_ctx;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
 	if (server->vals->protocol_id <= SMB21_PROT_ID)
-		return smb2_calc_signature(rqst, server, allocate_crypto);
+		return smb2_calc_signature(rqst, server);
 
 	rc = smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
 	if (unlikely(rc)) {
 		cifs_server_dbg(FYI, "%s: Could not get signing key\n", __func__);
 		return rc;
@@ -522,11 +520,11 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	if (!is_binding && !server->session_estab) {
 		strscpy(shdr->Signature, "BSRSPYL");
 		return 0;
 	}
 
-	return smb3_calc_signature(rqst, server, false);
+	return smb3_calc_signature(rqst, server);
 }
 
 int
 smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
@@ -558,11 +556,11 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	 */
 	memcpy(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE);
 
 	memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
-	rc = smb3_calc_signature(rqst, server, true);
+	rc = smb3_calc_signature(rqst, server);
 
 	if (rc)
 		return rc;
 
 	if (crypto_memneq(server_response_sig, shdr->Signature,
-- 
2.53.0

