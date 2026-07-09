Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE91367
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555568; cv=none; b=EJehCw3uvXfsykfEbW9Wv6bNWWJalDV2/XHR5eWCoj0M28WEahR5Blpib/viSSSUfFVblr4S/5kEi+Sldink02w+7E7CEB7UgiIV57xVGdV3gjY9qpkb0xlE6uRB3l4up2qq0kp1KlQf+qoBXC2rRDi1SaTTTgWB5gWLkzEv+Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555568; c=relaxed/simple;
	bh=mf/QZUQRR7urXiUWk4GvgOskt7C+Kc24a2Gnqf9M8CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEyZrFjRn3otzSEjk63gzlIDg30TEJ6K4HhBzTpiesmC4SJFAQe9V9lX6sz0jkpHpgNIiwCLDg34lro7kr1r4YiXzk3BvylPvg4zcxJAGCgR5dR/Q5KVPeA1R4EYNoS1Pmps1vbWVDlgfd8saOLDTUN4186h+szRTOJTDzOF3bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lrUH62au; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lrUH62au"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso12757855e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555565; x=1784160365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GPPrPvm8ZCl2JrsvC+tBjB/4C04nkB2qH1S33EBmcDk=;
        b=lrUH62auiPCGsmH7FV1aip0ic5BopT9/2AK/276ssoVpNAZfEbSM727Ngii2dDa4gi
         ckFBuNbL6rL941zpTuAV9RCkKdTQvsSFa/WEJe8ACzjNpGV84/3c62exUHYrn2CFu0KW
         JeV5WKFZgCh611gcBy3lO1kDcb2X5sfS2Tj/3l5dQUlqjlUF0Bg1vaRuNCkEVi2qLtDq
         vc7kHNW6FYrhfqgb9vtdI2fXMQ3XNL/wQ8Ivt3J5oMG6ZmZ3rIOPEgBQMv1zWPCqiDKx
         1L41TfqbL+C/6C5bpN4TV8CyrRqeB/MC3yC5/s/eGuYm1PBMZSOOb+cRyJ3CblHbbu2R
         yClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555565; x=1784160365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GPPrPvm8ZCl2JrsvC+tBjB/4C04nkB2qH1S33EBmcDk=;
        b=Q+LhfxB4p80kWWQBoZZf9rbtaQ8PZzzAoViPWboNT98nXl8noSRhXyPwPGPQcM8kds
         S9FCkFcLIHJzrWkQkfmjPr0/wj4U+KM9Bi9VXhmapsbAprE128PnEiwu8vmvd18KRnTj
         2V8K3rs80b/r1uKFqXOJ94YzPQalNe/ZsanDo/Z/ls0+BAP4OaxTSyRE491N3VLMCugp
         dLUeDu92iKQBK6MDJAXorHnQEZQkv92fspukbLXlFvpNYwn5GQNQi4sZ1nNuJNm8qldD
         F9mPI+7Oq7aWfW5cS0K5Sjm6NGN3fJDmTK0L7j9sZK47D+nZQKy30xCI7Vy2+Rf2cpPS
         NxiQ==
X-Forwarded-Encrypted: i=1; AHgh+RrdsjJgrE/wskZLYJN7tKMld61VPFBMEaSF149pxDHPVMf15U4hcMqOdz4jihtRKqzUd2ZxspSseGdR@vger.kernel.org
X-Gm-Message-State: AOJu0YzV/TpftH0ngJ3pGtk/yfxIAeZVg6p6GpPHTnrcWlK6BaRbZoCd
	10PKBWdGRbyR6UL1VnsH5+91K90ZumP1XzbcB4UnTpe5g8oF5E/YNfy5MtFUHpkx
X-Gm-Gg: AfdE7clNybNPCKZFdvrjgVH427oE5BM8db4Jh7aWgt39NVK/taErlFFfw8yMt9dmpMF
	Vh6V7fpX6LgOtS/UADp5wv4nOlkqTPiJjYrNk79+qe4URyc5ShABnWzMdq4Cj4aa/59Pc4F7kLj
	TAvugQeh3t9/i7LRfouIdOOgqEXGGIeDeGE2OqhRQEi9RjeiU8otfTGVm5tIq7dQrbmjeIvYRNe
	K72c+kpG6CYe1Gh8re/RrQW3I878CIYZd0+stTaLsyVJ66YZx6fWQVmNy/I+W6d0AVRp/CwEsVR
	4Anh+GeWWcguHsIjT3RQbmS9DsXquZFYtEuLkBfiCuH/KZ0t+Km5NKl/QcCJtG1SxD/mGUs+yL+
	h7IPyyyR2prvDLkCL39bO9mrlFE7TrwZTPHLkJw9cWkemwz98RQsn40j1VObdnCwJEmJXmZYGrI
	1HbJRozL8g0goAjlo3pCV/XGDjgksPbp8xEvg=
X-Received: by 2002:a05:600c:a47:b0:493:e53a:4b24 with SMTP id 5b1f17b1804b1-493e6892f99mr43195285e9.6.1783555565052;
        Wed, 08 Jul 2026 17:06:05 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:04 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 5/8] ksmbd: report actual xattr value length in stream enumeration
Date: Thu,  9 Jul 2026 02:01:08 +0200
Message-ID: <20260709000548.66445-6-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
References: <20260709000548.66445-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

get_file_stream_info() (FileStreamInformation QUERY_INFO) reported
each enumerated stream's StreamSize/StreamAllocationSize as
stream_name_len -- the byte length of the stream's *name*, not its
data. This is the same bug class already fixed for EndOfFile/
AllocationSize on an open stream handle (ksmbd_stream_eof(), added
earlier in this series), just missed at this second site: a client
enumerating streams sees a size derived from the name string length
instead of the stream's actual content length, inconsistent with
what querying the same stream by handle reports.

Compute the real value length the same way ksmbd_stream_eof() does,
via ksmbd_vfs_casexattr_len() on the already-known xattr key.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ffdae74b6..ca3d4985a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5865,8 +5865,24 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		streamlen *= 2;
 		kfree(stream_buf);
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		file_info->StreamSize = cpu_to_le64(stream_name_len);
-		file_info->StreamAllocationSize = cpu_to_le64(stream_name_len);
+		{
+			/*
+			 * stream_name_len is the byte length of the xattr's
+			 * *name*, not its value -- same class of bug
+			 * ksmbd_stream_eof() (smb2pdu.c) already fixes for
+			 * EndOfFile/AllocationSize on a stream handle; this
+			 * enumeration path needs the same real xattr value
+			 * length, not the name length reused as a size.
+			 */
+			ssize_t slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
+							       path->dentry,
+							       stream_name,
+							       strlen(stream_name));
+			loff_t ssize = slen < 0 ? 0 : (loff_t)slen;
+
+			file_info->StreamSize = cpu_to_le64(ssize);
+			file_info->StreamAllocationSize = cpu_to_le64(ssize);
+		}
 
 		nbytes += next;
 		buf_free_len -= next;
-- 
2.43.0

