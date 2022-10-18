Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028F7C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Oct 2022 07:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJRHjd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Oct 2022 03:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiJRHjb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Oct 2022 03:39:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A93AC7E
        for <linux-cifs@vger.kernel.org>; Tue, 18 Oct 2022 00:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666078764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQ3kK77qX/Suu8GxdqHjeZwSImbdkcxYF7bA+R4ztPY=;
        b=jPG8R4jTG9OgeE2fLmue36vDD/UF6F069Nid3ENgcF6KNvVOZpyQFgYDGK1tJlbQ8fa9sq
        oN97437JM2u7PKpPaiVF2lIgwVOWa/eKYtYzzUeoUvmNwf0Rt56xGQUQqJ+ebd/Xqbm7p4
        2f07dZnSC3jd2S2qKXDqwqf0LOODI/I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-6yhwcBGbOW6DR8nQtMB0lw-1; Tue, 18 Oct 2022 03:39:23 -0400
X-MC-Unique: 6yhwcBGbOW6DR8nQtMB0lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02BDD1C1A550;
        Tue, 18 Oct 2022 07:39:23 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F060740C206B;
        Tue, 18 Oct 2022 07:39:21 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: drop the lease for cached directories on rmdir or rename
Date:   Tue, 18 Oct 2022 17:39:10 +1000
Message-Id: <20221018073910.1732992-2-lsahlber@redhat.com>
In-Reply-To: <20221018073910.1732992-1-lsahlber@redhat.com>
References: <20221018073910.1732992-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we delete or rename a directory we must also drop any cached lease we have
on the directory.

Fixes: a350d6e73f5e ("cifs: enable caching of directories for which a lease
is held")
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 21 +++++++++++++++++++++
 fs/cifs/cached_dir.h |  4 ++++
 fs/cifs/smb2inode.c  |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index ffc924296e59..6e689c4c8d1b 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -340,6 +340,27 @@ smb2_close_cached_fid(struct kref *ref)
 	free_cached_dir(cfid);
 }
 
+void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
+			     const char *name, struct cifs_sb_info *cifs_sb)
+{
+	struct cached_fid *cfid = NULL;
+	int rc;
+
+	rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
+	if (rc) {
+		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
+		return;
+	}
+	spin_lock(&cfid->cfids->cfid_list_lock);
+	if (cfid->has_lease) {
+		cfid->has_lease = false;
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
+	}
+	spin_unlock(&cfid->cfids->cfid_list_lock);
+	close_cached_dir(cfid);
+}
+
+
 void close_cached_dir(struct cached_fid *cfid)
 {
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index e536304ca2ce..2f4e764c9ca9 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -69,6 +69,10 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 				     struct dentry *dentry,
 				     struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
+extern void drop_cached_dir_by_name(const unsigned int xid,
+				    struct cifs_tcon *tcon,
+				    const char *name,
+				    struct cifs_sb_info *cifs_sb);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
 extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index a6640e6ea58b..68e08c85fbb8 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -655,6 +655,7 @@ int
 smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	   struct cifs_sb_info *cifs_sb)
 {
+	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_NOT_FILE, ACL_NO_MODE,
 				NULL, SMB2_OP_RMDIR, NULL, NULL, NULL);
@@ -698,6 +699,7 @@ smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct cifsFileInfo *cfile;
 
+	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
-- 
2.35.3

