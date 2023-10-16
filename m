Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81167CDB474
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Oct 2023 22:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjJPWOW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjJPWOV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Oct 2023 18:14:21 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5A19B;
        Mon, 16 Oct 2023 15:14:20 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-5079eed8bfbso4055113e87.1;
        Mon, 16 Oct 2023 15:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697494458; x=1698099258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvN8fCLlFe7Jrcf7tnyNS2O/KMreYubvjkRXV3ZF900=;
        b=jZNsRbOSRBEMNnJXAd+I0My/oZyydqs0wjNPcMlv/8bALsBZSfk7rpti63vbfe20Sv
         dkngUZ1vpxkTz+7lrxBsLZ0zvgwF/VuxX5bcJncSEao90kNyyOV9FydZ3GKM15K3/1sB
         HG4XG/JHzfSoPDYY1FXF1R0mtZELyQWV9xJLjrZZeqEcsXql64EJwIStXPlZAdDnZx63
         xoQgKkUhlQ57yAwANd1i2fj4BBdnJGPCbfIXF4tpE4II09PDXQr5StKTJlZdjJGfuaOS
         b9e3a3nnTAw+IzDgOtVkoq3Ynk3aTYCd6Yo3u2PID1Rz9STocQzvjrJsCI85CJRbvagr
         cCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697494458; x=1698099258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvN8fCLlFe7Jrcf7tnyNS2O/KMreYubvjkRXV3ZF900=;
        b=TmEFoxeKI9/gHylF5VtL7bStJ2KCux0qEGbKmt/0ED+FVbiB2zXvcwzY3wWsSUZRgG
         /xhcl0uCPvK+W7gJX6nEOUmku1mVp1NGZBWxOVaGEPwBt+fuBuSHvzCIQOGnLyttMDVe
         pMR+ps1KYwXH1DhQYic/AE7R5BZuEGtBaOG3GyF/pgGeE+0aocEy4iFJnVacjC3SZDDl
         3KzYtIcuw0lyqXAiKvtgAA4JwUkmJuIyelnu2RcB4s0le2iOkyBBRc87QpKxbIpB8fdD
         aUDJ8dA5IchasBHf80EUtVKJ3ljFG06IYY1FURa9qnZT1Yw9qvPf+Rb/LgOLxwZqqp1d
         RAww==
X-Gm-Message-State: AOJu0Yycw771QItygW18NUaG6EUsAhXSRYfPvf9uVH2iT0lLRyp/w+2D
        QtmmL4WDH3QfvU0BlswCo+SmrWuI55TpLc8YHDgPGGSAP+bezw==
X-Google-Smtp-Source: AGHT+IFXFt/eaJWjHKduGhvzniZ6R3YYjayeqqEwooMHqMLyF5XD1We0e5s+zndoyLW1kupxy0QwGcfYS3q2cotGUGo=
X-Received: by 2002:ac2:5de2:0:b0:503:1775:fc1 with SMTP id
 z2-20020ac25de2000000b0050317750fc1mr474446lfq.31.1697494458303; Mon, 16 Oct
 2023 15:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mui-uk5XVnJMM2UQ40VJM5dyA=+YChGpDcLAapBTCk4kw@mail.gmail.com>
 <ZS1zSoRwv+yr5BHS@casper.infradead.org>
In-Reply-To: <ZS1zSoRwv+yr5BHS@casper.infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 16 Oct 2023 17:14:06 -0500
Message-ID: <CAH2r5mvBqqas=qrR+Sxfz2T99B2YbuJRn1O8vdpXhUc1CcnoQw@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix touch -h of symlink
To:     Matthew Wilcox <willy@infradead.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 16, 2023 at 12:30=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Mon, Oct 16, 2023 at 12:26:23PM -0500, Steve French wrote:
> > For example:
> >           touch -h -t 02011200 testfile
> >     where testfile is a symlink would not change the timestamp, but
> >           touch -t 02011200 testfile
> >     does work to change the timestamp of the target
> >
> > Looks like some symlink inode operations are missing for other fs as we=
ll
>
> Do we have an xfstests for this?

I was thinking the same thing - would be useful to add an xfstest for
this.  I actually noticed this old bug when someone reported an
unrelated problem (where "find . -type l" doesn't show the symlink but
"ls" and "stat" do) and the other unrelated symlink bug could be
useful to add to the same test

Are there other scenarios we could repro problems to an fs that
doesn't have a .getattr method (like cifs.ko, afs) or .permission
(like nfs and ext4)?


--=20
Thanks,

Steve
