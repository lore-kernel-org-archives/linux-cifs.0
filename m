Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F97C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 18:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjJaS3X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjJaS3V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 14:29:21 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F26107
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 11:29:18 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c514cbbe7eso83345501fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 11:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698776957; x=1699381757; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VCKe4QrDe63F1/IKwSE2vSXys/MXJhALBrQ4dZQjVyE=;
        b=SYfupTmW9QBOQegdfiIWvOaSva/X2wENze7shL+zDck+YhqaospxFSSd9zHu8iqqwB
         WPebIxu7DhmH8PgeaqyHJSfNfR7qWLOzxZBrQQ27hRoYrz0rB+Ffx/zopTtrFScUDDOs
         ZpI8Mq+JJsW6ryRkDuN6NS+f32+HsojKZ0oBNPWebYBb+/pq30JLMx+ogcORAO4F/tXY
         f9gSPYi+gNNYxbtpnOhAqQsAQ49AS39rv9N7WKzATsJHzI1n0GIY5P4xEnClKtIEcq5/
         GfvS2Z841tWJTpVWzLCZUtYHO4lt0tZuq5bgYUSdudSgrLUWkGhttfXf809Rn7S3b10L
         3D7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698776957; x=1699381757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VCKe4QrDe63F1/IKwSE2vSXys/MXJhALBrQ4dZQjVyE=;
        b=ffepHMWW2Cai81NPGnhojqWnkLJf26OXRRpjwlaS/Vse3EzBAo9fluDwVfVnBtYoDr
         nTUQuKxsi7gow4nRCitWCPM6U3vWmQGAbr1FQMHBuD7e5dfMgIasamnq3U/MsgNbAh/o
         TdlZDZ+0FALPJwTreANx7aOlhr5wu28jIbGgu/JoUuYFkF4WA3xmbB90EyjWTIxs3fat
         H1QtMHfbU/FaUR9H1sSVabMXdc3WlAVwABE0w7zNeOhLg1+3xgL2Q+jq8PSxhNTpMihU
         jpB6g1j3hKyjYE8wrMDu30d6tuLmSamHQnWBZhI3eWDszJXAyD2RFrHPmbd4D3h4q18L
         kBdw==
X-Gm-Message-State: AOJu0YxD78X6vCZcqLA4BEzdmoBKZDNu822yg0ED/72Z1ChHSaMDJncf
        5b8sPzEiKA4Hb7dXmDu4DekxlA3gFzqlPxoJ0I8=
X-Google-Smtp-Source: AGHT+IH16gEao9RhZojL8J9t2oick/V44B5chy8dfr0Cv9y7CC6DDFOkFzbsthunn4oo5m1l2nUnhc765/nseDPaLss=
X-Received: by 2002:a05:6512:39d4:b0:507:b084:d6bb with SMTP id
 k20-20020a05651239d400b00507b084d6bbmr13862271lfu.43.1698776956240; Tue, 31
 Oct 2023 11:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-3-sprasad@microsoft.com>
 <92001e6cc16020d2990229c411b6f78c.pc@manguebit.com>
In-Reply-To: <92001e6cc16020d2990229c411b6f78c.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 13:29:04 -0500
Message-ID: <CAH2r5muM_ZGCUiEnMsgfLwastbyMttftf1UryMfUYE9+Va7spQ@mail.gmail.com>
Subject: Re: [PATCH 03/14] cifs: reconnect helper should set reconnect for the
 right channel
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively added to for-next pending testing

(and added Cc: stable and Paulo's RB)

On Tue, Oct 31, 2023 at 10:27=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> nspmangalore@gmail.com writes:
>
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > We introduced a helper function to be used by non-cifsd threads to
> > mark the connection for reconnect. For multichannel, when only
> > a particular channel needs to be reconnected, this had a bug.
> >
> > This change fixes that by marking that particular channel
> > for reconnect.
> >
> > Fixes: dca65818c80c ("cifs: use a different reconnect helper for non-ci=
fsd threads")
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/connect.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>



--=20
Thanks,

Steve
