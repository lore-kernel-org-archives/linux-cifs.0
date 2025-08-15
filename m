Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA33C257833;
	Fri, 15 Aug 2025 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755277331; cv=none; b=fuQnCqvlqfbzKdSobvAiAVNLI+ha/VmuweUTW3Avd0bUparC2/x2HnZx9XF2NCPmOABpFBwNVUFtmAEFSi1oNbUtNO3t3J74l5QZfPauuHaYGqY3psEqkYy/JuHEYDH+4uCJcMhp4bzoPxX19jWAgiZjAIgW53gueP4sigXf3xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755277331; c=relaxed/simple;
	bh=BipuFkoKgGo31zR1MLuypoUC36v9kjYEC1MM6avSIOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=knnCP7xtmhFyC/c6VQg5bpKi63dpbeIWAmIaAUnD6Ujm0vv4CWOe17g3TIjm9nSVb3zL0167nDd1JqFPjAV80G7sGN8JrDR2jHbWClptkS5dypdsFTlnkLi5avuAdBXJp8kSZEQQPoR2XZjrvsyfa9xOAqphYpNnFC/DqilT9vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=afciDmqn; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="afciDmqn"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-53b173aa4a9so1501259e0c.1;
        Fri, 15 Aug 2025 10:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755277329; x=1755882129; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4u0clvu5HYUEqaa5HSaehD/ab3r+gohJKUE98+9Ll8=;
        b=afciDmqno2yh6XAeypWo3j3JXp8RTMqYceZA81D2pm412AFrzLahflgrVRPOTk5315
         1M1fFf8MAwFA6K0uC7qfGyFbs/C3o8s1dGhURJ1tVP53LUtRSxYaQAURK3+JWiZtSyH2
         E4lx3s05t6bL771LXXWPYcJs1W99EwzcZZTiUa/A2dWELKVQdWI6nsBZRbjmFFXG6KIB
         FMN0rz0MxLLk+VBhKarZpReY0jnoZtseW19KPn5ESCf+iZDSzzch8iAxujTwwKebhXKV
         68WAtEoLJDIIzAMMdGv8RD8E5lhaAuV83wQF4d48TYodUqzfqbZS/pKyq2fnugjtVHd/
         8fag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755277329; x=1755882129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F4u0clvu5HYUEqaa5HSaehD/ab3r+gohJKUE98+9Ll8=;
        b=mZza4xCitSID42j6jU6F5ioLd/T7l9EVI2WtXC3NT+EhBiD2AY+EOdEaOHsCQ7f859
         nyJyvoCnpWeBuEStjkw5QTqy0pR9p7DSYQdqJRgI6qKgjgPI0s6juEQ8SjuLDIHpq53S
         L2pM6G1Z86N2kE1QglgN6+I0I6Fy0b+XgJJfAjb7QXWgyd7XHrUO/INzTLawvh/iuO17
         xhToKL63ExueDyDgau3FeS47E6bVmHwl5oz7oqrvv7ZAWDfcwZtoGRWpztrsmUR2mKMk
         AGv7iTn+2LLIEdVM3rFmShHvw7QiNs96JMfvT8eLhXX2kEWko/V0z0B1OoqKOj1eMlDO
         bI1w==
X-Forwarded-Encrypted: i=1; AJvYcCWvUFxTIEL+SvIzPAFUJhlxQ3ay3rjhiYxK4F30TuPNU5YM+iWs/8cSyATJLRkib9BfbC4NcsEF1Y/M@vger.kernel.org, AJvYcCXx/XH+gHPRqCYmUxAPpflBxWH6VAtoDjBGkfmQigEKVMCeKdBxxTzgSCRsrEcIvjo8MqD3D1o+RB/YkPUg@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7VMxgLfafppXOp6MfydVomNPAKcZtMiBfUkGW+paS1Eg4dPO6
	+54ahBd05gj3F56g6jCiCjR/przHmJyaovg4IxpJgchcnZugdvJOnuePLp7s9z4ecK2ofXPZ3UO
	nvXiV3m7CldT743MgAsQQLyO9vFZqPW233g==
X-Gm-Gg: ASbGncscvv/k9XPS1G8cFaTVhHX81Rne/EatDenTsu6Hlh9JsIlEIIKH33Ryeb5eKZw
	KWTFs3r4KfMi32GbCrV7/hSwDbAn4CWiy5S3Gb7c9wCOkBoxfqPo+Rt+ht6nQWgreP2sT+zkStM
	sk1EJCp0tL4YZ1aOGcqxC+LO8j6KfqPRhHLiE4CDdHy8ra8wH5rqoOrVG+D7yGEz+I9Q4q6YA6F
	5DtCMtKJTzle9FoGkkZyb1EzURQZ9klAc3IzguiIUrwzr/oiP2J
X-Google-Smtp-Source: AGHT+IH7zyqF4DjLzhxHO8J1r+oyoEABFTZuedSXv9mxHvnHyfBwwSvxrm2gp0KMz599D3fBXb9mL/shRlkLr6nrIH4=
X-Received: by 2002:a05:6122:c8c:b0:539:af99:901f with SMTP id
 71dfb90a1353d-53b2b85f08emr1140664e0c.9.1755277307090; Fri, 15 Aug 2025
 10:01:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>
In-Reply-To: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 15 Aug 2025 12:01:34 -0500
X-Gm-Features: Ac12FXyL4e3Hskg1TPOGR01x0Wwv9U3Fbgt06X7mL4GYE7p-02hbgIxnp0zpWkE
Message-ID: <CAH2r5msLMNdqdo6EBuTvrQ0hwrqSRC-LSZuN2WpwV+PkDwsCOw@mail.gmail.com>
Subject: Re: [PATCH v4] smb: client: Fix mount deadlock by avoiding super
 block iteration in DFS reconnect
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to cifs-2.6.git for-next pending more testing and any additional
review comments

On Thu, Aug 14, 2025 at 10:24=E2=80=AFPM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
> An AA deadlock occurs when network interruption during mount triggers
> DFS reconnection logic that calls iterate_supers_type().
>
> The detailed call process is as follows:
>
>       mount.cifs
> -------------------------
> path_mount
>   do_new_mount
>     vfs_get_tree
>       smb3_get_tree
>         cifs_smb3_do_mount
>           sget
>             alloc_super
>               down_write_nested(&s->s_umount, ..);  // Hold lock
>           cifs_root_iget
>             cifs_get_inode_info
>               smb2_query_path_info
>                 smb2_compound_op
>                   SMB2_open_init
>                     smb2_plain_req_init
>                       smb2_reconnect           // Trigger reconnection
>                         cifs_tree_connect
>                           cifs_get_dfs_tcon_super
>                             __cifs_get_super
>                               iterate_supers_type
>                                 down_read(&sb->s_umount); // Deadlock
>     do_new_mount_fc
>       up_write(&sb->s_umount);  // Release lock
>
> During mount phase, if reconnection is triggered, the foreground mount
> process may enter smb2_reconnect prior to the reconnect worker being
> scheduled, leading to a deadlock when subsequent DFS tree connect
> attempts reacquire the s_umount lock.
>
> The essential condition for triggering the issue is that the API
> iterate_supers_type() reacquires the s_umount lock. Therefore, one
> possible solution is to avoid using iterate_supers_type() and instead
> directly access the superblock through internal data structures.
>
> This patch fixes the problem by:
> - Add vfs_sb back-pointer to cifs_sb_info for direct access
> - Protect list traversal with existing tcon->sb_list_lock
> - Use atomic operations to safely manage super block references
> - Remove complex callback-based iteration in favor of simple loop
> - Rename cifs_put_tcp_super() to cifs_put_super() to avoid confusion
>
> Fixes: 3ae872de4107 ("smb: client: fix shared DFS root mounts with differ=
ent prefixes")
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>
> V4:
>  - Perform a null pointer check on the return value of cifs_get_dfs_tcon_=
super()
>    to prevent NULL ptr dereference with DFS multiuser mount
>
> V3:
>  - Adjust the trace diagram for the super_lock_shared() section to align =
with
>    the latest mainline call flow.
> V2:
>  - Adjust the trace diagram in the commit message to indicate when the lo=
ck
>    is released
>
>  fs/smb/client/cifs_fs_sb.h |  1 +
>  fs/smb/client/cifsfs.c     |  1 +
>  fs/smb/client/cifsproto.h  |  2 +-
>  fs/smb/client/dfs.c        |  4 +-
>  fs/smb/client/misc.c       | 84 ++++++++++++++------------------------
>  5 files changed, 35 insertions(+), 57 deletions(-)
>
> diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
> index 5e8d163cb5f8..8c513e4c0efe 100644
> --- a/fs/smb/client/cifs_fs_sb.h
> +++ b/fs/smb/client/cifs_fs_sb.h
> @@ -49,10 +49,11 @@
>
>  struct cifs_sb_info {
>         struct rb_root tlink_tree;
>         struct list_head tcon_sb_link;
>         spinlock_t tlink_tree_lock;
> +       struct super_block *vfs_sb;
>         struct tcon_link *master_tlink;
>         struct nls_table *local_nls;
>         struct smb3_fs_context *ctx;
>         atomic_t active;
>         unsigned int mnt_cifs_flags;
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 3bd85ab2deb1..383f651eb43f 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -939,10 +939,11 @@ cifs_get_root(struct smb3_fs_context *ctx, struct s=
uper_block *sb)
>
>  static int cifs_set_super(struct super_block *sb, void *data)
>  {
>         struct cifs_mnt_data *mnt_data =3D data;
>         sb->s_fs_info =3D mnt_data->cifs_sb;
> +       mnt_data->cifs_sb->vfs_sb =3D sb;
>         return set_anon_super(sb, NULL);
>  }
>
>  struct dentry *
>  cifs_smb3_do_mount(struct file_system_type *fs_type,
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index c34c533b2efa..6415bb961c1e 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -678,11 +678,11 @@ int copy_path_name(char *dst, const char *src);
>  int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_=
iov,
>                                int resp_buftype,
>                                struct cifs_search_info *srch_inf);
>
>  struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon);
> -void cifs_put_tcp_super(struct super_block *sb);
> +void cifs_put_super(struct super_block *sb);
>  int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix=
);
>  char *extract_hostname(const char *unc);
>  char *extract_sharename(const char *unc);
>  int parse_reparse_point(struct reparse_data_buffer *buf,
>                         u32 plen, struct cifs_sb_info *cifs_sb,
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index f65a8a90ba27..37d83aade843 100644
> --- a/fs/smb/client/dfs.c
> +++ b/fs/smb/client/dfs.c
> @@ -429,11 +429,11 @@ int cifs_tree_connect(const unsigned int xid, struc=
t cifs_tcon *tcon)
>                                        tcon, tcon->ses->local_nls);
>                 goto out;
>         }
>
>         sb =3D cifs_get_dfs_tcon_super(tcon);
> -       if (!IS_ERR(sb))
> +       if (!IS_ERR_OR_NULL(sb))
>                 cifs_sb =3D CIFS_SB(sb);
>
>         /* Tree connect to last share in @tcon->tree_name if no DFS refer=
ral */
>         if (!server->leaf_fullpath ||
>             dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
> @@ -446,11 +446,11 @@ int cifs_tree_connect(const unsigned int xid, struc=
t cifs_tcon *tcon)
>                                      &tl);
>         free_dfs_info_param(&ref);
>
>  out:
>         kfree(tree);
> -       cifs_put_tcp_super(sb);
> +       cifs_put_super(sb);
>
>         if (rc) {
>                 spin_lock(&tcon->tc_lock);
>                 if (tcon->status =3D=3D TID_IN_TCON)
>                         tcon->status =3D TID_NEED_TCON;
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index da23cc12a52c..3b6920a52daa 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -1108,84 +1108,60 @@ int copy_path_name(char *dst, const char *src)
>         /* we count the trailing nul */
>         name_len++;
>         return name_len;
>  }
>
> -struct super_cb_data {
> -       void *data;
> -       struct super_block *sb;
> -};
> -
> -static void tcon_super_cb(struct super_block *sb, void *arg)
> +static struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
>  {
> -       struct super_cb_data *sd =3D arg;
> +       struct super_block *sb;
>         struct cifs_sb_info *cifs_sb;
> -       struct cifs_tcon *t1 =3D sd->data, *t2;
>
> -       if (sd->sb)
> -               return;
> +       if (!tcon)
> +               return NULL;
>
> -       cifs_sb =3D CIFS_SB(sb);
> -       t2 =3D cifs_sb_master_tcon(cifs_sb);
> -
> -       spin_lock(&t2->tc_lock);
> -       if ((t1->ses =3D=3D t2->ses ||
> -            t1->ses->dfs_root_ses =3D=3D t2->ses->dfs_root_ses) &&
> -           t1->ses->server =3D=3D t2->ses->server &&
> -           t2->origin_fullpath &&
> -           dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpa=
th))
> -               sd->sb =3D sb;
> -       spin_unlock(&t2->tc_lock);
> -}
> +       spin_lock(&tcon->sb_list_lock);
> +       list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
>
> -static struct super_block *__cifs_get_super(void (*f)(struct super_block=
 *, void *),
> -                                           void *data)
> -{
> -       struct super_cb_data sd =3D {
> -               .data =3D data,
> -               .sb =3D NULL,
> -       };
> -       struct file_system_type **fs_type =3D (struct file_system_type *[=
]) {
> -               &cifs_fs_type, &smb3_fs_type, NULL,
> -       };
> -
> -       for (; *fs_type; fs_type++) {
> -               iterate_supers_type(*fs_type, f, &sd);
> -               if (sd.sb) {
> -                       /*
> -                        * Grab an active reference in order to prevent a=
utomounts (DFS links)
> -                        * of expiring and then freeing up our cifs super=
block pointer while
> -                        * we're doing failover.
> -                        */
> -                       cifs_sb_active(sd.sb);
> -                       return sd.sb;
> -               }
> +               if (!cifs_sb->vfs_sb)
> +                       continue;
> +
> +               sb =3D cifs_sb->vfs_sb;
> +
> +               /* Safely increment s_active only if it's not zero.
> +                *
> +                * When s_active =3D=3D 0, the super block is being deact=
ivated
> +                * and should not be used. This prevents UAF scenarios
> +                * where we might grab a reference to a super block that'=
s
> +                * in the middle of destruction.
> +                */
> +               if (!atomic_add_unless(&sb->s_active, 1, 0))
> +                       continue;
> +
> +               spin_unlock(&tcon->sb_list_lock);
> +               return sb;
>         }
> -       pr_warn_once("%s: could not find dfs superblock\n", __func__);
> -       return ERR_PTR(-EINVAL);
> -}
> +       spin_unlock(&tcon->sb_list_lock);
>
> -static void __cifs_put_super(struct super_block *sb)
> -{
> -       if (!IS_ERR_OR_NULL(sb))
> -               cifs_sb_deactive(sb);
> +       return NULL;
>  }
>
>  struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon)
>  {
>         spin_lock(&tcon->tc_lock);
>         if (!tcon->origin_fullpath) {
>                 spin_unlock(&tcon->tc_lock);
>                 return ERR_PTR(-ENOENT);
>         }
>         spin_unlock(&tcon->tc_lock);
> -       return __cifs_get_super(tcon_super_cb, tcon);
> +
> +       return cifs_get_tcon_super(tcon);
>  }
>
> -void cifs_put_tcp_super(struct super_block *sb)
> +void cifs_put_super(struct super_block *sb)
>  {
> -       __cifs_put_super(sb);
> +       if (!IS_ERR_OR_NULL(sb))
> +               deactivate_super(sb);
>  }
>
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  int match_target_ip(struct TCP_Server_Info *server,
>                     const char *host, size_t hostlen,
> --
> 2.39.2
>
>


--=20
Thanks,

Steve
