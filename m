Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795285585;
	b=ubFNLDeJmFhlyTf1qW4K13Tv8VPlITmJ5+wSpdl2QXv3D9FC/5BSs44AWeOmNDYPmaxm
	 B03SI2rmGePhJtupQsobXRn4zQ64MxWPlRYNkLjCh3EtxNgsUA50MsSKK6IUEBIpym3of
	 QxZyTMJ83RK4ga1/e8ZNKmTIQ1krOTTFrzF3Lagbrl/dAQrs1GIaMqLye0Pn1KsE6393F
	 KsfBaAH+jMockz+IFUhWPaW0BcUM9o1UvTg2KB4RACNL1WPRaz7r5jps7a52fAkQghQGT
	 Zo3zSpnbyuOdvxqueIA4pUtJ8dVhzO1WiGxcJfqP75ZRRvVZxaXQ6O/wZMFBl3cbizg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795285585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yAYWGM+wOxQBk0PpmM5hBcytMWSDnG3ENBg6Zhdqtzg=;
	b=GVYZXDI0lFOSphcaFTBpXwLW4OjBYFEQjIiJ8m+isFeqBGa12X7QKyTjr6GHy8cyrYld
	 Wgr619E4SFqMj0anVYhGrkUrP9hhhf2oCkkISYoVIu9K0Hcx57LRB+eV7ezTj40S/tB68
	 LbfBdLH5/9HlvOy1VkIGLtCemm/9w4yClVHxKonSKgTrXJhDMgsfOpRVWJIVYgBOfEnN/
	 YMID2tpKmBZLAbyf3SYJTEPf0Wm5aYbWjRo0aKqQSDHOTG/uw6oFWPxOUNsWHsLvuKDbx
	 2KLNwB/eI8TBoiqDpLEB8Vis+lf52JFpabjTdfZh10+V1d6wXBA8xc25htYmvTm65kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZKFalGLT;
	arc=none smtp.remote-ip=74.125.229.2
Received: from mail-dy2-f2.google.com (mail-dy2-f2.google.com [74.125.229.2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027EF606A32A
	for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 18:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 027EF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZKFalGLT
Received: by mail-dy2-f2.google.com with SMTP id 5a478bee46e88-327b1d5824fso1741146eec.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 10:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795285584; x=1795890384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yAYWGM+wOxQBk0PpmM5hBcytMWSDnG3ENBg6Zhdqtzg=;
        b=ZKFalGLT+aaXpivK/3Ypqu5a9Dkkhf0E1d8u50CSUyKOUx1qXxWWgYIjq5HL0qdJ3d
         GszeRiIDfnLIuMzozueKOunkt3An+6RfLHfeJBnm4RsTur6dZjyT/WtcJYttI/tG9qTL
         dBU1FMdSG6pOnscPKzCn3U6oI8nbAzb3EUHO2lnS+TJiyneWm//WuXqr3xFcPUGh2Id1
         iacbneDDYY9d4znevKwusXbesbV5pK1s7Y/H0appouJ6HRBTq0X3j48Pg+tv+DGwR4An
         SA387ljnRYGDGn4+ZcJupx4Yw18m4gGrQ3YVna5wda2zQTPeYCr607/VjQJaoYWvQbbU
         PWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795285584; x=1795890384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yAYWGM+wOxQBk0PpmM5hBcytMWSDnG3ENBg6Zhdqtzg=;
        b=IE2z5GhQrHqTkAoZ2ZGqju1Ctg8NLqeXfj4yYmv5nSYOrV9nFNV4eyjq1lr9xDAHNm
         cnHJxBqctZ9tsvvgPi/BlnobAtiEeeCr4eG/L95PjZn3hJxqqzLPLc+6WmuczUy0nTBK
         xBN+IEDYSloTxj7iFnICFyRhYuV7XZcIWeguOKdQYCl4jHUor+PnjiYaku+cnzBL0jsu
         TGLkmBeD1coSDMc6tVwyzeFZe/LU0TR0lc11Ho4o+U8fbc0woBQzM4Tz+iRYL9vIFZHL
         qSAr4PYynuI/Ru4ZC8JlwzAnqqeZacbu8hu+jt0u6g0kBFv9FEL4m1nelbY89lyxh1uh
         BThQ==
X-Forwarded-Encrypted: i=1; AL+hErEkr5wQdIGNshaMuL9iDdSgBd+B50p4Ld6AGIM60Z4uguCdYgsFqEkjPJ7+56qUx6X5LhBJDDE3jiH/@vger.kernel.org
X-Gm-Message-State: APuU4Z9glMYRmuUx04jzkGWK5eXknb/rRZURddp4GG9oVOLIiz8rxBr9
	y6qsFiDgQ8p6sxPGkmnR9IdOczRQ0o4QmJkDQ/mQcMMWOTnZPStMcgu2
X-Gm-Gg: AZFdTZe0YH7uBHO1OkDsNakXD3/haWjuE1jYzK26FBkUlz168znVJgxkzPFBFdTpbtD
	P3bj8fPA9CM/oJUDEXCOyyiFX1bUBF48aKARcSgY54SZs+JktbmkrOkxYlUUCOr+EvDm9/xSFjZ
	7PDA32ZHPGcAfN07WAqzPavs5Wy6cs8ivJKffTcJ6Si81yWfdYlafmPqpLZb8AVBTZO3KfjIsyn
	prO/BRpfyCc4QcQiM3JQjWWyE8hdFR/eV+YMnl60svYDM8cIXrdT4a44aZknjpkTGkU7TBw7dpH
	VozVKmlcE+LiQoV5T9WrbPNURZeRhejveXC5QmAxz9LffwUbMifQSx8TVNZmcG8NSqimPKL6qo2
	bdcxDi2hdlLjR7bus0zd1LbSJAQZL7Q5860aoYxcpJYzmXMMlui3TOUgIxy28kNHPCFeB8PAIGa
	T3Z/4Glb15X2RgdCVTHTwauo2qtBmcSAm4pMcAdV0qBQTVJxDpRvlBIVoHZZijeMdYAb4tWtDfa
	M0+CPUaPJZt+cjmhRxh9nAbIkO8QxOp64gVeT9yvSwL5o98R9XYlbJ0QmxsjfbtufsI+Eoid2fj
	O7vKcpGZaW1N416R6lJhTBm7iPiywC2x7e0m2vV5e04+xCUd2fUsue8gUsDaiMpR9vPtlqQ5Z25
	mF8PcEB/Y6Zjv3CYd6IWd1rvYbL1R4Ci15lFf1A==
X-Received: by 2002:a05:7301:dd94:b0:36c:9afe:fcd8 with SMTP id 5a478bee46e88-3856f559cfemr6470210eec.30.1795285583855;
        Sat, 21 Nov 2026 10:26:23 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385665f21aesm25583535eec.4.2026.11.21.10.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 10:26:23 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	hyc.lee@gmail.com,
	lsahlber@redhat.com,
	icb@fastmail.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v2] ksmbd: refuse to open an append-only file for writing without O_APPEND
Date: Sat, 21 Nov 2026 18:23:13 +0000
Message-ID: <20261121182313.43201-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_open() opens the file with dentry_open(), which does not go through
may_open(). inode_permission() refuses write access to an immutable
inode, but nothing looks at S_APPEND. A client that has write permission
on an append-only file can open it for writing and overwrite the data
that is already there, which open(2) on the server and nfsd do not
allow.

Refuse the open like may_open() does, when the file is opened for
writing without O_APPEND or the create disposition asks to overwrite
it. smb2_create_open_flags() also selects O_WRONLY or O_RDWR for
FILE_WRITE_EA and FILE_WRITE_ATTRIBUTES, so these opens are refused
too.

An open with MAXIMUM_ALLOWED is granted the write rights that the
permission bits or the stored DACL allow and would be refused as well.
Leave the write rights that the client did not ask for explicitly out
of the access granted to such an open, so that it gets a handle for
reading. The maximal access returned in the MxAc create context is not
changed.

Directories are left alone: an append-only directory still takes new
entries.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Refuse every open for writing without O_APPEND, not only the ones
  that ask for FILE_WRITE_DATA or FILE_APPEND_DATA. A handle opened for
  FILE_WRITE_ATTRIBUTES could still reach kernel_write() through
  FSCTL_SET_SPARSE.
- Refuse an overwrite disposition up front. The truncating ones used to
  fail in vfs_truncate() after the oplocks were broken, with
  STATUS_SHARING_VIOLATION.
- Drop the write rights of a MAXIMUM_ALLOWED open in smb2_open()
  instead of ksmbd_vfs_query_maximal_access(), so that a file with a
  stored DACL is covered too and the MxAc reply stays as it is.
- Keep the rights the client asked for next to MAXIMUM_ALLOWED. A POSIX
  open for MAXIMUM_ALLOWED | FILE_APPEND_DATA can append again, as
  reported by Ian Bridges.

v1: https://lore.kernel.org/linux-cifs/20261120071553.28739-1-dennylin0707@gmail.com/

 fs/smb/server/smb2pdu.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6bd63c5e7da3..bcd25c197ffa 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5028,6 +5028,14 @@ int smb2_open(struct ksmbd_work *work)
 		maximal_access = daccess;
 	}
 
+	if (req->DesiredAccess & FILE_MAXIMAL_ACCESS_LE && file_present &&
+	    IS_APPEND(d_inode(path.dentry)) &&
+	    !S_ISDIR(d_inode(path.dentry)->i_mode)) {
+		__le32 asked = smb_map_generic_desired_access(req->DesiredAccess);
+
+		daccess &= ~(FILE_WRITE_DESIRE_ACCESS_LE & ~asked);
+	}
+
 	/* MAXIMUM_ALLOWED may not have granted the requested DELETE */
 	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE &&
 	    !(daccess & FILE_DELETE_LE)) {
@@ -5122,6 +5130,19 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	if (IS_APPEND(d_inode(path.dentry)) &&
+	    !S_ISDIR(d_inode(path.dentry)->i_mode)) {
+		if ((open_flags & O_ACCMODE) != O_RDONLY &&
+		    !(open_flags & O_APPEND)) {
+			rc = -EACCES;
+			goto err_out;
+		}
+		if (open_flags & O_TRUNC) {
+			rc = -EACCES;
+			goto err_out;
+		}
+	}
+
 	rc = 0;
 	filp = dentry_open(&path, open_flags, current_cred());
 	if (IS_ERR(filp)) {
-- 
2.43.0

