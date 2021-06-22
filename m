Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44729C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 19:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 242C860FDA
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 19:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhFVTIL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 15:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFVTIL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 15:08:11 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF65C061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 12:05:54 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id h15so19102471lfv.12
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 12:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rKRELqrONLt5xhg+ue0/GBt2LzXnnfQZKD2jib2x2Lk=;
        b=rJ3H+NotQsAbcgbX3+72H8eAKw3xjbhQrN06bh0KqX9JRcED/dqMopZ43RNI39SS/8
         UqIhvwWwaL0WTJ22TEDQJ+WjhFF+QJlJRq3nK692XP5xM/cLIK4eghS7Tn6ZjVqFSe/J
         f05eqTQb5kp5DRiax/mceF5Tq7yBDsftw34PrhtIj/TiLZ8bkTf8j+38zG6jgGhrwPh7
         61m7G3CbSQoWb3G/BmGzYt9EQrvW/lLyW2Ovb8bZasPj4HMXGygr1ILk32VysmPXTxka
         k1Xb5GrKFfeR/2MorQ/J36d9hclP/7cV7iJbXqnwgpmVriVOd14zQed28kITjdMYc17H
         v/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rKRELqrONLt5xhg+ue0/GBt2LzXnnfQZKD2jib2x2Lk=;
        b=cSvNgSdXeDCsEwSDOU3jUs7n4hd3v3WHSy0C1cgP0YdbTHv7ftFWgGFCIszNTsE0w2
         KxfiM9t/o+N0ooEXQMBzHqZ9ECZuIpJ3u5uC37Y4eZzDu9MQn6ndiHbMP1WVTB7MzJUX
         C0GNb+l6A/Vq0ItmpaMtVkyJrO0whFGplntMmND8TecwOkgmjSnf6W8SO8ez24y9jrDd
         7a26mRjXqt+Rm7rgyXE5/vzBjJopEdBBau1HGl9e1bx94zOsve/DnuVSiXXNHgkjZDdQ
         1Rq9cY/Z59X3U3m5cCw5E/pkblFEOn/7YNZSyRwHyAOB9y+gk0xMXERaY7/YFlKDLHgD
         90/A==
X-Gm-Message-State: AOAM530WXpc+KmgFsY1wKfa3AgshB2T7PbUxpDBdQOH48fSARLKiL8mw
        cXprzTYUQaRDw9Tq/7EiDq90rAfMLy5hCKZZsjunn2y5jpk=
X-Google-Smtp-Source: ABdhPJy+v5dF1CoQZjzG6w5IA9GL83Ah5x1T+aHFE30K7omBZULrgfbNBPK7eWECI7MP0edh0XBCkLcIo/Eoqpti+EA=
X-Received: by 2002:ac2:4d8f:: with SMTP id g15mr3887672lfe.133.1624388752438;
 Tue, 22 Jun 2021 12:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu4uEOP4r-KnF+bZGqPjdRwkaZanD1sE_JHuoK=jB_nnA@mail.gmail.com>
 <87r1guqk2d.fsf@suse.com>
In-Reply-To: <87r1guqk2d.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 14:05:41 -0500
Message-ID: <CAH2r5muhe-2GNe0MgVvKy=X+wCxN5E2_tXT8wN8AKXCjanwqgg@mail.gmail.com>
Subject: Re: 2 error cases in sid_to_id are ignored
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Should we make the error noisier?

Perhaps we could add a dynamic trace point for failed id mappings so
we could debug these if problems with the upcall, malformed ids/SIDs
etc?

On Tue, Jun 22, 2021 at 5:18 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Steve French <smfrench@gmail.com> writes:
> > Any thoughts on whether it would be better to return the errors, or
> > continue the current strategy of simply using the default uid/gid for
> > the mount and returning 0 (and removing the two places above where we
> > set rc to non zero values, since rc will be overwritten with 0)?
>
> My opinion: I think best-effort would be better, so returning things as
> default uid/gid (or possibly root).
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
