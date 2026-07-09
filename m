Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178E7EEBA
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555623; cv=none; b=Rc8R9ElVKmupFAjWbCsp2uCAaIJiUnN28BHwrk0JKLf60y0ZXxId3G+DBM5oxz9Rf7egrKy2eBJ+EmvwzCuxnKHuvp3Qv7py7d44iu5pmLbZspe9F91N/JPvCgjHtgDBbTqZBhkmzR5QC4avkVCyNuWqv3PXqeVMXX6jvSF4R4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555623; c=relaxed/simple;
	bh=UO13XvTcT5R8hL1jH8gY1AQ3usBbhaMSKq4QNi/0ATA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Ai/C/Lcpo5bYybUNLOhM5sA12P5rUuykHwh7g5o/E7mBY3J91i0rk98vEClIf6dhrX0yNB9BRxtO/1vjWjQ85KPKJBVZVDVIMRdOogOeKlESLGgSX6q02LsjApk2L+dQ7yNV/LM1E5+bxvtCufnrPbK1kk4AS9x/iEgn3Izcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXJ1gDOu; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXJ1gDOu"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so2549275e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555620; x=1784160420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sck97m+4IMXzvhsPIezE+q/IUvNo97hRK438DXj9Tmg=;
        b=SXJ1gDOuqLrzHo+09QXMas+wUGR1NvvHE+WouoS7kyH/MW4nX4xwn94Dp4OCjAUUEc
         CRr3o8lIctGwn+GPXfuyTrOFx48ULDg09zRxiogD5qfcX6nWDC74qc+RA4mcHhEB5u9x
         tNIzS8bUiFbo5DK4BB4ir6idVmXZh9U9XnA6DfC24BX+dNnDjk+AUqYvy0EzXusmoBkT
         VVrmKX0YiqSXWCgm4/q4XRKTtsz1SKbFqYKVjihH41JAIIG/4uLYrpKUFmdupau3XUEk
         nwWrChVAXtQsFLbN9SwhiIDiLISQnVjzz9aC9xDL89FCCCFbaOtTQbYrz08ei2Tf5mcW
         kOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555620; x=1784160420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sck97m+4IMXzvhsPIezE+q/IUvNo97hRK438DXj9Tmg=;
        b=Xae3EwkZeH7s9xbJzZOyF5S03PZk/az8kbGsd3OF1rY6LTlrjt8eGZtMVzrTo9L83U
         WJn1lt84gignAAT/pzd1xjFihWYHgl+WsDEsLh3NBjk9wbgjcb95SrmcTnPqwLehcwId
         LOrwQ0cZECvJenxdvAxiZXMVgshChOdbFvx/7lK4B9+xKO6DUK1OXvDc9SK+7r9vVHA7
         ZhEjUGdMnkz5EpsbHU9QuvWg4K2ZRJuBjZXLjl2MSZdYxYa6vowLXc6EHy6M1CfOJ7g7
         zWQwIfFotTsItU8fCzDkSVKQx4fTPFaBcdxeLRXyLDuLAVIkYlj/RwKadkGJYJHSHmL8
         wd6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr2PLiFiLQZ6VvHU3lVy+/lz33xGmL4Z+9dqVJRCxMd83olzQ28FH6q9aNV7FKN5oqJnf6EGEBzl9KY@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo/+UweFQSHXLkWV+Ky4TPfyKjYmEsZj5/JS3WYEjk81uWkvUU
	LpxorKp9LTBiwBelXGgR1vMc56GYocTM1IXraoXW18ci2ySzS0Nxl/LT
X-Gm-Gg: AfdE7cm5VQAKs3uSyxDE9z6DCFTiXYtYATZb71f09YgBB8wf1eGLEwOysQTMjzEpJ6U
	uArOI9lyuHWC9k2gobvIylKxv6nafhY7DCJ068lA4ZhRmoa2D81HY7SLEk4rNC8Pf+dWJNEelDv
	h1qRdBbVS2f3ztUwCi/4hLb4AZgmXnJ+bob9Pvinm0V+rMjVISVtcR1djlp+WgXNANTMjXI6pwH
	zYkUHN/N3PH0Rza1imGAVpeepJ4I8+EPvNkXdUZoLAiZOiyDDQF7Q9ZbDZ8hDb+1YXg6ocF8J7p
	0ezd3xnyH3fx+aj99rx7vKJ9RKZImPIKNB0fzAyUQwOGnryFJcSzEcMElUycfpiR6He2UB0H1lR
	1OXEAOb515sQjFh+tKbXSum/dW5r6A+VU4o/oZbl516CPnMy3p5M1PcHO+KjJasSPV59zjIxumc
	NABQRL3SRDB8Ed3wNngeqQyZo9yH+LXktmL+RsIUT/teXp8A==
X-Received: by 2002:a05:600c:8b72:b0:493:c634:952 with SMTP id 5b1f17b1804b1-493e69b0dc8mr42185665e9.7.1783555620439;
        Wed, 08 Jul 2026 17:07:00 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm15981925e9.0.2026.07.08.17.06.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:07:00 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 2/6] ksmbd: synthesize empty AFP_AfpInfo xattr on first probe
Date: Thu,  9 Jul 2026 02:06:08 +0200
Message-ID: <20260709000618.66534-3-g.blivet@me.com>
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
 fs/smb/server/smb2pdu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9c70e97d8..8fed5fd6d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2864,6 +2864,30 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return 0;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
+		if (!strcmp(stream_name, "AFP_AfpInfo") &&
+		    test_share_config_flag(fp->tcon->share_conf,
+					   KSMBD_SHARE_FLAG_TIME_MACHINE)) {
+			/*
+			 * Synthesize an empty AFP_AfpInfo xattr on first access.
+			 * type=0/creator=0 tells macOS to use the file extension
+			 * for icon and type detection. Matches Samba vfs_fruit.
+			 *
+			 * Scoped to TIME_MACHINE shares, matching the rest of
+			 * the AAPL series -- conn->is_aapl alone isn't a safe
+			 * gate here, since the pre-existing narrow UniqueId=0
+			 * path can also set it on ordinary, non-Time-Machine
+			 * shares whenever a Mac client happens to negotiate
+			 * AAPL there too.
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

