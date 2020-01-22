Return-Path: <SRS0=MBFb=3L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCD0C2D0CE
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 01:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E276A21835
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 01:08:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eD9AsfQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgAVBIL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jan 2020 20:08:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59956 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728609AbgAVBIL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Jan 2020 20:08:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579655290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=lQtk4n1FYAGu07BoYYhq3EIZUR4HN2CJNyee/GjPxtU=;
        b=eD9AsfQPepfJARhp3sQZ+jbLL6JSJelUFIbwbRmVAoB5CYcmOT7si8DtM7XU6pfh3Ns/WC
        6T9nUY35P55qLOTcb5nE2ljLu8HzaM8RUeiEbj5aTzCPRMWiXC8msE6WDboIH4tfa+hk1G
        k5/9MmL8LeloPsYOJN01lHPRmy/rE6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-KmprTUkUPcqxnC9dXXKCPw-1; Tue, 21 Jan 2020 20:08:05 -0500
X-MC-Unique: KmprTUkUPcqxnC9dXXKCPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC67E8010CA
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jan 2020 01:08:04 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72DB08889E;
        Wed, 22 Jan 2020 01:08:04 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix NULL dereference in match_prepath
Date:   Wed, 22 Jan 2020 11:07:56 +1000
Message-Id: <20200122010756.30245-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1760879

Fix an oops in match_prepath() by making sure that the prepath string is not
NULL before we pass it into strcmp().

This is similar to other checks we make for example in cifs_root_iget()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 05ea0e2b7e0e..0aa3623ae0e1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3709,8 +3709,10 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	bool old_set = old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
-	bool new_set = new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
+	bool old_set = (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		old->prepath;
+	bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		new->prepath;
 
 	if (old_set && new_set && !strcmp(new->prepath, old->prepath))
 		return 1;
-- 
2.13.6

