Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD06C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E586C2184C
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TH+njXIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfCNHMu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:12:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37092 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfCNHMu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 03:12:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id q206so3373739pgq.4;
        Thu, 14 Mar 2019 00:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FbfDfiDOv2MunJRGYRjVvYYVNj9j86FWntuGeGdexCk=;
        b=TH+njXIPA1xlfsK3Ixer5l6lupl/K0qQItE4b42tiC2I31rlB7tRI28XQENRnO7xMw
         u7vn40Er4ED7L3CHDl6A0/RCwwzbGocuPfbkmipt+mJwOOyYAkte5hcP06mzh433UPrd
         XUh9wLXQCms0wqSyOW6JBXH/bD6q/kyEJ9bEQnwRejKlEXjRyJpRim6XCnGEJoLMTuLm
         Ctq6ORAx83fq2Y78bmVTblIe+Vtra3S5aSW2DUw+Dx0OxP2HkIowS0JcMJJ6EM2dZKNo
         oSqFmZ1rYi2HdYbXG9oDRPDQyvG2Nl8BpCiODkO9ACpYiWSGtpOr5SYWfMVKV7Nr80Al
         /KSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FbfDfiDOv2MunJRGYRjVvYYVNj9j86FWntuGeGdexCk=;
        b=cojwhRCajAuOv5zFdFiLZCAPhPWUz9gUtf0AdOU/AZ+h9EQJkITYXQdA7Itptmp6kB
         ikHP71mFkDx7gSTnn1RQbk5D6j1OmOkowVFvMbeViz8J8xWFTt/4YBN5JXjqA8+ez6rm
         uQM5iD/2gsFVpmMEZqUOouik0zjAU0Pn4NXD4LfA43/2w7zxIlAn0ANE2fyTOJArDSXf
         cWaTVPgQ1zjJIl6mSRbSUzDe6mLIQR+jGhx+KSqecT3xEtJiG3gro9qrRWE7EWeiVWmZ
         N7b1AQMK1+0/RHSAEFFWFqFp7Z4V9Op+CrWcLFp/CunWXlqEnwhdVOkdvfUc8sfNxAA9
         ZUdA==
X-Gm-Message-State: APjAAAX4azOrQG9ZF/CgfUM4rSsjaqpJ9XBYTnjjn44sgWMR+A07g6+K
        ZdTQxGSFrXYCoUqfQ4Lt+sogwNur
X-Google-Smtp-Source: APXvYqzNliE+qZN8JWCSpR/P820Lnn6azSP0TvAKlJZ+M/2YIKD51KGTe5p7eavqW5ZwOEW4vEKVBQ==
X-Received: by 2002:a65:538e:: with SMTP id x14mr13598495pgq.79.1552547569780;
        Thu, 14 Mar 2019 00:12:49 -0700 (PDT)
Received: from localhost ([175.223.23.218])
        by smtp.gmail.com with ESMTPSA id z6sm333610pgp.8.2019.03.14.00.12.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 00:12:49 -0700 (PDT)
Date:   Thu, 14 Mar 2019 16:12:45 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/2] cifs: remove unused status severity defines
Message-ID: <20190314071245.GA2001@jagdpanzerIV>
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
 <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
 <CAH2r5msCs5ks3FUi_GhV2REsUR8t2h1=ybgLS6FyBEyka7Qb9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msCs5ks3FUi_GhV2REsUR8t2h1=ybgLS6FyBEyka7Qb9g@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (03/14/19 02:04), Steve French wrote:
[..]
>  #define STATUS_SEVERITY_SUCCESS __constant_cpu_to_le32(0x0000)

Does STATUS_SEVERITY_SUCCESS still use __constant_cpu_to_le32?

> -#define STATUS_SEVERITY_INFORMATIONAL __constanst_cpu_to_le32(0x0001)
> -#define STATUS_SEVERITY_WARNING __constanst_cpu_to_le32(0x0002)
> -#define STATUS_SEVERITY_ERROR __constanst_cpu_to_le32(0x0003)
> +#define STATUS_SEVERITY_INFORMATIONAL cpu_to_le32(0x0001)
> +#define STATUS_SEVERITY_WARNING cpu_to_le32(0x0002)
> +#define STATUS_SEVERITY_ERROR cpu_to_le32(0x0003)

Otherwise looks good.

	-ss
