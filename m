Return-Path: <SRS0=B7dF=3T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17D6C2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 21:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D3720674
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 21:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rj1LlI0J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgA3VYw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jan 2020 16:24:52 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46477 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbgA3VYw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jan 2020 16:24:52 -0500
Received: by mail-io1-f66.google.com with SMTP id t26so5687856ioi.13
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2020 13:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ms35iyyJALeam/e23imjOs9uwHQwNwwwbnNF3oepDXM=;
        b=Rj1LlI0JQab6chDGf/GESj7QMUauqsXWGuYxhE0VtUpSOX2voXZl9zJkm9goMibCew
         w11SVJsCFQOrChgMCtTIOH+V2LMXADamdk7UjUDPcJu8A6n0o111c6iUkerziGhbmNjD
         +M8MRQA0Wwgs8QGEbWnrhsTSmg8A5MUuOcYrxKo/mvBVOEguS1k2uMU9N3xInkPMk+il
         9DGz0m1NMSoDkCElm6FWx24n6tqMdIn9HEOhozLFQoUgFIoSNkboLe01TfXDnJQQ6WP3
         NGJakvRXYppg0wZmyu5yWko5/WXSGhfzEdxlLWSCxUbh8oN+vmopZb0Az/XhfifIcvBi
         q/nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ms35iyyJALeam/e23imjOs9uwHQwNwwwbnNF3oepDXM=;
        b=Io2ILs/Uv4fqkTs5Qg92xFJkwwGitI6FwECamOJaJjoMetLYZDNpC0Xi7Kn4GgO1ed
         sGFJwHrF/jHvoeprnbDPiUeyTjebHVZCWqU9426vaErz279ZKJfHvUh8U3EFusc/QgFN
         B3H8Zt46Atr1HaLPX47dp7zd8uJZLKSxTv8oEbusGbJr5A1X5lxd/O7uDuLjLifZX3Q7
         4Dh+ge6QE+PeJnPt3Zd0lIRWHj9hag6rfED+r99W+ZzbgCMaNPTicepDw/gC+7G2eR1G
         yoDdzIkLRJCZnOvNLI8xkTwMsqBAOn4oxD+8V386qGHWRrACa/gzspy+hEOu3fF7tefw
         AkOA==
X-Gm-Message-State: APjAAAVr8a0RA/FDc03L+3a6x1a43ebl5opc8jNqA98XvzE5FGuq3OnI
        2GNOIpgoPtojE2+alj7DDQr5ln1Ohzxf4obWVoI=
X-Google-Smtp-Source: APXvYqzruedVp+wnTYdB88Zia2ZKGuk2Ig2DzS/5hbNllXBKzhIA1wNgoFXF+63CT6OEKZimQ3VFe46MlSYx3MQveyE=
X-Received: by 2002:a6b:cd0e:: with SMTP id d14mr5625723iog.272.1580419491254;
 Thu, 30 Jan 2020 13:24:51 -0800 (PST)
MIME-Version: 1.0
References: <20200130195251.15789-1-lsahlber@redhat.com>
In-Reply-To: <20200130195251.15789-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Jan 2020 15:24:40 -0600
Message-ID: <CAH2r5mu9CNKFQ5Mht-qUWKQShPXNefcMY+RsuMcOzFKkSb=0xw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix soft mounts hanging in the reconnect code
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Paulo Alcantara <palcantara@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added cc:stable and Reviewed-by and merged into cifs-2.6.git for-next

On Thu, Jan 30, 2020 at 1:53 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1795429
>
> In recent DFS updates we have a new variable controlling how many times we will
> retry to reconnect the share.
> If DFS is not used, then this variable is initialized to 0 in:
>
> static inline int
> dfs_cache_get_nr_tgts(const struct dfs_cache_tgt_list *tl)
> {
>         return tl ? tl->tl_numtgts : 0;
> }
>
> This means that in the reconnect loop in smb2_reconnect() we will immediately wrap retries to -1
> and never actually get to pass this conditional:
>
>                 if (--retries)
>                         continue;
>
> The effect is that we no longer reach the point where we fail the commands with -EHOSTDOWN
> and basically the kernel threads are virtually hung and unkillable.
>
> Fixes: a3a53b7603798fd8 (cifs: Add support for failover in smb2_reconnect())
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 7edba3e6d5e6..14f209f7376f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -312,7 +312,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
>                 if (server->tcpStatus != CifsNeedReconnect)
>                         break;
>
> -               if (--retries)
> +               if (retries && --retries)
>                         continue;
>
>                 /*
> --
> 2.13.6
>


-- 
Thanks,

Steve
