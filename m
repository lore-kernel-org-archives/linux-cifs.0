Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86172C432BE
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 10:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7010B6113C
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Aug 2021 10:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhHSKfz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Aug 2021 06:35:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236149AbhHSKfz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Aug 2021 06:35:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629369319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UchP8gm/xLwDQfqX3cEw7G7k0fAv3u7lGcwDeNa2FtI=;
        b=ZmlyZKGqyrxoukhKdeSvI6qkri2yK3CdMsHXcOafwnh8psmh3z1M7wYXVWalG0QZol3/kh
        2lDLbI09qPYj9aNhFrpLp+ztYcQhdTE30MBpIdFwH5wbOKkJMaJBcXG2hNQZMu0ma0iqLu
        x+lxvfcubEptOmCczvHS6phIxsG5Fh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-iYiVDokTPCKj5K2dblHbWA-1; Thu, 19 Aug 2021 06:35:17 -0400
X-MC-Unique: iYiVDokTPCKj5K2dblHbWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6B90190D342;
        Thu, 19 Aug 2021 10:35:16 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BB3260BF4;
        Thu, 19 Aug 2021 10:35:15 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: crypto updates
Date:   Thu, 19 Aug 2021 20:34:57 +1000
Message-Id: <20210819103459.1291412-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Steve, find two patches that replaces the previous ones.

One patch removes all authentication mechs for SMB1 that are NTLM or less secure
but leaves SMB1 with ActiveDirectory KRB5 and NTLMSSP support.

Second patch forks the ARC4 code in the kernel and creates a new kernel module
under fs/cifs_common  that contains the ARC4 crypto that cifs/ ksmbd and
also all other kernel subsystems that need ARC4 support can use.



