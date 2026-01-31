Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D298B36657F
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 18:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769885566; cv=none; b=ZQk092TWlbVJTMOcv0mMyKaqstBaDOeggluLBhN/Zd72gJ4I5Jo5O6GWQjU5ukwbY/34FPwFtN7WqMSpNHAfAEqnM+WtUJvd+uhob9cLAyQMpsrujeLankQaLr5+SMraLi5KkTqk9zntC/y2FA96P4VpYfHw8N7ImTH+sSZTzUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769885566; c=relaxed/simple;
	bh=WELQ8A7lUsxeB7Xhp63wLAIhTFf2jgPHUwFuNrUfTSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LpJONVW47yj7U9x4mpxEMDjlu5/TAEmgUe0Ew6zPBhuWs+fd86S79daI/+h2TMdbQNgpDxgDkDWMq6gFYLA89Ps7FAniuk8HRdJ8rHGYwbhUyjvdv+1jcU0mkdU+gCgcUiaPfbQz6up2d7EKMD9DhFt5wzf9Q85VEkhepBW6Gu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j0J1fDde; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j0J1fDde"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81dab89f286so1571177b3a.2
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 10:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769885564; x=1770490364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=50/MBNc4NUeWmwMGMZPJMvHqKAOM1yXk8HEG5ImQG3E=;
        b=j0J1fDdemOCBtZsyEf5gJs0clToAYNawZI5ppsuLbRh9u0IoYoN+tQoPKQZ9qYqQgo
         4ViO8NzPhDI4P9c4mUy5ATBxUV9F9RvMDazhhxTiOw4Q2PJxnQWsgXtNIbdRRawOyKe+
         nbMJ5zgnyG+BTsAh2vf/iKNZqA+sUFoKjR+3/blCOLzljfYNVUm9l49bIKrwN4QwaRqF
         gRVmfEnGcKbl8ngY1PGYy9Nd9W6CjmZkqFo/AtTkY3Xq9TBpwNVUgfw1RHFKA2m8yxOJ
         yr3uD+OjP0Abk7txyjvYGBWHFbkhjZuf8nhwbzuOrJumM6jD58Kr4Wf92aEbxXs0TaPs
         5z8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769885564; x=1770490364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50/MBNc4NUeWmwMGMZPJMvHqKAOM1yXk8HEG5ImQG3E=;
        b=aHoFdpNsrensmrimRVgfw78ITG0gB3U0bPNf5whUrhgzmdnUOKSfi7y2Tcflslrhy2
         I2N+tPfAGLODdA4WjMpSI57Az7zXXXhaTh7rH9n9J8jV6IDnnfyVx/gIMdrKMd3evqgJ
         DMb7ZBBqrkAfW9Bd26QTGiPI9+f90oldVsQxoCnVxu6Co025fr80rYu9ipSkTuYxzXD6
         NiSc/RQ98dDgYIAGDcKjZt09QxE3H+gHn57+EMWrISpkAisP53RyEfU3hBs2I1wfRsiU
         MuJuBFG1r8wcksR8pVh2dkCjHfHZ+Vn9vIwFUgdII7ZzXeh5Jw4Nl5+Yobi1RYNZTDDO
         hTpw==
X-Gm-Message-State: AOJu0YyRUJAKrcyAzUA9lKxMyjxQUZwKZXIFlngwqWVd+mLdvrWNTyzi
	HoPftcsAeEBnVG+X81Upd0nIKqgHDfp60RdXnWcvxCKSfFCBFeQ5rQ8GZG+zY6Fu
X-Gm-Gg: AZuq6aJ90aL4eVuzeIVRgtHiNtwSrM773QGvS3qcjxkTgKuEH8D+sHS3joSn89Mz/By
	MYuTzcm4EEjYH5VUYe1+QhesBlxnrG4eKUOQNe3VboeEi3Aakf7pjf0ijB9DqnKAGpv5LfrSWTq
	NRN8dK7UFSGeEgl42XQXIJMThwryiyz1hCHa2hPJAK4Z9nkCeo9lRmz/VRMUr5DQ1lUHQ0ZVwzL
	S6XOYXEfwJ/xqeDPjUZwnfhCjR26I9VESbvCkYY9V8/7L+c1jMhO1tY/acbv0rbaikq51SrIK7n
	/A1jpgaI+obIKYYjFfF7/1KKOPCSLSCmLpSH6sMU6wPIAEQgeAvu1l5QA2/4DhPEoZV3fpRHml7
	TG78yZr1rCIoV0BmBeSgFoFZ5a5Iv5/srAoH7CRnYDyFfEr9wxNLI7Ny/WnrpRhLq70rlkXpZVc
	LSD1V/qzvJ8uJTWEsiS3aZRR5VvAYYkfYBDzLR+SA=
X-Received: by 2002:a05:6a00:1ca6:b0:823:9e5:855e with SMTP id d2e1a72fcca58-823a9fe2988mr6853284b3a.0.1769885563644;
        Sat, 31 Jan 2026 10:52:43 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379c22419sm11635760b3a.46.2026.01.31.10.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 10:52:43 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v2 1/2] cifs: Corrections to lock ordering notes
Date: Sun,  1 Feb 2026 00:21:12 +0530
Message-ID: <20260131185238.973130-1-sprasad@microsoft.com>
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

