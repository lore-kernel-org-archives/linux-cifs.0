Return-Path: <SRS0=zjVJ=VV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AA8C7618B
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Jul 2019 04:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE1CC227BF
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Jul 2019 04:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfGXEqM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Jul 2019 00:46:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50058 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfGXEqM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Jul 2019 00:46:12 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hq692-0004Q6-CE; Tue, 23 Jul 2019 19:32:40 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hq691-0003ye-Le; Tue, 23 Jul 2019 19:32:40 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
        <20190715134655.4076-39-sashal@kernel.org>
        <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
        <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com>
Date:   Tue, 23 Jul 2019 20:32:33 -0500
In-Reply-To: <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com>
        (Steve French's message of "Tue, 23 Jul 2019 19:29:10 -0500")
Message-ID: <87v9vs43pq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hq691-0003ye-Le;;;mid=<87v9vs43pq.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19WPNvkH+gWSBLcyA8Qu0HmQ+IFY+GAvQc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH AUTOSEL 5.2 039/249] signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Very easy to see what caused the regression with this global change:
>
> mount (which launches "cifsd" thread to read the socket)
> umount (which kills the "cifsd" thread)
> rmmod   (rmmod now fails since "cifsd" thread is still active)
>
> mount launches a thread to read from the socket ("cifsd")
> umount is supposed to kill that thread (but with the patch
> "signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of
> force_sig" that no longer works).  So the regression is that after
> unmount you still see the "cifsd" thread, and the reason that cifsd
> thread is still around is that that patch no longer force kills the
> process (see line 2652 of fs/cifs/connect.c) which regresses module
> removal.
>
> -               force_sig(SIGKILL, task);
> +               send_sig(SIGKILL, task, 1);
>
> The comment in the changeset indicates "The signal SIGKILL can not be
> ignored" but obviously it can be ignored - at least on 5.3-rc1 it is
> being ignored.
>
> If send_sig(SIGKILL ...) doesn't work and if force_sig(SIGKILL, task)
> is removed and no longer possible - how do we kill a helper process
> ...

I think I see what is happening.  It looks like as well as misuinsg
force_sig, cifs is also violating the invariant that keeps SIGKILL out
of the blocked signal set.

For that force_sig will act differently.  I did not consider it because
that is never supposed to happen.

Can someone test this code below and confirm the issue goes away?

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5d6d44bfe10a..2a782ebc7b65 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -347,6 +347,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	 */
 
 	sigfillset(&mask);
+	sigdelset(&mask, SIGKILL);
 	sigprocmask(SIG_BLOCK, &mask, &oldmask);
 
 	/* Generate a rfc1002 marker for SMB2+ */


Eric
