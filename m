Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548F306757
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232168; cv=none; b=kHA5dOd+XHPP8nc0a72mZjF4bnEtCuXh2Ebm6JPFJmxI/SHHPn3FtUP+JQyo5jG2eE6EulPUYoh0/D5zfb4OT0CQJAQRRaijAtdff4MmDdMRgEurkkcxxHsMeXVBV+ygBJgt45LC5DpPSd+ZIWII/Vpe/rwANqvM7xai8BctRA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232168; c=relaxed/simple;
	bh=9mfoAlEKza21W7C4PaEPHxjC7t15QgxueyYbVigrlVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvLFTAH7yNCsv+mr6vaEaUhPggDDWTIGYu3LYVyQipmjGhNdKq+XCex1J4nN00Dnv2Uf44+ojWXB5t0rJ9GuD+f0zOZdWkhHHhou1sJk1q/nVJ6Z9b+CR/KcD1VfshcD4SxFfb3dcIvr2fCOzA7izZvlbhY7NuliM2JwvdhfWuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=riPNWn4O; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="riPNWn4O"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bf20f6be6bso211265ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232166; x=1782836966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i9Vxb/xSaiZ8P5n8CmWGBvgirJ/kFFNj6t36EYH/cyo=;
        b=riPNWn4OUWYQPXsY6Wnp8W3TdnLO16sPJ/LUrKfQa3ix8ObFT+g22pi8svXI8buUpA
         splL3MFc0wIdrP1XnkQ6fFJoheUErqjzjK6vs0qPfU1G80lOq5SbFYGXuuiVfDfaZI9J
         NhDrNuU7H15gI8CeRcM6XgD6SsF3j35p0cl0GjOYd/nNlFn5+8ihU9pn1YRNCS1vb3K4
         5nZt8mQeKfE3+ztbSvaKpKVDcE15TpT/oDLnMhJSom4hSzDunjdFay9TYGtjXMOxygwU
         TG2QZdkjQWMiBCeDMyFo11H7kFI/urm5P/ztHzE/hbeNKdMjK2x7V3SFMmXgYBUZKc7z
         34rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232166; x=1782836966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i9Vxb/xSaiZ8P5n8CmWGBvgirJ/kFFNj6t36EYH/cyo=;
        b=K5z2DRAi94L081zM5FbAuYw2XdzlkNlyrWN7Tf/in6GwIr8wrZYd6vw39TmNt3KuwH
         N4toSJuXx5BhbhXWdnQfMgkAAUdx0B/g4oC9wRw0/C5mI33AOih2eoVwUghbSVvMPheF
         ARBVqOp8Ef/WUHjyLPBk3NRasdUv/PnlL/obKk3JCG5rfSejex17nVVo35nBj/v9Dgzr
         jvHlNrEMOEdJjamgCCdCiSDryzN14569UHf/B4nRMBw5TxUusFgjA/WfVD3/aN6aTCrn
         Vf7sK6JAkgeRbfaDRm/sXc/eyBkrP9RDe6fXPGcETk9fJ3xeB4Pu8p/f0nuupXCblsaf
         cRzQ==
X-Gm-Message-State: AOJu0Yypv6mpLy5eozSTrBGaeoi8cZEaQtz59mP9qIc0j+9YvHKl0s0U
	2EDDc86rUsBPL0Zze53tvk0Dy1MV8cP93RLtjfVnX0xwgSuhpJRL8PgKWI453lUSr4w=
X-Gm-Gg: AfdE7clWJuFVGfYg5E4hdJaH/eEN+6lHaOKFsWrImBwysmunTueILsG1dUnsUAoi56H
	X64RhuUBG6Lf2U8SUY7MMH5s4rywVNQwoU/Ay50ibtoiCQdAXfb1NXIyHtzW1UT1959aQGZdG8x
	rVbWVbhmwqNupi3aNe9V3Bux3NNpKLXP+o0MRMQdh2xWM/+VS4Lqd2baqOVS4Kf2KiWcyAtoVe4
	N/iJygdqRnZkF1Pn4D2A5P+MN3wXiNna4RxfcfCExSUC1hJoIB9QbDox1KS9ivz1oEma8nyYZ2q
	CFa8E5892LabeXdYlIrMcBpr31bJLZJMNIMcTqZbAJjfU41bqP/Y16C/vFnV/XbGW2tgUVIQOlO
	qP7tmyaNr+jQlC0xdUHJ3tdXqcxLjlDlADQpugpO/XAX2pQIu/4Mj8FzooRQhgAlcscdixSZw0J
	htBNWdrKY01A/zw96Gt5FwRIrLMLwhJr6kecFIc5XR+T34mBh8pVgcwQ==
X-Received: by 2002:a17:903:1c8:b0:2c0:b6c7:227e with SMTP id d9443c01a7336-2c718cc2034mr207381785ad.5.1782232166143;
        Tue, 23 Jun 2026 09:29:26 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:25 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v6 02/17] cifs: define variable sized buffer for querydir responses
Date: Tue, 23 Jun 2026 21:58:55 +0530
Message-ID: <20260623162910.343930-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623162910.343930-1-sprasad@microsoft.com>
References: <20260623162910.343930-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

QueryDirectory responses today are stored in one of two fixed
sized buffers: smallbuf (448 bytes) or bigbuf (16KB). These are
borrowed from server struct and are not sufficient for large-sized
query dir operations.

With this change we will now define a new buffer type specifically
for cifs_search_info to hold variable sized responses. These will
be allocated by kmalloc and freed by kfree.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/file.c     |  2 ++
 fs/smb/client/readdir.c  |  2 ++
 fs/smb/client/smb2pdu.c  | 14 +++++++++++---
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd0..79876c062d1d8 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1391,6 +1391,7 @@ struct cifs_search_info {
 	bool emptyDir:1;
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
+	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
 };
 
 #define ACL_NO_MODE	((umode_t)(-1))
@@ -1904,6 +1905,7 @@ enum cifs_find_flags {
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
 #define   CIFS_LARGE_BUFFER     2
+#define   CIFS_DYNAMIC_BUFFER   3    /* Dynamically allocated buffer */
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b60344125f271..fe862bcc99d1a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1563,6 +1563,8 @@ int cifs_closedir(struct inode *inode, struct file *file)
 		cfile->srch_inf.ntwrk_buf_start = NULL;
 		if (cfile->srch_inf.smallBuf)
 			cifs_small_buf_release(buf);
+		else if (cfile->srch_inf.is_dynamic_buf)
+			kfree(buf);
 		else
 			cifs_buf_release(buf);
 	}
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 1ff77f3d1de09..a50c86bbe60f3 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -732,6 +732,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 			if (cfile->srch_inf.smallBuf)
 				cifs_small_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
+			else if (cfile->srch_inf.is_dynamic_buf)
+				kfree(cfile->srch_inf.ntwrk_buf_start);
 			else
 				cifs_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index fbeb2156ddb6b..b4cd5514b77bc 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5636,6 +5636,8 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	if (srch_inf->ntwrk_buf_start) {
 		if (srch_inf->smallBuf)
 			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
+		else if (srch_inf->is_dynamic_buf)
+			kfree(srch_inf->ntwrk_buf_start);
 		else
 			cifs_buf_release(srch_inf->ntwrk_buf_start);
 	}
@@ -5655,12 +5657,18 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	cifs_dbg(FYI, "num entries %d last_index %lld srch start %p srch end %p\n",
 		 srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
 		 srch_inf->srch_entries_start, srch_inf->last_entry);
-	if (resp_buftype == CIFS_LARGE_BUFFER)
+	if (resp_buftype == CIFS_LARGE_BUFFER) {
 		srch_inf->smallBuf = false;
-	else if (resp_buftype == CIFS_SMALL_BUFFER)
+		srch_inf->is_dynamic_buf = false;
+	} else if (resp_buftype == CIFS_SMALL_BUFFER) {
 		srch_inf->smallBuf = true;
-	else
+		srch_inf->is_dynamic_buf = false;
+	} else if (resp_buftype == CIFS_DYNAMIC_BUFFER) {
+		srch_inf->smallBuf = false;
+		srch_inf->is_dynamic_buf = true;
+	} else {
 		cifs_tcon_dbg(VFS, "Invalid search buffer type\n");
+	}
 
 	return 0;
 }
-- 
2.43.0

