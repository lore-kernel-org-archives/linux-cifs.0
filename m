Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D86C7EE43
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Jun 2023 22:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239882AbjFFWb0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbjFFWbZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Jun 2023 18:31:25 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1575171B;
        Tue,  6 Jun 2023 15:31:24 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4f619c2ba18so4857117e87.1;
        Tue, 06 Jun 2023 15:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686090683; x=1688682683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCDEmazGxm1/yIkNGXM6G4Wh8a3ubOy148S4pQcYgUM=;
        b=So77yD5YxnfnDf4lc8UKWDKuM28FUcls+RpQtzibPliQ8fukJYfnU8zpCGccwGHkD4
         CwwWQzm1oTrtV5U1Ono9bIRrd3sZiePVsmTmKaWXbhpbW2OzYWqr5c5w7AzWIPaDg+JG
         nwG+OHQuhF/ivbLQjdyUm4Gnvm5dyAG1uG745q/1s1CMOmFLnNiVfmqBsH31qECNfX/K
         HQBo22jdWpbaRNQxpJBlTNB9/IGMSoZowFzvvFFPJl9tGttMhUzGe+twggaS3Wzij4ri
         juGBIlBeXKWmSTbpbYhGwVDdUWA06lWCgO/3t3dEIsl6aAjMifb7t56OyMlWMsNVtyrr
         z+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686090683; x=1688682683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCDEmazGxm1/yIkNGXM6G4Wh8a3ubOy148S4pQcYgUM=;
        b=SitkLI5c+UlYOQsu30ctHf+NDP2TpvBX2wk7T6leXaMBeWDr4ME6Jzm2No61YdT8ZF
         2R8Eh7G5t7XawxDgMrxu2sXVU2bCKuJxAksPaSJeswpWfkRw2t8264WB25jEkc7eeDhM
         GUKD71ISavuyKb4HmwYDyG9cF1y2eYMJ9BkHbyvufocfZru1LpP/zLM/KpvqT7SaosWf
         QX3f9nSbk6XJSUDOUgz8SWS83AcdDuMeHp0wZ+ahWZBb2zTNKPHy69zaxks7GC6SBaFC
         pJ3BwwxoV3oOrvkokLrbGbFNil/+qtvPme3dLmj1nAc5Txkb5cm2bMXtX1rPsXiWhKky
         GejA==
X-Gm-Message-State: AC+VfDwxAFPnlwlHoV2/emFqC6qXZ3uUIEO5UKVX3J/9uRprWLEC2Swe
        rm8ZmVJBij7seaeyiKx3BToZQ4CGl8zdwSb8I/8=
X-Google-Smtp-Source: ACHHUZ5zH9gmcnpdbtzZMeSqkiz9Q/6zWLKjBTUFqKMjxVtilzXaYEzPiJJS6IJ2heSts7qHwSShoYRlFCEV8+53vMY=
X-Received: by 2002:ac2:46d4:0:b0:4f6:14d1:5967 with SMTP id
 p20-20020ac246d4000000b004f614d15967mr1367787lfo.61.1686090682651; Tue, 06
 Jun 2023 15:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230606153456.14454-1-jxh218@163.com>
In-Reply-To: <20230606153456.14454-1-jxh218@163.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 6 Jun 2023 17:31:11 -0500
Message-ID: <CAH2r5ms2HJ4dH2O+UPtpidT-hyDgdGzr94mEutp9cfKiO4PCxw@mail.gmail.com>
Subject: Re: [PATCH] smb: remove obsolete comment
To:     "jixianghua@xfusion.com" <jxh218@163.com>
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfrench@samba.org, jixianghua@xfusion.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Tue, Jun 6, 2023 at 10:46=E2=80=AFAM jixianghua@xfusion.com <jxh218@163.=
com> wrote:
>
> From: =E9=91=AB=E5=8D=8E <jixianghua@xfusion.com>
>
> Because do_gettimeofday has been removed and replaced by ktime_get_real_t=
s64,
> So just remove the comment as it's not needed now.
>
> Signed-off-by: =E9=91=AB=E5=8D=8E <jixianghua@xfusion.com>
> ---
>  fs/smb/client/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 24bdd5f4d3bc..0474d0bba0a2 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -55,7 +55,7 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_=
Server_Info *server)
>         temp->pid =3D current->pid;
>         temp->command =3D cpu_to_le16(smb_buffer->Command);
>         cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
> -       /*      do_gettimeofday(&temp->when_sent);*/ /* easier to use jif=
fies */
> +       /* easier to use jiffies */
>         /* when mid allocated can be before when sent */
>         temp->when_alloc =3D jiffies;
>         temp->server =3D server;
> --
> 2.34.1
>


--=20
Thanks,

Steve
