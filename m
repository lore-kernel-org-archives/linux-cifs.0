Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9582C636D6
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Feb 2023 17:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBIRDA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 12:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBIRC6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 12:02:58 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27EA4EFC
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 09:02:57 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l21-20020a05600c1d1500b003dfe462b7e4so4391486wms.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Feb 2023 09:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kupmZX3BXgrz6kfwxlLZNQNS/5GSb4Eg8LQlhgMzd/c=;
        b=I6ATeBhENMAitFLdaGwM8nJS9m0KtUGF+tUOW+O51KZXysahKej88q4yfiYGjNouGR
         +HmLDZun6IsXLX700WaV6e6wOX8nGAYJSUoZQ04B0JSC8mVo5kpeJdOJNC6tGJ5qVkTc
         wKu0uhR4/t0eq/ecyTUNILssQCCiMIjysu8Po=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kupmZX3BXgrz6kfwxlLZNQNS/5GSb4Eg8LQlhgMzd/c=;
        b=JtlrsEmLWNFVxJ7a3v5M6EgWfzf9EI2IDoqsgLT4TRtlNAL8v7eHCTliWKwcsOPFlp
         EFb4w/dOvOpQPfa1CwkQxO0xcnV0+y3Ys6e3Rqw7K+Ejz9UeQmipmnqeZUYrHHVcZtqq
         ZscrGcBDAOdqmRyJc7JEZ1zsOEK20RMud3tn1PXh2TjW5w/UsCdxFSvHFo3Q8wMDibEt
         +ez7VB9tf+Q48DK1L/PZd4lAGYleVoH3PHJ/lLeYNp9bdWHP3dc86Ep8svNgMr9Ezod+
         vtQtRCVLKmiXfqBqREHWQPbU/Bmc1xNMdw8WOyjQZnTPGYwz8l4firT9GmEt7gl2DRnr
         +dxw==
X-Gm-Message-State: AO0yUKXmuusAK7WS/5XyimqzSfldWBxWxmxKNED1skDosACg/x0YMAvw
        0ojhsJRmt/ckQPSKRKYpDy2Bucme3K/M1Ro94Rg=
X-Google-Smtp-Source: AK7set9OICT0HjfB1dadZTXP1csIRvcSgKUd5+uTqvHDmriXER/81z7C9SoL+ZENoP6Cqep/dPJpjA==
X-Received: by 2002:a05:600c:713:b0:3df:e4b4:de69 with SMTP id i19-20020a05600c071300b003dfe4b4de69mr10519794wmn.27.1675962176291;
        Thu, 09 Feb 2023 09:02:56 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id t14-20020a05600c198e00b003dff870ce0esm6049280wmq.2.2023.02.09.09.02.55
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 09:02:55 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id m8so2626884edd.10
        for <linux-cifs@vger.kernel.org>; Thu, 09 Feb 2023 09:02:55 -0800 (PST)
X-Received: by 2002:a05:6402:50d:b0:4a3:43a2:f408 with SMTP id
 m13-20020a056402050d00b004a343a2f408mr2101218edv.1.1675962175259; Thu, 09 Feb
 2023 09:02:55 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mut-6o5Jy7Kb8ZmjyRDikAi7iueqNStX1JLdixrFmJPZQ@mail.gmail.com>
In-Reply-To: <CAH2r5mut-6o5Jy7Kb8ZmjyRDikAi7iueqNStX1JLdixrFmJPZQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Feb 2023 09:02:38 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiyY4ahLjKfvVho0CiCj-Nv0P3Edxqfu4bH4TcsZmsBJw@mail.gmail.com>
Message-ID: <CAHk-=wiyY4ahLjKfvVho0CiCj-Nv0P3Edxqfu4bH4TcsZmsBJw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fix
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 8, 2023 at 8:44 PM Steve French <smfrench@gmail.com> wrote:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc8-smb3-client-fix

Hmm. Malformed git pull request with no shortlog or diffstat?

I've pulled it, because I can see the SHA1 matching, and it is indeed
a "small fix for use after free in readpages", but I really do want to
see proper pull requests...

            Linus
