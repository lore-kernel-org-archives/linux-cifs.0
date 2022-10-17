Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FECC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 23:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiJQXcs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 19:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiJQXcm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 19:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90C0857EB
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 16:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666049550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAZ/Alo4EFRcF9pyoNAQ78il2NQYsqj1HgOXSDec3EQ=;
        b=MXPb83bGij7c/J/0kV/nvoID8GcCvaT/uylwpl9yGVofzVIf3oesegB+bemC42iya/CuPR
        pj1wgzqSQ+z5moROke5Ev329on+elGlTn2AuMWLiCf8WEz3jA80LsTUT07UgeMks2cZEp3
        6Kyp8rtZktMha+KrO1FIz9p7u965YzA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-sqTPjUqiMZCmASke8S-Z6A-1; Mon, 17 Oct 2022 19:32:26 -0400
X-MC-Unique: sqTPjUqiMZCmASke8S-Z6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CC683C0D196;
        Mon, 17 Oct 2022 23:32:21 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A3B9200BC58;
        Mon, 17 Oct 2022 23:32:17 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Dan carpenter <dan.carpenter@oracle.com>,
        coverity-bot <keescook+coverity-bot@chromium.org>
Subject: [PATCH] cifs: set rc to -ENOENT if we can not get a dentry for the cached dir
Date:   Tue, 18 Oct 2022 09:32:01 +1000
Message-Id: <20221017233201.1716316-2-lsahlber@redhat.com>
In-Reply-To: <20221017233201.1716316-1-lsahlber@redhat.com>
References: <20221017233201.1716316-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We already set rc to this return code further down in the function but
we can set it earlier in order to suppress a smash warning.

Also fix a false positive for Coverity. The reason this is a false positive is
that this happens during umount after all files and directories have been closed
but mosetting on ->on_list to suppress the warning.

Reported-by: Dan carpenter <dan.carpenter@oracle.com>
Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1525256 ("Concurrent data access violations")
Fixes: a350d6e73f5e ("cifs: enable caching of directories for which a lease is held")
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index fe88b67c863f..ffc924296e59 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -253,8 +253,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		dentry = dget(cifs_sb->root);
 	else {
 		dentry = path_to_dentry(cifs_sb, path);
-		if (IS_ERR(dentry))
+		if (IS_ERR(dentry)) {
+			rc = -ENOENT;
 			goto oshr_free;
+		}
 	}
 	cfid->dentry = dentry;
 	cfid->tcon = tcon;
@@ -387,13 +389,13 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		list_add(&cfid->entry, &entry);
 		cfids->num_entries--;
 		cfid->is_open = false;
+		cfid->on_list = false;
 		/* To prevent race with smb2_cached_lease_break() */
 		kref_get(&cfid->refcount);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		cfid->on_list = false;
 		list_del(&cfid->entry);
 		cancel_work_sync(&cfid->lease_break);
 		if (cfid->has_lease) {
-- 
2.35.3

