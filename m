Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E08C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Apr 2022 00:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiDNAb7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 20:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiDNAb7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 20:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F321839
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 17:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96E016116C
        for <linux-cifs@vger.kernel.org>; Thu, 14 Apr 2022 00:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00207C385A3
        for <linux-cifs@vger.kernel.org>; Thu, 14 Apr 2022 00:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649896174;
        bh=qhcmrScYOw4wOn3SQCRNAbFwscatZu2zvCx1yaUo9Sk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FfWSuTxJLpdhTrul4KlgwVY8B3c5cL65O3sxOPEpcWtVWO/CMXNL4xBjk3RqSlqFA
         ok8vjXldXiVrDSOlqHt/ruGv+II39wR6VIt5sc2ubTtSyFxH6xWRdq4OITIonKh06L
         88sv+2ZK+JMGljDJcF2vL8Rwc7LIa2D9WmlsyrXnuk49lDbzg3xYBDuCtCSAGgALNJ
         +aALOWhYstfWuFw6E9hW7qCJYux5u3mkPF7uXSYMSC95+UIZYUcJ4FYkz5FFUdLVo/
         jQq97saH0MoS1GBQTZVNphT9gKNSoiILxHteYybXaQvkUXXifGE8w6GHRWMOUcpA1+
         eCkumJzV1MHsg==
Received: by mail-wr1-f43.google.com with SMTP id r13so4793127wrr.9
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 17:29:33 -0700 (PDT)
X-Gm-Message-State: AOAM532UrHdixW3SRgn2KRQpB/7kYHUTDMbj9Z8h8xJZXzY71FZRo+bS
        pta10Q1DQLxDJeOFNdZrDcYIbRqCoeGVOEOKLug=
X-Google-Smtp-Source: ABdhPJz56Amwx2ViX9tlCxtEq+TiT+IiOJVYBrNcQdLWyW6jw1DEsvxgrgwFPSTSBUE+ycXv3HuJbbrFhKaDZs3ZHD8=
X-Received: by 2002:adf:f78a:0:b0:207:a5a4:5043 with SMTP id
 q10-20020adff78a000000b00207a5a45043mr107266wrp.229.1649896172085; Wed, 13
 Apr 2022 17:29:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64aa:0:0:0:0:0 with HTTP; Wed, 13 Apr 2022 17:29:31
 -0700 (PDT)
In-Reply-To: <CANFS6baGf=PvEoSQ5za4zXp3xihJjmV+Cb7BTakRxoZimv1Qyw@mail.gmail.com>
References: <20220412225706.5464-1-linkinjeon@kernel.org> <CANFS6baGf=PvEoSQ5za4zXp3xihJjmV+Cb7BTakRxoZimv1Qyw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 14 Apr 2022 09:29:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Artg1MvyXJq+m0nNkUyeRE+Tb-YteU02QZW6w=80pzQ@mail.gmail.com>
Message-ID: <CAKYAXd9Artg1MvyXJq+m0nNkUyeRE+Tb-YteU02QZW6w=80pzQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] ksmbd: remove filename in ksmbd_file
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-04-14 8:29 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 4=EC=9B=94 13=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 7:57,=
 Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> If the filename is change by underlying rename the server, fp->filename
>> and real filename can be different. This patch remove the uses of
>> fp->filename in ksmbd and replace it with d_path().
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/misc.c      | 40 +++++++++++++++++++++++++++++++---------
>>  fs/ksmbd/misc.h      |  3 ++-
>>  fs/ksmbd/oplock.c    | 30 ------------------------------
>>  fs/ksmbd/oplock.h    |  2 --
>>  fs/ksmbd/smb2pdu.c   | 21 +++++++--------------
>>  fs/ksmbd/vfs.c       |  6 ++----
>>  fs/ksmbd/vfs_cache.c |  1 -
>>  fs/ksmbd/vfs_cache.h |  1 -
>>  8 files changed, 42 insertions(+), 62 deletions(-)
>>
>> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
>> index 60e7ac62c917..20d4455a0a99 100644
>> --- a/fs/ksmbd/misc.c
>> +++ b/fs/ksmbd/misc.c
>> @@ -158,19 +158,41 @@ int parse_stream_name(char *filename, char
>> **stream_name, int *s_type)
>>   * Return : windows path string or error
>>   */
>>
>> -char *convert_to_nt_pathname(char *filename)
>> +char *convert_to_nt_pathname(struct ksmbd_share_config *share,
>> +                            struct path *path)
>>  {
>> -       char *ab_pathname;
>> +       char *pathname, *ab_pathname, *nt_pathname;
>> +       int share_path_len =3D strlen(share->path);
>
Hi Hyunchul,
> We can use share->path_sz instead of calling strlen.
Okay.
>
>>
>> -       if (strlen(filename) =3D=3D 0)
>> -               filename =3D "\\";
>> +       pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
>> +       if (!pathname)
>> +               return ERR_PTR(-EACCES);
>>
>> -       ab_pathname =3D kstrdup(filename, GFP_KERNEL);
>> -       if (!ab_pathname)
>> -               return NULL;
>> +       ab_pathname =3D d_path(path, pathname, PATH_MAX);
>> +       if (IS_ERR(ab_pathname)) {
>> +               nt_pathname =3D ERR_PTR(-EACCES);
>> +               goto free_pathname;
>> +       }
>> +
>> +       if (strncmp(ab_pathname, share->path, share_path_len)) {
>> +               nt_pathname =3D ERR_PTR(-EACCES);
>> +               goto free_pathname;
>> +       }
>> +
>> +       nt_pathname =3D kzalloc(strlen(&ab_pathname[share_path_len]) + 1=
,
>> GFP_KERNEL);
>> +       if (!nt_pathname) {
>> +               nt_pathname =3D ERR_PTR(-ENOMEM);
>> +               goto free_pathname;
>> +       }
>> +       if (ab_pathname[share_path_len] =3D=3D '\0')
>> +               strcpy(nt_pathname, "/");
>
> If ab_pathname and share->path store the same string literal,
> the size of nt_pathname is 1 byte. Could this strcpy make
> buffer overrun?
Will fix it.
Thanks:)
>
>> +       strcat(nt_pathname, &ab_pathname[share_path_len]);
>> +
>> +       ksmbd_conv_path_to_windows(nt_pathname);
>>
>> -       ksmbd_conv_path_to_windows(ab_pathname);
>> -       return ab_pathname;
>> +free_pathname:
>> +       kfree(pathname);
>> +       return nt_pathname;
>>  }
>>
>>  int get_nlink(struct kstat *st)
>> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
>> index 253366bd0951..aae2a252945f 100644
>> --- a/fs/ksmbd/misc.h
>> +++ b/fs/ksmbd/misc.h
>> @@ -14,7 +14,8 @@ struct ksmbd_file;
>>  int match_pattern(const char *str, size_t len, const char *pattern);
>>  int ksmbd_validate_filename(char *filename);
>>  int parse_stream_name(char *filename, char **stream_name, int *s_type);
>> -char *convert_to_nt_pathname(char *filename);
>> +char *convert_to_nt_pathname(struct ksmbd_share_config *share,
>> +                            struct path *path);
>>  int get_nlink(struct kstat *st);
>>  void ksmbd_conv_path_to_unix(char *path);
>>  void ksmbd_strip_last_slash(char *path);
>> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
>> index 23871b18a429..8b5560574d4c 100644
>> --- a/fs/ksmbd/oplock.c
>> +++ b/fs/ksmbd/oplock.c
>> @@ -1694,33 +1694,3 @@ struct oplock_info *lookup_lease_in_table(struct
>> ksmbd_conn *conn,
>>         read_unlock(&lease_list_lock);
>>         return ret_op;
>>  }
>> -
>> -int smb2_check_durable_oplock(struct ksmbd_file *fp,
>> -                             struct lease_ctx_info *lctx, char *name)
>> -{
>> -       struct oplock_info *opinfo =3D opinfo_get(fp);
>> -       int ret =3D 0;
>> -
>> -       if (opinfo && opinfo->is_lease) {
>> -               if (!lctx) {
>> -                       pr_err("open does not include lease\n");
>> -                       ret =3D -EBADF;
>> -                       goto out;
>> -               }
>> -               if (memcmp(opinfo->o_lease->lease_key, lctx->lease_key,
>> -                          SMB2_LEASE_KEY_SIZE)) {
>> -                       pr_err("invalid lease key\n");
>> -                       ret =3D -EBADF;
>> -                       goto out;
>> -               }
>> -               if (name && strcmp(fp->filename, name)) {
>> -                       pr_err("invalid name reconnect %s\n", name);
>> -                       ret =3D -EINVAL;
>> -                       goto out;
>> -               }
>> -       }
>> -out:
>> -       if (opinfo)
>> -               opinfo_put(opinfo);
>> -       return ret;
>> -}
>> diff --git a/fs/ksmbd/oplock.h b/fs/ksmbd/oplock.h
>> index 0cf7a2b5bbc0..09753448f779 100644
>> --- a/fs/ksmbd/oplock.h
>> +++ b/fs/ksmbd/oplock.h
>> @@ -124,6 +124,4 @@ struct oplock_info *lookup_lease_in_table(struct
>> ksmbd_conn *conn,
>>  int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode
>> *ci,
>>                         struct lease_ctx_info *lctx);
>>  void destroy_lease_table(struct ksmbd_conn *conn);
>> -int smb2_check_durable_oplock(struct ksmbd_file *fp,
>> -                             struct lease_ctx_info *lctx, char *name);
>>  #endif /* __KSMBD_OPLOCK_H */
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 3bf6c56c654c..e38fb68ded21 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -2918,7 +2918,6 @@ int smb2_open(struct ksmbd_work *work)
>>                 goto err_out;
>>         }
>>
>> -       fp->filename =3D name;
>>         fp->cdoption =3D req->CreateDisposition;
>>         fp->daccess =3D daccess;
>>         fp->saccess =3D req->ShareAccess;
>> @@ -3270,14 +3269,13 @@ int smb2_open(struct ksmbd_work *work)
>>                 if (!rsp->hdr.Status)
>>                         rsp->hdr.Status =3D STATUS_UNEXPECTED_IO_ERROR;
>>
>> -               if (!fp || !fp->filename)
>> -                       kfree(name);
>>                 if (fp)
>>                         ksmbd_fd_put(work, fp);
>>                 smb2_set_err_rsp(work);
>>                 ksmbd_debug(SMB, "Error response: %x\n",
>> rsp->hdr.Status);
>>         }
>>
>> +       kfree(name);
>>         kfree(lc);
>>
>>         return 0;
>> @@ -3895,8 +3893,6 @@ int smb2_query_dir(struct ksmbd_work *work)
>>                 ksmbd_debug(SMB, "Search pattern is %s\n", srch_ptr);
>>         }
>>
>> -       ksmbd_debug(SMB, "Directory name is %s\n", dir_fp->filename);
>> -
>>         if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
>>                 ksmbd_debug(SMB, "Restart directory scan\n");
>>                 generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
>> @@ -4390,9 +4386,9 @@ static int get_file_all_info(struct ksmbd_work
>> *work,
>>                 return -EACCES;
>>         }
>>
>> -       filename =3D convert_to_nt_pathname(fp->filename);
>> -       if (!filename)
>> -               return -ENOMEM;
>> +       filename =3D convert_to_nt_pathname(work->tcon->share_conf,
>> &fp->filp->f_path);
>> +       if (IS_ERR(filename))
>> +               return PTR_ERR(filename);
>>
>>         inode =3D file_inode(fp->filp);
>>         generic_fillattr(file_mnt_user_ns(fp->filp), inode, &stat);
>> @@ -5683,8 +5679,7 @@ static int set_file_allocation_info(struct
>> ksmbd_work *work,
>>                 size =3D i_size_read(inode);
>>                 rc =3D ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
>>                 if (rc) {
>> -                       pr_err("truncate failed! filename : %s, err
>> %d\n",
>> -                              fp->filename, rc);
>> +                       pr_err("truncate failed!, err %d\n", rc);
>>                         return rc;
>>                 }
>>                 if (size < alloc_blks * 512)
>> @@ -5714,12 +5709,10 @@ static int set_end_of_file_info(struct ksmbd_wor=
k
>> *work, struct ksmbd_file *fp,
>>          * truncated range.
>>          */
>>         if (inode->i_sb->s_magic !=3D MSDOS_SUPER_MAGIC) {
>> -               ksmbd_debug(SMB, "filename : %s truncated to newsize
>> %lld\n",
>> -                           fp->filename, newsize);
>> +               ksmbd_debug(SMB, "truncated to newsize %lld\n", newsize)=
;
>>                 rc =3D ksmbd_vfs_truncate(work, fp, newsize);
>>                 if (rc) {
>> -                       ksmbd_debug(SMB, "truncate failed! filename : %s
>> err %d\n",
>> -                                   fp->filename, rc);
>> +                       ksmbd_debug(SMB, "truncate failed!, err %d\n",
>> rc);
>>                         if (rc !=3D -EAGAIN)
>>                                 rc =3D -EBADF;
>>                         return rc;
>> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
>> index 9cebb6ba555b..dcdd07c6efff 100644
>> --- a/fs/ksmbd/vfs.c
>> +++ b/fs/ksmbd/vfs.c
>> @@ -398,8 +398,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct
>> ksmbd_file *fp, size_t count,
>>
>>         nbytes =3D kernel_read(filp, rbuf, count, pos);
>>         if (nbytes < 0) {
>> -               pr_err("smb read failed for (%s), err =3D %zd\n",
>> -                      fp->filename, nbytes);
>> +               pr_err("smb read failed, err =3D %zd\n", nbytes);
>>                 return nbytes;
>>         }
>>
>> @@ -875,8 +874,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
>>
>>         err =3D vfs_truncate(&filp->f_path, size);
>>         if (err)
>> -               pr_err("truncate failed for filename : %s err %d\n",
>> -                      fp->filename, err);
>> +               pr_err("truncate failed, err %d\n", err);
>>         return err;
>>  }
>>
>> diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
>> index 29c1db66bd0f..0974d2e972b9 100644
>> --- a/fs/ksmbd/vfs_cache.c
>> +++ b/fs/ksmbd/vfs_cache.c
>> @@ -328,7 +328,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table
>> *ft, struct ksmbd_file *fp)
>>                 kfree(smb_lock);
>>         }
>>
>> -       kfree(fp->filename);
>>         if (ksmbd_stream_fd(fp))
>>                 kfree(fp->stream.name);
>>         kmem_cache_free(filp_cache, fp);
>> diff --git a/fs/ksmbd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
>> index 36239ce31afd..fcb13413fa8d 100644
>> --- a/fs/ksmbd/vfs_cache.h
>> +++ b/fs/ksmbd/vfs_cache.h
>> @@ -62,7 +62,6 @@ struct ksmbd_inode {
>>
>>  struct ksmbd_file {
>>         struct file                     *filp;
>> -       char                            *filename;
>>         u64                             persistent_id;
>>         u64                             volatile_id;
>>
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
