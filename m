Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC57C636CC
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 17:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjAaR2P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Jan 2023 12:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjAaR2O (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Jan 2023 12:28:14 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6572FBBAB
        for <linux-cifs@vger.kernel.org>; Tue, 31 Jan 2023 09:28:13 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id j17so25356562lfr.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Jan 2023 09:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H+XcA4dML2u+oluAdEXsPzVq5p3cwf14adc31tRZv8M=;
        b=DNxSBSBEDY590nmvr8IQtX/jtvzYeJTCU66gMr4FgMnKUacGCH/2smnj3NABukK3my
         BPB16lYT/IB7WZmwP5sayHR5AmP7cPYO5EmE0fj2EUBqYzJyx/5UJyfBG4xBts6CrsPN
         q3UDKmD2gQzogD9MtB8MPGb86hvPVjM5Vfbd+eqj+VkAzZhSBs2UpIvuxcm9pbEGnLp+
         f4w1978EsLFGUAlmeStsCE1S8HlONt1/jqfh7k4SqgEZOTzJthNAjdcCf+2tCqjdrcaB
         ZmnVaYd0G5uAKm6q2SFq8nU8Lo6np9KkAjXpDHB98CXVrw3f/PByScNcL0uwITo6qyK/
         GMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H+XcA4dML2u+oluAdEXsPzVq5p3cwf14adc31tRZv8M=;
        b=e8uYuZnayub5YFg+QXdFRwDPkbLrJSGPaOlaTqO7/cz9XNGZCVGYYtXq+beB+vaK8u
         29sRRD/bXTltY0RQHnF2rvoZ1xf7Ww76V8AUzEXqdCf+vCTwMMhEAq/Xnw4BjGxQlTNK
         Ifqtsf67CXO3zhYhjLEZ9L/lFdcYWQF6WPjeH+TukHKOkdXeOUuhz/qs4prPCW/AZ1UE
         d2jS4LsYnqDoAuCffD6MyeO4E7fTEiL3wYfwGikuTX67UuEEV/Wx6uD/Yh2fg/V0XGKe
         /ifLqlvP4OEiioOLOVLn72z1tFufYiVyozLF5kuL6/AWj3iRmfosi4VzluSxR08H10j4
         k37Q==
X-Gm-Message-State: AFqh2kpJUW5DIo3hbg6A0wBNG1QDchV3euzRD3pLk+nxdH9+j1Ppr1wQ
        l6F/3R3/NntN0CnvwoYQD2obfnRXQcCZlZ/AajY58EQ0
X-Google-Smtp-Source: AMrXdXt4Z8JAZ+cUMD1OwJhoTaBRuJqS3CKmf1fNe0OhUAvhcI5iElaLQ2ri5Tj4QRVd6UMp+nZwPFHpKkhFdwjjOEc=
X-Received: by 2002:ac2:5228:0:b0:4d5:7953:a4e4 with SMTP id
 i8-20020ac25228000000b004d57953a4e4mr4065866lfl.65.1675186091358; Tue, 31 Jan
 2023 09:28:11 -0800 (PST)
MIME-Version: 1.0
References: <20230131162207.3511-1-pc@cjr.nz>
In-Reply-To: <20230131162207.3511-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Jan 2023 11:28:00 -0600
Message-ID: <CAH2r5msU4cjJg-uK2EOYovOBFBpR8j8ZLdFjr6TJNenQn1q9Xg@mail.gmail.com>
Subject: Re: [PATCH] cifs: get rid of unneeded conditional in cifs_get_num_sgs()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added David Howell's RGB and tentatively posted to cifs-2.6.git
for-next pending testing

On Tue, Jan 31, 2023 at 10:22 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Just have @skip set to 0 after first iterations of the two nested
> loops.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsglob.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 3da302ea9d76..1d893bea4723 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -2164,6 +2164,12 @@ static inline unsigned int cifs_get_num_sgs(const struct smb_rqst *rqst,
>         unsigned long addr;
>         int i, j;
>
> +       /*
> +        * The first rqst has a transform header where the first 20 bytes are
> +        * not part of the encrypted blob.
> +        */
> +       skip = 20;
> +
>         /* Assumes the first rqst has a transform header as the first iov.
>          * I.e.
>          * rqst[0].rq_iov[0]  is transform header
> @@ -2171,14 +2177,9 @@ static inline unsigned int cifs_get_num_sgs(const struct smb_rqst *rqst,
>          * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
>          */
>         for (i = 0; i < num_rqst; i++) {
> -               /*
> -                * The first rqst has a transform header where the
> -                * first 20 bytes are not part of the encrypted blob.
> -                */
>                 for (j = 0; j < rqst[i].rq_nvec; j++) {
>                         struct kvec *iov = &rqst[i].rq_iov[j];
>
> -                       skip = (i == 0) && (j == 0) ? 20 : 0;
>                         addr = (unsigned long)iov->iov_base + skip;
>                         if (unlikely(is_vmalloc_addr((void *)addr))) {
>                                 len = iov->iov_len - skip;
> @@ -2187,6 +2188,7 @@ static inline unsigned int cifs_get_num_sgs(const struct smb_rqst *rqst,
>                         } else {
>                                 nents++;
>                         }
> +                       skip = 0;
>                 }
>                 nents += rqst[i].rq_npages;
>         }
> --
> 2.39.1
>


-- 
Thanks,

Steve
