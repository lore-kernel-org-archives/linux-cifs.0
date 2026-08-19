Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138C63CC7CA
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 09:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787130552; cv=none; b=iB48Aq2RzEKBj6jvPdL2ZP56TGiHNkiUHyLdEYFvFxzC2aTtvBVPYngERqJQmT+S49S/X02YQZV+Nr+c09S6JIFlc+jHu+k82eX4QSiEnBOLSLxrJDNjxNXh6e//E1T3noVWaax8nRTwaaRzyvL7HOyZXUboaBMxPdWhSwuAf8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787130552; c=relaxed/simple;
	bh=JmodvTaXREPGXLwMR9LszkkZbcM/nBfmW4O3QqESnnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SC+d20n+4IhTVyD9Z0f0Fx+ATy8r3kb2tecqjlGQYqRPAemYwJVNA6Wi6o3ws56lyxRIkUkdaDWOjI2WmtXoD0tGD28GyTZvKhtsaAoesSkVnhXyMgikjn1exhiZn5trgMXJgA4s0Dbz0qTLgmc9W+/LsSz30UAfMYXe+1ZWvhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VY4fFc3b; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VY4fFc3b"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so6863555e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 02:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787130549; x=1787735349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2UbNZOStqr4QXwJzGGjS9zVa1/oBME6yib0prBXIAgY=;
        b=VY4fFc3bkNdvdLxFuHBewVTsk/T8O8zgIoXwrsnfWGEjU1IgaLpIj9ZnwMJoM66qv+
         GdSaAwTLOD2IkOLmJBZERfikhZO0ZnbmQiD6qteDWaW6q7Crq8/Z7yXte9BiUs0I/olZ
         yt1VDfzV5v3s6EHSXBLpPk6nBIy0vG2lPTgU2PpxrlDbqpKlAWYiLm3LgajRGim+GfUt
         MczVWzt4kN/fzS7zbAeKpfov1kGMyhWyicHeRztqv6ZUJIdFocxvHtIyHbinR/Rfukfr
         KmQSOltgcAdrJT3/g2t9CyH5UzLWPa7Ndx5g+NtXFS8SD3kymdMepIEpzqrDbdoP7xw8
         oEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787130549; x=1787735349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2UbNZOStqr4QXwJzGGjS9zVa1/oBME6yib0prBXIAgY=;
        b=chZP1woBNztC4RH2chULmHKMluLIYH/SXfPR1O3kbzaTnsiqeN5wHL6egQLUWw/E9k
         uJRIYgfVwrsGmS3SjHrda+p+u22JoSa0+67lWC37Z4QjjnTMsdsbAFI0/6TsiFnTKZnJ
         t9cdIFgfX4fyaVcZvtKDptbSZS3FdnBloN81QvEF89k/H9IFB+2ST08MtXZpdvdlFOm0
         +QVgS+7grE1LKdCB6fxo0R1j3uU2fTbQz03kPDOMr1VOFFLgxKTF9TacHJgmHkOGg51k
         n6UF+kiSfFUdjTY5rzVCHKp6f5T+Ssy+BFoUGOIvQm/6pGE0tpWJNVXiVk5NxzzZi3MX
         M0kA==
X-Gm-Message-State: AOJu0YxVFdBzRExVhi1lEJVooO1qy7FMxNQauDPK+3W6FceLoNSsF2sd
	GH1PXkK2YbG3sgAd11uvujgW5xMxyerz1oJPg+StO4zyrzBnv3SD+KuptmikB36s
X-Gm-Gg: AR+sD12D97bxCuZoUnAPSQDlWBc5icsWa4kVdSuIrlEyG2RrGRgKs7TmatRkJOkq2eG
	ZHk4Wx2LjdFb2qcz3z1wKak1za9FHVQ7sWbtbCsUNYu8aRiIntNBeNSDt+MQzsFd3Ik98Yhe0UT
	0oXkGTVfQObuTbYZoSZiiOfBFjQYdJoC5m0U0WgvsD4BdodclcgWC1gO6Rktb5fy7UxUNZ2ZytB
	2nG8utzdGitnWZucKka8qIcnKrVS9/ckLs2h7+KoyKSBQQy7kMwmJQ8LCDicA6MtsgUbgME3ZVd
	Ptpo4qYEqxmmxkLHzNoIMBXHgb6b0ghiLfJ1MU82Fto1koHVMBngfvT2pesWoQK7Y7dLGaajSgS
	2gI/MBmfnn/DNxlLdv3Fjw48Q4kQDWm4imZp++KPi/yPiJLk78zNPFDxaoT3cuG+hanlEZxTtRo
	0es7s5Jf73yf+gMI/lmylPqd5Sw9G22RRPlwQkXuHTe+XhLxqd1Y3Yx1zggF8ooeW4bft2qgc+U
	9jLPLE=
X-Received: by 2002:a05:600c:a414:b0:499:adb5:e7b2 with SMTP id 5b1f17b1804b1-499adb5e7d2mr17727365e9.11.1787130549116;
        Wed, 19 Aug 2026 02:09:09 -0700 (PDT)
Received: from SurHub.localdomain ([196.188.112.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499a9e78496sm50286265e9.2.2026.08.19.02.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 02:09:08 -0700 (PDT)
From: Abdifatah Suruur <suruurism@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com
Subject: [PATCH] ksmbd: fix use-after-free of lease table in smb2_lease_break_noti()
Date: Wed, 19 Aug 2026 12:09:05 +0300
Message-ID: <20260819090905.12448-1-suruurism@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_lease_break_noti() redirects v2 lease break notifications to the
client lease channel by reading lease->l_lb->conn.  The lease table is
linked into the global lease_table_list and destroyed by
destroy_lease_table() on connection teardown, which unlinks it and
kfree()s it under write_lock(&lease_list_lock).

The break path dereferences lease->l_lb and lease->l_lb->conn without
holding lease_list_lock, so when the owning connection is torn down
concurrently (e.g. the client disconnects while another connection's
open triggers a lease break), the table can be freed between the load
and the dereference.  This is a use-after-free read of struct
lease_table; the stale conn pointer is then passed to
ksmbd_conn_releasing() and ksmbd_conn_get(), corrupting a refcount on
memory that may have been reallocated.

Take a conn reference and perform the lease-table lookup under
read_lock(&lease_list_lock), matching the lock discipline of
find_same_lease_key() and lookup_lease_in_table(), and transfer the
reference to the async work item instead of re-taking it.

Fixes: 2145945feb2c2 ("ksmbd: route v2 lease breaks on the client lease channel")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

---
 fs/smb/server/oplock.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 79787099afdc6..ac21583cb6222 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1007,20 +1007,27 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack,
 	struct lease *lease = opinfo->o_lease;
 	int ret = 0;

-	conn = READ_ONCE(opinfo->conn);
+	conn = ksmbd_conn_get(READ_ONCE(opinfo->conn));
+	read_lock(&lease_list_lock);
 	if (lease->version == 2 && lease->l_lb && lease->l_lb->conn &&
-	    !ksmbd_conn_releasing(lease->l_lb->conn))
-		conn = lease->l_lb->conn;
+	    !ksmbd_conn_releasing(lease->l_lb->conn)) {
+		ksmbd_conn_put(conn);
+		conn = ksmbd_conn_get(lease->l_lb->conn);
+	}
+	read_unlock(&lease_list_lock);
 	if (!conn)
 		return ksmbd_invalidate_durable_fd(opinfo->fid);

 	work = ksmbd_alloc_work_struct();
-	if (!work)
+	if (!work) {
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
+	}

 	br_info = kmalloc_obj(struct lease_break_info, KSMBD_DEFAULT_GFP);
 	if (!br_info) {
 		ksmbd_free_work_struct(work);
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
 	}

@@ -1036,7 +1043,7 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack,
 	memcpy(br_info->lease_key, lease->lease_key, SMB2_LEASE_KEY_SIZE);

 	work->request_buf = (char *)br_info;
-	work->conn = ksmbd_conn_get(conn);
+	work->conn = conn;
 	work->sess = opinfo->sess;

 	ksmbd_conn_r_count_inc(conn);
