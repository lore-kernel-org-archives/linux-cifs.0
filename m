Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A33AC433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 14:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538C061177
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 14:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhEDOPg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 May 2021 10:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhEDOPf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 May 2021 10:15:35 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF08C061574;
        Tue,  4 May 2021 07:14:40 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso1311988wmh.0;
        Tue, 04 May 2021 07:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZmJ5I+1Rzh+1ETdshh+H96MHb0GU0TZshgd5tQa/Wfw=;
        b=bEDZwFiutKnibseve94T0+UEHpmneNa7QhdP115DLEBWQ9tkL77SfMJtQbimFMiu6T
         45yr2byj9jeXPSEFFJXZgoeoHodC+m/XBRD0O36p3xHknp0LzfcL2deMTfh/Xk4wC+ga
         58zBJ/6t3EuszXvrvM3O/8CGJOwmlSNBJ99LL3HBExaq+Ub5HX7RLSC1uhwLvmLGHeYT
         rbobHJCOg5bvfQ7ViAtAamiia7aLZaCjDFSjdciFhmXfTMXbUZCIjimw9SXxbzLE+4jj
         CKQy3i1LuoK+9kknLhM/3F7e5WCjSSsSWv3seZwkZO8AgAcLWRiMxBDmofjzoaDRFQmf
         Vq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZmJ5I+1Rzh+1ETdshh+H96MHb0GU0TZshgd5tQa/Wfw=;
        b=IV8dMJnS3v5Ve83jWwpIjSqz1kdn8544iLw2KHMa9H8jCDUxwEMhy3Tdzqe9+v/Ld2
         3gNHrxacM5/+HJkTQrRIFlL5juKt125gaJctxvbnwzdlhJTwOFzCQgZCCtPFTn6Luz5u
         1IZobv5tpnKf2BmonrqJs9zlHL7QlDEq00UfPVU9y8z4MGQX6FAVYN6QOxVaB7pXn6eS
         T6O+zahZm5AzpdyEbuBKginOUyxBW5DlZqPckBbrDHJUejrwD9NfeGtkHvE2Ow2rlwzg
         oBRkNgHmkv4TBnKWPSWYyyg+01biiC47wupZmKwESCTZBRQV1O0SVDSer/tt+u40ePQ4
         oC5w==
X-Gm-Message-State: AOAM533kyqSvDnPmwEmykmezRDUtjuO5hxH5GLhJgG/xgW2StPmjMNw0
        orYMG+VmIcStirR6toNSmUuP9Txwgo6+hLiA
X-Google-Smtp-Source: ABdhPJzzgZ7svv6P8SbOu4kzJFzL/JMdB14X1fYh2f6sZsS2R06Wrp7f/5po0KFRMPyz59p5I+coiA==
X-Received: by 2002:a1c:b002:: with SMTP id z2mr27620989wme.26.1620137678989;
        Tue, 04 May 2021 07:14:38 -0700 (PDT)
Received: from ard0534 ([197.2.237.199])
        by smtp.gmail.com with ESMTPSA id x8sm16428403wrs.25.2021.05.04.07.14.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 May 2021 07:14:38 -0700 (PDT)
Date:   Tue, 4 May 2021 15:14:35 +0100
From:   Khaled Romdhani <khaledromdhani216@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH-next] fs/cifs: Fix resource leak
Message-ID: <20210504141435.GA24514@ard0534>
References: <20210504124343.22611-1-khaledromdhani216@gmail.com>
 <20210504134244.GW1981@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504134244.GW1981@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 04, 2021 at 04:44:45PM +0300, Dan Carpenter wrote:
> On Tue, May 04, 2021 at 01:43:43PM +0100, Khaled ROMDHANI wrote:
> > The -EIO error return path is leaking memory allocated
> > to page. Fix this by invoking the free_dentry_path before
> > the return.
> > 
> > Addresses-Coverity: ("Resource leak")
> > Signed-off-by: Khaled ROMDHANI <khaledromdhani216@gmail.com>
> 
> Add a Fixes tag.
> 
> Fixes: 583248493f78 ("cifs: add shutdown support")
>

Yes, I will add a Fixes tag.

> > ---
> >  fs/cifs/link.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> > index 1cbe7ec73728..1485c6095ba1 100644
> > --- a/fs/cifs/link.c
> > +++ b/fs/cifs/link.c
> > @@ -686,8 +686,10 @@ cifs_symlink(struct user_namespace *mnt_userns, struct inode *inode,
> >  	void *page = alloc_dentry_path();
> >  	struct inode *newinode = NULL;
> >  
> > -	if (unlikely(cifs_forced_shutdown(cifs_sb)))
> > +	if (unlikely(cifs_forced_shutdown(cifs_sb))) {
> > +		free_dentry_path(page);
> >  		return -EIO;
> > +	}
> 
> Better to move the allocation here.  Avoid calling functions which can
> fail in the declaration block.  Better to test for NULL directly instead
> of hiding the test inside the build_path_from_dentry() function.
> 
> 	page = alloc_dentry_path();
> 	if (!page)
> 		return -ENOMEM;
> 
> The error handling in this function is slightly unweildy...
> 
> regards,
> dan carpenter
>

Yes, it would be better to move the allocation...
I will send a V2.

Thanks.
