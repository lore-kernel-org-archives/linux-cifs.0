Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0C6214811
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 10:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032318; cv=none; b=LsVp3TVvUri1QecV+kr3rzBjOGP8YZpBGJtGzOgI1vwZH4L8ri/MeJRs3lto8/2h90OVx+aegUdohsvogMqrozXdWrZgFSlGTOIg+Tfx0E5nlWCT9bYDk7rEOIj3ayqaqMzeSoDmR+7Jy5jjvjoxo7XL4+UVnAEVwyj82mgQk5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032318; c=relaxed/simple;
	bh=0kwnhdr//gYou9C5fbU1NpbT3H4FqUtSxRddSpYWh4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjKSchoj43FpR2YtIYzKoe3Nsf9Qm6U743vbMVTRuuKjzNMLFzHK3JLS84qdR+yd9a/rT4wMM449x8zKFTN/cGLqXc4Szr8b7PRFB2XZgcjxz/FltSjfs2n604rqe+GqeuQNaIsvAL9Ez7O61GraZzZNY3C/zkQ+cN/2TW9Xbuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwH9K80G; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwH9K80G"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23035b3edf1so60396095ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 03:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749032316; x=1749637116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XpiyCNXXuIfWox2F20DULP4ICPhnP/XcqBXZD/I6/Pc=;
        b=GwH9K80GOv/P7Wymh6S5RWZFolw42q6QDWSeDxY9T1ieMVFkUhcPGQaktB8NhN73d3
         vtzopFdXBwN/WAcUq/4rkK5GeVCccHJ1IpTm7JMzRDFVjS9fSwZnrMLpYZY6CwiMKcN8
         5AscOhHQ/Xioz1s7QEJnPyQfPAZNSPIsCCBknvZpsCQ2WUCrp6pegrEVJ51LARqHYZuj
         eHpn/lJJQZiSjkZdtD+0O8JUAQXNsvq5BLBe3b3agS13fCY/25hAh7F+Bw/WIC9UHW9R
         DxJhRSri2bcqkngcDZ7I0k6qOYRYV9ZlZVhIxzTKERtt4S85z8JrusczlWuvquXNsNHI
         7jxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032316; x=1749637116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XpiyCNXXuIfWox2F20DULP4ICPhnP/XcqBXZD/I6/Pc=;
        b=l3iE/mHONYdDxgazg23rPMXSVLEDXAZOZVG/OvnNGeLJJ6azGoI+q+D5PKlt8pFkKL
         zniorcX15OK8S9raI7jP9c19b79hrMYzTJRKl9whv2ld8dD2cpKqEmjsljDNUVyaZAct
         wRYEaLWLg87DM2r+Wno5GWHVihwh0j8WLm2zYtcgzmd3YSAOCLBv8IYIrKkzhJysVv8z
         JWmbmAO0KHsnzNUQ1qWbokn9WLNMyVezT844NGNXiQqc9nsCQdIVPiKEvJ5ckopT7G+F
         TtfbnMF/jx860UBUJAV5YuustcaxiunSg/bZ0UXEqlpTVDqVFih45tln2FwPuk7xQKbU
         L2ng==
X-Gm-Message-State: AOJu0YwwjDn33aPB51gr9RRs9ghhfMOHcA0HIpAkhyQxHoKA3lhd3dC+
	rKi1zGWIQolWbdzF2wVmreiirSSN28JQx+2+/xy35rqmByNEyt0w7lDhvvxGj3lGyo4=
X-Gm-Gg: ASbGncvmRY4AyeGuqjlkd/pecutr0XLfmTVD7Hz3qAkiMiqXJ4dfg+zaMto69nsVWBj
	r19Wrum8cJwuomK15mKhLhZJolMeaIwLnOODXkxHFuVDqT6y0GrEgqbfYpRWrZ0mZzhFY3DCzPA
	AsYeJg+0e/sCpMnui4ieYieioAOM0Nrp/kCEVQrTKbTeVJLyAXkMoQSJg1jMIAleFOvAb7Y8Am7
	w/727GhsE56CrwxONMHaMJIhW60zDYPfIGvb+De3QqftQal26ethaU69BUXBjjRbvIlkDDExaFX
	lY4BEd+l1PdwCdg6g+BSkwTqgp8m5XHKDQ+Rjy0U70Xs2tRVq1mgNa46wXXcFbwCX/JcMi15ljC
	yvfE=
X-Google-Smtp-Source: AGHT+IF0KbGSHHblUasY6wT2tMXrBhZAtxzQ9pLBIUMiMYT/HbMT69OPyIozf/WJpxibRIgd6V+uiw==
X-Received: by 2002:a17:902:9049:b0:235:e8da:8d6 with SMTP id d9443c01a7336-235e8da0b78mr7555165ad.2.1749032315704;
        Wed, 04 Jun 2025 03:18:35 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bf8132sm100563625ad.106.2025.06.04.03.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 03:18:35 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 5/7] cifs: update the lock ordering comments with new mutex
Date: Wed,  4 Jun 2025 15:48:14 +0530
Message-ID: <20250604101829.832577-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604101829.832577-1-sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

The lock ordering rules listed as comments in cifsglob.h were
missing some lock details and the newly introduced cfid_mutex.

Updated those notes in this commit.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0c80ca352f3f..a56d52951b00 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1989,13 +1989,14 @@ require use of the stronger protocol */
  * TCP_Server_Info->		TCP_Server_Info			cifs_get_tcp_session
  * reconnect_mutex
  * TCP_Server_Info->srv_mutex	TCP_Server_Info			cifs_get_tcp_session
- * cifs_ses->session_mutex		cifs_ses		sesInfoAlloc
- *				cifs_tcon
+ * cifs_ses->session_mutex	cifs_ses			sesInfoAlloc
+ * cached_fid->cfid_mutex	cached_fid			init_cached_dir
  * cifs_tcon->open_file_lock	cifs_tcon->openFileList		tconInfoAlloc
  *				cifs_tcon->pending_opens
  * cifs_tcon->stat_lock		cifs_tcon->bytes_read		tconInfoAlloc
  *				cifs_tcon->bytes_written
  * cifs_tcp_ses_lock		cifs_tcp_ses_list		sesInfoAlloc
+ * cached_fids->cfid_list_lock	cifs_tcon->cfids->entries	init_cached_dirs
  * GlobalMid_Lock		GlobalMaxActiveXid		init_cifs
  *				GlobalCurrentXid
  *				GlobalTotalActiveXid
@@ -2009,21 +2010,24 @@ require use of the stronger protocol */
  *				->oplock_credits
  *				->reconnect_instance
  * cifs_ses->ses_lock		(anything that is not protected by another lock and can change)
+ *								sesInfoAlloc
  * cifs_ses->iface_lock		cifs_ses->iface_list		sesInfoAlloc
  *				->iface_count
  *				->iface_last_update
- * cifs_ses->chan_lock		cifs_ses->chans
+ * cifs_ses->chan_lock		cifs_ses->chans			sesInfoAlloc
  *				->chans_need_reconnect
  *				->chans_in_reconnect
  * cifs_tcon->tc_lock		(anything that is not protected by another lock and can change)
+ *								tcon_info_alloc
  * inode->i_rwsem, taken by fs/netfs/locking.c e.g. should be taken before cifsInodeInfo locks
  * cifsInodeInfo->open_file_lock	cifsInodeInfo->openFileList	cifs_alloc_inode
  * cifsInodeInfo->writers_lock	cifsInodeInfo->writers		cifsInodeInfo_alloc
  * cifsInodeInfo->lock_sem	cifsInodeInfo->llist		cifs_init_once
  *				->can_cache_brlcks
  * cifsInodeInfo->deferred_lock	cifsInodeInfo->deferred_closes	cifsInodeInfo_alloc
- * cached_fids->cfid_list_lock	cifs_tcon->cfids->entries	 init_cached_dirs
- * cifsFileInfo->fh_mutex		cifsFileInfo			cifs_new_fileinfo
+ * cached_fid->fid_lock		(anything that is not protected by another lock and can change)
+ *								init_cached_dir
+ * cifsFileInfo->fh_mutex	cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
  *				->invalidHandle			initiate_cifs_search
  *				->oplock_break_cancelled
-- 
2.43.0

