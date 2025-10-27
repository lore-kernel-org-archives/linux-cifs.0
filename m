Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9437D2DC781
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761600696; cv=none; b=LgXn3ZinPtGc/R/f9kWUgXPG9YHQ63qGjBq2iwM+tOlr08Ua2HErQ/Z9sHNlny5JczIH4RBl+QECyJ83SMIVphJj7wV6h4GaL5UBqLYbLkOQYuuoBLWHSCdt86xgDVG0lIxy3/D7rDVLeOK8/GEXVwroVUJcp23gaMwr/tgIlSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761600696; c=relaxed/simple;
	bh=9CWSF/nzZYlA2KtylSrutpEaLRFqcq4zMwV08Ok/U20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rvhSh039rWB26uoG3shJQbQlI+N6BGg8xtUKvBL14Wx/SN32siCXav6xfCUNRB5Fc643nmva+xVKD+Vw6/rjemQnEReLypMH5uyUUUtngkmU1tia/KekpgEoeer/Fr4EyxQcLBUf+m5CPEPxEA+x8GCYC3e59rFD6R1tSvW1ta8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dwna3hkT; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dwna3hkT"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso3876347f8f.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 14:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761600693; x=1762205493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=26P0nbLQlhZQxR4Bcpe0hAWOdLS3FtZcnUq3mEGdkTo=;
        b=dwna3hkTPMdf3Skzf+g22NEC7UQGRl4sU6N+EUQjIaHgZbF1vD82XZV6APWFqUEXim
         UeokhHIuNmub0KzcFlaEvQjz1Piv0HQF81jXenPB6emYwEhX5dsYTNEPtE83rB3TNLZS
         PZFFBBQ8yVqxDNpwfdHJP77ctmrCJQLwZaIEoFQRzvyX2HCngUFJyRGA/lLhAfWfkazm
         X73qEg923XsT+XcZo4QHoGXrV4r7+ZlESBjGqotJhfGuNahN+RRJ2drytl8FkF06gvml
         2qX57u7GBRr8Lee1W/+i4j+fokgR5oQuHL5eG3kHuQo8yIhI7cFImdx2fW0zIfHbKDcE
         r5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761600693; x=1762205493;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26P0nbLQlhZQxR4Bcpe0hAWOdLS3FtZcnUq3mEGdkTo=;
        b=TsBpJQDAH1548Wkj2PwDHHHWBtndzHKCQI/ysgGaBd7+8zsl29XFOrB3LfviBlj9AN
         JLhRxmqmLvDqKhlSO7fsAOFVWvN0PQUNoNex0cfvw7rfhH+0+H4L0hIbjqJD9Pqjfw62
         fm4IR0C1dLpPOagYjiwvRKTLSgYDjYEq0Uo7I2x/TuTS5r5As6cqb8dzfPKukSxCbTPB
         1zBVgJQqqgR7x79dY9H8E6hmE4mkJzEaDJ8XKt6rkd5Vc05ppGWyX69uNtgeDm6js8kk
         8fz09TRFb92MPl5/uhk6LO6/c6uZV4kgso2eXBoGQ7sYoupLv/pB0LEvKwHjzCY4TDuc
         /T/A==
X-Forwarded-Encrypted: i=1; AJvYcCUDfI0UUz9cGzpo4cvQSlU935/w/2FyIzdkgybdhdCXyceYJ64ushVtbB3DZ9zMHEmH3wCjuURSsI5y@vger.kernel.org
X-Gm-Message-State: AOJu0YzxkQ6aImY1JcHXl8DPZ22PaxVg7XZpt+eSDLQW7h+OO9TaFVtg
	ltcwH7oMxheHqcXuA6x/NbavtOcBpXDaXrKU1iOEGLFrfsUzHgiTaHQQHfB3wRPu69Q=
X-Gm-Gg: ASbGncsxfH3nxaUlVsR8yx4Zv0AbASiXSb8vGbgHqys+PqD4vQV6P6Vp7xwvIcpQJ/i
	dFsajlc0pSPGSvYyU7rCRc7D3Ht9GlXiTXsLZxCsxLKl3VNOIi6elcrsOBZCem/Ldg5s5sqfImc
	Dfhblsw0/tEP7Twr6b/NNxgJadqZO4hGxUk9ot9JZQkUfTwUS/C1yEjp0dGDi68EX+uXNL5MB0j
	mYvdoH8TDGCQd8eXKLoset2Uzh9Nw7Qov6J20V2ytGjnV5fu4KmZ7FsFDlHABh5YtCUiDFmLECG
	ogI+Ls1QUZD2PRhQl/yASaLsB5yMDsJlagAgcdR5ZOuChuhoDOWtLl15r6JhDOI49MisRACmwls
	aRg5ygJuPwZmlGedY0N18B8hNHUYHnXy1onfwxatQNK+4YGsiwRybEIjduZwdGG33A7VvTaVl+r
	ha31uk8E95HgoU3kHYLfWzgx6jeg==
X-Google-Smtp-Source: AGHT+IEu3vyqH4s5AZhdLRfUV/HZyIemPPs6XqI5+PccNeTOshcpL8I91X87cQXCfYG1IyvGqkz2BA==
X-Received: by 2002:a05:6000:2913:b0:427:526:1684 with SMTP id ffacd0b85a97d-429a7e52f6bmr1146568f8f.25.1761600692800;
        Mon, 27 Oct 2025 14:31:32 -0700 (PDT)
Received: from precision ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e42e8fsm91931145ad.105.2025.10.27.14.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 14:31:32 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix potential cfid UAF in smb2_query_info_compound
Date: Mon, 27 Oct 2025 18:29:19 -0300
Message-ID: <20251027212919.2082212-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When smb2_query_info_compound() retries, a previously allocated cfid may
have been freed in the first attempt.
Because cfid wasn't reset on replay, later cleanup could act on a stale
pointer, leading to a potential use-after-free.

Reinitialize cfid to NULL under the replay label.

Example trace (trimmed):

refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 11224 at ../lib/refcount.c:28 refcount_warn_saturate+0x9c/0x110
[...]
RIP: 0010:refcount_warn_saturate+0x9c/0x110
[...]
Call Trace:
 <TASK>
 smb2_query_info_compound+0x29c/0x5c0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 ? step_into+0x10d/0x690
 ? __legitimize_path+0x28/0x60
 smb2_queryfs+0x6a/0xf0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 smb311_queryfs+0x12d/0x140 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 ? kmem_cache_alloc+0x18a/0x340
 ? getname_flags+0x46/0x1e0
 cifs_statfs+0x9f/0x2b0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
 statfs_by_dentry+0x67/0x90
 vfs_statfs+0x16/0xd0
 user_statfs+0x54/0xa0
 __do_sys_statfs+0x20/0x50
 do_syscall_64+0x58/0x80

Fixes: 4f1fffa237692 ("cifs: commands that are retried should have replay flag set")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0f9130ef2e7d..1e39f2165e42 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2799,11 +2799,12 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	int rc;
 	__le16 *utf16_path;
-	struct cached_fid *cfid = NULL;
+	struct cached_fid *cfid;
 	int retries = 0, cur_sleep = 1;
 
 replay_again:
 	/* reinitialize for possible replay */
+	cfid = NULL;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
-- 
2.50.1

