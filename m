Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D89ECAAD3
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 16:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiIAQOz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 12:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbiIAQOs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 12:14:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08549279
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 09:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=4VbnLm+oSf1DApioDjDC5Xzrzi5PuVWWRgrvbrXZSLU=; b=2+w+W/4c++hhJcgI+k20UZTYxf
        VdZ0TPSmgyDewQV/nkPZ0yrfNCKll0Pn5ENrPEOWp6ZOaMj5e4bkK+GZZEYyQq1lGMHKWx3WEWHBX
        B5C3sNCUC1hlgNDJz8s7PdmgJUrVF93ArhRJsE0koiy4o+rPulb124V0skql9zcouxjL/IpNH+y3v
        iVNSRZN4wXJMjBv4Vo/wh+PW1GhoF/r9wqQHmpB+va3A8nXqTs2G+b0WPsGhWYuEYaT4lW69idHjm
        jjhYtSTG28Kbr7/34BdVclk0j63+YZ756kn81/hmPl6OV5w9325nIioCVY/58eqso8FdzSFGGt4TZ
        Sx35TYUXbJcr3JGJqNULVSIaVgd1wZosoFLfsBjauQRzO0rHxZFPbYFjcZdEYcV51bhMccYvhqGqY
        W1MlwpoKe0kHvGK6tl93IzjBUK6KzddU+SWq+WGs+q+hzHBZZb4CR9jm7THPyOosbAlF1cHmYE1rI
        nFzYIoPAvynSgWeBiGjIMJQ8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oTmpw-002fZe-NG; Thu, 01 Sep 2022 16:14:37 +0000
Date:   Thu, 1 Sep 2022 09:14:31 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     atheik <atteh.mailbox@gmail.com>, hyc.lee@gmail.com,
        linkinjeon@kernel.org, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, smfrench@gmail.com
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Message-ID: <YxDaZxljVqC/4Riu@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <47dbb75a-b299-066c-61cc-2b21ca96173f@talpey.com>
 <20220901051929.14421-1-atteh.mailbox@gmail.com>
 <f7302043-44f9-35d8-2316-778985a14959@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f7302043-44f9-35d8-2316-778985a14959@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
>
>Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
>as you say that should be man 5k smb.conf. Sounds ok to me.
>
>But the second thing I'm concerned about is the reuse of the smb.conf
>filename. It's perfectly possible to install both Samba and ksmbd on
>a system, they can be configured to use different ports, listen on
>different interfaces, or any number of other deployment approaches.
>
>And, Samba provides MUCH more than an SMB server, and configures many
>other services in smb.conf. So I feel ksmbd should avoid such filename
>conflicts. To me, calling it "ksmbd.conf" is much more logical.

+1 from me. Having 2 conflicting file contents both wanting
to be called smb.conf is a disaster waiting to happen.

Please use ksmbd.conf.
