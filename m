Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF55C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 06:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 574EC2184A
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 06:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+FamryI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfB1GBo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:01:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37264 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1GBo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Feb 2019 01:01:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id s22so9193442pfh.4;
        Wed, 27 Feb 2019 22:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7SwTKAKFXS/JY2dv0YPxKSX37TBfcurhbF9H3u11S98=;
        b=G+FamryIeKgf9smikTY9LAoZIqwXoTMV9hOeDTOeLAuAQ0diFI3areFYlgOlcy7y0i
         YsWFgq4oppiiXf0gEDFZLCXPMUkx3a7jzaYXQ2tu9dD2v+CTCWVEkhqyztI/qNlUv4rC
         K9rNt1Rdbo7Tdoho3LLnEpZ8jFy3Nlw4ZkptlkGKM0mCxZxTCRU9kUfkEDlMzEuje1I8
         J+wDD+C7eaiJ5Wezckem/Btm2RvQrxPwfDRJjHJQoJn1Bc6OUHBJZJyOr4Rg2YkBUpxe
         C1RsNVFwWnTqOMFkYr0aasIdc+RSIOmROUKb5soETKyjD79+JSemAaNQinyvtsURDZbT
         oTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7SwTKAKFXS/JY2dv0YPxKSX37TBfcurhbF9H3u11S98=;
        b=QVStc5QFc8bCaL4TqgMWQPeRTFGGsjmVjI8IkiotQDmxpvG+AbvdwlbUW9H60DRKMP
         SUd7DIAg67xWvGWbGs/yaHrt4efhxq8c/nYz1Il+/tJz0Z2XegDhE8vll71Fg7Ps75vO
         kI2f/0nQfmcMBQAvYu4TnvQ99Qnw8yTEoscKRpwtIGjjoD+RdUfslQIDp56GEJ8sSJ2g
         tzCzduRPuAqP/Vn/W8c362JpQYbGIZ7AlUc+fUCBlxi+yvAgui6yBg3elB8wK/PszaVB
         fk9N5eu6EMDruaCxp0wImpPM6AxVaZY7XiNUznS6IykYbYweWICPnVd2WRRJI8fsQgfj
         +9rg==
X-Gm-Message-State: AHQUAuY0GD1UJCdCHj85GX120RshjaKIDJPt8R6Rjvv2hdyPkHeFfnqF
        89/byE8YcSXUTW8R6Lmpknr8baX+avxsHiW7Gjk=
X-Google-Smtp-Source: AHgI3IbMSgpMyiUpW20h/uPqOvTeYryT/O29oVhhJJpfIJDcYawVIO1XAC2xV5Spl6eb8x54+TVEXkJ6oGlQN/eE3sA=
X-Received: by 2002:a63:1053:: with SMTP id 19mr6849396pgq.55.1551333703503;
 Wed, 27 Feb 2019 22:01:43 -0800 (PST)
MIME-Version: 1.0
References: <20190227202202.21817-1-louis@kragniz.eu> <20190227222515.32579-1-louis@kragniz.eu>
In-Reply-To: <20190227222515.32579-1-louis@kragniz.eu>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 28 Feb 2019 00:01:31 -0600
Message-ID: <CAH2r5mtjgBX-Nd=Xr1gy8s0aHaCaae_jRCh6raHmR1HniMpKxg@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: use correct format characters
To:     Louis Taylor <louis@kragniz.eu>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com, ndesaulniers@google.com,
        jflat@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Feb 27, 2019 at 4:27 PM Louis Taylor <louis@kragniz.eu> wrote:
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

Steve
