Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29616C4167B
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 20:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjJ3UUN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 16:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjJ3UUM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 16:20:12 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC747F7
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 13:20:10 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWkXBtgQshXyjb+A1gCmJORlvEBsTyCPFTAr86WpZ2I=;
        b=RsQRFJc+q9oZuqiBfnAYPZCewxKPWb4mzm0CP79rQv2zO6KyK12sa+O4NamIWUQn/3ijMm
        kICbOD5oC6fQyzzDGGrgsyUNxfltrwjZzB1oDhp8Vzr2Bd0nb4rk5INhrbJAVbIG+CXyLT
        fix5zS3nW1GLyRjZ6TsKPUhiN5C08UIdOu9m9S3y6V5U8UqEazEMobfJDCGzN/rV3gvqNv
        V5qpZgKM1xmq8bf491yjdvxXejh/r1lmocVZbSNCOPiTaL1u0SngoEuC3xxPlRKQwnZDHf
        YxCP1fZoKJKhlPLqeyY24EOjN+Iuo6y4n3jnUD1OqFbMmnsoYJpcC/siGGLlnw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698697209; a=rsa-sha256;
        cv=none;
        b=J0YADWLuoDTZ29NqD/JUzhB91W9lT3KFNVEjx7mVBbTQbuJtRPqBp+2CNZRI7dq9phj37b
        rNTa8KGA7//h7JI/9++wNazpdT08JxQW/WyXY+NZa2vb4OcKOCrG8UNmj/vltAX3isb9+b
        gysPRGvZ3P+MhuYzRmAwpk791HdD1dC3iDrXNE11iqVGNGDOhwaEphklnbhaACqZUfYodK
        DpsyEsa6piiEu0kzsentYcTuI2U2doySn36/dpWOqZP8iRHOMRlf/r4hLfNMIj0Pu+mN00
        pJYNQVNdfqhd6cLBuzIOPGP0CjhLh8PN+nWv58hhuIj3AeXZ5TzZnkDlneZ+Hg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWkXBtgQshXyjb+A1gCmJORlvEBsTyCPFTAr86WpZ2I=;
        b=jIi2uRhXWsC0CchYvHy+vuN/niLciSxZ4DERhX5biZ+Xg+O99L1pCt6zuhSlHnGYj7ol46
        YOTihQyYA/fYvzeDCycuk6Cty1UH+Tw0w/Nl5CkaqMx8Lk6HKMcQemnHauQ/4oWs+xQXBc
        Pegd8ij09hLvnjYeiEclM9pileoezGX/l5yFYcubCDIasb5gDEHu4by+DI8vvVfwoL5Tv3
        4Ebjo9jUuEsXwCVD1SpIxCZT4OGd8aQaU2qY+GKKrEvkBNLhWjqGk6scs3Y8Zz/SFokyQv
        VzuciGjjYP719D3qTBQLOI5TNAI4F0bqoIdL6HlAd4ThLzQ3AzNyTaNWG/KRqQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        Frank Sorenson <sorenson@redhat.com>
Subject: [PATCH 3/4] smb: client: fix potential deadlock when releasing mids
Date:   Mon, 30 Oct 2023 17:19:55 -0300
Message-ID: <20231030201956.2660-3-pc@manguebit.com>
In-Reply-To: <20231030201956.2660-1-pc@manguebit.com>
References: <20231030201956.2660-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All release_mid() callers seem to hold a reference of @mid so there is
no need to call kref_put(&mid->refcount, __release_mid) under
@server->mid_lock spinlock.  If they don't, then an use-after-free bug
would have occurred anyway.

By getting rid of such spinlock also fixes a potential deadlock as
shown below

CPU 0                                CPU 1
------------------------------------------------------------------
cifs_demultiplex_thread()            cifs_debug_data_proc_show()
 release_mid()
  spin_lock(&server->mid_lock);
                                     spin_lock(&cifs_tcp_ses_lock)
				      spin_lock(&server->mid_lock)
  __release_mid()
   smb2_find_smb_tcon()
    spin_lock(&cifs_tcp_ses_lock) *deadlock*

Cc: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsproto.h |  7 ++++++-
 fs/smb/client/smb2misc.c  |  2 +-
 fs/smb/client/transport.c | 11 +----------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 0c37eefa18a5..890ceddae07e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -81,7 +81,7 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 char *cifs_build_devname(char *nodename, const char *prepath);
 extern void delete_mid(struct mid_q_entry *mid);
-extern void release_mid(struct mid_q_entry *mid);
+void __release_mid(struct kref *refcount);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
@@ -740,4 +740,9 @@ static inline bool dfs_src_pathname_equal(const char *s1, const char *s2)
 	return true;
 }
 
+static inline void release_mid(struct mid_q_entry *mid)
+{
+	kref_put(&mid->refcount, __release_mid);
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 25f7cd6f23d6..32dfa0f7a78c 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -787,7 +787,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
 	if (!cancelled)
 		return -ENOMEM;
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 14710afdc2a3..d553b7a54621 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -76,7 +76,7 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-static void __release_mid(struct kref *refcount)
+void __release_mid(struct kref *refcount)
 {
 	struct mid_q_entry *midEntry =
 			container_of(refcount, struct mid_q_entry, refcount);
@@ -156,15 +156,6 @@ static void __release_mid(struct kref *refcount)
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-void release_mid(struct mid_q_entry *mid)
-{
-	struct TCP_Server_Info *server = mid->server;
-
-	spin_lock(&server->mid_lock);
-	kref_put(&mid->refcount, __release_mid);
-	spin_unlock(&server->mid_lock);
-}
-
 void
 delete_mid(struct mid_q_entry *mid)
 {
-- 
2.42.0

