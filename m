Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CBEC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 06:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiCQGHV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiCQGHI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 02:07:08 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8A41B4E86
        for <linux-cifs@vger.kernel.org>; Wed, 16 Mar 2022 22:40:38 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id t33so696141ybt.12
        for <linux-cifs@vger.kernel.org>; Wed, 16 Mar 2022 22:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lKjZKbFAA5S3IK1pD/LY7di74ubeUzAeUFWQTtDet/I=;
        b=HuS/ADuHVNEumndqFxKl6C/6FtYAIp/6LpNCo1xu2Jd+qSPDMaJwGWgiyHvha8GLyQ
         3w06W9qcZ03WF5b6MEiKH4XUr++NPiIdSXGSXo89oMzLuYB/ubVGIFhU5W33sDEmeEDT
         r9RlR9gg7GY0xCUzWZxB+Y4Gpwrk90WD5B1JPlexd0fMrnkxfjmxy5Qn6CUWV/4SREVs
         K/6eg3/PdK2+g42nOgmZZYYhxlXIlJmh6i6aWKkc4Q+DjzllPxLQhq3aIiaWw9ArfWg7
         Jfm2dRU00ouAk8KecJfdWcFTLOUeaEEkfyBtb8isLqU+VZC6zBtiuUktjdKJcGGbxSbS
         ALDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKjZKbFAA5S3IK1pD/LY7di74ubeUzAeUFWQTtDet/I=;
        b=X0ejVrraa3ockprRj2F0M40z5HOW3euWaOPKaB2lRc0slbnhV+EBeNAkSTogcA2rNa
         6VuwKJpobbfHjT0ceOBX5b7nDOwOLOK88G76xR28fDDZZeHuaaN9e9gJvAKwlJMwLXeb
         dPx0Hnl6zDDrYo4EIgsSWDuHuTpaNCKKO6QndhSPfkB0L4m9dbyOeM5xPgc70GnDfx8Z
         xT5cIXHuxghVIpB/K9PKiaz6MoSqN42FHhzRZ+WGvfHmmrrgJuzcUpK0eYBvSry3Hrlr
         plLDnpce/ETv7N1ytojLgtycyiq1dTmbR4dL1/LcL5zvh2ZjAZorYi1MjlqEmMKkKe7z
         lrbA==
X-Gm-Message-State: AOAM531+IVf1Fh3c/GtiW0BkZv9SK+EehD/U0E1UcV4jZ/AR2MrBgp3T
        kFm6IH1PtW4oCalVGoiCg7YAv3u9VvqCyoNp++CFl3+A
X-Google-Smtp-Source: ABdhPJxp2fYIlW+KSSW60B01hym93FfWdEljOjg6ODu7tRVjFLtWGEK80CFtkNguovDx/fcCfrsdoO5nlvxVERuH53Y=
X-Received: by 2002:a25:c08f:0:b0:633:910d:498b with SMTP id
 c137-20020a25c08f000000b00633910d498bmr3002773ybf.531.1647488684932; Wed, 16
 Mar 2022 20:44:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
In-Reply-To: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 17 Mar 2022 13:44:33 +1000
Message-ID: <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix multiuser mount regression
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Satadru Pramanik <satadru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 17, 2022 at 1:20 PM Steve French <smfrench@gmail.com> wrote:
>
> cifssmb3: fix incorrect session setup check for multiuser mounts

If it fixes multiuser then Acked-by me.
We are so close to rc8 that we can not do intrusive changes,   so if
it fixes it short term.
For longer term, post rc8 we need to rewrite the statemaching completely
and separate out "what happens in server->tcpStatus" as one statemachine and
"what happens in server->status" as a separate one. Right now it is a mess.


>
> A recent change to how the SMB3 server (socket) and session status
> is managed regressed multiuser mounts by changing the check
> for whether session setup is needed to the socket (TCP_Server_info)
> structure instead of the session struct (cifs_ses). Add additional
> check in cifs_setup_sesion to fix this.
>
> Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/connect.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 053cb449eb16..d3020abfe404 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
> struct cifs_ses *ses,
>
>   /* only send once per connect */
>   spin_lock(&cifs_tcp_ses_lock);
> - if (server->tcpStatus != CifsNeedSessSetup) {
> + if ((server->tcpStatus != CifsNeedSessSetup) &&
> +     (ses->status == CifsGood)) {
>   spin_unlock(&cifs_tcp_ses_lock);
>   return 0;
>   }
>
> --
> Thanks,
>
> Steve
