Return-Path: <SRS0=R6NA=5B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAE5C10DCE
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Mar 2020 01:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD63D20674
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Mar 2020 01:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLZx8I99"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgCPBTT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Mar 2020 21:19:19 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:33275 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbgCPBTT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Mar 2020 21:19:19 -0400
Received: by mail-qk1-f179.google.com with SMTP id p62so23449379qkb.0
        for <linux-cifs@vger.kernel.org>; Sun, 15 Mar 2020 18:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tdNus9zNxtSOm7qlUBtshsyO4JEC1pBu4ig8znf74kI=;
        b=HLZx8I99a+P4axfDNAujOaj/sQ1oqWAkLLgslZHbQu3jOXcgPkidzv+SVdME8bPtHg
         SetElvl+jvyP8ArVe1imVQSMEAqraHsIHuO7It27JfTDq2shH5ZAqozXZfGuaKP3N1CI
         +RlGyyQFey82asFc2MLft70ftZNdw5QZllCoiOGR3l7TSkXuDaN62sQRFUYqsslaRb+f
         EvOtozGv6wxJHGalAc2mPYdOxZnhxQYkNijy6rsu8m9TMQmXPhJGWQPE5vCW1h9bapQ+
         zLn4wqFtX5DgonwWspODRTSHwSG1QRsHg9IO+RvJc+v3TTVTOwfI1cD4MBQRreyNxGHB
         FD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tdNus9zNxtSOm7qlUBtshsyO4JEC1pBu4ig8znf74kI=;
        b=JG7VKPykvKA7h2le95vBh6+f4g14JZSfgfRjjxWKA1EF7S2oJsG2scLl9aDHQrCRUZ
         x6HP8JpGBZbDzYW4Y7cEcucB0vciIbqE2WXd2iTUcovv7yAcPUMRbRqhHngu4v5FDT6c
         4B/M/nlcQtdxE7uEk7eNOAySSPJzPmOzmOM7z90Zs9ZHIo95cBC5Fs+jVXF21Fhvpu2R
         zx78tC9734wQ6IrfHLKW9NRGuR17Z+3ffTLxCf3e6pShAhcG2HhqitsmuWnjMSL6b7Wu
         RbZzRvG6VKKxIgj45FaicnM0Lx1g70/Yo9d4Smw148KUmpUFxqRu0zbUfMLWHKxGdDrh
         GJyw==
X-Gm-Message-State: ANhLgQ3rDs24RP/r0w8acck0q9BRujHuppH9TqnLqUksB6PkWLWgyncr
        /AVItJ0p7BfqW8Hduq2aM3+hnLvjQZmdwK1kf6Qd65Zd
X-Google-Smtp-Source: ADFU+vvw/EgWwz9qn98zRlv/vkB/Ds3xaZkM10Q58FUN+jkPEolnt14MxubPuUTRaVB71Gb83IcXCHDVqcN0gHs8nAc=
X-Received: by 2002:a25:2554:: with SMTP id l81mr32492135ybl.375.1584321556736;
 Sun, 15 Mar 2020 18:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms_oxqwHm56nzabM-x2XMR1Ni-WD1_LEYYxOW_NkswsOQ@mail.gmail.com>
 <CAH2r5mvN5ri_7x3dVah8tUft6Xxbjia9MSANZV04TkVwtqY9Tw@mail.gmail.com> <CAN05THSjfj2ZJCSEdgdEfiEcxG8=xd-e5zR6KrF8gR_O1Mxb7w@mail.gmail.com>
In-Reply-To: <CAN05THSjfj2ZJCSEdgdEfiEcxG8=xd-e5zR6KrF8gR_O1Mxb7w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 15 Mar 2020 20:19:05 -0500
Message-ID: <CAH2r5mtO_dC88hNj-UAj61Oy2OA4XX+LKjftK_+jwwzXzdnwEw@mail.gmail.com>
Subject: Re: [SMB3] New compression flags
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed typo - thx

(and also added acked-by) and pushed to cifs-2.6.git for-next

On Sun, Mar 15, 2020 at 6:10 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Typo in
> +    __le32    Repititions;
>
> otherwise looks good.
> Acked-by me for both.
>
> On Mon, Mar 16, 2020 at 9:07 AM Steve French via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > And one more small set of structures for the updated transform header.
> > See MS-SMB2 2.2.42.1 and 2.2.42.2
> >
> >
> > On Sun, Mar 15, 2020 at 5:50 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Some compression related flags I noticed were added in the latest MS-SMB2
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
