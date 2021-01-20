Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E67C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Jan 2021 06:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663DA2313C
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Jan 2021 06:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbhATG0t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Jan 2021 01:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbhATGUT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Jan 2021 01:20:19 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AABEC061757
        for <linux-cifs@vger.kernel.org>; Tue, 19 Jan 2021 22:19:39 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id u21so24761395lja.0
        for <linux-cifs@vger.kernel.org>; Tue, 19 Jan 2021 22:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kFfsFgBQbNTC7UlfNX/NprUxo7UkgUs7DieO5P+M3qY=;
        b=EKVQEX0Ei4krkMgfvg2FCqXSoHATbFKDAtgfBhj15TvVyFfq57bPoy2TasnW1uqBWE
         12bUamEnh+OKKGqLgumjjFqFjPGcCbA04FxFsVtIkMutXeE/5O3zLdVFRcytRwVwgCWP
         n/uGlMmj1UweGM/WN84H6+YAWXiXgoEDNqQ3p5HO8MhFdkMl7KK1FltrLAtSzB++KlZQ
         kPUIA97arLJlF6LFVF1itmlWUFmIXnjMxT3/s4Yv6DxUPpmoht22EWG8/mu3Bhmg3Iz4
         7RHfUhp00OZgrhaa4ikr4QZI8vf6vPZw9/ND6q4qTHlUhJK5woN8RE/kndwdbv+phuKD
         ekrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kFfsFgBQbNTC7UlfNX/NprUxo7UkgUs7DieO5P+M3qY=;
        b=iS95tPRoudgcdJmT0aTsGYBIZPiknTwjt3Tt0MOMhVjGI9cwEF5FNlkgjGNwckCdUx
         N/TO4hsTqpwJ9BGp0wEHu4gG7HIKzMasjgyZn50j6FQWNT923x3JSKdoh6uiup03kMrC
         qrAW3eNLJAYa4m6v29qNQXLZ78gJ128sEb6jX4K9qkq+VjYlNlM3oFKaA35Nr5Q5vmaD
         v/l4cAyh6w8l0wWfLBohec9Kws3SWPQ4hEOCDDukSULmqibmWD1TcD2FF5yMXcUnprRc
         rUzJNT/Sg+tbiQqhARSEcnND+2AB9q4oDeabc1Snvj4PL7PdIusjQWfFsn81iRsIQxiQ
         Kf1g==
X-Gm-Message-State: AOAM532KdGSPr9tZwSYm9/ugfVlvGRE75WKdLDbFql7yHGGr4uAXNBPB
        7YwUig4jkSERBDlZWuwzLthFPmaxDtLasbwwdG5vWKx857R0UQ==
X-Google-Smtp-Source: ABdhPJzElyIQx0PUi5QjPBGmTP4r7fmrLpeUOeAG8dvjYOQP9OnZBRhS0QDf1hvKdN7IxS1ZDbtuwjeQG+vZdFnZjhs=
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr3456054ljj.218.1611123577651;
 Tue, 19 Jan 2021 22:19:37 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com>
In-Reply-To: <20210120043209.27786-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Jan 2021 00:19:26 -0600
Message-ID: <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch won't merge (also has some text corruptions in it).  This
line of code is different due to commit 6988a619f5b79

6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
 cifs_dbg(FYI, "signal pending before send request\n");
6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
 return -ERESTARTSYS;

        if (signal_pending(current)) {
                cifs_dbg(FYI, "signal pending before send request\n");
                return -ERESTARTSYS;
        }

See:

Author: Paulo Alcantara <pc@cjr.nz>
Date:   Sat Nov 28 15:57:06 2020 -0300

    cifs: allow syscalls to be restarted in __smb_send_rqst()

    A customer has reported that several files in their multi-threaded app
    were left with size of 0 because most of the read(2) calls returned
    -EINTR and they assumed no bytes were read.  Obviously, they could
    have fixed it by simply retrying on -EINTR.

    We noticed that most of the -EINTR on read(2) were due to real-time
    signals sent by glibc to process wide credential changes (SIGRT_1),
    and its signal handler had been established with SA_RESTART, in which
    case those calls could have been automatically restarted by the
    kernel.

    Let the kernel decide to whether or not restart the syscalls when
    there is a signal pending in __smb_send_rqst() by returning
    -ERESTARTSYS.  If it can't, it will return -EINTR anyway.

    Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
    CC: Stable <stable@vger.kernel.org>
    Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ 1848178
>
> There is no need to fail this function if non-fatal signals are
> pending when we enter it.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index c42bda5a5008..98752f7d2cd2 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>         if (ssocket == NULL)
>                 return -EAGAIN;
>
> -       if (signal_pending(current)) {
> +       if (fatal_signal_pending(current)) {
>                 cifs_dbg(FYI, "signal is pending before sending any data\n");
>                 return -EINTR;
>         }
> --
> 2.13.6
>


-- 
Thanks,

Steve
