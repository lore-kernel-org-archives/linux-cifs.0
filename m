Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB63C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 08:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 013C861252
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 08:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhKEI17 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 04:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhKEI17 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Nov 2021 04:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF96261212
        for <linux-cifs@vger.kernel.org>; Fri,  5 Nov 2021 08:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636100719;
        bh=pnnx51RhigcTMnA4gTktPI9AyCSveEJwiRElQSYivZg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gSkrTpJnrFdIDFqMG78eMDbUtZuaw/spyAlarBBikxmOurW/EQXMHVL5SlftQQIoc
         rH9AFN57jXCf7akFJSItdUgVwOBt4kuf0ZPmcrT2ZmsOTwYnhW9WAcy4/Pqigk1vni
         EWhmej7qgEGzqNdBFWfritItArTqyWUcwjKpr29FC4tLK/D1ddw60l78aPf/K9yVEl
         7ror54gMy1lMlC+AVK8tGti1qs8ov/grpkewtd80TRg3XuUCcCBwIeOQacWtoahLR3
         6lFZ2D7GmXunW5v6DQKzo5/w2mBuHVyXCW9lt6jsVKoK4oWoK7wLRdGGUWR8Hdf33l
         /joxHv4g7XyVA==
Received: by mail-oo1-f44.google.com with SMTP id o26-20020a4abe9a000000b002b74bffdef0so2779611oop.12
        for <linux-cifs@vger.kernel.org>; Fri, 05 Nov 2021 01:25:19 -0700 (PDT)
X-Gm-Message-State: AOAM530+YZYLxDN0WH+o63wzuFU89we/pqhS+drUpixjOg00HIvp/XYn
        9Nd/mDnMObQLX1IMhzqdmQKafYh59X/fZjAzKBo=
X-Google-Smtp-Source: ABdhPJwdbeW+sPikFKlMnBOomYakUIGx01GULjUD1DqX7cntuhYg8FfYwZJtGoQxEOPFchPVkBpWFPz8aebgAMaEXE0=
X-Received: by 2002:a4a:6c0d:: with SMTP id q13mr7632894ooc.88.1636100719149;
 Fri, 05 Nov 2021 01:25:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Fri, 5 Nov 2021 01:25:18 -0700 (PDT)
In-Reply-To: <20211104083432.14666-1-casta@xwing.info>
References: <20211104083432.14666-1-casta@xwing.info>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 5 Nov 2021 17:25:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Pno6OiYBd-fKkKb-nXPw1YYFXus6bfe1iwZbayP3Epw@mail.gmail.com>
Message-ID: <CAKYAXd_Pno6OiYBd-fKkKb-nXPw1YYFXus6bfe1iwZbayP3Epw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd-tools: Standardize exit codes
To:     Guillaume Castagnino <casta@xwing.info>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-04 17:34 GMT+09:00, Guillaume Castagnino <casta@xwing.info>:
> In case of success, EXIT_SUCCESS must be returned by the control binary
> This standard behaviour is expected for example for the unit file
> Standardize failure codes instead of returning directly function error
> code
>
> Signed-off-by: Guillaume Castagnino <casta@xwing.info>
Applied, Thanks!
