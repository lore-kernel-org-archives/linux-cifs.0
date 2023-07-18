Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C4BEB64DA
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jul 2023 15:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjGRPTe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jul 2023 11:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjGRPTd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jul 2023 11:19:33 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43527DC
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jul 2023 08:19:32 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1b8eb69d641so4336917fac.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jul 2023 08:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689693571; x=1692285571;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KLaXtYRlST2Sj1AOgkosx08WFbMk+YpujA5IY3jgiNI=;
        b=mE5Lz0b7KfD56g2jw0ln8jxX7Uwcn1YG+w7+iPdCcPUMKmF7QKlCAUalsD9fxlj0w+
         9n+1f0g8Ilm2HmJphg+VtPUMEuFFtRbRdH+Lk6md+/i8uSSfkN54aYu2s1FGHyOceZAf
         0Lm8zQrAA+3Sh2Qdu8McVC7A5HeYYU5z9whL4faUFZnPtQySKVf0EEmcj7sJ8btzpxWA
         mCgzgjXpXMqpQaQA2YVM5CyH9gUre0xKbuPeZT5dsZzNrmW7sfjknwsxtmk9V97BR9YN
         gvRsLNj6KP8IIpw2ri4LFNvuzJVfDqNx5voZ+Vt6gegQaAznIBkgevfM4mcJS4dLVX6D
         U0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689693571; x=1692285571;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KLaXtYRlST2Sj1AOgkosx08WFbMk+YpujA5IY3jgiNI=;
        b=hE3+Fxr39339wA0Cjw9jg8I/pFeJz7mFVYFE+MjPiYUbId8mUWLGbFsDMyZ2xkO5OI
         X1ENAeBpfKU/tmkysj3vnn/QNkvmiDa0JpMu8VBCYsPdbGHkj4/I/XPYxAVRrs5A1P3M
         KTuUvuLRNaG4kXXJtfH/brFqcX/Ih0ICDA5DMJe0sq4FqqTTXC0CE9UWbfxhgak4x3Cg
         zuXfJ6QlRViUZURE/9w473id8f9ypkmYs6s241fq2dCBsbZ+5nbLOGxQYKxg6763zu1N
         8OP+ibpqh8nG+mOaWDn9EnnsSvcbJmwfCVo30g4NcX1t68i0Mbve7MdRU7UkVSSrAPR4
         FPdA==
X-Gm-Message-State: ABy/qLZiIt8FG/5Ju3Tx5Y28ak+x+HWOnwlSTtrndANEa63odwEFH8Lb
        1vRNLyyWavH/DkJ2SKm5qgltKMS/6ZG9gXgkCC7GeO4xEUw=
X-Google-Smtp-Source: APBJJlF+5K7Eg/6f2Z6UGqLIyXR9oEsq9ZgDuwakI28pBUqYu6AC/DlxodrBRvnGwPZOpiR/ugk+tTVVnLviDm5YSSs=
X-Received: by 2002:a05:6870:6194:b0:1b7:8836:95bd with SMTP id
 a20-20020a056870619400b001b7883695bdmr14835931oah.11.1689693571151; Tue, 18
 Jul 2023 08:19:31 -0700 (PDT)
MIME-Version: 1.0
From:   Roy Shterman <roy.shterman@gmail.com>
Date:   Tue, 18 Jul 2023 18:19:19 +0300
Message-ID: <CAOBqJ54ZGwCjuwZZwdTag3p-xSjWk_0Y1P61gbjVS5boCn8oLg@mail.gmail.com>
Subject: Question about NTLMSSP_NEGOTIATE_VERSION in NTLM messages
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I see that in the commit bellow we added Version into the negotiate message:
commit 52d005337b2c94ab37273d9ad8382d4fb051defd
Author: Steve French <stfrench@microsoft.com>
Date:   Wed Jan 19 22:00:29 2022 -0600

    smb3: send NTLMSSP version information

    For improved debugging it can be helpful to send version information
    as other clients do during NTLMSSP negotiation. See protocol document
    MS-NLMP section 2.2.1.1

    Set the major and minor versions based on the kernel version, and the
    BuildNumber based on the internal cifs.ko module version number,
    and following the recommendation in the protocol documentation
    (MS-NLMP section 2.2.10) we set the NTLMRevisionCurrent field to 15.

    Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

Now if I understand correctly the server side should return in
negotiate flags the flags he got from the client and that it supports.
It means that in auth_message where we construct the negotiate flags
we will have the NTLMSSP_NEGOTIATE_VERSION flag as well although we
are not sending the version as part of the message.

Doesn't it contradict the MS-NLMP spec?

Thanks,
Roy
