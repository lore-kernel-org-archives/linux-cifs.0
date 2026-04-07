Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BEB372EF5;
	Tue,  7 Apr 2026 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775591896; cv=none; b=IclHF85BOTxf6wctrGDqPGnllFuTh4VnczDvBiav0xDkeoQZV0ag3Stx6oMd2HPsmSCFGMvpk/mWIFtJjf5uODc5gTMRcol7v+fhPpd6B7zNhaHvdm3ZxuUMI7XFarG1WoEU92L+z1qUjNaROwZYbeAIGO3P2dgD+yeFlhZz2tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775591896; c=relaxed/simple;
	bh=ai1woy9AcZ6Mn5Q1SDLBbU1R46+AaUhq+y/ltspMVFM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aaHXic2q5b+4rLK4o6i4hTqmTQt6NDMPd1l5p9G5dNbsl5PfTo3j/uehXAFC6dmUJX/RdVzDuQYek0Q7iTw92WvMBr28uj5mYx8IeEWvyTYk0dgSMU7wg2r14ZRWvfgVywIblb3ljLEtf6PvdpvnJtbYXKGdZSbfApys+fS1+rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=T5iFyj70; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="T5iFyj70"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4Y8VJQhGsF/Hd1EvGb/OXRJwwnmkJ5iC1sxZAxQl2tY=; b=T5iFyj70TYpQP+beUlq4RpQBXn
	GVcWtlNx/T7SymP1mMAJRaImnqW6K8DoGprmDhRIcALrfCbSp9gCiD7tPvnsPYYKTnvoJgYUw0um7
	2bFpl9l7PToicnkm0DiFNaxD89QACOUlAPkUX9tJq0dGNg3IpGAwoEcZnBjjkMhPWkLJrtJCv+rQv
	COdoBdw85WOQdjC8TxsfdEa5h30MgQtUEzurDSxDiaD5MPVzNvpGH2cE+5JmoupM8UR+QJ107K4sl
	cSVgi4DAQm1JcjqS/gRfBYHfibBnEgEMOXe5csFw4VuMu9zZc2SAQZ+KZInai9+x/oshFTDOHUdr3
	Ukj0BIGg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wACYs-00000002NG1-3s0W;
	Tue, 07 Apr 2026 16:58:10 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: viro@zeniv.linux.org.uk,
	smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 1/2] vfs: introduce d_mark_tmpfile_name()
Date: Tue,  7 Apr 2026 16:58:09 -0300
Message-ID: <20260407195810.993862-1-pc@manguebit.org>
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
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
---
v1 -> v2:
  * fix BUG_ON() usage (willy)

 fs/dcache.c            | 19 +++++++++++++++++++
 include/linux/dcache.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7ba1801d8132..fcd5a40cce94 100644
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
+	BUG_ON(dname_external(dentry));
+	BUG_ON(d_really_is_positive(dentry));
+	BUG_ON(!d_unlinked(dentry));
+	BUG_ON(name->len > DNAME_INLINE_LEN - 1);
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

