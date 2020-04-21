Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670EAC54FC9
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 15:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB88206D6
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 15:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pTx2CXFP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgDUPER (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbgDUPEQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Apr 2020 11:04:16 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476FFC061A10
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2020 08:04:16 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a9so7477080ybc.8
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2020 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Oqbmf6pGXXV8g4N1wUnq1+Nr7jHTGmakAdWa9T2OZs=;
        b=pTx2CXFPvzs0Fpa82mRx3oMHtoKDqop32nnGV5ciLNWcK8bexc71AkzZ6Xrds6BJp0
         xO/vrotxc5Z6gQ/ec5XReS93ZY5CxhN7jWn1CoxmvN+e45cRbCUizlpvBVO/wdTkYMXo
         eNKm+oL/dUF4reSnDKuZ6RDt4d2GBwPoICI0cuXlzVQfMuCvNZKSjVjduXvxQ+LSZhxp
         LyUEiw0LaxnP5Q4bA/4boMvKeFZxAo9/3Ww72YjQpWitDg9x+Nq8WRMupatdVzCIGS1q
         yRSdjryX1+ayNwJVhAJIPmt2jWOT1DwVW2q7T/gVO3rVmVsUhjVp7t1tGpuJH1ew5ZFZ
         TWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Oqbmf6pGXXV8g4N1wUnq1+Nr7jHTGmakAdWa9T2OZs=;
        b=uQuzYwJfwyMx6a7owddKYHhXNurTBRvIPuqgtG+3/tnDGFO8PqD9FbvggKTfyWCB59
         /cqi0TuKNoHIi0vVmRAlRHguyzR0hR5/SnbkjC7lKEvxs0VS/0Cjdp6piJb0x4R8BXpX
         T6r4cpAiiPSyZKrjRajna+K0qN/qeqOPAIarN3NEbClHKJw1rVyJ4yhsEe1buUMd8wbJ
         AhGeJjJJBeIOwwp0PgUPCerLrnelMSoTswu6jdZVrA6XMrcgzeSsmTR0raJ10BWmLSCn
         SpEX9Cptm0P4utXRzHWz2mwja71VW8LbyMgZkv9SPF3JytwiZSfUbpw0K1ngwqRv42Rr
         QQ8g==
X-Gm-Message-State: AGi0PuZXmRnxxaLIeXmguRGmKzaRX8kstk5bPJEsN43vOs0GJ4IREnnr
        TuybFGJ3u7r5SUytwKMPHBHa0jAfcyU4yc/BK4A=
X-Google-Smtp-Source: APiQypKN8I68PdyIPuJf2lEKBndmM6eIziA1AsP+TPwvK9RtBVSqzPlDLJ5oPrt+ZR3J8Di0L94eS8m//aujy5VXiA8=
X-Received: by 2002:a25:e907:: with SMTP id n7mr17394908ybd.85.1587481455427;
 Tue, 21 Apr 2020 08:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200421023739.10708-1-lsahlber@redhat.com>
In-Reply-To: <20200421023739.10708-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 21 Apr 2020 10:04:04 -0500
Message-ID: <CAH2r5mt=pzajnJz0js2mWKMoMcfEKDmBmpSDoqftoN3rjKQ5xA@mail.gmail.com>
Subject: Re: [PATCH] cifs: protect updating server->dstaddr with a spinlock
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Apr 20, 2020 at 9:38 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We use a spinlock while we are reading and accessing the destination address for a server.
> We need to also use this spinlock to protect when we are modifying this adress from
> reconn_set_ipaddr().
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 95b3ab0ca8c0..63830f228b4a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -375,8 +375,10 @@ static int reconn_set_ipaddr(struct TCP_Server_Info *server)
>                 return rc;
>         }
>
> +       spin_lock(&cifs_tcp_ses_lock);
>         rc = cifs_convert_address((struct sockaddr *)&server->dstaddr, ipaddr,
>                                   strlen(ipaddr));
> +       spin_unlock(&cifs_tcp_ses_lock);
>         kfree(ipaddr);
>
>         return !rc ? -1 : 0;
> --
> 2.13.6
>


-- 
Thanks,

Steve
