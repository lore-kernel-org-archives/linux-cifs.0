Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFC3C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Dec 2021 01:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345669AbhLACA7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 21:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345621AbhLACAu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Nov 2021 21:00:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCA1C061574
        for <linux-cifs@vger.kernel.org>; Tue, 30 Nov 2021 17:57:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01DBCB817B3
        for <linux-cifs@vger.kernel.org>; Wed,  1 Dec 2021 01:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF95C53FCB
        for <linux-cifs@vger.kernel.org>; Wed,  1 Dec 2021 01:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638323846;
        bh=BqDjzl4G1TNVouHZmNuj/o43Wylhvb5JNkt81D+r9Sc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=nHCaeaolaxd60nOAiQe/LRdYCtGJz86ZkRWtXj641dm+VQmygHiX+K4oM32ahb3BE
         1oii9/hmKmALu3tdFqTWYGjxyaGp+XZFWoJbAs1rLJG02DPEQkuBMj8Gj8ysev3Vtm
         /ejAFwNHZI8cIX1oyQeCyM9lihE0WgxwwwHyGngOaYXOKI64egibLleQPLfQ//q7Ru
         Y0rhb4DJ43csnnKsxnQdY0ZyEda3tDX5WirNUdwqQN1nYAPWH8+aN6Ey5UqjUeREeG
         2hl7z4f6Elote6XdFWSg4pPRp4BYIBHHewE11Q2EblsgUQjgUBPyn86w9XZtiOidN3
         /yNp7+NEPGpFA==
Received: by mail-oi1-f174.google.com with SMTP id 7so45142778oip.12
        for <linux-cifs@vger.kernel.org>; Tue, 30 Nov 2021 17:57:26 -0800 (PST)
X-Gm-Message-State: AOAM531K69VWxNEJtAX6UrMj5KaEwS34ffn3lBB2DKCfImsw3fr2+POd
        ZoPTDfUNHkYCXh5bmGkzpxrylDgRANYcoT4W3Jg=
X-Google-Smtp-Source: ABdhPJzCt3k2bQDCtdmCE+eT6ZqLqxuXUDA030q2Ea8V8A/zaeOiO7loKqKZQsrr+4GxNDpp4dX7+CUufhHts3jZyFs=
X-Received: by 2002:a05:6808:a8f:: with SMTP id q15mr3001277oij.65.1638323845946;
 Tue, 30 Nov 2021 17:57:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Tue, 30 Nov 2021 17:57:25
 -0800 (PST)
In-Reply-To: <20211130115430.GA16669@kili>
References: <20211130115430.GA16669@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 1 Dec 2021 10:57:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9mdapD8Zzb4BoP77=N6zTU3VcXn+AcUGOKAD3Ga_=HPw@mail.gmail.com>
Message-ID: <CAKYAXd9mdapD8Zzb4BoP77=N6zTU3VcXn+AcUGOKAD3Ga_=HPw@mail.gmail.com>
Subject: Re: [bug report] cifsd: add server-side procedures for SMB3
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-30 20:54 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> Hello Namjae Jeon,
Hi Dan,
>
> The patch e2f34481b24d: "cifsd: add server-side procedures for SMB3"
> from Mar 16, 2021, leads to the following Smatch static checker
> warning:
>
> 	fs/ksmbd/smb2pdu.c:2970 smb2_open()
> 	error: uninitialized symbol 'pntsd_size'.
Thanks for your report! I have sent the patch to the list.
Let me know if the patch doesn't fix this warning:)
>
> fs/ksmbd/smb2pdu.c
>     2930                 if (rc) {
>     2931                         rc = smb2_create_sd_buffer(work, req,
> &path);
>     2932                         if (rc) {
>     2933                                 if (posix_acl_rc)
>     2934
> ksmbd_vfs_set_init_posix_acl(user_ns,
>     2935
>  inode);
>     2936
>     2937                                 if
> (test_share_config_flag(work->tcon->share_conf,
>     2938
> KSMBD_SHARE_FLAG_ACL_XATTR)) {
>     2939                                         struct smb_fattr fattr;
>     2940                                         struct smb_ntsd *pntsd;
>     2941                                         int pntsd_size, ace_num =
> 0;
>     2942
>     2943                                         ksmbd_acls_fattr(&fattr,
> user_ns, inode);
>     2944                                         if (fattr.cf_acls)
>     2945                                                 ace_num =
> fattr.cf_acls->a_count;
>     2946                                         if (fattr.cf_dacls)
>     2947                                                 ace_num +=
> fattr.cf_dacls->a_count;
>     2948
>     2949                                         pntsd =
> kmalloc(sizeof(struct smb_ntsd) +
>     2950
> sizeof(struct smb_sid) * 3 +
>     2951
> sizeof(struct smb_acl) +
>     2952
> sizeof(struct smb_ace) * ace_num * 2,
>     2953
> GFP_KERNEL);
>     2954                                         if (!pntsd)
>     2955                                                 goto err_out;
>     2956
>     2957                                         rc =
> build_sec_desc(user_ns,
>     2958                                                             pntsd,
> NULL,
>     2959
> OWNER_SECINFO |
>     2960
> GROUP_SECINFO |
>     2961
> DACL_SECINFO,
>     2962
> &pntsd_size, &fattr);
>
> No check for if "rc" is an error code.
>
>     2963
> posix_acl_release(fattr.cf_acls);
>     2964
> posix_acl_release(fattr.cf_dacls);
>     2965
>     2966                                         rc =
> ksmbd_vfs_set_sd_xattr(conn,
>     2967
> user_ns,
>     2968
> path.dentry,
>     2969
> pntsd,
> --> 2970
> pntsd_size);
>
> ^^^^^^^^^^
>
>     2971                                         kfree(pntsd);
>     2972                                         if (rc)
>     2973                                                 pr_err("failed to
> store ntacl in xattr : %d\n",
>     2974                                                        rc);
>     2975                                 }
>     2976                         }
>     2977                 }
>     2978                 rc = 0;
>     2979         }
>
> regards,
> dan carpenter
>
