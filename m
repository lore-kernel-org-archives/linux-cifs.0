Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1EFC07E99
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 14:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B7561363
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 14:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhGIOxo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jul 2021 10:53:44 -0400
Received: from mx.cjr.nz ([51.158.111.142]:22514 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231921AbhGIOxo (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 9 Jul 2021 10:53:44 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id AA7627FD1E;
        Fri,  9 Jul 2021 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1625842259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+VLcWzFemZtnzUvg3rGPfg2QONoobY+n6twyK7ucax4=;
        b=Snhh67w9Z1/oyBgB06OKpZIzLXVn5H3EbigD7X6jOTzIADJ4axGm/ol7wTtRWkDo57W/Xl
        T1M/+n4+wl5F/OdFrR3VICAvHkJM5zl5EuZ+ivYD3dIeaLll/XJPOkjssuXzr5ol626yHz
        LFyCFo1Nu+wCtUvbp1g3i71szJXhVv/yjNKCZVhXKub/AEPu3AudCyko4w/VP8WLRBNiNn
        jVRqXB6LiBNjnO1utGhJm0ZUhWraqVh+QcMkbSxPwX01DYAm3G2T3I2P1yoiYZN8IhUU1v
        GtnNjD22/1fCPy0TFTiFqvquOEzLwDHjSBb27AHRx5+xyDwhLhxNTH7HFkIlxA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH cifs-utils] mount.cifs: handle multiple ip addresses per
 hostname
In-Reply-To: <CAKywueQV6AeQmN7v489oudW7NYQuJmt1xryuQvUZnpR+MjXLXQ@mail.gmail.com>
References: <20210511163952.11670-1-pc@cjr.nz> <8735uttb7s.fsf@suse.com>
 <877dk5jfny.fsf@cjr.nz>
 <CAKywueQV6AeQmN7v489oudW7NYQuJmt1xryuQvUZnpR+MjXLXQ@mail.gmail.com>
Date:   Fri, 09 Jul 2021 11:50:54 -0300
Message-ID: <87sg0nr169.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

Pavel Shilovsky <piastryyy@gmail.com> writes:

> Are you planning to post another version of this patch? If there is
> already one HI which I missed, please let me know.

Not for now, thanks.  I would have to repost the multip support in
cifs.ko and rebase it against current for-next.  Then figure out a way
properly handle the different kernel versions and/or compatibility
features in cifs-utils so we can decide whether or not let the kernel
retry all ip addresses at mount time.

I'll let you know.
