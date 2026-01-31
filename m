Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D571E4AF
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 08:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769846584; cv=none; b=FxWURBubSXdl0PH7Mxdz7fyaWD4OIgmivYirOPmLtUYeuZzQ5YyWjnvxPlQLUWaGfgS30Jbnk0trPyQZt5zqlrcOlLnQZi9pIfNTaBS3Gf60dmIvvjht6JOeH3g45JYKGavaHjAkm0Pn2ROt9cpnmG4rjmNTP8K8RU3ae+ig1n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769846584; c=relaxed/simple;
	bh=WELQ8A7lUsxeB7Xhp63wLAIhTFf2jgPHUwFuNrUfTSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VfK0FhHV5mXUqc6mantYNAHtrvmdrDrajCN5W9ljO23EfnYZ8mNR9geIIneourOBXiWHML1YWkR4LXE3spruoiNBPaE6MbOz2p7qANbzU3emstQ81Uan5bsSspHOk0mu0XH2kAYrZILxI0aiK975b/9zpO4MmI5KJlUuGsYyR10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a4oIgnKd; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a4oIgnKd"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0fe77d141so18202525ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 00:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769846582; x=1770451382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=50/MBNc4NUeWmwMGMZPJMvHqKAOM1yXk8HEG5ImQG3E=;
        b=a4oIgnKdMyDQW0zzKj7zq2NLib8bvMAcIEibMH9vVxTL7xgLyX0JbWAxX7sCBuyFvq
         zkeu5d96z69BL1NdsfH9/cNK/SZY5aqCMmY3YYiLJN9TxWiSH8Siph6syMq9xUASsMUh
         /GZJJhYTGFqjNqe6BeEMK88qtHgfaFv+gKqu3Fv+boucpAClo2jwgdsxL6S/h+iaFmNr
         /k2+FLC3iM0ssa9lVjP5AkILob4gvhswDS9WcwKiH8PN7C3vlw2D993hx8LLXZtONwv0
         yxNEznHXdfsukoOqy0d8gLHkBrEEx88RlHx+xVC2Z7CCoID1d7AGPftpnWBZChJhUaVZ
         Wjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769846582; x=1770451382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50/MBNc4NUeWmwMGMZPJMvHqKAOM1yXk8HEG5ImQG3E=;
        b=D0EZKHwBPBJ4u0L8iKfJG47/L3YogkyyXnDH41uUiiM0meYHqr10RDn5NDCwBPwhDN
         9j/O1M5H+6mCbnAigp4cuR5I5aw+DoP9ScPxvMEkjP3jewzj0s969kpJKIpV4bR35nnt
         Ze1Qg4lX9t9gyZTyemTG9egUyQ7in61wz+3pPzhslXz0IkwVeoyXrMsHfergxcJUnpRq
         aQUPanTxxVBoB4YTRVnhuNiHGCxwxtSlKOI4nhL1RYX+6KA0vTuUWmieCqhJLx3u8Gsp
         95Xk1AJvMihZSW7e41Hy+0aU552/tHcQwsCcA8yyYRrApajNObDDzSu7krwe2eN/dJEq
         Bltg==
X-Gm-Message-State: AOJu0Yxf1U9vm/U4agzGgr3VS6bju2A4pqwU1dtfdbZ76sURFlOdApsW
	uc6UhLaK1LuDUSRxV+d9IWn7uYctGu5AeFPpELttZNeB53GJ5VKECu1vzoJs8Q==
X-Gm-Gg: AZuq6aIVlqFPpStpAWNxZgnlXGoL2iXKAXCJeggZ3buSQ+5mpPmhqHskJaBqp3xq1cV
	1nIodGs3q1vBaCkzPwaDoqQ6N+u/QaSPC5dawgDDsGXuQBTWAF9iHOv8LvKC/WK7fPbgRonmR+I
	KaCS71XKK2AYqQwvPS+RNQ/qtgrOPtMdZ4C6jG3M0xzPhYDJ5l60G7vb6BUHCRo0TghIHeS7p81
	+nyFB/nLLoNVM/Nz954h1bdcjV/tLCMLC/YkV0fjcTst6vNabSPuHnhkqt9062vHwen98gMh7+k
	iVch9hQbLIklauFxwrRRV26+3YIr4ZCjPxlI3KSBUi/YiSHggnvzYL9yP099mUtkbAohg0Augnk
	SsckGbmAO0GPPUD8MtduWuQur5mNq6UxeKx9fYdlnK6Fo90Evha0/L/d18IpV28EmSFMi2DvDVg
	bW5qmHnDusAD/rcd1e8nyfV1dJ9q8j/AdBC1JemH5Gib9Vzfpi9C8=
X-Received: by 2002:a17:903:2a90:b0:2a7:5171:921e with SMTP id d9443c01a7336-2a8d9943951mr57583755ad.45.1769846582014;
        Sat, 31 Jan 2026 00:03:02 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b7f6c7csm98853045ad.98.2026.01.31.00.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 00:03:01 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/2] cifs: Corrections to lock ordering notes
Date: Sat, 31 Jan 2026 13:32:15 +0530
Message-ID: <20260131080239.943483-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

There were a couple of discrepencies in lock ordering for the locks
that were specified in the lock ordering notes. Did an analysis
of the current codebase (using LLM) and found two pairs whose ordering
in these notes were wrong. It also found one lock that was recently
removed, and a few locks that weren't documented here before.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3eca5bfb70303..d797b953b6cf6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1943,6 +1943,8 @@ require use of the stronger protocol */
  */
 
 /****************************************************************************
+ * LOCK ORDERING NOTES:
+ ****************************************************************************
  * Here are all the locks (spinlock, mutex, semaphore) in cifs.ko, arranged according
  * to the locking order. i.e. if two locks are to be held together, the lock that
  * appears higher in this list needs to be taken before the other.
@@ -1971,18 +1973,21 @@ require use of the stronger protocol */
  * =====================================================================================
  * Lock				Protects			Initialization fn
  * =====================================================================================
+ * cifs_mount_mutex		mount/unmount operations
  * vol_list_lock
  * vol_info->ctx_lock		vol_info->ctx
  * cifs_sb_info->tlink_tree_lock	cifs_sb_info->tlink_tree	cifs_setup_cifs_sb
  * TCP_Server_Info->		TCP_Server_Info			cifs_get_tcp_session
  * reconnect_mutex
- * TCP_Server_Info->srv_mutex	TCP_Server_Info			cifs_get_tcp_session
  * cifs_ses->session_mutex	cifs_ses			sesInfoAlloc
+ * TCP_Server_Info->_srv_mutex	TCP_Server_Info			cifs_get_tcp_session
+ * cifs_tcp_ses_lock		cifs_tcp_ses_list		sesInfoAlloc
  * cifs_tcon->open_file_lock	cifs_tcon->openFileList		tconInfoAlloc
  *				cifs_tcon->pending_opens
  * cifs_tcon->stat_lock		cifs_tcon->bytes_read		tconInfoAlloc
  *				cifs_tcon->bytes_written
- * cifs_tcp_ses_lock		cifs_tcp_ses_list		sesInfoAlloc
+ * cifs_tcon->fscache_lock	cifs_tcon->fscache		tconInfoAlloc
+ * cifs_tcon->sb_list_lock	cifs_tcon->cifs_sb_list		tconInfoAlloc
  * GlobalMid_Lock		GlobalMaxActiveXid		init_cifs
  *				GlobalCurrentXid
  *				GlobalTotalActiveXid
@@ -2005,6 +2010,8 @@ require use of the stronger protocol */
  *				->chans_in_reconnect
  * cifs_tcon->tc_lock		(anything that is not protected by another lock and can change)
  *								tcon_info_alloc
+ * cifs_swnreg_idr_mutex	cifs_swnreg_idr			cifs_swn.c
+ *				(witness service registration, accesses tcon fields under tc_lock)
  * inode->i_rwsem, taken by fs/netfs/locking.c e.g. should be taken before cifsInodeInfo locks
  * cifsInodeInfo->open_file_lock	cifsInodeInfo->openFileList	cifs_alloc_inode
  * cifsInodeInfo->writers_lock	cifsInodeInfo->writers		cifsInodeInfo_alloc
@@ -2012,12 +2019,12 @@ require use of the stronger protocol */
  *				->can_cache_brlcks
  * cifsInodeInfo->deferred_lock	cifsInodeInfo->deferred_closes	cifsInodeInfo_alloc
  * cached_fids->cfid_list_lock	cifs_tcon->cfids->entries	init_cached_dirs
- * cached_fid->fid_lock		(anything that is not protected by another lock and can change)
- *								init_cached_dir
+ * cached_fid->dirents.de_mutex	cached_fid->dirents		alloc_cached_dir
  * cifsFileInfo->fh_mutex	cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
  *				->invalidHandle			initiate_cifs_search
  *				->oplock_break_cancelled
+ * smbdirect_mr->mutex		RDMA memory region management	(SMBDirect only)
  * mid_q_entry->mid_lock	mid_q_entry->callback           alloc_mid
  *								smb2_mid_entry_alloc
  *				(Any fields of mid_q_entry that will need protection)
-- 
2.43.0

