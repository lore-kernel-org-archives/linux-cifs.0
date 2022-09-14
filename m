Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2205ECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 11:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiINLKd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 07:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiINLKc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 07:10:32 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4515F204
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 04:10:29 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id j13so3067377ljh.4
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 04:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0m+STUgyKm3PsGxk9Bt9u3DoQxaP6CdGIQkaRsNx/rY=;
        b=YtyrkQTjWXJiwWiLmPyVyppxMKWiZxmRvJ+PDatAxZN3Wktu/jd9zirzmhk982pgxk
         anZhCmmkxE9m8zWf+uCW7a+IxYe5mN+obOG8bBMAQHDSuwgXo9/khJ30M2B32yAmqWSE
         pfC+u/UWfLoVsZ35jYCIaVc8e98u3/4utOlNX7rTNx+8COpnWz80GAMlmBy5iIQP5qnC
         RIKd2LwUyLoazYpkagLsa1j2b1DUeetbZpJKhSdLurqwXr6HhgxmW8oOfZABkih6saB8
         VA883lmp4Is4enVwUrADwAL5Ru2KsIupy1hTu/1XIy5M/7N+dV7I3qIbGZQGVW0oKOVM
         3BEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0m+STUgyKm3PsGxk9Bt9u3DoQxaP6CdGIQkaRsNx/rY=;
        b=PtjcEQD2lAA8d+mSHDy6ufsqvE3uj70fZGBGVhqu4qXWYigrWUMp96pWeiG4MJMvPG
         fYq8uHcccakfbdgxPo20TzUOvpAzEr56G38NMNRYIZ1aDCdt0uudYH9jAA6bTa0TeS15
         wqiq4WvSLlVihfEXZyZWxcDTQaLRdE8UTn8W63lWDsjR8NI5Om4j9WszheBfwakNc6In
         9BfxefbL/NhDbMHOuHnuNgTKug2l1M0pW0mq4wsCh4E7UXW9KY6WaGCgjFp4gxO9j8D9
         Ok5uYucXpp/qhn7Tdr0CdiaX5caNrV4p9Eh+vH62jXvtXsvDpdnCZ56DJGu3xpl1uwVo
         SLKA==
X-Gm-Message-State: ACgBeo1JWwevgVxIuXvkolqGi4VXxClmignUTZKiP1J83z9vPXNS9c+E
        lGdbyQCwyzOi6QjaC7SmVsA=
X-Google-Smtp-Source: AA6agR6bJLAM4o0yE/FTwLB6IAj1x4u7oK7TJ1Z2xkzjYMUQcs2FAkRGgZAdPMXJIubI6o1RC57OyA==
X-Received: by 2002:a2e:6d02:0:b0:26a:cf02:40c4 with SMTP id i2-20020a2e6d02000000b0026acf0240c4mr11020194ljc.513.1663153827244;
        Wed, 14 Sep 2022 04:10:27 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bc-66.dhcp.inet.fi. [46.132.188.66])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0049478cc4eb9sm2330732lfr.230.2022.09.14.04.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 04:10:26 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     tom@talpey.com
Cc:     atteh.mailbox@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com
Subject: Re: [PATCH v3] ksmbd: update documentation
Date:   Wed, 14 Sep 2022 14:09:18 +0300
Message-Id: <20220914110918.5720-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <388d1257-419e-f0c8-348f-587f5c0a51ee@talpey.com>
References: <388d1257-419e-f0c8-348f-587f5c0a51ee@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 13 Sep 2022 12:02:47 -0700, Tom Talpey wrote:
> On 9/12/2022 4:54 PM, Namjae Jeon wrote:
>> 2022-09-13 8:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>
>>> I missed this in the v2 match - are you intentionally moving the
>>> ksmbd.conf file to /usr/local/etc? That seems a very mysterious
>>> location. Nothing on my vanilla installed system places anything
>>> in there.
>> To avoid conflicts with the existing distribution package, the default
>> location as far as I know is /usr/local/etc. And it can be changed
>> with --sysconfdir. It is same with samba.
> 
> I totally disagree with this. The kernel server is part of, well,
> the kernel, and loading the kernel should not depend on a path like
> /usr/local/etc.

I really don't understand what this means. The dependency to the
sysconfdir path isn't ksmbd's, it's ksmbd-tools'.

> Also, nothing I know, including Samba, is deployed
> with such a directory in my experience. I find smb.conf in /etc/samba.

Yes, that is because your distribution builds it for you. If you build it
yourself, and don't want to collide with your distribution's packaged
version of it, then you choose some prefix other than /usr.

> 
> Where are the ksmbd.<foo> helpers installed by default? /usr/local/sbin?
> On my standard Ubuntu install (and presumably Debian?) they are in
> /sbin.

Yes, the GNU autoconf default sbindir is /usr/local/sbin since the default
prefix is /usr/local. It is distinct from the sbindir your distribution's
packages use. Your /sbin is (likely) a symlink to /usr/sbin and the
distribution's packages install in the /usr prefix. The /etc sysconfdir
is associated with the /usr prefix. You can also check what FHS has to
say about /usr/local if you'd like.

Namjae's way of running configure is correct. It's either this or colliding
with file paths used by the packaged ksmbd-tools, which isn't a good idea.

> 
> Tom.
> 
>>> Also, doesn't this file need to exist before step 2??
>> Ah, Yes. Will switch them.
>> 
>> Thanks for your review!
>>>
>>> Tom.
>>>
>>>
>>>
>> 
> 
