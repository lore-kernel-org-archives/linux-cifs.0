Return-Path: <SRS0=fjk5=BT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E68C433DF
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Aug 2020 16:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 727DD206C3
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Aug 2020 16:46:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUUlQ486"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgHIQqp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Aug 2020 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgHIQqp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Aug 2020 12:46:45 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE39CC061756;
        Sun,  9 Aug 2020 09:46:44 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so6601920iow.11;
        Sun, 09 Aug 2020 09:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UCHvINa6VosD8msvnuFOWiWxKgJoPHzS7PIxpE/jDKE=;
        b=SUUlQ486bbodonuMFEkprugAhuuwL2vHbLCV1+2ijqzaObbJzRpgSGucKZ6F+5UQh9
         vNQ/6Wp1o6OXrBW/ujPh9GzKi3skf1L3CWxuMSIsgzAtUBWnhsCMb/dYega9BNkcFm5h
         zaEaSbVPN00rGpU0UWU/XDauI/L36qM13aUNnmWiEJLIgdCYkof1ip3ZO1N9ToqwH3ml
         UhFH7V6cK4rdCblXegiI4p35SYmrGKVPGhUmbCN9aA6Dzn0XUCJHsq+3bShzqKeRtx1V
         ckK3GO3ckXG2gSTC9CjqIO+bpEra0Xj5TTk+se3ZhfBBl1UMmN56N9kA+M+IaI5j9EH9
         fGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UCHvINa6VosD8msvnuFOWiWxKgJoPHzS7PIxpE/jDKE=;
        b=Bjmo0SeYgqeVyuRrB+Zz94V+3Snuqh6hEMLwzrK1MPyGQwaa87aGHh3i5o10zQqPNS
         RwFyc18DlY8FkMh6HQoOYXh8YYpRsr87V8NMhOIhh4h3Y13zfjnPwPmiwVUTNk1+RP/F
         BJyirTbtSK4wUWAD0Z2YrGKy930a1I7EMlWbPgNAAWF2cRXVhlZZNDVQN2wG1DQjS2Rn
         NeSIGP7UmlqVQbBZPojsr+W6zoE/Svrn4/wbdQoZdymh/4Wv1QKj4o1L7Prz2RtwuqKj
         jCB2n2pF1pzULwE1GwYpdInUsTI77WuDWQaMIjanQhhkL8YwPqBODOCBljXER4blxMPk
         La8Q==
X-Gm-Message-State: AOAM530D8KxJ6cduZRZiMI1DWnIuqKCrnXcdtCPYYuCuuO6x7K3k1x0J
        Cb+WvZZqdEGtaQAh78hpUkWDO6rCpF7cV5wPA6Rl8iVrG4Y=
X-Google-Smtp-Source: ABdhPJxoK4IbE9i3/uwbgKBES4omB1Sn1yEUDgiKt1behl2IAnP9cuy6hGYY0MP9i6FNBs4RCSbb+ZuPMaYpszZy2ZU=
X-Received: by 2002:a05:6638:635:: with SMTP id h21mr16236867jar.27.1596991604178;
 Sun, 09 Aug 2020 09:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <1596875797-22710-1-git-send-email-linmiaohe@huawei.com>
In-Reply-To: <1596875797-22710-1-git-send-email-linmiaohe@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 Aug 2020 11:46:33 -0500
Message-ID: <CAH2r5mvHLXtCAam9Wcw6PJUGg3bY8PvjYG8ijFh0km-CKNEUnA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Convert to use the fallthrough macro
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is this conversion from "/* Fallthrough */"   to the preferred (?)
"fallthrough;" documented anywhere?

All I see is a few fs changesets like:

commit c730ae0c6bb3125ccb776fb2ab6abbdff500c02c
Author: Marcos Paulo de Souza <mpdesouza@suse.com>
Date:   Tue Jun 16 15:54:29 2020 -0300

    btrfs: convert comments to fallthrough annotations

    Convert fall through comments to the pseudo-keyword which is now the
    preferred way.

And the vast majority of places (33 vs. 4) use "/* Fallthrough */ in
the fs directory

On Sat, Aug 8, 2020 at 3:34 AM linmiaohe <linmiaohe@huawei.com> wrote:
>
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Convert the uses of fallthrough comments to fallthrough macro.
>
> Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 24c2ac360591..667d70aa335f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3913,7 +3913,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
>         case MID_RESPONSE_MALFORMED:
>                 credits.value = le16_to_cpu(shdr->CreditRequest);
>                 credits.instance = server->reconnect_instance;
> -               /* fall through */
> +               fallthrough;
>         default:
>                 rdata->result = -EIO;
>         }
> @@ -4146,7 +4146,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
>         case MID_RESPONSE_MALFORMED:
>                 credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
>                 credits.instance = server->reconnect_instance;
> -               /* fall through */
> +               fallthrough;
>         default:
>                 wdata->result = -EIO;
>                 break;
> --
> 2.19.1
>


-- 
Thanks,

Steve
