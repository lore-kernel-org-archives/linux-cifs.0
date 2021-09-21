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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A58EC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 19:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3ACA6112F
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 19:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhIUTho (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 15:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbhIUTho (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 15:37:44 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C23C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 12:36:14 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id g41so2067031lfv.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 12:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U4dEZEw4oErGynfppCJd00bZHdGidj3eKUzhoBTPvCs=;
        b=lfzQtH3Iv8HL50eEuFPCqU+ukXq0XXGhngTuGsSVi7cKk5+/X0DIgt6c0xIAoKNgy9
         XRxDlgG4DKDiUXSH5mYCYZ8flQUiDL7vu4U57V9MiFNfEcfYajG7BMnQMdnXdsQIcZa+
         w7cPCmAQI73gFf0hzUZWyl8trL2uEvbzsyuACs/ay/mvm0FnCZvZe+/824CWbBTsMgEe
         dftQPZQj1ALkql4x6lHX0DRSqegXU0Cpdc+bWOap5c6AUo+rs3nJBsmvsMNj/Q46W/sK
         okbAkesdCTXx/Z4o3BHomtNpidGIkcVY5/fB5wbhdM8iplp4/tTTqD5dRc9Kjjj3TYHL
         apew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U4dEZEw4oErGynfppCJd00bZHdGidj3eKUzhoBTPvCs=;
        b=ZnseVVxYiY6K/yIg6rR3g14YTwrzfDRHjBc9zAvyDu5kUNq5+k7zJytQrnUPL7l1Mp
         gro8cZGYjDd8YL8ChUXeU0j41vBq0eY8YmhYificxSJJcPpcQq/+jW756Zh9M40ljy82
         OLcw7klxdmp0kF0TczznRl15aeof4RHnGp0SrwlM+fm64phhoM+ucYIer2s5M2ZnjtOF
         VQwQsNy5faRi0gVSVcMzXVwI2bH+piORfN9ePAltxTu6zSUcGBpd85Cyjxe4cMkXJSUY
         WQatx/IMBYViORMM0edu6erogh68f26FKKlbPvMDdk2JXDOERWCRsIDaW4++hwc8vpQN
         rmnA==
X-Gm-Message-State: AOAM533pWyQvZngZIPRoGy6rPg4ccNoPceXhb1lRez3NumlgCzoJPsHr
        m490biJdXDc1D7VVOMHRlAZxO0rNSanORMG2F5g=
X-Google-Smtp-Source: ABdhPJyUvuYDYTQxI9V+aAM7XKI3jCdLyAYjGEElAsxfKZD0c+G6vvk8PEOXHw8m11jqhVdqCUEL67a11tuadPYyt8E=
X-Received: by 2002:a05:6512:3d93:: with SMTP id k19mr25771720lfv.545.1632252972894;
 Tue, 21 Sep 2021 12:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210921044040.624769-1-linkinjeon@kernel.org>
 <20210921044040.624769-2-linkinjeon@kernel.org> <d9f2a3c9-b9fb-9896-b318-466563e9cd56@samba.org>
In-Reply-To: <d9f2a3c9-b9fb-9896-b318-466563e9cd56@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 21 Sep 2021 14:36:02 -0500
Message-ID: <CAH2r5muaUWci4rfOqYhv+p8NO7rKLSg5Y3WgoJnBa9fL8YD0GQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: add request buffer validation in smb2_set_info
To:     Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated comment in header and remerged into cifsd-for-next

On Tue, Sep 21, 2021 at 2:38 AM Ralph Boehme <slow@samba.org> wrote:
>
> Hi Namjae,
>
>
> Am 21.09.21 um 06:40 schrieb Namjae Jeon:
> > Add buffer validation in smb2_set_info.
> >
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Ralph B=C3=B6hme <slow@samba.org>
> > Cc: Steve French <smfrench@gmail.com>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >   v2:
> >     - smb2_set_info infolevel functions take structure pointer argument=
.
> >
>
> perfect, thanks! One nitpick: we should either split out the
> smb2_file_basic_info fix into a preceeding commit or at least mention it
> in the commit message.
>
> With that change: reviewed-by: me.
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>


--=20
Thanks,

Steve
