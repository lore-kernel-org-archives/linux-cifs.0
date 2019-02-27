Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8D1C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 22:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69B2520818
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 22:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qhr3x8mW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfB0WAi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 17:00:38 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45501 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbfB0WAi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 17:00:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id y4so8586780pgc.12
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 14:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4U+eutgYcfnQ4sasqs16BIHjgIczLfK4EI7YAHB+5wM=;
        b=Qhr3x8mW0tBub8O8iY+qOOD7fZsAm2y4APcxWHZIGVlWRnQJ/5OnVrq9u1cjgpcCGf
         wURI4J5SAunoPvVDHEAvll2eDaLhHIlJg1wSiQzFxfyFcHXreHOWWQ405at1TCpst1bz
         fhzP3Zlm+h4WpLobRUvj98q0fOz2DqD2k6OwesOD3pSE7TEjNUYZAatU/YMFvH3IJ3ix
         olPJ9btgrDCTq2/JceaVgJGaOpq1r1VT5o0eMgXcv3B9N0q2SVTMWDVkYW0U1MiuMQbJ
         guZQ+Djtyif2nCxaygm8pFyNYUTvxBVlv/PDSsyBegcNMLC3mTBdfsvAEL3kPz5BaUTz
         Ul/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4U+eutgYcfnQ4sasqs16BIHjgIczLfK4EI7YAHB+5wM=;
        b=fpskP6NCH50KZsV6YFEnn7RG7vpcTDBgp5sLgVyMyo4G1NCfomslUjrw0vHdXbwRej
         rM5hu9wVZmhwFfZ0gwsPBwSZssSPP9zPE6giZvGC+26ng+nXGOArUExPFe987QSz0qfV
         sXbeTrUlHit7n4KB3Hhq/eWLY40PpoKAYXHQATSkIMpfnDp4PQM5i8vcO/hggULjUJpr
         qw/KsKXwdopmcsbH3HuTHNLzcjw/cM6Gvm20kW9IEvXd08+BMj3eQ4/sKkTkVrfmVkY9
         w6uPdVTSLDvHI07VVsBADyHtcdPv3g0LSQjYV71CDVxxueD0MmuDZ8iOsoKc5J0n0Fnc
         EDgg==
X-Gm-Message-State: AHQUAuZDGKptrOb32E6hgmFaku7KATgRGKaWiPgb1PXA+CSXnVKWcOIH
        nYuqOfzLEIDItsSRtIsbeUkqFj07Ozy95KkAA1mbfg==
X-Google-Smtp-Source: AHgI3IZnUqxarw+GN1FNQ6H7ilsHYJuSEN44/4Ov/zpJqPAbfpDxqy8xiCue3UL3NKqzlQtUUoL4y8gUwu91zvMtSf8=
X-Received: by 2002:a62:a113:: with SMTP id b19mr3877764pff.227.1551304836926;
 Wed, 27 Feb 2019 14:00:36 -0800 (PST)
MIME-Version: 1.0
References: <20190227202202.21817-1-louis@kragniz.eu>
In-Reply-To: <20190227202202.21817-1-louis@kragniz.eu>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 27 Feb 2019 14:00:25 -0800
Message-ID: <CAKwvOd=P50WiPMzQtM91Keo2J1Cb=VmCnnAb6Ly_zRQhSaCW1A@mail.gmail.com>
Subject: Re: [PATCH] cifs: use correct format characters
To:     Louis Taylor <louis@kragniz.eu>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        Jon Flatley <jflat@chromium.org>,
        =?UTF-8?Q?Matthias_M=C3=A4nnich?= <maennich@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 27, 2019 at 12:23 PM Louis Taylor <louis@kragniz.eu> wrote:
>
> When compiling with -Wformat, clang emits the following warnings:
>
> fs/cifs/smb1ops.c:312:20: warning: format specifies type 'unsigned
> short' but the argument has type 'unsigned int' [-Wformat]
>                          tgt_total_cnt, total_in_tgt);
>                                         ^~~~~~~~~~~~

Thanks for the patch! This one fails a small sanity check and needs a revision:

So 1 warning in fs/cifs/smb1ops.c, but 2 fixes?

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
>  fs/cifs/smb1ops.c      | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
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
> index 32a6c020478f..52e1ae6744de 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -300,7 +300,7 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
>         tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
>
>         if (tgt_total_cnt != src_total_cnt)
> -               cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%hu\n",
> +               cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%u\n",
>                          src_total_cnt, tgt_total_cnt);

This one is not correct; while you'd be forgiven for confusing the
case here `tgt_total_cnt` with `total_in_tgt` below, the above hunk is
not correct.  `tgt_total_cnt` is an instance of a `__u16`.  Please
resend with this hunk dropped.  The other hunks look correct.

>
>         total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
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
