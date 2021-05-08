Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A74C433B4
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 13:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7A9611BD
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 13:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhEHNhf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 May 2021 09:37:35 -0400
Received: from p3plsmtpa08-10.prod.phx3.secureserver.net ([173.201.193.111]:37944
        "EHLO p3plsmtpa08-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhEHNhf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 May 2021 09:37:35 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 May 2021 09:37:35 EDT
Received: from [192.168.0.100] ([96.237.161.203])
        by :SMTPAUTH: with ESMTPSA
        id fN16ljRhblLmNfN17lKiey; Sat, 08 May 2021 06:29:14 -0700
X-CMAE-Analysis: v=2.4 cv=AN1HNu1Z c=1 sm=1 tr=0 ts=6096922a
 a=Pd5wr8UCr3ug+LLuBLYm7w==:117 a=Pd5wr8UCr3ug+LLuBLYm7w==:17
 a=IkcTkHD0fZMA:10 a=PKzPBIdWZPNp9C6LNuQA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3] 3 small multichannel client patches
To:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <98a3e99b-3d2e-0480-55db-f843c7016351@talpey.com>
Date:   Sat, 8 May 2021 09:29:13 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfFefQxL7+DxKeGNyMFJ6uFu3LIGBksmiRAUmshphBZm2EjzqrSJjo/AcYR2SzL05ZKgLIpybVg4iEtpxSC+jCJjri6J+XaLSWG9KmFVBNNspOz47YDfZ
 ihM0rkvauTaSc7S5pRVH6W5iCU+JayhBOMkURmi7Oy6EGCzjBJiIQr9FHytmo6CmnFZrMF11MWCilIGr4ImgBHbhBq/qwrJBQKw9YX8gcbvSBke1fW8WJoDH
 foZZBxFOTsI5DZV7Gx+YZ3URq08mTVFFZtZE+x8bRtZF/P/B2AsS50ivmkHiJZMA
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/7/2021 9:13 PM, Steve French wrote:
> 1) we were not setting CAP_MULTICHANNEL on negotiate request

> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index e36c2a867783..a8bf43184773 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -841,6 +841,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>  		req->SecurityMode = 0;
>  
>  	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
> +	if (ses->chan_max > 1)
> +		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>  
>  	/* ClientGUID must be zero for SMB2.02 dialect */
>  	if (server->vals->protocol_id == SMB20_PROT_ID)
> @@ -1032,6 +1034,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>  
>  	pneg_inbuf->Capabilities =
>  			cpu_to_le32(server->vals->req_capabilities);
> +	if (tcon->ses->chan_max > 1)
> +		pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> +

This doesn't look quite right, and it can lead to failed negotiate by
setting CAP_MULTI_CHANNEL when the server didn't actually send the bit.
Have you tested this with servers that don't do multichannel?


> 2) we were ignoring whether the server set CAP_NEGOTIATE in the response

Is this "CAP_NEGOTIATE" a typo? I think you mean CAP_MULTI_CHANNEL.
In any case:

> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 63d517b9f2ff..a391ca3166f3 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -97,6 +97,12 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
>  		return 0;
>  	}
>  
> +	if ((ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) == false) {

This compares a bit to a boolean. "false" should be "0"?

> +		cifs_dbg(VFS, "server does not support CAP_MULTI_CHANNEL, multichannel disabled\n");

The wording could be clearer. Technically speaking, the server does not
support _multichannel_, which it indicated by not setting CAP_MULTI_CHANNEL.
Also, wouldn't it be more useful to add the servername to this message?
	"server %s does not support multichannel, using single channel"
or similar.


> 3) we were silently ignoring multichannel when "max_channels" was > 1
> but the user forgot to include "multichannel" in mount line.

 > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
 > index 3bcf881c3ae9..8f7af6fcdc76 100644
 > --- a/fs/cifs/fs_context.c
 > +++ b/fs/cifs/fs_context.c
 > @@ -1021,6 +1021,9 @@ static int smb3_fs_context_parse_param(struct 
fs_context *fc,
 >  			goto cifs_parse_mount_err;
 >  		}
 >  		ctx->max_channels = result.uint_32;
 > +		/* If more than one channel requested ... they want multichan */
 > +		if ((ctx->multichannel == false) && (result.uint_32 > 1))
 > +			ctx->multichannel = true;

Wouldn't this be clearer and simpler as just "if (result.uint32 > 1)" ?
