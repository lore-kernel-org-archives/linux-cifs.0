Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C8CC54EE9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 00:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiIWA4t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 20:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiIWA4s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 20:56:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661BEB40F1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 17:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663894607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PKN+Okf5ooumExpL4BtBSHJh6GnEvoCgRCPDaBOwjbQ=;
        b=Jm6JYMfZW18sUPLdfw6Fsv1KeCqf+O9MBae6PADbAFq3DeS+00ZRq7xVfM5g07m6Gr8yIV
        7jTIJLtLdjemKewjbWPFReiB6QsyvWL6VerPNrkt20esiIEaByWLClmqsbwO60SbmPtrfr
        9DSNRHI6R9E+yij17zH7ItzYTd84JJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-TSYFR-EMNI2zoAcvfX68xw-1; Thu, 22 Sep 2022 20:56:46 -0400
X-MC-Unique: TSYFR-EMNI2zoAcvfX68xw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A786B85A5B6;
        Fri, 23 Sep 2022 00:56:45 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0288F140EBF4;
        Fri, 23 Sep 2022 00:56:44 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Updates to directory caching
Date:   Fri, 23 Sep 2022 10:56:34 +1000
Message-Id: <20220923005636.626014-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Small update to the directory caching series.
The first patch is an updated to the patch at the tip of your for-next.
The patch in for-next does not have the changes Tom suggested. So please
replace it with the patch below.

The second patch adds a timeout for the leases and a laundromat thread
to return the leases when the timeout expired.


