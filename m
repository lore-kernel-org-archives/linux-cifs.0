Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F47C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Jan 2022 08:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352509AbiASIdB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:33:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352506AbiASIdA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 19 Jan 2022 03:33:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642581179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ue/zR5ctL9xqmZaX8RC/BhnarR76dUxiZFjQFbBnl8A=;
        b=DNy5X2mEeWkMqCG0iCmu+0SspvD/XzrPFNLkmyiNwbaOkAa5NibkDCPo8nrz1b1IbwUXu1
        p+Z/lS1ES4elKh46a13xvdoejqJFerq9yyBFvVHLvQm2PZbDbX2pKq21ADUDAIlSAGfRwT
        3Fepp1OJjj2e67czroiojmW/I7aFK2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-BMxSBeW-O2WF1IKJi5zyiw-1; Wed, 19 Jan 2022 03:32:56 -0500
X-MC-Unique: BMxSBeW-O2WF1IKJi5zyiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A0821966320;
        Wed, 19 Jan 2022 08:32:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A12CB60C28;
        Wed, 19 Jan 2022 08:32:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5muTanw9pJqzAHd01d9A8keeChkzGsCEH6=0rHutVLAF-A@mail.gmail.com>
References: <CAH2r5muTanw9pJqzAHd01d9A8keeChkzGsCEH6=0rHutVLAF-A@mail.gmail.com> <164251396932.3435901.344517748027321142.stgit@warthog.procyon.org.uk> <164251411336.3435901.17077059669994001060.stgit@warthog.procyon.org.uk>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: [PATCH 11/11] cifs: Support fscache indexing rewrite
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3762845.1642581170.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 19 Jan 2022 08:32:50 +0000
Message-ID: <3762846.1642581170@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> WARNING: Missing a blank line after declarations
> #460: FILE: fs/cifs/file.c:658:
> + struct cifs_fscache_inode_coherency_data cd;
> + cifs_fscache_fill_coherency(file_inode(file), &cd);

I have a small patch to abstract cache invalidation for cifs into a helper
function (see attached) that I'll merge in that will also take care of thi=
s.

David
---
commit ff463eee039fbe119ae0d4185cb8a90aec10ec80
Author: David Howells <dhowells@redhat.com>
Date:   Fri Jan 7 18:08:37 2022 +0000

    cifs: Abstract cache invalidation into a helper function
    =

    Abstract fscache invalidation for a cifs inode out into a helper funct=
ion
    as there will be more than one caller of it.
    =

    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 27604eb01a94..015fd415e5ee 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -653,13 +653,9 @@ int cifs_open(struct inode *inode, struct file *file)
 			   file->f_mode & FMODE_WRITE);
 	if (file->f_flags & O_DIRECT &&
 	    (!((file->f_flags & O_ACCMODE) !=3D O_RDONLY) ||
-	     file->f_flags & O_APPEND)) {
-		struct cifs_fscache_inode_coherency_data cd;
-		cifs_fscache_fill_coherency(file_inode(file), &cd);
-		fscache_invalidate(cifs_inode_cookie(file_inode(file)),
-				   &cd, i_size_read(file_inode(file)),
-				   FSCACHE_INVAL_DIO_WRITE);
-	}
+	     file->f_flags & O_APPEND))
+		cifs_invalidate_cache(file_inode(file),
+				      FSCACHE_INVAL_DIO_WRITE);
 =

 out:
 	free_dentry_path(page);
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index e444445d0906..b741d38df6c8 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -71,6 +71,15 @@ static inline struct fscache_cookie *cifs_inode_cookie(=
struct inode *inode)
 	return netfs_i_cookie(inode);
 }
 =

+static inline void cifs_invalidate_cache(struct inode *inode, unsigned in=
t flags)
+{
+	struct cifs_fscache_inode_coherency_data cd;
+
+	cifs_fscache_fill_coherency(inode, &cd);
+	fscache_invalidate(cifs_inode_cookie(inode), &cd,
+			   i_size_read(inode), flags);
+}
+
 static inline int cifs_readpage_from_fscache(struct inode *inode,
 					     struct page *page)
 {
@@ -112,6 +121,7 @@ static inline void cifs_fscache_get_inode_cookie(struc=
t inode *inode) {}
 static inline void cifs_fscache_release_inode_cookie(struct inode *inode)=
 {}
 static inline void cifs_fscache_unuse_inode_cookie(struct inode *inode, b=
ool update) {}
 static inline struct fscache_cookie *cifs_inode_cookie(struct inode *inod=
e) { return NULL; }
+static inline void cifs_invalidate_cache(struct inode *inode, unsigned in=
t flags) {}
 =

 static inline int
 cifs_readpage_from_fscache(struct inode *inode, struct page *page)

