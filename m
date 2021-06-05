Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27474C47082
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 20:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F14613B4
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 20:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFEUtZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Jun 2021 16:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhFEUtY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 5 Jun 2021 16:49:24 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50217C061766;
        Sat,  5 Jun 2021 13:47:20 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id w15so16284539ljo.10;
        Sat, 05 Jun 2021 13:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4cStJ2sFpNIdNUI9DcsT/mkiPPlBZuyp5QLWw6imaYc=;
        b=QtESuXB0PtZjtH++S1RRH4E4aeMpqIog64vtVlivI9L5aWQy/NYlOY0JA49Iw+7ruB
         BKExjUaGCxe5wpVFe4rgQ6s40cHFz+q7wkvol2BmHb3EvlPjfIu87j/ew8qM4sFSHXSc
         yC10oxqRrzS8ZjSaNB30O90jVXqqgrRdON695OlQI517wLSAS2GcZ1dJF1ZBDlWMnlHR
         myxj5iUt44PiHPs1Vak4acZiER0POYz0P+v+h2iFXFhBJJOFo8VPUowU2ACZUdn+yF8I
         MY+OzIQ094gBxShy3RU0hIjXRrdAmR7xOuctFT1Uwkel6tZpZ/hZj/6SXEisjciQfltf
         BTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4cStJ2sFpNIdNUI9DcsT/mkiPPlBZuyp5QLWw6imaYc=;
        b=cTKC1QOpnaOQd6PLdxsVxAvs7dhLvXVIuhJqnN4wUEfSaw6vw0h9Men6qsG6AQuydd
         jWn7tORAvi2TOnXarPbfsKQ9hP1fi10rIo1QdB0J2qGteS40/6bnhbOJu08YOHCdt3pT
         UnHd9bWvdNKYqluDkBziPW+wwPoQd8dayWD8jlzSbEOumJrH+ii2CK10llQVdAu7mdup
         Bmym2RDveHW1rV+mZlqKA+HYSkVWv1cU3DPhB2D+fyImrN0pZHubBKF49KFd5BFEecJA
         TGxUpBI6I9hvcFU5V0gKAthEwm4qMHSozFZ+3inE2pFyy2RMio3wTi0XMJJV9PBmHl+h
         T5BA==
X-Gm-Message-State: AOAM531IvTZxOR/b1JU06/PPF5xxRrFDDx/2JJI1WyyOT4Ir+c3LKO7e
        DJOkJSAe2kvBM9jvnCeDfe5MapIkwr0DrYgQBg/TDc14eg0=
X-Google-Smtp-Source: ABdhPJx8RG63VVbd8Ot5eXuzN6ZGihtg29eGHWgc2Ip+SPl7/7Ys16S0wZ78B06DRVQgEfhazZNZsB91mSc4gmxKiIk=
X-Received: by 2002:a2e:9a87:: with SMTP id p7mr3598873lji.477.1622926038656;
 Sat, 05 Jun 2021 13:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210526203545.13160-1-rikard.falkeborn@gmail.com>
In-Reply-To: <20210526203545.13160-1-rikard.falkeborn@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 5 Jun 2021 15:47:07 -0500
Message-ID: <CAH2r5muYv=tMkkX2bV0W3OU7Z8GLPwiekh_6D0pPQp+ybhmuMQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Constify static struct genl_ops
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Samuel Cabrero <scabrero@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, May 26, 2021 at 4:06 PM Rikard Falkeborn
<rikard.falkeborn@gmail.com> wrote:
>
> The only usage of cifs_genl_ops[] is to assign its address to the ops
> field in the genl_family struct, which is a pointer to const. Make it
> const to allow the compiler to put it in read-only memory.
>
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> ---
>  fs/cifs/netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
> index 5aaabe4cc0a7..291cb606f149 100644
> --- a/fs/cifs/netlink.c
> +++ b/fs/cifs/netlink.c
> @@ -30,7 +30,7 @@ static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
>         [CIFS_GENL_ATTR_SWN_RESOURCE_NAME]      = { .type = NLA_STRING},
>  };
>
> -static struct genl_ops cifs_genl_ops[] = {
> +static const struct genl_ops cifs_genl_ops[] = {
>         {
>                 .cmd = CIFS_GENL_CMD_SWN_NOTIFY,
>                 .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> --
> 2.31.1
>


-- 
Thanks,

Steve
