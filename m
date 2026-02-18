Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EE52F6928;
	Wed, 18 Feb 2026 04:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771388920; cv=none; b=VDqK+hd47p47tRqFbmsZ7qdGSIrwKU18j9wmwKMAiKwbR53sXIzDZ/mhsJLA+TQLcCp9ZmL0CwrSf2FGxbJ3+IKg1Y/NKSKM9fdG9eXjXgSynK7u2t1ZW/CS1BTAeItibZM/1iqEzCVEV1Lhl6wmLzTQC2EidDYrsAAKUYfxpV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771388920; c=relaxed/simple;
	bh=iy6RL7DwhoHeBMOhkBhLnVCwrgpiHotFkB/zdfz+Y6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HXutxs50T4/G9EtZTzD5eUwONyWHxmUU4grKEWjTUvwme2bebK+N4tydtXP6WIc8HXpbkQANgoRI8aIACL8L5NK0KhFmqCOJIj6mHJvHmVtm+Pf2kb9FeiFgrIK2lB1ibX2/nh2vKzx7hljTxGuZ30XELRc+EwCeH32bpVQ2ME8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7uCHhcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7uCHhcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92964C19422;
	Wed, 18 Feb 2026 04:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771388920;
	bh=iy6RL7DwhoHeBMOhkBhLnVCwrgpiHotFkB/zdfz+Y6M=;
	h=From:To:Cc:Subject:Date:From;
	b=c7uCHhcxEnJef71GWQ2x6eNHs7T5bJ0Ewl1BkCBKF8An7DjZYCaYgcKxdIwlXVGsF
	 /im4EyDdtScphtv1HDTGDyyCaLW3mOSFksnbvrAKmT2k1F5W/t22b32pc56HC1ze1B
	 U6XF8TgKwvF97rgbqnk3Sed+nNu2jYIPC7k5AZSZrFZsSMjHySkQsxMJdrPOjHcLpe
	 e8cjbcmQQN6GFR1rJfSpFPPAvwYC6V2voBIp58IpLqdK9aNhYjMp/jNJ7IcQl3Ye42
	 Ksg/Nq8KMSThXJBsGSBU5EQhhvEyWMOH+ooypkjbW33bDsO1k+qbslVfcYtgJoGwqF
	 uAfwuxGd9UrBg==
From: Eric Biggers <ebiggers@kernel.org>
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org,
	linux-crypto@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: Compare MACs in constant time
Date: Tue, 17 Feb 2026 20:27:02 -0800
Message-ID: <20260218042702.67907-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent timing attacks, MAC comparisons need to be constant-time.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/smb1encrypt.c   | 3 ++-
 fs/smb/client/smb2transport.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
index 0dbbce2431ff..bf10fdeeedca 100644
--- a/fs/smb/client/smb1encrypt.c
+++ b/fs/smb/client/smb1encrypt.c
@@ -9,10 +9,11 @@
  *
  */
 
 #include <linux/fips.h>
 #include <crypto/md5.h>
+#include <crypto/utils.h>
 #include "cifsproto.h"
 #include "smb1proto.h"
 #include "cifs_debug.h"
 
 /*
@@ -129,11 +130,11 @@ int cifs_verify_signature(struct smb_rqst *rqst,
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
index 8b9000a83181..81be2b226e26 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -18,10 +18,11 @@
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
 #include <crypto/sha2.h>
+#include <crypto/utils.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "../common/smb2status.h"
@@ -615,11 +616,12 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = smb3_calc_signature(rqst, server, true);
 
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

base-commit: 2961f841b025fb234860bac26dfb7fa7cb0fb122
-- 
2.53.0

