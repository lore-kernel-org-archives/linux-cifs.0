Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A274834404F
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782115; cv=none; b=QCoSMD0iJv68juQYoG/+/cJXlhVtCHP1gnaO0sWbKnYnxmTOU0qNUB4xjscBvEAGC/AbEdz3vR1sRwuB7NS3liwN6N9As8PPhCqPKEJSdsgTyeckJoHO+dODHUDSYkXiztnmkBII2M7YcD+gHh71qiGML71pvi2cWlqyb7hyiyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782115; c=relaxed/simple;
	bh=HX95O2Es8/zAFZdPhaX2sTslG1aiirVdV4Atf9FBVho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuZEGQifkrUREZTs/hDHnI0z3widkQ5X/w7/xH/BCsjPNknYg31oeXnyixGHlKhV86jnsOUZH6cZz9ZUN1N8OlADdY5NXf5voqDVH3P3wVf/zBT1J2Kwv66/Ezrmc+dx4+4FmhXfLbcNkoZLw406iXyEa5zaZjgWbY5+JAjBvjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hw21TpzB; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hw21TpzB"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c736261ee8dso3955775a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782114; x=1779386914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEiNedsAfTD5/DZPyOwVTeVAGqWw0g24HFNLI5ldkR4=;
        b=Hw21TpzBXi1gQFCzuz484hj3/MttqzlMRsqZY9H6nelYYFGBl5rk2xaxiPFdRbviPJ
         HYGymONH88/McC3nFpvKfb0W60tbnPRB31g9aPje8we2e0LxycAlMcfWsROFC8INjqio
         L3Qry7/fvk+3gR79pKxox1HI4wwtt5YoAfiR3yKVn2We7BLFRdWMKWGG/VzFSyBwUZTt
         Hq1Kq6LqurFfZu+29vPJXUHO/YlIel4O8VlHcylg7k5uDzDxdF/Q3t06NEJ4EtBnVKPG
         oUvGaqfijjGxQKcHQHanux1LOR4aSmndqkTKB4YIEZMIx7wg2AEOoQ3f5OkHp8cX1i4/
         W1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782114; x=1779386914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wEiNedsAfTD5/DZPyOwVTeVAGqWw0g24HFNLI5ldkR4=;
        b=mzrhGTC70geQ/Vk6+1oRZVUpWddnzTDblxcPN86/tu2KoNjax/dBZdO5erqhwCxXGW
         jNoRlghitR3VrlumkUmu2HGu5P5MChVtK6QegEQj1Zr82P6ans4tJrP7eU+7bWsH5Eb9
         VTwUqVllR1pFJwyeQ4Mfpb/ayIxCBYZDZBjOpr79zpD5YqS19RNfOViq4yiHuyoZWNJ0
         oX8RvwD0eIUZSiUm0tQc7JCuGD+ubDxC2vn8uqEhmaCdUl8+G9Qr3PJSe6FNI1bw8oKR
         4h2fh7jcUShHSaU/OfBBeFu1BZEaj3Vhr7TmEEUCiKnvVuZilLWUGrCs6RSPbZtPTvca
         uSyQ==
X-Gm-Message-State: AOJu0YzTyPtZe7Zm6DxgvGH/wenqhZX42MxrKRnYrYMzfLrOGWPa+qjy
	/vsBu0CyhNEAX57vJJ1XuHGJUlht2/Mh8kHkoq7rCGgruvL3qRuZ4YXo+Ryscjt3
X-Gm-Gg: Acq92OF/Y9kpYliBAh5EWgsq3bf/ITcvzBkgh9rKOQQ6m+e0M0aS8+YQfBMle3/X9ib
	fBq30V7lUrTsDxv3iPzmQmNv+V1uAJBZGOoSIVWOr525V8W5bu8nsGw+vnIr75VWMCczfLwsg3Y
	Mze9bcMjtMFBdiX+EWoMbgJiHQXc3Uq1wL4wCXZV/q3hXIHQCxHjlKuTi4/6hivvn2BgS4pZtVg
	S3WtxtDCgkagVlqKGYk1hPlMhXZ7ICVNmqjydmQsQXOzpuG3l8hz3ocAkzFpF0m9iduhVx3YLKy
	BojU9wMosnBBU0rDAMGeDmdf8NopgWn8jIN+gVQjKITsn4yCb8N4ljREUZ2TicnHcgHjhYoKZ9M
	QgoB7G8BeVXAjcdY5jEkmiCK/cu+AFlnsww/iwqblb/1LiQ4Pk5YxLmsgTHRY5yyjVbaHxgVLFG
	OpFb4pa3q1P+Gs1LuMJ0noly1mUITZwSrHJOoVMzKxwUm6SYX724AgCg==
X-Received: by 2002:a05:6a21:3298:b0:3a2:e0d3:37d1 with SMTP id adf61e73a8af0-3b22ec5f790mr358476637.41.1778782113771;
        Thu, 14 May 2026 11:08:33 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:33 -0700 (PDT)
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
Subject: [PATCH v5 02/17] cifs: define variable sized buffer for querydir responses
Date: Thu, 14 May 2026 23:38:08 +0530
Message-ID: <20260514180823.497293-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514180823.497293-1-sprasad@microsoft.com>
References: <20260514180823.497293-1-sprasad@microsoft.com>
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
index 82e0adc1dabd0..79876c062d1d8 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1391,6 +1391,7 @@ struct cifs_search_info {
 	bool emptyDir:1;
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
+	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
 };
 
 #define ACL_NO_MODE	((umode_t)(-1))
@@ -1904,6 +1905,7 @@ enum cifs_find_flags {
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
 #define   CIFS_LARGE_BUFFER     2
+#define   CIFS_DYNAMIC_BUFFER   3    /* Dynamically allocated buffer */
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 664a2c2230890..7e5889d56b8f4 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1563,6 +1563,8 @@ int cifs_closedir(struct inode *inode, struct file *file)
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
index 995fcdd306815..b2d6f89c74da8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5635,6 +5635,8 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	if (srch_inf->ntwrk_buf_start) {
 		if (srch_inf->smallBuf)
 			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
+		else if (srch_inf->is_dynamic_buf)
+			kfree(srch_inf->ntwrk_buf_start);
 		else
 			cifs_buf_release(srch_inf->ntwrk_buf_start);
 	}
@@ -5654,12 +5656,18 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
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

