Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BDEC2BB02
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 12:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D461D60F21
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 12:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343915AbhIAM4f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Sep 2021 08:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347001AbhIAMyx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 1 Sep 2021 08:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD72861059
        for <linux-cifs@vger.kernel.org>; Wed,  1 Sep 2021 12:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630500836;
        bh=umSK4s6PLS8FMsVkn8rvzYz9GRxtV2Qjan9yb5eLfA0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Jjc+DCkx7TCxqorEDYjTjb6BZ7HR4AA03MhC1nypYWLxkG1N69FQGLgdW87iHQOmi
         X7nXhmmfKLb1Do2gnBOt639eL+ubhR/l82xQxfDpOfwbb4CIYkEfDSNMsjj4ZPt/ES
         nnV4FeAm2NdRazK9kbUHED56SvnZi0RPqY8qqzvZv0VHGNe50n7Fj0H0CXnCqWImlZ
         5WBLaZokhybT7rKwLda1JZsf/5082Km/Ojl01f3Fz/EVpVeKkwyl86GKkfj1iW49Gv
         BpwdLU3Y6/YkOOqauy5dQmAk9Qlw4lQIYGEcIwCs+YYKbJ0FKwszHVrOqfLI7oJTyD
         l3akdoCggLsVQ==
Received: by mail-ot1-f45.google.com with SMTP id 107-20020a9d0bf4000000b0051b8be1192fso3286430oth.7
        for <linux-cifs@vger.kernel.org>; Wed, 01 Sep 2021 05:53:56 -0700 (PDT)
X-Gm-Message-State: AOAM5317xPMqlHgeypk+tA/g8diGjvVt7YTXMB0qDPQsRNnvTsStY5th
        W5O8IxPF8xovwjWh+qLT582ubYX7jZex394Whyc=
X-Google-Smtp-Source: ABdhPJwKlW/HQ1Kh2142QOL7nkkewSYph8kEggRY6KUDfEJTiEnbtNET8wRt1SZsyiZwyANe5RJDb5K7h3oOqGytZyY=
X-Received: by 2002:a9d:3e09:: with SMTP id a9mr7574776otd.87.1630500835969;
 Wed, 01 Sep 2021 05:53:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1bc6:0:0:0:0:0 with HTTP; Wed, 1 Sep 2021 05:53:55 -0700 (PDT)
In-Reply-To: <20210823151357.471691-12-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org> <20210823151357.471691-12-brauner@kernel.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 1 Sep 2021 21:53:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8wZK_v4kU3yXtpGP2QsR5jUehojWM-v6jTvfr4gy+J3g@mail.gmail.com>
Message-ID: <CAKYAXd8wZK_v4kU3yXtpGP2QsR5jUehojWM-v6jTvfr4gy+J3g@mail.gmail.com>
Subject: Re: [PATCH 11/11] ksmbd: defer notify_change() call
To:     Christian Brauner <brauner@kernel.org>
Cc:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-08-24 0:13 GMT+09:00, Christian Brauner <brauner@kernel.org>:
> From: Christian Brauner <christian.brauner@ubuntu.com>
>
> When ownership is changed we might in certain scenarios loose the
> ability to alter the inode after we changed ownership. This can e.g.
> happen when we are on an idmapped mount where uid 0 is mapped to uid
> 1000 and uid 1000 is mapped to uid 0.
> A caller with fs*id 1000 will be able to create files as *id 1000 on
> disk. They will also be able to change ownership of files owned by *id 0
> to *id 1000 but they won't be able to change ownership in the other
> direction. This means acl operations following notify_change() would
> fail. Move the notify_change() call after the acls have been updated.
> This guarantees that we don't end up with spurious "hash value diff"
> warnings later on because we managed to change ownership but didn't
> manage to alter acls.
>
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/ksmbd/smbacl.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
> index ef5896297607..8457a3c27c12 100644
> --- a/fs/ksmbd/smbacl.c
> +++ b/fs/ksmbd/smbacl.c
> @@ -1334,25 +1334,27 @@ int set_info_sec(struct ksmbd_conn *conn, struct
> ksmbd_tree_connect *tcon,
>  	newattrs.ia_valid |= ATTR_MODE;
>  	newattrs.ia_mode = (inode->i_mode & ~0777) | (fattr.cf_mode & 0777);
>
> -	inode_lock(inode);
> -	rc = notify_change(user_ns, path->dentry, &newattrs, NULL);
> -	inode_unlock(inode);
> -	if (rc)
> -		goto out;
> -
>  	ksmbd_vfs_remove_acl_xattrs(user_ns, path->dentry);
>  	/* Update posix acls */
>  	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && fattr.cf_dacls) {
>  		rc = set_posix_acl(user_ns, inode,
>  				   ACL_TYPE_ACCESS, fattr.cf_acls);
> +		if (rc < 0)
> +			ksmbd_debug(SMB,
> +				    "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
> +				    rc);
>  		if (S_ISDIR(inode->i_mode) && fattr.cf_dacls)
>  			rc = set_posix_acl(user_ns, inode,
>  					   ACL_TYPE_DEFAULT, fattr.cf_dacls);
> +		if (rc)
> +			ksmbd_debug(SMB,
> +				    "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
> +				    rc);
>  	}
>
>  	/* Check it only calling from SD BUFFER context */
>  	if (type_check && !(le16_to_cpu(pntsd->type) & DACL_PRESENT))
> -		goto out;
> +		goto out_change;
>
>  	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR))
> {
>  		/* Update WinACL in xattr */
> @@ -1361,6 +1363,11 @@ int set_info_sec(struct ksmbd_conn *conn, struct
> ksmbd_tree_connect *tcon,
>  				       path->dentry, pntsd, ntsd_len);
>  	}
>
> +out_change:
> +	inode_lock(inode);
> +	rc = notify_change(user_ns, path->dentry, &newattrs, NULL);
> +	inode_unlock(inode);
Can we move this above the ksmbd_vfs_set_sd_xattr call ? Current
change cause hash diff error from smbtorture test. The hash value
generated by using uid/gid/mode is stored into xattr. Could you please
review the below change ?

https://github.com/namjaejeon/smb3-kernel/commit/b53492ae8f16458dbc95424a5ebd7bb68c661900

Thanks!
> +
>  out:
>  	posix_acl_release(fattr.cf_acls);
>  	posix_acl_release(fattr.cf_dacls);
> --
> 2.30.2
>
>
