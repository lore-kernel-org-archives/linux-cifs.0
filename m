Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E261F2B8D
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372414; cv=none; b=pJw8uO9nruWtsY4Ommen93pmB7NpMvbSEZSs0/FUxt6jzEazsVYiN7JzYd+IDHtA927rxvL46fczeZbjoxPIKNr0aY4oWHCWllS3xJmsAV48V90Y2up74E3hBmHT6EJsa5ZsFv9Nqvw+IZ9qIduThiAcUKY3/Hp60SmAurZyQCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372414; c=relaxed/simple;
	bh=MLDfsbrqE/irJ5C5mfSMehDDIzdVCSob1K9JLJJP0Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph1LGMdBvU2IC1dtSLZSppgyoV72cEcyY8V/XhcxLA7f/mNVZkpNs7Oixp5a5he8PwEu0+FhvWYysaGlJcEMAA73uZhgEUUNNJFaN6qFy000V9huwVy+p3hkN7F0GeU1ru+tDys+c3vmXvs6Go9HDI5LmScbNjXTMNk5iawy8e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ero//CeK; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ero//CeK"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-835399c11e0so2828934b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 07:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779372411; x=1779977211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMnwkp3MOEwNeKoTQelUam/C2Jts/WAnmWXL6QUohHk=;
        b=Ero//CeKDOWUr2CPzFLJHRzQqjSMO1wsJAw1xiGJ+YOH2l1Xy/6xrHKVjFYHmS0NTh
         llJIDAN81pIk4WnmUrSJ3N6Pf3A+NI90AKCQmUNR1cyYfxi2lHwyqLT8/2seLiFVY2EL
         6sNdxYrvNB1OKWYbtYtnC5ufuRW5ywpY1pwlR3ou5+UIe4IvX6u4BLtyiGyPYgzxFLLm
         lsC9OPsXYAdH3ESliKUZntruQRX/u+M9y99wdCfXWK7r+AEdoN4bSaSkvb+DqTawvW+H
         F4w12JQKbRfWwOJidb9sIlfgDuLt1hO42jFQ6ozXdKvEutE3Sgg0/6bosR25+XpvkqtH
         V5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779372411; x=1779977211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lMnwkp3MOEwNeKoTQelUam/C2Jts/WAnmWXL6QUohHk=;
        b=exz8a0xBCk5IIKsamShEaq3N8MJ1+UbDyqyPfkkPB0FLUpDL+4ulZ7q55DEfqZbkkP
         I1RM1Y1n5raYh4QSkY98lUywvLQv8NvY29uxf0vfPogNAFAKJEQXBQ/nsxd0nScp3sZb
         jmaLy3dLCbTJvo5eCS5+pMzA+h55Cx6VRhBrTUUUZS4skmDpFk4khJtQjPqqqNpK/kgO
         c+aILqJbUPOwtn6ZTZHf/XqBZkROnfVZVDD2twHPyJuBLYrew6aq3dvQRtMWn3A8sSoq
         fcD0xQt1QGyPFiogvu+ZC75BbWbZog5uE+sS90RkqosV6Yca33T6us7pSN2LWOX4MGyw
         CBzw==
X-Gm-Message-State: AOJu0Yz5dgxFptiRxWBExwwR8BeSQOq4X6auAWoD0EMtLfev4yhu2Vbg
	pE+uc8rO635bTRa+sm2gaswjxypvUOYc8PPCt0t7oOjgg6kaOKU+a45d
X-Gm-Gg: Acq92OGjnm1z4gxDVOtJmgf8sVPvVDQEgOnhHRgTDlWS4InfH+nnd1BWvVmOgOsJWBz
	VwIE1eqX2PbVb3rAWQySdHRUoDr9EG7eufYDFFNMUNTmK7ud79k0FYYMbFyf4jOilGtylk+reGi
	Duy2E8gnnBG5RkBDvsx+bVYizXDf2qyCHby9APYciG8G8javc28daGziDvzeN+E8iOWhL2G8Ckg
	IQ0fIdnRgLahUK2G3d/oG4FLNgOI3qfLmx9v04fdw2UJKDjwb4egnkVHjXGr7zVEJ+FwcGnClEx
	Vtka3TeJoLTAbqJ+zyEmD6eLMCWQ+9OL4xkV72lsFR0qZQ88gFGkQDq/GoK40KlLmT3glypedXH
	6qMZYOjt/vh9iMYNa6b4L1wUI7m76hChuj+Gn+fTE1mYV6XbUwNqtMpaxA83X6Yw3OOTKt5UJcT
	Bgy72nOWgf+LpiHwaCNfL0612lGRJkvFSBl45j9f7EQH2/eJqGbr0N/up/eOkBzC/PalfmGnshE
	F4CUCYqquwRP1GpWdkREK4=
X-Received: by 2002:a05:6a00:3287:b0:83e:f208:b113 with SMTP id d2e1a72fcca58-8414ac62b13mr3306184b3a.7.1779372410574;
        Thu, 21 May 2026 07:06:50 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841549c46c9sm1719329b3a.10.2026.05.21.07.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 07:06:50 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v3 6/9] smb: client: move struct tcon_list to cifsglob.h
Date: Thu, 21 May 2026 14:06:41 +0000
Message-ID: <1fd3c3b8f04d7794e559f5caa4ea02ba6e4aa721.1779372325.git.rajasimandal@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779371115.git.rajasimandal@microsoft.com>
References: <cover.1779371115.git.rajasimandal@microsoft.com>
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
---
 fs/smb/client/cifsglob.h | 5 +++++
 fs/smb/client/misc.c     | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd..2a8b955638e7 100644
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

