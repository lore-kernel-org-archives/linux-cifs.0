Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B053D265CA7
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744208076; cv=none; b=oZdxwfnXVT/pK/IqWXtgtCo8f/5sACFGD8FqAx0+VUZV0Uow5uLHzh3J+9mTGVEa++CMQoG33Dgx1qeI4GBI7Ht2Xa517mQwyIBKqMx2iiBjV0+MWcgq7kI0vBLsEcGPvS7p1ULXtYDyQEhay/v/32VKAPdp6X/TCXa4sOo4FKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744208076; c=relaxed/simple;
	bh=ig/89DMxUZRoTTfVGmtoJ+4FqXgsPG3h3p/esxtGHTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BXctV7KPwvPIyGoCke/7MHketL5LoDkCi5zpLEHe4aXaDSmAWQ35rRcb/ghfvoSq+oUi1PYIud8DMS19Qpgv261KqMO8ISCLyjIdYob+LV/K5JGfp+5urlX9mmnroikigrYkKRcsXxiAkYWWhjJ4ralf6cNPdZKXa/zIusb1vww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=TRQcbWVl; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="TRQcbWVl"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1744208067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=X8fPUdhjYgOjhWDJfJDEIZ7jjB6gfcKWpw4EW8m6D9I=;
	b=TRQcbWVlLtcoW8RZyAfhhfuPakFExMNrJsgrKjX8rF5w+77XxG+KUQbv3l2qhI0/yR2LpE
	z5FKu2yDOq10hp/GTaPtJvvxVADrjPuvFP3mBh8O0W0uP/fHIJ/wtJ+Y6C68/twxMVSzH+
	MzihSdE7SSoYYn0zaCLZDbl6nL280qSVbm8FZQ2kl5QrABeq/Jv5rjT1EK2rqX7AlcUqgO
	gRvWJV1xqMxT2kQQsvU2P6qocE7ZCrOZhoMiu7wQ+idKZhCHC2ZWBMKS7vxJ6FycsWiUQq
	5pFwE72m7fzHAUuA4xaN8LX9AyetaenUXC+HiRhk/nN94bLc+HA7LyZtc1mHig==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH] smb: client: fix UAF in decryption with multichannel
Date: Wed,  9 Apr 2025 11:14:21 -0300
Message-ID: <20250409141421.154510-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit f7025d861694 ("smb: client: allocate crypto only for
primary server") and commit b0abcd65ec54 ("smb: client: fix UAF in
async decryption"), the channels started reusing AEAD TFM from primary
channel to perform synchronous decryption, but that can't done as
there could be multiple cifsd threads (one per channel) simultaneously
accessing it to perform decryption.

This fixes the following KASAN splat when running fstest generic/249
with 'vers=3.1.1,multichannel,max_channels=4,seal' against Windows
Server 2022:

BUG: KASAN: slab-use-after-free in gf128mul_4k_lle+0xba/0x110
Read of size 8 at addr ffff8881046c18a0 by task cifsd/986
CPU: 3 UID: 0 PID: 986 Comm: cifsd Not tainted 6.15.0-rc1 #1
PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-3.fc41
04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x5d/0x80
 print_report+0x156/0x528
 ? gf128mul_4k_lle+0xba/0x110
 ? __virt_addr_valid+0x145/0x300
 ? __phys_addr+0x46/0x90
 ? gf128mul_4k_lle+0xba/0x110
 kasan_report+0xdf/0x1a0
 ? gf128mul_4k_lle+0xba/0x110
 gf128mul_4k_lle+0xba/0x110
 ghash_update+0x189/0x210
 shash_ahash_update+0x295/0x370
 ? __pfx_shash_ahash_update+0x10/0x10
 ? __pfx_shash_ahash_update+0x10/0x10
 ? __pfx_extract_iter_to_sg+0x10/0x10
 ? ___kmalloc_large_node+0x10e/0x180
 ? __asan_memset+0x23/0x50
 crypto_ahash_update+0x3c/0xc0
 gcm_hash_assoc_remain_continue+0x93/0xc0
 crypt_message+0xe09/0xec0 [cifs]
 ? __pfx_crypt_message+0x10/0x10 [cifs]
 ? _raw_spin_unlock+0x23/0x40
 ? __pfx_cifs_readv_from_socket+0x10/0x10 [cifs]
 decrypt_raw_data+0x229/0x380 [cifs]
 ? __pfx_decrypt_raw_data+0x10/0x10 [cifs]
 ? __pfx_cifs_read_iter_from_socket+0x10/0x10 [cifs]
 smb3_receive_transform+0x837/0xc80 [cifs]
 ? __pfx_smb3_receive_transform+0x10/0x10 [cifs]
 ? __pfx___might_resched+0x10/0x10
 ? __pfx_smb3_is_transform_hdr+0x10/0x10 [cifs]
 cifs_demultiplex_thread+0x692/0x1570 [cifs]
 ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
 ? rcu_is_watching+0x20/0x50
 ? rcu_lockdep_current_cpu_online+0x62/0xb0
 ? find_held_lock+0x32/0x90
 ? kvm_sched_clock_read+0x11/0x20
 ? local_clock_noinstr+0xd/0xd0
 ? trace_irq_enable.constprop.0+0xa8/0xe0
 ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
 kthread+0x1fe/0x380
 ? kthread+0x10f/0x380
 ? __pfx_kthread+0x10/0x10
 ? local_clock_noinstr+0xd/0xd0
 ? ret_from_fork+0x1b/0x60
 ? local_clock+0x15/0x30
 ? lock_release+0x29b/0x390
 ? rcu_is_watching+0x20/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x31/0x60
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Cc: David Howells <dhowells@redhat.com>
Reported-by: Steve French <stfrench@microsoft.com>
Closes: https://lore.kernel.org/r/CAH2r5mu6Yc0-RJXM3kFyBYUB09XmXBrNodOiCVR4EDrmxq5Szg@mail.gmail.com
Fixes: f7025d861694 ("smb: client: allocate crypto only for primary server")
Fixes: b0abcd65ec54 ("smb: client: fix UAF in async decryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifsencrypt.c | 16 +++++-----------
 fs/smb/client/smb2ops.c     |  6 +++---
 fs/smb/client/smb2pdu.c     | 11 ++---------
 3 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index e69968e88fe7..35892df7335c 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -704,18 +704,12 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 	cifs_free_hash(&server->secmech.md5);
 	cifs_free_hash(&server->secmech.sha512);
 
-	if (!SERVER_IS_CHAN(server)) {
-		if (server->secmech.enc) {
-			crypto_free_aead(server->secmech.enc);
-			server->secmech.enc = NULL;
-		}
-
-		if (server->secmech.dec) {
-			crypto_free_aead(server->secmech.dec);
-			server->secmech.dec = NULL;
-		}
-	} else {
+	if (server->secmech.enc) {
+		crypto_free_aead(server->secmech.enc);
 		server->secmech.enc = NULL;
+	}
+	if (server->secmech.dec) {
+		crypto_free_aead(server->secmech.dec);
 		server->secmech.dec = NULL;
 	}
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 41d8cd20b25f..3f7fe74688a9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4555,9 +4555,9 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 			return rc;
 		}
 	} else {
-		if (unlikely(!server->secmech.dec))
-			return -EIO;
-
+		rc = smb3_crypto_aead_allocate(server);
+		if (unlikely(rc))
+			return rc;
 		tfm = server->secmech.dec;
 	}
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 81e05db8e4d5..c4d52bebd37d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1252,15 +1252,8 @@ SMB2_negotiate(const unsigned int xid,
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
 	}
 
-	if (server->cipher_type && !rc) {
-		if (!SERVER_IS_CHAN(server)) {
-			rc = smb3_crypto_aead_allocate(server);
-		} else {
-			/* For channels, just reuse the primary server crypto secmech. */
-			server->secmech.enc = server->primary_server->secmech.enc;
-			server->secmech.dec = server->primary_server->secmech.dec;
-		}
-	}
+	if (server->cipher_type && !rc)
+		rc = smb3_crypto_aead_allocate(server);
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
-- 
2.49.0

