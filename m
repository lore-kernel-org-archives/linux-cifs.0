Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A989C35A38A;
	Tue, 10 Mar 2026 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773172267; cv=none; b=tm7qxLAce8jYT3nPprQVRels9hx+kSU2dZisbm7/EBMAjelA0YhIuWVIrmUvsuE03cKPFj9HFnHQDTTO71h+ldDVExZevwc9Nm0AZLDBR+DrsaUfxqprtD75wClUcWU84qtwK90oZlQpwQAb9Be+4xwgJbSDza7ZaTWJ5jklLSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773172267; c=relaxed/simple;
	bh=PHVqUmdZOJoCMt1Z2VcfyTE7sGV0SetRg8yMWp20OkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kl2yJ86VU43C5WAiTPUUNjFQWZc/sn0a3zW4Oz/wSqJnPY/A8V6fTUGzzFGgsnWrgvYm4H5oJpkgEkt9ujaZeU1ZUX/HyAG0cyZKa8M0lbxUhLP/Rp15UCwOnh8GiLVg4vq51Ayaa9kA1fGFOJHNPgNCF/7knD3KcGR6w5ftH/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvKQoaJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvKQoaJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3F6C19423;
	Tue, 10 Mar 2026 19:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172267;
	bh=PHVqUmdZOJoCMt1Z2VcfyTE7sGV0SetRg8yMWp20OkI=;
	h=From:To:Cc:Subject:Date:From;
	b=lvKQoaJwEl9VFCiAKvp5nfgXxOlSV+4li4sni0hylLks/6hWQT+dzpQ4YcaFrbcrA
	 N/swEd0egd964vxTXBetj3krrhVOKGwzbiYoQhLIXEDEm9cPtvK+MuTCQKLqkbom7O
	 35DOP5FkmM/tG/9iui7B51nUjrtF0qAGDTqhPSgPA2KPECY0vAa0lxfjmAmZNkwS03
	 Jlavg8j0Xq9Zp5UZHTMEmBEIPT6kB1p+EB39zocwteLv0mjZ0AW/XVBGJ7YgKPPC7c
	 4K5MQVwexNK9y5qWv38tB9kTYIHSdb74nRqPsMBfHO5U937CeXEcRqX2n3E7rtMyfE
	 uazen/Gd1YriA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1] smb: client: Compare MACs in constant time
Date: Tue, 10 Mar 2026 12:51:03 -0700
Message-ID: <20260310195103.70705-1-ebiggers@kernel.org>
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
 fs/smb/client/cifsencrypt.c   | 3 ++-
 fs/smb/client/smb2transport.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index d3d4cf6321fd5..743098804edcc 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -21,10 +21,11 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include "../common/arc4.h"
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct TCP_Server_Info *server, char *signature,
 			struct shash_desc *shash)
 {
@@ -241,11 +242,11 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 		return rc;
 
 /*	cifs_dump_mem("what we think it should be: ",
 		      what_we_think_sig_should_be, 16); */
 
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (crypto_memneq(server_response_sig, what_we_think_sig_should_be, 8))
 		return -EACCES;
 	else
 		return 0;
 
 }
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 763cf946e8491..73d281abd265a 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -17,10 +17,11 @@
 #include <linux/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "smb2status.h"
@@ -697,11 +698,12 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
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

base-commit: f2ddafa93a259310ca47507153b7811ec54ab7fd
-- 
2.53.0

