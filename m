Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CE2CA0FE8
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 22:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjIAWrH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 18:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjIAWrF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 18:47:05 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EEBCC
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 15:47:02 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b72161c6e9so5735251fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 Sep 2023 15:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693608421; x=1694213221; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbkCai2oqtCCieUqz8z/ssZ8HmVvF3Jhup4l6BfAKFQ=;
        b=LGK+WP+n1K7P9POr8aIFaSxtnJw62w/qMSyoTOas9wcXPTH5Az63P8D1jbW2VV4XOM
         /uyJZg9zvVjBBKd+mB1MJYaD/L2totycsH/RIjSiqc+6T/bKLgFzwelW5TAfsU2nJMty
         rwtgBBQOguKbcvoQWZehd7G+PB4/x+Jy4APrMpiFiNtxeYFzXPkbLUX5CbC64Wz1z0qE
         Cne8xcl8cWEal+HBXMuQXSwjNYqLzcewQ652G6EAw9/Fo6TPMhr0AfsW3ejArob9YX+k
         vRa06920pFH5YoZsYAntJ3tYhNhZPyVs8ymBCloit3SnwVP+ZcniwJvTLEs8OGeWB3VZ
         7LGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608421; x=1694213221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbkCai2oqtCCieUqz8z/ssZ8HmVvF3Jhup4l6BfAKFQ=;
        b=YNqIsRNPGsOIGqMqRBdjLEbZdmg2I6LD/ow7ANZiuBc824ehvdI9ub3HOZ4v7ycojR
         8S8CrwoauEp41WkTp11uhiz8aKfRNQzcpj5XEB1uBe5Bomn/7vMf6bHk1CR6VYanK2Eh
         iqfqlSG0GQa2dXOwWV9dg8i5oc7TKrKMisD/2L5+vl2OeSHyn7MkHhPVaEPpVpcNDWdr
         s3gw0vDUbQ+W6v45Zw67ZtR7xYTbTk31K0nicr7BvZzgstWToXHmSE5okbiGRD3ZwIav
         Ybu99zHjvY8wMaWAQEUyT60RnvqH/iJAUsAxanylIZF2dgbd+g3XksqI1sD1tS61muCw
         D6LA==
X-Gm-Message-State: AOJu0YxSd75eruJpLhZm3sqcOVOpXHy8n357IEEypNQ+ecFQ71pwviGA
        9VjTujV7d1VQYxiSsJFj8LQnDxLub7BeCPemTjBcplwfCMA=
X-Google-Smtp-Source: AGHT+IHbq9Jx+3bFKkAFNxIr2lJRO+en37yt7gKZVOLovN2Vu8bpoACi42X8nD2tXIM+/S7uXEQTd+K/Gn/B557cOHw=
X-Received: by 2002:a2e:86d9:0:b0:2bc:d059:bc08 with SMTP id
 n25-20020a2e86d9000000b002bcd059bc08mr1072113ljj.6.1693608420539; Fri, 01 Sep
 2023 15:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
 <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org> <CAH2r5msreVdsetQ1DQYY0orfh=N+zkxLnsWvuecYJWzN3Xev+A@mail.gmail.com>
 <CAN05THR=bR7Wr5qP_evmBEWuxFVtX-z2+o_KavZ5r_zbTD3W8g@mail.gmail.com> <CAH2r5mvf+kqp_YdZear29kpEhbzHNa7z5nnXCTmn74ShMVTZYg@mail.gmail.com>
In-Reply-To: <CAH2r5mvf+kqp_YdZear29kpEhbzHNa7z5nnXCTmn74ShMVTZYg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Sep 2023 17:46:49 -0500
Message-ID: <CAH2r5muNavsN6ELUFMUWCXV_8N=FuNQ9Efyp3Uwy9msQMGs_LQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I also noticed that Windows apparently lets you control the size of
the directory entry cache (the file info cached for directories). See
below:

DirectoryCacheEntrySizeMax
HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters\Directo=
ryCacheEntrySizeMax
The default is 64 KB. This is the maximum size of directory cache entries.

Should we add a tuneable similar to this (per mount? per system?)

On Fri, Sep 1, 2023 at 5:20=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> On Fri, Sep 1, 2023 at 11:31=E2=80=AFAM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > Maybe just re-set the timestamp every time the cached directory is reop=
ened,
> > that way a hot directory will remain in cache indefinitely but one
> > that is cold will
> > quickly time out and make space for something else to be chaced.
>
>
> Makes sense
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
