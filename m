Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43721C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Oct 2022 20:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJJUnH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Oct 2022 16:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJJUnF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Oct 2022 16:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CA41B7B9
        for <linux-cifs@vger.kernel.org>; Mon, 10 Oct 2022 13:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665434583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DAoavaPmaQs9SfD0/dAZK6SHmHZg5n+7ojuvIa2tyJs=;
        b=KaRG6nGrs+Q+sCHqkxrDA+2nb0voEaRfVEWRoPdUVspa9mPZFrA07DcTAMVL9MxWWjzlLS
        /5WQMTXrD3C1FeL1gTHLlccIg8AsJ1ZAme8wSqvBzpxGOMNpE/oSjQjKkz6iNEPtVF2lIv
        /Yd88h2RHLkpqYHLwfKTsk/vJL8raUg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-EaPsNbs6PZSlCRHNlnDbPA-1; Mon, 10 Oct 2022 16:43:02 -0400
X-MC-Unique: EaPsNbs6PZSlCRHNlnDbPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 209E23C10223;
        Mon, 10 Oct 2022 20:43:02 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 733222084845;
        Mon, 10 Oct 2022 20:43:01 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: fix bug when skipping one entry too many after lseek()
Date:   Tue, 11 Oct 2022 06:42:49 +1000
Message-Id: <20221010204250.1411858-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Please see an updated patch for the issue when skipping one entry too many
after an lseek() on a direcotry and reading out of cache.
This now makes this patch plus patch4 pass generic/257.

It also introduces a trivial change to readir to avoid creating holes in the
ctx->pos sequence.   We either need to handle holes in this sequence
or we can just avoid creating holes in the first place (which this patch does)



