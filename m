Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD402C04AA5
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 04:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiHYElh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 00:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiHYElh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 00:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0A554C97
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661402493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pl7rtMP8qFWqBlWelKhBZJWmCG3UXH2YGws4cRmTn0o=;
        b=hfeMh1SDBOOW1fydvrNoGnJAqdqN7aWcXe09kLnSW0JZX6awvXFK4ZOviO87Jd4WlQZMPg
        729Jefgjp7z7jl84J/NwOGXfqTJUzEjSR4F4VhRQIpaOmRSWunqWQ1lO3EW2dQWysenCQu
        Tt2mjdgT2ayEwxbN1LtsfSMLPOr46zk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-G3pbdRJ_MUKhJCGtzR1uhw-1; Thu, 25 Aug 2022 00:41:29 -0400
X-MC-Unique: G3pbdRJ_MUKhJCGtzR1uhw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BB0D801231;
        Thu, 25 Aug 2022 04:41:29 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EDA2C15BB3;
        Thu, 25 Aug 2022 04:41:28 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Directory caching, v2
Date:   Thu, 25 Aug 2022 14:41:02 +1000
Message-Id: <20220825044107.3703811-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, Tom, List

Version 2 of the patches.
I have implemented Tom's suggestions for the first 5 patches and resend them.
The sixth patch, adding a lease timeout, I have dropped for now and will rework
completely using a laundtry task to recind leases instead of a using a compled delayed event.




