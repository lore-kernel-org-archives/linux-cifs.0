Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EC2C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 23:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E485220818
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 23:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OkCsFlzr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbfB0XNx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 18:13:53 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37018 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730340AbfB0XNw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 18:13:52 -0500
Received: by mail-pf1-f194.google.com with SMTP id s22so8741553pfh.4
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 15:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ieTp+KoWHfqUwaKdmwu5YzuGwMHkzBDwZFNJcECypUE=;
        b=OkCsFlzraH/jpAxupy2zkyYqddTwlJR2gcugk5iCZGmAuAIVDZEJGa3olwimZR7e15
         kj2aEkBaOZgLV50FXETkhKSDCJ0RFRvQWpD85qHnD0k+atAYrXkAXie+hAa0c6iYqeP8
         W/kF3BjsKDJL80kXJkliFp/QM16vH4PuNris8txkl6BxHu/QcppRV9nioVqjVDTlcs0h
         Q7RihSvERuxcxbe7evlSL2LtH8OqDpYcrtOqUGszbWkcfv6UaDfGiBK3V78P1V3uLxTj
         sDYlLLMKTd89kb/uRkLba4QMFbLnw14sTxte9yTqUhbFXW3GIfFgtX/d/v6xsxQEw++M
         77gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ieTp+KoWHfqUwaKdmwu5YzuGwMHkzBDwZFNJcECypUE=;
        b=rZLchOsqUXT2tngdVDkNq2keUdNWABP7F8MKYWjI3RG9MI4llJcej1ZRqITRJGWa4j
         hpgyCUAumDoy71B0biV/DL0P6N8B3avGbURixEHr+RDYApx9iCe/cg4qB/di5QnfzD5M
         oADZ2B2v81W+iNIGHPq2c2uqe2x98Q2E47rwpN52X9/8X+Rj9OGOHYlGUdXNlGMRIrfD
         Wpu/6bpJPaCmx79Bxm8JuQrI8KpCLGguYcc3XZ+nLGjp9N7YN+WVKzs9VUE8YLhnQ8oZ
         R9uic5n3brrmx7AJgc2NA506nPVh921Dt3jvRAv6YHRBh3rza5vqPhQwJtIMkLHfhpnH
         eL2Q==
X-Gm-Message-State: AHQUAuYrequZ4z2XrapMVweqNu1nzEYtNonPe8IukOH8YNJTxMNuTVly
        HswoN6FI9n4WvKvqO2VyHBsnlzkiWGJ+hmjUEeqqyg==
X-Google-Smtp-Source: AHgI3IYTJ3Rp5UTF95yp15cZYDsadjtvze06HoFEyw9/Ge/NTmE762AWdRXWZwRELdf+WIKMuDCmUInxfqgBbbu0I0g=
X-Received: by 2002:a63:f544:: with SMTP id e4mr5422768pgk.145.1551309231419;
 Wed, 27 Feb 2019 15:13:51 -0800 (PST)
MIME-Version: 1.0
References: <20190227202202.21817-1-louis@kragniz.eu> <20190227222515.32579-1-louis@kragniz.eu>
In-Reply-To: <20190227222515.32579-1-louis@kragniz.eu>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 27 Feb 2019 15:13:40 -0800
Message-ID: <CAKwvOdkWX9h68S9Nw3Y2jkZX9ouV-0=3wmnK94YV_rCVNr4hhA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: use correct format characters
To:     Louis Taylor <louis@kragniz.eu>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        Jon Flatley <jflat@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 27, 2019 at 2:26 PM Louis Taylor <louis@kragniz.eu> wrote:
>
> When compiling with -Wformat, clang emits the following warnings:
>
> fs/cifs/smb1ops.c:312:20: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                          tgt_total_cnt, total_in_tgt);
>                                         ^~~~~~~~~~~~
>
> fs/cifs/cifs_dfs_ref.c:289:4: warning: format specifies type 'short'
> but the argument has type 'int' [-Wformat]
>                  ref->flags, ref->server_type);
>                  ^~~~~~~~~~
>
> fs/cifs/cifs_dfs_ref.c:289:16: warning: format specifies type 'short'
> but the argument has type 'int' [-Wformat]
>                  ref->flags, ref->server_type);
>                              ^~~~~~~~~~~~~~~~
>
> fs/cifs/cifs_dfs_ref.c:291:4: warning: format specifies type 'short'
> but the argument has type 'int' [-Wformat]
>                  ref->ref_flag, ref->path_consumed);
>                  ^~~~~~~~~~~~~
>
> fs/cifs/cifs_dfs_ref.c:291:19: warning: format specifies type 'short'
> but the argument has type 'int' [-Wformat]
>                  ref->ref_flag, ref->path_consumed);
>                                 ^~~~~~~~~~~~~~~~~~
> The types of these arguments are unconditionally defined, so this patch
> updates the format character to the correct ones for ints and unsigned
> ints.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Louis Taylor <louis@kragniz.eu>

Thanks for following up on the feedback.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  fs/cifs/cifs_dfs_ref.c | 4 ++--
>  fs/cifs/smb1ops.c      | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index d9b99abe1243..5d83c924cc47 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -285,9 +285,9 @@ static void dump_referral(const struct dfs_info3_param *ref)
>  {
>         cifs_dbg(FYI, "DFS: ref path: %s\n", ref->path_name);
>         cifs_dbg(FYI, "DFS: node path: %s\n", ref->node_name);
> -       cifs_dbg(FYI, "DFS: fl: %hd, srv_type: %hd\n",
> +       cifs_dbg(FYI, "DFS: fl: %d, srv_type: %d\n",
>                  ref->flags, ref->server_type);
> -       cifs_dbg(FYI, "DFS: ref_flags: %hd, path_consumed: %hd\n",
> +       cifs_dbg(FYI, "DFS: ref_flags: %d, path_consumed: %d\n",
>                  ref->ref_flag, ref->path_consumed);
>  }
>
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 32a6c020478f..20a88776f04d 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -308,7 +308,7 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
>         remaining = tgt_total_cnt - total_in_tgt;
>
>         if (remaining < 0) {
> -               cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%hu\n",
> +               cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%u\n",
>                          tgt_total_cnt, total_in_tgt);
>                 return -EPROTO;
>         }
> --
> 2.20.1
>


-- 
Thanks,
~Nick Desaulniers
