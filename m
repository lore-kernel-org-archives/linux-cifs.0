Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B383C76196
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Apr 2023 04:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjDGENg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Apr 2023 00:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjDGENf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Apr 2023 00:13:35 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335235B9B
        for <linux-cifs@vger.kernel.org>; Thu,  6 Apr 2023 21:13:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id k37so53240329lfv.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Apr 2023 21:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680840811; x=1683432811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ayCY8gnSzRVaLPlX69HunLAAxrpGlLKZnIoUUkKakI=;
        b=G3am6QtCc/ohzizao0JPiLpe5jex0BIOfdy7+tfEDRYRKwumPeM7UTmFkhxOSkS7xt
         fiHh/tLU/T+bFubDudvwLvwX5ebInUPh+PFfFdQnzlGNCfp3FelWGUSOo1nMBGY3U23s
         QHzivT99VepCzvxF8I3g1AG7d5moC/30iU4j7NjXzgz0KihLjwFJ77g5YqJc2JrK71Ld
         TGEorHKWfJrQbpbjE6r2BrsprUVghOQdT536ryiw48QGoCtjedEdwJPFnoJ5MojUhplb
         FnGFPJcGOTTxkjPXpWqgwhT2hX799lx96C/bh6Q9V4mxKt9Q4KOLJOSFSAk0HzX/cEOq
         iE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680840811; x=1683432811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ayCY8gnSzRVaLPlX69HunLAAxrpGlLKZnIoUUkKakI=;
        b=txRuaCnftexRwsa6sqb4CRauEfPpNKOCd7wHw1JdHW4x6gdq9naQNpvbiMtJZ0zotv
         xACxAzcTPVqABJKIZKK0Fd8rk9i0dNbQr7i8Wo632j0xUm2Gzr+hULzcXncfwy0+TDsW
         gHVylEK5OGluM0dlb1tMdmt2/WdLiNwG8UpCey+onTnjJ8ZRTJ8pfEzG9y2PbcvjKmji
         7N509rdsTDoC7fpgxYeD3OaQv9XL9VIj5G069Y7ymaRcQSC+FLiKr8VZSaq8atOlJz6o
         u4S0LbeZ6ZjQi2L/SPabHcWWUuSPofelY0tYHK3plzLR0LxYwUGv8cjnEW/a6spBkGqS
         fJjg==
X-Gm-Message-State: AAQBX9eZFV+wqmKp+9rxvfgu5JjQRlTe5GTjXWThkskbx3hOYb9FH3dk
        az9gxQ5BsqWGsR1sRr1sPeDNcVZ8BVMT3rq+nVY=
X-Google-Smtp-Source: AKy350bRswQc+Go4VLcS//oc6Km8D/aDmonvZzbB2PVC4ejAc8eEuZn7aAMOJPzFaH2SlE6OdF9KR4FpYY4fV7PFS8M=
X-Received: by 2002:ac2:4569:0:b0:4e9:22ff:948d with SMTP id
 k9-20020ac24569000000b004e922ff948dmr327215lfm.7.1680840811172; Thu, 06 Apr
 2023 21:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <6cf163fe-a974-68ab-0edc-11ebc54314ef@redhat.com>
In-Reply-To: <6cf163fe-a974-68ab-0edc-11ebc54314ef@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 Apr 2023 23:13:20 -0500
Message-ID: <CAH2r5msJtiGDuQcQdUkpamChTYNobUEVCax5GmHwpV0NbZOR0Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: reinstate original behavior again for forceuid/forcegid
To:     Takayuki Nagata <tnagata@redhat.com>
Cc:     sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next

Any thoughts on priority sending it upstream soon?

On Thu, Apr 6, 2023 at 7:06=E2=80=AFAM Takayuki Nagata <tnagata@redhat.com>=
 wrote:
>
> forceuid/forcegid should be enabled by default when uid=3D/gid=3D options=
 are
> specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
> changed the behavior. This patch reinstates original behavior to overridi=
ng
> uid/gid with specified uid/gid.
>
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
> ---
>  fs/cifs/fs_context.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index ace11a1a7c8a..6f7c5ca3764f 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -972,6 +972,7 @@ static int smb3_fs_context_parse_param(struct fs_cont=
ext *fc,
>                         goto cifs_parse_mount_err;
>                 ctx->linux_uid =3D uid;
>                 ctx->uid_specified =3D true;
> +               ctx->override_uid =3D 1;
>                 break;
>         case Opt_cruid:
>                 uid =3D make_kuid(current_user_ns(), result.uint_32);
> @@ -1000,6 +1001,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>                         goto cifs_parse_mount_err;
>                 ctx->linux_gid =3D gid;
>                 ctx->gid_specified =3D true;
> +               ctx->override_gid =3D 1;
>                 break;
>         case Opt_port:
>                 ctx->port =3D result.uint_32;
> --
> 2.40.0
>


--=20
Thanks,

Steve
