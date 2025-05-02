Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FD11A4E9E
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 05:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746162945; cv=none; b=nDGt8KGr3idI/AtCwHouEWWAIffzWRlpvRNPasQ/vS55ReIEYS80IzqLrtolp3WHhGnmSOiuxZVq35Dx5R/zZgCVfIvWXLBGmoGK11VMt750Ygv59QHDUMsHlDz2X/0PCzwwjKOXLxQ2/up72S1YAHUr+cmtmKLDbvL+aT4lvCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746162945; c=relaxed/simple;
	bh=15rTx2oJrsVKNk7wVDXJkvu8MYeHyi9/eQUDmkYvpCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGCqYHT5V8sMuqsX3OE7OSDOMdbNnh8e1u4HJqcq64Mm1PJe01S4zg+hs1sGKxwJtiT9f7sSA2/aENRTHiiVK611JhUSJNaLaS3mQaUq7gRLZPcM36rzMsj+J/gNIUvgGMQq+7aIQCm/AiJhG/dPgK8bgUXg2oqrcqWcVxxoOaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EW1eCQ4v; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EW1eCQ4v"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so1675233b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 01 May 2025 22:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746162944; x=1746767744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/z7ZuYMMfJpyjXgHNY45550GenLUPbrbZQKpVuh+sMI=;
        b=EW1eCQ4v3WTq8KH7rwYRDlIvsX/b9iK3xWEm5Ed7SU5xfgpuAJv3FY6qG/52/m7351
         6iU1LG5+8BHyOhAjovzxiVDtcl4Pk7f4cpZi+ZJYuWzikwr2rTZXJ/uip5ctNECUrU/2
         c4eQlgN37nvBIexKFDWF2hzLpMC4tQPyk+4JUHEllY8u9GmkhD/W1qpWvm5mqryE5N3a
         49glNOtrTjKgse8SrA1LpgeBqElbcBc3cZLFY0vGf5kruqVFXPQcHa61r1g2A4ZIKt7p
         PQJuIbNYsP5MStzh/kTQq0Os8c4bZwoZbjxjZwcpQesN9MMfNA3JQab6bTjciSmnxb/m
         gsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746162944; x=1746767744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/z7ZuYMMfJpyjXgHNY45550GenLUPbrbZQKpVuh+sMI=;
        b=WyjqL+aiIai0xus/WMEzG/dXC2RA0mP5VF4Hgv73m+0GRTK3WMRhG2pmdRBTG+umG1
         ZwPvHKzk/t8VUQcaQSVNr+n3V+P2HbSHdi7TjWq254WankIyEjt7XdI9Gxsr7vYvrRkO
         AEE2Yh1grCvVbUSR8hP4gVYRAJKaA9CP24RotJ6hMMJIMdbgZy49j2KHbHh38BYMPpM2
         j2gvlELU3TAjDwM1qs33/yZl21Z87IPhVsbVkcuij4DMecLjiHLBC6t0k/tCWy8znrwA
         qEm/kGPm5Hj784t+C8GCGe95LUl6LKiCGwDNXNIa3N2wjNCaogK5E57vALOA5lEmO+in
         reVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYMP4pCofp4r4xXViADpMk5+Sgd4vfhRJiOHqfIGTPjqKAQN7f6egHLhflP+6WLQiZsuccfWIKWfJv@vger.kernel.org
X-Gm-Message-State: AOJu0YwBtiuccr2yzXN6BG3rJOXPG2rvO6xaZx2TpFPMvTamMorFLuFp
	zkkDVUaZxbUuh489nDycbg1E6iXjqekPfJdpqFEjD9YyN6uaRD0XFk1dVN04
X-Gm-Gg: ASbGnct3SGMjy592D3gVQ5XxiZ5ZqY9hbFYQpzwIc/VQlbewUg1Ibx5Zf85xn/EYHs6
	CpyWdNl7IBKGlTbUZ3grXw4PAlSEr5h5jT24OCN5gIAbqh3ybxhPWlXrRZQk+aG3zVO154q12XE
	HKwj+/jznL3BdIszBD7dQtU/9lKiu8VRpqikyU8kXAj/QTuxFH2l3c/E0XH5TmUE5er1jwZ8tVR
	npmeM+dX+B23crol7mZ15ad03MXGjIQPqejCF0h97GLfOVAjJf+NOKaqddAtMRGPQn/i67et3Sy
	9OcF9YWQ7THzIc7xEMy+Fj+50oJzawrp6oYAlsgv3ZWe07KftBpvRJTWP3OLapyAfGmFyHJDJVI
	ylc4=
X-Google-Smtp-Source: AGHT+IFBlhy7Ed5da7DXJg61a8jGTx0GmTMx4MUeqvx2ADuoT6JP6TNF7Zc3foY5ZqlLULcRmd2Hbg==
X-Received: by 2002:a05:6a00:3686:b0:73e:2dc5:a93c with SMTP id d2e1a72fcca58-74058a44990mr2084263b3a.11.1746162943390;
        Thu, 01 May 2025 22:15:43 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa82ba71asm425397a12.45.2025.05.01.22.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 22:15:42 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	ematsumiya@suse.de,
	pc@manguebit.com,
	paul@darkrain42.org,
	ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/5] cifs: update the lock ordering comments with new mutex
Date: Fri,  2 May 2025 05:13:43 +0000
Message-ID: <20250502051517.10449-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250502051517.10449-1-sprasad@microsoft.com>
References: <20250502051517.10449-1-sprasad@microsoft.com>
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
index 3b32116b0b49..a330abeea64f 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1988,8 +1988,8 @@ require use of the stronger protocol */
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
@@ -2008,21 +2008,25 @@ require use of the stronger protocol */
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
+ * cached_fids->cfid_list_lock	cifs_tcon->cfids->entries	init_cached_dirs
+ * cached_fid->fid_lock		(anything that is not protected by another lock and can change)
+ *								init_cached_dir
+ * cifsFileInfo->fh_mutex	cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
  *				->invalidHandle			initiate_cifs_search
  *				->oplock_break_cancelled
-- 
2.43.0

