Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5CEC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Feb 2022 22:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiBMWlQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Feb 2022 17:41:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiBMWlQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Feb 2022 17:41:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A56A54BD6
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 14:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644792069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZUPyyFCfE5JAjnwdqRdNVh3YxuOpGiobYEKUYF7YIHI=;
        b=iZd5Y3UCRakwWevJ658AeJ4H2LIlJchnZIavLPFkQCUYC8Bv9Z1g/lwpYTbgUvqsilmtfr
        obheUuUJviZUNhbt0SYi7sSMOmM6WT3xKPQ7cw646TO8u8NW+SvGJnjab2gXQ1vM7HquYG
        rrsQUKryBR7R/EW299ffBZ6d8TmJDcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-yxiVSuZwM1Sr9eJW5DoaXA-1; Sun, 13 Feb 2022 17:41:07 -0500
X-MC-Unique: yxiVSuZwM1Sr9eJW5DoaXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B722C1091DA2;
        Sun, 13 Feb 2022 22:41:06 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-22.bne.redhat.com [10.64.54.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34AF15DB90;
        Sun, 13 Feb 2022 22:41:05 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: 
Date:   Mon, 14 Feb 2022 08:40:51 +1000
Message-Id: <20220213224052.3387192-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List,

Here is a small patch htat fixes an issue with modefromsid where
it would strip off and remove all the ACEs that grants us access to the file.
It fixes this by restoring the "allow AuthenticatedUsers access" ACE that is stripped in

set_chmod_dacl():
                /* If it's any one of the ACE we're replacing, skip! */
                if (((compare_sids(&pntace->sid, &sid_unix_NFS_mode) == 0) ||
                                (compare_sids(&pntace->sid, pownersid) == 0) ||
                                (compare_sids(&pntace->sid, pgrpsid) == 0) ||
                                (compare_sids(&pntace->sid, &sid_everyone) == 0) ||
                                (compare_sids(&pntace->sid, &sid_authusers) == 0))) {
                        goto next_ace;
                }

This part is confusing since form many of these cases we are NOT replacing
all these ACEs but only some of them but the code unconditionally removes
all of them, contrary to what the comment suggests.

I think some of my confusion here is that afaik we don't have good documentation
of how modefromsid, and idsfromsid, are supposed to work, what the
restrictions are or the expected semantics.
We need to document both modefromsid and idsfromsid and what the expected
semantics are for when either of them or both of them are enabled.




