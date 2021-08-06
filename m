Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE91C4338F
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Aug 2021 07:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCCE160BD3
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Aug 2021 07:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbhHFHSd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:18:33 -0400
Received: from mail.tuxed.org ([116.203.59.37]:58440 "EHLO mail.tuxed.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhHFHSd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 6 Aug 2021 03:18:33 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2021 03:18:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alexanderkoch.net;
        s=2019; t=1628233773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+am1S/eRWJ0BmibE8XmJh+EOij0SVtCRb1tKYD+kb4=;
        b=ec2WFycGlomsGnbMwp332xreS3LmRhbTHsr4aMBh5S3rjnKY19/yxgseJ1RLsZMJ9smELD
        lI3e4pDBFGc1un/TNU/utoMq0UpCR3mBtxGAJkqSGFgCDb4PccDnDvJdjXZb9pXtjGKzH7
        doDvr8uXh2xuVrp/PBhpbhyneqQl98H6o6296NlP0ivwRxl7eY9JBQ2ttcSCl9StO9aSMS
        Dl7lztyZPIQGVdi/xJBgtxBkoI8qVG5oJTiVM6DYzGdZpy7Uu1qs907CHN7eA8MeXX+iKc
        CU7c0rMMDLDJ3cSZHMMEMjvszchQps5rtc0vrO6jFwYTh8OvIh8kiwixSLAwfg==
MIME-Version: 1.0
Date:   Fri, 06 Aug 2021 09:09:33 +0200
From:   Alexander Koch <mail@alexanderkoch.net>
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: cifs.upcall broken with cifs-utils 6.13
In-Reply-To: <956dd84c4e27fd02541ca4fabb7b1776@alexanderkoch.net>
References: <a01d5d22-5990-c00d-bc2a-582d2585ea69@alexanderkoch.net>
 <87h7k0zz6r.fsf@suse.com>
 <956dd84c4e27fd02541ca4fabb7b1776@alexanderkoch.net>
Message-ID: <2f863f5d2c22907a88a4bfc04ab5f1b4@alexanderkoch.net>
X-Sender: mail@alexanderkoch.net
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alexanderkoch.net; s=2019; t=1628233773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+am1S/eRWJ0BmibE8XmJh+EOij0SVtCRb1tKYD+kb4=;
        b=X9oUFhp/+sc21VaBhdfUE0O2raj8meWr2bodxkkI0bp5TdlSpN5PdoeLIWecNceVsBwmvl
        +iUtYSrxTMU+Pm/dQUF3hk8tb3cEQQLuHDKcklxeS1Op6vPdfc40Dh5xiBT5AU8ikfU2TD
        bwZtiVHojwFLQAu2dir9OlmhQ/H1VrjbVpXqXaip2O215m9kmK8x5SzXNuIg+DmV+eUS2d
        qtUscueYatEAebqKlWRUBgxd0z/Xt9ALBIHTPZUwuR3dG73DbgWFCG/3x0vXgOZPtLQa4g
        J8JJQYEhz5Uxaskgx5YtlI+tWkIl0OmpgfKtzOyyPcJwEmqwQOcB86NRexXynw==
ARC-Seal: i=1; s=2019; d=alexanderkoch.net; t=1628233773; a=rsa-sha256;
        cv=none;
        b=R1gskBN3n7eUYvfUr1w9ooT4clou+Jt2TcLdly61Yy2mDhOxh7ECCw6G/lIyb0DmjO8X6f
        Wj6tyO9DMp32lFWD8QHpabjh2DXDAHwwE50ZJ/2zqEMo0OGYP1PG24VC7FRpu9MKEM9Amh
        6sxj1p9c/5HvRH/JDMaG6crDrYHB4NXeA/fnR79xLX5nuY/S/AurR8q7xnqspliKC2zjx4
        Grw1pgZt7KbDoM6sZjGpXijjuCknSbK73r3ocrBmHrV1JhtAwqOxychpky0wfKkQVEDMg7
        9LvWfnoNou9+ce8Zh5MWG+sUDyE4V9b2/zpUuPEUFcUaHEXjH09GOA2JC/Z1fQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=mail@alexanderkoch.net smtp.mailfrom=mail@alexanderkoch.net
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=mail@alexanderkoch.net smtp.mailfrom=mail@alexanderkoch.net
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aurélien,

>> It's unfortunately a regression in the CVE fix. We are trying to come 
>> up
>> with a proper fix.

Any news about the proper fix for this regression?

I've seen there is no new release but maybe the is a patch that I could
propose for the maintainer of the 'cifs-utils' package in Arch in order 
to
work around this issue.

As of right now, the only working option is to keep the package 
downgraded
to 6.12.


Best regards,

Alex
