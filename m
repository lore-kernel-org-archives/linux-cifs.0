Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBAEC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C9760C3D
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCHXIY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhCHXHx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:07:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=5krstQ0Ej+bZU1eaUHAxKsElSoV/U8pvdwM/1u8T+lA=;
        b=gAH/81X7hB4qt2ZidZt24OQM8tnaBNGp1mrwor9zFG/bcQzBGeNPBQ69L8Q+2e3y6T6qF/
        aMrxapVEXGa9AHYnHOohqplVPQa1J8X8j2URgZLwt1WpU4IUaL3jm8wcs2soL4hz1mZ0FY
        sY5SAW8CJ8Hwbp414kzpVolZ+aIzxxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-eaJINqqHOD-KnMWQB5eAVA-1; Mon, 08 Mar 2021 18:07:50 -0500
X-MC-Unique: eaJINqqHOD-KnMWQB5eAVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADDA3814313;
        Mon,  8 Mar 2021 23:07:49 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 194E060C13;
        Mon,  8 Mar 2021 23:07:48 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 7/9] cifs: add a timestamp to track when the lease of the cached dir was taken
Date:   Tue,  9 Mar 2021 09:07:33 +1000
Message-Id: <20210308230735.337-8-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and clear the timestamp when we receive a lease break.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h | 1 +
 fs/cifs/smb2misc.c | 1 +
 fs/cifs/smb2ops.c  | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7d9b47f2f04f..f6cebb36a27c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -988,6 +988,7 @@ struct cached_fid {
 	bool is_valid:1;	/* Do we have a useable root fid */
 	bool file_all_info_is_valid:1;
 	bool has_lease:1;
+	unsigned long time; /* jiffies of when lease was taken */
 	struct kref refcount;
 	struct cifs_fid *fid;
 	struct mutex fid_mutex;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 60d4bd1eae2b..e617d2975c99 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -667,6 +667,7 @@ smb2_is_valid_lease_break(char *buffer)
 				    !memcmp(rsp->LeaseKey,
 					    tcon->crfid.fid->lease_key,
 					    SMB2_LEASE_KEY_SIZE)) {
+					tcon->crfid.time = 0;
 					INIT_WORK(&tcon->crfid.lease_break,
 						  smb2_cached_lease_break);
 					queue_work(cifsiod_wq,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9e2e1ce915c9..34419b2af8e8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -912,6 +912,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				&rsp_iov[1], sizeof(struct smb2_file_all_info),
 				(char *)&tcon->crfid.file_all_info))
 		tcon->crfid.file_all_info_is_valid = true;
+	tcon->crfid.time = jiffies;
+
 
 oshr_exit:
 	mutex_unlock(&tcon->crfid.fid_mutex);
-- 
2.13.6

