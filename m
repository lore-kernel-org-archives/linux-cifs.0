Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C555C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Oct 2022 05:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJFFVt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Oct 2022 01:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiJFFVs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Oct 2022 01:21:48 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5038A1FE
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 22:21:35 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id 126so939706vsi.10
        for <linux-cifs@vger.kernel.org>; Wed, 05 Oct 2022 22:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uUNMT1etW8Fo9M7Ao/+V1tF9UzwXZ1FjaBxoonQkCug=;
        b=oC5Khgf5UvVc0Sf/YMxjGyFcspe4gGdCWGiubqSrku7ffXsysbsOwaZVL3hLFIHzvp
         A952mxKS6tYprABvS4q4jyu1xcjis6pJ6eunLSDKavCibU/bR27+TpjTLMnNuPkH0yBt
         k62ocjnjvaAXH+APpqDlY1/QEgXBiBpn8HL4+5tg+xKZDBDnE5xVs3wiJMe6QkQ/p0op
         JZ895qwsvyT5tbTHzdP+bQWKlYH0Q0EtKYKw1b8YZkag07zHT4HEng78UpGaFhEbyl9n
         0B3YcdUKfaYJjhPygG/mOyap3vRFIQ5AGO0R6PQ7788DDELOCP/29MJ2oCYLRhTO6HPR
         2mEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uUNMT1etW8Fo9M7Ao/+V1tF9UzwXZ1FjaBxoonQkCug=;
        b=dFdyoanLxclI1cs1tPgHoTiNaLpHaaBW+h9rN5ZmuIu+AEsuXRtU4KN5oV7MUJbDwQ
         T773qyHTwLrRq4sOTivRn552B9h4qckfKJKM0cQaeUTuw3TxUF+j8UqZjW28TTOQHFaH
         ij2lvmVsOHmeBs3C/WX8nvS6yK3d5QnBTGnb+GujMiG77Bo1+AoCCXC0OhyLD/Srw/Sa
         qNSCg6FFT49REMVTmfpcE/x6mwbmQif0sGrVJoL8n3fuLvXH42lCwDllRHdUft2VeMY7
         JpNv8qIBX1V4hvYOP7DRE7eHiINJaKvJhwljEOUy13ECammCcgbzsydj0HseFpX0jSsa
         56mg==
X-Gm-Message-State: ACrzQf1l3BmZfEitojhX093HqbFOOS9l7ft29VFifFADiWFq0tbw/fkq
        KDstRjTm2G0nJtc4P+Eo8hD+3g/qfDkdPwd6E6cu56Nl
X-Google-Smtp-Source: AMsMyM53jIo+ZSzJKIzlrlz5fORIFNVj1vmapcz74xj/71zGjpLEj8m2LVqiKytf6KyapakRerYWoE3HplNKAVoPET4=
X-Received: by 2002:a05:6102:c52:b0:3a6:b386:bc01 with SMTP id
 y18-20020a0561020c5200b003a6b386bc01mr1799632vss.17.1665033694087; Wed, 05
 Oct 2022 22:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20221006043609.1193398-1-lsahlber@redhat.com> <20221006043609.1193398-2-lsahlber@redhat.com>
In-Reply-To: <20221006043609.1193398-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 Oct 2022 00:21:23 -0500
Message-ID: <CAH2r5mthpPrijJkHCPssCbXy76V=b-FWnsBP1GZkyD_frztkaQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively added to cifs-2.6.git for-next pending testing

On Wed, Oct 5, 2022 at 11:36 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> When application has done lseek() to a different offset on a directory fd
> we skipped one entry too many before we start emitting directory entries
> from the cache.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/readdir.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 8e060c00c969..da0d1e188432 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -847,9 +847,13 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
>         int rc;
>
>         list_for_each_entry(dirent, &cde->entries, entry) {
> -               if (ctx->pos >= dirent->pos)
> +               /*
> +                * Skip ahead until we get to the current position of the
> +                * directory.
> +                */
> +               if (ctx->pos > dirent->pos)
>                         continue;
> -               ctx->pos = dirent->pos;
> +
>                 rc = dir_emit(ctx, dirent->name, dirent->namelen,
>                               dirent->fattr.cf_uniqueid,
>                               dirent->fattr.cf_dtype);
> --
> 2.35.3
>


-- 
Thanks,

Steve
