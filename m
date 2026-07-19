Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794F42B9B7
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 21:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784498064; cv=none; b=O/dHijE9fEJVRX8nwdQhgh824NulacXAdfPQ55GdJOXT5AKaI9S16KGc+SyEcxGgEokX5e4uKx5wibGubgINt4kSdvVnVlP35gnHJZbJB7b9LGy0SrP1E1+wYnw+gIQO0GR0dAFEGle+2UvtoqJsk7X6VGIswyOWPrgN/iMdAD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784498064; c=relaxed/simple;
	bh=XToTZ3zBMR36otuvJaJ5ogI7loawm4AAim7VQIN+kR8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9ET0DfjXAAWfKlUFNuEdrkkFrhwpQrWiRrfg/W1bUUgA4SoIFGZC54E03Ogun6dkEnLC8ECDY8YDQkT4U6xieZD8Z5dVQsdGU11HCEXZk3wzw1gFxgyaTqyxautma7jSaxuBXomH8DO5QER4ieMgyeO35VLZikEgfBeoT/Pz20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iCyqwcLW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jy8AEJDG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCyqwcLW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jy8AEJDG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784498058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMVsu1MqSASuIpCDgOJg28LBAfnejVitF7YApIAlxyY=;
	b=iCyqwcLWEBotKcMcuxwC4mbuFH++FfYU+Y29+uZmb7/SXFBgfXIk6NmABVxUFhUPCTAAQf
	oLycLyDLzppqVBY5bLS34scGAqtXLw5g0G8zxdjmGny8GQy0i0VYlbhqwXZE3bGLQg1zGA
	zUomI6S+64hLbvmwJiLVwK4PJR4l2S0=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-BGEwMurgP-aJLY-Q8d8PHg-1; Sun, 19 Jul 2026 17:54:17 -0400
X-MC-Unique: BGEwMurgP-aJLY-Q8d8PHg-1
X-Mimecast-MFC-AGG-ID: BGEwMurgP-aJLY-Q8d8PHg_1784498056
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6a1791a6281so15995461eaf.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 14:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784498056; x=1785102856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GMVsu1MqSASuIpCDgOJg28LBAfnejVitF7YApIAlxyY=;
        b=jy8AEJDG0N9mjCW/nCz4J6UtZDyJcZP4Yfo+CxfH6a9IwuEvkZh4wgHzjpxkMuGT4r
         ho8X602yM04EWvzCZtj4KzFelhIxfMB+l4vZ87J10BW08RvSc6Uk0nLMpTKI0OrDu1ck
         ZXNxy19JcFce4LB5DnufHoa1bpukhHdI/e2SeWdQZXeu9yL1KNPYp4JvAqioPV5bUwc2
         2KKm5KYCfmMHnyWvqCu/O+iz24PTgYxRAeVA2VJTZu16p1oCmjZ9OgYcO+miy4T9pPQs
         Mw/po3YrlyXduzYznEGOWga7bIyNdEcCe5vNqq7HBDuPXsyO69lFF1ghMylIsMAEsmF4
         /QdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784498056; x=1785102856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GMVsu1MqSASuIpCDgOJg28LBAfnejVitF7YApIAlxyY=;
        b=ULCJyAVsmvUHTuXyCc/GJkWtDhAIZt2etK/e5P1D//pj361aFukpwGEZh5nCtlHpaj
         fsVQG/D3eMixAEzIlaTyVEAkbxygj/22WgHunxf2ok6XJQ8X+mWcmJlwemL/Kcowjcqb
         h0QG8zLNZJ2+L3dUvsXYk/i88xfTEmtlIn/BNfnT584TgBj9LQ7xzYPAlZLejwZj9mJM
         WALwvtYMn4cHPZ9CZzH42Y9je3VRaeBBywoNfcq4gt9PXjQj+5R7dO7wYK+dnoGeJU12
         ZJaprEUuemF/thJnEqiY3LmJcXuluuTnIgSFZ6aUKPVUYLytqFPRcU9seqcbSbeOJBzJ
         OluQ==
X-Gm-Message-State: AOJu0YwItP8THpqXedtp33urvs9gd+g+Am0H7cCPD2C0pRwdkmanifiE
	r5AYktNIBhPravTvOExNz+Je1f0jAtRxv9UmzxSJNUPaN1AgZl/J+H1gVjJUsR/TJpjex0UFHJW
	lQe5z0w+CFfPdMT3Q6VoHVrw2eig+86B0CWaz4Lw+o3GInEVDc1r17D2yxjnYlHzRkFiJ6Jnyki
	pdIZIW96g646F3G/7w5aKgVR1GE5ZgAKsWti0hX56GmsvVtSg=
X-Gm-Gg: AfdE7cn6NbcVGn1Yy/CuvBgMEAnv0cAL5t/HokeXBsOMPWcdrRX9MCImUe2vMExqA/b
	SYddEazd9koGzl2tarpDnLrdFBQ4OEN7A7ySXzrn0I23onHJh2Q33CTQahEU09kNLmSjObxBMEs
	kzrQ5lfJrjuEKTRV7PtmJrNOJrKs8j20NkRmnWvkruvqrdOS/QAHKhbtsQj+pWU2pUlpUCt0Jjj
	zt9qWgqgPY7m1kXh5mtSMyuJG5bcxJxt16BRKA8GciTX2WxBaiSPrgbIfewxXYfHji9o239Sxnf
	x/FLuL1n4YoVzMBMPxoJ3z1adSTw0ybRITWhUAMR/deLG7Sv5uTIiVU9BoLoAGqwwtRPmRzS1lI
	Fo9T5exfbiAFOPpwyIRax3M8o0GXoNsdrqxF9XJeu4l9epj+O/HCcGrZGDOXc
X-Received: by 2002:a05:6820:1806:b0:6a1:50eb:2110 with SMTP id 006d021491bc7-6a536a9faddmr6056544eaf.69.1784498056320;
        Sun, 19 Jul 2026 14:54:16 -0700 (PDT)
X-Received: by 2002:a05:6820:1806:b0:6a1:50eb:2110 with SMTP id 006d021491bc7-6a536a9faddmr6056528eaf.69.1784498055870;
        Sun, 19 Jul 2026 14:54:15 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edaf98c5f4sm6469018a34.20.2026.07.19.14.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:54:15 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 1/2] cifs: serialize readdir with directory cache invalidation from lease breaks
Date: Sun, 19 Jul 2026 16:54:11 -0500
Message-ID: <20260719215412.1218034-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260719215412.1218034-1-sorenson@redhat.com>
References: <20260719215412.1218034-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SMB2 directory lease breaks occur concurrently with readdir
(getdents) operations, the lease break handler can invalidate the
directory cache while readdir is still traversing it, corrupting the
dcache and causing subsequent stat() calls to return wrong file sizes
or EIO errors.

The race:
  1. rename() completes successfully, returns to userspace
  2. Userspace calls getdents64 on the directory
  3. cifs_readdir() begins traversing directory cache entries
  4. Server sends a lease break notification (directory was modified)
  5. cifs_oplock_break() -> cifs_revalidate_mapping() -> cifs_zap_mapping()
     acquires CIFS_INO_LOCK and invalidates the page cache
  6. RACE: cache invalidation runs concurrently with readdir traversal
  7. Subsequent stat() calls return wrong file sizes from the corrupted cache

This bug has existed since directory-level lease support was added.

The fix uses the existing CIFS_INO_LOCK bit to serialize cifs_readdir()
with cifs_revalidate_mapping(), which the lease break handler calls.
Since cifs_revalidate_mapping() already acquires CIFS_INO_LOCK before
invalidating, having cifs_readdir() hold it makes the two operations
mutually exclusive.

cifs_wait_bit_killable() is made non-static so readdir.c can use it
as the wait function for wait_on_bit_lock_action(). On lock acquisition
failure (signal), the already-allocated dentry path page is freed before
returning.

Reproducer: concurrent renames + readdir with 2 or more threads against
a Windows Server share (directory leases required; does not reproduce
against Samba or with actimeo=0).

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/inode.c     |  2 +-
 fs/smb/client/readdir.c   | 12 ++++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 00168839c123..e1f8304d323c 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -183,6 +183,7 @@ void cifs_dir_info_to_fattr(struct cifs_fattr *fattr,
 int cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 			bool from_readdir);
 struct inode *cifs_iget(struct super_block *sb, struct cifs_fattr *fattr);
+int cifs_wait_bit_killable(struct wait_bit_key *key, int mode);

 int cifs_get_inode_info(struct inode **inode, const char *full_path,
 			struct cifs_open_info_data *data,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index deed04dd9b91..e75138f5f6bc 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2772,7 +2772,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
  * @key:	currently unused
  * @mode:	the task state to sleep in
  */
-static int
+int
 cifs_wait_bit_killable(struct wait_bit_key *key, int mode)
 {
 	schedule();
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index ee5996e6d7d8..862ccc1a7e13 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -1064,6 +1064,17 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	void *page = alloc_dentry_path();
 	struct cached_fid *cfid = NULL;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
+	struct inode *inode = file_inode(file);
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	int lock_rc;
+
+	lock_rc = wait_on_bit_lock_action(&cinode->flags, CIFS_INO_LOCK,
+					  cifs_wait_bit_killable,
+					  TASK_KILLABLE|TASK_FREEZABLE_UNSAFE);
+	if (lock_rc) {
+		free_dentry_path(page);
+		return lock_rc;
+	}

 	xid = get_xid();

@@ -1226,5 +1237,6 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		close_cached_dir(cfid);
 	free_dentry_path(page);
 	free_xid(xid);
+	clear_and_wake_up_bit(CIFS_INO_LOCK, &cinode->flags);
 	return rc;
 }
--
2.55.0

