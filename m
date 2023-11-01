Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9B5C4167D
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Nov 2023 15:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjKAPwr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Nov 2023 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjKAPwq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Nov 2023 11:52:46 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE353E4
        for <linux-cifs@vger.kernel.org>; Wed,  1 Nov 2023 08:52:40 -0700 (PDT)
Message-ID: <412fe393cd49401e26a5624f0290eb43.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698853958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=roc3salG/iBzdCTw02HYKXBTEjo+ITZiLo5IAP3KDc4=;
        b=JRgET8dn74KCYwx+aO0W8df59rPdHfCjnxEV2zoKBVIILgAGIvx6bzfzI3gjD+HRHFxmNa
        FhvWII0amjwBb6e0FCWDPFfV+ISbAxANUrpyv3UvJhc5WabP/RUqijFWFf65/wB2vs6Sod
        gvD+Gnu34cejnat1Ju4wHbOvYchBlIPdXfzy5FWS1KBRsLXxjvmvkR72jUym2ffzggOuZr
        8ARzfo/Z3ldwfvNXTGR/cxPuZpzrvBtg+iZ9Bfmb8vxGgFYHDZpHXFYcbL5DT8Wy+lI//M
        tqaXEFsO8LlRTKx1BnR30TJ9GE1n954wnt2h4+mTbOLCA4kbnLGnFTMFuQj1Jg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698853958; a=rsa-sha256;
        cv=none;
        b=NPZyC8lfwkapX80p0FZzE9kY4PyfHjbWV0xWoqk4X6mh/uFNCYkEe3hMsjNF5EWvrXR63c
        zwQ6tR6dfegfa+yEdpragWhN6xx749Udu8315xciW8Tyy8zyteVMOw0d6s3fhXhMmbV+6s
        trxBwqUYoXBFwVcaSq3sy8FLkonyLfOrHzd6m+I/JNTCOJWMnnJZVaEombPoueQ+pAagv6
        0xLbTCzb8DiABwWhvGqASug3ZQGI+9PQM7VRXwSTwfcgy17uDgd9w9lTkaZVkLpMawnnL/
        OKK90eGPn/h5lBXSkcqHnRdnMLdLdxOY9/itM09TshcYENJT3l3HUQSRAoc58A==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698853958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=roc3salG/iBzdCTw02HYKXBTEjo+ITZiLo5IAP3KDc4=;
        b=S6iOvaT/k/sFwUaEz95WDyhO0VaCxRJIhV4S3/no/K+CQPwiYDQ01ggCYDaOEBUcVWTfyO
        fu5PDr1Gw0COK0naZVHvl2LNQQN72pA6kKmVTvg241768AtLRP/HL0vuiTkUqyuv0xj00a
        9oLPtNkOK1p9R3mux3PWJ5AUBbTFCBx+tpf0pKDNq4f4ZAJgtawANDnA6Or6FzSHp7kWCk
        ElT5Vu9fP6GidYjXWQY8Bb4cgyJ9AMp8lo+3jvKslQ0KkaM2oO7SHsrGhQVdZRK0QEnIDs
        JZPotISbsCFHfgjBwxyKY0jCfUTRTyK8rNSmoHDidU6qVUSMYsODDvpmMPOnCg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     nspmangalore@gmail.com, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting
 multichannel
In-Reply-To: <20231030110020.45627-11-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-11-sprasad@microsoft.com>
Date:   Wed, 01 Nov 2023 12:52:33 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> When the user mounts with multichannel option, but the
> server does not support it, there can be a time in future
> where it can be supported.
>
> With this change, such a case is handled.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsproto.h |  4 ++++
>  fs/smb/client/connect.c   |  6 +++++-
>  fs/smb/client/smb2pdu.c   | 31 ++++++++++++++++++++++++++++---
>  3 files changed, 37 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 65c84b3d1a65..5a4c1f1e0d91 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -132,6 +132,10 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
>  			struct smb_hdr *in_buf,
>  			struct smb_hdr *out_buf,
>  			int *bytes_returned);
> +
> +void
> +smb2_query_server_interfaces(struct work_struct *work);
> +

Why are you exporting this?  smb2_query_server_interfaces() seems to be
used only in fs/smb/client/connect.c.

>  void
>  cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
>  				      bool all_channels);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index e71aa33bf026..149cde77500e 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -116,7 +116,8 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
>  	return rc;
>  }
>  
> -static void smb2_query_server_interfaces(struct work_struct *work)
> +void
> +smb2_query_server_interfaces(struct work_struct *work)
>  {

Ditto.

>  	int rc;
>  	int xid;
> @@ -134,6 +135,9 @@ static void smb2_query_server_interfaces(struct work_struct *work)
>  	if (rc) {
>  		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
>  				__func__, rc);
> +
> +		if (rc == -EOPNOTSUPP)
> +			return;

Maybe also get rid of cifs_dbg() when rc == -EOPNOTSUPP?

>  	}
>  
>  	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index b7665155f4e2..2617437a4627 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -163,6 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>  	int rc = 0;
>  	struct nls_table *nls_codepage = NULL;
>  	struct cifs_ses *ses;
> +	int xid;
>  
>  	/*
>  	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
> @@ -307,17 +308,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>  		tcon->need_reopen_files = true;
>  
>  	rc = cifs_tree_connect(0, tcon, nls_codepage);
> -	mutex_unlock(&ses->session_mutex);
>  
>  	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
>  	if (rc) {
>  		/* If sess reconnected but tcon didn't, something strange ... */
> +		mutex_unlock(&ses->session_mutex);
>  		cifs_dbg(VFS, "reconnect tcon failed rc = %d\n", rc);
>  		goto out;
>  	}
>  
> -	if (smb2_command != SMB2_INTERNAL_CMD)
> -		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);

Why are you removing this optimisation?  For example, session/tcon
reconnect will no longer be triggered after returning back to userspace,
only when next I/O comes in.
