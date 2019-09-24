Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30C6C432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 05:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C537D214AF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 05:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLeFlT72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404615AbfIXFYd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 01:24:33 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36168 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404156AbfIXFYc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Sep 2019 01:24:32 -0400
Received: by mail-io1-f66.google.com with SMTP id b136so1386372iof.3
        for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2019 22:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/0fecYKIp3CuwRFnFuWAAtDfKoAEFERUp+ICUPl5260=;
        b=XLeFlT72ZDE4KOBL8MSIWAYz4FykLsJvit7+ujN1gPdJVGiA3q89XEk9PGYcoArxWO
         bxBBmU4xkdXELADZLY0k780XFVb5i6wh/SGVRH6gOa8bIIDSzRgIQg6UZYOqE2xSsDkS
         V1ptPsaAQOE6vzm6KaFFF32VP2dmRQbk2yypTXsWOmyblQXq/hHzHxsUWlAStZa+u0lW
         tLVRw4pEEq9fs8Je9/YNzWnrG36DOJwzR2gZsTJgnZOLLo9q6l2HgJwON/Nsyow5kuog
         bhUIA4sQXyg/4aDuIppd71Rb05zed07vr8CLD9x6ilf9y6Edlzjfu5iVisdENuv5RRma
         hVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/0fecYKIp3CuwRFnFuWAAtDfKoAEFERUp+ICUPl5260=;
        b=LnFxsZKGGuQ7vwr0aY67AcirBLBe6aY9fRKygfFm10SmU1CXT/qKhkncNzMU+3rZAG
         flAnfQwrIZ53RVBiGqk3LsRQ1QPB7B33Qyoo5rZjJu/XXShhgtrrykrSumoZXN+5kO0y
         KuSB62oosMm9NqRgcqvH7X0/rUVXlJjCy03kFLTP8VYZkvzINPndpFi12HbvyU3zEjOT
         fuQTYotsv4u/Q1+yD6oAEawnmG5THNXQ5RmxyBDLeuk56O02BkFKFuezmsEzcsPy/xy9
         94puq8U5iYzLpg8l+dN1LWek360N/WSPG1vthtOWzrMySZn7qouB50KiUI4PpbUL9RrX
         UN4A==
X-Gm-Message-State: APjAAAUXX9wzjlJHiIlx+fiDs6Ys0ZezWRfLdam605TSNEtfHg4C6Q5S
        L7qJPCcOXjnrcR7ftCiduQc1NaVoO2AUAtRMJ15Bzndr
X-Google-Smtp-Source: APXvYqz4KbHA8Fo1RlOzrU7/CUIw7HW4RVuvTVw8uwDvsXXtb1sskxPt1hxBX6NVATp4l6wAEWsBqd5mCu025Xsdy04=
X-Received: by 2002:a02:7f49:: with SMTP id r70mr1716722jac.85.1569302671912;
 Mon, 23 Sep 2019 22:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190921112600.utzouyddp3cdmxhe@XZHOUW.usersys.redhat.com>
 <878sqhfqzf.fsf@suse.com> <20190922012501.g6yon32sxlzdvkgj@XZHOUW.usersys.redhat.com>
In-Reply-To: <20190922012501.g6yon32sxlzdvkgj@XZHOUW.usersys.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 Sep 2019 00:24:20 -0500
Message-ID: <CAH2r5msB1G5acdROoV0PDx=1twPfMyzmQGT4-KosPGD62UoxMA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: fix max ea value size
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Your patch looks correct - added cc:stable and merged to cifs-2.6.git for-n=
ext

On Sun, Sep 22, 2019 at 2:23 PM Murphy Zhou <jencce.kernel@gmail.com> wrote=
:
>
> On Sat, Sep 21, 2019 at 08:23:32PM +0200, Aur=C3=A9lien Aptel wrote:
> > "Murphy Zhou" <jencce.kernel@gmail.com> writes:
> > > It should not be larger then the slab max buf size. If user
> > > specifies a larger size, it passes this check and goes
> > > straightly to SMB2_set_info_init performing an insecure memcpy.
> >
> > It's even smaller than that as CIFSMaxBufSize is the max size for the
> > whole packet IIRC. The EA payload needs to fit into that. So it should
> > be CIFSMaxBufSize-(largest SMB2 header size + Set EA initial header).
>
> No need. Slab size includes the bufzise and the header size.
>
> > And if we set multiple EA at the same time it has to be divided
> > by the number of EAs etc...
>
> They will be handled separately and slab will work well.
>
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)



--=20
Thanks,

Steve
