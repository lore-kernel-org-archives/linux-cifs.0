Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8973C4332F
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Nov 2023 20:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjKBU2d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Nov 2023 16:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjKBU2b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Nov 2023 16:28:31 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEC3193
        for <linux-cifs@vger.kernel.org>; Thu,  2 Nov 2023 13:28:25 -0700 (PDT)
Message-ID: <b709f32a96f04ff6136b69605788a2e6.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698956903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zz+kfeiPJqLnbEaWlqqUFrWJaGj4M/22RqvSN+RntKg=;
        b=sVQMRnAWL81fPdM9kCQ/X9HCmgOgT9X0N22vhZWzxs/AxRZRvtbjR1vP4rxUhptDxB4OtJ
        be2WH2ygjQMHvwyGgifQCiTu5tLbWpJ0avWPQ5/XnA/4neImcnu2oNfgGAqZQRBIoIKX7p
        UKs77uk2bBf3tU/E0jTMtc+InUxiajkHWfK/yldbEh8E+SSWSoN3WR82UApqNGKmar9Wfi
        mzWiCNvMsSr1uuImWOh94uU8FuQddJSHi6MRgruCZBJnvfAhcK8Z+O9rtSWbNm4+PBwo3d
        PWJoJsJW8ZY1iPBYqAMKR6kN3c0j0SGgvX08HXPRpWJxLeFtgAxlz7ABo/Nhzg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698956903; a=rsa-sha256;
        cv=none;
        b=Eq8BeqbCCznj+ZUONvcm0lA53WwhfzjQP+V9mwONZbkT4ttaJtmTb5wM99tdH4689pE2zV
        LnSmPHFED8Xe9wqXoEwFeNXImOlv+YkiHaokRylQJfOKmz85FfRNN1v47SKiFFdBIVp1Kt
        1crFhomlmZ9F3yjMUcOzwV6jBud5esUqrM3bLODHe2nyXj10PwhiaehMX6BI7PZMAyYi4S
        DuZoosh4e56shbwsehJSHE3Pz0ywA3GUizXBSPYgcHyS5f1oa2rLYwDrHKYQbC59ozQeI9
        3gK90ODODx0HGQYU7Foyj24VB0WmQYUADw/J06LTxU6p0LFjZ8txB9Fax9lHww==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698956903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zz+kfeiPJqLnbEaWlqqUFrWJaGj4M/22RqvSN+RntKg=;
        b=jseYmhyZuJCmjADwOHimulzhEnW2EbTU1MgPiWnKwG2KFpe0gX+WyOwcGk2DbjoHb5ntGm
        K9b3LB/b2SvbNX5ZKXHVqkW1FDw81R33Cq9ekT7KByB+R93dVXRzb6212tWG82FgeV+lAY
        DLcbQLOfLB0KiW2yEqcY+guQKfR4O5cVHasuo54hEZAKnnlp/IvSmL6DIvIU14Nfpm1QWj
        5WFoxju6qdoJMxVIOAX7qjvtg5/R/pqoequtcHd3c4nSEfpfUOV/xf+/C/BqXSVbaEMBVK
        xtoZNpBts6dPSWeE9V/Bd16xUWxNb1EFvbTPMOwY6BeXqA97byQZJUIBf84U+A==
From:   Paulo Alcantara <pc@manguebit.com>
To:     nspmangalore@gmail.com, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting
 multichannel
In-Reply-To: <20231030110020.45627-11-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-11-sprasad@microsoft.com>
Date:   Thu, 02 Nov 2023 17:28:19 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

nspmangalore@gmail.com writes:

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
> +	if (!rc &&
> +	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> +		mutex_unlock(&ses->session_mutex);
> +
> +		/*
> +		 * query server network interfaces, in case they change
> +		 */
> +		xid = get_xid();
> +		rc = SMB3_request_interfaces(xid, tcon, false);
> +		free_xid(xid);
> +
> +		if (rc)
> +			cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
> +				 __func__, rc);
> +
> +		if (ses->chan_max > ses->chan_count &&
> +		    !SERVER_IS_CHAN(server)) {
> +			if (ses->chan_count == 1)
> +				cifs_dbg(VFS, "server %s supports multichannel now\n",
> +					 ses->server->hostname);

Sorry, forgot to mention that you should call cifs_dbg_server() which
protects access of @server->hostname as cifsd thread could have it freed
before you access it.
