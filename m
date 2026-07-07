Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E73D952F
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418499; cv=none; b=Ibv04n041ZLlOsThYzImGEAYuEstn9wuOtRirMZ7AAyXura+zilv5m2TRNXh+BrWOhxms0+890o/tUQnnnXUQDdNBwrOZRVYyCKTEN896m+tCwoQ7jDrjoNewjxZ7Slnu1JpDjTgEmUSIb9dQE9XwsBbevFKwI7/3i4mn/y8uxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418499; c=relaxed/simple;
	bh=7TJd/OR+hNgJFec40x8iCg2HzGRO84lq7u55aY28lf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/pnOk7dq1qG1fotrs5zwMMXhem9fRtKaSZizPLNjavFVqKdRiznMIYy6lh4xR8nzDnFGDgbHNVeZPAp89SRLuenn/EunzbxAngd/16atS7DpNvZo0HevngtwgJmonTb+FqraDIJYXUyLcOwEjyXMmwgO6JkwMttaBw2kmHfbFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GdFNUELh; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GdFNUELh"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47db714766aso240011f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418496; x=1784023296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9CjVKRsj11I+0RJYvEftPDbm/ynuedIxEOtlfLwFL00=;
        b=GdFNUELhOSVxvpaJcTTuRZ95tQ+y1eQS6x0XpTeAnRf9tzzSRYU/nDJZdOlM+4bxXD
         IZ2s8M7zECuDiCKirqdg7psqCQC8pqqLZnjT4iKLFjnGzuhq6ndAenxD4dP5cdxfcPLM
         Qoz58gS6ppmjdAvzErcESpt+/gYR70pSpHfTLjIdKe03JeLcTola1J7MqKPVAPn0ACYK
         lULd8YTEVirKvv7wsW397w/V/6d9Tm2+UKzGlDHabFQDOqleV5DzdjCbsT6tP9qiMswi
         qHAp4EU+DPSSS6Eu6Q/ixgodQYRhFT9dTJF98+u7G1MnDPOwGw7EwIEbXHrJ8LAV7ERb
         3k4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418496; x=1784023296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9CjVKRsj11I+0RJYvEftPDbm/ynuedIxEOtlfLwFL00=;
        b=Q3auKi9wXgRlS2MysGmNe6W6GTy8QwvmHBuR8W36C8Utz7ZomJUzM8I+6Lp7U7D2uV
         Nsgb9UOdHbvH6gK5/CcBepIx5BBjzlG6P7ZQW5mSzckPBFHhvtn9std4H6arn6JgbIQX
         jJl6RhvMzlgz9JOh8V6xUmdYiNJfGL30T9GcvqqB68+VkLDdD034OnR7kPlJ+vg1Wvic
         Zsq0enfEu58PQbRrc7h2oTZsLr+CUgrftTh3pPcuSOMCUkQ1+cy7oBqYd6crvwphfv4s
         4NG/5eZhsriiO5MszTHAgtZZMdvvZfyEGzISLsMeK961olgyX4uK7HKMEvdaACGu9ft4
         fISQ==
X-Forwarded-Encrypted: i=1; AHgh+RqOy1dp06NT/68NNy1dHk3X8eJ89HNKYkbjTxdtb91GfMjFxHJ7hXshcGDn4lluA/l6urQVmX/+nSee@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9EasaTaIntVuwR+O0Uvj3memV5lmOflft5+W0MckllObJlFZA
	OvOEd+lnyDjimHnPb3aa/xp6yI/z7uINDqKSGEzF5AKu5OSvvzeO+iOz
X-Gm-Gg: AfdE7clW313Mx2zJh3tlSJuAH+Xz6Y2l90pPwl29yTbaSSbKF7to1YOKDXCfJP7X+oo
	N9LF/Tj7J/VXlRwVsbgHVA01B6JmbRVZdqXAOFaxQgcSUh2b9//EUiMOerVkEljGlCkx3VFPRnm
	dXQVUcxlkhNs5yiul6jx0lDMA2E66WE2/3IHi8SCEgeijmPJOMOvsio8kPM3WiZJGu59xNNiRG+
	zIu3npVa5EtdlLIVZvYt1QPH7jI/tbeXDdHARMs30em6siWTD6DHWfnj1SpX9hLFIMdr8nC8pmh
	wxxn0LE7DAVvuxLj3Jmtp8GQ7HtJGu1C2zevNqsk1wZpF1YWg+xyAC0WF9ZPKpzFAfhJ8pVLms9
	0wkQi3ntG87Lhgvn3V5x9Hudhmqj5v+FpPFHPTwApzxCgSnPjdEVdYZ3ENa7QKu0tKVU3GIvn+1
	0Mnq+kSIgsL2EHAk0bgQJ5NUEVc9d/sTSQ1bFBf6UDQOYxhg==
X-Received: by 2002:a05:6000:3104:b0:478:3df9:5d8c with SMTP id ffacd0b85a97d-47de97d595bmr2352140f8f.2.1783418494558;
        Tue, 07 Jul 2026 03:01:34 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm32203122f8f.8.2026.07.07.03.01.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:34 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/5] ksmbd: synthesize empty AFP_AfpInfo xattr on first probe
Date: Tue,  7 Jul 2026 12:01:25 +0200
Message-ID: <20260707100129.47563-3-g.blivet@me.com>
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

Once a server advertises the AAPL COPYFILE capability, macOS requires
an AFP_AfpInfo stream on every file it looks at for Finder type/
creator/icon resolution. smb2_set_stream_name_xattr() currently
returns -EBADF (STATUS_OBJECT_NAME_NOT_FOUND) when a client opens
AFP_AfpInfo with FILE_OPEN disposition and the xattr doesn't exist
yet, which macOS treats as fatal for that file: Finder falls back to
showing a generic icon, and file operations that depend on succeeding
against this stream (e.g. Cmd+D duplication) fail.

Synthesize a 60-byte zeroed AFP_AfpInfo xattr (magic 0x00051607,
version 0x00020000, both big-endian per the AFP_AfpInfo wire format)
on first FILE_OPEN probe instead, matching Samba's vfs_fruit module.
type=0/creator=0 tells macOS to fall back to extension-based type
detection, which is correct for files with no explicit Finder
metadata. The synthesized xattr persists on disk, so this only pays
the extra write once per file; a later genuine write from macOS (e.g.
after the user assigns a custom icon) overwrites it normally.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dce2a1088..8b81c712e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2824,6 +2824,21 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return 0;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
+		if (!strcmp(stream_name, "AFP_AfpInfo")) {
+			/*
+			 * Synthesize an empty AFP_AfpInfo xattr on first access.
+			 * type=0/creator=0 tells macOS to use the file extension
+			 * for icon and type detection. Matches Samba vfs_fruit.
+			 */
+			static const u8 afpinfo_empty[60] = {
+				0x00, 0x05, 0x16, 0x07, /* magic  0x00051607 BE */
+				0x00, 0x02, 0x00, 0x00, /* version 0x00020000 BE */
+			};
+			rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name,
+						(void *)afpinfo_empty,
+						sizeof(afpinfo_empty), 0, false);
+			return rc < 0 ? rc : 0;
+		}
 		ksmbd_debug(SMB, "XATTR stream name lookup failed: %d\n", rc);
 		return -EBADF;
 	}
-- 
2.43.0

