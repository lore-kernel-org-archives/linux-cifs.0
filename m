Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEBB1D5CD4;
	Sun, 12 Oct 2025 01:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234385; cv=none; b=rkg/cw7MEdnDzc1HMyH0CiAJcL9hPdEjXK0E+H9JIHyTr5A+Qnqjl7cj/C5wyEeX5W93jailX75pmgZPBW+SLMlNYtWKP5j/7ilpWqOZZmbHpkzoJp+TApmLpb/KsAMVO9G7uheUptiVbwdp3MM402HxQvB0aPf8ObeXTS0hZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234385; c=relaxed/simple;
	bh=gce5OUBuQc+Smg+z6s1ygjYENWqF7SJkJMMmMZMOOlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8cNSLpLhuPdDBorZXI3F6QFuvi5uqVp54r6KNcuWBYCg8OZyeNl9Y24tEN5fXRuQGD2lc0JngLoCR7cDKl75LoXUXozRUK5dzYnsGlBjsObY6s7LOwnKcPtDKtC/DvB61ohXPDABxiJL7aGZF7loJg3KGLoeeYgaVFqguxj+b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOFa2Bgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOFa2Bgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2841C116B1;
	Sun, 12 Oct 2025 01:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234385;
	bh=gce5OUBuQc+Smg+z6s1ygjYENWqF7SJkJMMmMZMOOlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOFa2BgfmrnYt+k/zVIQi5A9Wk/A4ED+EuqcaUmW4vXpAVYR8NzprTQBkGMKK5FXB
	 R6I8IQoKlWRD0gZSEOFcml9VksATsuEGH/VnUWOhljv8HDNUXQRAXGosI9iMjwOmXp
	 G05ABTRcYlnmzRyBVuDx7rJgyfUFaNM7xnfiLXxunkzkNnhzMhmdn2DOBT8YO4/rPX
	 WH5lsxHRKZQEVGA+8ri7GrjU5XjkapQrlQkqWMMiOao7OjL0zLCtmJB/m6htFt06gS
	 S/VkCNm2eIWHMNIuoX2smph16xRf/WhjuBe+LLBqqJ3wXsmQEMsK7017I3TLqSkODm
	 A7F1AA4qzGxig==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: samba-technical@lists.samba.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/8] smb: client: Use SHA-512 library for SMB3.1.1 preauth hash
Date: Sat, 11 Oct 2025 18:57:31 -0700
Message-ID: <20251012015738.244315-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251012015738.244315-1-ebiggers@kernel.org>
References: <20251012015738.244315-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert smb311_update_preauth_hash() to use the SHA-512 library instead
of a "sha512" crypto_shash.  This is simpler and faster.  With the
library there's no need to allocate memory, no need to handle errors,
and the SHA-512 code is accessed directly without inefficient indirect
calls and other unnecessary API overhead.

Remove the call to smb311_crypto_shash_allocate() from
smb311_update_preauth_hash(), since it appears to have been needed only
to allocate the "sha512" crypto_shash.  (It also had the side effect of
allocating the "cmac(aes)" crypto_shash, but that's also done in
generate_key() which is where the AES-CMAC key is initialized.)

For now the "sha512" crypto_shash is still being allocated elsewhere.
It will be removed in a later commit.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig     |  1 +
 fs/smb/client/smb2misc.c  | 53 +++++++++------------------------------
 fs/smb/client/smb2proto.h |  6 ++---
 3 files changed, 16 insertions(+), 44 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index a4c02199fef48..4ac79ff5649bf 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -14,10 +14,11 @@ config CIFS
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_LIB_ARC4
+	select CRYPTO_LIB_SHA512
 	select KEYS
 	select DNS_RESOLVER
 	select ASN1
 	select OID_REGISTRY
 	select NETFS_SUPPORT
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 89d933b4a8bc2..96bfe4c63ccf9 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -5,10 +5,11 @@
  *                 Etersoft, 2012
  *   Author(s): Steve French (sfrench@us.ibm.com)
  *              Pavel Shilovsky (pshilovsky@samba.org) 2012
  *
  */
+#include <crypto/sha2.h>
 #include <linux/ctype.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
@@ -886,17 +887,17 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
  * @ses:	server session structure
  * @server:	pointer to server info
  * @iov:	array containing the SMB request we will send to the server
  * @nvec:	number of array entries for the iov
  */
-int
+void
 smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 			   struct kvec *iov, int nvec)
 {
-	int i, rc;
+	int i;
 	struct smb2_hdr *hdr;
-	struct shash_desc *sha512 = NULL;
+	struct sha512_ctx sha_ctx;
 
 	hdr = (struct smb2_hdr *)iov[0].iov_base;
 	/* neg prot are always taken */
 	if (hdr->Command == SMB2_NEGOTIATE)
 		goto ok;
@@ -905,54 +906,24 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	 * If we process a command which wasn't a negprot it means the
 	 * neg prot was already done, so the server dialect was set
 	 * and we can test it. Preauth requires 3.1.1 for now.
 	 */
 	if (server->dialect != SMB311_PROT_ID)
-		return 0;
+		return;
 
 	if (hdr->Command != SMB2_SESSION_SETUP)
-		return 0;
+		return;
 
 	/* skip last sess setup response */
 	if ((hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
 	    && (hdr->Status == NT_STATUS_OK
 		|| (hdr->Status !=
 		    cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))))
-		return 0;
+		return;
 
 ok:
-	rc = smb311_crypto_shash_allocate(server);
-	if (rc)
-		return rc;
-
-	sha512 = server->secmech.sha512;
-	rc = crypto_shash_init(sha512);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init sha512 shash\n", __func__);
-		return rc;
-	}
-
-	rc = crypto_shash_update(sha512, ses->preauth_sha_hash,
-				 SMB2_PREAUTH_HASH_SIZE);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update sha512 shash\n", __func__);
-		return rc;
-	}
-
-	for (i = 0; i < nvec; i++) {
-		rc = crypto_shash_update(sha512, iov[i].iov_base, iov[i].iov_len);
-		if (rc) {
-			cifs_dbg(VFS, "%s: Could not update sha512 shash\n",
-				 __func__);
-			return rc;
-		}
-	}
-
-	rc = crypto_shash_final(sha512, ses->preauth_sha_hash);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not finalize sha512 shash\n",
-			 __func__);
-		return rc;
-	}
-
-	return 0;
+	sha512_init(&sha_ctx);
+	sha512_update(&sha_ctx, ses->preauth_sha_hash, SMB2_PREAUTH_HASH_SIZE);
+	for (i = 0; i < nvec; i++)
+		sha512_update(&sha_ctx, iov[i].iov_base, iov[i].iov_len);
+	sha512_final(&sha_ctx, ses->preauth_sha_hash);
 }
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index b3f1398c9f790..e7cda885c39f0 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -294,13 +294,13 @@ extern int smb2_validate_and_copy_iov(unsigned int offset,
 				      unsigned int minbufsize, char *data);
 extern void smb2_copy_fs_info_to_kstatfs(
 	 struct smb2_fs_full_size_info *pfs_inf,
 	 struct kstatfs *kst);
 extern int smb311_crypto_shash_allocate(struct TCP_Server_Info *server);
-extern int smb311_update_preauth_hash(struct cifs_ses *ses,
-				      struct TCP_Server_Info *server,
-				      struct kvec *iov, int nvec);
+extern void smb311_update_preauth_hash(struct cifs_ses *ses,
+				       struct TCP_Server_Info *server,
+				       struct kvec *iov, int nvec);
 extern int smb2_query_info_compound(const unsigned int xid,
 				    struct cifs_tcon *tcon,
 				    const char *path, u32 desired_access,
 				    u32 class, u32 type, u32 output_len,
 				    struct kvec *rsp, int *buftype,
-- 
2.51.0

