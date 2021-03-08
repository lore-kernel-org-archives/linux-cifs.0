Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F085C433E6
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70931652A4
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhCHXHx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:07:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229627AbhCHXHt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=81wsiKfCl4t7ZFP8lVjcPTP/RflB7DvlahVcI2y5ICY=;
        b=OX5EYfyaZDGz9EwrOp6DIMPKVrHqWpbxMO7eixLDaXXs7sFqgSm3A+rsauIjlaRw3ZkcMK
        ScjGC4ckNuzEXAC+wct2PqBtmgwg7SlYz4yuUgDbhK8xP8QhgP4ns4gFUc1W32sJipAFyK
        dpK0hU3wuuWUIA9JVOliB7gP00ZtgyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-WAB-fLZdOpCloNdq2Fwy7Q-1; Mon, 08 Mar 2021 18:07:46 -0500
X-MC-Unique: WAB-fLZdOpCloNdq2Fwy7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0D6D26864;
        Mon,  8 Mar 2021 23:07:45 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D1DC1A8A3;
        Mon,  8 Mar 2021 23:07:44 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 6/9] cifs: add a function to get a cached dir based on its dentry
Date:   Tue,  9 Mar 2021 09:07:32 +1000
Message-Id: <20210308230735.337-7-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c   | 16 ++++++++++++++++
 fs/cifs/smb2proto.h |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 81eb7f10368b..9e2e1ce915c9 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -925,6 +925,22 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
+			      struct dentry *dentry,
+			      struct cached_fid **cfid)
+{
+	mutex_lock(&tcon->crfid.fid_mutex);
+	if (tcon->crfid.dentry == dentry) {
+		cifs_dbg(FYI, "found a cached root file handle by dentry\n");
+		*cfid = &tcon->crfid;
+		kref_get(&tcon->crfid.refcount);
+		mutex_unlock(&tcon->crfid.fid_mutex);
+		return 0;
+	}
+	mutex_unlock(&tcon->crfid.fid_mutex);
+	return -ENOENT;
+}
+
 static void
 smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	      struct cifs_sb_info *cifs_sb)
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index ddbdf9923625..3b1cc27947df 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -73,6 +73,9 @@ extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			   const char *path,
 			   struct cifs_sb_info *cifs_sb,
 			   struct cached_fid **cfid);
+extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
+				     struct dentry *dentry,
+				     struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
 extern void close_cached_dir_lease(struct cached_fid *cfid);
 extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
-- 
2.13.6

