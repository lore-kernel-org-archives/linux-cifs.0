Return-Path: <SRS0=pVcL=6Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB71C47255
	for <linux-cifs@archiver.kernel.org>; Mon, 11 May 2020 15:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A5A206DB
	for <linux-cifs@archiver.kernel.org>; Mon, 11 May 2020 15:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AP08LLKo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgEKPmT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 May 2020 11:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbgEKPmT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 11 May 2020 11:42:19 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E793FC061A0C
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2020 08:42:18 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id se13so1628168ejb.9
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2020 08:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZyayfKHbdUpDZhSDZes91ie4j30cvRqOr7VTsuNDqxY=;
        b=AP08LLKof0NbWrTFE0ns3UqDkISQ+UaKUgBJ+P3JXLw5dnsDuBPfaG45V+FR/BgZ3T
         rp6YpNhqSMlNX9wp9FMW79WTF4/2pWJP0DUoYRU+hkaDrF7k+32yBrWq+Cnk6aB7cQCq
         gPTBspqZOnbAirCN6F16iusYqKSk9LqiqQTeP2Y80ClzxFt0w99vrDXHdeTq45vr68ad
         ZWI5PuXOO8R4/lbInJrSMehqBw7+RqDHI8RaAT5ome7RI6xj805rmA7BzL0HRQr3PRMn
         NbXsh4gY0JgWlgvTEX+E1KyqjBiwyDamOfm3hwDTlTYNULt+nLMfTgofNfvcLggu6a1G
         OFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZyayfKHbdUpDZhSDZes91ie4j30cvRqOr7VTsuNDqxY=;
        b=Lh6qOOMzQJkW7vK/X0wBNETPKEIcMJvVQ/1Y20y2dgzkmhOKcRClOy9tLwK3G7mydp
         NVjksKt3DOE0KkDuD6+B5lTsxMMH+doexFn9OCMMphYcPoHMulQaXLrfAVsXiNzUzFTh
         ACG0zZznU3kWJlH76U5c5TmYxrlIsCzZEiK1G6Cj9ULN3UDIaDeC4bl0SPejZD+ryd35
         Rv7y+vkb/EfLJy4mIwE5q7M1orUhqM/FRqdblEGL8twu20Zbc1eKlW/9xXI3MQS4K5f1
         MWHWT3I2EviIHVFbWMBsYX5ndjTNgZEFveHCyGhvtOvcBkrZ1BpJsqjX5cOfATtMKwFk
         BxWg==
X-Gm-Message-State: AOAM531Q02+1TSdO07y/JBxu+1wVG7EKhQw2U/vUvrYEaJcpbkLxw+DJ
        Rc3m4A5+c/q2HAG41i0jEjKB0b1X8aNmbSEKPg==
X-Google-Smtp-Source: ABdhPJxeCVz6Uaud3XaG7vY5Jr5pM8fWCSc4TRXkFdw36fYZF+oJShpwEviEUyOOOoGguDC1emhmMCZl90IyzHf0G60=
X-Received: by 2002:a17:906:eb1a:: with SMTP id mb26mr439212ejb.362.1589211737550;
 Mon, 11 May 2020 08:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200428032647.2420-1-ryanbarnett3@gmail.com>
In-Reply-To: <20200428032647.2420-1-ryanbarnett3@gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 11 May 2020 08:42:06 -0700
Message-ID: <CAKywueSWxHNKqZMhTGg_vHhCbfy46TnaQPb+Dwy6AEc5hyj4xQ@mail.gmail.com>
Subject: Re: [PATCH] Use DESTDIR when installing mount.smb3 and optionally
 install man page
To:     Ryan Barnett <ryanbarnett3@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ryan,

Thanks for the patches.

I think they are duplicates of ones posted in January which I haven't
merged yet:

https://lists.samba.org/archive/samba-technical/2020-January/134770.html
https://lists.samba.org/archive/samba-technical/2020-January/134771.html

Please let me know if you would still like any additional changes on
top of the two patches above.

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 27 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 20:27, Ryan Barnet=
t <ryanbarnett3@gmail.com>:
>
> Properly create mount.smb3 symlink by using DESTDIR. Also use
> CONFIG_MAN to optionally install manpage for mount.smb3.
>
> Signed-off-by: Ryan Barnett <ryanbarnett3@gmail.com>
> ---
>  Makefile.am | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index fe9cd34..e0587f1 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -119,11 +119,13 @@ endif
>  SUBDIRS =3D contrib
>
>  install-exec-hook:
> -       (cd $(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
> +       (cd $(DESTDIR)$(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
>
> +if CONFIG_MAN
>  install-data-hook:
> -       (cd $(man8dir) && ln -sf mount.cifs.8 mount.smb3.8)
> +       (cd $(DESTDIR)$(man8dir) && ln -sf mount.cifs.8 mount.smb3.8)
> +endif
>
>  uninstall-hook:
> -       (cd $(ROOTSBINDIR) && rm -f $(ROOTSBINDIR)/mount.smb3)
> -       (cd $(man8dir) && rm -f $(man8dir)/mount.smb3.8)
> +       rm -f $(DESTDIR)$(ROOTSBINDIR)/mount.smb3
> +       rm -f $(DESTDIR)$(man8dir)/mount.smb3.8
> --
> 2.17.1
>
