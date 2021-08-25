Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032D9C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 11:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10EE6108E
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 11:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhHYLR4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Aug 2021 07:17:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236038AbhHYLRz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 25 Aug 2021 07:17:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629890229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mvNPNxzdkccQGP4FYiqKBr/e2eaAkaMPc/c6oChOtzA=;
        b=Z5MAmyo0kCD8UrAK+PYoY/AWnmxbgQ0rRJHjaKBWLha++RoMzUHg1S6e61VC3YFPHzn+kG
        6b9HLn3uizejxx4BB/aBfmZMZ9LSdRldZQXGkapCrHUmN+nwpF4MvYZC8LFPbhSiONl9oR
        mK09aV73R6sHNo4+/mmk0EWwSZ/rHtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-0FD2StPuMIi7C5vd5TUX4A-1; Wed, 25 Aug 2021 07:17:07 -0400
X-MC-Unique: 0FD2StPuMIi7C5vd5TUX4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F95018C8C22;
        Wed, 25 Aug 2021 11:17:07 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4486A10372E3;
        Wed, 25 Aug 2021 11:17:05 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 0/1] don't leak EDEADLK to userspace
Date:   Wed, 25 Aug 2021 21:16:55 +1000
Message-Id: <20210825111656.1635954-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Steve,

Version 2:
refactor the patch so we catch all (both) places where we call
initiate_cifs_search() and update the commit message


