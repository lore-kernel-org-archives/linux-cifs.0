Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D76FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jan 2022 08:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiAVIFV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jan 2022 03:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiAVIFV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jan 2022 03:05:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D95C06173B
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 00:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61AF76114F
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 08:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93BAC340E5
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 08:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642838719;
        bh=oy+vGYpTgbRrMUoQVuJICfQLUjkWJU0IWLfrKTxyOoE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FKrV4Zq9wCHUiBFYGzHjhZ/2n9Uin9qUzfbG6rCiQPSVZ065MpkEvVAIyx1uAuIOt
         XXw+8rUIRxvVYcPgRKGQOWX2n8j2r5/8eM8kWnuI7k5216P30551+JvXtQDVoJP6Nd
         37ERfBRc8je/1CPZbVykK456xV+X0WTxOEDbXS4qncQOWG8jAJYHrJe3ddNBdu7K8m
         OVvQjAGJIXz0YtZh2G/dYYOYw3QEXzv9DghiRt8OQ5QUHgYkbmNSwUljX8rnOj1jPR
         i/Zq1MX7wr/B1yozmk8fr7SeiUzaqYPPdd81eBdNaZozwjK+EOfpSVhuh4AzG1yFLv
         f2yvouRou3YLg==
Received: by mail-yb1-f172.google.com with SMTP id h14so34306921ybe.12
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 00:05:19 -0800 (PST)
X-Gm-Message-State: AOAM532gBV/YTtaEbEmDSPUc/6uu1gUY5aS52umSG+MBQbwxN7xVBBT/
        ATKZPcIATZB+rpQkaR13c4NtfoTZvFVtMWAsCxQ=
X-Google-Smtp-Source: ABdhPJwY5Mw3LEKLq4i5c/TuL037LEGMeKtGPHs+cDJUPSp1Fk19SEHi9GfKoj6ts9iHATTPArEe/51cT0sYRsawv1Y=
X-Received: by 2002:a5b:244:: with SMTP id g4mr11579555ybp.507.1642838718884;
 Sat, 22 Jan 2022 00:05:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:b08e:b0:127:3295:9956 with HTTP; Sat, 22 Jan 2022
 00:05:18 -0800 (PST)
In-Reply-To: <CAH2r5msBe2RPy1vmg9pyqiAe2AH7J1XKfSeXkWZDiSGJG-aDFg@mail.gmail.com>
References: <CAH2r5msBe2RPy1vmg9pyqiAe2AH7J1XKfSeXkWZDiSGJG-aDFg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 22 Jan 2022 17:05:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-SP9memOgaYXddYu+Jamrbc9-GaNU7x6QQzKavRdfx+A@mail.gmail.com>
Message-ID: <CAKYAXd-SP9memOgaYXddYu+Jamrbc9-GaNU7x6QQzKavRdfx+A@mail.gmail.com>
Subject: Re: ksmbd kernel docs
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-22 6:29 GMT+09:00, Steve French <smfrench@gmail.com>:
> Looks like various updates needed (added ksmbd server features now
> supported) to the kernel doc:
> https://www.kernel.org/doc/html/latest//filesystems/cifs/ksmbd.html
Okay, I will:) Thanks for pointing that out!
>
> --
> Thanks,
>
> Steve
>
