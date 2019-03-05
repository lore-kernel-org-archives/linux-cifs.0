Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C85C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8C4B20663
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arq+HzAa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfCEXyH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 18:54:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33525 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728315AbfCEXyH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 18:54:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id z7so9204857lji.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 15:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=5wum17aordlpUtp6UVNEy6DcJtEfg6juoLBzBi9akCY=;
        b=arq+HzAafhNBMjDu2X6TVDW/loZHVsnP/bzEHgCIXX9hedvkaBSxcUCQI3PCpWYLZJ
         hdm6gvwpcF/c+nJYOt9rNMMuxx3iYMzCBfV3huxH3tNg2A7ap5EZ9KTMx6JSqmLtieEh
         I+UPRafo77xMboUO7i4VH/XyMCtBEtbO4L09funrs5MUL4AHvjo7hGu3lQm5L9Yc+XqK
         LLSPnrB26LLzkFGKAl2VhfFb0RJNwcTgWn7psdbR+1AC466qFsX+TOhERd7XWsIOy1yY
         TApLp+aFvb5ayWirTk3VU3SlC1dojtZYXloFVgZY2b+Y0N6lcgJNW/qw4vhyjnwMdcWh
         OfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=5wum17aordlpUtp6UVNEy6DcJtEfg6juoLBzBi9akCY=;
        b=mGrvN2Xfr+gbhJDTGCxXvvLa0up/fKwVXzGJ/Wi/wOA24Qef03eQME+zxizUH/Uvla
         jcjz5uuLXWxOXaUETyao+wFtVEa9k+xjPKikzIJJR37fy2Y+EvmrVYenEXsGNVTiLaQ6
         Map+u6H/H6nH8S9Xgi14QBSlkC7mjqGWdAd1zx7tle45/uawAsmTHoawEEVvvLCzsg1z
         R/Oge9yg0IXjmxivBmG3sFNDikUqfAhun2pqFnAiXj/R/W3hrWEsWMbA8ETVVG/C0ekF
         e+sE/jFR4cU4mI/fK9QBh0Jj1T8opcSB7Ei46Y1flDQpjgr96RCJcusjW7UyoypVYIkh
         VonQ==
X-Gm-Message-State: APjAAAVPwKQT4yAZVHgJQkGjcTr2TtAOMV7vIc+vSImO7iIcQN3ECLjg
        K/6/a/M+lDhcH9RZ1AssFjWO8MIzfXoniqvvab1be5Y=
X-Google-Smtp-Source: APXvYqzJD68bHcM7LsfioBBtA2TGBlJITNl8oIfbpm3z/iJqUTDehnC7Nb2EiuL0cnS/UIKqJhJ3tOMsy2DHpHvxMsA=
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr704659ljj.30.1551830043953;
 Tue, 05 Mar 2019 15:54:03 -0800 (PST)
MIME-Version: 1.0
References: <1549051452-5968-1-git-send-email-pshilov@microsoft.com> <1549051452-5968-12-git-send-email-pshilov@microsoft.com>
In-Reply-To: <1549051452-5968-12-git-send-email-pshilov@microsoft.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 5 Mar 2019 15:53:52 -0800
Message-ID: <CAKywueQ7NeSRHOmRRhdetYBrGM5truJNJqJ8xukRfX2J3b9KOQ@mail.gmail.com>
Subject: Re: [PATCH 10/23] CIFS: Mask signals during sock_sendmsg()
To:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 1 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 12:04, Pavel =
Shilovsky <piastryyy@gmail.com>:
>
> We don't want to break a session if we receive a signal during
> sending a packet through the network. Fix it by masking signals
> during execution of sock_sendmsg() and then checking for pending
> signals.
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/transport.c | 33 ++++++++++++++++++++++++++++++---
>  1 file changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 53532bd..eff9e3c 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -33,6 +33,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/processor.h>
>  #include <linux/mempool.h>
> +#include <linux/signal.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
> @@ -176,6 +177,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct =
msghdr *smb_msg,
>         int rc =3D 0;
>         int retries =3D 0;
>         struct socket *ssocket =3D server->ssocket;
> +       sigset_t mask, oldmask;
>
>         *sent =3D 0;
>
> @@ -189,6 +191,28 @@ smb_send_kvec(struct TCP_Server_Info *server, struct=
 msghdr *smb_msg,
>                 smb_msg->msg_flags =3D MSG_NOSIGNAL;
>
>         while (msg_data_left(smb_msg)) {
> +               if (signal_pending(current)) {
> +                       /* Should we stop sending if we receive SIG_KILL?=
 */
> +                       if (__fatal_signal_pending(current))
> +                               cifs_dbg(FYI, "SIG_KILL signal is pending=
\n");
> +
> +                       /* It is safe to return if we haven't sent anythi=
ng */
> +                       if (*sent =3D=3D 0) {
> +                               cifs_dbg(FYI, "signal is pending before s=
ending any data\n");
> +                               return -EINTR;
> +                       }
> +               }
> +
> +               /*
> +                * We should not allow signals to interrupt the network s=
end
> +                * because any partial send will cause session reconnects=
 thus
> +                * increasing latency of system calls and overload a serv=
er
> +                * with unnecessary requests.
> +                */
> +
> +               sigfillset(&mask);
> +               sigprocmask(SIG_BLOCK, &mask, &oldmask);
> +
>                 /*
>                  * If blocking send, we try 3 times, since each can block
>                  * for 5 seconds. For nonblocking  we have to try more
> @@ -208,20 +232,23 @@ smb_send_kvec(struct TCP_Server_Info *server, struc=
t msghdr *smb_msg,
>                  * reconnect which may clear the network problem.
>                  */
>                 rc =3D sock_sendmsg(ssocket, smb_msg);
> +
> +               sigprocmask(SIG_SETMASK, &oldmask, NULL);
> +
>                 if (rc =3D=3D -EAGAIN) {
>                         retries++;
>                         if (retries >=3D 14 ||
>                             (!server->noblocksnd && (retries > 2))) {
>                                 cifs_dbg(VFS, "sends on sock %p stuck for=
 15 seconds\n",
>                                          ssocket);
> -                               return -EAGAIN;
> +                               return signal_pending(current) ? -EINTR :=
 rc;
>                         }
>                         msleep(1 << retries);
>                         continue;
>                 }
>
>                 if (rc < 0)
> -                       return rc;
> +                       return signal_pending(current) ? -EINTR : rc;
>
>                 if (rc =3D=3D 0) {
>                         /* should never happen, letting socket clear befo=
re
> @@ -235,7 +262,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct =
msghdr *smb_msg,
>                 *sent +=3D rc;
>                 retries =3D 0; /* in case we get ENOSPC on the next send =
*/
>         }
> -       return 0;
> +       return signal_pending(current) ? -EINTR : 0;
>  }
>
>  unsigned long
> --
> 2.7.4
>

Please ignore this one. I posted the new version of it:

CIFS: Mask off signals when sending SMB packets

--
Best regards,
Pavel Shilovsky
