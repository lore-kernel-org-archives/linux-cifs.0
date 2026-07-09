Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE248472
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555624; cv=none; b=U4yg1bYFd0RRNBE8cJFQfOairRFBcSfgCYSVuNCP2sX0adZbTb6T+eOUKaPLHbpYJgK9ov4tgKX6rZroec0f3S1Nx4oirOgyjiDo4D9nRsaESfqRMrbu85GsEh9WyBMVJAzXabq3yUT5gSOgbsMTnxpvtXvP9Yvjm9Qjw1XKXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555624; c=relaxed/simple;
	bh=qhnVk8UqPHQsfvVSBfos+TQktcjxkIF1V0i9VPrS0M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gK/9zhSF6NS0q4ULiZMZ52q1+8QoZkA89aZ/F8Zr85prx1ruL0+zXi2DSt9LPiVEIz550YH9abNk+8Dp2+dRNVNbqQCv8eg4+wAYKtDmh5n52b+3RBdRgEUDvMnlE5oAgYbLOxx+X70D1OK0spiAtZXqg/tJssCnK40h3syvuE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7d5jGw/; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7d5jGw/"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so2560645e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555621; x=1784160421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QDeGTJGckIFCye1YsJMI5+Vi171DFr454fzQGKkJcHg=;
        b=d7d5jGw/WSLT00AVLT3kSFyDmxQ8oJHdkucH/UstI5dI5K8z0PG971YtLcQqUvnHHD
         GNYQs71oD3vY3Q9muC17ZCpKGceTMkAp3GMFbjCi1HgT7GbWbMmFIZIN5jOuySMJfRs7
         VvV0XereJ+ZNdkQ72qQ9fb+uSUlbe6tAAXvDhgDGB73F9oWqA8YekTZWDI4JgYG6auAV
         1XbopOiqpMZazTrLyChN+xnwUIPvs4ssqN5k6QjGVmsQyQaLclVzbsNPejPaVqdF77WZ
         zDxn2wlB5pB+sJp4P6lwOaAIMlvS2FV1lfuxbynPdm3zmcW/rKnEihLwsGVdQGC/WNXg
         vlYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555621; x=1784160421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QDeGTJGckIFCye1YsJMI5+Vi171DFr454fzQGKkJcHg=;
        b=Ga5jZFEZ9vCiBd0bZub8MKWe9myTVQg2UcOOP4kqHqdsaC/A1aoCioQ/hqZBqf8v6q
         U2ZTBngttZUf3dH2qRj+iqEBoBpwoqV5IA6xON8xP1vkx4NRJvkfRAsefrb/Ms11XsZT
         ZhTyM2/42RnjOxOf980GyWDsCgPKqohnj2ReljZMCXMvf/x1e2oqkqRvSTtUVQU7gWUF
         hhJhByKgdSe9VcARyma8Nt49BNM7IMBRaPruABjxS6ZWqnaGFaqeKZ7C2piJDJA9paBH
         XjIrUpoAEoemFfLU3syn18wXoLfZRdY+wi74c+HDchHEN7K1+tCD0iouGaaW9J47vSBl
         XUcw==
X-Forwarded-Encrypted: i=1; AHgh+RpucaLyWzdsKcoL0mpyR/2ufnfYvruongwv14Es40uwlNTFjfhNvoM9ejJo/3Vfc+QsimnaB+ylJCAi@vger.kernel.org
X-Gm-Message-State: AOJu0YztIv+QtOwN+87qlOn56he5ORDZDzKMaAUj3KiZPLN45FAq1qKg
	P74dGk5VjcuFa8gOp5QDvBS6/BS1vdF6+5uNnRu0YqFNrB7L00IvL9UVyPw8ncIS
X-Gm-Gg: AfdE7cnrVIQf1IJAc43ad/OyXuhO0bGcLGO5WBI/CcKa7XIRQFGIDJ3shyhOshEYlQF
	LfNsBZ7H2U/uxo3p6NXrSfFLqo1bd+GmYuZtTD1LFI4zO1JXM5M3gGKfdBvfH1FB0AZl4PvfNSG
	Y5PrO1G4BJDuvx925U6XO7ribh5LOPIht9Ar4wIQnXzLEvi8JU9xsf0TLzfPmep5FkXaGdZys+4
	FaevspBhO6Tu6rmS6Fur41c1/SqWaHdy0Nwo0mTSqt3Jdh1DIYzlKs3H4isvYndVRz8SOWmBX9V
	9etO0Jgp88ZfeuX9nmnXLL9Aec68iG9gWRVlvExwK6tTUq+9k0lzuRDtp8/T0Kelrqh1i2Oi2zx
	6gN9VLaDGimM5F+aDZubdu66gTdJyADlGuqG74VL3Y7flKwDZ+OERXwInXiM36wkvhKx7bvO6D2
	ycFUgIyn0Cxix1tRngsMwL4aLzW8cypvv7wwU=
X-Received: by 2002:a05:600c:1914:b0:493:bcba:46a4 with SMTP id 5b1f17b1804b1-493e68df746mr44871145e9.20.1783555621239;
        Wed, 08 Jul 2026 17:07:01 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm15981925e9.0.2026.07.08.17.07.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:07:00 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 3/6] ksmbd: send inline FinderInfo in FIND responses when READDIR_ATTR negotiated
Date: Thu,  9 Jul 2026 02:06:09 +0200
Message-ID: <20260709000618.66534-4-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000618.66534-1-g.blivet@me.com>
References: <20260709000618.66534-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Without READDIR_ATTR, macOS Finder resolves type/creator/icon for
every file in a directory listing by opening its AFP_AfpInfo stream
individually -- one extra CREATE+QUERY_INFO+CLOSE round trip per file,
which is the dominant cost of browsing a large directory over SMB from
a Mac.

When the client negotiates READDIR_ATTR (conn->aapl_readdir_attr, set
during CREATE's AAPL context exchange), inline the same information
directly into each FILEID_BOTH_DIRECTORY_INFORMATION FIND entry:
  EaSize           = max_access, expanded specific rights
                      (GENERIC_ALL_FLAGS), not the raw FILE_GENERIC_ALL_LE
                      "generic" meta-bit -- that bit has none of the
                      specific FILE_* rights macOS's smbfs.kext checks
                      bit-by-bit, so reporting it directly would fail
                      every access check and show Finder's "no entry"
                      badge on every file/folder.
  ShortNameLength  = 24 (fixed; the spec says 0 when there's no short
                      name; kept for wire parity with Samba, see below)
  ShortName[0..7]  = resource fork size (0 -- no resource forks)
  ShortName[8..23] = compressed FinderInfo (all zero: type/creator
                      unset, client falls back to extension-based
                      icon/type detection, consistent with the
                      AFP_AfpInfo synthesis this mirrors)
  Reserved2        = Unix mode bits
Reparse-point status is still carried via ExtFileAttributes rather
than EaSize once READDIR_ATTR is active, since EaSize is repurposed
for max_access.

Reverse-engineered from macOS smbfs.kext network behavior and
cross-checked against Samba's vfs_fruit marshalling
(source3/smbd/smb2_trans2.c, SMB_FIND_ID_BOTH_DIRECTORY_INFO). Also
confirmed against Apple's published SMBClient kernel source
(apple-oss-distributions/SMBClient, smb_smb_2.c) -- every field here
matches exactly, except ShortNameLength=24: real V1 clients read but
never examine that field, so it's kept for wire parity with Samba, not
because macOS requires it.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
v1 -> v2: Cross-checked wire format against Apple's published
SMBClient kernel source -- confirmed every field matches, and
corrected an inaccurate claim about ShortNameLength=24 being
something real clients require (they don't; a comment-only fix).

 fs/smb/server/smb2pdu.c | 60 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8fed5fd6d..120c2c80d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4733,17 +4733,67 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 
 		fibdinfo = (struct file_id_both_directory_info *)kstat;
 		fibdinfo->FileNameLength = cpu_to_le32(conv_len);
-		fibdinfo->EaSize =
-			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
-		if (fibdinfo->EaSize)
-			fibdinfo->ExtFileAttributes = FILE_ATTRIBUTE_REPARSE_POINT_LE;
 		if (conn->is_aapl)
 			fibdinfo->UniqueId = 0;
 		else
 			fibdinfo->UniqueId = cpu_to_le64(ksmbd_kstat->kstat->ino);
 		fibdinfo->ShortNameLength = 0;
 		fibdinfo->Reserved = 0;
-		fibdinfo->Reserved2 = cpu_to_le16(0);
+		if (conn->aapl_readdir_attr) {
+			/*
+			 * READDIR_ATTR wire format, confirmed against Samba's
+			 * vfs_fruit marshalling (source3/smbd/smb2_trans2.c):
+			 *   EaSize           = max_access (expanded specific
+			 *                      rights, simplified to "grant all")
+			 *   ShortNameLength  = 24 (fixed; not 0, despite the spec)
+			 *   ShortName[0..7]  = resource fork size (uint64 LE, 0 = no rfork)
+			 *   ShortName[8..23] = compressed FinderInfo (type+creator+flags+
+			 *                      ext_flags+date_added, 16 bytes LE; all
+			 *                      zeros means type=0/creator=0, i.e. use
+			 *                      the file extension for icon lookup)
+			 *   Reserved2        = Unix mode bits (uint16 LE)
+			 * Reparse-point tag is indicated via ExtFileAttributes, not EaSize.
+			 */
+			__le32 reparse_tag =
+				smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
+
+			if (reparse_tag)
+				fibdinfo->ExtFileAttributes = FILE_ATTRIBUTE_REPARSE_POINT_LE;
+			/*
+			 * FILE_GENERIC_ALL_LE (0x10000000) is the raw
+			 * "generic all" meta-bit -- valid only in a
+			 * client's requested access mask, for the server
+			 * to expand. It has none of the specific FILE_*
+			 * rights bits set (FILE_LIST_DIRECTORY, FILE_TRAVERSE,
+			 * etc.), so reporting it here as max_access would make
+			 * macOS's bit-by-bit access checks fail on every
+			 * entry -> permanent "no entry" badges in Finder.
+			 * Report the actual expanded rights instead, same
+			 * as smb_map_generic_desired_access() does when
+			 * translating a client's GENERIC_ALL request.
+			 */
+			fibdinfo->EaSize = cpu_to_le32(GENERIC_ALL_FLAGS);
+			/*
+			 * The spec says ShortNameLength should be 0 when
+			 * there's no short name; 24 here instead matches
+			 * Samba's vfs_fruit marshalling (smb2_trans2.c) for
+			 * server-to-server wire parity. Apple's own SMBClient
+			 * source (smb_smb_2.c) confirms real macOS clients
+			 * read this field but never examine its value for a
+			 * V1 (non-READDIR_ATTR_V2) connection -- V2 repurposes
+			 * it as a flags field that is interpreted; V1 doesn't.
+			 * Either value is safe here, so keep 24 for parity.
+			 */
+			fibdinfo->ShortNameLength = 24;
+			memset(fibdinfo->ShortName, 0, sizeof(fibdinfo->ShortName));
+			fibdinfo->Reserved2 = cpu_to_le16(ksmbd_kstat->kstat->mode & 0xffff);
+		} else {
+			fibdinfo->EaSize =
+				smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
+			if (fibdinfo->EaSize)
+				fibdinfo->ExtFileAttributes = FILE_ATTRIBUTE_REPARSE_POINT_LE;
+			fibdinfo->Reserved2 = cpu_to_le16(0);
+		}
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			fibdinfo->ExtFileAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
 		memcpy(fibdinfo->FileName, conv_name, conv_len);
-- 
2.43.0

