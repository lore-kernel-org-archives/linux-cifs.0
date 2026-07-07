Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4804B3C1080
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 09:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783417445; cv=pass; b=To82YbmRCymGDsuNblnkRD7UfQFcdScKcpsfeMcGV0zReec5r9AfF+leaMlyH1iG6WMdjVkSrOxI5EMhNr/d7/oLPMkWrqNPAUtntQh1JJMEWpR/+UK5EJPu9FbTvgaKNj7mJNDU7VhJvzHNhp6T6ld/tu8hWc2bhT1UWwd2aLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783417445; c=relaxed/simple;
	bh=VPXH07CDPhd5rak2km1cKyBn1SFPqQIo4+zEUb0cngU=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=UL3aaVwSlmcdd011DF0jlHQgweyKgHG2ojcCAnmRJMjkKmu4w+BuQSBqbUV4Rb6jh/roH3IKII0y2Q39lt4cg8HaYdYO99zrstSg4h2lR5MB8zSI0mk5Hm7julTqEDJJ8YclRIsDjbe5z9WFBhLFYzZa7brKimqOoQmbzN5IH6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UzuGaWkE; arc=pass smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzuGaWkE"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-847a52edeb2so3079406b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 02:44:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783417444; cv=none;
        d=google.com; s=arc-20260327;
        b=J8uYqeXWTzcT2ip6aVMXfpJBBSzx3mQR9oj7PhWcvHrnI7yVzpYqSrEBZjZEhiKUfF
         vGgq8h9sFNYwc/69LiH7dQ3s7s+ct0TzDO1eVqibG7IFXDl0Pay8T3bMv2xa2KoQG8iI
         yiV3Hm+JBGMnKPEAEl7IrqTWM3sy7tPsXm3mHNOOU9BZg1xLmZsIjIih7U3lP5fHmGd8
         ZrkJVLhf3u32XYxw3byqAQaYrVOs5GsbHONuBjs2NMl9/BjLnYbmhtTovAEoYBBH6Cwg
         vPtVQIYQwLpZfqBZxiNqSaC1zhPCp11mei5S7r9X89Qvf+bDLgIx4SLh0G7sayxskX74
         uiUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=6IY/mKMT+7EIk0NR66b+rv5i8rg86+n5XdCIF1mB5ps=;
        fh=NDpYk95N0t08vx4afg3zG/jEk1CeX33Ejrq1HST0xv0=;
        b=CoaS2LQYnh9yvXL+tetZS04OqmknaEVF51H0c/4+daW8+MZEra65K4kJXUt1kI1SpR
         iDJoGar3xXaehyUekP1EEjWcfrFDcxg/2prVdQLWYbeervPbMmBURZL0dQ8h+4Qr4VDj
         IM1QMg3p4vPSu/yEb/xgU1j81eCkj0WldYuDCxsPv8BS8a+Qrz6Z76IFwC7cwCZ18ED+
         vECtnDkmp0L7rcJf0fvNqTVoLyh+0pjN/TsV/IKI07ZG6cBVjq5HIcwtyX3sB0545TgY
         N1XxCMHD8wK3i93w606bVypq3oyWUDDUTvQW+m9dW+3zy+JnTvdCiNNwp6WMYaOp0grp
         fu6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783417444; x=1784022244; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6IY/mKMT+7EIk0NR66b+rv5i8rg86+n5XdCIF1mB5ps=;
        b=UzuGaWkEBD5VT3bqbG0UOsJPM8o7GC5vI2lXh/24Fd2GJFYSmGPYH3ZTjBt74kB7+o
         sKGFnBGn71Boon/aBdxzMA1Cm4alX+XNEHZWObLtaYfb4Ee+QIPKwtTM3lWNJCWuYoyT
         djjl632BD+km9CFORwvkJ0vscRKRjQI+w/YjLfYmDvh7hqoAawej0o8oQVZC/3+XmvXm
         uJIHAiAyaKvwbtMPjq3cUTYoHyvuOwM+YoHDeHN+xdHTqVIkvnBpNarxsdCn9O8sXGRc
         55UimNbvwvYT7K8GiSPoOhoYYnTlYADJP8bLgKiEkkIo0gRo2Muu0BMbbr//YLIawaU4
         ecJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783417444; x=1784022244;
        h=cc:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6IY/mKMT+7EIk0NR66b+rv5i8rg86+n5XdCIF1mB5ps=;
        b=epSgOjDRoBepVWM0/VyZCIYoa6S1fh+WsSWHTbw/I3fHi+7XkNZk2WuBBTYmw+qLc0
         TV/pEdeU4ajzvIv2QQZtw5UV30bh4zgqfndjCpXlnKtpJHC43wbbCDkebiwQKoGxp5ZU
         kgqTlV5w8WIfhLnLwL/4wgZukRUA49SQsr0eoAskmZ9mWzIKtzoXpF+rnBrvwCeICAPZ
         7lBxbBWF8IwjHtwFBw3eUBqCryyVAhrqliqSTuSnrJ0K6z5LtNFL06lqMuse9bDigkt4
         X91SVhNRMRtNazoF2947zErtlRH1NjGcZwRICjRpSUYaPD9+Rn6ltL2NugKgwF45/sbi
         F4AA==
X-Forwarded-Encrypted: i=1; AHgh+RrE2421TQd64g4aDHVqE4uTDkjwGgCLFjLVSTOKCGRDW9ed7EuEABrZB8J3b4TSBVZtpnUZarPTLYXY@vger.kernel.org
X-Gm-Message-State: AOJu0YyGggKv9+pjJdV/624YTbCTnYftqJ0A+Waz3bfY114Jh4CYxy+1
	XRItOhuLWi9i1oMbGrWgd6PTdTEnFylEQ2wqrX6/ax4vOjVA0hXYjhQhOIOVEv1gBGBb3XVhM/y
	iIW72kQWemz6qlzGXZEIsxlA6rXz2+30=
X-Gm-Gg: AfdE7ckpbgqSuo+AwUbdJW0K8HSzQVqyzHBeAm4rLbMJYN4KGDAbmjeewkJEukJAmlN
	2kIPqeegYPl3fLChRRuH77i189Xey28/f5X8kNiWsIyE/8r8zpwVeTw18FpC31SAfQmSjl4S48d
	tAwVC5QFuIfQQaj3qBF8+ysWydIZYcWbm2SJwKngt0AiGtfgukAm3ZBztAngDttfEOHk/d3NVEX
	kt1lxt37191QgHG5p/QdsN3EGgGNmcSoim4WZ7f2GPzma0yW9kwPg8dAtZ1ng3gS7d1Wj/juW9s
	ofLso6AC
X-Received: by 2002:a05:6a21:6b10:b0:3bf:a881:4094 with SMTP id
 adf61e73a8af0-3c08ef1a391mr5448642637.50.1783417443603; Tue, 07 Jul 2026
 02:44:03 -0700 (PDT)
Received: from 1092881822491 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 02:44:02 -0700
Received: from 1092881822491 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 02:44:02 -0700
From: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 7 Jul 2026 02:44:02 -0700
X-Gm-Features: AVVi8CeAT_OA9I2IsuPak2sakCvGMoGjVHPoDt2Zql55ZYfd9txoChbdSuTIMJc
Message-ID: <CADAuDAMMqYM9o0KvYon8__rjhkKWCY35f5=oOSX9HAYt_y4KOA@mail.gmail.com>
Subject: [PATCH v2] smb: client: restrict implied bcc[0] exemption to
 responses without data area
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>, Pavel Shilovsky <piastryyy@gmail.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

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
v2: resend only; no code changes.  v1 was line-wrapped in transit by the
    mail path, corrupting the diff's "@@" context lines so it would not
    apply.  Resent with the body protected against re-wrapping.

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
@@ -145,6 +147,7 @@ smb2_check_message(char *buf, unsigned int
pdu_len, unsigned int len,
 	int command;
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
+	bool have_data;

 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
@@ -228,7 +231,8 @@ smb2_check_message(char *buf, unsigned int
pdu_len, unsigned int len,
 		}
 	}

-	calc_len = smb2_calc_size(buf);
+	have_data = false;
+	calc_len = __smb2_calc_size(buf, &have_data);

 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
 	 * be 0, and not a real miscalculation */
@@ -247,8 +251,13 @@ smb2_check_message(char *buf, unsigned int
pdu_len, unsigned int len,
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
@@ -409,14 +418,17 @@ smb2_get_data_area_len(int *off, int *len,
struct smb2_hdr *shdr)
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
