Return-Path: <SRS0=0I05=7S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC4DC433E0
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 15:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D1320663
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 15:20:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3ZSVBJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFEPUr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:20:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56988 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgFEPUr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jun 2020 11:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591370446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5rWX1KqozTs9+owaDqHyvwWWbSHRmWFIMNq0TLHbRpY=;
        b=b3ZSVBJr6FYWG+1+hImR1cHq9WZBByDgI9Kxnqqe7L7UogFHoTs+jQsJ7d8Pyl8IxMAKZ0
        sPu3NkoxjNHWIQSK0XGDrJOhCwBlXn0dcw5UOiog3l3LyqLdUYzSDw9f117CyQ3zOCIxaR
        gPvVuv7fZEsnj2tPSXm/frnVr12TZiY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-H-3uGDURNji-olFzpndC_g-1; Fri, 05 Jun 2020 11:20:43 -0400
X-MC-Unique: H-3uGDURNji-olFzpndC_g-1
Received: by mail-qt1-f200.google.com with SMTP id e8so8747948qtq.22
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jun 2020 08:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5rWX1KqozTs9+owaDqHyvwWWbSHRmWFIMNq0TLHbRpY=;
        b=ixXptn8dq8A2oEhFJkjiC4splBt0Q54+ot2yz1O4557tpg+ZgG0FOYjtJ2syslVZQh
         A7g9kdJActLR2Olu+TLw+XR5uplmrsqAChci8Mm/ZxtTSTa5WMDu7VYyO6Iz52X0XW0P
         BuzAip3CzM42kVHJ1n29ADwATyKBPvBQ44WRpNrRqiiwtD/fd07tlIQMCIYfOoYNl6aj
         0+pVEIy/e5u8cwgNT/x+m4ARA3zcE2ypJtmD7by/p/eSpFg6KqEFszaWIfmuct4gTXIG
         08LLU0MqHDGKQs+h6DE3I2G8B0m/HbUdjp1dX5FZ9N1if7rBjbq3AR65S+zX2B+73U8S
         J8YA==
X-Gm-Message-State: AOAM533jIajBJvXXW4s+wD9XVzQgBb3OKUApyipmtN6CNbpenEK4AYdN
        bYtSPSQxGmuNbCeHbHDlv9U9qKz7h/2P/hi5hSgE93Rd7wU68z1UIqL6BsFezC5B0+688YpLX5s
        qcOq0TzvnQ6GjyWEV+KRj2/BDsRSbOkMnk98t+w==
X-Received: by 2002:a37:b95:: with SMTP id 143mr8973768qkl.99.1591370442344;
        Fri, 05 Jun 2020 08:20:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiRKoFyC7+KSUu0bTebumqj6H+GYJeqn0Vi9YXshBMYhgEJ+0LiFtl0JPhVCBEQS7trbUoaGP+WVFd8T+McQY=
X-Received: by 2002:a37:b95:: with SMTP id 143mr8973743qkl.99.1591370441971;
 Fri, 05 Jun 2020 08:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200604154441.23822-1-kdsouza@redhat.com> <878sh2iw63.fsf@suse.com>
In-Reply-To: <878sh2iw63.fsf@suse.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Fri, 5 Jun 2020 20:50:30 +0530
Message-ID: <CAA_-hQ+NU_3AXvjpvu=Bhd4fH8guktZ-+_NNVvQhBRhsZSzi5Q@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: dump Security Type info in DebugData
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien, Implemented your suggestion.
Sent v3 for the same.

On Thu, Jun 4, 2020 at 10:51 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Kenneth D'souza <kdsouza@redhat.com> writes:
> > Currently the end user is unaware with what sec type the
> > cifs share is mounted if no sec=3D<type> option is parsed.
> > With this patch one can easily check from DebugData.
>
> LGTM but I would move the security_types next to the enum definition in
> cifsglob.h somehow, so that it will be harder to forget to update one if
> the other changes.
>
> Since it is in a header, maybe via an inline func with a
> switch... simple but more verbose. Or X-macros [1] magic (might be
> overkill).
>
> 1: https://www.geeksforgeeks.org/x-macros-in-c/
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

