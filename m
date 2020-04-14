Return-Path: <SRS0=o2U4=56=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7F6C2BB1D
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Apr 2020 20:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1451B206E9
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Apr 2020 20:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mUXhWcLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632828AbgDNUOx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Apr 2020 16:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2632825AbgDNUOq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Apr 2020 16:14:46 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DA1C061BD3;
        Tue, 14 Apr 2020 12:58:45 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e17so7893681ybq.0;
        Tue, 14 Apr 2020 12:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GNxgPPM4n2ujMawZGS0HyHorgM1gpVp/anc4VzVl3U8=;
        b=mUXhWcLskvqOcwmIDaztUH/RxMxbg4sS/9GYSD08uGIEVyl0iz5WH10Ounm4jH3bP6
         Bc+znuOupuZWbV2UIvNrxIE69HdFLORK6/IbFspNMefhoC2TrA/gpeaAkIVydH+WCACW
         oAjJLeKQqhAxADjapWPVoHTp6dmMIZpYPHA4C012WPe/YHLabmYx9OHJHydOfJmoF1BG
         RUglQAsacRDOUfVOmrH11aj/m0+0ozDIsEqa2ZK8l5T3Tdi34fw9mAS6JZ8RkB/i8cV0
         uCmcemCp8Ri92TqFucj4fEHTZAAd3abOlg53bHe8Ge8qhRNjdwRMR6FK/GvwsnXbh8bd
         nDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GNxgPPM4n2ujMawZGS0HyHorgM1gpVp/anc4VzVl3U8=;
        b=e2Ry80shEjg9wmZvIV/hv8WlmwOyzprO/x88pBHQs1dR96oIJMFJdFA3WGNcRmFNe5
         fvQ3+89jFEKZZpAVfAvJX3qIayhc74WzjBRTPmM5ZeIwLJldZ2GL4bEI7YBwb+AIntEe
         Hr6JEL+1huX1WS/YRGb+MXabWpuCGwKErKNr6EZdvCsj6XF+iMZI8Wqjw2x4jlDB+Co3
         WqeVy9QEiyRW/PLtB4NtQ8TZkCbrYTKGCr+XkRnjpQe4/tL3nJeBSJlloQH/6XzPTCvm
         HGrqE2PxMN6VhKB1zAXgfkvDlfrxkcIde4PjUAZR4TkzfxGd71yCW5YQFRDSF8Ij12kq
         K4nA==
X-Gm-Message-State: AGi0PuYUKBTMYrr61TupUWxYqzdmeieGYFlGOWuWJ/TeK5M2Og+AdyB5
        E5gmggNFQgYf9+YgZDGo3NAl6wM59Jh0TVX4BuQ=
X-Google-Smtp-Source: APiQypJN5cWKfU4KSqHxDKZJHAGcb3fPrJTJAFfYVdg0wvrOrwPXCVsAsVoQ1s1vQir2tqnSureNzNJq3rjM6EsKb4Q=
X-Received: by 2002:a25:b78b:: with SMTP id n11mr3040477ybh.376.1586894324869;
 Tue, 14 Apr 2020 12:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAEUGjKiLPQP9wp0AgLUvHgKBOe9We2a-RQaZ7cd7CvhnarwWiw@mail.gmail.com>
 <CAKywueT0Q9WkANNsg8cEDwGZSMaaE5c4LHuEeMhVDzJAzycroQ@mail.gmail.com> <CAEUGjKhSBNQboKOMFMgos9OQfxcLQZsXp8aBrUSFcaSe1saH2Q@mail.gmail.com>
In-Reply-To: <CAEUGjKhSBNQboKOMFMgos9OQfxcLQZsXp8aBrUSFcaSe1saH2Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Apr 2020 14:58:33 -0500
Message-ID: <CAH2r5mt1k5t8rSH1KizeSrcLaN1Fn3GWeMvDPwT2Kfq43UAWaQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: improve read performance for page size 64KB &
 cache=strict & vers=2.1+
To:     Jones Syue <jonessyue@qnap.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Did you also test (at least briefly) with vers=3D1.0 since some of your
code affects that code path too?

And if anyone figures out how to configure an x86_64 Linux to use
PAGE_SIZE of 64K or larger let me know...

On Sun, Apr 12, 2020 at 9:24 PM Jones Syue via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Hello Pavel
>
> Thanks for kindly reviewing!
> Please find the attached v2.patch.
>
> --
> Regards,
> Jones Syue | =E8=96=9B=E6=87=B7=E5=AE=97
> QNAP Systems, Inc.
>
>
> On Sat, Apr 11, 2020 at 2:25 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Hi Jones,
> >
> > Thanks for the patch!
> >
> > It will work although it is probably a little bit cleaner to
> > initialize server->max_read to server->maxBuf for SMB1 and use the
> > server->max_read in the readpages condition check instead.
> >
> > @Others, thoughts?
> >
> > --
> > Best regards,
> > Pavel Shilovsky



--=20
Thanks,

Steve
