Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761AEC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Feb 2022 08:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiBLISJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Feb 2022 03:18:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiBLISJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Feb 2022 03:18:09 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7A426AF3
        for <linux-cifs@vger.kernel.org>; Sat, 12 Feb 2022 00:18:06 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id o19so31309241ybc.12
        for <linux-cifs@vger.kernel.org>; Sat, 12 Feb 2022 00:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFXN4Dxkc1IKs0rvjt8ky7qrC4NrKBZNQVEiNoa1qMY=;
        b=cQ0avBkTHQtQINV89+dhSFs5A+3AXgyNl91Yx5rsHco4+aOiOUQRRzzoyBVLUHCSG6
         JcqeW36shTLc3ZQOPFdZngri/vL/SM0pKZ0GHk9FkCJXxOuAtK/Ebio6RyatmOXx0+zO
         PW34w5RerewDOqjDZe4zsrmDdvirmQZVUfdsKVLzjPbymyFv2mc+BerH8LOmMEZ/ZTc+
         nTOGNE1y8ooBYZ0H8hloAqMkI6EL75yjvklZo6Anh3W+uDZLk8hjP+x6vPIq/ZL23Fzx
         cayVZlZCectzs8HellBLHJJfNf0EeCNKoin4mVTiYnhVh/p0HITBazA7+Qjdi4M7ukMs
         nQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFXN4Dxkc1IKs0rvjt8ky7qrC4NrKBZNQVEiNoa1qMY=;
        b=alelj/1ngfpl0UsbMvybvQhXEZJNHqwGWe0gAEDwvF7KEVuwjiHxLgHA7kKOHA9iP9
         qIP+vq2VU5QG89NI5gPLqoIQx+wW19XFhxd2NRcEd07OikYpXJY4ptzd79k7uKSmfJRP
         hkWMH6eryoTuOsh1N1kM7yXSRilDThFTxwDewhAhNT+aEBwnyLSCcWJeyVJ1SXauTCj3
         A2YkAfsUApd3WK/XLNRYtcpi81LKbaXHOqCtQqZCuRjFIeWVhtminAIFGnYzUXVRAO1Q
         fRGAh+TdVZAvKg4nPcUJz40Tc6znNn9ma23SiEjhvhOytQSRkQ5NbX2R0PGmUDxtD7I6
         SiRw==
X-Gm-Message-State: AOAM530E4LEktPnloJgcLKURUnXA8oMvMao0A9ZrzKGjPkM+QC857gzO
        hryM4YbPkeP+K+W5Qo8B6qLknOKteDFllrdpk2w=
X-Google-Smtp-Source: ABdhPJylEbSF+59v+HEXcbC+/GSniNnYSYGnGjMXqRBD6Of51dCnBIPiBnD9P+b4FbFv1JQrgFMkh6DtLcF1V9l3shc=
X-Received: by 2002:a81:c502:: with SMTP id k2mr5528809ywi.424.1644653885510;
 Sat, 12 Feb 2022 00:18:05 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtB05z7j45H4LRYGE8LUcyTL-17bacB=zm9LO5nZcvPgQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtB05z7j45H4LRYGE8LUcyTL-17bacB=zm9LO5nZcvPgQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 12 Feb 2022 18:17:53 +1000
Message-ID: <CAN05THSM3by6AJCSGRxcL+nJmYChvt=EROEwJ9Z6NfY+evz+XA@mail.gmail.com>
Subject: Re: [PATCH] smb3: fix snapshot mount option
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, ruckajan10@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by me

On Sat, Feb 12, 2022 at 6:06 PM Steve French <smfrench@gmail.com> wrote:
>
>     The conversion to the new API broke the snapshot mount option
>     due to 32 vs. 64 bit type mismatch
>
>     Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
>     Cc: stable@vger.kernel.org # 5.11+
>     Reported-by: <ruckajan10@gmail.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 7ec35f3f0a5f..a92e9eec521f 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -149,7 +149,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
>         fsparam_u32("echo_interval", Opt_echo_interval),
>         fsparam_u32("max_credits", Opt_max_credits),
>         fsparam_u32("handletimeout", Opt_handletimeout),
> -       fsparam_u32("snapshot", Opt_snapshot),
> +       fsparam_u64("snapshot", Opt_snapshot),
>         fsparam_u32("max_channels", Opt_max_channels),
>
>         /* Mount options which take string value */
> @@ -1078,7 +1078,7 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,
>                 ctx->echo_interval = result.uint_32;
>                 break;
>         case Opt_snapshot:
> -               ctx->snapshot_time = result.uint_32;
> +               ctx->snapshot_time = result.uint_64;
>                 break;
>         case Opt_max_credits:
>                 if (result.uint_32 < 20 || result.uint_32 > 60000) {
> cifs
>
> --
> Thanks,
>
> Steve
