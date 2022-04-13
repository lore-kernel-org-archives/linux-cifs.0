Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA2BC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 23:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiDMXb4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 19:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiDMXbz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 19:31:55 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4261B7AF
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 16:29:31 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id o132so1551344vko.11
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 16:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TPzfVGSuSKVWhdl6Otsgf8glon5zwFRRuwiqWl6fmK8=;
        b=jRu45XvJgElOOBNfI2PMvqhHw9ck2v194DJsIRPKWXWiM9HFK4JtV+KDn7X1YCPTHG
         K7Yrr8MagEtPZagUIhgGipyXaswGDaiK32iGhPLmS1sdvXao1Vo0hcFrSIucrY5l00fd
         F5oWSfUUxlVifm1FSuJRPMo+1yKS3HqujqdkEbxzcv5pByyXo8DAYqFtad4OU8fjIWRY
         Cimm7zKxzNOkRo5chfLM1wNgImTP4B3WEJ707nGzOnwWdl4kjnJgdOrgWaelqdteVqXD
         QsQEYjiuI25ObMPoXRSwc/2PnjJvM+Jp8xLUPUq05EVh1kFnPTiJaz1KLlAkgSbPODxu
         voTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TPzfVGSuSKVWhdl6Otsgf8glon5zwFRRuwiqWl6fmK8=;
        b=CRcuUaoKhVs2rg+O1L5Vn2Oio0QVBye3E3RXOfxbuDmHz5rzVkLDeVZUthwUeVBnSj
         Jj8vHF/GliQ0sCSI7eKpbCd5sHT2FnbZHL4bf4vuokm8x+lwrny1FmbzBT/ekvnO63Er
         C1F+wkbev2G9U7aWnO5DX+u8WXhocYhDZGsHsAkjTvjRaPb87PX0A16e2tbWH5xzI0IX
         Hr+vj0egfpdLGYKIP4JaKVMXp/lXoZ6fE0wcGfGQxPQUtm/9f8Y2FiMfjk8McQPe/dNZ
         Y2UKbnAl10KC9CMLve0kEleAs2FW6BftWojC33RzXRP30l2Y8J7ff/03o+Q1RsFLMo5Z
         DPtA==
X-Gm-Message-State: AOAM533VOCJqCQa5EuRXa8oLHtFn33okbKOVmYEGMccQEFrIJ/BT3+wp
        i4B08gq5nhia0znWNRmTjvJIGl8+x1CP97+LJdc=
X-Google-Smtp-Source: ABdhPJxNcgB5BHPWvysIjiyDkBs/jN9vC3u/+WPEwy/2zXSliBOcJZb+Cdvp5zlFUg7cT+lodvtlcRxptE+4fuq6Nd4=
X-Received: by 2002:a1f:26cb:0:b0:345:6c2c:2765 with SMTP id
 m194-20020a1f26cb000000b003456c2c2765mr488974vkm.38.1649892570287; Wed, 13
 Apr 2022 16:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220412225706.5464-1-linkinjeon@kernel.org>
In-Reply-To: <20220412225706.5464-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 14 Apr 2022 08:29:19 +0900
Message-ID: <CANFS6baGf=PvEoSQ5za4zXp3xihJjmV+Cb7BTakRxoZimv1Qyw@mail.gmail.com>
Subject: Re: [PATCH RESEND] ksmbd: remove filename in ksmbd_file
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 4=EC=9B=94 13=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 7:57, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> If the filename is change by underlying rename the server, fp->filename
> and real filename can be different. This patch remove the uses of
> fp->filename in ksmbd and replace it with d_path().
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/misc.c      | 40 +++++++++++++++++++++++++++++++---------
>  fs/ksmbd/misc.h      |  3 ++-
>  fs/ksmbd/oplock.c    | 30 ------------------------------
>  fs/ksmbd/oplock.h    |  2 --
>  fs/ksmbd/smb2pdu.c   | 21 +++++++--------------
>  fs/ksmbd/vfs.c       |  6 ++----
>  fs/ksmbd/vfs_cache.c |  1 -
>  fs/ksmbd/vfs_cache.h |  1 -
>  8 files changed, 42 insertions(+), 62 deletions(-)
>
> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
> index 60e7ac62c917..20d4455a0a99 100644
> --- a/fs/ksmbd/misc.c
> +++ b/fs/ksmbd/misc.c
> @@ -158,19 +158,41 @@ int parse_stream_name(char *filename, char **stream=
_name, int *s_type)
>   * Return : windows path string or error
>   */
>
> -char *convert_to_nt_pathname(char *filename)
> +char *convert_to_nt_pathname(struct ksmbd_share_config *share,
> +                            struct path *path)
>  {
> -       char *ab_pathname;
> +       char *pathname, *ab_pathname, *nt_pathname;
> +       int share_path_len =3D strlen(share->path);

We can use share->path_sz instead of calling strlen.

>
> -       if (strlen(filename) =3D=3D 0)
> -               filename =3D "\\";
> +       pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
> +       if (!pathname)
> +               return ERR_PTR(-EACCES);
>
> -       ab_pathname =3D kstrdup(filename, GFP_KERNEL);
> -       if (!ab_pathname)
> -               return NULL;
> +       ab_pathname =3D d_path(path, pathname, PATH_MAX);
> +       if (IS_ERR(ab_pathname)) {
> +               nt_pathname =3D ERR_PTR(-EACCES);
> +               goto free_pathname;
> +       }
> +
> +       if (strncmp(ab_pathname, share->path, share_path_len)) {
> +               nt_pathname =3D ERR_PTR(-EACCES);
> +               goto free_pathname;
> +       }
> +
> +       nt_pathname =3D kzalloc(strlen(&ab_pathname[share_path_len]) + 1,=
 GFP_KERNEL);
> +       if (!nt_pathname) {
> +               nt_pathname =3D ERR_PTR(-ENOMEM);
> +               goto free_pathname;
> +       }
> +       if (ab_pathname[share_path_len] =3D=3D '\0')
> +               strcpy(nt_pathname, "/");

If ab_pathname and share->path store the same string literal,
the size of nt_pathname is 1 byte. Could this strcpy make
buffer overrun?

> +       strcat(nt_pathname, &ab_pathname[share_path_len]);
> +
> +       ksmbd_conv_path_to_windows(nt_pathname);
>
> -       ksmbd_conv_path_to_windows(ab_pathname);
> -       return ab_pathname;
> +free_pathname:
> +       kfree(pathname);
> +       return nt_pathname;
>  }
>
>  int get_nlink(struct kstat *st)
> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
> index 253366bd0951..aae2a252945f 100644
> --- a/fs/ksmbd/misc.h
> +++ b/fs/ksmbd/misc.h
> @@ -14,7 +14,8 @@ struct ksmbd_file;
>  int match_pattern(const char *str, size_t len, const char *pattern);
>  int ksmbd_validate_filename(char *filename);
>  int parse_stream_name(char *filename, char **stream_name, int *s_type);
> -char *convert_to_nt_pathname(char *filename);
> +char *convert_to_nt_pathname(struct ksmbd_share_config *share,
> +                            struct path *path);
>  int get_nlink(struct kstat *st);
>  void ksmbd_conv_path_to_unix(char *path);
>  void ksmbd_strip_last_slash(char *path);
> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> index 23871b18a429..8b5560574d4c 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -1694,33 +1694,3 @@ struct oplock_info *lookup_lease_in_table(struct k=
smbd_conn *conn,
>         read_unlock(&lease_list_lock);
>         return ret_op;
>  }
> -
> -int smb2_check_durable_oplock(struct ksmbd_file *fp,
> -                             struct lease_ctx_info *lctx, char *name)
> -{
> -       struct oplock_info *opinfo =3D opinfo_get(fp);
> -       int ret =3D 0;
> -
> -       if (opinfo && opinfo->is_lease) {
> -               if (!lctx) {
> -                       pr_err("open does not include lease\n");
> -                       ret =3D -EBADF;
> -                       goto out;
> -               }
> -               if (memcmp(opinfo->o_lease->lease_key, lctx->lease_key,
> -                          SMB2_LEASE_KEY_SIZE)) {
> -                       pr_err("invalid lease key\n");
> -                       ret =3D -EBADF;
> -                       goto out;
> -               }
> -               if (name && strcmp(fp->filename, name)) {
> -                       pr_err("invalid name reconnect %s\n", name);
> -                       ret =3D -EINVAL;
> -                       goto out;
> -               }
> -       }
> -out:
> -       if (opinfo)
> -               opinfo_put(opinfo);
> -       return ret;
> -}
> diff --git a/fs/ksmbd/oplock.h b/fs/ksmbd/oplock.h
> index 0cf7a2b5bbc0..09753448f779 100644
> --- a/fs/ksmbd/oplock.h
> +++ b/fs/ksmbd/oplock.h
> @@ -124,6 +124,4 @@ struct oplock_info *lookup_lease_in_table(struct ksmb=
d_conn *conn,
>  int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *=
ci,
>                         struct lease_ctx_info *lctx);
>  void destroy_lease_table(struct ksmbd_conn *conn);
> -int smb2_check_durable_oplock(struct ksmbd_file *fp,
> -                             struct lease_ctx_info *lctx, char *name);
>  #endif /* __KSMBD_OPLOCK_H */
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 3bf6c56c654c..e38fb68ded21 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2918,7 +2918,6 @@ int smb2_open(struct ksmbd_work *work)
>                 goto err_out;
>         }
>
> -       fp->filename =3D name;
>         fp->cdoption =3D req->CreateDisposition;
>         fp->daccess =3D daccess;
>         fp->saccess =3D req->ShareAccess;
> @@ -3270,14 +3269,13 @@ int smb2_open(struct ksmbd_work *work)
>                 if (!rsp->hdr.Status)
>                         rsp->hdr.Status =3D STATUS_UNEXPECTED_IO_ERROR;
>
> -               if (!fp || !fp->filename)
> -                       kfree(name);
>                 if (fp)
>                         ksmbd_fd_put(work, fp);
>                 smb2_set_err_rsp(work);
>                 ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status)=
;
>         }
>
> +       kfree(name);
>         kfree(lc);
>
>         return 0;
> @@ -3895,8 +3893,6 @@ int smb2_query_dir(struct ksmbd_work *work)
>                 ksmbd_debug(SMB, "Search pattern is %s\n", srch_ptr);
>         }
>
> -       ksmbd_debug(SMB, "Directory name is %s\n", dir_fp->filename);
> -
>         if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
>                 ksmbd_debug(SMB, "Restart directory scan\n");
>                 generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
> @@ -4390,9 +4386,9 @@ static int get_file_all_info(struct ksmbd_work *wor=
k,
>                 return -EACCES;
>         }
>
> -       filename =3D convert_to_nt_pathname(fp->filename);
> -       if (!filename)
> -               return -ENOMEM;
> +       filename =3D convert_to_nt_pathname(work->tcon->share_conf, &fp->=
filp->f_path);
> +       if (IS_ERR(filename))
> +               return PTR_ERR(filename);
>
>         inode =3D file_inode(fp->filp);
>         generic_fillattr(file_mnt_user_ns(fp->filp), inode, &stat);
> @@ -5683,8 +5679,7 @@ static int set_file_allocation_info(struct ksmbd_wo=
rk *work,
>                 size =3D i_size_read(inode);
>                 rc =3D ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
>                 if (rc) {
> -                       pr_err("truncate failed! filename : %s, err %d\n"=
,
> -                              fp->filename, rc);
> +                       pr_err("truncate failed!, err %d\n", rc);
>                         return rc;
>                 }
>                 if (size < alloc_blks * 512)
> @@ -5714,12 +5709,10 @@ static int set_end_of_file_info(struct ksmbd_work=
 *work, struct ksmbd_file *fp,
>          * truncated range.
>          */
>         if (inode->i_sb->s_magic !=3D MSDOS_SUPER_MAGIC) {
> -               ksmbd_debug(SMB, "filename : %s truncated to newsize %lld=
\n",
> -                           fp->filename, newsize);
> +               ksmbd_debug(SMB, "truncated to newsize %lld\n", newsize);
>                 rc =3D ksmbd_vfs_truncate(work, fp, newsize);
>                 if (rc) {
> -                       ksmbd_debug(SMB, "truncate failed! filename : %s =
err %d\n",
> -                                   fp->filename, rc);
> +                       ksmbd_debug(SMB, "truncate failed!, err %d\n", rc=
);
>                         if (rc !=3D -EAGAIN)
>                                 rc =3D -EBADF;
>                         return rc;
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index 9cebb6ba555b..dcdd07c6efff 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -398,8 +398,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ks=
mbd_file *fp, size_t count,
>
>         nbytes =3D kernel_read(filp, rbuf, count, pos);
>         if (nbytes < 0) {
> -               pr_err("smb read failed for (%s), err =3D %zd\n",
> -                      fp->filename, nbytes);
> +               pr_err("smb read failed, err =3D %zd\n", nbytes);
>                 return nbytes;
>         }
>
> @@ -875,8 +874,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
>
>         err =3D vfs_truncate(&filp->f_path, size);
>         if (err)
> -               pr_err("truncate failed for filename : %s err %d\n",
> -                      fp->filename, err);
> +               pr_err("truncate failed, err %d\n", err);
>         return err;
>  }
>
> diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
> index 29c1db66bd0f..0974d2e972b9 100644
> --- a/fs/ksmbd/vfs_cache.c
> +++ b/fs/ksmbd/vfs_cache.c
> @@ -328,7 +328,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table =
*ft, struct ksmbd_file *fp)
>                 kfree(smb_lock);
>         }
>
> -       kfree(fp->filename);
>         if (ksmbd_stream_fd(fp))
>                 kfree(fp->stream.name);
>         kmem_cache_free(filp_cache, fp);
> diff --git a/fs/ksmbd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
> index 36239ce31afd..fcb13413fa8d 100644
> --- a/fs/ksmbd/vfs_cache.h
> +++ b/fs/ksmbd/vfs_cache.h
> @@ -62,7 +62,6 @@ struct ksmbd_inode {
>
>  struct ksmbd_file {
>         struct file                     *filp;
> -       char                            *filename;
>         u64                             persistent_id;
>         u64                             volatile_id;
>
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
