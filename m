Return-Path: <SRS0=SI7l=6U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBFCC28CBC
	for <linux-cifs@archiver.kernel.org>; Wed,  6 May 2020 15:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 692FC21974
	for <linux-cifs@archiver.kernel.org>; Wed,  6 May 2020 15:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kod1vXQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgEFPXw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 May 2020 11:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729754AbgEFPXq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 May 2020 11:23:46 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF021C061A0F;
        Wed,  6 May 2020 08:23:45 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id w137so1172977ybg.8;
        Wed, 06 May 2020 08:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HN9ojInOFKYThRzc8Ql4PZMRAE8OzPwg0Rj7oohGgGQ=;
        b=kod1vXQydzMu58nt7WS5nepff0qeObRx4XHGsshew2+imFpLAyaJDSSgKd5uPcGhdC
         4MGDv8sa3k7u82yjl+9XFcPt2kEpOaqykd6kiPBXAeHOOoGiZ+cWcn9ptyem/B0i/Z+F
         QIYNrQFYk+HGtZ5wBDLqpS8ZkqQXfFTu5LgkJEtbJQJ36NK0HejTJLqty9zSxcbQai5Q
         3in5w6CDIvWK4cqZBK6jLiaJB5LGDwznGy7Y6I1gqs8TG6NcSUeuIxp4uVCB42DUhssW
         ZJawDFzeIQhEPi8dfSLCdZd4r+y+sCcdFcFYBhKpnqJLbOgfxiqHvNhjkuB6XZ04T6RN
         fKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HN9ojInOFKYThRzc8Ql4PZMRAE8OzPwg0Rj7oohGgGQ=;
        b=Ql4k3Y8yspsa2dK+mDMYatOEzrHmKTIIYEIR45J7KjWvNeia5tfpQy8S9qIbr0pb2O
         3n5MQhHO4Lro3gxctyN9D3nAav3HGMTMa427l9JFZJ9cEI5nwYUMcMISp3IYo+ThcVVF
         Ni1/nT8A7Nmzv0ax8DdaFh8zoS0TFbUULms5Ai93F5JYFh3xQOeGUkGJW5kxKzB09egh
         hOfHf0fCcgsa8+rKmWfdZZU/A+bpvIUnMnVdz7TMYovIG532bLSiqmVxqJa2Ii6dk+TA
         esFEZ/V8flJryHBojsQ+G/MLnJBMCdsdLqKF9wZXoPmpZ8prV9u+QFLAherdHHXZoK+7
         IswQ==
X-Gm-Message-State: AGi0PuaQkVY4QNLhIZT3fATl5kXxWgJr3/Fgzn6ZdRU35LIdLfE6kljE
        AHUXQT4p9VcXiqO5ga8909jJotyG8BTuGneiUOvcorsI
X-Google-Smtp-Source: APiQypIqRLHpjtToZNBKKvR/o1+aXAENDQ953WCIfNCcT9Ks9wfQ9MZn60jC/Fvhcd19XSLXbKMWBALmuU8M76B1tgE=
X-Received: by 2002:a25:abcc:: with SMTP id v70mr4224871ybi.364.1588778624121;
 Wed, 06 May 2020 08:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200505134335.26802-1-geert+renesas@glider.be>
In-Reply-To: <20200505134335.26802-1-geert+renesas@glider.be>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 6 May 2020 10:23:33 -0500
Message-ID: <CAH2r5mvndbMwhcLRDG5JGG-2GnHwfQYz2kh6avBzQWnAebY_Cw@mail.gmail.com>
Subject: Re: [PATCH trivial] CIFS: Spelling s/EACCESS/EACCES/
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Steve French <sfrench@samba.org>, Jiri Kosina <trivial@kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, May 5, 2020 at 8:49 AM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> As per POSIX, the correct spelling is EACCES:
>
> include/uapi/asm-generic/errno-base.h:#define EACCES 13 /* Permission denied */
>
> Fixes: b8f7442bc46e48fb ("CIFS: refactor cifs_get_inode_info()")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  fs/cifs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 390d2b15ef6ef9d7..5d2965a2373054a4 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -730,7 +730,7 @@ static __u64 simple_hashstr(const char *str)
>   * cifs_backup_query_path_info - SMB1 fallback code to get ino
>   *
>   * Fallback code to get file metadata when we don't have access to
> - * @full_path (EACCESS) and have backup creds.
> + * @full_path (EACCES) and have backup creds.
>   *
>   * @data will be set to search info result buffer
>   * @resp_buf will be set to cifs resp buf and needs to be freed with
> --
> 2.17.1
>


-- 
Thanks,

Steve
