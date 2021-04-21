Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1B5C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C5F6141C
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhDURnY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbhDURnY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Apr 2021 13:43:24 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BE7C06174A
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 10:42:50 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k128so22640556wmk.4
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 10:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=aNDAGih556waRq2rd7wKh4GrqRDa9GTsVKo0fzmq2uU=;
        b=WTToaFdcLlj0rRxjJks8xMH1L4S4RXKoFrJjrXC/VgI7Rlrhow/J77JvBQ/K6CS1eE
         V1YxH0k+Q1b9xFiOohjiG0eoYAfwfPaDhKei92MYK2qKFmiVlhTTlUgh6Wr/7tmu/1f4
         I+7b34eSjzl6Uw4ZjQI04lRsybS7tepFDsT+ZyCMv8FNTnHJw9zTHIXIS09liRStxItG
         ePSYpur7OhHt0g9KCbLNw2T7kqU/F00EfUhc5PbsRVxLREhl2Hn/VShdkRd5wC9OGq31
         msfTA2DWYwKAI396D7lKxlUGMlS/mTFo1CHzEpaO6jFbnV2OXZR0BYvw8hN7Ups5iLhT
         N1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aNDAGih556waRq2rd7wKh4GrqRDa9GTsVKo0fzmq2uU=;
        b=bbeuj+hRiQN942GlVxwipVaXpihg8wnhVndNwtLyJDz4NkJYx9LAssKKkRZmOXx6kQ
         V2AA2QbNOY2wptJfC0wqLdLUb/VJh3D95BK/D276kBuIQ5Ki6+xJZPsLHYCzXijVNJJ0
         q0vs8ndDaUxPfjw0G2emY619DQ7+Zwi/dJoTyWtdaKhJ9uQX7PEbAV/bINb8pdXzTj3k
         IL02YcGwQVzhlvBNd5zx1np3zDxkD5MpzKDu5sYF/Ait3DwUVVqrppUitwAhum0tqiKf
         uICnagmagfy4qqfIQgBTP8tRUKAYQhqNnjzLoN33H9Usk1Kjqto1YUN8OJSMuqOsnEoR
         Mi6Q==
X-Gm-Message-State: AOAM533gcxy0jidzhdKKVruPRoZ4BMKV4GTX2tcyhIEJNFqFOP2zK9fp
        ubPGAXtqPbmNJyMTfbamo+uBaw==
X-Google-Smtp-Source: ABdhPJxBUa0tUSyzbvEgk48di7KnQzP9gYZ94C/OBx1LxK81ysjAWRPrkdROuqV5edCtZi87uIimCQ==
X-Received: by 2002:a1c:3983:: with SMTP id g125mr4638820wma.163.1619026968954;
        Wed, 21 Apr 2021 10:42:48 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ec4b:6d50:c93f:f2c4:62f1:b1e8? ([2a01:e34:ec4b:6d50:c93f:f2c4:62f1:b1e8])
        by smtp.gmail.com with ESMTPSA id i4sm140686wrx.56.2021.04.21.10.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 10:42:48 -0700 (PDT)
Message-ID: <1157a5af41b38f8826a08e9684ea2b124a0cc21f.camel@freebox.fr>
Subject: Re: [Linux-cifsd-devel] ksmbd testing progress - buildbot run passed
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net
Date:   Wed, 21 Apr 2021 19:42:48 +0200
In-Reply-To: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
References: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 2021-04-21 at 12:18 -0500, Steve French wrote:
> Current Linux client (minus the deferred close patches) to current
> ksmbd on 5.12-rc8 as a test target passed all tests:
> 
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/32
> 

It doesn't look like any test was actually run though.
I looked at some of the tests output and they all had umount errors:

  umount: /mnt/test: not mounted.
  umount: /mnt/test: not mounted.

The warmup smb3 generic/001 hints at cifs.ko not being loaded:

rmmod: ERROR: Module cifs is not currently loaded
mount error(113): could not connect to 192.168.122.13Unable to find
suitable address.


Marios

