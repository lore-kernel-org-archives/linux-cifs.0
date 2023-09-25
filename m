Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9881FCE7A95
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Sep 2023 15:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjIYPHw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjIYPHu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Sep 2023 11:07:50 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0356910C
        for <linux-cifs@vger.kernel.org>; Mon, 25 Sep 2023 08:07:44 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4060b623e64so79085e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 25 Sep 2023 08:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695654462; x=1696259262; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ib5Tu/yij6vtc9GrE/st2fBgFvO/LwgeHlPUA9wo+ZA=;
        b=xkifSKljq/OcnmhkycjyJiwkdXC0SOEGlPGGbkgi/i9jtsMeiXtd5o+HNnzf44BftW
         nbe72fXlLPCLpLpjV2Bnl0Rq6b2uy9xrLSSjWJX9OcT/M3jQ3vjXvBiHU5OSiAR5Wwkm
         CU46faJk1mDel3RkOCM9T1ZfG7KW3bTfFKHyBGWrnjQtOlBXG99bk820hQzzFQcXq/BI
         4es9KWc4w/QXcsNm2ubmHHLxsH6fXUel2Gt4HJPzxUbs5ZigSGbcDw23ShdC7LutJxER
         asJMM70qvTiyiwrAgZyX/5YrvZvxzgIiLit8a4yrpEVK/N8uEyUAWSj+YVtpYbaIA6a9
         4rKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695654462; x=1696259262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ib5Tu/yij6vtc9GrE/st2fBgFvO/LwgeHlPUA9wo+ZA=;
        b=InYtYwohOCmuWnYJBSQ9Zc6ppaMB+C29AChu+z4z2BMn5drY/sKDTu9VH7/ZYgrly0
         QNVs1rj9gkv2pe8abnS9qiElXbgdrTqyPqoimvQlAELHTG3r1svea7Xd3/Y30wTwaIcu
         l/zi8r0iB/wn8a4ZZ0us8Llv3X0mGvoZPVhJtomGG6La9mQ7J1BCT/cowAPswtCaruX/
         rUQrR0MQ3jTYfd52ydWKEf7FDn3OBUDN9XDdFHpjWvv2DIa44wPy+6+maPIIkpBVC7++
         LCfvrRLyn1O01zc+QSCHKEE1FvbO83IMapP/LlJurKS840tIOZ2UafIp7Qf8d+oGKH+x
         1I3g==
X-Gm-Message-State: AOJu0Yzwm1MXVNUxe6r2zPgxalvtuSjOdoXfw0iaFf6WD7kN1uZNuyri
        mu6qrRFMyVfDAepX34g+rNB9ng==
X-Google-Smtp-Source: AGHT+IGhhKsVyPQsHpOL8KJMLR5nCSgXbuHNvqh0lfoD3EFI26aQfJU+KLvBnXh3gftGejaFT4hNNg==
X-Received: by 2002:a1c:4b1a:0:b0:3fe:1fd9:bedf with SMTP id y26-20020a1c4b1a000000b003fe1fd9bedfmr5322643wma.11.1695654462386;
        Mon, 25 Sep 2023 08:07:42 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e20-20020a05600c219400b003fe1c332810sm15301042wme.33.2023.09.25.08.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 08:07:41 -0700 (PDT)
Date:   Mon, 25 Sep 2023 18:07:37 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Su Hui <suhui@nfschina.com>
Cc:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] cifs: avoid possible NULL dereference
Message-ID: <1ae6c204-ed00-4626-8246-32d66ae7e232@kadam.mountain>
References: <20230925045220.93400-1-suhui@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925045220.93400-1-suhui@nfschina.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 25, 2023 at 12:52:21PM +0800, Su Hui wrote:
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 2108b3b40ce9..37eed057ded0 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -4878,6 +4878,12 @@ void cifs_oplock_break(struct work_struct *work)
>  	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
>  						  oplock_break);
>  	struct inode *inode = d_inode(cfile->dentry);
> +
> +	if (!inode) {
> +		cifs_dbg(FYI, "%s : failed to find inode\n", __func__);
> +		return;
> +	}
> +

Are we allowing this in the middle of the declaration block these days?

>  	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct cifsInodeInfo *cinode = CIFS_I(inode);
>  	struct cifs_tcon *tcon;


regards,
dan carpenter
