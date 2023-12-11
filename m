Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="W5xdTOGm"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E179A
	for <linux-cifs@vger.kernel.org>; Mon, 11 Dec 2023 05:27:01 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702301219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wx9vzItDY34yg1d1Z+UQPCLcN35MfbLnda4QNZANaBU=;
	b=W5xdTOGmOZH+BcM5tQUvNIXXVSDPO2OAXm7mbwq9TMc7lziwKjZeJo++4pSWblr/yp/bWT
	JrkBNHEZZF+MLlqT5p78T9FXgcCbi66i+JCPAuZ4lD6uIVBM4CNUnEl4lVixV+Li60wVmF
	BJKPIVXjpvQAB3aTlHiH8SK3HsD4wUOkuL35/vbe4BDJZJtomU1lxuuvS13JJLGkUckTlm
	tyqSKOhcPJxx4u/OeENYgFh1hjIuyMP6DSxAhgL3SyPGMvmjhrxWlMGlnT5Cx6I6Yj1qnz
	lsVQJ3efSvaUfbhdXf15rGMC9tbCMqgKXSY0x5NUhQSiqjTTmt+9SWMIQcflbw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702301219; a=rsa-sha256;
	cv=none;
	b=UnXJAqDpf0j7gqeIJHdIHSSuR1897Jp53KBObA0ZZvdfJYHQx82DMn3W8nPjgyO5Li8Zqt
	Lkrcm+LJthy/LrymZfArqE/OooPN7b5LtFde7c5kvPB0D+sbMZJAyVSjRmG7cx6i48FtVE
	r4aiY/7WnXe6ch3s4y3ZX9l9vnIgkILHnzC6rc3BJaxrrvkcbo8BNE6kgkCLx7UG8RlfTF
	FCpSxW/CeoAGlrEbncb+RRr39TZmYbWmXE7JVrUkHkiOHe7QqEd5nE5JaTojJ2TUsq1z8u
	pva7vc9oMeCydCHe6RvAtCPRE54Mn+pssUbzrmJeUBQiE+NizU9uSMhep55/Mg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702301219; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wx9vzItDY34yg1d1Z+UQPCLcN35MfbLnda4QNZANaBU=;
	b=EYMR7q5nZaYHyOB8zbXJBXh7VlHpgEpOtahIy8OTX52zpj4YDhFVEjVNvBEdPYDXFiv4U7
	dX6OsA0ndAep6+gRuIf2q9pizh51F1Rh39PJVXYxeJtsyGsNIGvGShjQ4Et6pqar0NMMmS
	Eoes9C/hfLN8oaRFf1gZTmBDIkm3oNLNHYM6Tqh96ZSKoH5y/O4G2LNFrOjRB4WgChLTiG
	zdceMJowX9VbIKYVuLblV9zHUmufTNE3JbXfg0S8k3LBYz0YFIazI7iK/5fNUd7ptbXhoP
	iyvaAhhOyWcgcCwfmqZJukDo75B2N+2EfHiUnJneeYUf6BsmEwj9GI3UriQ38Q==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH 3/4] smb: client: fix NULL deref in asn1_ber_decoder()
Date: Mon, 11 Dec 2023 10:26:42 -0300
Message-ID: <20231211132643.18724-3-pc@manguebit.com>
In-Reply-To: <20231211132643.18724-1-pc@manguebit.com>
References: <20231211132643.18724-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If server replied SMB2_NEGOTIATE with a zero SecurityBufferOffset,
smb2_get_data_area() sets @len to non-zero but return NULL, so
decode_negTokeninit() ends up being called with a NULL @security_blob:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 2 PID: 871 Comm: mount.cifs Not tainted 6.7.0-rc4 #2
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  RIP: 0010:asn1_ber_decoder+0x173/0xc80
  Code: 01 4c 39 2c 24 75 09 45 84 c9 0f 85 2f 03 00 00 48 8b 14 24 4c 29 ea 48 83 fa 01 0f 86 1e 07 00 00 48 8b 74 24 28 4d 8d 5d 01 <42> 0f b6 3c 2e 89 fa 40 88 7c 24 5c f7 d2 83 e2 1f 0f 84 3d 07 00
  RSP: 0018:ffffc9000063f950 EFLAGS: 00010202
  RAX: 0000000000000002 RBX: 0000000000000000 RCX: 000000000000004a
  RDX: 000000000000004a RSI: 0000000000000000 RDI: 0000000000000000
  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000002 R11: 0000000000000001 R12: 0000000000000000
  R13: 0000000000000000 R14: 000000000000004d R15: 0000000000000000
  FS:  00007fce52b0fbc0(0000) GS:ffff88806ba00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000001ae64000 CR4: 0000000000750ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? __die+0x23/0x70
   ? page_fault_oops+0x181/0x480
   ? __stack_depot_save+0x1e6/0x480
   ? exc_page_fault+0x6f/0x1c0
   ? asm_exc_page_fault+0x26/0x30
   ? asn1_ber_decoder+0x173/0xc80
   ? check_object+0x40/0x340
   decode_negTokenInit+0x1e/0x30 [cifs]
   SMB2_negotiate+0xc99/0x17c0 [cifs]
   ? smb2_negotiate+0x46/0x60 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   smb2_negotiate+0x46/0x60 [cifs]
   cifs_negotiate_protocol+0xae/0x130 [cifs]
   cifs_get_smb_ses+0x517/0x1040 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? queue_delayed_work_on+0x5d/0x90
   cifs_mount_get_session+0x78/0x200 [cifs]
   dfs_mount_share+0x13a/0x9f0 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? lock_acquire+0xbf/0x2b0
   ? find_nls+0x16/0x80
   ? srso_alias_return_thunk+0x5/0xfbef5
   cifs_mount+0x7e/0x350 [cifs]
   cifs_smb3_do_mount+0x128/0x780 [cifs]
   smb3_get_tree+0xd9/0x290 [cifs]
   vfs_get_tree+0x2c/0x100
   ? capable+0x37/0x70
   path_mount+0x2d7/0xb80
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? _raw_spin_unlock_irqrestore+0x44/0x60
   __x64_sys_mount+0x11a/0x150
   do_syscall_64+0x47/0xf0
   entry_SYSCALL_64_after_hwframe+0x6f/0x77
  RIP: 0033:0x7fce52c2ab1e

Fix this by setting @len to zero when @off == 0 so callers won't
attempt to dereference non-existing data areas.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2misc.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 32dfa0f7a78c..e20b4354e703 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -313,6 +313,9 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
 char *
 smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 {
+	const int max_off = 4096;
+	const int max_len = 128 * 1024;
+
 	*off = 0;
 	*len = 0;
 
@@ -384,29 +387,20 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 	 * Invalid length or offset probably means data area is invalid, but
 	 * we have little choice but to ignore the data area in this case.
 	 */
-	if (*off > 4096) {
-		cifs_dbg(VFS, "offset %d too large, data area ignored\n", *off);
-		*len = 0;
-		*off = 0;
-	} else if (*off < 0) {
-		cifs_dbg(VFS, "negative offset %d to data invalid ignore data area\n",
-			 *off);
+	if (unlikely(*off < 0 || *off > max_off ||
+		     *len < 0 || *len > max_len)) {
+		cifs_dbg(VFS, "%s: invalid data area (off=%d len=%d)\n",
+			 __func__, *off, *len);
 		*off = 0;
 		*len = 0;
-	} else if (*len < 0) {
-		cifs_dbg(VFS, "negative data length %d invalid, data area ignored\n",
-			 *len);
-		*len = 0;
-	} else if (*len > 128 * 1024) {
-		cifs_dbg(VFS, "data area larger than 128K: %d\n", *len);
+	} else if (*off == 0) {
 		*len = 0;
 	}
 
 	/* return pointer to beginning of data area, ie offset from SMB start */
-	if ((*off != 0) && (*len != 0))
+	if (*off > 0 && *len > 0)
 		return (char *)shdr + *off;
-	else
-		return NULL;
+	return NULL;
 }
 
 /*
-- 
2.43.0

