Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF88ECAAA1
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 03:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiISDiG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Sep 2022 23:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiISDiC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Sep 2022 23:38:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B7314D2F
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 20:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663558680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=edLQ7tpCGHyPaeHFUyZITLq1lBjmvdHQMBIbGbrimJs=;
        b=IsU2CYqGc0NoT635WqfLeFWHT8A+GaS8S4Xi51ohSrbRJ9s3QJhfBZfcfWo9qrga8MMan2
        yB2tBawxshDrH48meTSIHSYmcgZKpsXOxloFzpS/tE8kyINqYqlLDctIafWUpqRTWcBWum
        FcNk4Pssn6UTJpx+FkRnsIkRfmZwPu4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-xwI7GZDsNzmQk5FRpfr-BQ-1; Sun, 18 Sep 2022 23:37:56 -0400
X-MC-Unique: xwI7GZDsNzmQk5FRpfr-BQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BEAF185A79C;
        Mon, 19 Sep 2022 03:37:56 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDF31492B04;
        Mon, 19 Sep 2022 03:37:55 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: invalidate and destage pages before re-reading them for cache=none
Date:   Mon, 19 Sep 2022 13:37:47 +1000
Message-Id: <20220919033747.461583-2-lsahlber@redhat.com>
In-Reply-To: <20220919033747.461583-1-lsahlber@redhat.com>
References: <20220919033747.461583-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is the opposite case of kernel bugzilla 216301.
If we mmap a file using cache=none and then proceed to update the mmapped
area these updates are not reflected in a later pread() of that part of the
file.
To fix this we must invalidate the mapping, forcing the changed pages to be
destaged to the server before we allow the pread() to proceed.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6f38b134a346..31ceef22ffe4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4314,6 +4314,9 @@ static ssize_t __cifs_readv(
 
 ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to)
 {
+	struct file *file = iocb->ki_filp;
+
+	cifs_revalidate_mapping(file->f_inode);
 	return __cifs_readv(iocb, to, true);
 }
 
-- 
2.35.3

