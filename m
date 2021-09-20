Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94EAC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E12610CE
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhITPWP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 11:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241338AbhITPWP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 11:22:15 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E7DC061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:20:48 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id z24so43085469lfu.13
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3X53aIVL6g8iMaogeyojEhv5E4srczP3SVuOMg2CZw=;
        b=qqnm8anqdbUt4RYrWCaAEHE/JMd3HIS6SyiApcxKpgKNByr0+rkkPuJjw5BnFKKaDw
         RYcbnsrhZVZXMC2WeY3Uap3knNgRS298qgzoraahp18ITRgJSO733in6tGOoYxK97B9Z
         V79KQQadeLfcm2vXeJAwOJIS3GpwjLjZ1SFOmbDg6cGtzTnYAvo9WsdZDin14n83fa7b
         gNZV3aoAYboWeLZpRsiVtxjwazo/Rq2RBiPXEavaabnYyPjiq0lBFf0/Q2wmQmzphHn1
         mQOhDWSE/WXPdPgsOUGfVowg4vqHtVU5mTAnSDe4ZeqceDBeuImMpL3mZFfLLCExvYMY
         lL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3X53aIVL6g8iMaogeyojEhv5E4srczP3SVuOMg2CZw=;
        b=wKWr3D5ZEHwF2yRB0SDl1Pu0o6o3fH7aTKvWhtVVhSHPwLgPPA2oG9vtH7aZTOQZUM
         4sAEPYwLxxnW69Cn3Uyhtjo2E9pJGbRjzq1ekitoxlVA6DZgGIqiHWDhZkTrLqDUaynx
         1/HCOwcGdk9v7r0dN7bV4tk6kXHXI+FVKIdGPkagadpA/4aJVXn8GL1EzRv3X8ezrzfs
         Ne4+PwAzlo47xjeO3n9D4XXA2s/LM+AjFt6Mlzil8AR6xwXYFHLnmOr0bOaWXsCUxDuS
         UoRzp6W94byPVZjBMsbRswFrSu9ZGF+Az4fC/lU0Pl2mRMesswKTjNukANQDLc06sqRe
         tYqQ==
X-Gm-Message-State: AOAM530vX44xyTQk+4OIKEbGOqtGshkyerRzUTqVh6vRVoHMd1nHJT/v
        4dB2ROenBr8pAlWkFTFmwqXhsCRGhOzFG+WTkYw=
X-Google-Smtp-Source: ABdhPJy37EqsVMjJr05bSuWdn5GK8tQFKFRtsZnY6D+F7SycKDAazpXBp08A8nk9GFqursh1nlc/20J6Q9s1Rwzj0J0=
X-Received: by 2002:a05:6512:32c5:: with SMTP id f5mr4637093lfg.234.1632151169104;
 Mon, 20 Sep 2021 08:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210920065613.5506-1-linkinjeon@kernel.org> <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
In-Reply-To: <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Sep 2021 10:19:18 -0500
Message-ID: <CAH2r5mtT2b_9HGP1_Yii8tVu6vmwyDu6y_9pj_Y8haqQtvqnRw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 20, 2021 at 9:44 AM Ralph Boehme <slow@samba.org> wrote:
>
> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> > Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the
> > middle of symlink component lookup.
>
> maybe this patch should be squashed with the "ksmbd: remove follow
> symlinks support" patch?

These two could be merged if it makes review easier or less likely to
cause merge conflicts later (in this case that may be true since they
both touch smb2_open), but that assumes that removing ability to
follow all symlinks is agreed upon.

Removing the ability to follow symlinks may be preferable, but I can
imagine cases where the admin is exporting only via SMB3 or only read
only where symlinks could be of value inside a share and safe (if
remote users can't create symlinks outside the share).   I don't have
a strong opinion but also can imagine cases where symlinks could be
required (share exported by both nfs and smb3 e.g.) but obviously
checked to avoid escaping from the share.

-- 
Thanks,

Steve
