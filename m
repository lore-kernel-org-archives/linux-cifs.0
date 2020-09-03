Return-Path: <SRS0=e7mR=CM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D49C433E2
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Sep 2020 00:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB6422078E
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Sep 2020 00:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bjMSXaPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgICAC4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Sep 2020 20:02:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53614 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgICACz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Sep 2020 20:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599091374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ePGG9ltLxq+szttfEh+HdDG4CFj6Srom8mT/7BVkWBc=;
        b=bjMSXaPaBCtgLW+7N7rzFinZA62lLRSwW0Oia0I70fQNBaFmIwEff0rxOD9pHdjf4btcmK
        Hq6qaUp+yYERzwOYAnXSJ6YohM5d6XY+M5BK4V0vfBQR0bj1Cvk4ggjQon0Ne505nzlkGl
        yjSlnETc6vLmjbQWeur3U6LIJKTaLIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-PPBrixnFOH2_ZGWnaPIkJA-1; Wed, 02 Sep 2020 20:02:51 -0400
X-MC-Unique: PPBrixnFOH2_ZGWnaPIkJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 350751DE00;
        Thu,  3 Sep 2020 00:02:50 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-64.bne.redhat.com [10.64.54.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8B095C1C4;
        Thu,  3 Sep 2020 00:02:49 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix DFS mount with cifsacl/modefromsid
Date:   Thu,  3 Sep 2020 10:02:39 +1000
Message-Id: <20200903000239.31507-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1871246

If during cifs_lookup()/get_inode_info() we encounter a DFS link
and we use the cifsacl or modefromsid mount options we must suppress
any -EREMOTE errors that triggers or else we will not be able to follow
the DFS link and automount the target.

This fixes an issue with modefromsid/cifsacl where these mountoptions woul
break DFS and we would no longer be able to access the share.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3989d08396ac..1f75b25e559a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1017,6 +1017,8 @@ cifs_get_inode_info(struct inode **inode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, true,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Get mode from SID failed. rc=%d\n",
 				 __func__, rc);
@@ -1025,6 +1027,8 @@ cifs_get_inode_info(struct inode **inode,
 	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
 				 __func__, rc);
-- 
2.13.6

