Return-Path: <SRS0=fkjb=YJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B63EFA3728
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 20:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2301021848
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 20:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="qFIs8dpv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394733AbfJPUwP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Oct 2019 16:52:15 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58588 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394732AbfJPUwP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Oct 2019 16:52:15 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id BF51D20B7116; Wed, 16 Oct 2019 13:52:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BF51D20B7116
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259134;
        bh=Rtb+2kdRn8perdldTeE4yqY1kvTunTWHiFSixuBZlIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=qFIs8dpv54C9das6jYmoorkcU1WOfWMzyE/TM3h00P4otkQow6ti1I5WBN1DrUC8v
         wc6Tp40NyAoe/4bzDAjpGC+eW4V3heFmgQxPmx8UyLi2mCvnGsbXMEhxLbL8v2/K9l
         kPGS38PPSFtcPD5j83wFEL+Scqy6legGkoxmblUc=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 1/7] cifs: Don't display RDMA transport on reconnect
Date:   Wed, 16 Oct 2019 13:51:50 -0700
Message-Id: <1571259116-102015-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

On reconnect, the transport data structure is NULL and its information is not
available.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/cifs_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 0b4eee3bed66..efb2928ff6c8 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -256,6 +256,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		if (!server->rdma)
 			goto skip_rdma;
 
+		if (!server->smbd_conn) {
+			seq_printf(m, "\nSMBDirect transport not available");
+			goto skip_rdma;
+		}
+
 		seq_printf(m, "\nSMBDirect (in hex) protocol version: %x "
 			"transport status: %x",
 			server->smbd_conn->protocol,
-- 
2.17.1

