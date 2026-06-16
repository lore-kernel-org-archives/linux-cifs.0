Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C23D75B8
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589268; cv=none; b=Cd5YXjaj2Fp8QBaHnS+FXhULvKDMbwPfD63ApjdT7FMhnBmzWkRNNR/mCSWsQ6Qixi49/JkbmhQ4dV1lXvR/DklAjVaLVXSBogfeGwerdtdnyrzyA2GhBUOxqJFF0y0ugs9H013BTnP+hXgBoMoGL2CUJASllV40mTcXH35i4kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589268; c=relaxed/simple;
	bh=awqTlgpDXXNPiMddpl6/icRCFqOKguUA0X8IxUTpvO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/KxrqBgvfZJkHGyQXjTgltsp4Gylrr0Llvfrj4zXSG4yE4DKDWyeF4UW47n6rvRnG76LM5kXRFL28mM2oYXOxRA5uZQfdeYn+y/HJ9yRauraQlzNy+v6K7ruC64CwWjLGLQ9noRUnHlkVGEwR7GSkYLTO5AXBOgK/cN0MJ1vcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iyn3WaEy; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iyn3WaEy"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c2da7fa321so18395135ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589267; x=1782194067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azgFA9QsjHUCJwWt4I+HuOmbFV1W60h2+aAACqXgEZY=;
        b=Iyn3WaEy4kjLQkto9rg6kkVZ8SR8NfZW7oGsHosH6tr4KLJ9SB28GmHDQar9Dfb5cb
         RST0FmyRC9Z5yCi5RRdYMT5xhxSfhyYRY2pnzUSBejSCGPQfGGL7S2sRakvGc81HTG3P
         WErqcUOUU1AkHCK6vB8vOMVGKd2Ogvvjy09FTVsd/RhlvJTr1vPmrHOCogXJYAvlzxuq
         uyYcGnhGWHs9ZnOlwOGLBVA8bpM1GRmaJV/qzyxrEiDmovc+SOyqHu5QAG/75RxQsZbv
         JNhilXo4+opNp5NvKRrep6iuT1AEDiLVwJGJ6DlUEbAUy/5Gj4VytFal75K2q5GuRSsJ
         mdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589267; x=1782194067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=azgFA9QsjHUCJwWt4I+HuOmbFV1W60h2+aAACqXgEZY=;
        b=C9ErFNLm2V0WxpFEhkzyYVCPW+qsahi22/Fg4Z8zaF5u7VkuJaenfrYfnmt1fNDJ7s
         9vGgF9dNUvqf5ABj2kW7KvLXkYLge1cfVeClLvLhVtEFx4lIFpnBY4VA+AM7LZUAcGvm
         z78SPHktU6Xd89WDM3n7b0ioQR9nO7hKdTBxQwcB+4LwE3gXQI5ywNpV9Uogx/eBiyof
         1fH1/ZrPIQq9pOZDrl/8Z1HYdqqQS2zHNLeh3pxJQl6G910+AASq2TCtR6SRlxiDLTU1
         9OzRv5+nKsNmpIFJQ+RcOly+ncj1wn+bVu/fK4IXOeoNwV3G0OgnqoH9rSppfGVgQJXw
         NUaQ==
X-Gm-Message-State: AOJu0YxU7QLuuFygzpXOsZ7bfK2one/ybDwxCx3x3Aa0bpkN8vp1zVVF
	mPgxNA2wYPBECj3uABKnnFY3KIBIQjefCfMB1keQzo4p3DgPHlXSAZHu
X-Gm-Gg: Acq92OGAVIJfTetdKVMZbDxdMMlhKmGEQCIoU1ckM8m4VwIG7hRrrIZHeietZ2gvk84
	wJ4WrEXsGaB5C8QyyE4qOYsH5hw8419EGSbQGmSVhJhatm1hpm4z0yjwuAr+5BRRd3ycQ2Ev7WH
	cpB76abrM/nyXUfr2kEM6BjM2YxhUiHLinpISLFdZ5+oAXBZNcJAJikUrQjFoKh4/RbZKB+p0xB
	YngPwX5iHg0cvg9yP2rzqUNgxxOgE1UE5InPDIQ6sfI/fWnNHjn1PFzHiBetUIVeL2wuPbXCs9p
	3xZlJU9IEm6k/BNunWdsaMJd3nKiozNt3eHQRTmSHVN+IJMNsWH6ps+G31mEZSFwgCmrLa2Htts
	rxGUR6LokJWaraOXmYcfOpLUFtVFVz2KPalzFsRmkZpcASrDJAvplSl1dDACkWeANcTD5nFMpC2
	J0JQg/3/BdgtTl/GNE3sd+0sW+DTPdT+MQ2iV+ul6j4Guhg/UG8k7+1IGNv/r7id0DjLvdXHn9+
	tefF3+WgmhWmSetSUF0YQk=
X-Received: by 2002:a17:902:d4cf:b0:2c0:c3ac:4ae6 with SMTP id d9443c01a7336-2c41255a61amr194244855ad.19.1781589267008;
        Mon, 15 Jun 2026 22:54:27 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:26 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v4 6/7] smb: client: move struct tcon_list to cifsglob.h
Date: Tue, 16 Jun 2026 05:53:56 +0000
Message-ID: <20260616055357.3798387-7-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616055357.3798387-1-rajasimandalos@gmail.com>
References: <20260616055357.3798387-1-rajasimandalos@gmail.com>
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

