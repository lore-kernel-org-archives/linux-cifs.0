Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1868C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 22:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B169B61051
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 22:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhIFWsR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 18:48:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhIFWsQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 18:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630968431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CP0BjoGYSSpPWDMdkSQHBens//x0CvSnqlxi7UYQMvI=;
        b=dLJJK8RLBp8JWJbt2ncUWgJ87UzgSyWg/QHe5HzgNRoPn9Tv5U3x5FR4pbzBUJNuoZ6JQx
        iCCCiWCUY3MvOEQRbU9Z/1DOH8qr4rjFHZWe7HSvzfQO/AtBoZ3QNycER/ojfJ5gAgNlkN
        0WaUnBr/p/fBCVoPWR19JEgycXarnKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-PE7j6M9CMjm52VrjT0k7OQ-1; Mon, 06 Sep 2021 18:47:09 -0400
X-MC-Unique: PE7j6M9CMjm52VrjT0k7OQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0525C835DE0;
        Mon,  6 Sep 2021 22:47:09 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E2D460657;
        Mon,  6 Sep 2021 22:47:08 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/4] Start moving common cifs/ksmbd definitions into a common directory
Date:   Tue,  7 Sep 2021 08:46:44 +1000
Message-Id: <20210906224648.2062040-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Namjae,

Here is a start of work to share common definitions between the cifs client and the server.
The patches build ontop of Namjaes patch to rework the smb2_hdr structure
that he recently sent to the list.

It creates a new shared smb2pdu.h file and starts moving definitions over.
The two copies of smb2pdu.h, in cifs/ and ksmbd/ have diverged a bit
so some things are being renamed in these patches.
NegotiateProtocol is in two separate patches since for this funciton the
changes are a little more than just renames, for example I change several
arrays at the tail of structures from [number] to simply []
so that needs careful review.

Two patches are for cifs and cifs_common and two patches are for ksmbd.
The ksmbd patches depend on the cifs patches so the cifs patches have to go in first.


