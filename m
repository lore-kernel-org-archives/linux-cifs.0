Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5ACDC433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC606115C
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhDIES2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhDIES1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 00:18:27 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896B8C061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 21:18:15 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j18so7588578lfg.5
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 21:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0V22YQzfuUMOz/TxoEHZMx3BSmUtgXRFWlQ24Nilo9A=;
        b=XlUVN8zoohSAKwejncOXhuMXGwltHPpvonJ3OxpHQ3yyavqAn3MvhNHs/stVj2RnZa
         j37n9H79GLGNhtG0BnJBgNnDrsUG+6ctlAzQvs9hVmZe31vykRv+izl0v72InKllw83J
         EAKtCoyzFLlk1Vwwu6ADmkD5rXV2FlQZbYsO1eq8gx4sIaZGaDXA3o6CyYxo+0W8RO2i
         M3pU/hBgcIGKYZMBQoecjIlxvfe4JlFLzqNrEjRgyGHhkHddsLuyaLNsROOidhNcqO9P
         3efkv5B10Ipt7BuqtOt6H4zEW/IgvikPQ1IjNVgTdPn3RXsK64LYJnpik3Bt/Ez5tgc/
         2GMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0V22YQzfuUMOz/TxoEHZMx3BSmUtgXRFWlQ24Nilo9A=;
        b=ZH7+zQFfB+PRzY7TF6Jd8WWNuTPMX4s9wKmbZDYh2QjlzibKMzAO787n54SMMacdhD
         Cct60SvhdZvLNNfpHK4kVgHqk67VeDvJZLHT0zCf2JtAM8Ws/9kf0xNG8l2RwV/WZQ6W
         6Jbjf3fP2vx5UmlsbT10v7wfZrYKIoRvcnJQr37YLuisKJiNPxLkJfT3v1wpp67Hn6tK
         zBcLNXeq3rjQenWmjfFNSATkR1d4blUbDdjUZlHxCNYbBZoawvD7c8shs1ijzKYRHKE2
         iWgR0pcXXN04ggCIdCp//mGCESxzvIi0ZF5DPMpfQEHTQ8Ad2vKxzR34I6QE6G7Bqy9D
         kGkg==
X-Gm-Message-State: AOAM531TaulCyVFVmhXKpShWL2LVO0pXVZzxONQBKK2leqAQkFTOE7YS
        1HILHnSZHyJ0jMcJ60YBHCRnjd6s/2aA95sHPlZlIlpsz/I=
X-Google-Smtp-Source: ABdhPJwr1xr5Cbfy1SVrUZEn/Iis7Vhno/ITLzi6k9qjLDI/orvujqT1GsjmqnPi3wjiwFOcAgOlfvajGSVQ4xajSNE=
X-Received: by 2002:a19:5513:: with SMTP id n19mr3838741lfe.313.1617941894041;
 Thu, 08 Apr 2021 21:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <DM6PR10MB3833F0DD867BF1B48F60B99FA2769@DM6PR10MB3833.namprd10.prod.outlook.com>
 <87eefn4hdt.fsf@suse.com> <DM6PR10MB3833579F43D640A69C4A39F8A2769@DM6PR10MB3833.namprd10.prod.outlook.com>
 <87blaq41uc.fsf@suse.com>
In-Reply-To: <87blaq41uc.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 23:18:03 -0500
Message-ID: <CAH2r5mum-b1MS4JNQSrs5HatgmcsPfpJfs7RbkkUN5vhoB2=Bw@mail.gmail.com>
Subject: Re: [PATCH cifs segfault ]
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Seth Thielemann <sthielemann@barracuda.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch didn't apply (presumably due to whitespace issues) - can
you resend it (can be sent offline if you prefer) as an attachment?

I also want to run it with checkpatch/sparse etc.

Also let me know if you see any issues with the read path

On Wed, Apr 7, 2021 at 4:03 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Seth Thielemann <sthielemann@barracuda.com> writes:
> >   This definitely could be a bug with the compiler, I ran into issues a=
dding some printk's and things just magically worked and then changed to ad=
ding asm volatile nop sentinel's to make sure I was looking at the correct =
sections. I still think it's a reasonable change to use the ssize_t since t=
he rc is a ssize_t and the outbound syscall path is also a ssize_t. Best ca=
se scenario is a segfault in userspace (made things easier to track down), =
but will likely wind up with memory corruption otherwise.
>
> Looking at this more I found that commit 97adda8b3ab7 fixed a very
> similar issue:
>
> -       ctx->rc =3D (rc =3D=3D 0) ? ctx->total_len : rc;
> +       ctx->rc =3D (rc =3D=3D 0) ? (ssize_t)ctx->total_len : rc;
>
> I think the logic is that compiler sees the "then" part as unsigned and
> so casts the "else" part to unsigned as well.
>
> In any case I think the change is good. We could change rc type in the
> read path as well.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
