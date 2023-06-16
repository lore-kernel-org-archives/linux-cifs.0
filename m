Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EA8EB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Jun 2023 21:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjFPVRI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Jun 2023 17:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjFPVRI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Jun 2023 17:17:08 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050803581
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jun 2023 14:17:07 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b45b6adffbso13645051fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jun 2023 14:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686950225; x=1689542225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16ZOOl4MKo+7Cfvn4U3i/wwKezp4f+CpVB4U/SHrk1s=;
        b=dy0VmGSF4bDHy6YCSJ+0dCtN9q6VAbENir+K1fgLgB07ZXI63dpJMKFYlN9OX/mzrj
         KtYfeb6OagNzKXPtJ5Pbnv5StYHlKB71EghhOl22pstrGRwlOsNnyq7q2ofyO9gkjka+
         4vgrPt+AVBVSg5ALefWIh6XgtdJh/we4Sat5MKY3V7+SGu8l10a+yVO+KDn4/35gyQ8s
         GWOeISVlr+yeURqQlqKp+wbtIukiFAddX9nwx7BUBe5mvpRvuDMRSpe4OeSchjJ4wCEq
         vuEEqf8Vz7K5wNubVNN0EEeyjuHdVAIrHlfzDTj0RRzM3u7Phg0CKhszfs4yKZCNhTLP
         +0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686950225; x=1689542225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16ZOOl4MKo+7Cfvn4U3i/wwKezp4f+CpVB4U/SHrk1s=;
        b=ivoReVp/lc+kJtPDSXWyoxiSSuUwIZoEFPh6gy3pdw3w326oMkAShxuI1LWnRJE34D
         0Tlaf1+a99pEKbG2Ky+uzFo5rNxBi9iFunSBfeViW+EDKqB80AcfD0MI015SyRKKhQp3
         t4R75MuaQyQHA6sMDa5JmN7I3TsiZN2vBfOXRMQ9u89VPpDjSQjTr7qAui6cWdSUCoe3
         b2iXP1fRY0jHEJOkUWGDlO+FabkIInOAt3rUOhzEQ/d/JK4cQrl8vQDnhW8t5eV1l5NB
         8m1GP58RjOd9mjEyrOf5PZToOsz46c48vgtawHVOniHRsTSbyqZIjYekGbd59VWTC21K
         0kkQ==
X-Gm-Message-State: AC+VfDzD27FyjeEO2sX9VSQwt3sMMNEiYwK1/g+dsPB/3+Gz1NfcgIcB
        pAgpUURQHCumjcMOi7NJBfhpiEQjBVAY4Gt195Q=
X-Google-Smtp-Source: ACHHUZ6WEpxsAzz0HpJ8u/NlfwQ3Mx3t2AvctYdvXwLyJTyLjMryRF+lXc9NjKLUvsQfyq5r0CBZNZVA2m9mQ+tRHKQ=
X-Received: by 2002:a2e:b0ef:0:b0:2b3:be08:19f8 with SMTP id
 h15-20020a2eb0ef000000b002b3be0819f8mr2431821ljl.50.1686950224878; Fri, 16
 Jun 2023 14:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230616103746.87142-1-sprasad@microsoft.com>
In-Reply-To: <20230616103746.87142-1-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 16 Jun 2023 16:16:52 -0500
Message-ID: <CAH2r5ms9MwXs3hBY=OJWRdcTH629Db4rKDGx70MKdqu71yUisA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: print nosharesock value while dumping mount options
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, pc@cjr.nz,
        ematsumiya@suse.de, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

Note that nosharesock was being printed before, but only in
/proc/fs/cifs/DebugData not in /proc/mounts



On Fri, Jun 16, 2023 at 5:37=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> We print most other mount options for a mount when dumping
> the mount entries. But miss out the nosharesock value.
> This change will print that in addition to the other options.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 43a4d8603db3..86ac620a9615 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -688,6 +688,8 @@ cifs_show_options(struct seq_file *s, struct dentry *=
root)
>                 seq_puts(s, ",noautotune");
>         if (tcon->ses->server->noblocksnd)
>                 seq_puts(s, ",noblocksend");
> +       if (tcon->ses->server->nosharesock)
> +               seq_puts(s, ",nosharesock");
>
>         if (tcon->snapshot_time)
>                 seq_printf(s, ",snapshot=3D%llu", tcon->snapshot_time);
> --
> 2.34.1
>


--
Thanks,

Steve
