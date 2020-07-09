Return-Path: <SRS0=36sk=AU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7420C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 15:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA74D2073A
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 15:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pyW5Prrj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGIPFl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGIPFl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jul 2020 11:05:41 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E08CC08C5CE
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2020 08:05:41 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a15so1172394ybs.8
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2020 08:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sLiVaMwMSIrj1mcL7eOlwUOMrvUU/K/1BJJ5+rI1MaY=;
        b=pyW5PrrjaLhj9+AVbSxusfXIYIR8AmKnLzKrwLvsNZMUJWztBB/+9+Zd494BoUE4oC
         jhfGb9kfj1iaxYsep/KvabX6lHqMmHogpDoC+AnzwN2at6z+Kxcy3OXD7L+EmaU5xhZu
         TQ6EjsX3q96zTxT7lzXDg/goomj421uW+AcJLw/HVqIfsLwchHgOn7qmx98JpV95b1Tq
         pUQ2Y0RnGRQsi8WuGOV225e7UJnaii4UiZZ/CWQV4zx5a6aMz5JlVnSKf8OVd6X7M7Rf
         tUJbMOFNUxylyY5f6yvQccBazxwDEyStAUJKYNhJl9jgwhRNvc/8t7yWiUUFRtGTQ3t3
         dUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sLiVaMwMSIrj1mcL7eOlwUOMrvUU/K/1BJJ5+rI1MaY=;
        b=sEqhaDH1qK/1SJJaakUQHKfudt1/+7PUx8GsHj5BWWKf4fMAT6Rb41sEmj6vYYdWV/
         52fs3F9ZgGYcCaet2Wwc3hhkBcHvmPS+lGe2sNTXQffx1RWDe0q/azbSInr5Ox+mov+C
         HYjmMe2cWeAcXWem+NZOHMHyygEnQGfCNuC31ppjfIvby3AKanb3GV60sS0dPLt4VFvj
         UrGTiX6wBYUGPgVtz/PqWRBQhL7pNHxu5rrfWzBATpT0FGczRP2+PYHoOZbGNaFQdL0f
         4u0p+6YYjrHyG76ihUiOVy3XIKrtMcVUxHSSuNgRE5kjmTEpfYRKS6fHh3EwFnFf25r9
         xP0Q==
X-Gm-Message-State: AOAM533NH12KT458VYJLzGPT0opQ/NT+1Ri800UZjyL/vWwnSmJrtqmX
        gvqPw0tFuye1g72qUMK0RrKiA449wV00gMokSuw=
X-Google-Smtp-Source: ABdhPJxvBeARafP0rJIj6sIrn7ZPSR56/MyRYD4q0fmGWnS4hhnqKouPcAjEJJfnkZsBZfrjT+6fA47Re/zMz+8ygZo=
X-Received: by 2002:a25:56c3:: with SMTP id k186mr77810491ybb.183.1594307140264;
 Thu, 09 Jul 2020 08:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200709103949.29944-1-lsahlber@redhat.com> <87lfjt53xd.fsf@suse.com>
In-Reply-To: <87lfjt53xd.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Jul 2020 10:05:29 -0500
Message-ID: <CAH2r5mtJg0OONLuAYmcggj=M3euDDxRa3Y5-_W1=qxwbeZypqA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix reference leak for tlink
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Jul 9, 2020 at 6:22 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve
