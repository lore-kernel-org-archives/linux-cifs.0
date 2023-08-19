Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B6DEE499C
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Aug 2023 03:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjHSDhw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Aug 2023 23:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjHSDhl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Aug 2023 23:37:41 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBE69B
        for <linux-cifs@vger.kernel.org>; Fri, 18 Aug 2023 20:37:40 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2ba0f27a4c2so23397751fa.2
        for <linux-cifs@vger.kernel.org>; Fri, 18 Aug 2023 20:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692416258; x=1693021058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tp42jAIOh6It5oyqUGVEGf4lTmeeJfFmoUI9UchpXw=;
        b=cOUxsLcpJ4sff0834dNoCwWBBUynwNzjet5pXzQjRnkEjPcaoeiT+8UpK1zq4SV5jk
         eFiET1F1XbYAfRMNWFwd59RCpg43AHmTL+hSups09jLQLPGfonwNSMQx3BCyS09EB6Sq
         1abmC2MaPWTOxSdddl7agCt3rlrkjMIvDgk9Ia3fQZJsI+3ffU9K36ew4P1ht7kEaOd4
         Lgougem2D+fTUX2s+2ChpcbPRmReTZhhnolFN0rTLmlVOKFCQ3bN33jSK68gVJic4PJx
         nnRLBMdXEQgERDEjrsGAhZnKwLqKuA5Fs2JKdVrzzKQrP9TEdsMWZZ/Jx3IQVRIAv/9P
         nXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692416258; x=1693021058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6tp42jAIOh6It5oyqUGVEGf4lTmeeJfFmoUI9UchpXw=;
        b=Jbd9Td0yfzub0uT8UAl1ht9LqssE2PMjzu0J0xzjbuP1Yaf70HXMg/n2+BBQVDMtSe
         rcJfweKSsF9dRlPyCKUIgsgHWj3Dwc9yy8it21ECf1dLuqsNhBuBrNXbFjITKEEbCXs+
         PRPVUuI6v+RumpJQmnpvhnQJW645jQ0azDx7N17EOX2iO9Sd7ov2Ju899dFVn44AzxVB
         WqmP2STGnD7x0YGK9uMQCbtQk90SiejrwOjq53MBbQpbpeu78LX4OY3RiDV3rXv7XpCw
         jnjLK7Lq/KLu5tIBXipdoDceEsigy2jU8AAWYfkUzS1rq9vWObMvX2Q8W4u2lEOvJt3f
         8WqQ==
X-Gm-Message-State: AOJu0YxwIraeCyCSdMnFAF1yVefBInpH8MXMIACyel7C47T/ogQJ/9+7
        fzR9myt0TSFg85q6RI40sS6wy9ubRV8rcQPwlNU=
X-Google-Smtp-Source: AGHT+IFflEn7KTVH/bLGxwbttP77d7UGVgE/aHxoGOk5kFWRnr0j02qlil8NqJDR1jPLu9kZSYAwzCYxL2vucr9fiSE=
X-Received: by 2002:a2e:6e0e:0:b0:2bb:8eea:7558 with SMTP id
 j14-20020a2e6e0e000000b002bb8eea7558mr642664ljc.13.1692416257912; Fri, 18 Aug
 2023 20:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230817153416.28083-1-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 18 Aug 2023 22:37:26 -0500
Message-ID: <CAH2r5mtmVF-f+rBGauyScVfrKC4Xi3TaTRYaQgbPR+hGf8gRpg@mail.gmail.com>
Subject: Re: [PATCH 00/17] cifs.ko fixes
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively added to cifs-2.6.git for-next pending testing.

Opinions on whether any should be cc:stable?

Also let me know if anyone wants to add RB or Acked-by

On Thu, Aug 17, 2023 at 10:35=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Hi Steve,
>
> Follow patchset with DFS, reparse point and -Wframe-larger-than fixes
> for v6.6.
>
> Please review & test.
>
> Paulo Alcantara (17):
>   smb: client: introduce DFS_CACHE_TGT_LIST()
>   smb: client: ensure to try all targets when finding nested links
>   smb: client: move some params to cifs_open_info_data
>   smb: client: make smb2_compound_op() return resp buffer on success
>   smb: client: rename cifs_dfs_ref.c to namespace.c
>   smb: client: get rid of dfs naming in automount code
>   smb: client: get rid of dfs code dep in namespace.c
>   smb: client: parse reparse point flag in create response
>   smb: client: do not query reparse points twice on symlinks
>   smb: client: query reparse points in older dialects
>   smb: cilent: set reparse mount points as automounts
>   smb: client: reduce stack usage in cifs_try_adding_channels()
>   smb: client: reduce stack usage in cifs_demultiplex_thread()
>   smb: client: reduce stack usage in smb_send_rqst()
>   smb: client: reduce stack usage in smb2_set_ea()
>   smb: client: reduce stack usage in smb2_query_info_compound()
>   smb: client: reduce stack usage in smb2_query_reparse_point()
>
>  fs/smb/client/Makefile                        |   5 +-
>  fs/smb/client/cifsfs.c                        |   2 +-
>  fs/smb/client/cifsfs.h                        |  11 +-
>  fs/smb/client/cifsglob.h                      |  69 ++-
>  fs/smb/client/cifsproto.h                     |   9 +-
>  fs/smb/client/connect.c                       |   8 +-
>  fs/smb/client/dfs.c                           | 291 +++++-----
>  fs/smb/client/dfs.h                           | 141 +++--
>  fs/smb/client/dfs_cache.c                     |  10 +-
>  fs/smb/client/dfs_cache.h                     |  12 +-
>  fs/smb/client/dir.c                           |   4 +-
>  fs/smb/client/inode.c                         | 530 ++++++++++--------
>  fs/smb/client/{cifs_dfs_ref.c =3D> namespace.c} | 113 ++--
>  fs/smb/client/readdir.c                       |  23 +-
>  fs/smb/client/sess.c                          |  68 ++-
>  fs/smb/client/smb1ops.c                       |  26 +-
>  fs/smb/client/smb2inode.c                     | 199 ++++---
>  fs/smb/client/smb2ops.c                       | 283 +++-------
>  fs/smb/client/smb2proto.h                     |  17 +-
>  fs/smb/client/transport.c                     |  29 +-
>  20 files changed, 993 insertions(+), 857 deletions(-)
>  rename fs/smb/client/{cifs_dfs_ref.c =3D> namespace.c} (62%)
>
> --
> 2.41.0
>


--=20
Thanks,

Steve
