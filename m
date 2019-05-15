Return-Path: <SRS0=u+N2=TP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6472CC04AA7
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 04:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2CD20862
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 04:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOKAo1cJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfEOERF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 May 2019 00:17:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36996 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEOERF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 May 2019 00:17:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id e6so666409pgc.4
        for <linux-cifs@vger.kernel.org>; Tue, 14 May 2019 21:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DodO9Mg8u8/1AkbHPj2F53K5XyU7kSkUFEb0mOGWoOg=;
        b=eOKAo1cJYY+sFWymDiwsv/0V+Ci/O2pST7jo802f1GUnWN7P+dGySviMq97mWhkLow
         JVm8Sy9W0RrBTbP5aHOQ3zYf0PpLNQ/m27jS9l9p7vzBg9zQPt6xoD1YzFvHaBOIGKcj
         Yu0JeYoOvIh+P2LOxvI1WqFzG+/c3lP3ilLd8xJMVROHyfGcqLMlQ7J2IOslPIWesj2Z
         h7fLE1ahjJv75s++4cU1lgfu0crIAWA8XVwZfyGffcanL7Qtp1IvmhbvrijUKulKxjL8
         pfzNwyHNcGMPw2hFus5MKT6hnWcJFFj4rG+msIy15EI9rneubVwDMHhIXQlwSb7ulW/D
         HkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DodO9Mg8u8/1AkbHPj2F53K5XyU7kSkUFEb0mOGWoOg=;
        b=laBblbnkXiloGa7jPr56doXSiva1zKgWKAKRxyMXOdwjtgWfLvY7abt0BdJvIE9tWB
         6UTnhaESTk6qxYVpL+kHUB700OdmW824M4xufnN1/3xMtAC5bf5pLaMW0XpueHUEbCUP
         UAbckZyUtOlRWMCOKXpPO/dzWH6uqn9D6Y+BNMvGXGiVrEGJLcoqI/tUaFuG7hEZUdoC
         fdV23bEN/LGFfksCVxm3kBVK6K4INSowaDB1WwlvjD5LA9W/UmzIZrQVDWvwroM1cK9Y
         DAL9CdO1kyEdCoq2nHmTde2VIP7btAs/8CjkkAURrucUvmYkRGIIVBO7wS5/qOqVeX0T
         Ofcg==
X-Gm-Message-State: APjAAAWFBDbzJq7qAOs+pbE0koxYRyd4hblqFjqtF/P/zk6sT1Dx5hoV
        iFzS3rUSIupSkHf+wBK1hsdCQ+OTCtX5fAm27zhzig==
X-Google-Smtp-Source: APXvYqzLdLeoUE/tXifjF38Mtz+d3GcJ/Q0cWrEkV9MattjvKEnJOwiEm7LVKt6HIg9PYpt2ED12fwuWUEkeTku2Spw=
X-Received: by 2002:a63:f806:: with SMTP id n6mr41837772pgh.242.1557893824730;
 Tue, 14 May 2019 21:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190514211702.19269-1-lsahlber@redhat.com> <20190514211702.19269-2-lsahlber@redhat.com>
In-Reply-To: <20190514211702.19269-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 May 2019 23:16:53 -0500
Message-ID: <CAH2r5mtTqkCuqyScdEk8mk9k-YLX3hsSBXOE-wPyr3u0uotkYg@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for SEEK_DATA and SEEK_HOLE
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, May 14, 2019 at 4:33 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c   |  9 ++++++
>  fs/cifs/cifsglob.h |  2 ++
>  fs/cifs/smb2ops.c  | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 99 insertions(+)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index b1a5fcfa3ce1..75fef9fb78d8 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -878,6 +878,9 @@ static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>
>  static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
>  {
> +       struct cifsFileInfo *cfile = file->private_data;
> +       struct cifs_tcon *tcon;
> +
>         /*
>          * whence == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
>          * the cached file length
> @@ -909,6 +912,12 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
>                 if (rc < 0)
>                         return (loff_t)rc;
>         }
> +       if (cfile && cfile->tlink) {
> +               tcon = tlink_tcon(cfile->tlink);
> +               if (tcon->ses->server->ops->llseek)
> +                       return tcon->ses->server->ops->llseek(file, tcon,
> +                                                             offset, whence);
> +       }
>         return generic_file_llseek(file, offset, whence);
>  }
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 33c251b408aa..334ff5f9c3f3 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -497,6 +497,8 @@ struct smb_version_operations {
>         /* version specific fiemap implementation */
>         int (*fiemap)(struct cifs_tcon *tcon, struct cifsFileInfo *,
>                       struct fiemap_extent_info *, u64, u64);
> +       /* version specific llseek implementation */
> +       loff_t (*llseek)(struct file *, struct cifs_tcon *, loff_t, int);
>  };
>
>  struct smb_version_values {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 542b50c0b292..e921e6511728 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2922,6 +2922,90 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offset, int whence)
> +{
> +       struct cifsFileInfo *wrcfile, *cfile = file->private_data;
> +       struct cifsInodeInfo *cifsi;
> +       struct inode *inode;
> +       int rc = 0;
> +       struct file_allocated_range_buffer in_data, *out_data = NULL;
> +       u32 out_data_len;
> +       unsigned int xid;
> +
> +       if (whence != SEEK_HOLE && whence != SEEK_DATA)
> +               return generic_file_llseek(file, offset, whence);
> +
> +       inode = d_inode(cfile->dentry);
> +       cifsi = CIFS_I(inode);
> +
> +       if (offset < 0 || offset >= i_size_read(inode))
> +               return -ENXIO;
> +
> +       xid = get_xid();
> +       /*
> +        * We need to be sure that all dirty pages are written as they
> +        * might fill holes on the server.
> +        * Note that we also MUST flush any written pages since at least
> +        * some servers (Windows2016) will not reflect recent writes in
> +        * QUERY_ALLOCATED_RANGES until SMB2_flush is called.
> +        */
> +       wrcfile = find_writable_file(cifsi, false);
> +       if (wrcfile) {
> +               filemap_write_and_wait(inode->i_mapping);
> +               smb2_flush_file(xid, tcon, &wrcfile->fid);
> +               cifsFileInfo_put(wrcfile);
> +       }
> +
> +       if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)) {
> +               if (whence == SEEK_HOLE)
> +                       offset = i_size_read(inode);
> +               goto lseek_exit;
> +       }
> +
> +       in_data.file_offset = cpu_to_le64(offset);
> +       in_data.length = cpu_to_le64(i_size_read(inode));
> +
> +       rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
> +                       cfile->fid.volatile_fid,
> +                       FSCTL_QUERY_ALLOCATED_RANGES, true,
> +                       (char *)&in_data, sizeof(in_data),
> +                       sizeof(struct file_allocated_range_buffer),
> +                       (char **)&out_data, &out_data_len);
> +       if (rc == -E2BIG)
> +               rc = 0;
> +       if (rc)
> +               goto lseek_exit;
> +
> +       if (whence == SEEK_HOLE && out_data_len == 0)
> +               goto lseek_exit;
> +
> +       if (whence == SEEK_DATA && out_data_len == 0) {
> +               rc = -ENXIO;
> +               goto lseek_exit;
> +       }
> +
> +       if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
> +               rc = -EINVAL;
> +               goto lseek_exit;
> +       }
> +       if (whence == SEEK_DATA) {
> +               offset = le64_to_cpu(out_data->file_offset);
> +               goto lseek_exit;
> +       }
> +       if (offset < le64_to_cpu(out_data->file_offset))
> +               goto lseek_exit;
> +
> +       offset = le64_to_cpu(out_data->file_offset) + le64_to_cpu(out_data->length);
> +
> + lseek_exit:
> +       free_xid(xid);
> +       kfree(out_data);
> +       if (!rc)
> +               return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
> +       else
> +               return rc;
> +}
> +
>  static int smb3_fiemap(struct cifs_tcon *tcon,
>                        struct cifsFileInfo *cfile,
>                        struct fiemap_extent_info *fei, u64 start, u64 len)
> @@ -4166,6 +4250,7 @@ struct smb_version_operations smb20_operations = {
>         .ioctl_query_info = smb2_ioctl_query_info,
>         .make_node = smb2_make_node,
>         .fiemap = smb3_fiemap,
> +       .llseek = smb3_llseek,
>  };
>
>  struct smb_version_operations smb21_operations = {
> @@ -4266,6 +4351,7 @@ struct smb_version_operations smb21_operations = {
>         .ioctl_query_info = smb2_ioctl_query_info,
>         .make_node = smb2_make_node,
>         .fiemap = smb3_fiemap,
> +       .llseek = smb3_llseek,
>  };
>
>  struct smb_version_operations smb30_operations = {
> @@ -4375,6 +4461,7 @@ struct smb_version_operations smb30_operations = {
>         .ioctl_query_info = smb2_ioctl_query_info,
>         .make_node = smb2_make_node,
>         .fiemap = smb3_fiemap,
> +       .llseek = smb3_llseek,
>  };
>
>  struct smb_version_operations smb311_operations = {
> @@ -4485,6 +4572,7 @@ struct smb_version_operations smb311_operations = {
>         .ioctl_query_info = smb2_ioctl_query_info,
>         .make_node = smb2_make_node,
>         .fiemap = smb3_fiemap,
> +       .llseek = smb3_llseek,
>  };
>
>  struct smb_version_values smb20_values = {
> --
> 2.13.6
>


-- 
Thanks,

Steve
