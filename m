Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA669C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Dec 2022 04:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiLWEVK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Dec 2022 23:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLWEVI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Dec 2022 23:21:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F02201B4
        for <linux-cifs@vger.kernel.org>; Thu, 22 Dec 2022 20:21:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B33C361A09
        for <linux-cifs@vger.kernel.org>; Fri, 23 Dec 2022 04:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3B0C433EF
        for <linux-cifs@vger.kernel.org>; Fri, 23 Dec 2022 04:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671769263;
        bh=NAoofNn3fhgrKQKJmnIeYxESZaY+K8zxqHdSFqnm9KA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gTzvOJe6gjtUlDvBi38GGOhgpPIPc3qUuEUegOSCJteQ7i7o05b1BnK1OYheVAIeM
         VVrH/MIwOKJZul3n+mZ2sflqj8cM2LP+VuCEV0gPTATJZiapNae4Tp29mLFISl2mLg
         D5QwbZyT0ckKbunwhXIdpHldNQR+b1/NihN209xzfFxHP1w5gZKu+e/YskI/ZPbSRR
         dGEDrwP2+PSX3+dxVo6XYRnBQlifZT2bgDjFsFLiwgwExCUCznkzHBsrLPcVPCvNHJ
         ZUxoEyZ/hewPJFNGVq1yQSMfpzIyUaX2M2NZfuurbsFDRAabaPjehBSYpaD9BVLrol
         vSzIYPnzhDpNQ==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-12c8312131fso4837892fac.4
        for <linux-cifs@vger.kernel.org>; Thu, 22 Dec 2022 20:21:03 -0800 (PST)
X-Gm-Message-State: AFqh2kpNqy0xqpempqTseOlcuJSI8fkRY0Vr8T8p09ZxvuBH/pt6UjR4
        J1G9+/RtttLRV7rPkC1/SUEi9eMxLiD8swxipOA=
X-Google-Smtp-Source: AMrXdXvwi+Xsdthu6Fy0jT+vsrUdYf8DlfHSKFXXzrTCT/omVQY8GLKCixeXpsVrZI7guAhF9lvdP+36IYhUH35ZVmU=
X-Received: by 2002:a05:6870:a10e:b0:141:828c:12b5 with SMTP id
 m14-20020a056870a10e00b00141828c12b5mr614490oae.8.1671769262175; Thu, 22 Dec
 2022 20:21:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:2d06:0:0:0:0 with HTTP; Thu, 22 Dec 2022 20:21:01
 -0800 (PST)
In-Reply-To: <20221222104701.717586-1-mmakassikis@freebox.fr>
References: <20221222104701.717586-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 23 Dec 2022 13:21:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_SLXF664ajnNEVxkx-BOSk7M-JXAn_w-_SuoTjfZtH1A@mail.gmail.com>
Message-ID: <CAKYAXd_SLXF664ajnNEVxkx-BOSk7M-JXAn_w-_SuoTjfZtH1A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: send proper error response in smb2_tree_connect()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-12-22 19:47 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
Hi Marios,
> Currently, smb2_tree_connect doesn't send an error response packet on
> error.
>
> This causes libsmb2 to skip the specific error code and fail with the
> following:
>  smb2_service failed with : Failed to parse fixed part of command
>  payload. Unexpected size of Error reply. Expected 9, got 8
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/ksmbd/smb2pdu.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 14d7f3599c63..bd2ff9ffa965 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1882,12 +1882,14 @@ int smb2_tree_connect(struct ksmbd_work *work)
>  	if (IS_ERR(treename)) {
>  		pr_err("treename is NULL\n");
>  		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
> +		smb2_set_err_rsp(work);
>  		goto out_err1;
>  	}
>
>  	name = ksmbd_extract_sharename(conn->um, treename);
>  	if (IS_ERR(name)) {
>  		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
> +		smb2_set_err_rsp(work);
>  		goto out_err1;
>  	}
>
> @@ -1895,10 +1897,12 @@ int smb2_tree_connect(struct ksmbd_work *work)
>  		    name, treename);
>
>  	status = ksmbd_tree_conn_connect(conn, sess, name);
> -	if (status.ret == KSMBD_TREE_CONN_STATUS_OK)
> +	if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
>  		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
> -	else
> +	} else {
> +		smb2_set_err_rsp(work);
>  		goto out_err1;
> +	}
>
>  	share = status.tree_conn->share_conf;
>  	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
> @@ -1928,13 +1932,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
>  	if (conn->posix_ext_supported)
>  		status.tree_conn->posix_extensions = true;
>
> -out_err1:
>  	rsp->StructureSize = cpu_to_le16(16);
> +	inc_rfc1001_len(work->response_buf, 16);
> +out_err1:
>  	rsp->Capabilities = 0;
>  	rsp->Reserved = 0;
>  	/* default manual caching */
>  	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
> -	inc_rfc1001_len(work->response_buf, 16);
>
>  	if (!IS_ERR(treename))
>  		kfree(treename);

How about moving smb2_set_err_rsp() to the end of this function to simplify?

@@ -1987,6 +1987,9 @@ out_err1:
                rsp->hdr.Status = STATUS_ACCESS_DENIED;
        }

+       if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+               smb2_set_err_rsp(work);
+
        return rc;
 }

> --
> 2.25.1
>
>
