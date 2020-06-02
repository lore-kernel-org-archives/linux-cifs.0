Return-Path: <SRS0=2Ot7=7P=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC94C433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jun 2020 14:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03FCC206C3
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jun 2020 14:32:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQVBnXNb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgFBOcS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Jun 2020 10:32:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58223 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbgFBOcR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Jun 2020 10:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591108336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WND/vobCbtVfEKZMI7mkWDPAddyxpKsuDdwgIQgXPo0=;
        b=bQVBnXNb6Y+g2kCvkx7um4s29vkZHRG9+6PALI7eSTG3qDrZO+hUnynbktRw65J31bGRAD
        MIVhJLMync3P+OXg+PANxV1HW+bPAnbPpaAhEVU35UMKJFnRnctfc4P6yhpEaDI+NhrrQy
        dJj2l7+N2QBEwGGdxSpaAPTkdNaI/Bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-MZZzjh0KOESCF9bRezWPTA-1; Tue, 02 Jun 2020 10:32:14 -0400
X-MC-Unique: MZZzjh0KOESCF9bRezWPTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B4C618FF662;
        Tue,  2 Jun 2020 14:32:12 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.74.9.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 271E15C220;
        Tue,  2 Jun 2020 14:32:08 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     kdsouza@redhat.com, rbergant@redhat.com, smfrench@gmail.com
Subject: [PATCH] Print sec=<type> in /proc/mounts if not set from cmdline.
Date:   Tue,  2 Jun 2020 20:02:05 +0530
Message-Id: <20200602143205.23854-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently the end user is unaware with what sec type the
cifs share is mounted if no sec=<type> option is parsed.

Example:
$ echo 0x3 > /proc/fs/cifs/SecurityFlags

Mount a cifs share with vers=1.0, it should pick sec=ntlm.
If mount is successful we print sec=ntlm

//smb-server/data /cifs cifs rw,relatime,vers=1.0,sec=ntlm,cache=strict,username=testuser,uid=0,noforceuid,gid=0,noforcegid,addr=x.x.x.x,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=61440,wsize=16580,bsize=1048576,echo_interval=60,actimeo=1

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
---
 fs/cifs/sess.c    | 1 +
 fs/cifs/smb2pdu.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 43a88e26d26b..a5673fcab2f7 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1698,6 +1698,7 @@ static int select_sec(struct cifs_ses *ses, struct sess_data *sess_data)
 		return -ENOSYS;
 	}
 
+	ses->sectype = type;
 	return 0;
 }
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b30aa3cdd845..bce8a0137fa4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1601,6 +1601,7 @@ SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data *sess_data)
 		return -EOPNOTSUPP;
 	}
 
+	ses->sectype = type;
 	return 0;
 }
 
-- 
2.21.1

