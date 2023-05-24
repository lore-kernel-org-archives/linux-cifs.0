Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B062C7EE2F
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 01:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbjEXBoW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 21:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbjEXBoV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 21:44:21 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55663184
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:44:20 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-510eb980ce2so818033a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684892659; x=1687484659;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JEaiFobRhUHQmO7Q88SZdG5k2e03jpjx9wkte3MBkdI=;
        b=lYsTzh8G31q20XZ5PLKqwhkn8edsPh93g7ep1h42P5bVJzjs66fqSa+KJ7Gd82qgg6
         QTzoBG0NLZkIka/ZJLD1PE8IJPOSb6tF3dqvlDJy6dUcQDrbiIFz9S8wx4rx8c2Ep4RB
         fIysZfyHPYr76fLbn8kQC9xiOkxYUy2zqztUZwzLRSTotRn2rvO+FNkPRefRHj1GFmB0
         Mle6a49Mkin5R5x+1tlYRRI/9t07z/+ntQh8aZIlja/p6aNML8u9CyhUIMR95vw7DaDn
         i0zQxt2N9Ah+T39YbeaF1q/782ly7clXMi2mTE9Ye2j+ggwkkq6Qm2H9AS3iALaX/bVP
         yqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684892659; x=1687484659;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JEaiFobRhUHQmO7Q88SZdG5k2e03jpjx9wkte3MBkdI=;
        b=BqrZWXH9guz8s+2vYrbSWAdceCItz16/2ttGCF6A2Y0FzsZxne6EPe3Fp+2lLl+w/u
         RTCYXapqXIcQqFzULL6vDNvfuVU1nrqLcJpvG1zdE0I2/9a6Msg8OwKsBxnJOjzvzAXl
         IZMP0DjSRKGceeKBa+VPuq31V93xuIPrZ712L6c7b6nUcELGrdyEPQ5rs8c5Gq7sblf3
         TYlXaCp6F/973juK+yDSKNgTQm4nhIirVK05QuUJqaYRH7cTXSoMHc1DAh/vygKsDmAJ
         zsxHcIRMky+tv8V64buXZkg1CYAiWD5LrRZeF42mDLcZUzlYOsN5tLDkv/kC3Z8kMQpB
         FxFw==
X-Gm-Message-State: AC+VfDwAe2B2AJDJsz6R95sUsD/o3fw2aZze99/SxM2/xmabkKSv+pzQ
        zDEGbMatnSQBZKHe6gRCT4u7c1tdKiLUP1TltOw=
X-Google-Smtp-Source: ACHHUZ6XErchnKW66o6d4jmoNTpUdM4Mvdq3QKRODtWgM2ubx8AJfl/ZM0QPNssqDrYmpYnOwo0fdpVorNh56lpurZY=
X-Received: by 2002:a17:907:3e9d:b0:970:d43:7fd1 with SMTP id
 hs29-20020a1709073e9d00b009700d437fd1mr7546351ejc.52.1684892658619; Tue, 23
 May 2023 18:44:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtuuGd-OR-Ran9XWDzv7pW=pv6xUBGZExE87+NrChsRoQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtuuGd-OR-Ran9XWDzv7pW=pv6xUBGZExE87+NrChsRoQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 24 May 2023 11:44:06 +1000
Message-ID: <CAN05THRgK3isCm49pA9gTOkfbZOabXeJ0c-X3oC-PdJUvg5XRg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] display debug information better for encryption
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

lgtm

acked-by me

On Wed, 24 May 2023 at 11:38, Steve French <smfrench@gmail.com> wrote:
>
> Fix /proc/fs/cifs/DebugData to use the same case for "encryption"
> (ie "Encryption" with init capital letter was used in one place).
> In addition, if gcm256 encryption (intead of gcm128) is used on
> a connection to a server, note that in the DebugData as well.
>
> It now says (when gcm256 encryption negotiated):
> Security type: RawNTLMSSP  SessionId: 0x86125800bc000b0d encrypted(gcm256)
>
> --
> Thanks,
>
> Steve
