Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16303C761A6
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Apr 2023 12:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbjDFMJf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Apr 2023 08:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbjDFMJe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Apr 2023 08:09:34 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3162681;
        Thu,  6 Apr 2023 05:09:31 -0700 (PDT)
Message-ID: <8219c3dd87179df545fb6de4b89b2bbc.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680782966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=548kDFj4gIoUugd5f3FYvuQrAA/yoYohbrORtH8xrVk=;
        b=WG6MoNIYST3leO8UG3+SBA1KImJjXJHiBms2FEDzjWadFiVyAuuFk3OicXaKSfwuZtHn3u
        bqS6sDnzoJmjn5JhW0rXbD/1VmPPXqtSJGwLBYEuPqNq4axcIpzZw36sh/WFDlzhJcSxNl
        5DBcWlFdMZZTAo9zFK/HtZ8/1mLx0HKsARVyrnvd4OauNAhQTC6lS910tZYlBdXdaHuMa1
        gFr0nW6ZCsgCQcKQkpEduGC8m9Ocac+WZqCCizZbp/PqUMhOLAMjVR1z1CTQEB1kGraWm3
        J7YrAVLnluy6pWwh2YBBWtNIlBYWKEObedkV2SCx0XYGV92HanF4LrX4Z8Jp+w==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1680782966; a=rsa-sha256;
        cv=none;
        b=X+L8UmhLUdRCBAw9MWHAqu6ulQyTRO1vwEhwH4nMhXOY50ydAUQbV79F8R0krcT89qEq/e
        sAhoVpan6GKLt1OWmZpfPfXst20ouAzbbEOvzY2W+vropoxvtYaVqycd+DLBlNw64kp/zV
        QZdn9uwYphChBpz836Hh3cKz6lV5FGtyjBgJ6738RSClmOtg2VOwMeeXQ9SBfqbc40uSP7
        ADzqy+rEisk421OWhVmi2sQ83zxi1P3c/ggm2uj6fdwMXS6+SzBrYuF3rf/6LkJHpOhMty
        MpISUdKw6RD8VXXq4T+DdADeAZPpPu/R8ipyq4JmOPRVATu5C8Io1ysW0RnR1Q==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680782966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=548kDFj4gIoUugd5f3FYvuQrAA/yoYohbrORtH8xrVk=;
        b=c4FeABY1c2gOAKYwLkzF0oDm8UHzqz72Q5G9vlCPwdcvI0VsuuRFVuWcFjX5YZ1nVkV5cj
        nGo3qoG5a0j+b1/FNnHg5M5QqXbuXAGRWVIR6KBZyEtzWOzOnSUM7Mz06nnM5HMTr7he2Z
        e0va26ZyVMdfqLHtFrZuHzVeqAcNjnomKMg91YXDogjEJUZSVaSd2W2sIqQo3mg5Q+NZ83
        98MY4jfVONrbUutKxEXnpFG6H/JoSDirVmxuOk7WChTV559mSqTn8AlqGZ3gBr0KgWZtj9
        FYCL5x6IQGqCUY2xH662o9SkyFd+xJjnGmfOzR1FI0g77YkAxRxNGgmr2k22wg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] cifs: double lock in cifs_reconnect_tcon()
In-Reply-To: <ZC6JEx4dvWUvgcwW@kili>
References: <ZC6JEx4dvWUvgcwW@kili>
Date:   Thu, 06 Apr 2023 09:09:16 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dan Carpenter <error27@gmail.com> writes:

> This lock was supposed to be an unlock.
>
> Fixes: 6cc041e90c17 ("cifs: avoid races in parallel reconnects in smb1")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  fs/cifs/cifssmb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
