Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F94C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 19:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D90AA60F57
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 19:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhHMT5h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 15:57:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233752AbhHMT5h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 13 Aug 2021 15:57:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628884629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JLb6vIK1W18ySxWLR2J4lp9A9NpUCwspXGw2NEQ2z3Y=;
        b=RxHpCqEw7WRTIRYEJT9yMg0KFMOct9pzKBfW0L2eJIbIzJapZLy9hSM5ZMEm8kadFKnViZ
        3XoKG7rEx6Thbao0wFZJaHoX5aQ0aU52Wd86ro98dWSebxOoQHYdjvpbQN/W2CIqyOv91z
        EyQKtNdw8b4F4eKDvDaj/YFtWW8Qa2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-iUKDytKvO2qn3Qi_VUh99Q-1; Fri, 13 Aug 2021 15:57:08 -0400
X-MC-Unique: iUKDytKvO2qn3Qi_VUh99Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70488180FCAA;
        Fri, 13 Aug 2021 19:57:07 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9EC2189C7;
        Fri, 13 Aug 2021 19:57:06 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: only compile with DES when building with SMB1 support
Date:   Sat, 14 Aug 2021 05:56:41 +1000
Message-Id: <20210813195644.937810-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, list

These three patches moves smb1 and all functions that depend on DES
into smb1ops.c and will optionally compile smb1ops.c iff SMB1 support
is enabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY)

Additionally, make CONFIG_CIFS_ALLOW_INSECURE_LEGACY depend on
CONFIG_LIB_DES so that if the kernel is built without DES support
we automatically disable the smb1 protocol.


This allows to build a cifs module on a kernel where DES has been disabled.



