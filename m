Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEC320126A;
	Sun, 12 Oct 2025 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234388; cv=none; b=YdH283ce9059970rJ+vu3n7/ZoWneLZSbztYyrPbbxOAM+5ooW8Llsrn3l3v9K8eQSUTXn0diPAyVTHR4GMezdKf2tWDePJJVciB5fkE7kOo476sdzkbWQ0KV08BgjGRBiS9tlWRBCL3LUnHRfQBP14XhchuE8Rlj6157ul9VmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234388; c=relaxed/simple;
	bh=68uQaOv1+uvhvQouwuek8F2wnHh0nnIbcccW1KgVb2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7fjjZQGLXVMgjMTgqV4p3dG4fvr00020CYAkQy7VFudzRN/+AShVo/TW5qIIPCYR8/lYuNSEZ+Eu377VZtWwCgQijTzUG7GSG1fKegKusVDNTHM4WL/ot4tHmZEI2fB/8gkhUdGV0wmjVQflhpRjQE9cNDOR5vr1jrVzsgaJag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FbM0R5dj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FbM0R5dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A54DC116C6;
	Sun, 12 Oct 2025 01:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234388;
	bh=68uQaOv1+uvhvQouwuek8F2wnHh0nnIbcccW1KgVb2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbM0R5djZTm0S99UUljKvf6qqa7s0wQ5i/slLm0bWAmG0y3kNMwAcz73FapbTXCl2
	 B7YixY/GU6hExfPP5ZSRcPhzyQBhpDFKjL+Bh2xh1KjPM0rXXpQpgVO9+T76lo2CiL
	 P6wVjwB5DQTyIY9octvl/B7bcuMsw51YhvE/EbiO5zSB4V2TGZe+pI28TkDHLjeEVw
	 S+Yzja43QlhGQaLudM8BupaX1fQV7cMF1Q1a3vAzVNCwONO0LubdRGf4A/yRfjWLKE
	 GjjRzqlokfgS+4nZ9P9pc6RShNo4L6IoXDvjhYr1P0QOB/dVHqGssFaDqYMGrS/IbA
	 SiodS1DlZ084Q==
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
Subject: [PATCH 8/8] smb: client: Consolidate cmac(aes) shash allocation
Date: Sat, 11 Oct 2025 18:57:38 -0700
Message-ID: <20251012015738.244315-9-ebiggers@kernel.org>
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

Now that smb3_crypto_shash_allocate() and smb311_crypto_shash_allocate()
are identical and only allocate "cmac(aes)", delete the latter and
replace the call to it with the former.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/sess.c          |  2 +-
 fs/smb/client/smb2proto.h     |  2 +-
 fs/smb/client/smb2transport.c | 10 +---------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 0a8c2fcc9dedf..ef3b498b0a02a 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -582,11 +582,11 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	/*
 	 * We need to allocate the server crypto now as we will need
 	 * to sign packets before we generate the channel signing key
 	 * (we sign with the session key)
 	 */
-	rc = smb311_crypto_shash_allocate(chan->server);
+	rc = smb3_crypto_shash_allocate(chan->server);
 	if (rc) {
 		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
 		mutex_unlock(&ses->session_mutex);
 		goto out;
 	}
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index e7cda885c39f0..6eb86d134abcc 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -293,11 +293,11 @@ extern int smb2_validate_and_copy_iov(unsigned int offset,
 				      struct kvec *iov,
 				      unsigned int minbufsize, char *data);
 extern void smb2_copy_fs_info_to_kstatfs(
 	 struct smb2_fs_full_size_info *pfs_inf,
 	 struct kstatfs *kst);
-extern int smb311_crypto_shash_allocate(struct TCP_Server_Info *server);
+extern int smb3_crypto_shash_allocate(struct TCP_Server_Info *server);
 extern void smb311_update_preauth_hash(struct cifs_ses *ses,
 				       struct TCP_Server_Info *server,
 				       struct kvec *iov, int nvec);
 extern int smb2_query_info_compound(const unsigned int xid,
 				    struct cifs_tcon *tcon,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index cd689bc27bfdc..ad6068e17a2a9 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -25,20 +25,12 @@
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "../common/smb2status.h"
 #include "smb2glob.h"
 
-static int
-smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
-{
-	struct cifs_secmech *p = &server->secmech;
-
-	return cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
-}
-
 int
-smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
+smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
 
 	return cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
 }
-- 
2.51.0

