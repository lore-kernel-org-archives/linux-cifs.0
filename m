Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A96AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Mar 2022 00:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiCCABk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiCCABj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 19:01:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31655FAF
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 16:00:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49E71B82284
        for <linux-cifs@vger.kernel.org>; Thu,  3 Mar 2022 00:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122E4C340F2
        for <linux-cifs@vger.kernel.org>; Thu,  3 Mar 2022 00:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646265652;
        bh=3ELEbxIQAj3fbcdAImndmmy8irBgPb8IzTbjIafqsEo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ec1Su17hGjIC44f22DyToY4vzk3rujJGfHik+e02twI8/4e/SdL1UlWjuKBkZop2K
         p4A8ILBrR/DVhIINlcPW4CN8/fvgugx8BqT1OZKc6bAimxzIcFNf5e3QlQnCv5gELp
         lDQtgfZvm1ATqjJ0f9lez4hhNlk2zYhD0qTDqTshb6QujBeos/1r0lpc4nzsMR++nN
         CWKBud+71iU+14jrQBLXM3t6CmzuTS23aSB+/qqtTMD5GuBIIZCQ6TFaqvLoHkYlMb
         oSUQKdkmaQEkl8nVy5QLdsKo2mY2GKlKQI6AJA+O/Ew+MTMvPpHpomgE/Yx5UirXmX
         f7PcpnXBnXnwg==
Received: by mail-wm1-f47.google.com with SMTP id c192so2152788wma.4
        for <linux-cifs@vger.kernel.org>; Wed, 02 Mar 2022 16:00:51 -0800 (PST)
X-Gm-Message-State: AOAM532s3z9ZxaDbh7T2t8vXc0UMBKey9vxjEJa4nLhQpnsmzxJbuk0Y
        ixT5flETn0g3wqMzPhnCcbfNjFRlHU01YUcqOho=
X-Google-Smtp-Source: ABdhPJwjA1l4ItaDO+cbBFV9WOg3mhjgz32NzfQy2Zl0Ln/sJue9x2rxesZiESY1tQJJp4fSlJeUJdIK1g8N0O12gGo=
X-Received: by 2002:a05:600c:3d99:b0:381:546c:8195 with SMTP id
 bi25-20020a05600c3d9900b00381546c8195mr1727463wmb.112.1646265650346; Wed, 02
 Mar 2022 16:00:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:4e02:0:0:0:0:0 with HTTP; Wed, 2 Mar 2022 16:00:49 -0800 (PST)
In-Reply-To: <20220301110006.4033351-1-mmakassikis@freebox.fr>
References: <20220301110006.4033351-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 3 Mar 2022 09:00:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-c5+0CwFcDANz=zMpH7QwCVjYO-huP9i64nKM5cuc_nw@mail.gmail.com>
Message-ID: <CAKYAXd-c5+0CwFcDANz=zMpH7QwCVjYO-huP9i64nKM5cuc_nw@mail.gmail.com>
Subject: Re: [PATCH 1/4] ksmbd-tools: Fix function name typo
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-01 20:00 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Rename ndr_*_uniq_vsting_ptr to ndr_*_uniq_vstring_ptr.
>
> No functional change.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
All 4 patches have been applied.
Thanks for your patch!
