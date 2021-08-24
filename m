Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA6BC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 08:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51FB61181
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 08:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhHXIVi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 04:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233692AbhHXIVd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Aug 2021 04:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0058961262
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 08:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629793250;
        bh=szO3stcJugb0KqsHB8TXgaGEqmKiRGbhqWdW8OKDYnQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=mgs3yIZ+H5N90fAmd9PDU4yMu/wAiEaaBSMaRNMk5eCc39jN81cofkEqdDQ2ULgz8
         9/98ezW820+o5+nTlSV8X7Kqn3mzR3cZLB9tcu9blTK8G8mfHKSxIobMpj7Sb1KFwJ
         7Pz5sxmrZb+d03MLuYzjTyeO/PYw0k/040/KCK7F7jZAHHxrmEMZkRRrGrBhF75dJY
         BaVwr4/FGxZKJw3ZO8mlxcWT2A1Oy6Rs8HVRNPQbVnFwpi7usA9ceauSKzRTt4i7sT
         xJWeNd66RlKDNY/n7kYd53ItIOqQHWCjxGhoCvpXpCUVrvWNHzRvp4aF0TeZXQnGpu
         EX4/2+w7V4H9g==
Received: by mail-oo1-f53.google.com with SMTP id z3-20020a4a98430000b029025f4693434bso6249702ooi.3
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 01:20:49 -0700 (PDT)
X-Gm-Message-State: AOAM532bPX/M4T/YzwDCAUAeuJ/zYEjaQzBRFgk1ESI4LQoTOuIo6NQW
        ooxYivfBc/WwQq0NfyrbVQ1IIk6I84HvmyJ0x/s=
X-Google-Smtp-Source: ABdhPJxgOzRR5P5BM1MsB37iz01PqUqgu/kIAGpQ42EjDQvxA3L+e4qa4fho67synEmeaHTNRXS58/FNjbjbssqx4Jo=
X-Received: by 2002:a4a:e792:: with SMTP id x18mr1116312oov.53.1629793249342;
 Tue, 24 Aug 2021 01:20:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1bc6:0:0:0:0:0 with HTTP; Tue, 24 Aug 2021 01:20:48
 -0700 (PDT)
In-Reply-To: <20210823151357.471691-12-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org> <20210823151357.471691-12-brauner@kernel.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 24 Aug 2021 17:20:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_B1uJEh_Y_JRi1o_zucd92-tAvDFjJ8ZW2my2D86-Zsg@mail.gmail.com>
Message-ID: <CAKYAXd_B1uJEh_Y_JRi1o_zucd92-tAvDFjJ8ZW2my2D86-Zsg@mail.gmail.com>
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
You seem to have missed adding braces after adding a debug print.
I will directly update it if you don't mind.

Thanks!
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
> +
>  out:
>  	posix_acl_release(fattr.cf_acls);
>  	posix_acl_release(fattr.cf_dacls);
> --
> 2.30.2
>
>
