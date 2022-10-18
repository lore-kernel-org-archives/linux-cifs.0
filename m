Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3807C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Oct 2022 07:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJRHjc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Oct 2022 03:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJRHja (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Oct 2022 03:39:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA221E1A
        for <linux-cifs@vger.kernel.org>; Tue, 18 Oct 2022 00:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666078761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dLAwf8AOBEVEGqJtJB9OBF/uig35o/6vKVMwFCOEd7g=;
        b=Jg+9JwiRt2APq1BYJGEfIge2SaMusC9uowT8rAfHzbx8o8sBvjMYN9yoqWS3M9V97HEMaf
        PiFx0uA/aBhUUp53D4B4OawhwnWlU3aBQGG/7KEmd5bPniGMMHXhllOjzukxd56gsJPLgv
        z8jWatV/97RRlFm01SO93dWGmCeFn0M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-s6e4go-mO1id9WS4fTs7Nw-1; Tue, 18 Oct 2022 03:39:20 -0400
X-MC-Unique: s6e4go-mO1id9WS4fTs7Nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3AD0185A79C;
        Tue, 18 Oct 2022 07:39:19 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43EDF2166B41;
        Tue, 18 Oct 2022 07:39:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: drop the lease for cached directories on rmdir and rename
Date:   Tue, 18 Oct 2022 17:39:09 +1000
Message-Id: <20221018073910.1732992-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,
This fixes early failures in the git tests on the buildbot.
It was missing to drop the lease for rename and rmdir.

There are still failures in the git tests but I don't think they are related
to the directory caching. To test I have reverted all the recent dir caching 
patches from for-next but the git tests still fail.
We will need to git bisect and find what broke these tests.


