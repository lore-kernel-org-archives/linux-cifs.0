Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E2FC4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 03:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B53822D04
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 03:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgLPDZd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 22:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgLPDZd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Dec 2020 22:25:33 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B642C0613D6
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 19:24:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id t6so12160663plq.1
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 19:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fCJx/YxURffKs41GQgJFWZaR1Ez24C8hxznF80ImfJY=;
        b=CH48kZUjM2/X+tzsVF/8hsWgaSIAvencbS39UjmeEIYvjS/7KO/1nkQ8xkQQxxkKkP
         cD4MMcHe8UFozdEg5dN0e+izBp59ozN8wwWaZur9GWn35j1YkYKeS8Iqsk7BgtigQ4TT
         CFlGJxXYKYf8b+9xCcSZ1M2Uej32HZrcOf4ae2ays8ytady9xyWrCO4eaQdGlly7g0F1
         aKW5ytD7HvS0gGdOJ7tWgMlLKmhVNfYuoZ5JXA/rxqZMNMbIa0tol9V5Wr/tJVksqPqV
         z7pv3n7zeoRheaUDuYm11L6W9IGbuyiuRJJu8JTKLoByBouEsLQ1jG8qAQn6y2y0B7/c
         imnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fCJx/YxURffKs41GQgJFWZaR1Ez24C8hxznF80ImfJY=;
        b=FMYFgvvxxJmRzTPTHb/7HWFu2xLA/RTi8/VZWOuQpymBdDHhQdSt73GG5glumWRxF5
         ttCdon24givE/bAlRBADhi55T5vFnKx6NBF699WXutgvIjpdYc5TPb3RNlkYbUNfaJy+
         UGdH8ccQpxJU/pHKPdTdLlbskJ5Pnu2dAq86NC1E6Az15BmVqHJpINFrQb3bG+LqFyE+
         gI77+yijf7PJvgKQ/2G3a/ahqaeoNlricGLlpbYJIrw038whKSmY5P3XOaEVDP/omiUy
         ZM1vmt8Kn+8vGb1n/qNVVqm0ZMwJvZVAPhmTqEMEE1ySt+M/Qm/jvUwC7pvuNr2jCRxE
         ggsA==
X-Gm-Message-State: AOAM532HdgisdxZV17mGPCtR/wrOFJGUd5fOg6M3Dit00C03sWsFLZj6
        RycRqhC/9liVytRWBL48e51Axyhd5rpd7w==
X-Google-Smtp-Source: ABdhPJzyvxIf7oMU95Q8edy+PHhLVM2oMy1N4ninpIgs/jclb9O3etQdhbkW9KZCXNy3KexMxxc/vw==
X-Received: by 2002:a17:90a:d18c:: with SMTP id fu12mr1365297pjb.153.1608089092355;
        Tue, 15 Dec 2020 19:24:52 -0800 (PST)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id q26sm397360pfl.219.2020.12.15.19.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 19:24:50 -0800 (PST)
Date:   Wed, 16 Dec 2020 12:24:47 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        'CIFS' <linux-cifs@vger.kernel.org>,
        'Steve French' <smfrench@gmail.com>,
        'samba-technical' <samba-technical@lists.samba.org>,
        'Hyunchul Lee' <hyc.lee@gmail.com>,
        'Sergey Senozhatsky' <sergey.senozhatsky@gmail.com>
Subject: Re: updated ksmbd (cifsd)
Message-ID: <X9l9/7rttZkNc389@jagdpanzerIV.localdomain>
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
 <CGME20201214182517epcas1p1d710746f4dd56097f16ed08cfda0f6b2@epcas1p1.samsung.com>
 <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
 <003a01d6d28a$00989dd0$01c9d970$@samsung.com>
 <069556fc-cb6c-1e52-02ab-fa9b71f58cf6@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <069556fc-cb6c-1e52-02ab-fa9b71f58cf6@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (20/12/15 15:29), Stefan Metzmacher wrote:
> >> 6. Why is SMB_SERVER_CHECK_CAP_NET_ADMIN an compile time option and why is it off by default?
> >>    I think the behavior should be enforced without a switch.
> > I can make it default yes. Can you explain more why it should be enforced ?
> 
> Why should an unprivileged user ever be able to start the server?
> Wouldn't that be a massive security problem as that user would provide
> the share definitions and users and controls what ksmbd_override_fsids() will use?

The idea was that user-space needs to have its own user:group
(e.g. CIFSD:CIFSD). And smb.conf and password file should not
be readable by anyone who's not from CIFSD:CIFSD - similar to
how .ssh/config is 0700 on any reasonably configured system.

The massive security problem here is that the server runs in
the kernel. So I don't always see why people want to also run
user-space (which serves RPC calls, and technically can be
tricked to do something that it was not intended to do) under
root - wouldn't this just increases the attack surface?

	-ss
