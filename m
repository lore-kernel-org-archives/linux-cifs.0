Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C97B3F54B3
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161511; cv=none; b=nVPTUPQFsmZ4K75fP0wlSFTZtZJmKH1WgEx1D/yrznaO+ljZ3LUhWPigvx0oT1IY0uToUj5I65QqO6Az5sz2kTQGiemAUHYvseHN7MVnXsSep9cV8itJ8xZ1emdhImdt9k0DIltw25/QHdMHfBZSzcSZXLV1PJogo4120F3IXcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161511; c=relaxed/simple;
	bh=MLDfsbrqE/irJ5C5mfSMehDDIzdVCSob1K9JLJJP0Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwBjTcIIfJhWbGTULUJjx3DJHmrlxviazI4c4tUWQ6GmF5U8sjqsRUWWDTVUYptChwsdSlY9faHXBBNkxvkouZJteywzFYk5S+qcU1j+4Jgd6YrMrEVOTfoDffnoG6ZnfuW8tQPhbKz44TyRtJIYwianneJmNmfTD5AyPeWpo14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hV0XaTGC; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hV0XaTGC"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-365d712bbd2so518597a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161509; x=1778766309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMnwkp3MOEwNeKoTQelUam/C2Jts/WAnmWXL6QUohHk=;
        b=hV0XaTGCQ3rau2fOLJA3p0et77TPRLBApRFBKozEETjOyDnVMnCXsY+jbPsWr40D1Z
         cQUMc++04My9is/H2yTctQbBUNiejYm/qwkhqGGieRizOi33o57XyJ6xxBr8bPIlXfh5
         CyRGcCpMlM9GzFqRtmn6+0RjzJDMacI83pVZN94FCBGvFumOkJIxBGs5CBIDwGfEMPMa
         MnXAH4xkHdyv0cxcEhBEp0JOd0uywmFFE0prpi+AFZlQI4mDck1fLsUDP6YDFhOAv8oO
         gM3GOGzUKkp1mHOU5QhNR0hxBM481KelGaQxLNstSXGzbv0pwdid40wZ3CDX5FcLzea2
         wH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161509; x=1778766309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lMnwkp3MOEwNeKoTQelUam/C2Jts/WAnmWXL6QUohHk=;
        b=NqpQkA8SXB2TlaWYEP0bfIvyGnazhTKWWtHowYTVnX+MiBkD9V1h35MTJfTSqeHOmx
         0RHImI4q95pVvAXQr6m/8OdCdeLoio4Y0D0SrRbcrU7YmdT+C8o59cSFzbrUExjaxI94
         YrHwwqvpqPcwuBR2lRNBLBkvABmBHE1cStWxa9qvfLILxqakQxKe8LGdaj59LFKfWMvZ
         7oKFGoXz9Nba5OrU1Ixq0jH+vd4/4Q9uRMiseUtmeCRKF72iuuVG+UEzdS/3uQ0LFQnf
         OJ9najazHBWgL9LEzq/qtBlQGJ0FFBI28dzPx65KvUn8Oad64BGRqL+wn0vkzy+817dv
         ulIQ==
X-Gm-Message-State: AOJu0Ywp4hmxjqNsAlZxlpwKbh/WrCiwRxREQNQbWRoxPVzyBaIB0wgi
	uwheDT6XECrif0l/AUVbLM0B22j3G8gN7OQTj6sn/En0lPDtvpgPi6m96rFpBg==
X-Gm-Gg: AeBDiesW8XI0kLtSW8kCgNYggvBA0Wd4PK5YYBtpcU+WTHr7pi9ZT14n3DdHi9u7PAu
	ulP2jOaH7X1kShHkWWWb39NkvwGxU4EbLVAGnq+cF0gO9rJc/bt35ddTEcPG0t0I3r3NC32qyPb
	nYIELhBVEgxcVCyP4zeNovuK2UP0AXhHS/h/lhDn5i95W0Ov72irLvzU3qj8auBWOCsS7LxMuNM
	Jm60AFqUXqbBZpViHvKNoOepsZuS07Drp94aaEc58YFid5IW5EbRckMuyk+YBzCgi4FEdCS1ex2
	CcQRvs8ZPidPfsmFRD/VHOC0RmCDPbVLvvE/443ngVsvbE9ZaVZwB7v/+bq1BziAK9bj9uU8mwu
	f9bXXTgpj+/gglcbRtZ/hisqvU+lIet7Bqlj5IvklKtVTwRQN9UkJVQEsz2Ak5NYWGcn+1NYYQv
	KoHD+j8Hljo5aZv6D/9CjxZoCLLMPXhpX7rihAB3qsL1551UjbWZfxKSsrjzzRzJhflUqbXexKL
	Eh3nR6+isa09jZ7Kiixc7PLIHJnKkkjk+aWz2rQgfqh
X-Received: by 2002:a17:90b:3a0f:b0:35e:5051:fb18 with SMTP id 98e67ed59e1d1-365ac7a5853mr7634568a91.26.1778161509385;
        Thu, 07 May 2026 06:45:09 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:45:08 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 5/8] smb: client: move struct tcon_list to cifsglob.h
Date: Thu,  7 May 2026 13:44:45 +0000
Message-ID: <20260507134448.168602-6-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507134448.168602-1-rajasimandalos@gmail.com>
References: <20260507134448.168602-1-rajasimandalos@gmail.com>
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

