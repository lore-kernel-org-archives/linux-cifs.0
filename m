Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA963C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 16:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6336761418
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 16:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhD1QNj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Apr 2021 12:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhD1QNf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Apr 2021 12:13:35 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484DEC061573;
        Wed, 28 Apr 2021 09:12:50 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t18so6081371wry.1;
        Wed, 28 Apr 2021 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=9sQOg2djYqFyyvZ+XRPCZzW7QjwnUE+n/y705XB+4KU=;
        b=OT9RIuYm+aabyzcOmaIYB1vZmez4cppddKZ7Ayy1I/WCN7lMtjqQMLGAf5Rx0HGge5
         g59UN1CtU1VNFOTDdoZo8JN5560267VMC3cMpU/YqDzkC8telFGP319YlbQ6CnyTC1FA
         D72jN9L0NMCcbUWCg4xlLH1DltT7Y6LEt9YnE2edPXkBymFoaZCq6/h24BGkg9Rn9sEZ
         0n83OR+QgMgj9aeicOIO+p/nVVyXxSJoB2tlZBZtProESTB7Vwe+aYeDhf6Zv7vQSwRs
         Z98rNu5LiJo4gzW5z0N+t3RYU7AioWDuaML58L8KfodbOQ7uxBBlVwO2Ur6go2KyX2vH
         XkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9sQOg2djYqFyyvZ+XRPCZzW7QjwnUE+n/y705XB+4KU=;
        b=HExP1pjfTSEE8xW+C4mQPil5RrNHtsgRLiuym6Ed0beEL78qADLlFaZmtVlm/T/56B
         lDypHbRauugycHZfV20/Y1DEmcGIe6YKBryrLvNhTY7PHIIaIRjee12czdN/zLcCV4YD
         WVSEakLQ4hdEjmhSVKs7tp6Zrzkm1yKQJAgkuPLzHQN8C/yubJI4zJMOO3d0axK8YDIt
         2qGmE73kVPvMT34bA5xVRDwf8mEkclFiiHcj6slmaaGB3euAm9X3Sx+XjgLn2KFvBh8p
         bJD01SUXMO0FFScm4zRkCed6WsKHYrA8kR9VAbkeEmgztfrq6iw79LV01GGbQQVNHAYP
         BFeA==
X-Gm-Message-State: AOAM531MRIS/Jnf82hMiCOovnIA1b4fK08eQm/CneEAIE4oyzt/WUMwj
        55CVVOPeJTIHsrfv7DBUZDE=
X-Google-Smtp-Source: ABdhPJwwYplb8UHwtRRe9SQ92QhNRZVekAV0hd7zTpqShgHkseq5PLWwnUnqc/3H9D9Ly2ZD+Hve1A==
X-Received: by 2002:a5d:654c:: with SMTP id z12mr37123433wrv.12.1619626369046;
        Wed, 28 Apr 2021 09:12:49 -0700 (PDT)
Received: from 192.168.10.5 ([39.46.118.120])
        by smtp.gmail.com with ESMTPSA id l14sm228211wrv.94.2021.04.28.09.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:12:48 -0700 (PDT)
Message-ID: <8e81d6a32408f172a6ab4ebf68eee760444d9666.camel@gmail.com>
Subject: Re: [PATCH v2] cifs: remove unnecessary copies of tcon->crfid.fid
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Steve French <smfrench@gmail.com>,
        =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     musamaanjum@gmail.com, Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <linux-cifs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>
Date:   Wed, 28 Apr 2021 21:12:43 +0500
In-Reply-To: <CAH2r5mtwMep4J1yu1jUUEp3+CmwhFuv2mJKqN1ViBkSxi-jGTg@mail.gmail.com>
References: <20210415152409.GA2286719@LEGION> <8735vp18su.fsf@suse.com>
         <CAH2r5mtwMep4J1yu1jUUEp3+CmwhFuv2mJKqN1ViBkSxi-jGTg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 2021-04-19 at 18:39 -0500, Steve French wrote:
> I changed the comment to
> 
> +               /*
> +                * See commit 2f94a3125b87. Increment the refcount when we
> +                * get a lease for root, release it if lease break occurs
> +                */
> 
> and added Aurelien's Reviewed-by.  Let me know if you see any
> additional problems.
> 
Thank you so much!


