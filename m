Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3383A6EF8
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634437; cv=none; b=Lm2hpGwEpWWKOw/D3bSOTxI0uE0vqkEVMkx5iaXZ5Ck8fGYZ0o0wjsmp7Gh/2U3l6pmcQSc+F+4H/qYQETALDeM5LqUdhpIoxrRP+bDrOLQBJkESkd1n1/kc6Fixupu5Pkk/V0b9TwK3oSGSPpNxUzBIB3Ge965tbltVeLoSo7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634437; c=relaxed/simple;
	bh=7fs/qpQj7CViKJpl1xKhLVHakBiwsBbgCOkyBzjRtuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO946jlhKOq7PiNnpV31JcTPHpnrw/q3RZes5LBz64MnW2vRhuOMMK+uawqPoun1QT3ZVXTqfQBwUWlePXrKV5T1sCS7a4U+QQ5k8i6ygd9DgZ505PVUrF0UeuRcqsq8r/l73+OTOyflQb/6NY4FkG9WvCvjkQdqVgFYsdxAk+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mFoXoVK1; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFoXoVK1"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82f69adeecbso825277b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634434; x=1778239234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=mFoXoVK1le5VkApKd/GCCWgOsscJcBtm+7xlnYfiLDTna8p7t0sw1a9B3mmyyV1KW2
         APZ5+6NFAbu6IBmQGmtDTh+70sXU/TUhFuakDoJqPBl2BjipTIIS3b0MPYuBXPHT7WVI
         fpKblj9uKdNsgVvG2/6E9qMF6eM+NnnUAz3V8suvuh5SLNeb6aDZmE5ZAwGZnQTsDn8j
         04YXS3AfkXcryCFYbUYHCTPPqr7Dwt2BZv/g0CBdsdSt/dXLy8YvLakkMmJpB4O22tv8
         KZawT+3Ej91tP4zwXuH1N2RtaYE9lE0T9TiMwTYHV3Och5UnYN78I8GIy6DN/knfxmCe
         kXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634434; x=1778239234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=D5cQbLf6hHPQevtcg/pvtRUoxzcdi2DHOa+pAdB1MNh/W+yfclUVZC5iiwL60LlJAR
         u9Cj85iRukz+jU+BDUWYlgpC6XFv9MtwtwNugWGBwBmnE+Tjn40Ju+bqrasmsn2saUvN
         te87Ykl8F3GW+Irtjz9F/8F3vIrTHXOHFg49nSUHyuQwPAXdzi9IEt4P4ABlqeFIFAgf
         yge39qco7W5Y9vPFmiWLTn2N84vwFk/YxtzXhPCmTpsZLkhNCO2BdYpWLogI2KIChxOm
         aGkmdxaGPSk33/HEn8FONbgzLTFSX2CvJ1wk/Gucq3P9IOQooFeBI0iBtaC+Q6FmWFJ8
         AcwQ==
X-Gm-Message-State: AOJu0YxhdGvYPJjT2b70+jlYvk/bAYpKxBhn4C8hIow8HpL3ool9wSHJ
	mF0DayMFwm9qUIBFjyfGyAoH+ijNYPQpP/0SXHjdmRMqfb+ngYoVPSoVi/pVHQMgFt4=
X-Gm-Gg: AeBDieun1DQXHKYQPp11KgVPNTtuFa8sV00upRYzhpXC/Rg7MLMVyON4gUIlXkExNRr
	LIUR3wObwjbe3ZWamMMdatKXGUNoELM5bxS6mck5+voCYKrLarLisAYwEmHVm6HbmfK0Yf1Lcx0
	9cGPVgOtj7+qOQFSBX3RqBuwaFzsFobUbq5C9XR6PNmCSND/Ea6OimfffdvVU2+xIFhS6GN97tU
	lKA6d2Y4Vsu6WIxldHHJ1zw81wGi+5+C0/w8K16S1fypXY0SmckPTA81W1W9BhcCWUXPzwUBnWE
	y7mPzVvVEqGEkn/mufKXJCaFIwkumel8EnHKJKgWof3NXQfc0wsyxTKHdaYQWxjO8N08xciuqGh
	0FPBdH6SZXDUJuBZcKSXLOOe83d/SSseC/BIi8n+0jzw/BzzRtiN0AXcm+QnMIoZ96Epmd02dBv
	BKGWB+0EfcFx7gJkLgozOir3ouytT+fsqiv24VlPQIPG+9qzGf3sAyUT5LSNlcwrA+
X-Received: by 2002:a05:6a00:408d:b0:82f:38:a5b2 with SMTP id d2e1a72fcca58-834fe237b41mr7807442b3a.40.1777634434492;
        Fri, 01 May 2026 04:20:34 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:34 -0700 (PDT)
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
Subject: [PATCH v4 04/19] cifs: define variable sized buffer for querydir responses
Date: Fri,  1 May 2026 16:50:07 +0530
Message-ID: <20260501112023.338005-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
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
index 709e96e077916..8d089ba08e3e5 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1394,6 +1394,7 @@ struct cifs_search_info {
 	bool emptyDir:1;
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
+	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
 };
 
 #define ACL_NO_MODE	((umode_t)(-1))
@@ -1907,6 +1908,7 @@ enum cifs_find_flags {
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
 #define   CIFS_LARGE_BUFFER     2
+#define   CIFS_DYNAMIC_BUFFER   3    /* Dynamically allocated buffer */
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index a69e05f86d7e2..6a1419d59ed5a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1546,6 +1546,8 @@ int cifs_closedir(struct inode *inode, struct file *file)
 		cfile->srch_inf.ntwrk_buf_start = NULL;
 		if (cfile->srch_inf.smallBuf)
 			cifs_small_buf_release(buf);
+		else if (cfile->srch_inf.is_dynamic_buf)
+			kfree(buf);
 		else
 			cifs_buf_release(buf);
 	}
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index be22bbc4a65a0..b50efd9b9e1d2 100644
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
index 5188218c25be4..49dca84b169e6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5625,6 +5625,8 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	if (srch_inf->ntwrk_buf_start) {
 		if (srch_inf->smallBuf)
 			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
+		else if (srch_inf->is_dynamic_buf)
+			kfree(srch_inf->ntwrk_buf_start);
 		else
 			cifs_buf_release(srch_inf->ntwrk_buf_start);
 	}
@@ -5644,12 +5646,18 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
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

