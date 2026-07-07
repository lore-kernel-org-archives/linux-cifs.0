Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71B0227BB9
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418498; cv=none; b=RRBvldN3hDBxxSyWSCtqpsFHn9yGeEQeyrATyQS9FFxPTpMLsZSxF+qA1s1bs5BCClyNp3IBSZRVSmWqZyNZy/vY3/I6Aw2BvJItSdUflZIJcLkkqi3/lymVNRYvy+f1TEDmm8E3XNb3sADLphPh/M81BdQuFcW+EWmKq4ZvCxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418498; c=relaxed/simple;
	bh=Wq5smhmaSs9FQqjnlX9PVXUuRhDBNGs+kzESsV1u43A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0eUufG6A36wRN3qqneWE74ofr8wXHMYrPrlsMepvgvbEDVjFXa/srQ6tO2xsU4nv+FZTfrXRGdyHJBhU+3w9dT1kyM8LCT1N78eFp/GeVqzmGelG1FDHkrb0oTzdUX7rswYgO79TvGZE3wNK9onoHjl+h6C50mM9QxubihINVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FUdilNRN; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUdilNRN"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4703bc0a99aso2191830f8f.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418495; x=1784023295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+j8d2ocGrvYrq0XcmzBQ4o0mLWqeRieIU+AXOYTGpEc=;
        b=FUdilNRNWtTNg2MPjLbOAOp83J36zYSonEVGGHaNnYC02AzzTNjCSR7rK4+zAT24YY
         NRAqBngUEBYZvkzCyeChrpkiAiylPjK2INNq0vhagpTmZA9Alr4aLpiOlqYXZWEbbCvz
         HF9gt3Hc7kJcM/o60zC4Z7XBo/kJtO1Z7VjONdU94iO6auzFSoFAQMx9JHfdur/BhIIm
         4kSPosf6KA6R3Hv/EnKr9UrHm+lJjcea+MdRGnCIwsnQySck3duSL/TdTb7ysCaZ7Wib
         MhrhREctT+RV9dhIsKavXjwSQxixjFoR3WABlY2TRMgebRK9MZIxJY91ADG9ougZr7Re
         /NYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418495; x=1784023295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+j8d2ocGrvYrq0XcmzBQ4o0mLWqeRieIU+AXOYTGpEc=;
        b=khoV0FX6JU99n5cTu4dOcE3rT0xoRhMuhdeQ0gPno/XWl5pd0nSWOQ1L/osmowHWjQ
         F89xDp06Lw1xdo7NtgsiQYem0d0S4pkt7BDgblbo+S7JhT55ZDhparXGnMbjxen0Comn
         oWw29Vs0DH8N6QTJ+WpdH2JsNizN/y47NsA4lJfsS3g6whEIMyRT8m8UpQTOVIojyR4N
         M7GCzXRz3PlPcOK/+VsJ0h80zkWJxLhUuZswNdMLSVgLC82dwYNg6fSsbaBTr6TPL9y5
         GpgiPX4tSsfO4uBpSwEZxvHpb/SgorpwsiwqZeqstZGpmJsS8zo8kvoxNejAwE3Nenat
         Dr0g==
X-Forwarded-Encrypted: i=1; AHgh+Rod0ugnSTvTLXSRkdTU15xMQGVqVqmpVLavEMGzGlao83wfGx/RmiMM7QZAOn4O6XUf5PJuBp2w6/cO@vger.kernel.org
X-Gm-Message-State: AOJu0Ywti++/Af0p1nLUTeFiRHZ5WnbR253IpDAYAjVvS5SA4gkzNift
	+jBHszoTo6ZID7dydwkSocqr0txm3cc05NtVY5T59bhAum3Wga1jSZzM
X-Gm-Gg: AfdE7ckww3kCqXTc6nZYHDmYjRX8F3ebrsrno4rTjW7VE9OlPUpwI6Ja1AuO2CIRBSG
	gzw0BLYFn0ntBsL+KIcj8wDmVGawfoFcomqc1Y2aHluEcrfhjmveFxP8GQWl98WybKnWJ/DerY7
	EQ1r9vTQGzpRiNwqjPR4ZPS0D2ptSIqLWSRATK0o44x66l56PHmPLSb5prE+glQm3PCz820I94f
	VeRkQVuHqjkfTrog4jkSsVMsHg5MDGX1eX2Oq5+rjK8xf9fKP+VI0z/GZM2HqDa0lMSIze9BnJ+
	xD+FA4varZAREYM+EXnjTe+47UULDqHNn6ITPTyUbBA2RnyW35ug7d54eO7uKtsk5VlcVGUXlDD
	155g4dFSMMfiEPz+kQ1C187zUnugKkBy4XyT+lGW4MYmkon8ZoV1VZ6yIXjrn5RfaiNSTy9OWf+
	DSZLltgwryVDNtTAzDqrh+qQYJj9ggvSQSPsk=
X-Received: by 2002:a5d:4801:0:b0:473:53b7:e390 with SMTP id ffacd0b85a97d-47de666b175mr3923584f8f.11.1783418495132;
        Tue, 07 Jul 2026 03:01:35 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm32203122f8f.8.2026.07.07.03.01.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:34 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/5] ksmbd: send inline FinderInfo in FIND responses when READDIR_ATTR negotiated
Date: Tue,  7 Jul 2026 12:01:26 +0200
Message-ID: <20260707100129.47563-4-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100129.47563-1-g.blivet@me.com>
References: <20260707100129.47563-1-g.blivet@me.com>
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
                      name, but real macOS clients expect 24 here)
  ShortName[0..7]  = resource fork size (0 -- no resource forks)
  ShortName[8..23] = compressed FinderInfo (all zero: type/creator
                      unset, client falls back to extension-based
                      icon/type detection, consistent with the
                      AFP_AfpInfo synthesis this mirrors)
  Reserved2        = Unix mode bits
Reparse-point status is still carried via ExtFileAttributes rather
than EaSize once READDIR_ATTR is active, since EaSize is repurposed
for max_access.

This wire format was reverse-engineered from macOS smbfs.kext network
behavior (Apple has not published it) and cross-checked against
Samba's vfs_fruit marshalling (source3/smbd/smb2_trans2.c,
SMB_FIND_ID_BOTH_DIRECTORY_INFO), which implements the same extension
for the same reason and confirms both the max_access expansion and the
ShortNameLength=24 behavior.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 57 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8b81c712e..b1be4df04 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4649,17 +4649,64 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 
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
+			 * there's no short name, but real macOS clients
+			 * expect it set to 24 for READDIR_ATTR entries --
+			 * confirmed in Samba's vfs_fruit marshalling
+			 * (smb2_trans2.c): "on the wire behaviour shows
+			 * its set to 24 by clients."
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

