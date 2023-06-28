Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B09EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 20:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjF1UuT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 16:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjF1UuS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jun 2023 16:50:18 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2431FF6
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 13:50:17 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4fb7589b187so119240e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 13:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687985415; x=1690577415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TW3hJH4jv6uCu/JUNc+MSlIYGf3UQ5nEznwzn+GshvI=;
        b=qLfapKBFeT0KKKVAwgiGKI32FwrrEgTenyLMsbKDRKgUcrfs4KMlGWXueZwilM1Sxf
         idjb9L6QJwo0AtKRIBkpL1f58RLkluU4EjmvFMt3dBsBc5tXhllc0IeAN+M7EcFBep6E
         PsLMaYed6B2TU2Swt12xYu1UcPOw3zYaYaXfOpoYGf/pvXE1zvDK7abPcuM/FKgRu8Pc
         Kz1cuDNUyyGO+qF1BgnOpzrx2F4SRf6hAPiDshsZJcntRJUmy59UXmnbvbFyxp7vZce5
         QfDR5DeADDM7Cn1snWhybKFlMuogkT0+EDcXnFKnOf2L9lQJhjLP/thhV2ZwJGNC3dvI
         STQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687985415; x=1690577415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TW3hJH4jv6uCu/JUNc+MSlIYGf3UQ5nEznwzn+GshvI=;
        b=Lt/mvSahFucMRaGWAmE6OIrG2CNwpHboUUtl2S+yOAQHDnG38i/ZmagoSF1FrPhDFa
         /e/lCTB1nuxwy7A4vN4v/O64WHRSgwmgKRUNrIG/9W2FZpCTDFdzue+CbWvX1e5r3JBS
         nRlqk+0nz0yOi1d3v94ZTrWQmV3HsiwRMq0IOWs0OtRECFeRpkKXza8HT7DgC6GXfOGQ
         r54rLtBSq4VHL9Kxv0DYeoEkvUkIgvySRgwOeIYuGDkUmmDNuc+BlzKKXzwIJQwmGBFe
         mrXrXjL5SsObL6uq1avIGLfQnLGsTrA8ds+7bSejwI/QN450kqj/lKXg49C96eU/M6vx
         zQXA==
X-Gm-Message-State: AC+VfDyBLfP0pjIlyFAFCtnXXv6vYfO9qNdA8/vhk1mYIffziEnwDGwr
        S8mLTYSPDfbuhShxXNbM+GS7qo8XrM8dMTCDMqnCf5r3
X-Google-Smtp-Source: ACHHUZ6TOFh8XloSqUoPwIfL8CTJaYO1D3v8Wgk6sGyid9lHiQi9o/JhzbGCbbBIKkjANpNzkh1PrKrXvwYCDFdkwHE=
X-Received: by 2002:a19:5619:0:b0:4f8:6d53:a68f with SMTP id
 k25-20020a195619000000b004f86d53a68fmr17137704lfb.64.1687985415187; Wed, 28
 Jun 2023 13:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230628002450.18781-1-pc@manguebit.com> <20230628002450.18781-2-pc@manguebit.com>
 <efe033740c7ec923fbc3a2453287b36f.pc@manguebit.com>
In-Reply-To: <efe033740c7ec923fbc3a2453287b36f.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Jun 2023 15:50:03 -0500
Message-ID: <CAH2r5mseUCr91=EuAXkkHoXMW5=yms4mkvJRKgmB3aRrv+O86g@mail.gmail.com>
Subject: Re: [PATCH 2/4] smb: client: fix shared DFS root mounts with
 different prefixes
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing/review

On Wed, Jun 28, 2023 at 1:53=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Hi Steve,
>
> Sorry, but I've missed an important change in cifs_tree_connect().  If
> we couldn't find DFS superlock from @tcon, it means that we must still
> go on and tree connect to last share set in @tcon->tree_name.
> Otherwise, we'd leave the non-DFS tcon disconnected as long as the mount
> is active.
>
> I also took the opportunity for renaming cifs_get_tcon_super() to
> cifs_get_dfs_tcon_super() to make it more clearer.
>
> Find the updated patch as attachment.
>
> Thanks.



--=20
Thanks,

Steve
