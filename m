Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DC1C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Mar 2022 15:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiC2PLP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Mar 2022 11:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbiC2PLO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Mar 2022 11:11:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF33217950
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 08:09:31 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u26so21040028eda.12
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=7lH8rI99KHcETDVw84puXbs3cPikJuKWeGUUCM6asBY=;
        b=aARHCT7PQPJb+cRcMd2ZqpZi/UEqacExj+1GI6mGT9qz+kPBiHkQ68Ri1fYwUirXGh
         iR6D71nWyAyZzKQSMq7XLRFDOuVgfOudGxaXU6XjDPum0N4rnor9FAR5EcVhgTdQydC7
         M+OS4bj5VDQc1JyoMMk+rp13folS+ES/Y7tyMj/4kajJltkB6VnohP277T/J9SRiBOel
         o/eTCPAwgMqMoZatrrahNEvT8EAMfhi+lAM4MUJSuuudH389L2lfqC5tb6LQ14lxKr7i
         p1MMgnTZKdTPgx+oMJwikXV4al8NKrnWFcWb12pf4se5mp+S43nMNKIG3OdphKyGHVQL
         O49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7lH8rI99KHcETDVw84puXbs3cPikJuKWeGUUCM6asBY=;
        b=NXxZC+SK6pRrsGwjBUjE5vdGVHhK+7uHi3GSLBd2CT/XfgVulwlVQ123BWwTTQF8j7
         WQX1cM9xUtSBTioSe6+5c+PXtX/0DiCniKmn1Tbh2427vCg+WJ6PogyFoAeDE3JZeHz8
         i9jU3s8ywy7bxUGqdyTf3OcSrHRTZUoHuJTBODpaifIqHQZzQqd3rc9jnhSo5FfFT2o6
         ACnnw2qJawazN4YDVAO80JDS+1GTQc0zFJD5+nhVxD0PyfhccYZxaidYeN1VfX5iqzmR
         kEuswc/ZKxT2jfE7CbH5MVGT1MiMWxg77tAcUFekKpUh9wfQcn0p5B9YhYzLpVqxvH++
         34ww==
X-Gm-Message-State: AOAM532lutJkPqAH/HrVPPREggvz7B0OPbTEmHEWzzYZhBKEqQBdFFTb
        RuTcq2MQwXYmsF+JXmHrn7DZpDPhvDHy2jcpkTce7F/Z8aY=
X-Google-Smtp-Source: ABdhPJw8CiTueWs8GY0z4L+5pEdmbBAsarS4v4Wa2QHxTFVy7ounj+ctWmkbPy8R6pQT5gpKsj2cdIrjtvq1o7nQXIQ=
X-Received: by 2002:a50:a6c2:0:b0:410:a328:3c86 with SMTP id
 f2-20020a50a6c2000000b00410a3283c86mr5103131edc.55.1648566564963; Tue, 29 Mar
 2022 08:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oU3E6v639bXKQd4ssEvWmAWEDD0qUOixcwONzJyLYgOg@mail.gmail.com>
In-Reply-To: <CANT5p=oU3E6v639bXKQd4ssEvWmAWEDD0qUOixcwONzJyLYgOg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 29 Mar 2022 20:39:13 +0530
Message-ID: <CANT5p=rTosSwc3fer_dYgDFhTuEeeK5rxYxQMK+M2QuZu8fzpw@mail.gmail.com>
Subject: Re: Regarding EKEYEXPIRED error during dns_query
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 23, 2022 at 10:42 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi David,
>
> I was recently working on validating the recent fixes in cifs.ko and
> key.dns_resolver.
> However, I've stumbled on a different issue now.
>
> The call to dns_query from cifs initially upcalls into userspace and
> key.dns_resolver seems to resolve the name to IPv4 address. This comes
> back with an expiry value of 5 sec; so the key is set a timeout of 5s.
>
> However, at some later point, the IPv4 address changes for this DNS
> name. The resolution in userspace happens just fine, and I get the new
> IP address. However, I can see that the dns_query call from cifs is
> not upcalling to userspace anymore. And the dns_query calls are
> returning -127 (EKEYEXPIRED).
>
> I also tried to "keyctl describe KEY", and it also says "Key has expired".
>
> 1. How can I debug this further?
> 2. Is this a known issue? If so, what's the issue?
> 3. I see that afs.ko calls dns_query with invalidate passed in as
> true. What was the reason for not using the dns cache in the kernel
> keyring? Was it once used and later changed? If so, can you please
> explain why? cifs.ko does not set invalidate=true during dns_query
> calls today. I'd like to understand if there are any risks associated
> with this?
>
> --
> Regards,
> Shyam

Did some more digging into this.
It looks like cifs.ko may sometimes end up doing very frequent dns_query calls.

David: Do you know if making frequent calls to dns_query can possibly
prevent expired keys from being cleaned up?

-- 
Regards,
Shyam
