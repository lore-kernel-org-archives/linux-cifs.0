Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611A8CA0EEC
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Sep 2023 14:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbjILOiI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Sep 2023 10:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbjILOiE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Sep 2023 10:38:04 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FB4118
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 07:38:00 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-402c46c49f4so61196505e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 07:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694529479; x=1695134279; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cfSxSAD1PhMzscq/6YVbDEiW1Jjk6nsVrseRz+PEruA=;
        b=ImDgjbGQdGwhLeud88NGFJhKm4KiwneLTglkjwRTjAUFUz0sO4EK71aoedjLzpVKRN
         pkbI+VE5d0wz8TPY7OvXyj1+vBJ3VOcflV8QTgPATX69Y7JzdgGrYN4jec8L65dbHtg3
         YePlM2V/8eGYTzHWe6PYRL9o50UNCp8434sgehsYVD25tGmHIxNuNnMFGo4FoXQ+jUr3
         vtT1mtwA7Y/Ip3fb2iAwaCuhLomuWaxwtp7HggVJ4wC41fSRjV9i5G7nXhW0Il8exhWa
         fSimzM7fGIXufxmyLH1FUqNNf8eJJn418gSB2OiOg2ITv05tvQOOnG4PUEIQZeh76aam
         FDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694529479; x=1695134279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfSxSAD1PhMzscq/6YVbDEiW1Jjk6nsVrseRz+PEruA=;
        b=LnTJhHblLtN/rFYuL7nXxeoBCG0FXHM4uQnbSrjBljcId91feR4Wncv7TQDLx7qKyj
         hd4+WiWuagP2Uyyh2eUROAgOmUcZZY3unOYV90AsL5vRW3mMy9yIHX6w7DKEio4650A/
         8a6eP96wEFarPpiayvaH7pnYvsMUB2Oc0JEzUpeBDJYecPQ4rO85ZAsPFBay3zlTxq95
         ayuzpEgu/P/cAcmqSaTHxv9PYoEEKbCvtk45u/BcxGrDtKhMnB6v9E9ZgWUYEeczwmNd
         t4QZrm63HenaBkJwwcFHcwUpu/lB3PFt8xTQMyC1LJzv6MuQ4mH9A0RwM/Su9jQWX8f9
         vnfg==
X-Gm-Message-State: AOJu0Yxq3mGgNxabvekTom48+yOw1N7Hjw/kWO6A/vyNOFUQrXQVA/Qv
        C8YwFKPB8vPva75yd/4rTh7L60ikAgkuxdh1yew=
X-Google-Smtp-Source: AGHT+IFq4dI5kiES0vO9R8OkSfClZBMsdCNIqbzlLXdcZbwHQSF/jHusDDU9rihlL5xFpNdEDLKF9A==
X-Received: by 2002:a1c:7707:0:b0:401:5443:55a1 with SMTP id t7-20020a1c7707000000b00401544355a1mr11148870wmi.3.1694529479068;
        Tue, 12 Sep 2023 07:37:59 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id gw18-20020a05600c851200b004030c778396sm7300180wmb.4.2023.09.12.07.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 07:37:50 -0700 (PDT)
Date:   Tue, 12 Sep 2023 17:37:42 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [bug report] ksmbd: add support for read compound
Message-ID: <5807d05b-9ebe-4256-9682-ef9d0c341efa@kadam.mountain>
References: <dfc735a8-c0a6-4691-80a0-bf5c3814662e@moroto.mountain>
 <CAKYAXd9_rxHxUioYdKD7HshfJq0nzw1hBrJKnE6vHnk+ztsN7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9_rxHxUioYdKD7HshfJq0nzw1hBrJKnE6vHnk+ztsN7g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 12, 2023 at 10:03:27PM +0900, Namjae Jeon wrote:
> 2023-09-11 23:31 GMT+09:00, Dan Carpenter <dan.carpenter@linaro.org>:
> >     6309         if (is_rdma_channel == true) {
> >     6310                 /* write data to the client using rdma channel */
> >     6311                 remain_bytes = smb2_read_rdma_channel(work, req,
> >     6312
> > aux_payload_buf,
> >     6313                                                       nbytes);
> >     6314                 kvfree(aux_payload_buf);
> >                          ^^^^^^^^^^^^^^^^^^^^^^^
> > freed
> >
> >     6315
> >     6316                 nbytes = 0;
> >
> > I guess probably it doesn't matter that we're passing a freed variable
> > if nbytes is zero.
> >  But could we also just set "aux_payload_buf = NULL"?
> > I am not going to try silence this type of warning in Smatch.
> Yes, It isn't a problem... but will fix it to make smatch happy.
> 

Thanks!

regards,
dan carpenter

