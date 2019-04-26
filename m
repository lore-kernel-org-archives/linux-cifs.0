Return-Path: <SRS0=UR+C=S4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E2BC43219
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 00:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65587206C1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 00:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfDZAdk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Apr 2019 20:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbfDZAdj (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Apr 2019 20:33:39 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D545D1219D5;
        Fri, 26 Apr 2019 00:33:39 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-54.bne.redhat.com [10.64.54.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F6561001E6C;
        Fri, 26 Apr 2019 00:33:39 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 0/1] cifs: fix credits leak for SMB1 oplock breaks
Date:   Fri, 26 Apr 2019 10:32:22 +1000
Message-Id: <20190426003223.4763-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 26 Apr 2019 00:33:39 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel, List

Here is an update after the email discussions.
This is minimal patch that adds a new flag to specifically indicate
that there will not be a response to this PDU and thus we can immediately
add the credits back after sending in compound_send_recv()
This flag is only set for SMB1 oplock breaks so this will not affect anything
else.

Additionally, we no longer need to check the CIFS_ASYNC_OP flag in
compound_send_recv() so we can remove that conditional.

This is the smallest patch which fixes the actual smb1 oplock bug thus we should
be able to get it into an rc, and stable.
But we need more but that should wait until the next merge window.


The next steps we should do is:
Remove CIFSSMBNotify() completely and with that also the check for
CIFS_ASYNC_OP in SendReceive()

When that is done, the only thing that CIFS_ASYNC_OP does is make sure
we do not block in wait_for_credits().
Which means we could rename this flag to CIFS_NON_BLOCKING.

We should also rename CIFS_NO_RSP to CIFS_NO_RSP_BUF to make it more clear that
there will be a response status code but there won't be any or we don't care about any response buffer.


Thus the semantics will become:
* cifs_call_async() : if you want async handling of responses
* CIFS_NO_SRV_RSP: There won't be a response so do not wait for a reply. (only used by SMB1 oplocks)
* CIFS_ASYNC_OP/CIFS_NON_BLOCKING: do not block waiting for available credits.

