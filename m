Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5D7C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0EFA610E9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 09:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244703AbhIGJGc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 05:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244581AbhIGJGE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 05:06:04 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8F9C061757
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 02:04:58 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e16so7644249pfc.6
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 02:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JFUe0oUrwXqCwKq4eqExlpRTi7IcVmkvmbvLDysmvKo=;
        b=BM7dGvd6Edcau63BuGqiLd8+YnWfnHHq3n8PkRi2eHP4MY0vVmyklJSWzZQtTeAOqL
         l5M2tJsNU/fU56sXnaI2CDdb42JjQsjUzEeT0sfLl/aqBDnDXRG/1IM+65SjU/ZtoR9X
         m+lOMWM/YlDFXbJGxlQfPdkshPIerdR4LYZrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JFUe0oUrwXqCwKq4eqExlpRTi7IcVmkvmbvLDysmvKo=;
        b=BZ32E22HLvS+t3MO3VI/GMTSnAvX/5rISY49fjFVGkLNGF5WhjHQICoT6wqMi5kjo6
         gDTCWgQ6+64VxWPLQ5/GGPB+PwakD6vDxtJtjRYTAS0eD3NQ5L9wFHeUznnZ2t638N5s
         G3+zMye3blJszhp2id/HQvWepF8oxEeO5JC9NmfOp29jKg1J6l+hh+rbydVtiLMSz5Xw
         OwJXuAMLZT2RINdIYnAxFA05NbhAGLfu0+ACr9aw9E+fVWcJDT5PKTRAUOL4i+jXHREI
         Oj3vL376UddMdtIZf9ttF3ZbYszAVhR183zFLzZL06nY/SVvyxeY/PF7WZndtm0YJZAU
         XH9A==
X-Gm-Message-State: AOAM533dPiFgUD0hsP6feWrO7FBtCYUT8qCSjFR9UrYLNfKCE4gJCQAT
        thhAbKZe1bxl81VWkbNITVc79Q==
X-Google-Smtp-Source: ABdhPJzx8/3ISOCaLAV2Ny8T7f+2UxkdQZswsuLsvQcXhjD4hcDtp/JeCFZl/QG2ac5GMuFxjiUXaw==
X-Received: by 2002:a62:28c:0:b0:405:397f:5c9e with SMTP id 134-20020a62028c000000b00405397f5c9emr15386576pfc.74.1631005497656;
        Tue, 07 Sep 2021 02:04:57 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:4040:44a5:1453:e72c])
        by smtp.gmail.com with ESMTPSA id 73sm10503064pfu.92.2021.09.07.02.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 02:04:57 -0700 (PDT)
Date:   Tue, 7 Sep 2021 18:04:53 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: potential uninitialized error code in
 set_file_basic_info()
Message-ID: <YTcrNUmL+WmV3prK@google.com>
References: <20210907073340.GC18254@kili>
 <YTccRzi/j+7t2eB9@google.com>
 <20210907084851.GL1957@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907084851.GL1957@kadam>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/09/07 11:48), Dan Carpenter wrote:
> On Tue, Sep 07, 2021 at 05:01:11PM +0900, Sergey Senozhatsky wrote:
> > 
> >                rc = setattr_prepare(user_ns, dentry, &attrs);
> >                if (rc)
> >                         return -EINVAL;
> > 
> > Either it should be used more, and probably be a return value, or we can
> > just remove it.
> 
> You are looking at old code from before the bug was introduced.

Right. I fetched today's linux-next and see the point now.
