Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C65C32793
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 22:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjARWbg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjARWbU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 17:31:20 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC7165F2C
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 14:31:15 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id vm8so1080457ejc.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 14:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=198c/rE7n354IuRh6mGhDtRZWd9cepSv8Ua6yRRO74A=;
        b=LBkICLFmVmK7KTCteXmBxlnGaGmQvSv0cr8O1IT8x5BRrApshPwzwdc55eIrjThHQm
         lfeJ5OQhkQrUwM6/lR8pkKrNZTk4Anb17wpD+/pUWb6jKNHnwBBUml98F6JIhL+qfUHQ
         uv/7jB95Xnjc/ZJX2zu6LdwhZas4owYrdKn8hIQzyVz+g4ucCbuVWzt71DwpMBAiFvra
         z45qs/XCgdBy/OxWbk5JtPoeQH/3uzkNSxgzXyGYRSJVeYvw1AGjzaIuuw2skKmYFo3H
         gjJFJkf5oQkM78Jeai9gm6eGbVwqTQtPXqCnSZrh3i0WClawaQyEYR9l+xNShPpyJdff
         lx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=198c/rE7n354IuRh6mGhDtRZWd9cepSv8Ua6yRRO74A=;
        b=AARW+XuldfnbScW0s9iM1RL9w/zsfjJ87ZfS9fqcrakH3Ao4mq/0IZEWi366f9n8+J
         n/K2XM1wOVf8lmeksiUlYEalSCUyiEAcVdMdqMvIVnJ6JQKWNKUjtLwEOogk9CupmKu1
         ltWeaPnXr7JmEED+c3w4vpB0FXKNHS6MEsVYxi70Zt89HPkSc9TXgWNsPj0G+Y4mJ8fG
         lpqUpkhI+VuBx9ci46mbX6htCo6s+j0CxtDNKGu/feeYCQ4fsgbN0+b0Y+Ns83pXkQwZ
         pC2VCoSwPI7SFoXiF/I6pHd1VA1H8Elp8ERgV7LJDXMJfMkkPEV3JmL/SzGd05iF9Fqz
         GdsA==
X-Gm-Message-State: AFqh2kr4bpzy5VYEnKB+hsuVMbrMsv7lFtp5FKmZ5PrJYWfaVulOEucP
        wZOESDWKFUxaqTRrz9pi5vl5sYmHt4iasimhS4k=
X-Google-Smtp-Source: AMrXdXukWHSCCXK1vJT7VBP++30VWgczW2u9SKZKS64t0vndWtokLLT9Hs85PTUoyE02l589Ms/MSEnBebbltWIRWJ4=
X-Received: by 2002:a17:906:d04b:b0:78a:d0a4:176 with SMTP id
 bo11-20020a170906d04b00b0078ad0a40176mr752441ejb.720.1674081074252; Wed, 18
 Jan 2023 14:31:14 -0800 (PST)
MIME-Version: 1.0
References: <20230118170657.17585-1-ematsumiya@suse.de> <871qnrvc7z.fsf@cjr.nz>
 <CAH2r5muxweTSeBdGjcG1W_WjuM7fdd4JpqPCB7AqVXjn8QyhBw@mail.gmail.com>
 <87tu0nwkrc.fsf@cjr.nz> <CAH2r5mt2UvW32AZrvjde75NL3V5qWLbc=WTTdaLZsi2B4oYEhA@mail.gmail.com>
In-Reply-To: <CAH2r5mt2UvW32AZrvjde75NL3V5qWLbc=WTTdaLZsi2B4oYEhA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 19 Jan 2023 08:31:02 +1000
Message-ID: <CAN05THREk=3Zk2VTpfm6qyAA88mV2xm0qtiL0-p44ZRhXPuzmw@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not include page data when checking signature
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We should update the buildbot so we clear dmesg before every test and
then check for and fail any test that results in something unexpected.

On Thu, 19 Jan 2023 at 08:18, Steve French <smfrench@gmail.com> wrote:
>
> Aah yes. I see it now
>
> On Wed, Jan 18, 2023, 16:17 Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> Steve French <smfrench@gmail.com> writes:
>>
>> > I wasn't able to reproduce this with generic/465 - at least not
>> > running to current Samba.  Any thoughts on how to reproduce the
>> > original problem?
>>
>> The test actually doesn't fail.  You can, however, observe the signature
>> verification failures on dmesg while running it, e.g.
>>
>>         CIFS: VFS: \\ada.test\test SMB signature verification returned error = -13
