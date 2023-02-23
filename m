Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF3AC6379F
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Feb 2023 08:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjBWIRG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Feb 2023 03:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjBWIRB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Feb 2023 03:17:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFD74DE13
        for <linux-cifs@vger.kernel.org>; Thu, 23 Feb 2023 00:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677140149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N+RF2+RPgUggwhI+a1oS5LZoLf2bDJ0WzpxSX5IdQfc=;
        b=C+kFnYdYTTEUhv+cfuks1441Bbnr/uUL6NOd43Dkl6sF7zeXRDaIA0NNFnN3a6+Oax4vx/
        /AT/alrSq1MAKr0cknMrQw8JU4wX7Nv4IZsGM1ESPf9cQr49txq9JQg0ueD30nLMI89DDY
        aREdqXNLRrNj7iV+XKe0aoNoAIpsP9A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-D9tfDm8sPjCnsBnBURMyYQ-1; Thu, 23 Feb 2023 03:15:43 -0500
X-MC-Unique: D9tfDm8sPjCnsBnBURMyYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33A85299E740;
        Thu, 23 Feb 2023 08:15:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAA2140168B5;
        Thu, 23 Feb 2023 08:15:41 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] smb3: Miscellaneous fixes
Date:   Thu, 23 Feb 2023 08:15:37 +0000
Message-Id: <20230223081539.970487-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Here are a couple of fix patches for you.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-cifs

David

David Howells (2):
  cifs: Add some missing xas_retry() calls
  cifs: Fix an uninitialised variable

 fs/cifs/file.c      | 6 ++++++
 fs/cifs/smbdirect.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

