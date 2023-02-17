Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BBDC636D4
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 03:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjBQDgK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 22:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBQDgJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 22:36:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E64498BD
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 19:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676604920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rjZXrMa0WadpCuLhWIhGQOhQi11+oBz0hI2g6SreywY=;
        b=Ev3MCMIZQNuVfLJ5tJKcghGEgBJpLKcNbDnGMcQZFvXi5F+j6dWYAfEt+eG9hEb7Pl0zBh
        lN3ly3bXnja+YENFR2NTZMjSfHCtlNoPEtnGA8hbExrH4qDvDoN3MhhY9AAVZ6oNiRVOuu
        yvRA74UE04Jn8ajj/5+8DbBuPqqN2KU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-W3M9fmChOoiYeesRWCoFVg-1; Thu, 16 Feb 2023 22:35:13 -0500
X-MC-Unique: W3M9fmChOoiYeesRWCoFVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC3C9821B8C;
        Fri, 17 Feb 2023 03:35:12 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-18.bne.redhat.com [10.64.52.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A65D12166B30;
        Fri, 17 Feb 2023 03:35:11 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/2] cifs: Check the lease context if we actually got a lease
Date:   Fri, 17 Feb 2023 13:35:00 +1000
Message-Id: <20230217033501.2591185-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Some servers may return that we got a lease in rsp->OplockLevel
but then in the lease context contradict this and say we got no lease
at all.  Thus we need to check the context if we have a lease.
Additionally, IF we do not get a lease we need to make sure we close
the handle before we return an error to the caller.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 60399081046a..6672f1a0acd7 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -220,8 +220,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
-
-	atomic_inc(&tcon->num_remote_opens);
+	cfid->is_open = true;
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
@@ -238,7 +237,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			    &oparms.fid->epoch,
 			    oparms.fid->lease_key, &oplock,
 			    NULL, NULL);
-
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
+		goto oshr_free;
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_free;
@@ -261,7 +261,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	cfid->dentry = dentry;
 	cfid->tcon = tcon;
 	cfid->time = jiffies;
-	cfid->is_open = true;
 	cfid->has_lease = true;
 
 oshr_free:
@@ -281,12 +280,17 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	if (rc) {
+		if (cfid->is_open)
+			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
+				   cfid->fid.volatile_fid);
 		free_cached_dir(cfid);
 		cfid = NULL;
 	}
 
-	if (rc == 0)
+	if (rc == 0) {
 		*ret_cfid = cfid;
+		atomic_inc(&tcon->num_remote_opens);
+	}
 
 	return rc;
 }
-- 
2.35.3

