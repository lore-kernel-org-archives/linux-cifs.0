Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D9C3E3C69
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783419748; cv=pass; b=M1gATRAYDFP8pcmoO+i9dL9lkqPXQgbxWOAjO6BJksVh0/wnYkktunfFM9GLY/TD251wgcDcY+1nR7slr3lWtKmgSS9smAMvVGDJh1m6Zi+KpfgPQDPmeXiowlVVPqKQwxHoHwzenQ2tCdnIkhlUGSD/IwwOByhG4eZiHVFnBEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783419748; c=relaxed/simple;
	bh=Ez3/dkvyz11Fy7wof4uSaU46oVU6YjEyovXNc6Xsy0Y=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=QqIGinH6XhnMLEke9sQ2RG+lJmYU5QLf9DJ+x/1U7YNysNA7Hvd5Skh5yENwZcYknXOCDU30SCkFR18AnnFpjziV1HK7Orui0RiiUzqDFeZmiuRugwdMDb/4tfOctcdg430XfKUlDProxm3t1mywlPhh5wUAoEsCkv996n9T/HY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PM6wnCpK; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PM6wnCpK"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-384930ca5e2so2724574a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:22:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783419746; cv=none;
        d=google.com; s=arc-20260327;
        b=Jj/11UjKH6LrbQgCpgYK1CMg1YnADSzIvYZEYKq2IPtbwswkdTVE5KDrHeqcVXp0EA
         BxZdvnie0GWLijTPLLqqnhNlovN/prmYktjoWlgCOa2lxh8SLoRD/4BK2NsbnuqiDiVg
         IO7D711rFtxpTZu/HsM0XSeSf/hE8fW29vZEaja16hjiutmS4xO7bqIG2PU48yEAlYHY
         mrDUzzUuyb6igXo4WZMRuMWujMI49M3qei0w5vCpC8qmOcONNTPiA0aA0u49BMa3Gbgu
         rypGT8iDvYDekyQEEtCVHTTfx+2x4a3YYhqLp/Qlsr6ZZ3ujw1zRaR2M4p77lmdrJ5zM
         z59Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=5NEGqaqLoaouNromSMWdFa/ONCBSTswZ0QJyZ/NiaEA=;
        fh=rsm8ErQzHCJpqtGV1q9I/+8ZHfO22Va8t1GThBwEUIg=;
        b=F9ALgx/Db86pBuEdkDhP/HmksAokpkzC4rXMLhxqHEgLnFK5zChySS84CCM0pC68hn
         MygcCP53MLEG3yzfpl+HoLmAr2j8ylylNc72xPoc8Sxqs0ai56xc2UBukaxRGD8UJ5Aa
         M55TwPHQ8+3uXKrM0KwuXK59BGp22xOomhGqTfKchEgokT5czUFrVU+tgAZIjkuAwwmK
         1mVv5Yom3mz7vlcsvA835Ier7+9ZN/AfXoMFvvQwZlupSaam7T6MRqQtxfH4qOtdMikK
         +JqFE+BcoBNGRK/2nZqWJQPGxaLhLE5IUjkPrfBG09sFtwr3ryP84eDeWbD3HifkM8xl
         zyhw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783419746; x=1784024546; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5NEGqaqLoaouNromSMWdFa/ONCBSTswZ0QJyZ/NiaEA=;
        b=PM6wnCpKW7A2PFYymesbx13JSc0okIgG4+TXynKc5Qo+JGkehYiOJYYZvn1Om0BcJi
         BzXy7FzlbZ1hWQmcXBhl7KSjT8ds8DfiY8Jq5pi05/a2gL8xgnZY5j6HEGjnd8HSKWmF
         jbx/NmxU8+MlsuD2XWmVSXFm6aY7LZxfWMoA+qZTy663/DF9A4WiWWki/HYXeUDwuOFx
         pR3R3aLcnmgsyGLOeENvvCwLI9AQq/jNUP7pu+4diqcEjseCo39wWuDrgVat7AaAZhlx
         q4ue/IxM2xeqm+u4vyucE89TiIrmnwABN+A9TZyYxPlZR1k39qp3UNKlEAdTDEp5FFpl
         b20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783419746; x=1784024546;
        h=cc:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5NEGqaqLoaouNromSMWdFa/ONCBSTswZ0QJyZ/NiaEA=;
        b=ghLqsv3AD3y+YpxvWWZsgZGVWbCe0o7EGVEEY3WNhrTcZD07KGaYpRM6dWYpSZ6WoX
         VZV0HckYirobXQxCHUzyhodUFriyd59e+Ti9hJ7Ew3XbGBEv9loSdabTwDPkMu2TRJfv
         LvLxnDEJ690WFUs0fcuovOocFPv6w2gelITlhJjoWUkD1gHgDlrvtr2xjVRGILdcUUPM
         fNZ7HyUbQJxGba9Db1fAutchCfmDo+59eGIHKfpxlRdtaRUzPDxaPPllddwZuPxxYFfr
         lil7H6tvhF2Z2rJsgwPD/hkCHeOx8GsC/alWQ17mbrqCifkLbSykTATOe3eyr4wXITvE
         BqXQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpcys5cWVRZL+eozPatv4vMfW7JL8llpQRrPJpeE4nsT6oUUEgmIDpafY99ar43Yr5Dyx7E7RStD17j@vger.kernel.org
X-Gm-Message-State: AOJu0YyTZnkJCQSdyHdNCgRU5TBFBWnnNL/pxYIrpr1EHcZ1WTwvhFZE
	GGdVaSNTEetsdudwVTdPG7Im2e84csnV4mT20RNydRg25gmXl/+iwG2ZrkEVeR8tcuLCNnY09R1
	QS8nqcM1ukHX/NiXy0J+pnZcAKXkHoeU=
X-Gm-Gg: AfdE7clMzjGNLKt3DwbKGjWWt0ATPR3AwpV+5FcNteuyiNwEF4LC7poyY2Xl/bGvhNz
	5wcggyKP/UxrJT4EQ+32wKMk1dGKoHyt1W1j/Ujkj3E/2udHZGZwQSz/C3OW4Aj+7U7KRMLLsP9
	oqMVRYihpOnRozriATFMRjj3zO9Hr/DkEfidKMBQAJf8AdMsP7srWik0WogkzEIuDa7OhFbHYCY
	2FOt+pDVZiZN1E1a2VSaEVyp4xM+NKMX25KnIdD4D+Q6KNF/bk3BY8gRizJL+L5BLMigePf3A==
X-Received: by 2002:a05:6a21:6487:b0:3b4:71a9:cd8f with SMTP id
 adf61e73a8af0-3c08ef052a1mr5735665637.41.1783419746117; Tue, 07 Jul 2026
 03:22:26 -0700 (PDT)
Received: from 1092881822491 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 03:22:25 -0700
Received: from 1092881822491 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 03:22:25 -0700
From: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 7 Jul 2026 03:22:25 -0700
X-Gm-Features: AVVi8CefMabb3il5MvzpnMbKMY64U17oUHs5i-KN9fgCCqOaUMkEdIb6Z_2vYfs
Message-ID: <CADAuDAP9Sq=DyMQXm-mP6+mP8vmV=BdYd7YbTnMOAUTwWn8V8w@mail.gmail.com>
Subject: [PATCH v3] smb: client: restrict implied bcc[0] exemption to
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
v3: no code changes.  v1 and v2 were corrupted in transit by my mail
    path, which re-wrapped the long "@@ ... @@" hunk-context lines so the
    patch would not apply.  Resent with a base64-encoded body so it is
    transmitted verbatim.  Sorry for the noise.

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
