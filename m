Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72555C6FD18
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 23:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjC2XVp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjC2XVo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 19:21:44 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70744171E
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 16:21:43 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id e11so17818799lji.8
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 16:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680132101;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtSiJsA/lZ88L2un1QDafrmeA+ZXYg/KJLwWTWWtzFM=;
        b=HOEhK2SDRJPdLO0swG/YOIiFZhs5rO1m7Ca1hznnkWrVWSj66inRhFlDA36t/kj92i
         weJKbDLSSWNAa6NSLMlfQFS2P6QS7PJZi5bzhRNESaFxml84mOJzeQTQ14SzLCw8ja/j
         EynlFrWRexf8rEqqzoamkdhVIhxUJb1355RmCUldpyzft25CUAtCOFs75H9Qv1G5FnKk
         0VUFBMc68ZfQ3XrmhWMdpl+9KIQCuFhOKjQllAOlptuKqog21HIwgoufJ1sxGWtlJyml
         LjrI7K6gBR9E+GXBcueNtJz19hGsLP0bfNcApeGw+PvtNMxnwSRyS0jAkcJqiRys1IAU
         yfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680132101;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtSiJsA/lZ88L2un1QDafrmeA+ZXYg/KJLwWTWWtzFM=;
        b=18KwT3faVtoy5deCvHrkQnh3MaA2u5opk4kqWRJdBJcykC1OD9v5PDUB9JhaMQJyig
         /prrXkF1s4sIMt79D/te3fIE5uHs/uUXmaP7p8ZjUWUblV4xoCAuF4jWSoyt9LVVN6XD
         kxrHSK74uMDxTnyG+bweuIOOu4QeLzVPoIrM4G2h3sp5D2ray/G4KNQ+bhj4cXjeFlPb
         Rh3s2R8uqP9JRVebBI7rs0BRIe3/7d/bMcBLBDS47/EMf5ewaj6OJ4jz5QfJVTACVlGD
         w5lpsfixVWKQjx3BV6vlmqQQiPYMnpDdzgFUaXnO294V0N1juv/N5oG06AE3zrcKyrJW
         0QTw==
X-Gm-Message-State: AAQBX9cX4l7XlIevORtlK4IHxr/V6xdnmFM2d5sxe7SpMgTGmaDQRnvL
        5r6etKJox7/4D6ssQ5kRJmIV7v/BM5a5uOYERgCMAVgN
X-Google-Smtp-Source: AKy350b3GRWHkk3ykD9KbnDz/nbjGJwwuDyQ9gsRdW8CM9l+1arsrnf3RuFUWkCfFGp0GCqpe8+taR4LuXwuiqOGR9E=
X-Received: by 2002:a2e:3203:0:b0:298:b337:c11f with SMTP id
 y3-20020a2e3203000000b00298b337c11fmr6461285ljy.7.1680132100890; Wed, 29 Mar
 2023 16:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230329202406.15762-1-ddiss@suse.de> <CAH2r5mtEXtRWbtf9OAzwWa2Wm6fUR+fZrU=OmtiP3E0VQpn+2w@mail.gmail.com>
In-Reply-To: <CAH2r5mtEXtRWbtf9OAzwWa2Wm6fUR+fZrU=OmtiP3E0VQpn+2w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 29 Mar 2023 18:21:29 -0500
Message-ID: <CAH2r5msRi6=9cvx_SKtP=1r9YUY1p8Gy8mc_hXmBWHE1gVurow@mail.gmail.com>
Subject: Fwd: [PATCH] cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next and added Paulo's Reviewed-by

On Wed, Mar 29, 2023 at 3:23=E2=80=AFPM David Disseldorp <ddiss@suse.de> wr=
ote:
>
> When compiled with CONFIG_CIFS_DFS_UPCALL disabled, cifs_dfs_d_automount
> NULL. cifs.ko logic for mapping CIFS_FATTR_DFS_REFERRAL attributes to
> S_AUTOMOUNT and corresponding dentry flags is retained regardless of
> CONFIG_CIFS_DFS_UPCALL, leading to a NULL pointer dereference in
> VFS follow_automount() when traversing a DFS referral link:
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   ...
>   Call Trace:
>    <TASK>
>    __traverse_mounts+0xb5/0x220
>    ? cifs_revalidate_mapping+0x65/0xc0 [cifs]
>    step_into+0x195/0x610
>    ? lookup_fast+0xe2/0xf0
>    path_lookupat+0x64/0x140
>    filename_lookup+0xc2/0x140
>    ? __create_object+0x299/0x380
>    ? kmem_cache_alloc+0x119/0x220
>    ? user_path_at_empty+0x31/0x50
>    user_path_at_empty+0x31/0x50
>    __x64_sys_chdir+0x2a/0xd0
>    ? exit_to_user_mode_prepare+0xca/0x100
>    do_syscall_64+0x42/0x90
>    entry_SYSCALL_64_after_hwframe+0x72/0xdc
>
> This fix adds an inline cifs_dfs_d_automount() {return -EREMOTE} handler
> when CONFIG_CIFS_DFS_UPCALL is disabled. An alternative would be to
> avoid flagging S_AUTOMOUNT, etc. without CONFIG_CIFS_DFS_UPCALL. This
> approach was chosen as it provides more control over the error path.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  fs/cifs/cifsfs.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 71fe0a0a7992..415176b2cf32 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -124,7 +124,10 @@ extern const struct dentry_operations cifs_ci_dentry=
_ops;
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  extern struct vfsmount *cifs_dfs_d_automount(struct path *path);
>  #else
> -#define cifs_dfs_d_automount NULL
> +static inline struct vfsmount *cifs_dfs_d_automount(struct path *path)
> +{
> +       return ERR_PTR(-EREMOTE);
> +}
>  #endif
>
>  /* Functions related to symlinks */
> --
> 2.35.3
>


--=20
Thanks,

Steve


--=20
Thanks,

Steve
