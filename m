Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A311C32771
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 02:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiI2CI1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiI2CI0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 22:08:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5BDFB33D
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:08:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l9-20020a17090a4d4900b00205e295400eso27721pjh.4
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9JDgVuQ1LuvJRpOADB4A6P6KH9w01eLrOQ1FEuI/C6c=;
        b=Q38N7xt7yEyCb6R7/nneecgtCQNMQOn8Hl97ud1wFvX/t3Gl3/KcljYtzJXhTn+buo
         N28TYV7nZCtNXKiAhuDw0o2nrDTLdvN82RvB2HulJtu8V3EgAkOiJL+H9RDyNs3qcLLX
         vsKyQe1qOT16SI7Mvc8f5V3tPWYZs35JbTeJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9JDgVuQ1LuvJRpOADB4A6P6KH9w01eLrOQ1FEuI/C6c=;
        b=Qj1Mu2DvElnu8Y5HO6a8Z5jAHUaidA0pA6Lh02M8O/vwQrHaRWu8udwzkn5zW77ReP
         8bQC8HiIRTVN1PQWsj2aBB+U9kLal66oOGk+L0Z2FOtbIa4QbjMITneR1f48YqCjSxU3
         FN5/pXmwq/nMvfuCWQDQSvJVvwEr2T/+eq9spzaIxTrXR/y8hYT+5sSKEodB/EmyWtg0
         q9YQlqdE71K7xAuePIqVlmoDkDn2hcVZJzRBftnvpQE5FaVlrbt3sdPG1K8UjjIPnfmX
         svOS9MwzI9aYNt0EqmtS0ga/V2KFE9/MB/iEC/O3bghB6aMOylHOFHOL4ZDg8W3p3uEX
         +aYw==
X-Gm-Message-State: ACrzQf0AudEvS9W+DYfyMEAqLphRAWN7k9Qt/WMLP/oEepGFkXRNq6V1
        szQVJQ6X4Vpp9KEPOPzrURi0vw==
X-Google-Smtp-Source: AMsMyM4OkyI/9lPGYDPWzF67HTuToDnXgFvDdX9wksCO2qxgGuJIRPBNzpE+uLRigb+vMpKB++g0DA==
X-Received: by 2002:a17:90b:33c5:b0:202:fa60:3769 with SMTP id lk5-20020a17090b33c500b00202fa603769mr1083057pjb.60.1664417305044;
        Wed, 28 Sep 2022 19:08:25 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:e460:54c6:9d69:badf])
        by smtp.gmail.com with ESMTPSA id z67-20020a626546000000b00546d875a944sm4729590pfb.214.2022.09.28.19.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 19:08:24 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:08:20 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
Subject: Re: [PATCH] ksmbd: hide socket error message when ipv6 config is
 disable
Message-ID: <YzT+FFwTmcvjppVc@google.com>
References: <20220927215151.6931-1-linkinjeon@kernel.org>
 <60322098-648f-2610-bcf2-1cec581d4f86@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60322098-648f-2610-bcf2-1cec581d4f86@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/09/28 11:25), Tom Talpey wrote:
> > diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
> > index 143bba4e4db8..9b35afcdcf0d 100644
> > --- a/fs/ksmbd/transport_tcp.c
> > +++ b/fs/ksmbd/transport_tcp.c
> > @@ -399,7 +399,8 @@ static int create_socket(struct interface *iface)
> >   	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
> >   	if (ret) {
> > -		pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
> > +		if (ret != -EAFNOSUPPORT)
> > +			pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
> 
> Why not just eliminate the splat? The only real error seems to be
> that IPv6 is not configured, which is undoubtedly intentional, and
> in any case there's nothing to do about it. Suggesting to "try ipv4"
> is kind of pointless, isn't it?

Yeah, that pr_err() sounds like a suggestion, but in fact it's not.
It meant to say "ipv6 socket creation failed, fallback to ipv4".
