Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F226ECAAA1
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 03:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiILDFH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiILDFG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Sep 2022 23:05:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571F611A27
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 20:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662951903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1J4MPeffydccJCqU/DPkvbCbkyH3KrDjfzjVBEJbh0c=;
        b=YMUFSeRmDA/A3puxM1KfEyKH9BFnSPE//PONvocMIQ92DbAAr62Qq/uSKjX1EgbW4cKrjl
        xIAB1/3hlmA5v0PFsmrktwFn3Lc94UhUe49Iqty+tC10fKqY39J8/w9EKERy+EsLZnC3sD
        SlgSnyc8icDEnHoreHDeqnpfdb90EhY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-uRupmXH7MdS63A5gsHRmhA-1; Sun, 11 Sep 2022 23:05:00 -0400
X-MC-Unique: uRupmXH7MdS63A5gsHRmhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8DD03C025C9;
        Mon, 12 Sep 2022 03:04:59 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F6BBC15BB3;
        Mon, 12 Sep 2022 03:04:58 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: revalidate mapping when doing direct writes
Date:   Mon, 12 Sep 2022 13:04:46 +1000
Message-Id: <20220912030446.173296-2-lsahlber@redhat.com>
In-Reply-To: <20220912030446.173296-1-lsahlber@redhat.com>
References: <20220912030446.173296-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Kernel bugzilla: 216301

When doing direct writes we need to also invalidate the mapping in case
we have a cached copy of the affected page(s) in memory or else
subsequent reads of the data might return the old/stale content
before we wrote an update to the server.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fa738adc031f..6f38b134a346 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3575,6 +3575,9 @@ static ssize_t __cifs_writev(
 
 ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct file *file = iocb->ki_filp;
+
+	cifs_revalidate_mapping(file->f_inode);
 	return __cifs_writev(iocb, from, true);
 }
 
-- 
2.35.3

