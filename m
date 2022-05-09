Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31815C43219
	for <linux-cifs@archiver.kernel.org>; Mon,  9 May 2022 23:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiEIXs2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 19:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiEIXro (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 19:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA31826FA57
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 16:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652139755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NmCwGT/Vdls1bGsADt4fWNjUaaGJ7fe9iuKRbYQXlxs=;
        b=A94u1RMejeOlW+D1gwQjgo7n+Y9I+shK8keHJiQJsT+Q7IVvFw430ZQJlrbvmH5uB0mkPG
        C2IDrcZmIeL4Fmc6dFCTE/dyC6k56G/P3S6Td+iUQ/y7iJ7ahQsiA6mfcKnpXOg+t4SEK8
        ZaN9EItwW+mr3qmIW0stpFyQRe7Da84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-ommzgQyrORe8Raoxer0bEw-1; Mon, 09 May 2022 19:42:31 -0400
X-MC-Unique: ommzgQyrORe8Raoxer0bEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D42B101AA42;
        Mon,  9 May 2022 23:42:31 +0000 (UTC)
Received: from thinkpad (vpn2-54-168.bne.redhat.com [10.64.54.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8618B2166B2F;
        Mon,  9 May 2022 23:42:30 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Cifs: cache entries for the cached directory
Date:   Tue, 10 May 2022 09:42:03 +1000
Message-Id: <20220509234207.2469586-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Updated version of the patch to add caching of directory entries for the cached
dir.
I have updated with all the suggestions from Enzo and Paulo.
In this patch, once you have done the initial 'ls /mnt' and future 
listings of the root of the share will be served straight out of cache
until the lease is broken.
The first three patches are small and isolated for easy review
and the fourth patch is what actually adds the caching of entries.

These functions are now at a stage that we should be able to start looking at
replacing the "single cached direcotry" that is linked to the tcon
to be a list of <=n most recent directories we have accessed.
Thus expanding it to cache a lot more directories than just the root.
But that will come later once this is stabilized and road-tested.
At least I think with these all changes it should be fairly easy to expand
the use to more directories.


