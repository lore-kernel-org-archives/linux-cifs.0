Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84357EEB571
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Sep 2023 23:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344240AbjIHXs2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Sep 2023 19:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjIHXs2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Sep 2023 19:48:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2066E46
        for <linux-cifs@vger.kernel.org>; Fri,  8 Sep 2023 16:48:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686FDC433C9
        for <linux-cifs@vger.kernel.org>; Fri,  8 Sep 2023 23:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694216904;
        bh=Hd+Z2qTHF3i7pj8uSCJpDqZWPxIM1x39oaGJmdaL33o=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=AHaqeMQL3diXk9VFTOUyd30ju7IB+33fQBZCrFrEH8Utrc2aD0/bUNr2AySAKkwts
         InXVNvmHxmqWiOhVsOwKJrGnXRI41Rhi8tEZz8o1Mwxl7WCBHNiJ1a1eWFSL5QMpDR
         kVm4INweEC786kGrLcn0Jhp6ACXWw3j7soxQBINWHIBq+qUon7Mmv6cgOInzTAe2y1
         1aeGqoITY/FGXiOsp7wQ1iN+Jwf/Xp5h+Z4yxolwbx03jZeVflqSNPLB2UkV/qZ437
         SBJG0MV1nCJQ81FZtH55bwnX+tUPv1vgRs4dWKh+fannwqrKQbPNnEnLp0e1sj5LWf
         ifoT3dbzxj3Yw==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1cc87405650so1748351fac.2
        for <linux-cifs@vger.kernel.org>; Fri, 08 Sep 2023 16:48:24 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywlf9+GlS7361IGnkZo1gZtDoQ2nSLkdqBkUm6abT7vcMKzb+D4
        CUdENGI0pEsr1aNoT476I31R1kDohRyvr4Ui6lQ=
X-Google-Smtp-Source: AGHT+IFJsJagPYd4XUBq74+QraEAbcPA21yyIbGn0X8yC1k6mUIPZH6t9+fp7vNOZkqQVyfzJj1uLkbpaL8kKvMKhHU=
X-Received: by 2002:a05:6870:4205:b0:1b0:805:8678 with SMTP id
 u5-20020a056870420500b001b008058678mr4408250oac.24.1694216903750; Fri, 08 Sep
 2023 16:48:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:692:0:b0:4f6:2c4a:5156 with HTTP; Fri, 8 Sep 2023
 16:48:22 -0700 (PDT)
In-Reply-To: <CAH2r5msh3RUvBEwf2henYJ-oVt=4PwBDePnu-EVSrTpOCWLyUw@mail.gmail.com>
References: <CAH2r5msh3RUvBEwf2henYJ-oVt=4PwBDePnu-EVSrTpOCWLyUw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 9 Sep 2023 08:48:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_a19XtgdUci4U7cuXwXq_Q2YoPvFzSLheNokvGvgwCyQ@mail.gmail.com>
Message-ID: <CAKYAXd_a19XtgdUci4U7cuXwXq_Q2YoPvFzSLheNokvGvgwCyQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Trivial typo fix
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-09-09 5:56 GMT+09:00, Steve French <smfrench@gmail.com>:
>     smb3: fix minor typo in SMB2_GLOBAL_CAP_LARGE_MTU
>
>     There was a minor typo in the define for SMB2_GLOBAL_CAP_LARGE_MTU
>           0X00000004 instead of 0x00000004
>     make it consistent
>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
