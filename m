Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA98C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Feb 2022 03:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348776AbiBCDca (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Feb 2022 22:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbiBCDca (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Feb 2022 22:32:30 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A110BC061714
        for <linux-cifs@vger.kernel.org>; Wed,  2 Feb 2022 19:32:29 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id q22so1951373ljh.7
        for <linux-cifs@vger.kernel.org>; Wed, 02 Feb 2022 19:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rifR8JYiq1RGWwua2ATPPPhzFaT/RzC0IagjomCuyHw=;
        b=mfLdREEW7nV5xN1x+0L85oKtWxkzzbrvT7+FjPNbbBkbWel0eY7GRR4WMfATjd/xMk
         UgnSpV3UqprTIoHVd13EeZorOtJlXa0oFYt2/zvpe49HNZFdh1wRyUIaLm9RCit/v+Pl
         BXu9gmwTnrDB08GV0IGxQf4LwFteWKN9Wmdi5o3cK9VlDbMJxunrclbSF25c7uY4vhld
         HDP1NJMs/cJVzfmrsF3kFIjq9M/wUsZil3T0ONlrj9UGs4pihFLghFjl1TH69N43AO1x
         BfcoakuJvknM+JK6EKLeXtRdhlwH240NW7FeaZ2qbHVZkJCM32e2cojpMd381EEcWC5r
         rm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rifR8JYiq1RGWwua2ATPPPhzFaT/RzC0IagjomCuyHw=;
        b=mx69ixlZH17i1kG+iX9FTvXbhjKIx4dGpTL4hKowSRmzeNzER2Bq90PaEbwRmrgytl
         JRof+ADDjEKjmWYY4TwU2n/izW08HzoR/OYapoXyEVmtfcDOZoOlHbizy1sAfPSVdHgg
         3x0csArkgnz7GcnRIbTKKEWG7c+plo3Gnzh/6TXdY76n0f/2DHM0ctRuJiheaisu8ucw
         mn57mLcXGc3KEM2a83k+I3IuhvJImjlL0kKXU3glby6pmVBkWqZ3E/fzrnyX1MvQlz6U
         inMM9DY0AnAbMpbZlZ5KUajBbgjApQ1vOduh+KzAQs41B2cLqSEOgFBwQoPypOkH1K0O
         wYuw==
X-Gm-Message-State: AOAM531nIKm8l25oK53idqIYuQZ0vUb7uXVeWt4P0sqNyhULAg2mrseQ
        bLFTjDHiv6MCS14t8iiEqx4Ss8Ce8Eu/SO8cdM4diEun
X-Google-Smtp-Source: ABdhPJzW5S4DYEo11S0qvmgiTINdve94m8XDqHeFvOZJ5u6pT2JpaQGX60QAyCqfdOQGhs9sJUlG1ncXY5qjQcr47VI=
X-Received: by 2002:a05:651c:1315:: with SMTP id u21mr21145923lja.398.1643859147165;
 Wed, 02 Feb 2022 19:32:27 -0800 (PST)
MIME-Version: 1.0
References: <20211222160405.3174438-1-ryandbair@gmail.com> <20211222160405.3174438-2-ryandbair@gmail.com>
In-Reply-To: <20211222160405.3174438-2-ryandbair@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 2 Feb 2022 21:32:16 -0600
Message-ID: <CAH2r5msgnA2hEJEz-VFJDJw-zgqiOwV8wSHO=BJb2re7GvAahA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix workstation_name for multiuser mounts
To:     Ryan Bair <ryandbair@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Missed this email thread during the holidays - will test it out later this week.

On Fri, Dec 24, 2021 at 5:07 AM Ryan Bair <ryandbair@gmail.com> wrote:
>
> Set workstation_name from the master_tcon for multiuser mounts.
>
> Just in case, protect size_of_ntlmssp_blob against a NULL workstation_name.
>
> Signed-off-by: Ryan Bair <ryandbair@gmail.com>
> ---
>  fs/cifs/connect.c | 13 +++++++++++++
>  fs/cifs/sess.c    |  6 +++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1060164b984a..cefd0e9623ba 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1945,6 +1945,19 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
>                 }
>         }
>
> +       ctx->workstation_name = kstrdup(ses->workstation_name, GFP_KERNEL);
> +       if (!ctx->workstation_name) {
> +               cifs_dbg(FYI, "Unable to allocate memory for workstation_name\n");
> +               rc = -ENOMEM;
> +               kfree(ctx->username);
> +               ctx->username = NULL;
> +               kfree_sensitive(ctx->password);
> +               ctx->password = NULL;
> +               kfree(ctx->domainname);
> +               ctx->domainname = NULL;
> +               goto out_key_put;
> +       }
> +
>  out_key_put:
>         up_read(&key->sem);
>         key_put(key);
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 035dc3e245dc..42133939f35d 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -675,7 +675,11 @@ static int size_of_ntlmssp_blob(struct cifs_ses *ses, int base_size)
>         else
>                 sz += sizeof(__le16);
>
> -       sz += sizeof(__le16) * strnlen(ses->workstation_name, CIFS_MAX_WORKSTATION_LEN);
> +       if (ses->workstation_name)
> +               sz += sizeof(__le16) * strnlen(ses->workstation_name,
> +                       CIFS_MAX_WORKSTATION_LEN);
> +       else
> +               sz += sizeof(__le16);
>
>         return sz;
>  }
> --
> 2.33.1
>


-- 
Thanks,

Steve
