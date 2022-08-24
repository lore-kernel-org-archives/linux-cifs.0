Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EB3C32796
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 00:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiHXA2S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 20:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHXA2S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 20:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5A86B65D
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 17:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661300895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aCreidWqiTeEG+WrbMnqKoknc9yhLGIZqrnlQM/VWl8=;
        b=CdviQyfXgH/HffpaH6CaLrWjzLTUjeN6xE+wqbvPywGPqjtLI2r+GmKs2lafeRVK34AlOB
        Kqxzlux4Fr0gGPggNbiB+EzaUuUtfDyIOCqtmMnGXziwDMFUQAN779dNvJsUKSrLL7jmH1
        4Jqxq75olt5HVnVHCmn//kuEld/5+jo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-txCRY0_CN7eurYy7lpSsnA-1; Tue, 23 Aug 2022 20:28:13 -0400
X-MC-Unique: txCRY0_CN7eurYy7lpSsnA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 644CB85A585;
        Wed, 24 Aug 2022 00:28:13 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8CBD492C3B;
        Wed, 24 Aug 2022 00:28:12 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Cifs: caching of arbitrary directories and attributes 
Date:   Wed, 24 Aug 2022 10:27:50 +1000
Message-Id: <20220824002756.3659568-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

Here is an updated list of the additional patches needed to expand directory caching based on leases.

The first three patches should be small and trivial. They do not change functionality, just preparing
for the fourth, big patch.
The fourth patch is the meat of the series. This is where we change from a static allocatoin to
cache only the root-directory to instead dynamically cache any (within limits) directory.
The fourth patch contains a large comment describing the strategies for locking and reference counts
for these structures to make review easier.

The fifth patch expands how we cache attributes for the entries in these directories, which is based
on holding a reference to the dentry for the directory. (so that inode.c can find it)
This patch allows SAFE caching of all attributes in these directories for a long time and will
reduce the need for the ad-hoc and unsafe "cache the attributes for some time to prioritize performance"
which we have done for a long time. This caching is based and triggered from opendir(), so it will
only apply to directories we have already scanned (and read the entries and attributes for)

The sixth patch is a patch to recind the lease after an arbitrarily long timeout.





