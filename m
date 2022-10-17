Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E15C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 23:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiJQXco (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 19:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJQXcj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 19:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A84872FEB
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 16:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666049546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x0TLmIKobo77ya6XYszv6n5IVPCbmBMFJ2chk7yksMs=;
        b=U3wzvQNc37igVyuv5tk/YM0Q2p+p7g0Ve5UpDuZfWYuvOVqyKhOMc9pCNfy1HJlxN64vyu
        4kvVNSJY9VgkbyINBB4iu15fmVe1EQ0gcJp5QYFotSkBLUu4K7PPAZmGbm2DxxHeuPDYHV
        anN1GbDdkWG9KXlOniBI4l9Y/oezQU0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-BKFuzLLzNnWsF9Hy4f7gUw-1; Mon, 17 Oct 2022 19:32:25 -0400
X-MC-Unique: BKFuzLLzNnWsF9Hy4f7gUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC70D86EB2D;
        Mon, 17 Oct 2022 23:32:14 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B7F5C15BA4;
        Mon, 17 Oct 2022 23:32:11 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: suppress two false positives from static analyzers
Date:   Tue, 18 Oct 2022 09:32:00 +1000
Message-Id: <20221017233201.1716316-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,
Please find a trivial patch that suppresses two false positives from
Coverity and Smash.
No need for stable for this imho.


