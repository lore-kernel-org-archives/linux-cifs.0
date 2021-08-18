Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE49BC4320A
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 04:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B569261051
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 04:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhHRELM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 00:11:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229449AbhHRELL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 00:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629259837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+TrIREaDZVESBxlXP/bXI4ogvUI9xdhcpK1/pkbCUzU=;
        b=Z7H0YKtdQ4oQp8VJUWw2obEMPwIcKIQVLQeaWYZ6IdtDTf79JD55pZQB2YqlXOmDjv3wIE
        kENyMSoPKoftFOhZk3IVm9+c/M32jZBParEL83iCC2sBfqPR/VjUFBtfUqG5Db/eE/yIy0
        vDlnEQ3/AVwCDVQzPlp8oG5YKYyTkyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-Nbht_rIRNwWPvRaWAcmcYw-1; Wed, 18 Aug 2021 00:10:35 -0400
X-MC-Unique: Nbht_rIRNwWPvRaWAcmcYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D19A871807;
        Wed, 18 Aug 2021 04:10:34 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84ACF5DA60;
        Wed, 18 Aug 2021 04:10:33 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Disable key exchange if ARC4 is not available
Date:   Wed, 18 Aug 2021 14:10:20 +1000
Message-Id: <20210818041021.1210797-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

We depend on ARC4 for generating the encrypted session key in key exchange.
This patch disables the key exchange/encrypted session key for ntlmssp
IF the kernel does not have any ARC4 support.

This allows to build the cifs module even if ARC4 has been removed
though with a weaker type of NTLMSSP support.



