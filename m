Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528382116E7
	for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 00:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758069788; cv=none; b=olZWLAiiEHz2DivYW1VgS94Aev5/6uPM9hocEMXUyKOVsfGVLCtncRPMvbnAbeReoQaGCvKoRcBBqg6T2zhY05DSeoyol05Ids/34i3cyJND5WDvU55GUpumdLs/T+7JmGj9ohadouW5gNtXrWRCCTkAyy6P9Rjs7LdmjQ32zCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758069788; c=relaxed/simple;
	bh=bPbIpSjrTjqiowJ/rGqULMEjIbiVk/S5Hy0odg6P09k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dNF/a2v4KOs6TbOeCEOdqpSnieV7F5qEnzJVgvZeuy3/WLxhg8XACEQfgNgjX4LbEEaA+EbZ9H/TMrjNezGSQoo6uEb2dYdSnH4KwwY8zkDB1gyjOC2rvU86h41hEyhhXg/t7CqjqilEOQSBoYVzvinz6NmjiI2Zoverw5pHO/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=PM+DCiVL; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="PM+DCiVL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=y4m3NjC6i3xV3/GKOKbdu3Fs/+UVX79AKn2/IMRLArw=; b=PM+DCiVLG97lUHIt9/377EmgHT
	zTZlBr7LG7J+lh4n9uBKXgktZ/9RE7uSzTyRJFWkGi3qhwEPrCwXSahC+8aSlD3hMfIf+MCgCb6Sl
	h24/G9P0yhYxrxFKa+0r/fmSJndfk+7GuMgTcC/4lRRZ9yGV7N09vOWh0OLvs0lEA+4MSmIWXALZU
	wh25kQqZhGQlA6vTtkt8M72gU1mBnWGJ53yKVHs6ev8eMRmNnjXFzbkjMI726wYWT2YOWk8vIaHVj
	vgGSpxhda8tVrfegQAmhVreKmHB1zgXJA2DN5MTug/h13AmppIXY1aex/af24hRpMtO7HGXJDCn9f
	X9RUSUOA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uygAP-00000001YgF-2t9l;
	Tue, 16 Sep 2025 21:37:01 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix filename matching of deferred files
Date: Tue, 16 Sep 2025 21:37:01 -0300
Message-ID: <20250917003701.694520-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the following case where the client would end up closing both
deferred files (foo.tmp & foo) after unlink(foo) due to strstr() call
in cifs_close_deferred_file_under_dentry():

  fd1 = openat(AT_FDCWD, "foo", O_WRONLY|O_CREAT|O_TRUNC, 0666);
  fd2 = openat(AT_FDCWD, "foo.tmp", O_WRONLY|O_CREAT|O_TRUNC, 0666);
  close(fd1);
  close(fd2);
  unlink("foo");

Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/misc.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index da23cc12a52c..09d5fa3638c9 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -845,20 +845,19 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 	spin_lock(&tcon->open_file_lock);
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		full_path = build_path_from_dentry(cfile->dentry, page);
-		if (strstr(full_path, path)) {
-			if (delayed_work_pending(&cfile->deferred)) {
-				if (cancel_delayed_work(&cfile->deferred)) {
-					spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
-					cifs_del_deferred_close(cfile);
-					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+		if (IS_ERR(full_path) || strcmp(full_path, path))
+			continue;
+		if (delayed_work_pending(&cfile->deferred) &&
+		    cancel_delayed_work(&cfile->deferred)) {
+			spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+			cifs_del_deferred_close(cfile);
+			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
-					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
-					if (tmp_list == NULL)
-						break;
-					tmp_list->cfile = cfile;
-					list_add_tail(&tmp_list->list, &file_head);
-				}
-			}
+			tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
+			if (tmp_list == NULL)
+				break;
+			tmp_list->cfile = cfile;
+			list_add_tail(&tmp_list->list, &file_head);
 		}
 	}
 	spin_unlock(&tcon->open_file_lock);
-- 
2.51.0

