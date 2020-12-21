Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0A0C433E6
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Dec 2020 22:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF06229CA
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Dec 2020 22:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgLUWx0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Dec 2020 17:53:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38090 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgLUWxZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Dec 2020 17:53:25 -0500
Received: from mail-qk1-f197.google.com ([209.85.222.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <sergio.durigan@canonical.com>)
        id 1krU2k-0002zE-NP
        for linux-cifs@vger.kernel.org; Mon, 21 Dec 2020 22:52:42 +0000
Received: by mail-qk1-f197.google.com with SMTP id n190so9949648qkf.18
        for <linux-cifs@vger.kernel.org>; Mon, 21 Dec 2020 14:52:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=ztDo0Tvsi1+V8rQ/rPZZeoJWxZBaDcxlV8+/nx7XrOE=;
        b=U1XP+oAIrwtRoho6wrZMolmDJihPN0Oz2+K4m504aE7WXvWSmrs3OsR1TxKdF4Te4/
         u66FKTce7gsPRqgmkG+d8Zi7eHUpn/i+cXoQ6toLkWpSrQfrM9s3ngfLoXLo9NdYH24O
         FakNxcmPpUxdCOPXwvZ3gMNINW25ayUs7XPCH1unA7s7nhoA7yxNQtMrPEiA5iCQSs5P
         JlEEy1xERii3ns/NlGUttffJrodJ24zVY7UaohSWy2aQakP1VSxdnGlPMxgGfD/hO4JE
         8y2NQ6M2DaagbBMiZMJYWm4p3+6kLJnE64ALb/IUSoqfMVmPpY444n0aFm5X9jDx+GqT
         hCrQ==
X-Gm-Message-State: AOAM5324t/hDD8tIqEAyhIjukOKOR7LkqcIgRaqxl2wHW/EEauXoVN6h
        nvNuCsyHjE4Z8Tu4iCTRlQUrPDr6IUcJqoiJhZ0FloJoKrUjp83cGYoEu4W8YJB+qJYUFpVPQV3
        MEH2Hay6Yb9LYXnjTyd0gaqpG7gPD0oxXxWYtMv0=
X-Received: by 2002:ac8:58d2:: with SMTP id u18mr17966924qta.235.1608591161860;
        Mon, 21 Dec 2020 14:52:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNfKoODIVfQLccrluRLJXlVuf8R+ByZDUjn/6RDlI7wfyEux+oF7L4LKHvjkszgEDXzRBtSA==
X-Received: by 2002:ac8:58d2:: with SMTP id u18mr17966908qta.235.1608591161538;
        Mon, 21 Dec 2020 14:52:41 -0800 (PST)
Received: from localhost (bras-base-toroon1016w-grc-29-76-64-118-63.dsl.bell.ca. [76.64.118.63])
        by smtp.gmail.com with ESMTPSA id n5sm3354730qkh.126.2020.12.21.14.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 14:52:40 -0800 (PST)
From:   Sergio Durigan Junior <sergio.durigan@canonical.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] Separate binary names using comma in mount.cifs.rst
References: <20200609180044.500230-1-sergio.durigan@canonical.com>
        <CAKywueTDHV112-y125ROPK2aa+w6A1Fd_4x82YVEU6LauaAS9g@mail.gmail.com>
X-URL:  http://blog.sergiodj.net
Date:   Mon, 21 Dec 2020 17:52:38 -0500
In-Reply-To: <CAKywueTDHV112-y125ROPK2aa+w6A1Fd_4x82YVEU6LauaAS9g@mail.gmail.com>
        (Pavel Shilovsky's message of "Fri, 28 Aug 2020 17:22:46 -0700")
Message-ID: <875z4ug4ax.fsf@canonical.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Friday, August 28 2020, Pavel Shilovsky wrote:

> Merged. Thanks!

Thanks for the reply, Pavel!

I'm writing because I don't see my patch merged in the git repository.
I noticed that there was a cifs-utils release recently, and
unfortunately the patch wasn't included.  Can you double-check this,
please?

Thanks!

=2D-=20
Sergio
GPG key ID: E92F D0B3 6B14 F1F4 D8E0  EB2F 106D A1C8 C3CB BF14

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6S/Qs2sU8fTY4OsvEG2hyMPLvxQFAl/hJzYACgkQEG2hyMPL
vxQBag/+PM4zSkkqk2g/lpEYZnVqqH2mml3Uy2T2DUWIAM49vTMWnkfuZpvrpphw
WKK39RJq+A+pXVjsJwWVecqgX/gGra1rU6avBCKN9Slxsm6fIJsGatw0fXs3MOe5
eWhES9Y/Rg1HigcZ5IeqUku+w0sd8GZfadBgNzL/hT+9TwA+qANwaTEAWcfG5XWy
zA3Xuj1Y7BWEGMsNIRFKJ+D0YvX3NTIGkeQFm9MVeuZRlUwuoBD7Ko4buC8KLlC+
7yDQTT4oIAEintoeC4gAgJhUZJJ/p9ml5gzxayjKbAMuU2r3HMWpoUof/dPvtDns
w/8B3PNWxh330tyXSjcqm+3KSkYm472rwpw+sx21X2w4PVTH3gatluCHvlkokd7W
YrKEdK0aFNBIQsVJ8K/wvf3b3BhHeKxfmYI+cQIJdjcEatvtA9J7Ob32DoJK7ZH7
fjKNogcaq2OUdNH3touGNcUcIdVNiKh9Lb68iKjoTdfGspVcmQ1rF+MjpmnApm2W
rllVO2KiA1NnIR+J4VFI7+TkS23U8Hj4Jsh/74QptPGsW0M+gXyAXnkcfC5qV96E
1RVcAwrqcUd9lG4P7IeVtHNu2ouXUyuhf/CwGuLMmcO9H5c92qnyMgerdXW7lcQ9
HI9OyFE2gxIFrgecmEOPi6Z7dx1Ugf6mbZX0raTWn9lL7b5VjNQ=
=M8fF
-----END PGP SIGNATURE-----
--=-=-=--
