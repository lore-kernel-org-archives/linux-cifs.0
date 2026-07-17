Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5DD22301
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 07:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784272542; cv=none; b=mOlwB/YhGM2iVlLryF1JsZR6XxfzE4VzMikI9X73O4xDhWSl3TpGIyh/k8oB0NaRkybFItJgPUQNKdmQKQgJwhfwaUAHcPEkbPfo7uKTabkwO5HNdlufiI15kVJandW6yxovnlrgiB3LOUJBNj6SpvP/UI1LYTjqixm1/Qk4/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784272542; c=relaxed/simple;
	bh=74fsYrB85mbRRrxbwsECaWOK7BAz0ked2rrAbVJFzQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=krGl98Lbii6lPcokGlEit0IUaepc+jP00kp4K5v5a68E7bFRrUhKFIcqqSwtfkqPqh8GRuqzmaAXmD37oKthPMrQibAv7hfDnqdoFs+IIu+XXsJP7oWZ7OZp4nivQjU0sZUNqZKd71f8L5vdRfxas5qGfl/dGhrvp3hayedt8kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXFSm0CK; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXFSm0CK"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4954afac04bso1939895e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 00:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784272539; x=1784877339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6KD+ZXPcax0y8blp/+0Y6zGTf0RaP23ryh/m2W0ZrVc=;
        b=PXFSm0CKvebJOO023IVyiUU+3uYZ/ST/fLmNAt8FLapIL2vqnxnkw7b+v4KU9/Is9u
         +9YUASf+OjJuJyQ2D5SqGVrZ77pmo9TJf1BoNWhae0Lojc0gpGX2qO/MSeC3XonhG43N
         Fkpe6xeqyhLppC6Dz5AiImQWZcaXIQmcdaUZUN8JJAbaJJKj2xgR8+QsJ8FOeoauPzu6
         Pe0veMuFqM/tg6+CS18IjSgv4+AjRI7u28FbyySo24dDQINIoUFpp0i7CzZ/feAbZoqv
         SpCwe45ZjaaZWJ9N8ttskMg609gMvHiWCuW10CR4FQ3cx9wSztEKJs8iDvAV4p0Nsbyh
         Jh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784272539; x=1784877339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6KD+ZXPcax0y8blp/+0Y6zGTf0RaP23ryh/m2W0ZrVc=;
        b=r6dDOPL0ePDi9uDAYIa6Y0KBy0Sxg3S5v1YgYIogU85kb1gDUjIg56yngydMP3mXPG
         UvuI/9W3jklhOsBS01o8chQsVniUA1fkFH+aA/sn4S3vKeoTXRguv/r279DGKBXAvyz0
         AhyfMmgnffi0MVoDgX+b58X8RC2phsYdj2+IMJzr6J87J80FzbLP+jCVtaOhLFr07Pzb
         aX0RQCUbF6ZnoZbyWTpu7/jjKoJJWOWgnFaJo0SSl6Zb2NxeE33m1TT7izZkvrlmYSZo
         MbSDWJbFS6yN2Mz5IloxnBPhnBFLJRZIcBtkS0SBDddOKfFY5vc44YCkSP6M4Zo12RZt
         XNtg==
X-Forwarded-Encrypted: i=1; AHgh+Rqifh11Fg1S18msTUKHh3d9QKc095AJRBLICkUpN+YbOkDuG2c5qjFYFcYzSbcMXTE8C7pcvZGA5haR@vger.kernel.org
X-Gm-Message-State: AOJu0YxV4Fn4LMVGWT1bvxRcZTJmg64DwiKHRWlJrwZVlsGDwL8doHzm
	VCjOKi29Drg3aYacznkhXXsk0memNj6tTwJIEX5SZ4iiKOqCIJFGnr4zmgmnWQ==
X-Gm-Gg: AfdE7cneTWfnQcUFoBEfHP4r/10fRgyYAgZtnHvSpRZiFLx3tDbY+E7Ei7QPKjAZcoy
	te65GDYkH0z2L4At3dRxDLCG7T2XPqeh+vaQVi0dNRhuXMII5M+P/XTVvnRYAY+e0/FKT2bFU+t
	07WYLlqd+G7l6mnlmPh4iSnoIo/4Icpze/fHPg4OoK9z1UygOwUsuMZ6tNZYi4TTmBZ54HdvPJr
	5wajFeHpRctZbWcf978RQa3tXQy7/fCGRpsIhX4vMBQFBauAsuUZisVjYiVSwCwiHMwGzkgbN4G
	1+BJTRZCj1MpmZhwB+qqs0rUpRDs2W/GvoR+RgrL31YLFqB6IFOidmZrI+smNoNCLNS0edWMWzi
	MTS0kqBDbmDy/y+S2g1045yhTuzxqxu4qGxkdPId4ladhm1DmA70l/Ulp7jj83EpChDoOzrZ9U1
	bniy7T4V+a+Aw0lHeGDFt0SlqGaI84RTUu
X-Received: by 2002:a05:600c:1d15:b0:495:3f26:4f30 with SMTP id 5b1f17b1804b1-4954a3e6e08mr13720755e9.6.1784272539172;
        Fri, 17 Jul 2026 00:15:39 -0700 (PDT)
Received: from localhost.localdomain ([82.67.171.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549a47de7sm28052965e9.7.2026.07.17.00.15.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Jul 2026 00:15:38 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: linkinjeon@kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: fix maximal access leak when object has no NT ACL
Date: Fri, 17 Jul 2026 09:15:04 +0200
Message-ID: <20260717071508.7297-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_open()'s maximal-access handling sets maximal_access to the
FILE_MAXIMAL_ACCESS_LE request sentinel, then calls
smb_check_perm_dacl() to compute the real access mask from the
object's DACL.

smb_check_perm_dacl() returns success without touching *pdaccess when
the object has no stored NT ACL xattr (ksmbd_vfs_get_sd_xattr() fails,
taking an early goto err_out with rc still 0). This leaves
maximal_access holding the raw FILE_MAXIMAL_ACCESS_LE sentinel instead
of a real access mask.

Observed live: a freshly-created share root shows macOS's "no entry"
(prohibited-access) badge on connect, even though POSIX permissions
clearly allow access -- macOS requests maximal access via the MxAc
create context on every share-root open, not via DesiredAccess, so it
trusts the leaked sentinel verbatim instead of falling through to the
correct POSIX-based path.

Fall back to ksmbd_vfs_query_maximal_access() -- the same POSIX-based
computation already used for the DesiredAccess-requested-maximal-access
case below -- whenever the sentinel comes back unmodified.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
---
 fs/smb/server/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 602b60417..1a9009025 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4156,6 +4156,17 @@ int smb2_open(struct ksmbd_work *work)
 						 0, sess->user->uid, false);
 			if (rc)
 				goto err_out;
+
+			/*
+			 * smb_check_perm_dacl() returns success without
+			 * touching *pdaccess when the object has no stored
+			 * NT ACL, leaving maximal_access as the
+			 * FILE_MAXIMAL_ACCESS_LE request sentinel instead of
+			 * a real access mask.
+			 */
+			if (maximal_access == FILE_MAXIMAL_ACCESS_LE)
+				ksmbd_vfs_query_maximal_access(idmap, path.dentry,
+							       &maximal_access);
 		}
 	}
 

base-commit: b0532660f76e08c75143d9d030a9e8c4f2e2bb1e
-- 
2.43.0

