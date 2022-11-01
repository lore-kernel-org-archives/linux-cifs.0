Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC6FC4332F
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Nov 2022 17:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiKARxq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Nov 2022 13:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKARxp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Nov 2022 13:53:45 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA341C43D
        for <linux-cifs@vger.kernel.org>; Tue,  1 Nov 2022 10:53:44 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1opvSG-0002CB-Mc; Tue, 01 Nov 2022 18:53:40 +0100
Message-ID: <0fb9b48e-3bcc-5a5e-15fb-1d3e2752d80b@leemhuis.info>
Date:   Tue, 1 Nov 2022 18:53:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] cifs: fix regression in very old smb1 mounts
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20221011231207.1458541-1-lsahlber@redhat.com>
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20221011231207.1458541-1-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1667325224;e463da83;
X-HE-SMSGID: 1opvSG-0002CB-Mc
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 12.10.22 01:12, Ronnie Sahlberg wrote:
> BZ: 215375
> 
> Fixes: 76a3c92ec9e0668e4cd0e9ff1782eb68f61a179c ("cifs: remove support for NTLM and weaker authentication algorithms")
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>

Ronnie, Steve, did this change create any trouble in 6.1 pre-releases so
far? If not: could you please consider submitting this change for
inclusion in 6.0 and 5.15, as this is a regression from the 5.15 days
that according to the bugzilla ticket seem to annoy some people a lot.

Ciao, Thorsten

> ---
>  fs/cifs/connect.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 93e59b3b36c7..c77232096c12 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3922,12 +3922,11 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>  	pSMB->AndXCommand = 0xFF;
>  	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
>  	bcc_ptr = &pSMB->Password[0];
> -	if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
> -		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
> -		*bcc_ptr = 0; /* password is null byte */
> -		bcc_ptr++;              /* skip password */
> -		/* already aligned so no need to do it below */
> -	}
> +
> +	pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
> +	*bcc_ptr = 0; /* password is null byte */
> +	bcc_ptr++;              /* skip password */
> +	/* already aligned so no need to do it below */
>  
>  	if (ses->server->sign)
>  		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
