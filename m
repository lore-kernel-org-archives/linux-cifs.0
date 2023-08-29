Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD2DC6FA8F
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Aug 2023 23:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbjH2XXf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240035AbjH2XXN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Aug 2023 19:23:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CD4139;
        Tue, 29 Aug 2023 16:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=zmAvbKbvHPTK+tSdU1LtS5cJIoj5hGJqWxhJnxvR1TE=; b=bkHEmD8N0NCg57Z34V1rkyw9uD
        Y/t/T67CzbZr9uXqiw/E9VtVFHYX4zsPf13GEqti8H0fmXeoFONAQbWAXpgGAdlqV/W9D+pL2kGr2
        3UvXSEKce7SNAXikHXnPzbztWnCEI1f/7izMx2q9hMstLCv02rGTRXSb96hFOco3L5JtqqJtR7mO9
        T3jGZhdoyyYmZojv9jDfulvK+5o5xhPn3ZHF4zWQ2f/8jm151LT8h0bmPROr3X7g/ueoY8N1jVDnZ
        lxH2E7EF5X9eIA6k9Oo8lyMNv2CEnJREoeAUKAqr1wbchmvo6PGp+lC0W51ESSpWVX6Q3L0jybyyW
        NwVL762cWCQvzzqAbE2TWYAuJvmmfoDAfI42qSlpxmgmVJtOdAuv/CipILNnVwazazVqwBRTc/s5g
        U3YZSJHm6Vk72bL7Fa8FySuHDjXGZkvoYuSC0SH1aNYNgnWrwqi1F/XB39oV2GuDmp3YuNDtSxF1F
        Kut9+xXj9tg/zmsKLuh9klvI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qb837-00AfZm-0X;
        Tue, 29 Aug 2023 23:23:05 +0000
Message-ID: <62bd6748-fedf-85c4-7416-7e620fa6b4f2@samba.org>
Date:   Tue, 29 Aug 2023 18:23:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] smb: propagate error code of extract_sharename()
Content-Language: en-US
To:     Katya Orlova <e.orlova@ispras.ru>,
        David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Paulo Alcantara <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        Steve French <smfrench@gmail.com>
References: <20230815133831.3537-1-e.orlova@ispras.ru>
From:   Steven French <sfrench@samba.org>
In-Reply-To: <20230815133831.3537-1-e.orlova@ispras.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next

On 8/15/23 08:38, Katya Orlova wrote:
> In addition to the EINVAL, there may be an ENOMEM.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
> Signed-off-by: Katya Orlova <e.orlova@ispras.ru>
> ---
>   fs/smb/client/fscache.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/fscache.c b/fs/smb/client/fscache.c
> index 8f6909d633da..34e20c4cd507 100644
> --- a/fs/smb/client/fscache.c
> +++ b/fs/smb/client/fscache.c
> @@ -48,7 +48,7 @@ int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
>   	sharename = extract_sharename(tcon->tree_name);
>   	if (IS_ERR(sharename)) {
>   		cifs_dbg(FYI, "%s: couldn't extract sharename\n", __func__);
> -		return -EINVAL;
> +		return PTR_ERR(sharename);
>   	}
>   
>   	slen = strlen(sharename);
