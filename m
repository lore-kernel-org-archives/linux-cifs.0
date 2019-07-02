Return-Path: <SRS0=GYif=U7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05594C5B578
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jul 2019 01:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49AE21479
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jul 2019 01:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVZtQBpA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfGBB3Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Jul 2019 21:29:24 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37156 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfGBB3Y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Jul 2019 21:29:24 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so7422431pfa.4;
        Mon, 01 Jul 2019 18:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=okHXZWy1RC0s+ym/tCWI7Nmsc9E0/K/JlQNwRmoNEmY=;
        b=pVZtQBpAOxDHgd10sbBXUOHCIDK+DWQYX1vDeFfUtDlnaHFxd5alO9XDxJRkchea5z
         N5kae3IUDfpY4D8r78Ppo38NWqQdQ1+QsqSOoq9HMSEfRRiELec/7tb+3fSpSukuGwoh
         WmmMQpF+8V9v/jjIXf2lD7A4cB6f8Dk7g3nXrEyaWGGDbA/3NLvF2Gb8eALkI8sqPlpW
         0K7hH7NoRKAGOIyngaIirnxoGvsl99mtI50oA9Xhu1iL1DWeMaG/PcpZa0jC6oYSSukj
         av4Vg4vGzKDNlurzEZo7eyEJ3YyfpIoRUauDIBPnVIovfAz6gUTOh44+a5FC/+UFL6Cd
         kB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=okHXZWy1RC0s+ym/tCWI7Nmsc9E0/K/JlQNwRmoNEmY=;
        b=l9IsqHuAFVyndSosvca86reqkm+PjSxEVGGmeokTbKY3eTQtendre1gkdsuhoyJ9Jh
         uZuJV61u4DkqI1FgBYko75xSOljxN/kmqByBfSssylGeHiPmn6mFQ1atKqgj48T23MM3
         ebUzTTmvHLntw8jSRu+pp6QCCP/PQgRYVlCG7y1k9Y+fhHKQnI+q0PtqyzVN2zc+1d1S
         nJ/cvuWKbhmZ+4Xh4n0of+uVIQ4wi1aA3FoR27Ib5TmK3PXu3gXEaWh2cUpWGMgXuUUp
         SRT5wml7tGYrc84qXCEN7oA0vtC0TE6BE3VjDnY3P14G76iAoiuCLKnxv9R5dbrPEzYq
         OXiQ==
X-Gm-Message-State: APjAAAUByGtzaDzu7LeKXF0z9BdtQQuVdn4gSR6scoYgY8WChfz5QazB
        HSAZ7ZcpAlF77CV0auFbZDc=
X-Google-Smtp-Source: APXvYqwLXr0oqFlBH9jkUQd+Yo7ZVrdSGlJ11M/aBH1UN58sKxsdE/cuJlURWIyV9B19ba7PhZ6OPw==
X-Received: by 2002:a63:7a01:: with SMTP id v1mr24664400pgc.310.1562030963395;
        Mon, 01 Jul 2019 18:29:23 -0700 (PDT)
Received: from localhost ([39.7.59.222])
        by smtp.gmail.com with ESMTPSA id a16sm17634323pfd.68.2019.07.01.18.29.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 18:29:22 -0700 (PDT)
Date:   Tue, 2 Jul 2019 10:29:19 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] cifs: fix build by selecting CONFIG_KEYS
Message-ID: <20190702012919.GA8040@jagdpanzerIV>
References: <20190701030325.18188-1-sergey.senozhatsky@gmail.com>
 <CAH2r5mutRM0d9oLG0rpRAzTC9DMWL61i0ewbri8v7Lgu1Ud5yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mutRM0d9oLG0rpRAzTC9DMWL61i0ewbri8v7Lgu1Ud5yQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (07/01/19 16:04), Steve French wrote:
> 
> I had already merged the attached (similar) fix into cifs-2.6.git for-next

Yup, just got it with linux-next 20190701.

	-ss
