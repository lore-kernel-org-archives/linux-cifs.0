Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63513225AD
	for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 13:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710335252; cv=none; b=l5V/e3aB/Npyi6yCa71NioUHj9PF5qG5go6cOYvdSRdBoXXJGdWKc8N0GUAdLEwzg2D/3zc9HUnCteHWN9tfIff+0OBTW1pAAkOP0EYzxXJwFLMOQsEt3vveVxQ8X8+UmP0I3x+y56m84C7K/xI/xn5X5WnCTtBXCY0rV9Sobes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710335252; c=relaxed/simple;
	bh=ejc7AyvKtnrNeahWB++HFa6sCj5xZLAI4/moqBmmq3k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TYb/uz9U9l1wdJnyeVk7C3ue2BU8HknhP391m07zTLO6G2NGOU/Z9/l6jtJdkRHSrmPsQN/n6yemXIIsP+JsF4wQr15pMyq3PPfE6iBnPtdpGu9cZeqUQiW0qpE1LWuDvUDHl+KdO/SCFQnEd3PoeGike3XGVduN08efm3+C0GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=0iLW/M/O; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="0iLW/M/O"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-513ccc70a6dso85248e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 06:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1710335246; x=1710940046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qc/yUtEVogdBPMSpYyV8lCItJuJWgMnmzu6595Kkt3Y=;
        b=0iLW/M/OE1OiJv3h/tILE0KEqRtQDson6wb7lrLrM83OAjjBs1hX6lth+yqt/chmhB
         TwpFP0Qc2B+oI3zePERqU3+ZxU/yVbh0OfYabIfPh9529CBbTdtsfsnNojZmPl9FXW7V
         wSLdfa2d5krVlMIwWE98eUNYC7Ma9Tmdg0iHXRBleRd9VGM0a9TxrOcwXmMHuSGUAFHF
         Z3NU3oPMKmZQCgD25OVp3WaNHZz9VxjxFhf/LR/hrqPjhwvYxGTLP/kqoj1r9jQaKxDt
         LICUzc0rmLHH5I4cwGbfPtOrFkKwx9nGG7Ldq55o+DtVg7keXYPDxc7cU5s6KEiasxSQ
         ZYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710335246; x=1710940046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qc/yUtEVogdBPMSpYyV8lCItJuJWgMnmzu6595Kkt3Y=;
        b=UQAxrqNqsmh9eI4PJTkf+yRHtTZWoktbku8dH57UW1nyg5k3rjNheUt224WGxiIUBb
         5gL9dt9p97TRxPFY9/rs3bg70iWGvL0Xm3DLBGCkxjqtHnmvZPG7kQsT5jjbvYCJHzLu
         ZGLOcjIkmvnEKSMohuAaOD/CMKXZqVj1VWXPG1vzKbteTu2g8FdSaC5GIavGznoDBm4N
         vZlauZXjf5LCPsxT9NrOLYq1oDmG1a8pWE00TqSLyUhEPHV7alXNXduDyF5OPbEOVelM
         a4ebkLYoBg2ZXFMHtIldXVwqyy7WEduiyn5NqZe+h+gLdbLZCepxOS+V8bIJz1+VmukS
         x7Gg==
X-Gm-Message-State: AOJu0Yz9Y3Ag52RtZyA8TIPxIS/1sutdLQbssuwazQf1IObxsElqLh0S
	WTVRd0u5ynC1Y5jHc+sEBBSaigCImkPCR9YWC9xJuGGT791saNNaj4bwMgJkl/HVrPVTzWt5iEW
	1
X-Google-Smtp-Source: AGHT+IG50mU4IVNvdQ/zGYhrK8tB3cvg58B7xwcaii+cyGJiTK1jlmdPSZDVd33Jnqw9kCy6gOolHw==
X-Received: by 2002:ac2:598b:0:b0:513:7e83:b3f2 with SMTP id w11-20020ac2598b000000b005137e83b3f2mr7507883lfn.45.1710335245825;
        Wed, 13 Mar 2024 06:07:25 -0700 (PDT)
Received: from odysseia.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id a11-20020a05600c348b00b00413ebcd5814sm1209375wmq.38.2024.03.13.06.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 06:07:25 -0700 (PDT)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org
Cc: Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
Date: Wed, 13 Mar 2024 14:07:08 +0100
Message-Id: <20240313130708.2915988-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

File overwrite case is explicitly handled, so it is not necessary to
pass RENAME_NOREPLACE to vfs_rename.

Clearing the flag fixes rename operations when the share is a ntfs-3g
mount. The latter uses an older version of fuse with no support for
flags in the ->rename op.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/vfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index c487e834331a..d7fbea2ed0bf 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -754,10 +754,13 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out4;
 	}
 
+	/* explicitly handle file overwrite case, for compatibility with
+	 * filesystems that may not support rename flags (e.g: fuse) */
 	if ((flags & RENAME_NOREPLACE) && d_is_positive(new_dentry)) {
 		err = -EEXIST;
 		goto out4;
 	}
+	flags &= ~(RENAME_NOREPLACE);
 
 	if (old_child == trap) {
 		err = -EINVAL;
-- 
2.34.1

