Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D5E359A6C;
	Tue, 10 Mar 2026 19:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172271; cv=none; b=lOxShIoAkgSCJX5Co6XRYvqJ1YodkqnYssJQyq+672enQcINIKzsPSrpMw3ewEQeA+s4MMDGmvWQEPPFzMuM+NxO3xoUHTZPD7RzP+B36Ng2HCHRrdLTFWKMJcpSHGwEiRQQjSzrzZFcY1V5VAoHJOJpWnuWbRnYMXA3SpNIbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172271; c=relaxed/simple;
	bh=wEEkUnSNpTrETGrKsNZ/O4l0unHxZBqqEVrAp+ZKrjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ksOaSdYErQcrhxYOzrgqzyagp/YpT31juyCk9AwMBJwFLRr61wEo8OsMH2CPxTow+gXYM62j7Z7ZbH19GVL2pLrhWfGO2p3Ib9Lei3ipAV4ItAlJIchtEC4noTHOyox5aMeR4MBC00JOhwLuEzCKvFZlhyAYVJUAqkneWC2Pjo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPaczcva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPaczcva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D184C19423;
	Tue, 10 Mar 2026 19:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172270;
	bh=wEEkUnSNpTrETGrKsNZ/O4l0unHxZBqqEVrAp+ZKrjk=;
	h=From:To:Cc:Subject:Date:From;
	b=sPaczcvalMUPy0JokP8kFwQveTDfGHJflqPNTZSqkQeMa01TtSpwUjj5kQm67fGY7
	 I8uUxdtJGhiIuMNu7Eh6fhkNxXBiBIcsKIxS14cwY9upaG8CuNDxrUF9LblcAkRDPN
	 QP84NORdjLlWKa71SErfByaHasP8Mtu9b7JnsGfbSx/Snn+s478SOtOY/T+uDvVbOu
	 8LSX6CYcwCKJUcljLq+YZPRxDMgHFhl7HsAfwSUFpmR3C+DKSYeB2h2zCq/dMqQMbw
	 nNDgLL5uYunJba8x7FWKIjTO9MMUMd0aMFT2XqAYQhIvi3KoPHNc4oK6oXB95nyfR3
	 5KetcFbo98whw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15] smb: client: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:51:07 -0700
Message-ID: <20260310195107.70729-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 26bc83b88bbbf054f0980a4a42047a8d1e210e4c upstream.

To prevent timing attacks, MAC comparisons need to be constant-time.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsencrypt.c   | 3 ++-
 fs/cifs/smb2transport.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index d118282071b37..981347ee94143 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -21,10 +21,11 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include "../smbfs_common/arc4.h"
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct TCP_Server_Info *server, char *signature,
 			struct shash_desc *shash)
 {
@@ -240,11 +241,11 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 		return rc;
 
 /*	cifs_dump_mem("what we think it should be: ",
 		      what_we_think_sig_should_be, 16); */
 
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
 		return 0;
 
 }
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index ffae3a7f46ce4..df840fda1ab8a 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -17,10 +17,11 @@
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 #include "smb2pdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
@@ -674,11 +675,12 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = server->ops->calc_signature(rqst, server, true);
 
 	if (rc)
 		return rc;
 
-	if (memcmp(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(server_response_sig, shdr->Signature,
+			  SMB2_SIGNATURE_SIZE)) {
 		cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx\n",
 			shdr->Command, shdr->MessageId);
 		return -EACCES;
 	} else
 		return 0;

base-commit: 91d48252ad4b17577cf8cc8d3e1353402e4da8f1
-- 
2.53.0

