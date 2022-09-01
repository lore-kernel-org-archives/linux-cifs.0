Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51A6ECAAD5
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 19:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiIATmq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiIATmp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 15:42:45 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4182F696CE
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 12:42:44 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id bn9so168200ljb.6
        for <linux-cifs@vger.kernel.org>; Thu, 01 Sep 2022 12:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=e7YObGEe2XyiRHf9LTW0FOKQWi4UQsrJEF0POUUX70Y=;
        b=YFr7odEF7VFVdHjkdT2gvb4AqICIH2F2tF9EIZH9Veq2bnmUEvbMrW/OCQ4QRItVSF
         +ETsIRrouaf3QUAJSztCTXz/tA+VO2fY2puxJ1wdCBWMyPUJ/mIzm+KZc9TZvyz54sLM
         9jbQUYfcDDHvgyWhNzdgXnerRoGu3ndxD7DGnIRtJc/W0motpK07MrMlk0lSHU54mHKM
         aTyg+XjEOkV+m8laiCMrqjlb5uJ+RcNrhD+0UL+OSpvKkJf9NQCSFv35zbTMaDQ7evlt
         ZuOvKVMAUELrl3cZIAe4HGiDmEqnXziNqFSGU/DmcKsSBSe5+NFRERp5E74G3FTd9VFj
         ji1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=e7YObGEe2XyiRHf9LTW0FOKQWi4UQsrJEF0POUUX70Y=;
        b=z9AisZXVlma+zZlrm21y/hnXLi2n8fALOKD2VawoNATbSEuheNFeuqCbsKt8KYWZyh
         vlqZc2oT9FjoZVBc+H4+t7c/k/GXVIbTO2v1ZkkW7uGbxYnCuyplCGLj7ScVnQ3Guysk
         n8e4MeXagWWZHyyTbQLAmhL4zEisH2spnEPWiNB1alqIP83Frw5sp1zDWG+dHu2nq5hc
         0J0Y4StvaQaRk/HUIVu2UbfYlM354D+lnV75ilbJH0GJ1ZK4Qq+lPQYVtrx14Q/cu2Hi
         7jIw5d5jW0QCWe24QAWg2goctmprhNgnJ2UWEGVQ8HvoO+S3UKsfvEMmCS5JX82mOzcK
         Zv1Q==
X-Gm-Message-State: ACgBeo0ArkcCnQBSCm5FEeQyFASDidww2980E6Z10vj6U1h2+7qBEVIM
        EiCllpnRQc3cc0npqckAWK4=
X-Google-Smtp-Source: AA6agR4M9FZOtPIu/5U2Elf7YSm938JZme/78n/ZO/FIO2T9Op5HckPCnc+SSt0IyI1Y0wVwo1bTBA==
X-Received: by 2002:a2e:9216:0:b0:261:e2ae:8b0e with SMTP id k22-20020a2e9216000000b00261e2ae8b0emr10411833ljg.454.1662061362547;
        Thu, 01 Sep 2022 12:42:42 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bf-218.dhcp.inet.fi. [46.132.191.218])
        by smtp.gmail.com with ESMTPSA id a21-20020a056512201500b00492d270db5esm672392lfb.242.2022.09.01.12.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 12:42:42 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     jra@samba.org
Cc:     atteh.mailbox@gmail.com, hyc.lee@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com, tom@talpey.com
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Date:   Thu,  1 Sep 2022 22:42:12 +0300
Message-Id: <20220901194212.28441-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <YxD6SEN9/3rEWaNR@jeremy-acer>
References: <YxD6SEN9/3rEWaNR@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 1 Sep 2022 11:30:32 -0700, Jeremy Allison wrote:
>
>Samba adds and or changes functionality in smb.conf all
>the time, without coordination with ksmbd. If you call
>your config file smb.conf then we would have to coordinate
>with you before any changes.

ksmbd-tools has always called its config file `smb.conf'. Has this
matter come up before? I don't have anything against changing the name,
but I'd be surprised if my writing of the man pages first prompted this
concern.

>
>Over time, the meaning/use/names of parameters will drift
>apart leading to possible conflicts.
>
>Plus it leads to massive user confusion (am I running
>smbd or ksmbd ? How do I tell ? etc.).
>
>It is simple hygene to keep these names separate.
>
>Please do so.

Atte Heikkilä
