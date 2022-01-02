Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0034BC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Jan 2022 07:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiABHVj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Jan 2022 02:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiABHVj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Jan 2022 02:21:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D3DC061574
        for <linux-cifs@vger.kernel.org>; Sat,  1 Jan 2022 23:21:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1164CB80B2B
        for <linux-cifs@vger.kernel.org>; Sun,  2 Jan 2022 07:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A37DC36AE7
        for <linux-cifs@vger.kernel.org>; Sun,  2 Jan 2022 07:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641108095;
        bh=o77TeewVe93Bwsd17zFdq3IrjcuhGxqvhAXm4B51Kd4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=uDDvcWBSm2WUpHTzbxVPxG03AZDFfHKEeLpvLuwO8pGqc8ILtgUWorfI5ICfbiW1Q
         CBEa0um8RAblGoNsfHNGtsQbUdlxUNHlpu4KRy0XUnyzpXb2O36i6qdMbeTeN96O/Z
         InG4YiG/VkWHx6ockw/QQTKrDFARsROL0+42MhO0+adC4mnr6wyEqKwBoi+FzEeIJ7
         5SqQ7ymXrQTgaTBFOkbGbJAG1QaBTdjhR3ISuQ9ctlzYZXr+YbfTZGuMX8ME+h7572
         fLhGRRddaX53CS7QNNc/RgapraLYN1xTDrBTUm6b54hyAG2lwKvRfTghtv/xY44+La
         n1aQVLvavv44w==
Received: by mail-yb1-f178.google.com with SMTP id w13so57239447ybs.13
        for <linux-cifs@vger.kernel.org>; Sat, 01 Jan 2022 23:21:35 -0800 (PST)
X-Gm-Message-State: AOAM532k9THYV9rzRPc1w5Pwd8VBViuOqr6thtUQzDPaj964cy7dKANc
        J0pjNCCmZSNvcNDTxyqNM1GEN8oMVAB+f2L+XGU=
X-Google-Smtp-Source: ABdhPJxtvlaCjn/JeEMuGmx/SJgcEyUxU2ZrjIjeRlVn7hsvpI4mXwY2MUqFjOTRxDfr8YjnPq09FqRAdlWNZpb2e44=
X-Received: by 2002:a25:9d0a:: with SMTP id i10mr42799754ybp.507.1641108094756;
 Sat, 01 Jan 2022 23:21:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:4357:b0:11e:f0cd:2c0e with HTTP; Sat, 1 Jan 2022
 23:21:34 -0800 (PST)
In-Reply-To: <BCCDD94E-F82F-4EDA-AC7E-9393C217A459@gmail.com>
References: <BCCDD94E-F82F-4EDA-AC7E-9393C217A459@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 2 Jan 2022 16:21:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-3F455Ykb1mK71eS_Y-n55Phhc7b5xrdjg6db30LeCaw@mail.gmail.com>
Message-ID: <CAKYAXd-3F455Ykb1mK71eS_Y-n55Phhc7b5xrdjg6db30LeCaw@mail.gmail.com>
Subject: Re: Patch for ksmbd-tools (issue #222)
To:     =?UTF-8?B?6rmA7JiB7ZuI?= <lanph3re@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-30 17:15 GMT+09:00, =EA=B9=80=EC=98=81=ED=9B=88 <lanph3re@gmail.com=
>:
> Hello, I wrote an issue #222 in ksmbd-tools repository.
Hi Younghun,

>
> The one of the maintainers commented that I can send the patch to the
> mailing list.
> I attached the patch generated with `git diff`.
> I=E2=80=99ll also leave the original link for the issue below.
First, Thanks for your patch. You need to create the patch using git commit=
.
Please refer the format of the patches in ksmbd-tools.
https://github.com/cifsd-team/ksmbd-tools/commits/master

Thanks!
>
> Thank you.
>
> Issue link: https://github.com/cifsd-team/ksmbd-tools/issues/222
