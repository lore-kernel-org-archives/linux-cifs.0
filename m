Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3228C636D4
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 03:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBQDgB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 22:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBQDgA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 22:36:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE104FC82
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 19:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676604913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPiYKxBk/eTmBrtPBw9LpqUvL1b6oLteYMJPr0Xh4hs=;
        b=FaK6dEEPasPhOo4FoqBYn72gask+GPCwxN+tfn59A8+43WnNyLhwWyZAF6gHtY4v/9kiix
        YOQ/LvvdvNnXLv7mBQ4F7xH4A/OqHd7mh0jHfMbgvSPFJV2UFS1gU/ewgc/2autPqdrTR4
        fEI6qxhCAW/U2np6BD15SDbVCwfO44Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-AUp9q4XnMDqzsgwlIjbxag-1; Thu, 16 Feb 2023 22:35:09 -0500
X-MC-Unique: AUp9q4XnMDqzsgwlIjbxag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A3AE2999B40;
        Fri, 17 Feb 2023 03:35:09 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-18.bne.redhat.com [10.64.52.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9592651FF;
        Fri, 17 Feb 2023 03:35:08 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/2] cifs: return a single-use cfid if we did not get a lease
Date:   Fri, 17 Feb 2023 13:35:01 +1000
Message-Id: <20230217033501.2591185-2-lsahlber@redhat.com>
In-Reply-To: <20230217033501.2591185-1-lsahlber@redhat.com>
References: <20230217033501.2591185-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If we did not get a lease we can still return a single use cfid to the caller.
The cfid will not have has_lease set and will thus not be shared with any
other concurrent users and will be freed immediately when the caller
drops the handle.

This avoids extra roundtrips for servers that do not support directory leases
where they would first fail to get a cfid with a lease and then fallback
to try a normal SMB2_open()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 6672f1a0acd7..27ae908e4903 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -14,6 +14,7 @@
 
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
+static void smb2_close_cached_fid(struct kref *ref);
 
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    const char *path,
@@ -220,6 +221,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
+	cfid->tcon = tcon;
 	cfid->is_open = true;
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
@@ -232,7 +234,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
 		goto oshr_free;
 
-
 	smb2_parse_contexts(server, o_rsp,
 			    &oparms.fid->epoch,
 			    oparms.fid->lease_key, &oplock,
@@ -259,7 +260,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 	}
 	cfid->dentry = dentry;
-	cfid->tcon = tcon;
 	cfid->time = jiffies;
 	cfid->has_lease = true;
 
@@ -270,7 +270,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	spin_lock(&cfids->cfid_list_lock);
-	if (!cfid->has_lease) {
+	if (rc && !cfid->has_lease) {
 		if (cfid->on_list) {
 			list_del(&cfid->entry);
 			cfid->on_list = false;
@@ -279,6 +279,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		rc = -ENOENT;
 	}
 	spin_unlock(&cfids->cfid_list_lock);
+	if (!rc && !cfid->has_lease) {
+		/*
+		 * We are guaranteed to have two references at this point.
+		 * One for the caller and one for a potential lease.
+		 * Release the Lease-ref so that the directory will be closed
+		 * when the caller closes the cached handle.
+		 */
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
+	}
 	if (rc) {
 		if (cfid->is_open)
 			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
@@ -339,6 +348,7 @@ smb2_close_cached_fid(struct kref *ref)
 	if (cfid->is_open) {
 		SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 			   cfid->fid.volatile_fid);
+		atomic_dec(&cfid->tcon->num_remote_opens);
 	}
 
 	free_cached_dir(cfid);
-- 
2.35.3

