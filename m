Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E90F399002
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 16:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565350; cv=none; b=ZvSm/ySO2eU9oJkMcwJaqrt7462UMwndBRBbOMjRl+AJXYKbRpebMm+DrdypISLS5fqemxv72NtMfCSlL4Rkpw55Hdsbsljijyg51gk/FSuleHO2LzS/rfqY2tOkWobdOQDWQTpaHt5s5KFZ3huWt5ASM7EnM2CrUnq57NvHdAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565350; c=relaxed/simple;
	bh=XToTZ3zBMR36otuvJaJ5ogI7loawm4AAim7VQIN+kR8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gi768eN0IGtIzD6m1Yem4/ZCpezD11kzWD1NeTsDM9IAFt/u+vzTCzplOlIGULGewTv4dSmvj4U50EfRc95SdFIIHiPocTyPRrbIgSJIE/uEfI8n1frzdtP9tamwkXZatz4Rb/31TB8hvwSWIygaYfgfW1gcpyxgtG2yPRq0Vhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SHk2TEbh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tLt5cdUp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHk2TEbh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tLt5cdUp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784565347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMVsu1MqSASuIpCDgOJg28LBAfnejVitF7YApIAlxyY=;
	b=SHk2TEbhwjo0kirS+ZW26WQguUzeTR92eZ5n5otdzHpjzBLPKmAlaAPzE44KrfgkjX71x3
	IzmAA1xV1dO2drbNVPZnqbClHm9CuW5ebBuMRAseZcD7LS+IbgOa7p+PO/qqERZAIuL0xT
	yar724IGASUMvz9mu8PwLuVvcltkz1g=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-oCVr3EypPeuw3O0PqO7kMg-1; Mon, 20 Jul 2026 12:35:45 -0400
X-MC-Unique: oCVr3EypPeuw3O0PqO7kMg-1
X-Mimecast-MFC-AGG-ID: oCVr3EypPeuw3O0PqO7kMg_1784565344
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6a374304efbso13617294eaf.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 09:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784565344; x=1785170144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GMVsu1MqSASuIpCDgOJg28LBAfnejVitF7YApIAlxyY=;
        b=tLt5cdUpAH34KJVLE2co61knvAB4C1BB1RQy/3yMEDjt2ifkl3N6uajzkrZJT0T3u7
         WfmctQdgVU4mcSx1cRZLyocuCY5VO4vAdGgRcH7G9mUowgZgmxrDa/k4FW2S5zwpjC9I
         Q/KWBvpTZS0O6/31Y3PkIzaiSuz1l9/EJXxChD7HdFUUfKIOdAIOp3g+LyMIeuYXFSDq
         Dez6rnkLn66E06eqQpsoAyNL3/Mj+ivGZX0WEEthFfLu4tk6CPvuT6SM5657hevoYbpU
         68/f/Uta8z9rBylDdcflbqFiMWngM9zCWWKDepQg9ridEhY8XK2CgQYri3G6Gkq3QrCz
         GjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784565344; x=1785170144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GMVsu1MqSASuIpCDgOJg28LBAfnejVitF7YApIAlxyY=;
        b=PNL/kwjT2ipkQuGlDkw9x1IpYFuFmdWfKnLwT3LILXnDObjMhwzAmNmO0mox8I2U9H
         vrWOQL3mxkoOxwEkum0YJgsvoK1knUJzmMWnyeftNiC170nkPzJmAUAg9bET8sXIx4Tj
         2H/1a9Y3GgY3pPRKyQqP3aUl9mUcsARHqx94HRBuYT9ziep/jz8NqIVtlKnaK4IyNvH6
         ka3Ms99uxiiZZ4lGcdlHiDUfiI1U5bsvN3xizmz7fsfRi0NsGqmxvsbVl1NCLiBucHkl
         kk1ywk7ebbRjJteGMA8eFVw/r5iawhJxt5+DPB82ktDx35Rvb/C9Dvmkbl+8W2Skdnzy
         Gu7g==
X-Gm-Message-State: AOJu0YxJ5NWebNeVdO9bXzbaCq5twfjyr/1mZx0ZRX/A5W8yuROiTQZv
	bb27Vlca7SiQGkqIiAXbugTTAAzIchSHgnB93DjsqQBkb3K164UIv7K3KT+IAvFtK6ixkfQRiLq
	SmBm4jMr5WmQ2ZCa1iMe6D0KxbL9oEAF23bAqvuGt49dQQEzQTA1n5TKIN8fLQaAqzL5HQNy7eB
	TyUtNfh+Di6uYIsMOLvTBrdvDGYA5vd0MX7n4hngV6i/4JNAU=
X-Gm-Gg: AfdE7cnGZ5YY7FpQsvIOux7Xb1gljc48H+R+Mw7m1+szlaTX6+9Aakt74V1preW0jCe
	erbRB85LltR0IGrLPdqNfiFQQGTc+M9+sAT/5YUtBMnn4ohxUutZ55bIpd2RImByLkuKuuPk3MD
	jdqaSjWPBcHScKMbhriwXKBB/s7qlaxWTmqGdBhE68Pxq7f70hTnbs4HfokNWD9eU+opEtBNbDt
	/iN9QB62yQS3v2IRkDTTaFNmAUW9XnOd8Q5POmm1xr99q+pVa7DgYPjVFycAONGwVUpJuZMjb5K
	tq6yPfhigVIbHMqnx0O9k3Cprkj7o1L/bGa07uoYtYo/E12G9eR/rvXLbMy4T88cdCl7guYFZ9N
	6X/IH46Y/V2uE3eePLg4H6v9ad0tXUyPZIfqY6uHATX+ooTNcfpWASa1m2BYc
X-Received: by 2002:a05:6820:4cca:b0:6a3:97a0:b224 with SMTP id 006d021491bc7-6a536877950mr8097490eaf.33.1784565344298;
        Mon, 20 Jul 2026 09:35:44 -0700 (PDT)
X-Received: by 2002:a05:6820:4cca:b0:6a3:97a0:b224 with SMTP id 006d021491bc7-6a536877950mr8097479eaf.33.1784565343779;
        Mon, 20 Jul 2026 09:35:43 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edaf9cd6f4sm8662312a34.23.2026.07.20.09.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 09:35:43 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v2 1/2] cifs: serialize readdir with directory cache invalidation from lease breaks
Date: Mon, 20 Jul 2026 11:35:40 -0500
Message-ID: <20260720163541.1428872-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720163541.1428872-1-sorenson@redhat.com>
References: <20260720163541.1428872-1-sorenson@redhat.com>
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

