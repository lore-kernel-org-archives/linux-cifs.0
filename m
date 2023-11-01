Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1475C4167B
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Nov 2023 02:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345397AbjKAC6P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 22:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345437AbjKAC6O (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 22:58:14 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF96C2
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 19:58:12 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2c5056059e0so90551351fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 19:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698807490; x=1699412290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDeH/zmKEt+sZEk7gFTaaeJKL44ARjqAtk/xn8KWC54=;
        b=mS/MI/n5fVCNl+WruV4zUgEg0hGmmP+64our5fKC/O9sEVacmSPjycM5vsiyZv5KnN
         OLFNiBFyivI3Y5c2CXeXVKqQRx0Jxk1Ujvm0gk8q2dCsecf5AKmm1lC8WzYq/bilCp1h
         9SmPBE/IdJ6gstu+s2j+dxwsXcGpwyqr2rUFmZnFtuOuKr1RIaWKBU1DmHAwN23XYVK/
         M1lvMUOnWYIeR0HSPwhKMgK1VJQREkgxyfno/CUfoT3R6wnSaLAfKQz9P2XbuRXB6Mjq
         2rlFcY0JZR9nY+ma8MfK4Z3cC0mLPTa8gn4C9VYyhZ59p4mgDQb62gNkeXhJCUFnIxgb
         OMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698807490; x=1699412290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDeH/zmKEt+sZEk7gFTaaeJKL44ARjqAtk/xn8KWC54=;
        b=OBrQKiXumAkxNtIrx74OMzQEkIUgJ66Fr3L47uHJSbRgjNkcnZfG8gzgplq1c9SflJ
         MiUHRmMOczYK6sViuqamlGxnW+MfioDq1KcTeYNRBxodIzuEGqRmtcAIEuGyVWRy5mSZ
         ehd9I8zYAdYxrQsP6fMht5q1/K5G8p9CCMUkDYivRbXkGSQkVxNtguvMO7V/RVW3rHOc
         SzU4mc4vv4ZdKrL9UIZ3tD9g+elpfPWg1pECTHoSLLS0F18dyJYfBWss/M6A6PbOd3i3
         cPxv6QbCasZNAjMdJgXDY34scFJtNobnwlXZGw59Gv1HaaE2+uHkRzyDcutFtA25a9EM
         ZSdA==
X-Gm-Message-State: AOJu0YySfEmOiLwQZc3HKF2zy7ydXGl6kAY/OYJ4Smc5bAH3fy6fb18c
        t24dAwfXNXDf2RDWzUUF/fvyyn6xRC72lRc7Rgg20UouZzo=
X-Google-Smtp-Source: AGHT+IGgI35EhkVFXouQJS73D8iGKrBEHLNNy2sFeKRU/gfxu+qwVJSpz7sS+rINYP5iWJMX/CtMU45XJYfoVZBrKCU=
X-Received: by 2002:ac2:4423:0:b0:503:2e6:6862 with SMTP id
 w3-20020ac24423000000b0050302e66862mr9608062lfl.32.1698807490050; Tue, 31 Oct
 2023 19:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-4-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-4-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 21:57:58 -0500
Message-ID: <CAH2r5mtnktKkoSmCeLLpSFktWJ-kPS_uhTSy1_nvtWwG6UbOiA@mail.gmail.com>
Subject: Re: [PATCH 04/14] cifs: do not reset chan_max if multichannel is not
 supported at mount
To:     nspmangalore@gmail.com
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending more testing

On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> If the mount command has specified multichannel as a mount option,
> but multichannel is found to be unsupported by the server at the time
> of mount, we set chan_max to 1. Which means that the user needs to
> remount the share if the server starts supporting multichannel.
>
> This change removes this reset. What it means is that if the user
> specified multichannel or max_channels during mount, and at this
> time, multichannel is not supported, but the server starts supporting
> it at a later point, the client will be capable of scaling out the
> number of channels.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/sess.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 79f26c560edf..c899b05c92f7 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -186,7 +186,6 @@ int cifs_try_adding_channels(struct cifs_sb_info *cif=
s_sb, struct cifs_ses *ses)
>         }
>
>         if (!(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> -               ses->chan_max =3D 1;
>                 spin_unlock(&ses->chan_lock);
>                 cifs_server_dbg(VFS, "no multichannel support\n");
>                 return 0;
> --
> 2.34.1
>


--=20
Thanks,

Steve
