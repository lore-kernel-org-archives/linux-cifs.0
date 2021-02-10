Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF02C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 02:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9390964E4B
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 02:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhBJCsS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbhBJCqV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 21:46:21 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F339C0613D6
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 18:45:41 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id w140so178406vkw.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 18:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=071lot6s7HVOyK06SwQXs7ICEvUPGcv4h4+dx985ktM=;
        b=UHt5UPtKaxgGiCTjA6GHz1LiVYZMwzoicHw4tDZd+l4+pKs58gSQKZTRRfEmvUZZli
         V6akGwyaoMtzB/2EbPP3gfZulSM7XxeaNzx4IjBSxx9SuJ7wajQlyAKuTjyRrZy2i0LJ
         iVJYOv41LnsoOXhkUmGs4e36D+dFwS23RJEcBib+Lvw5WhuJOjkE8fCUm3CtwHQw+zsu
         27Ce77CP6TtjJ8/LWJqGe0GNbz1ZXSl+OoS+XVJI+ze2QaYaOT/OLu5bCZ1ETyJzHcBC
         KzdHj2hxU2kwEqL1+5et0lJVNi2hAKyjHkzuwznaxFbG8a8U4jfzKCAo2Jfur2nPpEbE
         pstw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=071lot6s7HVOyK06SwQXs7ICEvUPGcv4h4+dx985ktM=;
        b=LJgckxFVM2rcW/6q1/VyEmg9PXsukhMvwBRTdPlbwu4jYv4EGNyPbyJjQgk5tYLYqb
         YUqxtatbjYYk2DmA8LHPhHieKA843Z6CFAmIcBq2nmQ/h46Wj/1w4bV0u4yVFwtKCtFW
         bySWF6WbA+C77nzVoXBIk5N9p0Vsgd4Nk16C1ho9T05RK8bEjAtT9i6jQOousqWk0aZI
         QI4dXaiqE7Y4MqxszytsTrZixnF+urs5SJvjRl+jkVaphWSqJB4lw5n5rkKhos1e/NJE
         SLmFFG/E9lAslHpLbxbjiqhwTzq9gl7UlNcaC9YsqQ8gTFVIu/YEq0yu5kQIc2ZH1fG1
         HXLA==
X-Gm-Message-State: AOAM530bRh1L/oiQ5j7msSwWgj/UvoX9JPXZmdQGp0N7S1WzJWuflI/i
        cCCffgXHPLYXJV/YYetUMzWqCVCWlaSFb23Ww9I=
X-Google-Smtp-Source: ABdhPJwgHQq2RlKK0eODlSRcliov5ut3s69SpBLRFUMiw1ldd1zdCxJLVzfcqlb3aW8F2nSVvzqktCGbGjR1SipK0YE=
X-Received: by 2002:a1f:1c83:: with SMTP id c125mr519443vkc.0.1612925140579;
 Tue, 09 Feb 2021 18:45:40 -0800 (PST)
MIME-Version: 1.0
References: <CANFS6ba33DORg99OYHwaD9yJ+r6rt8A7v_R36_Uf_hHkw=agyw@mail.gmail.com>
 <CAN05THQyVJ_4CN41Ep1Wn93BuFYgqUZ1fqCVnqiUebHtobu1tg@mail.gmail.com> <CAH2r5mvRds+QT33zw=3qtfDt4a7jEW-y0H6baP05oUFXVAoEkQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvRds+QT33zw=3qtfDt4a7jEW-y0H6baP05oUFXVAoEkQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 10 Feb 2021 11:45:29 +0900
Message-ID: <CANFS6bYwKbUnZOussTi-cgrTewqNJHTFok-UJK6G6gxMB8HOAQ@mail.gmail.com>
Subject: Re: "noperm" mount option not working
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

"noperm" has been set properly.
And for ksmbd, xfstests generic/125 has been passed.

Tested-by: Hyunchul Lee <hyc.lee@gmail.com>

Thank you,
Hyunchul

2021=EB=85=84 2=EC=9B=94 10=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 11:09, =
Steve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> merged into cifs-2.6.git for-next
>
> On Tue, Feb 9, 2021 at 7:56 PM ronnie sahlberg <ronniesahlberg@gmail.com>=
 wrote:
> >
> > On Wed, Feb 10, 2021 at 11:18 AM Hyunchul Lee <hyc.lee@gmail.com> wrote=
:
> > >
> > > Hello Ronnie,
> > >
> > > from the commit 2d39f50c2b15 ("cifs: move update of flags into a
> > > separate function"),
> > > "noperm" is disabled if "multiuser" is not given. this happens even i=
f
> > > "noperm" is given.
> > > Could you explain why this is required?
> >
> > That was a bug. Thanks for spotting this.
> >
> > I have sent a patch to fix this to the list.
> > >
> > > Thank you,
> > > Hyunchul
>
>
>
> --
> Thanks,
>
> Steve
