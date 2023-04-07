Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44AEC77B6E
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Apr 2023 10:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjDGKOU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Apr 2023 06:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjDGKOT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Apr 2023 06:14:19 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271DC9004
        for <linux-cifs@vger.kernel.org>; Fri,  7 Apr 2023 03:14:18 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id sg7so7385979ejc.9
        for <linux-cifs@vger.kernel.org>; Fri, 07 Apr 2023 03:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680862456; x=1683454456;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0Dh6ojJ1aLo61oAOPLHDys23msr377LbLwQmvUkIACk=;
        b=OOnBrmgkvKwMuPxuUzXeqTI54QW/7T3fDO1aYHt+nWr3jp6FFfynu1F8Jh6kNwQsmK
         gF7cKLFDajyULHAmxiFB94h50n4oRXZJYKrhPS4SKgOsUw63SN3Wuz86CbccpA13O4qC
         +YZEH/Bdw8vEpdi4MTcYSa5DrnUrBhfBB4rg+g5dQJZ6Iu2paM1f7uGI/oxqb8ZY2X3a
         RNs0xqmvLHyubMv4+1XYl5DVz5fbwJqCfH4Q0bXU79PlDcPhNIXG5reRxpBZcbhb8fM7
         bZ0NTrwR7lUQdBy5OGVLxWYOB3SvcOyzH7ieOSR9iGweOVecG00o2Zwiw1i8oOLBuj+u
         EXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680862456; x=1683454456;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Dh6ojJ1aLo61oAOPLHDys23msr377LbLwQmvUkIACk=;
        b=nICXr7tCsuCqdMry6VdrTwfZIqUfmEG9XkAdSInB2IfisLbRkrcrm+ke6HdNoSIK4E
         gJs8s2WG8tJq3xUeiaQj9D+gBNffQV6DDidzBQwoeCdpr8nCQW0yp7t7OZYAuHsp7UIa
         +PMV13uU7ehTb93y2H4Rlxwb2JN729JJV0bR+P0k5eUwA5ZJou7d5Hu/9EvTJwNbO4SM
         w18nEgT80O3tmo5k9T4D48rZo07M0Pgy6PZwoZQEID67+Xxzc+MMCNwS/BX/MBwLscEg
         +ne0vjBCVrS3UENFo7PsFZhr5L0dVPez8fFmZnYM7nS3DGSwRPmp2+AkDXn7njY9HyM7
         shwA==
X-Gm-Message-State: AAQBX9cQifK4hTVY/VT8r5TR8lwzGDUIt0MA6iOjQPce1q3vE+zDWN23
        KZHlfJ2opIzWkYzuT0s/SExmPIETd7goKrmVGuI=
X-Google-Smtp-Source: AKy350bbs3q+gqoTfvRGsZnf3KurJm+o/nwFKA8YK2UQxqR9LJdFgwOnS+HXqWQYQOA/e80ID2sew9Pq3HRs2NLXSBg=
X-Received: by 2002:a17:906:802:b0:8b1:3298:c587 with SMTP id
 e2-20020a170906080200b008b13298c587mr911297ejd.2.1680862456649; Fri, 07 Apr
 2023 03:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <1efcd842-b6a3-353a-0bf9-3ebf890eb712@redhat.com>
In-Reply-To: <1efcd842-b6a3-353a-0bf9-3ebf890eb712@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 7 Apr 2023 20:14:04 +1000
Message-ID: <CAN05THRJb_4edm9Hne1yY3D6VvtQ=CbYn+KhVy7Xw=i4GE-c+w@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: reinstate original behavior again for forceuid/forcegid
To:     Takayuki Nagata <tnagata@redhat.com>
Cc:     sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.
The question arises, are there any situations where forceuid is
meaningful without uid= argument and what would it mean?

On Fri, 7 Apr 2023 at 15:09, Takayuki Nagata <tnagata@redhat.com> wrote:
>
> forceuid/forcegid should be enabled by default when uid=/gid= options are
> specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
> changed the behavior. Due to the change, a mounted share does not show
> intentional uid/gid for files and directories even though uid=/gid=
> options are specified since forceuid/forcegid are not enabled.
>
> This patch reinstates original behavior that overrides uid/gid with
> specified uid/gid by the options.
>
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Acked-by: Tom Talpey <tom@talpey.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
> V1 -> V2: Revised commit message to clarify "what breaks".
>
>  fs/cifs/fs_context.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index ace11a1a7c8a..6f7c5ca3764f 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -972,6 +972,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>                         goto cifs_parse_mount_err;
>                 ctx->linux_uid = uid;
>                 ctx->uid_specified = true;
> +               ctx->override_uid = 1;
>                 break;
>         case Opt_cruid:
>                 uid = make_kuid(current_user_ns(), result.uint_32);
> @@ -1000,6 +1001,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>                         goto cifs_parse_mount_err;
>                 ctx->linux_gid = gid;
>                 ctx->gid_specified = true;
> +               ctx->override_gid = 1;
>                 break;
>         case Opt_port:
>                 ctx->port = result.uint_32;
> --
> 2.40.0
>
