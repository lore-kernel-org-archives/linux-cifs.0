Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2689AECAAA1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 02:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiHaCuM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 22:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiHaCuK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 22:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F4A4BA78
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 19:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661914208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EH4Qa6UBhXL5o98yfYdZ3twCys0iJhTucPUOA8UiHgM=;
        b=Pw/VlXX1l1nx8KK1BebEVcMtZag01JjRRb2uTKjBlnC2BPQYEe67C68VaknejjOxayKNL/
        lfMbFQMicRaWFV8QvkHSCLUg0N5vrEMxLQliUTUQ/vp+cJ8q/RGU/Rby/hGv/KnMSsk8hC
        a6u+VFeQiMxd7RY5Zc3Or3WWfzTCO/U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-dF8e4utMNc6i8qA821uuYw-1; Tue, 30 Aug 2022 22:50:04 -0400
X-MC-Unique: dF8e4utMNc6i8qA821uuYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36BC6101A588;
        Wed, 31 Aug 2022 02:50:04 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96E139458A;
        Wed, 31 Aug 2022 02:50:03 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: expand directory caching to handle any directory
Date:   Wed, 31 Aug 2022 12:49:41 +1000
Message-Id: <20220831024947.3917507-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List
Updated version of the patch series that adds a 6th patch with a laundromat thread
based on suggestions on the list from Tom.



