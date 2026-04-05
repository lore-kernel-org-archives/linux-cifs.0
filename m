Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B47381B01;
	Sun,  5 Apr 2026 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775423911; cv=none; b=sjTYQe9zMpE3DCnS3VUaF9jg/4DJmP0QHWz3y+oBI1DqUj5NmmYuN2nWhzBCMZ8ce46I9VYddqO3G1DpDEslv7o3usYS3A4pYOIycKZ1oU6fdQCzAaMRkXlSDZ4Q1PFlWQg1h7PKy18JBdVzMHdFB7Ug2KuabXd71OE8JTfegT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775423911; c=relaxed/simple;
	bh=De9P1RCqPoG2wXGPrLaoafgTnqQFr7Gy4Q0m4jXzjKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LG7xdu7dTWltoQ8uE71R87zxvXXwo8GBFkyXvQXRpUA6DhkAil4lQVI5qyutaE0kDNytiHrhcp4Md3M/b0LMRsoEoPHOZOamLYnKMDWJ1SJ3YjNhSLTcO0Rl6yjH8ppAd5TfEyLn5DpyzXmNUOeoy8dwFValvyIfzWwi2lJ4hCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=B0i01b8q; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="B0i01b8q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=R3hAMltGZXZBXMekdnU4F6nV3F8FNNgjvNrI3g9yUq0=; b=B0i01b8qY098hF/cM3fCuthraz
	Ix/GjrEIY1vFBNafHYIn8CJG2aTtIcAk7RzFb+79fuNVZTOBd+ynQeKiqCXHQ5B1Gu0S3wyKFdGs+
	tdjjISnTVtQqTqtnKThaIWamgUTi/njGFmgxKCkGw3gvzjGBhjuPHPSbl/q5M4i4ucWGmkDEa01CA
	a75+aNGPxjOWEyIW9WL+UHaQU8OCPuGNL/uCOhEIh9OQltcDD86w2qPkMm665nzBqgq6/wmN2sgiH
	dzrGvk88hmtMMdo7YeveWi+p+0iIW3o/eM9FsLS4EFeVDRq1mS+LSFX7l/iWECbv5WDzjyOV2CR5h
	P2Y7jSMg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w9UrL-00000002GBi-2cBL;
	Sun, 05 Apr 2026 18:18:19 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: viro@zeniv.linux.org.uk,
	smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Howells <dhowells@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/2] vfs: introduce d_mark_tmpfile_name()
Date: Sun,  5 Apr 2026 18:18:18 -0300
Message-ID: <20260405211819.1251369-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CIFS requires O_TMPFILE dentries to have names of newly created
delete-on-close files in the server so it can build full pathnames
from the root of the share when performing operations on them.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
---
 fs/dcache.c            | 19 +++++++++++++++++++
 include/linux/dcache.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7ba1801d8132..c20a9c9e921c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3196,6 +3196,25 @@ void d_mark_tmpfile(struct file *file, struct inode *inode)
 }
 EXPORT_SYMBOL(d_mark_tmpfile);
 
+void d_mark_tmpfile_name(struct file *file, const struct qstr *name)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	char *dname = dentry->d_shortname.string;
+
+	BUG_ON(dname_external(dentry) ||
+	       d_really_is_positive(dentry) ||
+	       !d_unlinked(dentry) ||
+	       name->len > DNAME_INLINE_LEN - 1);
+	spin_lock(&dentry->d_parent->d_lock);
+	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+	dentry->__d_name.len = name->len;
+	memcpy(dname, name->name, name->len);
+	dname[name->len] = '\0';
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dentry->d_parent->d_lock);
+}
+EXPORT_SYMBOL(d_mark_tmpfile_name);
+
 void d_tmpfile(struct file *file, struct inode *inode)
 {
 	struct dentry *dentry = file->f_path.dentry;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 898c60d21c92..f60819dcfebd 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -264,6 +264,7 @@ extern void d_invalidate(struct dentry *);
 extern struct dentry * d_make_root(struct inode *);
 
 extern void d_mark_tmpfile(struct file *, struct inode *);
+void d_mark_tmpfile_name(struct file *file, const struct qstr *name);
 extern void d_tmpfile(struct file *, struct inode *);
 
 extern struct dentry *d_find_alias(struct inode *);
-- 
2.53.0

