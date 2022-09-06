Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03C3ECAAA1
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 05:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiIFFm7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Sep 2022 01:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiIFFm5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Sep 2022 01:42:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282AF5927D
        for <linux-cifs@vger.kernel.org>; Mon,  5 Sep 2022 22:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662442976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6CwZKGvzGp2WooUEJnwTJ5MbKiBATBhpjC8iOWw5e2s=;
        b=EQYGsibLu3YWMh+20TbFVrFbLS++WhxPHS3KdytviIPI4H66fraEJXPf3zkOi4VjgE5dBM
        docAXajqJrC5onZm1CQSpJqO0urvV8yV5y4ZBO+R38h1y4cIwTyvQTjqLIBRAd72hbpHIR
        G16s+bvHSbr6c/EBEIfY2BgzOITL7a8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-HnXCKp0oOiGV92olkQGPMw-1; Tue, 06 Sep 2022 01:42:53 -0400
X-MC-Unique: HnXCKp0oOiGV92olkQGPMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B797299E740;
        Tue,  6 Sep 2022 05:42:52 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0138EC15BBD;
        Tue,  6 Sep 2022 05:42:51 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: CIFS: attempt to fix kernel bugzilla 215375
Date:   Tue,  6 Sep 2022 15:42:39 +1000
Message-Id: <20220906054240.4148159-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, 
Here is an attempt to fix kernel bz 215375.
I can not test it, since I don't have access to servers this old but the change
should be safe for modern users as it only affects the password field for
"share mode" security, which we do not support anyway.

It is only tested for regressions with user mode security on win98 and later systems, using ntlmssp
authentication.



