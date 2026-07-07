Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFF93EB0EE
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 11:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783423484; cv=none; b=ffYd3z1Qa6udAtg7gfcWG4pl9EQFi6Q7AAftGCjdwUdDJAtQzxZezdz31ogOT9bsGBVSO42b7kRVAcDxwlr4n4Yu2eeI0h1nqinek23aXkFIlN6d7VHHSvxDX5LCWhgWQzKVla2Ga0iDQXNPvLtILS+fN7Hp651Abx5WO3CuGYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783423484; c=relaxed/simple;
	bh=Bo9oL/C2y1aYLxBhHb5rf7zJZmAXYfSvTuo+3FjKYNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BcLagG/DL4uS2k/VbgAGwfg5ybKO4bgmZpV1iKrmHkx9w7/BogA7KcEW74xXHdxGqJZkADC7ca+Nu4zmAOWYSCIG0Llmf/IfXrhqza+EbKat2v8ZEsbvHOOcJWIZXfl7mT/Qjszw+kjkFAHuSFj/r+boX9qy3xtZlBWNU1H3GRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKsD301t; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKsD301t"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3825c406ffeso3239959a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 04:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783423482; x=1784028282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gnLbIBcEZuA3LS3sX2nuUnV5rtpwTIPyf21YklMdLh4=;
        b=XKsD301tFtgo63VlXIPOHTdn/Mqt+3Ijv0DbmQg/zN6lNeqRzrVtfomSbytMNAGpOz
         7BDq4k+3qtjxmlGpCprtcp9VQb15AfHVX5hnFuIGAg70PnrJsJxfl7RNXjWWdfChmqv3
         YDrNPpTvLWQ9I4UUqvd6ZHxuk3bgzOUlCSSNzm1Qe0UbogCCua6z+LIMJvNIiixWI1Aq
         zV77pJbUSAjd3B4k3XegIal2C5OZiiiOgUX+c/T5nudG2lJX+WvVKxAarJiZRW2b+qmR
         BWqFPF56ZMHtCE0592SNKNp1AtYfi6U2EuQHtpLWpJJX9hx2yB8vEV99p8fp+HL6ro26
         gREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783423482; x=1784028282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnLbIBcEZuA3LS3sX2nuUnV5rtpwTIPyf21YklMdLh4=;
        b=GYixaOrgJuAwGt3v0PTkQwXnho5cG8GPDLYxe67SED0oCCxRuVKiYLy2V1iMym1puz
         f7liNLmGUtNR0rj5O2CLbCrqELMxOh0/+aGvxsfCmHm4IIjnVWj4s/ZfNefPn4zSSxfA
         ZcXvfUAf+7FOCmItNLBq4j772F9MsAueqdmTtN1JY1hpMea92ekkydDsig+olIT3uLly
         +ncCeH7u1I3BUfngRrkDA9Zkc8r2lca7c7mfkarhW79qmE7pVUo4+vbAO8plKJbTd7Al
         NnGAsBsWjuwq0jZM1k2thvlrO4dpZjmalUIvpGEutLGbftk6pckO1KQrybfWQsIpQz73
         qXmQ==
X-Forwarded-Encrypted: i=1; AHgh+RqlWzwJoziwt+q4Bnyd1/M1YiGN0ePnwMdQ9BzCx6P4vrZ8MLz4Zb+pmd3BxFopKqP4uy0lrYYT10Kp@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0QUzw7TRrkaShYNW7THXGZfac+28NGy9Gikq6SFwBptYw7dVO
	S1MeNwSuptIEXtxBztZE9++i2eWWV0L7KVcueCqT3digTu94JB/Gp3bD
X-Gm-Gg: AfdE7cnb3Qxx9+e71GiPsKB7+bg7fEdbTcVaGTd0yda8tyZcsnUUI4WK4BeXByMslhd
	iWmO7SFka6JqRv6JxeRcM6xExuyAsSPUvSG8PYjyGMc874WSdKIgcBU/IW9wr9+DFaCBegj0/DE
	MUfMcQvuMKaJPdTMl7kz8YeL+Lg0nSLJ7wCGU0gugq4o+gOhnGJu1aX4XgOkF4BjojClmcLcATM
	Ml6ldn2/3JK2yaGsDrAQ9rADZ4I0gdtmRKDJEv0rP5p6kgeemjINoF9Y9U8KHETUhsuk2oLYLVv
	tOgEgPB2rYi9aEz9w8EEGSU3kBg3XfniR+TH+T8CzqwbzwKNeHgyu5M3dlPExWlJPOX0RiEXT3Y
	8pj6ohvL6485whDDZnlZWCJqj+qN2iDbO4GtBYE2Jm3Z0QyiRqsTGTOaKJ4zheddwA3R3NUIl2X
	VKLjm3OEVV6M4xzO8eFACaQWO3ITR375HH24vzLfEZePiKAjan
X-Received: by 2002:a17:90b:3146:b0:387:e0db:3d8b with SMTP id 98e67ed59e1d1-387e0db437cmr2313551a91.38.1783423481884;
        Tue, 07 Jul 2026 04:24:41 -0700 (PDT)
Received: from miyamoto-pc.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d3c6bbdesm905466a91.16.2026.07.07.04.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 04:24:40 -0700 (PDT)
From: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Pavel Shilovsky <piastryyy@gmail.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-kernel@vger.kernel.org,
	Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v4] smb: client: restrict implied bcc[0] exemption to responses without data area
Date: Tue,  7 Jul 2026 20:23:58 +0900
Message-ID: <20260707112358.2375494-1-shoichiro.miyamoto@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_check_message() has a long-standing quirk that accepts a response
whose calculated length is one byte larger than the bytes actually
received ("server can return one byte more due to implied bcc[0]").
This was introduced to accommodate servers that omit the trailing bcc[0]
overlap byte when no data area is present.

However, the exemption is applied unconditionally, regardless of whether
the command actually carries a data area (has_smb2_data_area[]).  When a
response with a data area is subject to the +1 exemption, the reported
data can extend one byte beyond the bytes actually received, yet
smb2_check_message() still accepts it.  The subsequent decoder then reads
past the end of the receive buffer.  This is reachable during NEGOTIATE
and SESSION_SETUP, before the session is established.

The resulting out-of-bounds reads are visible under KASAN when mounting
against a non-conforming server; both the SPNEGO/negTokenInit and the
NTLMSSP challenge decoders are affected:

  BUG: KASAN: slab-out-of-bounds in asn1_ber_decoder+0x16a7/0x1b00
  Read of size 1 at addr ffff8880084d67c0 by task mount.cifs/81
  CPU: 1 UID: 0 PID: 81 Comm: mount.cifs Not tainted 7.1.0-rc6 #1
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4e/0x70
   print_report+0x157/0x4c9
   kasan_report+0xce/0x100
   asn1_ber_decoder+0x16a7/0x1b00
   decode_negTokenInit+0x19/0x30
   SMB2_negotiate+0x31d9/0x4c90
   cifs_negotiate_protocol+0x1f2/0x3f0
   cifs_get_smb_ses+0x93f/0x17e0
   cifs_mount_get_session+0x7f/0x3a0
   cifs_mount+0xb4/0xcf0
   cifs_smb3_do_mount+0x23a/0x1500
   smb3_get_tree+0x3b0/0x630
   vfs_get_tree+0x82/0x2d0
   fc_mount+0x10/0x1b0
   path_mount+0x50d/0x1de0
   __x64_sys_mount+0x20b/0x270
   do_syscall_64+0xee/0x590
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Allocated by task 85:
   kmem_cache_alloc_noprof+0x106/0x380
   mempool_alloc_noprof+0x116/0x1e0
   cifs_small_buf_get+0x31/0x80
   allocate_buffers+0x10d/0x2b0
   cifs_demultiplex_thread+0x1d5/0x1d50
   kthread+0x2c6/0x390
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30
  The buggy address is located 0 bytes to the right of
   allocated 448-byte region [ffff8880084d6600, ffff8880084d67c0)
   which belongs to the cache cifs_small_rq of size 448

  BUG: KASAN: slab-out-of-bounds in kmemdup_noprof+0x36/0x50
  Read of size 329 at addr ffff88800726c678 by task mount.cifs/89
  CPU: 0 UID: 0 PID: 89 Comm: mount.cifs Tainted: G    B      7.1.0-rc6 #1
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4e/0x70
   print_report+0x157/0x4c9
   kasan_report+0xce/0x100
   kasan_check_range+0x10f/0x1e0
   __asan_memcpy+0x23/0x60
   kmemdup_noprof+0x36/0x50
   decode_ntlmssp_challenge+0x457/0x680
   SMB2_sess_auth_rawntlmssp_negotiate+0x6f0/0xcb0
   SMB2_sess_setup+0x219/0x4f0
   cifs_setup_session+0x248/0xaf0
   cifs_get_smb_ses+0xf79/0x17e0
   cifs_mount_get_session+0x7f/0x3a0
   cifs_mount+0xb4/0xcf0
   cifs_smb3_do_mount+0x23a/0x1500
   smb3_get_tree+0x3b0/0x630
   vfs_get_tree+0x82/0x2d0
   fc_mount+0x10/0x1b0
   path_mount+0x50d/0x1de0
   __x64_sys_mount+0x20b/0x270
   do_syscall_64+0xee/0x590
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Allocated by task 93:
   kmem_cache_alloc_noprof+0x106/0x380
   mempool_alloc_noprof+0x116/0x1e0
   cifs_small_buf_get+0x31/0x80
   allocate_buffers+0x10d/0x2b0
   cifs_demultiplex_thread+0x1d5/0x1d50
   kthread+0x2c6/0x390
   ret_from_fork+0x36e/0x5a0
   ret_from_fork_asm+0x1a/0x30
  The buggy address is located 120 bytes inside of
   allocated 448-byte region [ffff88800726c600, ffff88800726c7c0)
   which belongs to the cache cifs_small_rq of size 448

Restrict the +1 exemption to responses that have no data area, so that
it still covers the bcc[0] omission it was meant for.  When a data area
is present, the +1 discrepancy instead means the reported data length
overruns the received buffer, so the response must be rejected.

Fixes: 093b2bdad322 ("CIFS: Make demultiplex_thread work with SMB2 code")
Cc: stable@vger.kernel.org
Signed-off-by: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
---
v4: no code changes.  v1-v3 were corrupted in transit by a broken mail
    setup on my end (long "@@ ... @@" hunk-context lines got re-wrapped),
    so they did not apply.  Resent with git send-email from a working
    setup.  Sorry for the noise.

    v1: https://lore.kernel.org/linux-cifs/CADAuDAPSq+BUcB1SkHqkZsF364mShyE6jsaB+vk9zm=5Q+LHFw@mail.gmail.com/

 fs/smb/client/smb2misc.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 2a7355ce1a07..6270b33147d2 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -19,6 +19,8 @@
 #include "nterr.h"
 #include "cached_dir.h"
 
+static unsigned int __smb2_calc_size(void *buf, bool *have_data);
+
 static int
 check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
 {
@@ -145,6 +147,7 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 	int command;
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
+	bool have_data;
 
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
@@ -228,7 +231,8 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		}
 	}
 
-	calc_len = smb2_calc_size(buf);
+	have_data = false;
+	calc_len = __smb2_calc_size(buf, &have_data);
 
 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
 	 * be 0, and not a real miscalculation */
@@ -247,8 +251,13 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		/* Windows 7 server returns 24 bytes more */
 		if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
 			return 0;
-		/* server can return one byte more due to implied bcc[0] */
-		if (calc_len == len + 1)
+		/*
+		 * Server can return one byte more due to implied bcc[0].
+		 * Allow it only when there is no data area; if data_length > 0
+		 * the +1 gap indicates an overreported data length rather than
+		 * the bcc[0] omission.
+		 */
+		if (calc_len == len + 1 && !have_data)
 			return 0;
 
 		/*
@@ -409,14 +418,17 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 /*
  * Calculate the size of the SMB message based on the fixed header
  * portion, the number of word parameters and the data portion of the message.
+ * If have_data is non-NULL, it is set to true when a non-empty data area was
+ * found (data_length > 0), allowing callers to distinguish the implied bcc[0]
+ * case (no data area) from an overreported data length.
  */
-unsigned int
-smb2_calc_size(void *buf)
+static unsigned int
+__smb2_calc_size(void *buf, bool *have_data)
 {
 	struct smb2_pdu *pdu = buf;
 	struct smb2_hdr *shdr = &pdu->hdr;
 	int offset; /* the offset from the beginning of SMB to data area */
-	int data_length; /* the length of the variable length data area */
+	int data_length = 0; /* the length of the variable length data area */
 	/* Structure Size has already been checked to make sure it is 64 */
 	int len = le16_to_cpu(shdr->StructureSize);
 
@@ -449,9 +461,17 @@ smb2_calc_size(void *buf)
 	}
 calc_size_exit:
 	cifs_dbg(FYI, "SMB2 len %d\n", len);
+	if (have_data)
+		*have_data = (data_length > 0);
 	return len;
 }
 
+unsigned int
+smb2_calc_size(void *buf)
+{
+	return __smb2_calc_size(buf, NULL);
+}
+
 /* Note: caller must free return buffer */
 __le16 *
 cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
-- 
2.52.0

