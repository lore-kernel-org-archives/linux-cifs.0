Return-Path: <SRS0=eY7I=5D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64E4C10DCE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 04:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9851520768
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 04:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfA+GMmC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCRErp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Mar 2020 00:47:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43189 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgCREro (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Mar 2020 00:47:44 -0400
Received: by mail-io1-f67.google.com with SMTP id n21so23509931ioo.10;
        Tue, 17 Mar 2020 21:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9t6OER6Nr8rTZmv9fIvbSoay6iMJgVOYfySsd9QPfc4=;
        b=mfA+GMmCp4qNgKXbNcNzf8cghnXV6QQ3GtKTAxFhMdD6bRnE36h5Xo3rZwAUXBoNmZ
         nuGj1WreHi2fmsfZ3wRWJPTwZWKbcwxcHCJJ3wl1PhnaN1X95rsCkpPT9b//wmJeXFSN
         XgakKl2ogf7QvmgHiMGwTU/vTm6WUgtHxfFXS3ERvHEJEVThIiLpq+cKdg5fLQ27W3sx
         JoeBXDa85cjpI5pO1PUKyF2t9NggC9wu7zf4SnCNRVVI10Kgcis7Op2/Aujk5er8KzEa
         ij3V20oD2QMnmLU2JgWxoztvhNaHbXh9ndRIQm31FQ/yG/EtZrOI8COKYz9SBZiJchp4
         h0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9t6OER6Nr8rTZmv9fIvbSoay6iMJgVOYfySsd9QPfc4=;
        b=NxIoQg14mbO2u4JEUeSZuTzdFxO35mzX23yZ9adfA+2OHSt2kYeex7UoIzlh4B66MB
         nYcYA4uYuvEMT/Ty20WHJr+65pN4ALGJMbVs//nIaKYtPuoQDnZ4erong1inQuFVKCx9
         p6MSrTAYVVG9UN12OLNSxnVATz7hDW6DPVHZJZ4KTqVbd9wyeGZYLQaBL6gCZJpeZkD/
         2gK4E+yUXfaBXFbYcX/BTu0UFA8y6Mu+SC8AaCoABjMHMx1vweKgmTyNkyv+5q5I3rU1
         vcOMJEww+pWnyhP63lTvhi4JycZhnTyNoUA5Qtgkg6m8Pq9qW3kX5cA9Vh3YMduFu37s
         ecFg==
X-Gm-Message-State: ANhLgQ0c2ArHHjJzIWScHDXPsZBwVROvuCE+Gw1rwKopvlLBAgkPCfeZ
        FzbgOoz8sXYZ51b57VVH8Or8PHMoSpx1+pckktHV9g==
X-Google-Smtp-Source: ADFU+vsgQ+qx2CLoR9BIj0WDMTsdIGixCf0zjYOE9Lr8efHI5AIL3zlIgFhzUgrpb+kZOdFKxZALyNWkE4zVHAWjSU8=
X-Received: by 2002:a05:6638:a99:: with SMTP id 25mr2729836jas.37.1584506863812;
 Tue, 17 Mar 2020 21:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <ef49e240-fc8f-9eb4-af98-26bfd39104aa@huawei.com>
In-Reply-To: <ef49e240-fc8f-9eb4-af98-26bfd39104aa@huawei.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 18 Mar 2020 14:47:32 +1000
Message-ID: <CAN05THQYxPcsgiHTqMcsTgB6ZDYaBMamu-sOe428H7EwSRU2HQ@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix bug which the return value by asynchronous read
 is error
To:     Yilu Lin <linyilu@huawei.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, alex.chen@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Yilu,

I think your reasoning makes sense.
Do you have a small reproducer for this? A small C program that triggers this?

I am asking because if you do we would like to add it to our buildbot
to make  sure we don't get regressions.


regards
ronnie sahlberg

On Wed, Mar 18, 2020 at 1:59 PM Yilu Lin <linyilu@huawei.com> wrote:
>
> This patch is used to fix the bug in collect_uncached_read_data()
> that rc is automatically converted from a signed number to an
> unsigned number when the CIFS asynchronous read fails.
> It will cause ctx->rc is error.
>
> Example:
> Share a directory and create a file on the Windows OS.
> Mount the directory to the Linux OS using CIFS.
> On the CIFS client of the Linux OS, invoke the pread interface to
> deliver the read request.
>
> The size of the read length plus offset of the read request is greater
> than the maximum file size.
>
> In this case, the CIFS server on the Windows OS returns a failure
> message (for example, the return value of
> smb2.nt_status is STATUS_INVALID_PARAMETER).
>
> After receiving the response message, the CIFS client parses
> smb2.nt_status to STATUS_INVALID_PARAMETER
> and converts it to the Linux error code (rdata->result=-22).
>
> Then the CIFS client invokes the collect_uncached_read_data function to
> assign the value of rdata->result to rc, that is, rc=rdata->result=-22.
>
> The type of the ctx->total_len variable is unsigned integer,
> the type of the rc variable is integer, and the type of
> the ctx->rc variable is ssize_t.
>
> Therefore, during the ternary operation, the value of rc is
> automatically converted to an unsigned number. The final result is
> ctx->rc=4294967274. However, the expected result is ctx->rc=-22.
>
> Signed-off-by: Yilu Lin <linyilu@huawei.com>
> ---
>  fs/cifs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 022029a5d..ff4ac244c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3323,7 +3323,7 @@ again:
>         if (rc == -ENODATA)
>                 rc = 0;
>
> -       ctx->rc = (rc == 0) ? ctx->total_len : rc;
> +       ctx->rc = (rc == 0) ? (ssize_t)ctx->total_len : rc;
>
>         mutex_unlock(&ctx->aio_mutex);
>
> --
> 2.19.1
>
>
