Return-Path: <SRS0=5FUd=AH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E555BC433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9225520720
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="gGm9cfbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgFZUCy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jun 2020 16:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgFZUCy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jun 2020 16:02:54 -0400
X-Greylist: delayed 256 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Jun 2020 13:02:54 PDT
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A269C03E979
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2020 13:02:54 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id BCE38820E;
        Fri, 26 Jun 2020 13:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593201773; bh=SXaWRjA9S4aTRWLr5O+bEuLpkZLXs5TnqnU/uZO+nJw=;
        h=From:To:Cc:Subject:Date:From;
        b=gGm9cfbJZTR18Tf6/883XgzrSloxNwBRP8hii1jNodgofAl2HoSJODo/5Il99kwb2
         BDsYEhLvLcdOw0OIZRu/RWEVUj6mMcEVPp+Ba1Rp/AzWoys6hQ/Yz5BElgexEOj8mr
         MTTZp/dWqnEGgX1Sp5owuEfnBQJzPHkQkJjnmK+ifr0lBnSHErL3LK1WH/oI4YiIIo
         tGqDoz2EQcVEj3lYoh/Dn4DIPD2YgEOhSESRVjMDplinal3wLK3oEVYCH3iYF+296O
         hO9yg4UD6CytSXphODnTbSpm+euZdaiUPHNpISVLwOklYe+LToh8DrsZqWthdk9VxZ
         5Avl52AzZqyhA==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org, Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: Fix leak when handling lease break for cached root fid
Date:   Fri, 26 Jun 2020 13:02:48 -0700
Message-Id: <20200626200248.431426-1-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As observed with kmemleak:

    unreferenced object 0xffff98383a5af480 (size 128):
      comm "cifsd", pid 684, jiffies 4294936606 (age 534.868s)
      hex dump (first 32 bytes):
        c0 ff ff ff 1f 00 00 00 88 f4 5a 3a 38 98 ff ff  ..........Z:8...
        88 f4 5a 3a 38 98 ff ff 80 88 d6 8a ff ff ff ff  ..Z:8...........
      backtrace:
        [<0000000068957336>] smb2_is_valid_oplock_break+0x1fa/0x8c0
        [<0000000073b70b9e>] cifs_demultiplex_thread+0x73d/0xcc0
        [<00000000905fa372>] kthread+0x11c/0x150
        [<0000000079378e4e>] ret_from_fork+0x22/0x30

Fixes: a93864d93977 ("cifs: add lease tracking to the cached root fid")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org> # v4.18+
---
 fs/cifs/smb2misc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 6a39451973f8..17684b25eb21 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -619,6 +619,7 @@ smb2_is_valid_lease_break(char *buffer)
 					queue_work(cifsiod_wq,
 						   &tcon->crfid.lease_break);
 					spin_unlock(&cifs_tcp_ses_lock);
+					kfree(lw);
 					return true;
 				}
 			}
-- 
2.27.0

