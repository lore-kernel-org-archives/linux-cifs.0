Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4283BBA15
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 08:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775119163; cv=none; b=UDpurBA3h3BAIEYGcxarZkQrx8l8mVyElEbi1iF9eKxIOu1Hubd/FuUQ51pepUxLB8ap5i1z4Ubs6RQpIFD+0glyOI7sDk8SVE9XBfd/fNOcDSr0HbyR21ib2wiX9JPUzKiQgljfiiTZnifQ/+vsxU0rmdAKppwA5KVelT+8RvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775119163; c=relaxed/simple;
	bh=cwiMGb+QvJPPbyOUbTGVlCDSVPPTs9vIaN+NXNJAVn8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hKpTHaLnaFSWazZEkN6uQ/oPoEMvi4oCUB7MoP7ug3FcV6X89FxukkSF/PGLrmqBc76DqliMYyh85cpU10UCfnbk35PqmP0OaLOYzn5hjhgq3ncOIYII06iFxdSmvl6BR0U0BQ4uwub92QJMJVUT57EIvUaQayhD/SToWC/dcq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/FgGiS+; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/FgGiS+"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-126ea4e9694so2025145c88.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 01:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775119161; x=1775723961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7eITVDgwa5tEdf7gs96GHN8iyQzNKskoC8moYtKLcKc=;
        b=K/FgGiS+3PI2cFIE2N+jYPaP3BbsprXkLelxACmeih+ZJPGr6NWju/f1916TjbFFkf
         hZe/o0+7Mi9Nh8LR39DkgNxuql0TvOgBtyNcn1eupfqiLol1ElVgjyYZR+Z8PlS4FUBE
         7jRTE9z5OvIAyBmxLHB9M+3u5Q/wfYaqkcEvbBY70NJPMbUDyALNBmj/2rjWlr9+XU9s
         oEZt77sdmJCjDlY3137MMUZLABPhV1KibPuvqW/3dyFG6aQuDsPk7Ocbx2P6e6QcOYNw
         d+JugzOrlkOzt5+fw89gpYcKlXSuZDxFsSJX/CTvk7oDCSVYAXzPlMbzdiN6cfqaiK3N
         292g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775119161; x=1775723961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7eITVDgwa5tEdf7gs96GHN8iyQzNKskoC8moYtKLcKc=;
        b=tRFfn/2Q/y5ebjN4g90pLOrrjsCfNcxmpDap1XpZMvi4z7bieu75jh30kNlNP4hUwl
         5kT4mYb3dRFQeg0NvVBbvQz2gbTobTgBC9d6gVbrzaIVOxgtvPzLh1lLeHPQoqlxYUFR
         9LvtJQmONMmLflMt/Vdnyv7/c8RFMOAuWu2pFUICnX7Py1yQyKjjVhsbhSatMCLdMnOW
         B7lpa4NXSmu+4p8XWoQNs5eu8OYDqaQUHtCMgIPLcfpKcaIwOz5XdWSixN52yYoKtYVK
         7Zi7jhSz5ehwSuO29P2302neT2rniQOMYV3m+h4W52nXiFeZmfHRbBzTEVPUciAHkk/z
         dVmQ==
X-Gm-Message-State: AOJu0YzsxLnziUZwn1cwj0raOTcyAJ3NGoNqRwJdx4VR0ysKzRnfGcNC
	gxQsf/lr8I0KCvSGpOYveGN2fdZMLGQgsPFJDND1PjwJvqHWUgCgU0BD
X-Gm-Gg: ATEYQzy3qFtowAUeqyEtZphaKNAUb3loylUIIwPROEQD6Los456nx1n/jOvHbtkE6Tj
	Ira07lkUiUnTb4nQGSoWCbsV/2ZosSfosrz8j/4uENc5XJmRkuuFG4G5rSCXZzsYRfLmKoE5/ak
	ymABzbNiSuxGsxRnSY33Rm74FSNJKDfZnbFt+QS1kHWY/ZUouG4RyO4crNyZTPlLUc4fyDh75Jf
	+W5o3sS5jRy/OQoIUFY7YZjQgSPzeDw28rP/pzz9rDzHK8RPmQ0BhoHscb2wS5is+BkohmurbF1
	krSXFPnx09m3G9oxC7LROAedhY/ZOA9p3rcsGuqX4I70NnEkEbqlGAAthR64j/mqthraMKSSSM8
	oSG/UUtYJedALDN95PGW7zxgChVPLs6iL0Y3ZtxkMREmVG6s++AKrMIDGrRF9mcFk6pe1yS8uZB
	0Am/IfueKgrCXxU0RYKWACZ2PJ2/LUuGA4nVnlp58uvQ+OvZ0Sk/eY0wJoYg==
X-Received: by 2002:a05:7022:f8e:b0:119:e56b:957c with SMTP id a92af1059eb24-12bee613f8cmr1450943c88.1.1775119161057;
        Thu, 02 Apr 2026 01:39:21 -0700 (PDT)
Received: from ubuntu22-base.lan (104.194.93.216.16clouds.com. [104.194.93.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12bedd4e4e3sm1716646c88.1.2026.04.02.01.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 01:39:20 -0700 (PDT)
From: munan Huang <munanevil@gmail.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	munan Huang <munanevil@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix use-after-free in __ksmbd_close_fd() lock cleanup
Date: Thu,  2 Apr 2026 08:39:12 +0000
Message-Id: <20260402083912.457676-1-munanevil@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In __ksmbd_close_fd(), when cleaning up byte-range locks on a durable
file handle closed by the scavenger, the lock cleanup loop
unconditionally dereferences fp->conn->llist_lock to remove each lock
from the connection's list:

  list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
      spin_lock(&fp->conn->llist_lock);
      list_del(&smb_lock->clist);
      spin_unlock(&fp->conn->llist_lock);
  }

However, when a client disconnects without SMB2 LOGOFF, ksmbd preserves
durable file handles via session_fd_check(), which sets fp->conn to
NULL and arms the durable scavenger timeout, but does not detach the
byte-range locks from the dying connection's lock list.

When the scavenger timeout expires, ksmbd_durable_scavenger() calls
__ksmbd_close_fd(NULL, fp). At this point fp->conn is NULL and the
original connection object has already been freed by ksmbd_conn_free(),
so it would cause a use-after-free or NULL pointer dereference.

Fix by checking fp->conn for NULL before accessing fp->conn->llist_lock
in the lock cleanup loop. 

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org
Signed-off-by: munan Huang <munanevil@gmail.com>
---
 fs/smb/server/vfs_cache.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 168f2dd7e200..772a84d95fe3 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -463,9 +463,11 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	 * there are not accesses to fp->lock_list.
 	 */
 	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		spin_lock(&fp->conn->llist_lock);
-		list_del(&smb_lock->clist);
-		spin_unlock(&fp->conn->llist_lock);
+		if (fp->conn) {
+			spin_lock(&fp->conn->llist_lock);
+			list_del(&smb_lock->clist);
+			spin_unlock(&fp->conn->llist_lock);
+		}
 
 		list_del(&smb_lock->flist);
 		locks_free_lock(smb_lock->fl);
-- 
2.34.1

