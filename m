Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD70C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 12:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbjJ3Mkc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjJ3Mkc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 08:40:32 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0394DB7
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:40:30 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2c5210a1515so64098211fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698669628; x=1699274428; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1LXslDgpWSpKhxifNv8hwQ2CuLDYbumHwPz5obFl38=;
        b=AO5lshzeTZYkqTya3OtpU6W6CODAppfNCt+MyhtS2/FTmNRceXJzlLZH8SWNzrq43c
         zORLsF6vatfuPaZ171I0gKGr+yG/fct4EpMFa3emhvSRftPKDY06EzQRsnEjsLlv0WHl
         iQL3FIijS8D3s8NQke4nz8zPHnz9I+c2Xbsb2+hFaGznOIJTqQXCsk+vZn3uV8dXD8kF
         hLbgCTbs6xSa6AnAe5uZTxkBkFUsOzbZkZY4tM/UrlmwWWavD7Wqxm/z4YnIShhnSXOT
         4VB3mMq2JlX8heP3Om352Fz3+Hht459pnfb1kyrAqddAbqdIdduCZhG9LT54rlBYtsxJ
         RVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698669628; x=1699274428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1LXslDgpWSpKhxifNv8hwQ2CuLDYbumHwPz5obFl38=;
        b=kH52EpwxvAj12HMQNR0HSi/DfQrWO4DLtX8vScDHsSjEWoQfxmbA4DKgjnGZ7X9uRv
         svC0DeLDek5O11G8xE+WlDyvVML0Xp/j5PGRZKaXoG+Zpth2njWguq1l8fKfic7fnfjy
         Xp8fAcztRL6lja1OI7YVQggxRJu61kub9lwVULUx85RjoZCueX69qG1Wpk0XTxBj4KbS
         yhnTnJcco4hrt1YUuZdE7hLe/DVkt3QJ/J0fWx7ubIB+spPhL0n2PJMijPlZ3jRilY21
         bIKPe8HVwCsKimCeyphJNbYscU1bOAvHV0+/Pktj8Rrm8H5hsEPdkW3YS+LqoUhR0ruW
         kP4Q==
X-Gm-Message-State: AOJu0Yw22sisUGgBC4e1m6VvjDmfMe5BGIBoFuiBDXgnwrlabyocc6cV
        2HrMweF8Rg679cv6GkdCIqmazVYn406WFyg5ThA=
X-Google-Smtp-Source: AGHT+IH/epcmKI4v1KqBqS7RVCk7VtFM+TFtJXY7GYJO/Jmt5sWrub/4auHgPiIw6Lv8nSxunVIeGkzZQPEjfl8esdw=
X-Received: by 2002:a2e:bc83:0:b0:2c5:19aa:ca83 with SMTP id
 h3-20020a2ebc83000000b002c519aaca83mr10161949ljf.20.1698669627841; Mon, 30
 Oct 2023 05:40:27 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <CAGypqWz2sq7w3SkjD-9hTFA7_uY69DrdYGpKek9iH2x5SHfz7g@mail.gmail.com>
In-Reply-To: <CAGypqWz2sq7w3SkjD-9hTFA7_uY69DrdYGpKek9iH2x5SHfz7g@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 30 Oct 2023 18:10:16 +0530
Message-ID: <CANT5p=qJyHAECHANqAc+qas8Aadq0Or5FXo1JBy-6qQFrLd_yQ@mail.gmail.com>
Subject: Re: [PATCH 01/14] cifs: print server capabilities in DebugData
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     smfrench@gmail.com, pc@manguebit.com, linux-cifs@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 30, 2023 at 6:04=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> On Mon, Oct 30, 2023 at 4:30=E2=80=AFPM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > In the output of /proc/fs/cifs/DebugData, we do not
> > print the server->capabilities field today.
> > With this change, we will do that.
>
> We already print session capabilities in DebugData. How is it
> different from that.?

These are capabilities at the server level. That one is at session level.
Actually, there's tcon capabilities as well, which I think we should
also dump in DebugData.
I'll submit a revised version for that as well.

--=20
Regards,
Shyam
