Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F9DC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 19:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245318AbiE0Tcs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 15:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiE0Tcr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 15:32:47 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FD613C095
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 12:32:46 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id t13so3522332ljd.6
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 12:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YbNlXe87qNc6h67+KP/ggEhHQmBaOtSGUnOsKzPXQyw=;
        b=cQJY+P6rcRGZZ5r3c7oRqG5V7iGSoJNJfKBfuZfO15LxSEWMkzAtA54lu7Hp/tYWBV
         wWSVEi3BgDrSqtNbmMqXIV9tPidA0qwutEe5J6bEx6R78si5RkSYCzVzWoyTDMtRlldU
         DZy13KPSObcqjZC20xf9UDfblSOqjoP6xPruYdMlBDSh/Rj/CWl+4G4TkODCM2vsTIjW
         Ofqstgp/HJlVo9uKP1+4DyCRvGnLZkps8yxzz07y6GsvLCzo5o1FfyVqKcEq21v9Fywx
         8WPNqYNKpyUzjKwQImhtgUQ2Dag5bdTNucqQQFvxEtU5kZuVoVNmllkponQWwR+Ri0Sb
         71Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YbNlXe87qNc6h67+KP/ggEhHQmBaOtSGUnOsKzPXQyw=;
        b=kk/K5F9mSoXBhg1Umx60cQ23nnNDmP8UiI7yi7azy36hftEo+odySxiuMXaTxS3uCJ
         QevjC1lhMdRKqfqGvtitjwbzIedRn3a4pa2TpksOpYA/mR5l8LiZOBP6OxxL75BmoOpq
         PQUq+3MdXx/axuAzpdscZz/SJoB1UaheOWrhkVHfhxaeLs8bCjnGlLdDFULKGQPXq816
         dXhmdvISww7dbf+R9ShKrGMGZdnkyh3HPWQ6iBlePULJnFCml3as/tP0aIXUET+QKtiQ
         VXYTFla1I/OAH0PRYNUsj8NrzCz2j2lfBzkKgKN7bOnZLyxQLXMQRjA2RR0JBxBaCijg
         Y/5Q==
X-Gm-Message-State: AOAM530ueL+0jdKiZquLwjE82lOQNsZg++EjqLqegL5W6UxN5szJ7Tc4
        Y6IxYntMLdDNI/8Td+7+vK0CvhBfFUyQaRm3iUXLjw==
X-Google-Smtp-Source: ABdhPJzAxhlMSalFK9CVX5KwiMg/9AV2qQCnCCuSa8PGqm8A4zOvp5d8SiUYeHr7aft7fDHizNRyejsH6FF624ole3c=
X-Received: by 2002:a2e:b98f:0:b0:254:1e41:6aae with SMTP id
 p15-20020a2eb98f000000b002541e416aaemr5939903ljp.493.1653679964237; Fri, 27
 May 2022 12:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220526140226.2648689-1-trix@redhat.com>
In-Reply-To: <20220526140226.2648689-1-trix@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 27 May 2022 12:32:32 -0700
Message-ID: <CAKwvOdmPZXiMZRKyMfZVMmw-95XVocSZn3VVi3yJh0Bx1ONbJQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: set length when cifs_copy_pages_to_iter is successful
To:     Steve French <stfrench@microsoft.com>
Cc:     nathan@kernel.org, dhowells@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>, sfrench@samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

+ Steve's @microsoft.com email addr.

On Thu, May 26, 2022 at 7:02 AM Tom Rix <trix@redhat.com> wrote:
>
> clang build fails with
> fs/cifs/smb2ops.c:4984:7: error: variable 'length' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>   if (rdata->result != 0) {
>       ^~~~~~~~~~~~~~~~~~
>
> handle_read_data() returns the number of bytes handled by setting the length variable.
> This only happens in the copy_to_iter() branch, it needs to also happen in the
> cifs_copy_pages_to_iter() branch.  When cifs_copy_pages_to_iter() is successful,
> its parameter data_len is how many bytes were handled, so set length to data_len.
>
> Fixes: 67fd8cff2b0f ("cifs: Change the I/O paths to use an iterator rather than a page list")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 3630e132781f..bfad482ec186 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -4988,7 +4988,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
>                                 dequeue_mid(mid, rdata->result);
>                         return 0;
>                 }
> -               rdata->got_bytes = pages_len;
> +               length = rdata->got_bytes = pages_len;
>
>         } else if (buf_len >= data_offset + data_len) {
>                 /* read response payload is in buf */
> --
> 2.27.0
>


-- 
Thanks,
~Nick Desaulniers
