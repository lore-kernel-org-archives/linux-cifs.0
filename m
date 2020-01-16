Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C2EC33CAF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 18:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26FEB2073A
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 18:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198928;
	bh=hhbWhpvF5ZdlE2pCnvgPQ4xz2p9KSvhc5E7USna33YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Yb5kPt5JPZxU1xHlbfy1xENOVfbj7McjL8LQYMsYIUgGI8sai8B94ZmkD4KeI0ywt
	 fOP2T7PMu7sP+hyqxCdzL0ee6We++WL4j8+wnQFu0wdRtFxYORkl37Kt6lmSzNk7LI
	 JIOmLUpvFYuSIj9DyMR9w7+o0kpd2/jUUVjP7tLY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgAPSWG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392485AbgAPR1j (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F220246C9;
        Thu, 16 Jan 2020 17:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195659;
        bh=hhbWhpvF5ZdlE2pCnvgPQ4xz2p9KSvhc5E7USna33YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZIEmDGhtzTAJ7ffvybQKGi0zKT0Py5KIsdKWSIEOYKepvAvydMRiln5LYr1v1VPW
         8/UpAwjJvHxZ9+VgoId9bE63eNbvIuuNR/2Kg81+yZjZD3UvlPQuJcYJPXNKQFbBXq
         fWP/auHeSAMuZTiEFzVHqdvAKpcsMmXwhZL/UegM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        Steve French <smfrench@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 219/371] signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig
Date:   Thu, 16 Jan 2020 12:21:31 -0500
Message-Id: <20200116172403.18149-162-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 72abe3bcf0911d69b46c1e8bdb5612675e0ac42c ]

The locking in force_sig_info is not prepared to deal with a task that
exits or execs (as sighand may change).  The is not a locking problem
in force_sig as force_sig is only built to handle synchronous
exceptions.

Further the function force_sig_info changes the signal state if the
signal is ignored, or blocked or if SIGNAL_UNKILLABLE will prevent the
delivery of the signal.  The signal SIGKILL can not be ignored and can
not be blocked and SIGNAL_UNKILLABLE won't prevent it from being
delivered.

So using force_sig rather than send_sig for SIGKILL is confusing
and pointless.

Because it won't impact the sending of the signal and and because
using force_sig is wrong, replace force_sig with send_sig.

Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Jeff Layton <jlayton@primarydata.com>
Cc: Steve French <smfrench@gmail.com>
Fixes: a5c3e1c725af ("Revert "cifs: No need to send SIGKILL to demux_thread during umount"")
Fixes: e7ddee9037e7 ("cifs: disable sharing session and tcon and add new TCP sharing code")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f523a9ca9574..51bbb1c0b71a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2320,7 +2320,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
-		force_sig(SIGKILL, task);
+		send_sig(SIGKILL, task, 1);
 }
 
 static struct TCP_Server_Info *
-- 
2.20.1

