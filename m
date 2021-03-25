Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D625C433C1
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 05:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E26461A13
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 05:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCYFXu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 01:23:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhCYFXl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Mar 2021 01:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616649820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g3GMbwQFX5uXTJvVDMqQ2TxFbiYs3FyjMhpD4101TW0=;
        b=ZAT8jj7SwdsCRSoohjgsCZeGsvGBqcM58aHTo+eyfOiWRckJGTffbhabxXBNfy9eadag61
        H3As27ulmgx4Zd0t+eNHWWRfoWgwOnebKSWCJivitikyf5IfAetDmG0FiBX9Fc3zhBeK+6
        +hoYGUBpJ7MfvqGT974VdLK9teg/gOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-LsiDgrmVNISSaTw6i5P6iw-1; Thu, 25 Mar 2021 01:23:38 -0400
X-MC-Unique: LsiDgrmVNISSaTw6i5P6iw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D0248015D6;
        Thu, 25 Mar 2021 05:23:37 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6FAD6267A;
        Thu, 25 Mar 2021 05:23:36 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Thu, 25 Mar 2021 15:23:30 +1000
Message-Id: <20210325052330.40898-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: root <root@localhost.localdomain>

RHBZ: 1933527

We have seen read cashe surviving across close to open under
SMB1 POSIX.

Signed-off-by: root <root@localhost.localdomain>
---
 fs/cifs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 26de4329d161..042e24aad410 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -165,6 +165,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 			goto posix_open_ret;
 		}
 	} else {
+		cifs_revalidate_mapping(*pinode);
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
-- 
2.29.2

