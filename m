Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE7E2B9BF
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 20:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732565854; cv=none; b=KYdsLGmXAxoZYmBikzdzFNlq206srA/BIQKO4YE00jOUfBywvsk1Mx9dDZMSSRb8ucPie3FDLYvlARSJ0C+fxuHh3WDE39xejob4vEE3FP3hOQdeECMjHgT0oj2SOID5dSwmVYxE6+vpr/XMtqKpBXfioNhPSkvR1Skgp74ubrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732565854; c=relaxed/simple;
	bh=Zns0QWWr/x5SQBU9W63gY1p7YIz/qPRnb6KMtORJjog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sEnCJfp5hkoioBVtyvJuxxz/IO+u3uvmHVU+aQRx9TTKrx6Bw/3Twgx+ewMFGELtoSAzM+52fNOpTsBLNU9jMbYVcfunbcz++qCz5spfjxGD4cUU9rvkESNNSlfJVZj85yva4A8WS1r1UHdgWyHfkTuzQ+S+Ly8xEbYLJXa8aag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=MBIm6k95; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="MBIm6k95"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732565848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U2ShDvkg6aZDncZn7dVgaupumXokISHBdE8N0+cfCys=;
	b=MBIm6k953SILPWfkPQHjm4/4UKoYZ+33GtgZumANjXjYAv1zwiP7HJm8aIMLPyWnaN7Uma
	Ofj1oJ0NQd/BUtMAxilOlUt34RScS2vVSK5423VJaygO9fbic2Q4Nbc7go1wcpFdhWp0jS
	6MT/SHonqovs4sAqtvXJUKHhlhrQx0VdZHlgyQq5uH1dMJ2ONnDinSr/6mozy5oWQYIXcQ
	M/q+OTrvwga07zw6nXcQdJqQH1xF9RzQaB6BCZY4Io1/OmMgZO+aLS59+iq0hNIyKFUFhj
	7V5oKfuqt7CoLivgly1gvYv9zEf9HkAenoY7575a+ZSq7QAxC+wXidP3vGm3mQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: client: fix NULL ptr deref in crypto_aead_setkey()
Date: Mon, 25 Nov 2024 17:17:23 -0300
Message-ID: <20241125201723.190140-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Neither SMB3.0 or SMB3.02 supports encryption negotiate context, so
when SMB2_GLOBAL_CAP_ENCRYPTION flag is set in the negotiate response,
the client uses AES-128-CCM as the default cipher.  See MS-SMB2
3.3.5.4.

Commit b0abcd65ec54 ("smb: client: fix UAF in async decryption") added
a @server->cipher_type check to conditionally call
smb3_crypto_aead_allocate(), but that check would always be false as
@server->cipher_type is unset for SMB3.02.

Fix the following KASAN splat by setting @server->cipher_type for
SMB3.02 as well.

mount.cifs //srv/share /mnt -o vers=3.02,seal,...

BUG: KASAN: null-ptr-deref in crypto_aead_setkey+0x2c/0x130
Read of size 8 at addr 0000000000000020 by task mount.cifs/1095
CPU: 1 UID: 0 PID: 1095 Comm: mount.cifs Not tainted 6.12.0 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-3.fc41
04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x5d/0x80
 ? crypto_aead_setkey+0x2c/0x130
 kasan_report+0xda/0x110
 ? crypto_aead_setkey+0x2c/0x130
 crypto_aead_setkey+0x2c/0x130
 crypt_message+0x258/0xec0 [cifs]
 ? __asan_memset+0x23/0x50
 ? __pfx_crypt_message+0x10/0x10 [cifs]
 ? mark_lock+0xb0/0x6a0
 ? hlock_class+0x32/0xb0
 ? mark_lock+0xb0/0x6a0
 smb3_init_transform_rq+0x352/0x3f0 [cifs]
 ? lock_acquire.part.0+0xf4/0x2a0
 smb_send_rqst+0x144/0x230 [cifs]
 ? __pfx_smb_send_rqst+0x10/0x10 [cifs]
 ? hlock_class+0x32/0xb0
 ? smb2_setup_request+0x225/0x3a0 [cifs]
 ? __pfx_cifs_compound_last_callback+0x10/0x10 [cifs]
 compound_send_recv+0x59b/0x1140 [cifs]
 ? __pfx_compound_send_recv+0x10/0x10 [cifs]
 ? __create_object+0x5e/0x90
 ? hlock_class+0x32/0xb0
 ? do_raw_spin_unlock+0x9a/0xf0
 cifs_send_recv+0x23/0x30 [cifs]
 SMB2_tcon+0x3ec/0xb30 [cifs]
 ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
 ? lock_acquire.part.0+0xf4/0x2a0
 ? __pfx_lock_release+0x10/0x10
 ? do_raw_spin_trylock+0xc6/0x120
 ? lock_acquire+0x3f/0x90
 ? _get_xid+0x16/0xd0 [cifs]
 ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
 ? cifs_get_smb_ses+0xcdd/0x10a0 [cifs]
 cifs_get_smb_ses+0xcdd/0x10a0 [cifs]
 ? __pfx_cifs_get_smb_ses+0x10/0x10 [cifs]
 ? cifs_get_tcp_session+0xaa0/0xca0 [cifs]
 cifs_mount_get_session+0x8a/0x210 [cifs]
 dfs_mount_share+0x1b0/0x11d0 [cifs]
 ? __pfx___lock_acquire+0x10/0x10
 ? __pfx_dfs_mount_share+0x10/0x10 [cifs]
 ? lock_acquire.part.0+0xf4/0x2a0
 ? find_held_lock+0x8a/0xa0
 ? hlock_class+0x32/0xb0
 ? lock_release+0x203/0x5d0
 cifs_mount+0xb3/0x3d0 [cifs]
 ? do_raw_spin_trylock+0xc6/0x120
 ? __pfx_cifs_mount+0x10/0x10 [cifs]
 ? lock_acquire+0x3f/0x90
 ? find_nls+0x16/0xa0
 ? smb3_update_mnt_flags+0x372/0x3b0 [cifs]
 cifs_smb3_do_mount+0x1e2/0xc80 [cifs]
 ? __pfx_vfs_parse_fs_string+0x10/0x10
 ? __pfx_cifs_smb3_do_mount+0x10/0x10 [cifs]
 smb3_get_tree+0x1bf/0x330 [cifs]
 vfs_get_tree+0x4a/0x160
 path_mount+0x3c1/0xfb0
 ? kasan_quarantine_put+0xc7/0x1d0
 ? __pfx_path_mount+0x10/0x10
 ? kmem_cache_free+0x118/0x3e0
 ? user_path_at+0x74/0xa0
 __x64_sys_mount+0x1a6/0x1e0
 ? __pfx___x64_sys_mount+0x10/0x10
 ? mark_held_locks+0x1a/0x90
 do_syscall_64+0xbb/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Cc: Tom Talpey <tom@talpey.com>
Fixes: b0abcd65ec54 ("smb: client: fix UAF in async decryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 055236835537..6d4c48b33701 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1231,7 +1231,9 @@ SMB2_negotiate(const unsigned int xid,
 	 * SMB3.0 supports only 1 cipher and doesn't have a encryption neg context
 	 * Set the cipher type manually.
 	 */
-	if (server->dialect == SMB30_PROT_ID && (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
+	if ((server->dialect == SMB30_PROT_ID ||
+	     server->dialect == SMB302_PROT_ID) &&
+	    (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
 		server->cipher_type = SMB2_ENCRYPTION_AES128_CCM;
 
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
-- 
2.47.0

