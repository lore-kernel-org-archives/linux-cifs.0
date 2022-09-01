Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E03ECAAD2
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 20:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiIAU0m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 16:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiIAU0k (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 16:26:40 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B4674360
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 13:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=qCwYkXNdchmY5oojk4bXS8abKEWWyZT75gQUN6AcUu0=; b=1II7adF+21LeYzpoHZqcDliGUx
        DewaDWU73+qnKtL18ms9jtuIW7oBSkSr3ppYFrkgwmSQS8iBd/jk0WRmgR2kEBJCoo+LUS6lOD85B
        RxmcKiHBuYW0E/rjsSdQWOFXqJzG9SbZvb+orVeTt99ZNi/wxvo1ikexPqGLgr24/DyfufmpS4jko
        98BPvsBbUyqy0XfjhgnyDvDKW62pS/VlFHoSC746rG3e0eIIbE35LLKaNhlIqtNrIwmd0iSFJuMl7
        gMdKooPwGfbD7d1lHvJXHgIf69ZIzRLbJyQJzDCy9cBI1xOYwoPlwzZ9O745seBXUe2uxsDyIZZnf
        Yj6eqXY4GwnblX9ur1FCcKNXsbFTnNqPo5V82D1k2BT8yAche3ReIAkisNC6WYa6W/08BLtB7KvW3
        utu2uSGA0GV7aljDyCfsqpX/DTSrfO6YbsNbRmzU8OnMwqIr3W4pNL0qYIzyafRnw8JCfqFPiiKWC
        29uRNViZy+/3kjxiiVsG0oAa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oTqlk-002h94-2u; Thu, 01 Sep 2022 20:26:32 +0000
Date:   Thu, 1 Sep 2022 13:26:26 -0700
From:   Jeremy Allison <jra@samba.org>
To:     atheik <atteh.mailbox@gmail.com>
Cc:     hyc.lee@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com, tom@talpey.com
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Message-ID: <YxEVclFM9X1POlEG@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <YxD6SEN9/3rEWaNR@jeremy-acer>
 <20220901194212.28441-1-atteh.mailbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220901194212.28441-1-atteh.mailbox@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 01, 2022 at 10:42:12PM +0300, atheik wrote:
>On Thu, 1 Sep 2022 11:30:32 -0700, Jeremy Allison wrote:
>>
>>Samba adds and or changes functionality in smb.conf all
>>the time, without coordination with ksmbd. If you call
>>your config file smb.conf then we would have to coordinate
>>with you before any changes.
>
>ksmbd-tools has always called its config file `smb.conf'. Has this
>matter come up before? I don't have anything against changing the name,
>but I'd be surprised if my writing of the man pages first prompted this
>concern.

Well I didn't realize it used the same name until
you wrote the man page :-).
