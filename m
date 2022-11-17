Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80532C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Nov 2022 04:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbiKQE6D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Nov 2022 23:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiKQE6B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Nov 2022 23:58:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0DE2B197
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 20:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668661026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRNgsje5v+iSsOtKxKODca+zMELkto4gAPpZd/JZ4Wo=;
        b=UWDu68h1PVK3ShlNTALbY4GMc4uIKbPm4lEOI5019Vxd6JSranyUHHyg45d2+jHR/cGw2K
        a78q3+A43mO2u/xjEoSNA0HHDcHfYepa1BYhF/J4iQezb5U1UHKzR7SxCfGdtvznH4jslg
        Oy+E2yeZFCUKBv/5BAZSJSZgoGh0rEg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-38-lrdq6yjIOO67r6NkDgR7nw-1; Wed, 16 Nov 2022 23:57:04 -0500
X-MC-Unique: lrdq6yjIOO67r6NkDgR7nw-1
Received: by mail-pl1-f199.google.com with SMTP id l4-20020a170903244400b00188c393fff1so562020pls.7
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 20:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cRNgsje5v+iSsOtKxKODca+zMELkto4gAPpZd/JZ4Wo=;
        b=YRTD6fZnh1T3pa9mf4Ia2PIuPsaMFM1xHP3cmyAcd5zl/DNkF62pT7rrwnkN4COnwI
         QGifSqVHHcyLejNUGCD3LjgXyh/lopqWSFndVidGaNNiFjPZ/Y9AhvberU9ljsCIcFyy
         SKxmNxWgSZXF5Ogf7WeOh1irAgqv3ziR22h2wF6VVBaLkgWF1LfPZ0o02Ha58+tvpJTA
         8nT9357FisB/LdlFVZ4uv3KQWnoVDcP+vEYySQaE2UBW2pJw/FeQgyU3HPWjGurfkqH3
         zKMiHb3maT3HJNTg2p5JbHXPHVEQHCckVbkf/HEUKwBWm8rnmzq6gu3+YGahMVMGOh/S
         tj3g==
X-Gm-Message-State: ANoB5pkeHrwMyrPTCA26/VS+TkTcbkei5ZLLwd5MTD+ocaQ9RZp/P90p
        Eq5eD2jJzo5CrKqpKr1fC4jshcJaWR7TQtYqdbvJFC40CRkzVd9ezBOrfk0TEZpJJnSgPBUrunf
        mUjvSIaCUtIalHrmhBCg0Uw==
X-Received: by 2002:a63:5f14:0:b0:43c:969f:18a7 with SMTP id t20-20020a635f14000000b0043c969f18a7mr635977pgb.12.1668661023834;
        Wed, 16 Nov 2022 20:57:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf63NoWprGlJIf07cPSVNjoTzWwiwPuTUjMvYVGNkdFlaO5oAfTME7Qg7XG1sR+f67MLmbpQ7Q==
X-Received: by 2002:a63:5f14:0:b0:43c:969f:18a7 with SMTP id t20-20020a635f14000000b0043c969f18a7mr635959pgb.12.1668661023555;
        Wed, 16 Nov 2022 20:57:03 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o6-20020a17090a55c600b0021870b3e4casm438628pjm.47.2022.11.16.20.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 20:57:03 -0800 (PST)
Subject: Re: [PATCH 2/7] ceph: use locks_inode_context helper
To:     Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org
Cc:     linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-cifs@vger.kernel.org, chuck.lever@oracle.com,
        viro@zeniv.linux.org.uk, hch@lst.de
References: <20221116151726.129217-1-jlayton@kernel.org>
 <20221116151726.129217-3-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <589a0fcc-569f-e5b2-0877-c1639736ae5e@redhat.com>
Date:   Thu, 17 Nov 2022 12:56:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221116151726.129217-3-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 16/11/2022 23:17, Jeff Layton wrote:
> ceph currently doesn't access i_flctx safely. This requires a
> smp_load_acquire, as the pointer is set via cmpxchg (a release
> operation).
>
> Cc: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/locks.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 3e2843e86e27..f3b461c708a8 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -364,7 +364,7 @@ void ceph_count_locks(struct inode *inode, int *fcntl_count, int *flock_count)
>   	*fcntl_count = 0;
>   	*flock_count = 0;
>   
> -	ctx = inode->i_flctx;
> +	ctx = locks_inode_context(inode);
>   	if (ctx) {
>   		spin_lock(&ctx->flc_lock);
>   		list_for_each_entry(lock, &ctx->flc_posix, fl_list)
> @@ -418,7 +418,7 @@ int ceph_encode_locks_to_buffer(struct inode *inode,
>   				int num_fcntl_locks, int num_flock_locks)
>   {
>   	struct file_lock *lock;
> -	struct file_lock_context *ctx = inode->i_flctx;
> +	struct file_lock_context *ctx = locks_inode_context(inode);
>   	int err = 0;
>   	int seen_fcntl = 0;
>   	int seen_flock = 0;

Thanks Jeff!

Reviewed-by: Xiubo Li <xiubli@redhat.com>


