Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE66ECAAD3
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 05:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiISFjX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 01:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiISFjX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 01:39:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4805B18352
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 22:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663565961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7mHlQ2IXbJ7K/KP6bAm2mOLtLXkAvHk+n2uXgfdSUZ8=;
        b=cQCR7lvrgDNQ0z9L4pggx/76MLkW00Q2JmutH5lC+zALkZY12qvmPjuJQPJxdi/U71Kwd7
        kHIDKumsavPuZjvJwwcnyv1iSffh4BmZNPle4tP1FhzShm651PMiW8Au59RnRZ5kjqJP2P
        WMv4BXGEsu5gfERgtzhhyh2Sr1/YuTQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-l23gitjiNcaG5P4Yx_0tJQ-1; Mon, 19 Sep 2022 01:39:12 -0400
X-MC-Unique: l23gitjiNcaG5P4Yx_0tJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBFCA85A59D;
        Mon, 19 Sep 2022 05:39:11 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 555121121314;
        Mon, 19 Sep 2022 05:39:11 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Improved fix for reading stale data when cache=none
Date:   Mon, 19 Sep 2022 15:39:00 +1000
Message-Id: <20220919053901.465232-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Please find a better patch to fix the data corruption issue I posted earlier
for when doing direct reads to an mmaped file after the mmaped area has changed.

The main difference is that I now destage and invalidate only the range that
is affected by the pread() and not the whole file so impact on performance should be reduced.
(that said, with cache=none there is probably no expectation of high performance in the first place )




