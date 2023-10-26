Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75EBC25B6B
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Oct 2023 19:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjJZT7a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Oct 2023 15:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZT73 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Oct 2023 15:59:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159EDB9
        for <linux-cifs@vger.kernel.org>; Thu, 26 Oct 2023 12:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698350321;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DKGH30ebKbNOdnmAvexW15bM5fXzpA/juQXVVxLdAxk=;
        b=F0gtUy14VgO9+9hDvCuiy9wYRGtPLVYMt3cPbPZwBdpozRxlAZEAw8KvzsbT1XisSQ7+q8
        OQuC8458zbHKdSS7uBPk7TOLNTwlzBxGx7RQM19RWl4AK/IB7SmiNW9DwTmGu2m0qYBK3W
        pgYabMV9Kju/wMLDjgzFgOmi7yk2zR4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-0ppK8IiROy6FFBbK__hy4w-1; Thu, 26 Oct 2023 15:58:39 -0400
X-MC-Unique: 0ppK8IiROy6FFBbK__hy4w-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7a832e1a358so104187039f.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Oct 2023 12:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698350319; x=1698955119;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DKGH30ebKbNOdnmAvexW15bM5fXzpA/juQXVVxLdAxk=;
        b=SPxq6IOyiR2NcX5ry950wfhV25Ctrgp9wpwUBGRt7KcXalKu3/3eaO4z8PBxcf9fdC
         f9FsZIPG+7BDdgDgsLorqx7rT1zbyVNHbOVkaUiVarJ7k+nvEuH9EhXxQ/V6yegjtv4p
         4hVw7IN4X534Rwg6KZCxcR5scS56RWYCS9dce1+OPDTlPB1Cmpbmd2DeCPM/2UYZGN1l
         unZ2wMR4GoxOYjaK4obTrUrXM4r148BNwwM2xFFFSC7bqhhxiQRukdrfGI5YJBvpWhux
         pd7WLGpAqnaPrU8kHX03Lt4qr4fMW9YZI+6GlMirjZxuGw1Kh7tPWx0JlQSLNRP99GsY
         s5WA==
X-Gm-Message-State: AOJu0Yz5GPwC41pPu0R/h7sOSGScrRA8C1hUbctgcQetxzPgLhyUYOTd
        ZChTBsilldCjOEktBEuuf2Uk8X3+Pt8ya64g5b5eh8q/VVi8a7JjZdZ8JAftqjQ5vvjpgbzzqoA
        A0NsdVWdVZxTT1W9567lbORG4JLVfew==
X-Received: by 2002:a05:6e02:1d96:b0:351:526a:4bc with SMTP id h22-20020a056e021d9600b00351526a04bcmr1067409ila.15.1698350318804;
        Thu, 26 Oct 2023 12:58:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4OK91wHuAkcVZ8wytpXmJiDuwLvMnoSvTS33a9Xm/dy+XO5YKJA6cSB46m5FZCtfWFQr4mw==
X-Received: by 2002:a05:6e02:1d96:b0:351:526a:4bc with SMTP id h22-20020a056e021d9600b00351526a04bcmr1067396ila.15.1698350318517;
        Thu, 26 Oct 2023 12:58:38 -0700 (PDT)
Received: from [172.16.0.69] (c-67-184-72-25.hsd1.il.comcast.net. [67.184.72.25])
        by smtp.gmail.com with ESMTPSA id y7-20020a029507000000b0045c8e7e68a3sm766474jah.105.2023.10.26.12.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 12:58:38 -0700 (PDT)
Message-ID: <7ef19ef0-c339-8127-9561-57c0d07a215b@redhat.com>
Date:   Thu, 26 Oct 2023 14:58:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Reply-To: sorenson@redhat.com
Subject: Re: possible circular locking dependency detected warning and
 deadlock
Content-Language: en-US
To:     Paulo Alcantara <pc@manguebit.com>,
        Frank Sorenson <frank@tuxrocks.com>, linux-cifs@vger.kernel.org
References: <e04c7696-fc8a-b799-13f9-2cc051ba80dd@redhat.com>
 <92abdb27545d717b4e4898a1708b2013.pc@manguebit.com>
From:   Frank Sorenson <sorenson@redhat.com>
In-Reply-To: <92abdb27545d717b4e4898a1708b2013.pc@manguebit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/26/23 13:07, Paulo Alcantara wrote:
> Frank Sorenson <frank@tuxrocks.com> writes:
>
>> I'm getting a 'WARNING: possible circular locking dependency detected'
>> followed by a DEADLOCK when I access /proc/fs/cifs/DebugData while doing
>> a lot of mounts/unmounts/IO, etc.
> Could you please retry with attached patches?
>
> I was able to reproduce an GPF with a similar test by running xfstests
> from Steve's for-next branch with
>
>          'vers=3.1.1,multichannel,max_channels=2'
>
> against Windows Server 2022.
>
> No deadlocks or lockdep warnings.  The deadlock fix from second patch
> was just based on code analysis.

Thanks.

I'll test and report back.

Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

