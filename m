Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [195.16.41.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9862661A3;
	Tue, 25 Feb 2025 09:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.16.41.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740476108; cv=none; b=lVx3BB+IqJFZ4At0qfAMmYGb7csNGL2dGNoo3naaqIdkgVTmJWWEH2ayiuhVbprwZc91MKo6WFE830u+/U1MbVXDSG8fzTvzJARJDaQo6ZiP8RBfsdYHZkDFGt4aZeNs6CyMi84tmvlMYzpynbYe0bOY8v3w+l0XtrSVWEOw54o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740476108; c=relaxed/simple;
	bh=VKVpn9QhnPv0kuUhUfzxMejbN/ieb227EPXkOuggSWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azOy6Pev9TvfZSbSBIv1xKvar+TnooOQ85I/5/zyx1pd6ibAAMPZckUYlxz4i6qsn4b2l9ft7x89GVx+EgonNkxQDXpv0wDHvvEjCuvjph7BSO5fFQjPEn+maLbSAq409t5r6tetQfDQ8GrEjz0VCZKZO/zQjuYmmhVY3htxG6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=195.16.41.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from gca-msk-a-srv-ksmg02.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 560E21F9E5;
	Tue, 25 Feb 2025 12:35:00 +0300 (MSK)
Received: from new-mail.astralinux.ru (gca-yc-ruca-srv-mail03.astralinux.ru [10.177.185.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Tue, 25 Feb 2025 12:34:59 +0300 (MSK)
Received: from localhost.localdomain (unknown [10.177.20.114])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4Z2CBB2cPRz1h0Mh;
	Tue, 25 Feb 2025 12:34:58 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	lvc-patches@linuxtesting.org,
	Tom Talpey <tom@talpey.com>,
	Jianhong Yin <jiyin@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10/5.15 2/2] smb: client: fix NULL ptr deref in crypto_aead_setkey()
Date: Tue, 25 Feb 2025 12:34:24 +0300
Message-ID: <20250225093428.611253-3-abelova@astralinux.ru>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250225093428.611253-1-abelova@astralinux.ru>
References: <20250225093428.611253-1-abelova@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: abelova@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 51 0.3.51 68896fb0083a027476849bf400a331a2d5d94398, {Tracking_from_domain_doesnt_match_to}, astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 191262 [Feb 25 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2025/02/25 08:32:00 #27449984
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Paulo Alcantara <pc@manguebit.com>

commit 4bdec0d1f658f7c98749bd2c5a486e6cfa8565d2 upstream.

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
Reported-by: Jianhong Yin <jiyin@redhat.com>
Cc: stable@vger.kernel.org # v6.12
Fixes: b0abcd65ec54 ("smb: client: fix UAF in async decryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
---
 fs/cifs/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 245e2dd5a194..4197096e7fdb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -963,7 +963,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
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
2.43.0

