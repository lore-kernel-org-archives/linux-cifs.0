Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA05C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 16:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D87BA613C8
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 16:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhENQDP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 May 2021 12:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhENQDO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 May 2021 12:03:14 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B309AC061574;
        Fri, 14 May 2021 09:02:01 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id c15so23913830ljr.7;
        Fri, 14 May 2021 09:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hbs58K5TlV2bJvEoYy+ewLKsVKD8mWsVRSkrb6/1M38=;
        b=aWERtuBkNybSMk+QQY4cJ521GkTSpqS+FEMVRqjP4xHxSm0FHJcHPlsDD2wVkwOuZN
         Dbz29Dd6wbD5VElVLOFCSBMnLBIF2//VJjmI25M+DHPp/ooQjvhBOx6n50Nhm3aJIDC7
         gnOpzHv49ogsB7yJIR9N99BnCH/Dw/9oZi6LWF5eS/Dud1iiYz4/Xg1xcKZuB9pOYnNl
         nSgJgJC4vdzVvSEwk0lHDNh6OzXAS2X4vz/70ZPzpXY3+DUyo5fTuE7X+g8HnecDo2WZ
         XknrVjlSLtUwuL9huGcyaP8/i5LracWWNp09klBi93SNmVsuZ/f3x3tWlLkIuJQ63Onx
         /tOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hbs58K5TlV2bJvEoYy+ewLKsVKD8mWsVRSkrb6/1M38=;
        b=i4GfsOVRJHjHJ0Htt5p1Cq2A8prkkMt3udYyVPJQpz+z2BSHFJccT6YjYyNa7yeiQQ
         HhTQEdPe+eEX3gBidgGb7/eg+fwM8KGLHKDrUtqfZqWrtz0IOgbo42UH3z0AEuhja01u
         aM8bVbK8oDZctalJnebAGVOaMnOfyOoNgUU0R4tOVkGWe5jFxjIsevU4XxcmwRlrlNnr
         BR9bmlDynDBHxQ700Dlks9Vq6mzBpWXiyMVnKvhymPcq3P5Dh31zmwfRxvasplPqULyn
         HFmpY8Myof5SYgAq6ULKi8p79Ml+nz+/e7E5d5Mm7ewYtD+MoARVhZ6mspqwkTCbL4UU
         XBXA==
X-Gm-Message-State: AOAM530ZdWLuZAjvSHnnfYhPhyiVgZaQLtfkwK3jii6V783qF0AFanXw
        /q4CqY+euhyUTFkwEjN2qA4FFbdA7OiL5SeZnD8=
X-Google-Smtp-Source: ABdhPJz9fhj9VklicGlUHwFGpHf0bgXbKi6WLqBEDvp90FsUA5MYMjRvqyHQnaRP5IpjwVvTl8/OCcpHf0lpYkFSFkk=
X-Received: by 2002:a2e:bc1e:: with SMTP id b30mr4380301ljf.6.1621008120227;
 Fri, 14 May 2021 09:02:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210509233327.22241-1-wenhui@gwmail.gwu.edu> <20210513165516.17723-1-wenhui@gwmail.gwu.edu>
 <87sg2pshr4.fsf@suse.com>
In-Reply-To: <87sg2pshr4.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 May 2021 11:01:49 -0500
Message-ID: <CAH2r5mtYy9jT80mJNBXnsXwOVRLaTADdLibpTyP7NANMXEtepw@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove deadstore in cifs_close_all_deferred_files()
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     wenhuizhang <wenhui@gwmail.gwu.edu>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, May 14, 2021 at 6:01 AM Aur=C3=A9lien Aptel via samba-technical
<samba-technical@lists.samba.org> wrote:
>
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
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
>


--=20
Thanks,

Steve
