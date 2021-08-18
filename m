Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746FFC4320A
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 13:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D26A6108E
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 13:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhHRNWf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhHRNWd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 09:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BE5E61038;
        Wed, 18 Aug 2021 13:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629292919;
        bh=5KcLxEBGDXnCm8nVaw+nWKg2bSoQtlfddRDR7GGl9T8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RndsyT80eK5peg0Wa+LDP9j9fD87rWPH7qIZCmht5Z5qvvpkhwKs50Efvp8c2W/BZ
         K2+LUMFBtPNST8VG79B8kQVc1cgq9/I35NIa5fnECRSgdYvvuTxAQWyn3US+50ZCTV
         1vziHJFjbAkqMbNUaCBWYVK0Jl11hbfLkpVOubDUJaABhANU08nQKvlBxCmPoC7Ora
         guCnuc3dI4J3JvT1iBiSmzKP+5O24KcsCV9HQpxwfjMIg+oo8KAhCUkdV3y9RJxlts
         vvCb7lejSc+JbydRhSD+8s73QeOek/uomkFwZAEoDfGnncaR4CUK33YJgskRdX+C+r
         qB/9oQlc9TAqQ==
Message-ID: <2f3a644e279a8a0933343339fa0add8e76276bf8.camel@kernel.org>
Subject: Re: [PATCH] CIFS: Fix a potencially linear read overflow
From:   Jeff Layton <jlayton@kernel.org>
To:     Len Baker <len.baker@gmx.com>, Steve French <sfrench@samba.org>,
        Suresh Jayaraman <sjayaraman@suse.de>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Date:   Wed, 18 Aug 2021 09:21:57 -0400
In-Reply-To: <20210817102709.15046-1-len.baker@gmx.com>
References: <20210817102709.15046-1-len.baker@gmx.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 2021-08-17 at 12:27 +0200, Len Baker wrote:
> strlcpy() reads the entire source buffer first. This read may exceed the
> destination size limit. This is both inefficient and can lead to linear
> read overflows if a source string is not NUL-terminated.
> 
> Also, the strnlen() call does not avoid the read overflow in the strlcpy
> function when a not NUL-terminated string is passed.
> 
> So, replace this block by a call to kstrndup() that avoids this type of
> overflow and does the same.
> 
> Fixes: 066ce6899484d ("cifs: rename cifs_strlcpy_to_host and make it use new functions")
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  fs/cifs/cifs_unicode.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 9bd03a231032..171ad8b42107 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -358,14 +358,9 @@ cifs_strndup_from_utf16(const char *src, const int maxlen,
>  		if (!dst)
>  			return NULL;
>  		cifs_from_utf16(dst, (__le16 *) src, len, maxlen, codepage,
> -			       NO_MAP_UNI_RSVD);
> +				NO_MAP_UNI_RSVD);
>  	} else {
> -		len = strnlen(src, maxlen);
> -		len++;
> -		dst = kmalloc(len, GFP_KERNEL);
> -		if (!dst)
> -			return NULL;
> -		strlcpy(dst, src, len);
> +		dst = kstrndup(src, maxlen, GFP_KERNEL);
>  	}
> 
>  	return dst;
> --
> 2.25.1
> 

Reviewed-by: Jeff Layton <jlayton@kernel.org>

