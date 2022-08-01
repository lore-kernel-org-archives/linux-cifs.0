Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C270EC00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 08:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiHAIZ2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 04:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiHAIZ1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 04:25:27 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB2220BE0
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 01:25:26 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id f5so6130352eje.3
        for <linux-cifs@vger.kernel.org>; Mon, 01 Aug 2022 01:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hq2GqhSOlnPd6BLGarUkWXRZ832PGoqTbAwXrtyaqZ0=;
        b=c7NT/e94hzf2uHmP1vSgrP0u3RO8u1b/uZBbZMRYXmCbc8NQxnYymfC/kcnhUNL/T1
         ErPufS4zOYcFhI1e9abhIcNGVRIjcST97ftLoY0uqVQxuWev2Uk8OWENROgpgW3hnVtE
         tDoLg2gOc1NTKcJJ2Rhf8657R9rM+fE6pX3OHfPePgy/5RDSXkoGJJe/i++Lr2d694ik
         /t6CV72yizLXDAx0BSYsMRsV7Q0ZeGP2oPB7e1aBZ3lU8x5jp0f7Oh5A5pDUXhEExksg
         trZGbOouIcBBl1JMl8yxzQNSsMaYtZxHY8y+KhtvJukS2x+xHnYIfWkMp0S5j5Pg3aEH
         +YrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hq2GqhSOlnPd6BLGarUkWXRZ832PGoqTbAwXrtyaqZ0=;
        b=7ebtTxQIOaykZG7yVOSxv+p0GpnAoNdkWfG9rhSGhoebQhxWYZTRdAKMXkdOioR4O5
         WiGlYtuLhqU7ZR4lPLwzCqd4/SoAiOHPToOY+rVAqazuWuFJ8B5uIBxbIQWk7Ol3pqDl
         wOGTCAxwEl+mWKEx2h/Xjzf3DM4wptP1D1KbHoLCOkmzvJYc4EOlhTnZSiKzquoA6xgF
         c13Go7fH5gODefwxM6mF5vYeqkjRqnH0eu5CFkF7GneKKn8M8OsjqKI8QjEwc2eAg7yB
         z4f7fqJ+CJCdAn1lgnkThEHv/PeikGqpo/36XmQfWDoZxtlhXLJVu78MdVfj0Yx4S4uD
         2vnw==
X-Gm-Message-State: AJIora+WtgfkCcTdaOo7NbXCo9t/JdhSFtSJC5DwctDH5R0K+zdLigWt
        Fva+m3afcLmcxq0MOCPGtFFI2iovaWQZ6MgNPLHLUuXo
X-Google-Smtp-Source: AGRyM1t143ouwfgB3aF/Co5kUy+r5YupPTXg2lkmXEXRjwb3PbZwxh+szDcpveSqnqEN5lZ0u3rbScXUCj8oTxwyl4g=
X-Received: by 2002:a17:907:a0c7:b0:72f:b204:c281 with SMTP id
 hw7-20020a170907a0c700b0072fb204c281mr12036388ejc.720.1659342325267; Mon, 01
 Aug 2022 01:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
In-Reply-To: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 1 Aug 2022 18:25:12 +1000
Message-ID: <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Small nit : in cifssmb.c  why comment out smb2proto.h,  just delete the line.

Otherwise, a good first step. Good work.
Reviewed-by me.

Maybe we should now also add a warning to smb1 mounts that smb1 will
be disabled by default in say jan 2024 ?




On Mon, 1 Aug 2022 at 16:28, Steve French <smfrench@gmail.com> wrote:
>
> Currently much of the smb1 code is built even when
> CONFIG_CIFS_ALLOW_INSECURE_LEGACY is disabled.
>
> Move cifssmb.c to only be compiled when insecure legacy is disabled,
> and move various SMB1/CIFS helper functions to that ifdef.   Some
> functions that were not SMB1/CIFS specific needed to be moved out of
> cifssmb.c
>
> This shrinks cifs.ko by more than 10% which is good - but also will
> help with the eventual movement of the legacy code to a distinct
> module.
>
> See attached.
>
> --
> Thanks,
>
> Steve
