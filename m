Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DCCEB64D8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 18:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjFVSpR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjFVSpQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 14:45:16 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E531FF5
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:45:15 -0700 (PDT)
Message-ID: <e2e6207f531cee699b0bd9b261fb6232.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687459512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zQb9EnQePsgq9S7GxCn2/G0/A+YncF+9VrDLu1DksfQ=;
        b=jEvVc7J2PnqQhnjDe6KbIFJGK/xlIQJJeDycN21t36eP/ApCKSYbLNygSF9sAauL39xDiu
        027IFjKfAviewMAf1zRWghSky+hkKq+enqEOOqdt0Z31jrwo42LT9s9k4w+xYnOXUr+Yo0
        o2iZe7DXe62KlYBnLLNi/iD/r89dr7lTFP0/n5GlDc4+sBbXuBfANET9+YuUUvFiyUG78b
        c4u8ErMb+GBTpkUg9d0fSjB7el1yE2YgsqBM74uL1FT4ynvQY09Wma6JjL1YpGgJePvupD
        LAP2g23YTy6wboGpDEoB2EwBggkSGMZ+e4MH8ItZZbw2IKtm9Al1QQPbcmeJUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687459512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zQb9EnQePsgq9S7GxCn2/G0/A+YncF+9VrDLu1DksfQ=;
        b=n88WWb+D7KTSvG5ZBfEPXU1DTgNYww8lhvSw2mttpsp0JyaXmyd3sVFZEVbepOnFiYxfnW
        N/VB5ricO2ZSFdm9hUAAmQFCQKgeogMLbpCHrlO8ZkyhH95Ub7DY/TPtcrm+FTHSYPUylq
        ApDFqu8+ixqLaZXMPBrpaP0cZ2Bp1pjMaDsqm9cCzjO7KLVaz9tJQ36fNcxGVty0NiI2X1
        8iYVBjEbH3p63eFOgXeM7XdWHZypGM0K5cBjD6svz6YiSMVYrVME5+RsDhbbAe3OUrN8/i
        GFwy9qLTspSKIYK2PkAbzarsCGZ0L6t13bkFor3a6mWLMx9yVd1w1ooF4/6ecw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1687459512; a=rsa-sha256;
        cv=none;
        b=ZlmsUpTHSB4kWHspziMBcTP/MlhUr/LQBDJen1ja9PAeMhFMS7DU/hVdw1h0rlGu+S4hOh
        k5FoPULEpgduEu/0+goOwZ9bqA/Ram8UCUt4hcwidVP1l/qtrZepia+LXAuOiSzrl6EZCB
        7NkoKDGamqQwkncf4TsMo08o9LI5cvOIqde5YGf8nEvjfpMYeqfWmg2WTdQ67VlDSBS11o
        QUHslTyG3MUIYNBIYEiRrkzkydGEQr1sS3uzSVdjCdFqMjs7LNIY8GUJqavKeP6w87AJOg
        375uQFAlfODSKSrkaWr2i1ZNMMMUkZD22XhRL06B2Ka+yse9Svn2TKuUGFe23w==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ematsumiya@suse.de, bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 1/3] cifs: log session id when a matching ses is not found
In-Reply-To: <20230622181604.4788-1-sprasad@microsoft.com>
References: <20230622181604.4788-1-sprasad@microsoft.com>
Date:   Thu, 22 Jun 2023 15:45:06 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> We do not log the session id in crypt_setup when a matching
> session is not found. Printing the session id helps debugging
> here. This change does just that.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2ops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index a8bb9d00d33a..8e4900f6cd53 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4439,8 +4439,8 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>  
>  	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
>  	if (rc) {
> -		cifs_server_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
> -			 enc ? "en" : "de");
> +		cifs_server_dbg(VFS, "%s: Could not get %scryption key. sid: 0x%llx\n", __func__,
> +			 enc ? "en" : "de", le64_to_cpu(tr_hdr->SessionId));

I think this should be FYI rather than VFS as it is usually fine to fail
on smb2_get_enc_key() while the session was reconnected, since the I/O
would be retried later and the current value of @tr_hdr->SessionId would
no longer match any existing session ids.  I have seen such messages
while running reconnect tests with 'seal' mount option.

Other than that, looks good.
