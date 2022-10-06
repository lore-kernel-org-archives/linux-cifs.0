Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29413C433FE
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Oct 2022 04:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJFEgj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Oct 2022 00:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJFEgY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Oct 2022 00:36:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5209A5EDD7
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 21:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665030982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R9R6ASv6sqk9sjuUYogCkHZDH3o7e4l0KyET3EkiWGs=;
        b=h2DbuAUQwdrDs//2jNBgOdaZ9fTOU7maDEUzLdKXrVKf0YCO3zwJUNRGN1cz+XX9oaSvwN
        z/vk1B2oubRxzsNBemnyMGw6XkXyxoiFkf32JltX0UyNc/CVP76+t/X5BTlP/ByqeBbiXf
        ANTGKrwcz4aAM3D40sL/a/wyqtF7jEI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-wJ62z8dfMcqMI1_8A5Pi8Q-1; Thu, 06 Oct 2022 00:36:18 -0400
X-MC-Unique: wJ62z8dfMcqMI1_8A5Pi8Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4164A29DD9B8;
        Thu,  6 Oct 2022 04:36:18 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9DB6492B05;
        Thu,  6 Oct 2022 04:36:17 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: cifs: fix failure for generic/257
Date:   Thu,  6 Oct 2022 14:36:08 +1000
Message-Id: <20221006043609.1193398-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List,

Please find attached a small patch that fixes when/where we start emitting dirents
to the application AFTER it has performed a lseek() to a different offset.
Not sure if applications should assume that the offset where a specific inode value can be
found at being stable, we need this fix anyway to address generic/257

With this patch you can also apply patch4 from the cached directory series
and generic/257 will still pass.
 


