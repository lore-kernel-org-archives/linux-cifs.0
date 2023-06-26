Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E478FEB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 11:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjFZLMd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 07:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjFZLMc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 07:12:32 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17C8B1
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 04:12:30 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f9b4bf99c2so40871915e9.3
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 04:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687777949; x=1690369949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+hI2gY5sPy40fHmpvVeaHL4PCuJRNSoENIsXyndMBh0=;
        b=hISyINVI9/wNfLSh39bjpjOF6j9wk+nqzR31kff+OO23SW1dI6n0wLjPKMjv24VAva
         WZs58akNZxuVid9jV346/eTZWZRL5Tjfx1rlrw6tIfP8Ul/Tf4pXCmczSjjXtQnDiY5T
         w/f2jZb4Oww+ounUntbu4d+eSV6F5XiFlZs34cdZMxv4aOTy+bPz+Jf0kOtHIeT9b2DO
         3BldTOnxQmkBUq/6HBk0PD9jhpvvhZ4nEoa4iofBQjHQczLkzzg3rQEyoCNTlhBr1/6w
         BPu2gSV1MNHPt+RhoyNeP8gN1RDguFKkECW9wtVJE7h9R59AspbIxhoOyryxxJ87Tazs
         /Hsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687777949; x=1690369949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hI2gY5sPy40fHmpvVeaHL4PCuJRNSoENIsXyndMBh0=;
        b=BHbKW7aNYuGtCMEFxOUKdBEDIFE4vJDtRnF7tUYHAM2BXU3A/0CXethoYBt/SE5Bpy
         rjF/JitH3+cxPpdnzUx7XlFn8F119z8h46azJ0pD0uXv9PN4MeVdnrdHJtNSbebRkrq1
         CidG4nqY8MxHgSpNfOjjBKA4MFP38q7cXCk6a0jh5Ee/nbmymrD1HAm+dKY59P7ihA+e
         z0ui1ijHwp6IxNSfP4rDttFDXidIo3SftIoCW9U5ha8RhVW9uY8/lcgCvUtTm4hWVVMQ
         d8DjkqBjcEegOe6SV4POW5YnSrB3YdsA9XdWqyGoIen82+ycqSYKjlRgYxF8U/QRz3AE
         nYwg==
X-Gm-Message-State: AC+VfDymCh4In59ZT2ZtCaTRtquiP4dToPjD9kE4RvOC0c3SqOexyOwW
        cp5snbadQB6AqEWjEqG5jEqg1Q==
X-Google-Smtp-Source: ACHHUZ7kIEkIz+Aeo3F7rFRmeiKRFChc64vDD23ujgCbR9Lx7i2QGc7CJSPpVzSXNbAEfArtty7Pqw==
X-Received: by 2002:a05:600c:2c2:b0:3f7:3699:c294 with SMTP id 2-20020a05600c02c200b003f73699c294mr21921008wmn.29.1687777949137;
        Mon, 26 Jun 2023 04:12:29 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n4-20020a1c7204000000b003fa15e1e987sm7481373wmc.3.2023.06.26.04.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 04:12:27 -0700 (PDT)
Date:   Mon, 26 Jun 2023 14:12:24 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, Shyam Prasad N <sprasad@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 6/6] cifs: fix sockaddr comparison in iface_cmp
Message-ID: <82239b61-4000-4f57-a7bb-17bbad7dd45f@kadam.mountain>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-6-sprasad@microsoft.com>
 <2099a884-2e27-cc43-a293-69de617ab5d7@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2099a884-2e27-cc43-a293-69de617ab5d7@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 23, 2023 at 12:09:12PM -0400, Tom Talpey wrote:
> On 6/9/2023 1:46 PM, Shyam Prasad N wrote:
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 1250d156619b..9d16626e7a66 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1288,6 +1288,56 @@ cifs_demultiplex_thread(void *p)
> >   	module_put_and_kthread_exit(0);
> >   }
> > +int
> > +cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs)
> 
> Please, please, please, let's not add a new shared entry starting with
> this four-letter word.
> 

What would you suggest instead?

> > +/*
> > + * compare two interfaces a and b
> > + * return 0 if everything matches.
> > + * return 1 if a is rdma capable, or rss capable, or has higher link speed
> > + * return -1 otherwise.
> > + */
> > +static int
> > +iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
> > +{
> > +	int cmp_ret = 0;
> > +
> > +	WARN_ON(!a || !b);
> > +	if (a->rdma_capable == b->rdma_capable) {
> > +		if (a->rss_capable == b->rss_capable) {
> > +			if (a->speed == b->speed) {
> > +				cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
> > +							  (struct sockaddr *) &b->sockaddr);
> > +				if (!cmp_ret)
> > +					return 0;
> > +				else if (cmp_ret > 0)
> > +					return 1;
> > +				else
> > +					return -1;
> > +			} else if (a->speed > b->speed)
> > +				return 1;
> > +			else
> > +				return -1;
> > +		} else if (a->rss_capable > b->rss_capable)
> > +			return 1;
> > +		else
> > +			return -1;
> > +	} else if (a->rdma_capable > b->rdma_capable)
> > +		return 1;
> > +	else
> > +		return -1;
> > +}
> > +
> 
> The { <0 / 0 / >0 } behavior of this code has been a source of
> incorrect comparisons in the past, and it still makes my head hurt
> to attempt a review.
> 
> So I'll ask, have you thoroughly tested this to be certain that it
> doesn't result in new channels being created needlessly?

I was not a huge fan of this function and the move makes it harder to
review.  But I didn't see anything wrong with it....  Here is a slightly
simplified diff that I use to review.

regards,
dan carpenter

 iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
 {
        int cmp_ret = 0;
 
        WARN_ON(!a || !b);
-       if (a->speed == b->speed) {
                if (a->rdma_capable == b->rdma_capable) {
                        if (a->rss_capable == b->rss_capable) {
-                               cmp_ret = memcmp(&a->sockaddr, &b->sockaddr,
-                                                sizeof(a->sockaddr));
+                       if (a->speed == b->speed) {
+                               cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
+                                                         (struct sockaddr *) &b->sockaddr);
                                if (!cmp_ret)
                                        return 0;
                                else if (cmp_ret > 0)
                                        return 1;
                                else
                                        return -1;
-                       } else if (a->rss_capable > b->rss_capable)
+                       } else if (a->speed > b->speed)
                                return 1;
                        else
                                return -1;
-               } else if (a->rdma_capable > b->rdma_capable)
+               } else if (a->rss_capable > b->rss_capable)
                        return 1;
                else
                        return -1;
-       } else if (a->speed > b->speed)
+       } else if (a->rdma_capable > b->rdma_capable)
                return 1;
        else
                return -1;
 }

regards,
dan carpenter

