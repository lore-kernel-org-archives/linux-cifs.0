Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB41175A7D
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784910646; cv=none; b=AC404zVG7s064rx12gWUluLjrVvZ9/qWxDfQ0xQBn7BAiqwfOxWXMp/7tUIsYbqNAZMPX3uwBc6PKbM3ctKQ0gk6dmCbRO2272MESy0t009pDDYzJlR5CT98e5jxHCJYyvbyNu8vIoyZ+ameqRWRqmHhWkH/Kbe487U0ZtoTKA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784910646; c=relaxed/simple;
	bh=TXha3ahed3rmWzBxsutpZ7FijFVjIOTCpGKhX27Pcsg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/i/vkCx0mbat1MDJya+Wp+XbOaAV+q0Pw4kCaFmGQn0rWCR5VYwIHqb/gKMD+5UBBFygC9xuGYuUcMqG7ohaIl3/QqMBT+96yTGNBMelMsXqfJhzZC9gffZOr83J+pqB3LQwi0f2hCP0SkxfznEh4omYOwmYtd/5FdDVzFQgMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gPeOd2v7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bS8wCBV8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gPeOd2v7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bS8wCBV8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784910643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zXdPGGhtmCA9Y48+PJ9aSPMRCrbNxjQQxIc8Vb/EXoA=;
	b=gPeOd2v7PsiDNcVWYZdxlyGsGE/nrlvndY1pNnNchpNVGknxS1AILKQy1U5gXRKe7b8Yh4
	SVf4YSQ7FQfeClO7+/SxYEnMXtFWukmemm80aV7nqqG7QvEUSADqAROGnK+gGZ+s+THDoS
	UkVmBzlnR6ZCT1bjFTdz0pc8T82XeGs=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-EB_U3nQRNLCVwUS2X9F_ew-1; Fri, 24 Jul 2026 12:30:42 -0400
X-MC-Unique: EB_U3nQRNLCVwUS2X9F_ew-1
X-Mimecast-MFC-AGG-ID: EB_U3nQRNLCVwUS2X9F_ew_1784910641
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e9e54e9cf5so617282a34.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 09:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784910641; x=1785515441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zXdPGGhtmCA9Y48+PJ9aSPMRCrbNxjQQxIc8Vb/EXoA=;
        b=bS8wCBV86VnhmXuVCH9WA97ZhN+33rMdlDdGdT8QqVZGFzvVXrp6qYd973O+yQtKDW
         FyF5yWXEytJLUBIHoEq9aXjsk3YCj76+0yF99VOvScwSoOT2PXinS/8TTSDuysdXBb5+
         8vDSx/WaniDcOvXlC3ldOc/Ad6cYdl766QMdz4DC4V0tDsbEywYlRRqusXcWYYxmFte+
         i7Q6WGZtT4wk3Q6sb9uJjUY+pd0//ajr5jtQtStuRMhA4Q1bj52nPbXewajNkU/tiIaA
         Z4ix/GcJIO2XwK6d1gCIhC5GDMKMb6U0/a/PwdbJO6xKSYToZZIwzR6/OAGNDJYHcmx4
         hFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784910641; x=1785515441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zXdPGGhtmCA9Y48+PJ9aSPMRCrbNxjQQxIc8Vb/EXoA=;
        b=ikI5xRnmKnXNWUlfHH+shJ2lBxxZUj395H8UHUVeb0viDqAGrnNnqvrom83bTjZKl6
         76C4AjxH6zi0fhHlRrkq2Sw5klqxPSqx/DIQWCPgKcG5uZChWkZhnbT1S5rTEjQpx4zs
         cT7PmlWW9YVQmIPQTl0LJaizvI2l7j09UOwVEb72EPiYFx4/2Ma/tWXW+a0nAXVOzW72
         ouEaI0mJfIf+++OuiBDF+Pemww1Pguu/MxCHQOfhOF5J3tD6qY6APxOoCAWizfOCpnfv
         GveIsUEZcWqWB+Xu6iercijeg+nh0XRCkeWxZMjWc/LmO62rl8C2WiZ51NQCWv4p5oUL
         twyQ==
X-Gm-Message-State: AOJu0YwoqJQ0X0BI4sdnMRkLjFnpARYtuC5t6Xu+bjQhtF1JOGzQ3Uq0
	Q8qWjWN0PqaaG1LA5btHV6xUJ09RxLUxV9HKnOGLuSqT48VjrQUPxVQ8vm3LCzfDoDPLMHXqztW
	Il5V8WQnVB86lRBfkhYNIAzuNTJCNYrV9VZJkGM6vwpJjQi9nD8pwuRZTWm9hV3KiJISdII8wP1
	XFbrz4TIa+C4OrHLN8mH0lLaqZR9uv+Xr9VA5kMFqEMPxzpgk=
X-Gm-Gg: AR+sD12yi6UGdkUtOElxEe87u9j8hZ9xxJwS3nRQvsO54Ufg/LHsFQX1PZJmrTw/+r8
	ODFJwZ13skInLgg5F49PefH4ukD2HDAIE6ZfcU9/IAXpgdkTXBFuqYTx9exTZcu4sRUlXye2+sB
	Tb1CpLB19m8kK2zJU6QLNpCc3RPazcv8pHdzRD64spx8ZtFawozQ/CloAJ6Zdutx0Tfvttra2sT
	38zCPSqS5ZRRt+eJKGW+7JZXgsFvhaI2GK1l3PIDmKomKq1YA6Dpzq7HISANW54d9Z5zR9NSQvM
	4as9TH2DaLMEUeWC7BsBjALbo69hJMwSOob/usNl8pfoRT8251JKx/TA6S3K2UlHy3VT3MwzXLV
	zZosPgp8LsvO4EZwuAG+d883ArzehaQ0+lnVT7VG/jmBjn97ltGIpY+Q+1wCp
X-Received: by 2002:a05:6830:349c:b0:7dc:df37:844b with SMTP id 46e09a7af769-7ee43eaa5d4mr5321359a34.4.1784910641123;
        Fri, 24 Jul 2026 09:30:41 -0700 (PDT)
X-Received: by 2002:a05:6830:349c:b0:7dc:df37:844b with SMTP id 46e09a7af769-7ee43eaa5d4mr5321321a34.4.1784910640468;
        Fri, 24 Jul 2026 09:30:40 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a03d30asm6351819a34.18.2026.07.24.09.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 09:30:39 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 1/2] cifs: consolidate time_last_write stamp into _cifsFileInfo_put()
Date: Fri, 24 Jul 2026 11:30:35 -0500
Message-ID: <20260724163036.2670328-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260724163036.2670328-1-sorenson@redhat.com>
References: <20260724163036.2670328-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The time_last_write stamp was scattered across cifs_close(),
smb2_deferred_work_close(), and the three drain functions in misc.c.
This missed the case where background I/O holds the final reference
after userspace close() returns, and required explicit maintenance at
each close-path site.

Move the smp_store_release() into _cifsFileInfo_put(), immediately
before releasing open_file_lock.  This single location covers all
close paths unconditionally: normal close, background I/O dropping the
final reference, deferred close via timer or external drain.  The
spinlock's store-release/load-acquire pairing with is_inode_writable()
already provides the ordering guarantee documented in
is_size_safe_to_change().

Remove the now-redundant stamps from cifs_close(),
smb2_deferred_work_close(), and all six stamp sites in the misc.c
deferred-close drain functions.

Fixes: e8a8d54c2d50 ("cifs: prevent readdir from changing file size due to stale directory metadata")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/file.c | 37 ++++++++++++++------------------
 fs/smb/client/misc.c | 51 ++++++--------------------------------------
 2 files changed, 22 insertions(+), 66 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b279a44be729..ac89c1ba56b1 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -915,6 +915,14 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		cifs_set_oplock_level(cifsi, 0);
 	}
 
+	if (OPEN_FMODE(cifs_file->f_flags) & FMODE_WRITE) {
+		/* Stamp while open_file_lock is held; covers all close paths
+		 * including background I/O. Pairs with smp_load_acquire() in
+		 * is_size_safe_to_change().
+		 */
+		smp_store_release(&cifsi->time_last_write, jiffies);
+	}
+
 	spin_unlock(&cifsi->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
@@ -1429,15 +1437,6 @@ void smb2_deferred_work_close(struct work_struct *work)
 	cifs_del_deferred_close(cfile);
 	cfile->deferred_close_scheduled = false;
 	spin_unlock(&cinode->deferred_lock);
-	/*
-	 * Refresh time_last_write immediately before the actual server close
-	 * so the protection window is anchored to the real close time, not
-	 * the earlier userspace close time stored by cifs_close().
-	 */
-	if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-		smp_store_release(&cinode->time_last_write, jiffies);
-	}
 	_cifsFileInfo_put(cfile, true, false);
 }
 
@@ -1467,10 +1466,6 @@ int cifs_close(struct inode *inode, struct file *file)
 	if (file->private_data != NULL) {
 		cfile = file->private_data;
 		file->private_data = NULL;
-		if (file->f_mode & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&cinode->time_last_write, jiffies);
-		}
 		dclose = kmalloc_obj(struct cifs_deferred_close);
 		if ((cfile->status_file_deleted == false) &&
 		    (smb2_can_defer_close(inode, dclose))) {
@@ -3276,13 +3271,13 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 	 * No writable handles open. Check whether we are within the attribute
 	 * cache validity window of a recent local modification.
 	 *
-	 * For the close() path: cifs_close() calls smp_store_release() on
-	 * time_last_write before _cifsFileInfo_put() removes the handle under
-	 * open_file_lock. That spin_unlock() is a store-release that pairs
-	 * with the spin_lock() (load-acquire) in is_inode_writable() above,
-	 * so if is_inode_writable() returned false the smp_load_acquire()
-	 * below is guaranteed to observe any time_last_write update from a
-	 * concurrent close().
+	 * For the close() path: _cifsFileInfo_put() stamps time_last_write
+	 * (via smp_store_release()) before releasing open_file_lock. That
+	 * spin_unlock() is a store-release that pairs with the spin_lock()
+	 * (load-acquire) in is_inode_writable() above, so if
+	 * is_inode_writable() returned false the smp_load_acquire() below is
+	 * guaranteed to observe any time_last_write update from a concurrent
+	 * close(), covering all close paths including background I/O.
 	 *
 	 * For the setattr/truncate paths: those callers use smp_store_release()
 	 * directly; the smp_load_acquire() below pairs with that store. There
@@ -3297,7 +3292,7 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 	 * jiffies is still close to INITIAL_JIFFIES on 32-bit systems.
 	 */
 	if (from_readdir) {
-		/* Pairs with smp_store_release() at close and truncate sites. */
+		/* Pairs with smp_store_release() in _cifsFileInfo_put() and setattr. */
 		tlw = smp_load_acquire(&cifsInode->time_last_write);
 		if (tlw && time_before(jiffies, tlw + cifs_sb->ctx->acregmax))
 			return false;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 6edebc0807ea..46e1382e8e04 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -525,24 +525,11 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	}
 	spin_unlock(&cifs_inode->open_file_lock);
 
-	if (failed_cfile) {
-		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
-					  jiffies);
-		}
+	if (failed_cfile)
 		_cifsFileInfo_put(failed_cfile, false, false);
-	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		struct cifsFileInfo *cfile = tmp_list->cfile;
-
-		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
-					  jiffies);
-		}
-		_cifsFileInfo_put(cfile, false, false);
+		_cifsFileInfo_put(tmp_list->cfile, false, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -576,24 +563,11 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	if (failed_cfile) {
-		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
-					  jiffies);
-		}
+	if (failed_cfile)
 		_cifsFileInfo_put(failed_cfile, true, false);
-	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		struct cifsFileInfo *cfile = tmp_list->cfile;
-
-		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
-					  jiffies);
-		}
-		_cifsFileInfo_put(cfile, true, false);
+		_cifsFileInfo_put(tmp_list->cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -663,24 +637,11 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	if (failed_cfile) {
-		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
-					  jiffies);
-		}
+	if (failed_cfile)
 		_cifsFileInfo_put(failed_cfile, true, false);
-	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		struct cifsFileInfo *cfile = tmp_list->cfile;
-
-		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
-					  jiffies);
-		}
-		_cifsFileInfo_put(cfile, true, false);
+		_cifsFileInfo_put(tmp_list->cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-- 
2.55.0

