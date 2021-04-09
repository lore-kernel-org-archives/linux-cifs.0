Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBFCC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3272610D0
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhDIEYM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIEYH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 00:24:07 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E879C061760;
        Thu,  8 Apr 2021 21:23:19 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id v140so7590335lfa.4;
        Thu, 08 Apr 2021 21:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bX3oaJ8LOdDLHPl6Ky49TEfmBDk/aP5kfaNiD1lV2Bs=;
        b=e2uOKIHVS4Io8+rzZfRjbyH4lqsjSTjcIj0ltd00TmX/Y08bCY3klGQ51GceAyOp70
         FItNxZTUVejbaztCS3LLd7g3QBaTD3mTZdvmCvtWtMruYkiUr9pe4eC4w2z8PGkMfJfh
         d8AaiZnksq/aWJwB8qL5YCSYuWdQeGP6Ydufr570uY/MxFF1wywfkfTB+7KXbPeqbtSo
         DFZL/e6VH8AkcYIU5vwO+Edq7HSjTzj/qCsGIzoSJqKY0aGxi0Dm/XLhbKmzF+/Kgiod
         3HopKWzVbsNdOSkCTDek78Tg8rgPqgwK4AqOR+ROtyNYbQjUchPE62+F6ye4pVg1+wgs
         w3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bX3oaJ8LOdDLHPl6Ky49TEfmBDk/aP5kfaNiD1lV2Bs=;
        b=tzD7wdZFo15V6pWzAFnf+T+4kguOMiDvKIjTFSUGKSpOpj7eUv3A0G5mpRGkFxEW/e
         NGBWVqbxVskxAgnVnwzNe5L1sWuqfQql4EeO76bF0gVQ/krZy9UopPiQu4qDvWUmUuRB
         ptGgjMJ1HeQvRdeNwp/U+n7FNUGlgSAyWYwJj1WRcPquaGE9XD7MXDms4YEOFv8Di8XX
         vkjDaGydoiU7xw4O6rixPFmBQds8knan4K8qeSI05lMoKNd/mCaWyNI1m4p3eRLEfwv2
         FOargkppFZbC/VoLtxzFxMbTNO2ONu5MCaCNcP1ysdl6ydkauLmwV8OYnvFzPamrXFUM
         x8XA==
X-Gm-Message-State: AOAM531r9z6v4synteIswHRbPu2qRnpDn6vx5mzv2Efa6qOZGEnNQa11
        tW93Gp7fqU+29D0bwT8wZGq2DT4/P+PNTqKKWJw=
X-Google-Smtp-Source: ABdhPJzERF9ruKl1jj/2gVjN0YXKkA1XPOF7uGD4teqtgIyApxGL2BzysvXQzVtdMvRcI98GidIgJPfjUL+DmVBaKDM=
X-Received: by 2002:a05:6512:1322:: with SMTP id x34mr8827582lfu.133.1617942197748;
 Thu, 08 Apr 2021 21:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210326011117.GA46303@embeddedor> <877dltrjue.fsf@suse.com> <4def044f-4529-9e73-6d01-1a9751f6b09a@embeddedor.com>
In-Reply-To: <4def044f-4529-9e73-6d01-1a9751f6b09a@embeddedor.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 23:23:06 -0500
Message-ID: <CAH2r5muf-y5XDyickz9mEw7kTVSjKvK+4AspSPsySbY9ucix8w@mail.gmail.com>
Subject: Re: [PATCH][next] cifs: cifspdu.h: Replace one-element array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Mar 26, 2021 at 12:02 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
>
>
> On 3/26/21 10:54, Aur=C3=A9lien Aptel wrote:
> > "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
> >> There is a regular need in the kernel to provide a way to declare havi=
ng
> >> a dynamically sized set of trailing elements in a structure. Kernel co=
de
> >> should always use =E2=80=9Cflexible array members=E2=80=9D[1] for thes=
e cases. The older
> >> style of one-element or zero-length arrays should no longer be used[2]=
.
> >
> > I've checked the usages of the struct, looks OK (we don't allocate it
> > directly, we use memory from the small/big buff pools).
>
> Awesome. :)
>
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Thank you, Aurelien.
> --
> Gustavo



--=20
Thanks,

Steve
