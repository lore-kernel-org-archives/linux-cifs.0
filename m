Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEFCC7EE26
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 21:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238538AbjEWVpM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 17:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238599AbjEWVpL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 17:45:11 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522B6E59
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 14:44:50 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-97000a039b2so16030366b.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 14:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684878289; x=1687470289;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8wIZSCQ8edYhjFZ+60ckyujMxmrvzH8jxmNqi1okaVM=;
        b=e/GdEeOEJsY//5MQ/xaJHDvgLsxvC1Q52QEdUm/n9PlkqYc158HieNZiwJSpBhOesA
         8x2PU9LzAGrJAAmR/3Eiuug3CvNisa9MtM3EsXAOQCleQRousmpOraR1I0QGXcGRx1Kh
         eYadhC9J2RwUhlJoRSGk2gh96k8v2sTC2H1li8eP6+YpvTfwuA7i0cXcV2siOUL48Vax
         QqjtR8FUQj+Q2DvDb1ImjoGK5PLMQADiGUdl0+WzGjXMxTGfE+pRveuckZNO9vI1kNKX
         kqdTCBpDH2tZhRv/g4XvlvT/xYwxvKUsBGJvEDeZQxDeqRK1eMENwVpbo/bv85d9MQPI
         qPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684878289; x=1687470289;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8wIZSCQ8edYhjFZ+60ckyujMxmrvzH8jxmNqi1okaVM=;
        b=Hwscc3oBj9WsrOY5HuA3OjaCXmG5241O7u3NmLudTdadr/tytkESoo2BUYAgu3+DFC
         gM3Iiqj6afKdsOjn4xaWfvDJGsgYD9gQfn8HL49hZA6orgkS406ovW6V9wjkznis2pEA
         ZUa59RlEEJBmImd3fj7dfIGHtHQO+sP9YCnaddxkwiqU5OBq8SuC1Eon8GSWst405j1e
         qeqMTTtAqCVgAgigkgRj7gF9Z0yh6Vs5adSHxZEULCqnUaxIl27+PaC6xiW5zVefrLYh
         t5Tx/aWYpOO5OtTrpIEbqifGZyqh9bJVli0DOurMBVksps+EsA+UbiKhhTC/LUaydP5k
         /uxQ==
X-Gm-Message-State: AC+VfDx8ejjGe2fp7i873AsSg9lT1wXZHHqmtC6joZOQwpjrdeENgsHv
        esByHX2/iIkFCsQxxykgpFJLRRTm0ASF+NrZR0OyVQsq
X-Google-Smtp-Source: ACHHUZ6LFhG0r6xBndZvF+/Yf4c5IOH7uL8J6uEefVhtJqDEVnkJJytAnjWJQGt9ks8h9RiJxb7NxeUOUSRTSo7lroU=
X-Received: by 2002:a17:907:1b24:b0:969:b2e2:4f29 with SMTP id
 mp36-20020a1709071b2400b00969b2e24f29mr17580538ejc.53.1684878288553; Tue, 23
 May 2023 14:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
 <ZGzo+KVlSTNk/B0r@jeremy-rocky-laptop>
In-Reply-To: <ZGzo+KVlSTNk/B0r@jeremy-rocky-laptop>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 24 May 2023 07:44:36 +1000
Message-ID: <CAN05THQyraiyQ9tV=iAbDiirWzPxqPq9rY4WsrnqavguJCEjgg@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 24 May 2023 at 02:25, Jeremy Allison <jra@samba.org> wrote:
>
> On Tue, May 23, 2023 at 10:59:27AM +1000, ronnie sahlberg wrote:
>
> >There are really nice use-cases for ADS where one can store additional
> >metadata within the "file" itself.
>
> "Nice" for virus writers, yeah. A complete swamp for everyone
> else :-).

Viruses? I don't think they use ADS much since most tools under
windows understand ADS.
ACE's on the other handd.
Which reminds me I need to write that tool to store/retrieve files
stored inside "hidden" entries in the security descriptor.
