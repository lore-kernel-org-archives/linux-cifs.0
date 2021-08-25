Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8ECDC4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 07:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87F696023B
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 07:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhHYHbn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Aug 2021 03:31:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238533AbhHYHbm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 25 Aug 2021 03:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629876656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h8qexNopxzMlFLwK6zu47pL21IQnbMVtcOGAfm7S9IY=;
        b=A3l03jN8pFvk+zugtf8pAO4JjL2AxPjkZhyl7DQHqyoe5yicgA4xaWg58W8ih4aj1ZcwbC
        u27QG1XNb0SYdk7L4AfrEo7Ku2aumiyje8ixyWVLELUSVIyLfcg3QH9iGJtitMC/aJJym1
        UBgiTC9xYxJFIRCNvuWsgM/KcxRxYJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-kbTFcZ9tMSy9xWltZoYPFA-1; Wed, 25 Aug 2021 03:30:54 -0400
X-MC-Unique: kbTFcZ9tMSy9xWltZoYPFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E24B318C8C04;
        Wed, 25 Aug 2021 07:30:53 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC6625C1D5;
        Wed, 25 Aug 2021 07:30:52 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/1] cifs: do not leak EDEADLK to dgetents64
Date:   Wed, 25 Aug 2021 17:30:42 +1000
Message-Id: <20210825073043.1630555-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Please find a patch that stops us from leaking EDEADLK (not enough credits)
to userspace when we do not have enough credits due to a pending reconnect.
This can be triggered for example if the server responds with
STATUS_USER_SESSION_DELETED during the Create part of the Create/QueryDir
that starts a directory scan.


Easiest way to reproduce this is patching up scrambla to inject this error
every 3 directory scans:
diff --git a/server/server.py b/server/server.py
index 7fd113b..47d0b7f 100644
--- a/server/server.py
+++ b/server/server.py
@@ -26,6 +26,7 @@ from smb2.filesystem_info import *
 from smb2.dir_info import *
 from smb2.ntlmssp import *
 
+
 class File(object):
 
     def __init__(self, path, flags, at, **kwargs):
@@ -81,6 +82,7 @@ class Server(object):
     dialect = 0
     
     def __init__(self, s, **kwargs):
+        self.errc = 0
         self._s = s
         self._sesid = 1
         self._treeid = 1
@@ -348,6 +350,16 @@ class Server(object):
         #
         # Create/Open
         #
+        #print('PDU', pdu)
+        if pdu['desired_access'] == 0x81:
+            print('YEAH')
+            self.errc = self.errc + 1
+            if self.errc == 3:
+                print('Generate error')
+                self.errc = 0
+                self._compound_error = Status.INVALID_PARAMETER
+                return (Status.USER_SESSION_DELETED,
+                        ErrorResponse.encode({'error_data' : bytes(1)}))
         if not hdr['tree_id'] in self.trees:
             self._compound_error = Status.INVALID_PARAMETER
             return (self._compound_error,




