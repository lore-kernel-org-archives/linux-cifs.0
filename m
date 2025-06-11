Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC8A25BF12
	for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749641391; cv=none; b=PebXXWKMnro3cthyDZ4MhyP9I5fDwnomO+CCGn8uglIoSrzoVVA/ZfyVJ0aVE2ZFJLr8ahciuQ0Ff+ssjPO2bSiDj1gnZMwxeijvmxa170qGcpRaZqJVjxLTqJK24/FjMOwG4lYLJ4C5rxXanKn/5Sdt6mSFx7yYYYZnlOMEb5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749641391; c=relaxed/simple;
	bh=rXfXD0fhHuieIJX9I4xWmIxUDBibz5B1S4fAIKv0e14=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EFeEw3IxV5QHkQ3UYZ0/geaeGAf/5/XXlCiGFvpa1RAGIHYyPwrURqkhScLDrkQq8LDrR+6QhAIr6qSLmvwZtmFl+EQ6pRatyaKCQoRYqB0aUQD8EmQWHuPcYO5v2siZsIjo0Jvf6sVcrSFPB1iVbFTpoPhD3k1RK876lRjTMFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IqK2MZHD; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IqK2MZHD"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b26d7ddbfd7so6931379a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 04:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749641389; x=1750246189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zmNrjfZQXU9no9/hWCPAeWfccSWNYyxPqPE39CyoKdo=;
        b=IqK2MZHDSnO4mi1lDgHRSarYi4K5295xEpmDbrATeWVn+ZJ6HmqSV8bCn9TY0iyNFC
         qiCFpfjixbJ4pPQ/XMJVleOrO4ENgg4uv4FBa6442HVNs5Qv1T3YJjVoUu5wsqPXOBM9
         yzEUcYZVgLWtQnHGUmvgj9EE1hIWO+uJRCJBra/KZz3h7w96HtAkOih0wL3ZIxXEn7qi
         kdCjp4CZPC3UI+WDg0xzRZpzCZglQHs7mtOjdw+N3fue1dA+agTJkPQAErDy3tjjCAvR
         R/YZnsQxzifqbtrwwRVcshV/hHax2tE2+0L/kuNxb/fpERkrVkf/5YwpOSf2svppAIcQ
         Srcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749641389; x=1750246189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zmNrjfZQXU9no9/hWCPAeWfccSWNYyxPqPE39CyoKdo=;
        b=Df09+EF4UaoN4avlLzlY/onXIhjulhxlXOTO++rO3WnfACag5F2xOVTgzb2wy/H69y
         aFN5w1V0nTnZU2QJ+IneexnlBQw1cPkXSfFQHnRFZ1NP2fXISXADa9NKycjXSY14m0zw
         C1rrtUYjxxRJp9Ty4j3Nu/nhTRa7bPDPh7eMCltdOBMxB/KC84+wLwRS+XHY7gB+IGwV
         kKSfQMh/a5d5dPcFS9l16SRaJQAyJGkwQTM/jP8hk0XLCX5nfaEzxtWYesMtmlJqgc+O
         ALvsJ7MH9JctmaYZVl02BNZnIlo1xfw/9bINJCbqjkgZQZeTaTdmHEXaW+5ITg9WlUAC
         Kezg==
X-Gm-Message-State: AOJu0Yyz28IDMlsNJ4nY0DqopgpC6DAwH9stpOVUEHgQciYSyi2pmbO7
	vbSVYD1qEKkn8OIKa98W2GxmTtigz+SxAMgiDyO7kzT+eyba3QTihVeX4gwmYZ3u
X-Gm-Gg: ASbGnctpp7SKxf56fZs/MRS3AE+UpcmuqJFWT8xrsdTK2LcT5JVu3wYDtUcouFwRWON
	29owLMvibyzg7qhI/xPv1mzQNJ06YWyqP3R55Y2Ss9F7NDJZEK2IOsYD8FjaWhETy3f4POqhOD9
	ZoPyWoO4MbGLAQ4Zmnzgt1O3wD85LDyfcD1A8K/HP6iB6AUOpdxWwYdLyX6ZqHJ0J4x48Drwf5s
	/skmGgYJXSdf9Q7C0xGa6CQ3bi81x5zmhQN97xsKqVKNBmjDRS7TMyytOngRNtYhLKbVkUZJ24X
	ZuadSWWNwRIFKRCNsSfMSlNMDdYQtHjp8PGwEPta+Leb0907gymujBy74KxuCOcP0pw47wEsBoI
	Sin72gGZvX+3Q0kE=
X-Google-Smtp-Source: AGHT+IFVZWzY792eRDgo7L343go8Lt1w8FPKRsCgJurouJ5Zs4EbsQG65sPtEwCANACiDY7Uxbet0w==
X-Received: by 2002:a17:90b:28c3:b0:311:f05b:86a5 with SMTP id 98e67ed59e1d1-313aefe90b1mr5820351a91.0.1749641388905;
        Wed, 11 Jun 2025 04:29:48 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.159.189])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-313b2110382sm1194273a91.27.2025.06.11.04.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 04:29:48 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	paul@darkrain42.org
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] smb: improve directory cache reuse for readdir operations
Date: Wed, 11 Jun 2025 16:59:02 +0530
Message-ID: <20250611112902.60071-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, cached directory contents were not reused across subsequent
'ls' operations because the cache validity check relied on comparing
the ctx pointer, which changes with each readdir invocation. As a
result, the cached dir entries was not marked as valid and the cache was
not utilized for subsequent 'ls' operations.

This change uses the file pointer, which remains consistent across all
readdir calls for a given directory instance, to associate and validate
the cache. As a result, cached directory contents can now be
correctly reused, improving performance for repeated directory listings.

Performance gains with local windows SMB server:

Without the patch and default actimeo=1:
 1000 directory enumeration operations on dir with 10k files took 135.0s

With this patch and actimeo=0:
 1000 directory enumeration operations on dir with 10k files took just 5.1s

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cached_dir.h |  8 ++++----
 fs/smb/client/readdir.c    | 28 +++++++++++++++-------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1dfe79d947a6..bc8a812ff95f 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -21,10 +21,10 @@ struct cached_dirent {
 struct cached_dirents {
 	bool is_valid:1;
 	bool is_failed:1;
-	struct dir_context *ctx; /*
-				  * Only used to make sure we only take entries
-				  * from a single context. Never dereferenced.
-				  */
+	struct file *file; /*
+			    * Used to associate the cache with a single
+			    * open file instance.
+			    */
 	struct mutex de_mutex;
 	int pos;		 /* Expected ctx->pos */
 	struct list_head entries;
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index f9f11cbf89be..ba0193cf9033 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -851,9 +851,9 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 }
 
 static void update_cached_dirents_count(struct cached_dirents *cde,
-					struct dir_context *ctx)
+					struct file *file)
 {
-	if (cde->ctx != ctx)
+	if (cde->file != file)
 		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
@@ -862,9 +862,9 @@ static void update_cached_dirents_count(struct cached_dirents *cde,
 }
 
 static void finished_cached_dirents_count(struct cached_dirents *cde,
-					struct dir_context *ctx)
+					struct dir_context *ctx, struct file *file)
 {
-	if (cde->ctx != ctx)
+	if (cde->file != file)
 		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
@@ -877,11 +877,12 @@ static void finished_cached_dirents_count(struct cached_dirents *cde,
 static void add_cached_dirent(struct cached_dirents *cde,
 			      struct dir_context *ctx,
 			      const char *name, int namelen,
-			      struct cifs_fattr *fattr)
+			      struct cifs_fattr *fattr,
+				  struct file *file)
 {
 	struct cached_dirent *de;
 
-	if (cde->ctx != ctx)
+	if (cde->file != file)
 		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
@@ -911,7 +912,8 @@ static void add_cached_dirent(struct cached_dirents *cde,
 static bool cifs_dir_emit(struct dir_context *ctx,
 			  const char *name, int namelen,
 			  struct cifs_fattr *fattr,
-			  struct cached_fid *cfid)
+			  struct cached_fid *cfid,
+			  struct file *file)
 {
 	bool rc;
 	ino_t ino = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
@@ -923,7 +925,7 @@ static bool cifs_dir_emit(struct dir_context *ctx,
 	if (cfid) {
 		mutex_lock(&cfid->dirents.de_mutex);
 		add_cached_dirent(&cfid->dirents, ctx, name, namelen,
-				  fattr);
+				  fattr, file);
 		mutex_unlock(&cfid->dirents.de_mutex);
 	}
 
@@ -1023,7 +1025,7 @@ static int cifs_filldir(char *find_entry, struct file *file,
 	cifs_prime_dcache(file_dentry(file), &name, &fattr);
 
 	return !cifs_dir_emit(ctx, name.name, name.len,
-			      &fattr, cfid);
+			      &fattr, cfid, file);
 }
 
 
@@ -1074,8 +1076,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	 * we need to initialize scanning and storing the
 	 * directory content.
 	 */
-	if (ctx->pos == 0 && cfid->dirents.ctx == NULL) {
-		cfid->dirents.ctx = ctx;
+	if (ctx->pos == 0 && cfid->dirents.file == NULL) {
+		cfid->dirents.file = file;
 		cfid->dirents.pos = 2;
 	}
 	/*
@@ -1143,7 +1145,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	} else {
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			finished_cached_dirents_count(&cfid->dirents, ctx);
+			finished_cached_dirents_count(&cfid->dirents, ctx, file);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 		cifs_dbg(FYI, "Could not find entry\n");
@@ -1184,7 +1186,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		ctx->pos++;
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			update_cached_dirents_count(&cfid->dirents, ctx);
+			update_cached_dirents_count(&cfid->dirents, file);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 
-- 
2.43.0

