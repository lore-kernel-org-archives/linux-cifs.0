Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99F44BCB6
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392505; cv=none; b=uQhzxxh74BRZowIILzVdXWnmeK+2lLG454WpmYPuXwuM+Cz9LPYVIj0/WPzQD6uBTVdksT+BB8uob6fb/UMKa3gYuV4E2fpRX0Wd55Uxu935HEZbS9LrDqlwv+qv0hcb8U3eYU69yJqWMqIFpNLQmrXEUROj4hek6keoUxW4z2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392505; c=relaxed/simple;
	bh=7fs/qpQj7CViKJpl1xKhLVHakBiwsBbgCOkyBzjRtuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mjb97F8UTuD8LwZWHb1fsKVE7eBb37En3iL7GdvFkXIeoGlGr/kg2Dg+PvuSTURsVYC5+SFr7Ez/ZrZVDNclO7kGeaH7YgUMGv0Cvh4+Zmkatngw38SIYYrzf+DQZMohvss3U36RQmFyHs5J8aqIShQpIlPy8CrMjwzHoRL5ylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCX1iSm/; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCX1iSm/"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad4d639db3so57673455ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392503; x=1777997303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=eCX1iSm/pNtiEfgE/MKPgZzTZnDcB3VNGGmF/WbS5VynoPcoWs+AK4DR3QvJAPiBhP
         Y0tDlZkNLpzCqHjzxThoDdiEhN6tBZHUmaaq0+Y5gDTra0f0YwNJAWRtP5CUbkRthVkl
         FlKg5NCkoHZYVacHf11whpJlN7JPYDQzhA4QzbWumaIAM7JybmgtQZE3v0RKst0qb1Eh
         +rKizQD61nx3uH8trBior4tDC10xn1JP2vi/teSc0G4t3GcOwEKXCPu+I1wBOU0z2bXS
         +dvEQMa5cHAHuBtZxseeuaQZc9Fph64CC+1EaVyX5d7hJV7+1m9fKiJR95INp/5oQbYj
         tJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392503; x=1777997303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=sRrzGMYv9z6UyzgFAybFg5zS7zKJ4jUy2k+0B9hWwM8VZ7hitAQuloxnmthiPtgpOg
         EATaC6HtIl0ZwNrgelX5gLivw9qVy/ajSij8HgOuIPWb2YGVeKPPReNG7EWD4GS2kLQ8
         AuiL2doWEfNi2+3IKqvRwaVSdb/jEW6Hx84bGSIwfMl2cvT1ZxZa6P3Wl2clVebyFXgI
         9wda/03JyRZ4m3MGOYcRjqdq0FFZPWkMmpj0D0ByxiQQ+dh/X6UdEi0kPiwftOWDSggE
         0apzdvODpEOCbgciHzBg772ZuI1LUID6KDbjrTwgIrgYYltUng+tZPWaIPkYSBFrc84Q
         Y0ew==
X-Gm-Message-State: AOJu0YyKkJC1x2/HsemwWDiQhiNGu4FH/6zQse+6WPVrN2Dt/6XDDQA9
	Kb/ydK4jvyr1C4R/4n5u/CQfkF3lEmd5VPdip1CWC3zkfiqzm1GbU57ktLqTc53S
X-Gm-Gg: AeBDieu4vdvt4A6VDDa0UvsHBzjDD78s4DX0mVhpCfIoAWAlpiyAbrM8dbmJXkq4AHC
	+8M2FL9S0KQX4o9z5QpcOmvHUVkS0DuBrt8mvEMB54d9zBzwaMbHs0Cf03qnkIgSG16BQH3mB5j
	1UkNOGiP63KRheMWUvAFBbONMga7/6OL4HKWVvzJ5N38mKzokeeCJ8zAQRk/8qg0LqcZN/XZZAW
	qmd2PaqxkZWuog8s0fkUwwd2OJowGz8jQhlOOQWbrRCwa/1fDqtfalRDL7EPgTdxtBcMgJ7hFbx
	00QSHZnRnc7hl7IrK7gaDk+Q8a1gNUXrO40z+IRT6OxK4rcXGgKmisK9zQ+K24moATXaBZhqFXA
	LhiCXkMEcFSFY56f1kSancq23im7pbuKu3kORKhvBKdf0YSyfHE7KWQHmer/ic7/B1FD4wWlJLN
	eEyCi2chomtKSbIUK4wrrvQeUPK9cx8MVtvNUEb3KeeP947q49IN0FM6jhEZCGs9cO
X-Received: by 2002:a17:902:c412:b0:2b0:5cb4:d89d with SMTP id d9443c01a7336-2b97c499589mr39140425ad.29.1777392502782;
        Tue, 28 Apr 2026 09:08:22 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:22 -0700 (PDT)
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
Subject: [PATCH v3 04/19] cifs: define variable sized buffer for querydir responses
Date: Tue, 28 Apr 2026 21:37:49 +0530
Message-ID: <20260428160804.281745-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
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

