Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83523C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 01:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64E276120A
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 01:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhKHBvm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 20:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhKHBvj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 20:51:39 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99C6C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 17:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=DLXpZHbBOOlON9QvHTAiX9DdRq005uQOCBI4sMN+nbo=; b=K9XrGmIuru4DryZ+u/EXwFXSND
        w+c7E4qrYqJPq97Z1qo9KcMkdZ/pwTlx40KodrnnwvwB2JAxWnoBde54P71raltLmDjY6asqhW38Z
        OQkbEU3lMIETy7dMVHoMhJpFtJIjbdErzLSqHo9R2ZDbd/NWYrpkKa4rronf8zUT88Y8F4BLTaU7t
        IlzE+8VcSsNvepQr09u/Aw85EJ8i2wwfZ1QccW8IOz/vlnMjIWHO2mIiYECzfJM3JADKKEZkyTb7I
        4lfIPYoUh8MvduJCT60s9NIdIS/G6G90Nt26E7BxZ8CTkguP9LwYiMZOZSfed8w534Gjrdvi1vXWs
        NvaZTnIARGFYQH355/DWzAOwMFplsnS58FTiU7iyE1JJ30wYm53cmXb4BMuaOG0KhB6t1oWV+7e49
        hxoqBhs6dXowBKTM+G3XCaJSLn7Jj4tLmIPir2xtV8XbcF60sAICDgo5JII+yJVwuokwTkhJ36SHl
        VvseypUFjEcxfuLvfXhJoyMA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mjtmG-005hZ6-96; Mon, 08 Nov 2021 01:48:52 +0000
Date:   Sun, 7 Nov 2021 17:48:49 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYiCAcxxnIbHz4xv@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer>
 <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Nov 07, 2021 at 11:51:37PM +0100, Julian Sikorski wrote:

>Thanks, this looks promising. Do you have any guesses as to why it 
>works for goffice-0.10.50-1.fc35 but not with goffice-0.10.50-2.fc35? 
>Race condition?

No clue, sorry. I'd need to see comparative traces - but all that
will tell me is that it isn't doing the fsync on a read-only file.
