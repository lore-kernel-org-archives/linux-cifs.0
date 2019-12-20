Return-Path: <SRS0=XmFd=2K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5885DC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 01:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F9B42467E
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 01:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hDmKdmCE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLTBmf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 20:42:35 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35640 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfLTBmf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Dec 2019 20:42:35 -0500
Received: by mail-il1-f195.google.com with SMTP id g12so6588321ild.2;
        Thu, 19 Dec 2019 17:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sfr0DkASOT0MoT13/9e3piyeEKgEAbIuAROVb11tB/8=;
        b=hDmKdmCEoRGDXnjj93XNfw6FoH8rtTZnKOYluWiw5na7UgC74B6XdOt5X1HcRAZnun
         odMTXStKNxHolBzNSxflFXZPttY+WPy9NuB7kXkL7OP1k/ur6X6NpKB/iKDkiptIEdRS
         B3pnFp6TsBm89uV38uszZHKpaaGpRnoIf1L685FfOY/qaHRt13u7hKgbWQ6mQ5cz8gRs
         0M5S7JWjgFvHlPSo1Y0gpvuxkzFLPwBOzs/bm3M+mrbCvk1+QB6786aHyt+b7f8gEJPh
         EDWgjplRuJyYyf5oXtJ/se+QjE0zNlc4rDEb6iBCEVweQKlA1pEgVjeCj4jya3lq5jJD
         SMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sfr0DkASOT0MoT13/9e3piyeEKgEAbIuAROVb11tB/8=;
        b=XObANOzUVpSaiYEBBsfxBQiDN/kUHpJc5XVUhRzoRJNDEHhEOWkTy7vv4L+xkcCh1o
         pyQvZq3lW7DHxlFbJ/r7fhJCr4IUzdlFSVK3MVXlwWUduKGwq6WJmGr2iF/M6SPk8DGH
         2bqg2zbP2rUznfViy64vL5aHJ2xSF3MDKIHfHAuPt2nWwo2PYppXoprNDuBxP1G8/2bK
         u3jDHH0GjF4TkJuR9tEQC5esIVJy78rL6IAwpp6SkXrRnUTOMs3fd3bO4Gdd7xwWhEN4
         XHVzWBtDIUY07fwZF8beSxHAhFzKdViIofQ00OFEJtqP+2ZfP28s1CchaaNTLbM8HQrh
         D9YQ==
X-Gm-Message-State: APjAAAUKgCkHf1qQjaQkCrksy26EcroHXBS25Lvc5VzLcE8uTvoZcpC5
        oBK4CdrT7CMk4ec1s/X6Hu9zNwetuYYgALJUPWID9A==
X-Google-Smtp-Source: APXvYqwW12fGRUInSbhFGQiF8M5rMUYdDDkl/mkcbRhVNYfiGDJz2k/OjCft5BgxUUEN5KqBimqQgZwbaY/hrYQzo6Y=
X-Received: by 2002:a92:4883:: with SMTP id j3mr9930949ilg.272.1576806154739;
 Thu, 19 Dec 2019 17:42:34 -0800 (PST)
MIME-Version: 1.0
References: <20191218030451.40994-1-natechancellor@gmail.com>
In-Reply-To: <20191218030451.40994-1-natechancellor@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 19 Dec 2019 19:42:23 -0600
Message-ID: <CAH2r5mtr=d-LYD_EQ_OQVX5s8QziHvAYNmRnwMpVjeb4JiHMYw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Adjust indentation in smb2_open_file
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Dec 17, 2019 at 9:04 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> ../fs/cifs/smb2file.c:70:3: warning: misleading indentation; statement
> is not part of the previous 'if' [-Wmisleading-indentation]
>          if (oparms->tcon->use_resilient) {
>          ^
> ../fs/cifs/smb2file.c:66:2: note: previous statement is here
>         if (rc)
>         ^
> 1 warning generated.
>
> This warning occurs because there is a space after the tab on this line.
> Remove it so that the indentation is consistent with the Linux kernel
> coding style and clang no longer warns.
>
> Fixes: 592fafe644bf ("Add resilienthandles mount parm")
> Link: https://github.com/ClangBuiltLinux/linux/issues/826
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  fs/cifs/smb2file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index 8b0b512c5792..afe1f03aabe3 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -67,7 +67,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>                 goto out;
>
>
> -        if (oparms->tcon->use_resilient) {
> +       if (oparms->tcon->use_resilient) {
>                 /* default timeout is 0, servers pick default (120 seconds) */
>                 nr_ioctl_req.Timeout =
>                         cpu_to_le32(oparms->tcon->handle_timeout);
> --
> 2.24.1
>


-- 
Thanks,

Steve
