Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7666CC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 12:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjJ3Mea (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJ3Me3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 08:34:29 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83429D3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:34:27 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-5a7c011e113so42585537b3.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 05:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698669266; x=1699274066; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rMZ2/38gVohtyPWa2ieMjSqd56787Dechxg0AkJ9LM=;
        b=Pz+PgIVP0Ii1fru5iLiu30NIGfNcF6ihMsMtrxC8S4whqse0eQxOHzfB+LAc5ao7bs
         h503aIVH583COzCxUyaSuTpDwkHuN3Coi0HZ/kRAujKxh4Eb9M6VbFtEjh5NfC/uSeNo
         hmL3Zg8cqWGLr6MApYW0aG8+4Ma9YrONY0Af2tMYCGQYjvx2EvhqjfwwaAYazjfAF1Nr
         tAPWYDbPbom9WqmeFZ+7srql0w/Oal2/ziuMxmKIucnl+7T4SvBl3YjK5kkCGWdSgsOx
         WHNYysXA0BDjYQRNViDdGnKPlgxesH/PpijoCu9uMIPwf12EYUSajDeVLHYWnOtVuOvK
         qq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698669267; x=1699274067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rMZ2/38gVohtyPWa2ieMjSqd56787Dechxg0AkJ9LM=;
        b=q7AHT4eiZ4aGgNWktMFa/pHt3x/G/xCot3zxGLU+T4z7Ur9hlo86GPnkv83HMiBKwC
         IwUVSSYULYWO8tKDH6U15w0eJ31Iwes/T6wCk/Zjs6q75KXTiH7YG9Ox1x+ZAozgZUzS
         OE24Lz1/ro+QY1eyEBSpW436wvh9T54ghrsTzTl3Tbmm+xAkhI2B0TJqwv4BqlSTkmP3
         LoyTjOD7yx9kgkOgRik8VD5X5Iq8RUU7HEYcdwNZyUEd7TY80l0NxAy6Jlb7qp/qr2zT
         PEZWnjhx4DrJY4ASztif6wHA3Kz/g1hZlsTrSZ/wuiOFuaZOA2AYgzRQ06Dp4G6CAC2e
         HZ4g==
X-Gm-Message-State: AOJu0Yw6dwdD8EGy6gEEJofrWOHhVmeHtGHCj/5PI4Or4FrWouUIAEv1
        +85znFOwxBaIbdUYkBt7MTRYmonQ7U+qPScjvxY=
X-Google-Smtp-Source: AGHT+IG67t2QX7Bz5d+VaihQvHtP2STg9OECm7KTdaPwNOzyOfidh+t1PHR1EF94vhddTvtacxBUPUox0GK/0T2ZsyU=
X-Received: by 2002:a25:5508:0:b0:d9a:44fe:be93 with SMTP id
 j8-20020a255508000000b00d9a44febe93mr6753438ybb.26.1698669266649; Mon, 30 Oct
 2023 05:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Mon, 30 Oct 2023 18:04:15 +0530
Message-ID: <CAGypqWz2sq7w3SkjD-9hTFA7_uY69DrdYGpKek9iH2x5SHfz7g@mail.gmail.com>
Subject: Re: [PATCH 01/14] cifs: print server capabilities in DebugData
To:     nspmangalore@gmail.com
Cc:     smfrench@gmail.com, pc@manguebit.com, linux-cifs@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 30, 2023 at 4:30=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> In the output of /proc/fs/cifs/DebugData, we do not
> print the server->capabilities field today.
> With this change, we will do that.

We already print session capabilities in DebugData. How is it
different from that.?
