Return-Path: <SRS0=f6oI=BQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0947CC433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 16:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9822086A
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 16:52:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vQcflc2Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgHFQwB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729508AbgHFQvD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Aug 2020 12:51:03 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717FCC0086AB;
        Thu,  6 Aug 2020 08:31:45 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z6so50062328iow.6;
        Thu, 06 Aug 2020 08:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T9d2cPoZwDqNGPTOF/xh+MxXI5gE97qXPjeblukEaaA=;
        b=vQcflc2YsOmgW2sQjngcKtZEcaKtv5UkXvVETU5hbzK6g0ksH2yEr8GcVsuKfRcpsR
         EFW2Dxuq+ZVOurLvqdJcInXpyTCS4D5zF0d9Gu1tWjyu6PSFcwzbHQoqPL9cVwSsVT4I
         THCWUNf3YKvfZhJG/jaBUwiX7vn+TLoxKzj33KMkHw2AABschis+j1bRkvEk6gvGBOHV
         gvNx8YOSEbBcBQO5NDwNosSImG3Jg9yxf3z87RhWVJkfTQPlHDuICSpTDX08c+rws8ZR
         CF51+6gtwtvDWoSteC6vZ2C3x6k1f+8j9/p1QeDxVSxuOZR4yvDnu+NtziMwVpVpauNa
         ccJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T9d2cPoZwDqNGPTOF/xh+MxXI5gE97qXPjeblukEaaA=;
        b=hqdq/N9R+HxJtnC0gmqQqmjbRwVIvD6kdQyW7TYK3MSFQ7HXxZJGYfu+9p+bhREK1f
         qAQm5XykoW1arwnS628T5Wit3j10ZyYf9XfOoaTkbZelx8KwZm9F0W5MF6lWb1vsLUMz
         P2UoCX0zmQmsoveZbQWx0gtzyVt+ee2RFzqD/qFPV05lU+fSFxDjOEduUa+8tzekPIcz
         7Ncr0p00plsqlVFlBEpDU2zXa6YRp71WNtKOpJ/FBGUnjKf7ulErUeXZDDqPLyX/MnMx
         BdqVFmICzacH3aj4yplVv4aM/AuDsRHV+JYdbA/CN+7wo43+mEqA390MVF91e1Yhd4E0
         A3ew==
X-Gm-Message-State: AOAM531D7Eieg7u1InwFawT4WT7LwwKCy0RapBJrQh6/tW9EeQ2BbDk2
        KZ4d4atOpGkM6eg4Q2qJ6NXVGmwTwpdeQhOiHsSQ8Yoo
X-Google-Smtp-Source: ABdhPJzmjtu3I9LpJ7xxUqAWkEMGb6vq1m8lbFSQ4AwTzFSkP9twdx78ZCkmV7yKZa1BLk2PvG5WRWqNadBbvjcTUho=
X-Received: by 2002:a5e:d80e:: with SMTP id l14mr10808869iok.65.1596727904697;
 Thu, 06 Aug 2020 08:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200806164505.0eada105@canb.auug.org.au>
In-Reply-To: <20200806164505.0eada105@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 Aug 2020 10:31:33 -0500
Message-ID: <CAH2r5mvGD3ftLDfwrpx61kaJQnPpspupdDHD8NOjnF-q-ByTfg@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dan,
I just fixed the Author tag in this patch to match your email address
but seems like the author email address gets mangled when sent through
some mailing lists.  Any ideas how to avoid this.

On Thu, Aug 6, 2020 at 1:45 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   2676d210d2f4 ("cifs: Fix an error pointer dereference in cifs_mount()")
>
> is missing a Signed-off-by from its author.
>
> This is only pisked up by my script because of the mangling of the email
> sender address by the mailing list it passed through.  I guess a little
> more care is required to make sure the author attribution is correct in
> this case.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
