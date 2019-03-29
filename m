Return-Path: <SRS0=xN7r=SA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C902C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 21:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DACCB21773
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 21:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tYflX9SC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbfC2Vxi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 17:53:38 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:38138 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730122AbfC2Vxi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Mar 2019 17:53:38 -0400
Received: by mail-lj1-f169.google.com with SMTP id p14so3246738ljg.5;
        Fri, 29 Mar 2019 14:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2aFkVM+Ep8OTlOOQ+F3mzxeBXqVJuKa6HXbPnWpeAPA=;
        b=tYflX9SCvQ+gfrpqiZrReFsfKXD5eXwewv1aucIuFMOfNaX6hgG4QZxkI4ogQS8FTx
         Q5CSeQTGryzwKXOCfKXpY1x90PwcrkJf5Cb8FDvyp5D2vvCKQiNpq7N/WPGBUXCXiHJ9
         pkFA47bnvgeHAm+0I9tyoFJcWl2tJwlpyV7vT9ZZgSUOpRTMZyXyNlgiPJzvaexzMZTL
         4Aeer6eBpxx7hWhrPGG5575nGNDpjgdabcG/obbwK3FtFxL8hinCK9EBwCu1QUjTYqU5
         UdKVaDuUOrV+eDHP8F205rGdkUJNWuzlx/Bg0OtoBKgr7J9ioExylY/2zJ+3yevH0wHI
         FkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2aFkVM+Ep8OTlOOQ+F3mzxeBXqVJuKa6HXbPnWpeAPA=;
        b=npSihgxXth7Eu5H4yvsCnElvpfAZnzPWuYgeykLcw452rfEiknWruW2Q1+1cKHfeWV
         SlTrG4sdgtXnQTj7buIImO3uzYIqDp+jJ2s9TBw8UYDSBP/PnUgJUpHbwXGHEgDbX5RI
         bL2AfJRvsvjBk31eQ2JMOhd3hgr+stZhzz1Qwz+xlxV55tcka1M0C6D9pNNwLPLpYcvi
         TAcbPytfbVWtj1jaxzAUrQY9ADaCLzj0mFbsMhos8B/dvoyrZFzmEbO6ZBLYSIHXIMtQ
         xpzTyGf+zpFENT1NSqdLWDPHthda7swt+/nsU7kmPTolQiUK6TwuZ70RSe4YIkBwbvpu
         ogEA==
X-Gm-Message-State: APjAAAVDJikqK/Y3520HygSvyz64FrN1f/G/HFaSC4pKW/Zg1cMebkjI
        ZIYHFAy9PlhHwmad1kH+i+9td6OvHl/nSt6H3g==
X-Google-Smtp-Source: APXvYqyw//aY9c/U+rAB2b/6ISlsDh//nG1LhJ+K1xH+30wRJRKt+ppQOcPwpuPuFZvWFYuoNveA9it+WdTcaqpUa+k=
X-Received: by 2002:a2e:899a:: with SMTP id c26mr27901571lji.192.1553896415732;
 Fri, 29 Mar 2019 14:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msprMMEP3rQRjHFZDTBK2kakE9WgJpQSs2ftr5ztJNiDw@mail.gmail.com>
 <CAH2r5mv30B-jLyacmZk+xMoAaAi1UUcN+xf7Lk7BGKDtdFDjeA@mail.gmail.com>
In-Reply-To: <CAH2r5mv30B-jLyacmZk+xMoAaAi1UUcN+xf7Lk7BGKDtdFDjeA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 29 Mar 2019 14:53:24 -0700
Message-ID: <CAKywueSOxzQKJiWcYzO_yxq2f3U2wXHQEZcKJiACf=b7KzCbDg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Allow overriding the default persistent handle
 timeout on opens
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 29 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 14:32, Steve Frenc=
h via samba-technical
<samba-technical@lists.samba.org>:
>
> V2 fixes 2 sparse warnings (missed cpu_to_le32 in two places)
>
>
> On Thu, Mar 28, 2019 at 10:05 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Reconnecting after server or network failure can be helped by
> > allowing the client to choose the default persistent (or resilient)
> > handle timeout in some use cases.  Today we default to 0 which lets
> > the server pick the default timeout (usually 120 seconds) but this
> > can be problematic for some workloads.  Add the new mount parameter
> > to cifs.ko for SMB3 mounts "handletimeout" which enables the user
> > to override the default handle timeout for persistent (mount
> > option "persistenthandles") or resilient handles (mount option
> > "resilienthandles").  Maximum allowed is 16 minutes (960000 ms).
> > Units for the timeout are expressed in milliseconds. See
> > section 2.2.14.2.12 and 2.2.31.3 of the MS-SMB2 protocol
> > specification for more information.
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
