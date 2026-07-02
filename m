Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720693A5E87
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992163; cv=none; b=m44gecxpduv+ZkV4IIeRkuCcfpYKhWZz4v+k6wXY9Ow2qGuO0sEVzGb0y0UR4QcNlKYD99i3RTECNktS+TGYGns2zM9Zd8jYa1oDxm/n98f9ztSdsRvxMnzPQQWPgKk82EfJXPCKReOzKXZQShDiF2dTs9K98NbtOGENMhmMhPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992163; c=relaxed/simple;
	bh=awqTlgpDXXNPiMddpl6/icRCFqOKguUA0X8IxUTpvO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuxVb1vGuypSbbPzzfINRnyr+1zUzVWdB5K9yF8gN+Kq+AL4T+nCj0HJqZe/33AG8JXSAwZtCUbpnOMi60LWfQ6SvE4ft1EQ7QINb5xWmap9+513gigi6NSb3UArDLd/PnfTocc4Zllj56/5M+Arayosim3J5SCY6QMW7oGgN+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RNY2najJ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNY2najJ"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c88973b6965so395833a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992159; x=1783596959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azgFA9QsjHUCJwWt4I+HuOmbFV1W60h2+aAACqXgEZY=;
        b=RNY2najJMPuhlSuyEp1tEGF8S5zh3sgp/woOidqL2fpNonnR5ZracuWGWV0j338+sj
         /rP2eybtVmm3mXnFuCvT4qPCrIOcacUdgstSCaKgPMk2Wibr1sDYPqfUAHy1o5LfBKF+
         MOp+vKDRSFQq9Trhc3wjqE9XJslhfaIUmQdhfNPz+/HB3DqRBYf1LUS1r5/vNg2Vs9J7
         b+JLOZazANmWszpba1JlsgIEM3h7rbBDLDxXqow8vS54ehg686O38xGcgNgOZLmVyrXV
         D1rScScuejGABtg0L3Swz81LujMvdQlEdbEcVx6VpIlrwGy5FHDwh84ZyTB30tRFJfB8
         fCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992159; x=1783596959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=azgFA9QsjHUCJwWt4I+HuOmbFV1W60h2+aAACqXgEZY=;
        b=NgbdbvVwm8DXN6mZqYZ95B9OYeNeb7asI7E5uh7Bmq1ZIjhhbYEMBNMVVbTcH/ba0l
         NoJTvtO/nMPlCwUyVwtA1PePyDimcTw//Xh8PQoFxjSioq4dJErU2DE2Ph5pPChm/n58
         8foih1rkWSujWpvxVGf2LS9qjwp0q5mqNrlDuVrKupGXDJ0Q+FIUK0+oz0bhELuXWoxs
         A9zP8MeUMHNFFEB0es5XvZgN3hjYS24pcIAN/B1q7zeLkuPCSSEMWe8f4oZ31pfocevW
         mkI3BM/oAAD3IRpvABbZnCxiRnHYeasH401wK7/lCH95AcqjOdZh9y177LB/sKY3xggg
         9Ntw==
X-Gm-Message-State: AOJu0Yw7z00kXrVUwJooCXjutTKxv9XRpxynsPY3qArFut+ENEvS+LAJ
	qJqA2+nwZ8jPcglHz5iUQdJxEFb8Glpa1V6/I1b7tq8OfmNTC5+io91s0Wmh0w==
X-Gm-Gg: AfdE7cmzcddGPA8fehX2TSgU5WeCDtNV/vvmbgosakinscAsx/TVVM5ooRYpPrMMwN4
	s2Y7uBfeK+DVJ4X8mgT7EFfLXlefpZvPT5ukCzzsQf8C7SuGySRsZlzIZY7rZQm3x6h5mGi+Lyk
	8va9wB2SbSETmWPIYhlYmS8sOUCJ3y0qiVGhnJFMCh/jluh1O0rf7etDlIxWSN9Xs/Z7eEXvUD6
	UpydR1tVxJwbtEdi9poXtU/xQRaNWuz4G8F9wgRBClleD45L8emYb07ui4F5AFpv1T0DDEbZ1Oq
	1G35CoNMlOFDjOCPbNm4W0+bB/sa+FtUZQyH8IK0Kxuj5HgZAGZbJtux2awao1outQH0QBNhRzC
	lly++B1Nc55gd4fGzZPozmlTK5ONGk2FcxO3uDDxRyaK+IjIu4rgXsaVMhtojvnKymJr1K//B40
	EBFtWM3M1RJM7cboUtGjIjGlnjoQOWToS6J4ogO8gHJg3ujmnDVKJHz7MMsY7+u1x1KZoMn12IA
	ISd+SdxeVak
X-Received: by 2002:a05:6a20:d508:b0:398:76d4:c7e9 with SMTP id adf61e73a8af0-3bfd28b5ec6mr9752039637.35.1782992159368;
        Thu, 02 Jul 2026 04:35:59 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:35:59 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 6/9] smb: client: move struct tcon_list to cifsglob.h
Date: Thu,  2 Jul 2026 11:35:32 +0000
Message-ID: <20260702113535.4044308-7-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

struct tcon_list is a small list-node wrapper that pairs a list_head
with a cifs_tcon pointer, used to safely iterate tcons under a
superblock outside tlink_tree_lock.

It is currently file-static in misc.c, used only by
cifs_close_all_deferred_files_sb().  Move it next to the similar
struct file_list in cifsglob.h so that other _sb() iteration helpers
can reuse it instead of redefining the same shape locally.

No functional change.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifsglob.h | 5 +++++
 fs/smb/client/misc.c     | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a462c1590a9e..38e27ba6d8f6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1807,6 +1807,11 @@ struct file_list {
 	struct cifsFileInfo *cfile;
 };
 
+struct tcon_list {
+	struct list_head entry;
+	struct cifs_tcon *tcon;
+};
+
 struct cifs_mount_ctx {
 	struct cifs_sb_info *cifs_sb;
 	struct smb3_fs_context *fs_ctx;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 0c54b9b79a2c..7ef135dc8268 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -28,11 +28,6 @@
 #include "fs_context.h"
 #include "cached_dir.h"
 
-struct tcon_list {
-	struct list_head entry;
-	struct cifs_tcon *tcon;
-};
-
 /* The xid serves as a useful identifier for each incoming vfs request,
    in a similar way to the mid which is useful to track each sent smb,
    and CurrentXid can also provide a running counter (although it
-- 
2.43.0

