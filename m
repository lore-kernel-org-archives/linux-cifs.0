Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274D6C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 04:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiCAEWn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Feb 2022 23:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiCAEWl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Feb 2022 23:22:41 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C223334641
        for <linux-cifs@vger.kernel.org>; Mon, 28 Feb 2022 20:22:01 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id bd1so12448321plb.13
        for <linux-cifs@vger.kernel.org>; Mon, 28 Feb 2022 20:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xcD3DLzlSiv5+2xjOLCVbu4Mz1FZrHNfXkP4SfFAO8M=;
        b=AsAcUiT4NrNpzqrWszR0OWWixCi8jN2fDRzW4vxT3O7KAUy5XNJF+N2BSNetl96BSc
         QdVzuxwjw4EaU71YRBhD98Zm2dad2IhB5TYv4hH4eV7aLLJOzMO93WY2Zr0a6NCdp0Vs
         e57PBJ6k1tlcd0oFHqBaZ2i3yc78o0wKxY6JU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xcD3DLzlSiv5+2xjOLCVbu4Mz1FZrHNfXkP4SfFAO8M=;
        b=Fk/NnTi+9YikOT1bhXg0qLrlRgEyT21KzmITaQE4lYdoSw6naybHhg1ItZYOEdhOKk
         IhVoPMr3F/LFPo5MAOV/zoBeuRHKJibjTLsW1C2EaPlxbdbsFQJIEMJTSOTdCSy6kWoR
         86RhiDkMPAY/605b/G9yHj4l801mnAvumzLM2e1lX+ABHbiy0CS6VDctTlD55m00Zxek
         lTqRYC0LZiYfM6mOg4hPew/pJHQeGj0BaM5+EtPdKx1dfrhZg8wapIwa6m1l5UlHNABd
         uwO2vBjoX/8HERVAP5sYdQl30exoDOi7PsilplvpdIhv8JA5aX0J4xgNY295D9N+dzQa
         5LXw==
X-Gm-Message-State: AOAM531dcASzzOx8s1Pa7BV5x2KK0cQQtl+x+v9YMXy7SSocSlXT9ULG
        0kco2xVSMkxVS+pNqlz/cgOvXw==
X-Google-Smtp-Source: ABdhPJwwbP2Sa8V8bqQ8Sj5wA8WG+81HwJJqlkxz7EeIf458BpFvq8FByyWaKKp+nvTcdX/dynhLSg==
X-Received: by 2002:a17:902:d504:b0:14d:846f:e7da with SMTP id b4-20020a170902d50400b0014d846fe7damr18148823plg.133.1646108521297;
        Mon, 28 Feb 2022 20:22:01 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:95ec:e94d:ec6b:6068])
        by smtp.gmail.com with ESMTPSA id o7-20020a63f147000000b00373facf1083sm11415554pgk.57.2022.02.28.20.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 20:22:00 -0800 (PST)
Date:   Tue, 1 Mar 2022 13:21:55 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3/4] ksmbd: increment reference count of parent fp
Message-ID: <Yh2fY6F8n/8KvMEH@google.com>
References: <20220228234833.10434-1-linkinjeon@kernel.org>
 <20220228234833.10434-3-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228234833.10434-3-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/03/01 08:48), Namjae Jeon wrote:
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 3151ab7d7410..03c3733e54e4 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -5764,8 +5764,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
>  	if (parent_fp) {
>  		if (parent_fp->daccess & FILE_DELETE_LE) {
>  			pr_err("parent dir is opened with delete access\n");
> +			ksmbd_fd_put(work, parent_fp);
>  			return -ESHARE;
>  		}
> +		ksmbd_fd_put(work, parent_fp);
>  	}

And also in ksmbd_validate_entry_in_use()?

>  next:
>  	return smb2_rename(work, fp, user_ns, rename_info,
> diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
> index 0974d2e972b9..c4d59d2735f0 100644
> --- a/fs/ksmbd/vfs_cache.c
> +++ b/fs/ksmbd/vfs_cache.c
> @@ -496,6 +496,7 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode)
>  	list_for_each_entry(lfp, &ci->m_fp_list, node) {
>  		if (inode == file_inode(lfp->filp)) {
>  			atomic_dec(&ci->m_count);
> +			lfp = ksmbd_fp_get(lfp);
>  			read_unlock(&ci->m_lock);
>  			return lfp;
>  		}
> -- 
> 2.25.1
> 
