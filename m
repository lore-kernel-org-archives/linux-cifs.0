Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FAAC47082
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 20:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E9A6138C
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 20:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFEVBa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Jun 2021 17:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhFEVB3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 5 Jun 2021 17:01:29 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE87EC061766
        for <linux-cifs@vger.kernel.org>; Sat,  5 Jun 2021 13:59:27 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m21so3752613lfg.13
        for <linux-cifs@vger.kernel.org>; Sat, 05 Jun 2021 13:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R/KLXfh8T6zu4Ar85DLXHjlnpMsDz2v7+2mUSZPbAdE=;
        b=n8AxTz/Ifoful+kLScQ/YHOYdZ5kaI8HEFCXqvrOyz4zNJ7kR1Uxn4xNSsUeSaWnOC
         WAWCZ9+qTjkqr71bGmSUjckicwQdHW5Sz0ktf3hOlDSA+M8ifBLbDO15ee1ynS3AthRg
         +VtCFhhgD6VgL8RhbN5ZLNnXO3IwJr3A00Z15HDai63pP/ZoL4FoWhCJkxoQZfGp0qbX
         I1QpS4uZ1IQX0nxI9RhpLystCO5JxVv4AMkgG4iH6e8iwo3sRak7+e/uh8SQHcv2MNHA
         odhxmuxNsRIqu8rITLte86eL7LIJu9Bcd6BxaG0YqoBA/rg+bjFMCQT/OR2mxSkqugq+
         bzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R/KLXfh8T6zu4Ar85DLXHjlnpMsDz2v7+2mUSZPbAdE=;
        b=kDhadwn4iBVCkDD+AH+A5zmubs6NGZmEHZQxKiv+p16AP3IYLLLa1fIoHy2qWtrUBa
         TzhMc7qavAomGDVs/tUDN5sCV9DYe9ix9+mXYUjbCBe+8frC0ATSFs0xJs9MHQenFjrA
         0fBFqTn9x/U9bJezv57EnAmrudkyNmAOgXQh4SC6XijwnJA8JVGw60CsmVcPw3jh05yY
         TUcNW8nFXdJDhOerckKVVsxyX5dozXNqJp+M2Y9n5lc29sCNZO8RXyPavqLTCFxqklQD
         R2yTSd8O0ohesf6hEBZeeJulISLYGvjWKBGiTIHai2YMhE0cCy8uJ0XXJoOlHdheoDFi
         p9Ow==
X-Gm-Message-State: AOAM533nh2lWTTvRSEFLtqWt5gdF02igcwOTNd3ysksFmNaBBMk0hZMD
        4TV1dixU9oCu8r1na4tMTh5bCBIW4sNkLyd9cnY=
X-Google-Smtp-Source: ABdhPJzIECt1N5kQucNC/yQgQfGlljDmbKZmoy/7QziWVJZ3ifTGI0TopI6ZMwyDiMUk+epkI2HhWfGW1GOruX37XH4=
X-Received: by 2002:ac2:5684:: with SMTP id 4mr7061309lfr.282.1622926766239;
 Sat, 05 Jun 2021 13:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210603053101.1229297-1-lsahlber@redhat.com> <20210603053101.1229297-2-lsahlber@redhat.com>
In-Reply-To: <20210603053101.1229297-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 5 Jun 2021 15:59:15 -0500
Message-ID: <CAH2r5mvNgHyiV-yaLHPiBiUSYHPKpncXY8L-ra+oXcorM3wexQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: improve fallocate emulation
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

corrected some minor formatting in the description and merged into
cifs-2.6.git for-next

On Thu, Jun 3, 2021 at 12:31 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1866684
>
> We don't have a real fallocate in the SMB2 protocol so we used to emulate fallocate
> by simply switching the file to become non-sparse. But as that could potantially
> consume a lot more data than we intended to fallocate (large sparse file and fallocating a thin
> slice in the middle) we would only do this IFF the fallocate request was for virtually the entire file.
>
> This patch improves this and starts allowing us to fallocate smaller chunks of a file by
> overwriting the region with 0, for the parts that are unallocated.
>
> The method used is to first query the server for FSCTL_QUERY_ALLOCATED_RANGES to find what
> is unallocated in teh fallocate range and then to only overwrite-with-zero the unallocated ranges to fill
> in the holes.
> As overwriting-with-zero is different from just allocating blocks, and potentially much more expensive,
> we limit this to only allow fallocate ranges up to 1Mb in size.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 133 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 21ef51d338e0..b68ba92893b6 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3601,6 +3601,119 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +static int smb3_simple_fallocate_write_range(unsigned int xid,
> +                                            struct cifs_tcon *tcon,
> +                                            struct cifsFileInfo *cfile,
> +                                            loff_t off, loff_t len,
> +                                            char *buf)
> +{
> +       struct cifs_io_parms io_parms = {0};
> +       int nbytes;
> +       struct kvec iov[2];
> +
> +       io_parms.netfid = cfile->fid.netfid;
> +       io_parms.pid = current->tgid;
> +       io_parms.tcon = tcon;
> +       io_parms.persistent_fid = cfile->fid.persistent_fid;
> +       io_parms.volatile_fid = cfile->fid.volatile_fid;
> +       io_parms.offset = off;
> +       io_parms.length = len;
> +
> +       /* iov[0] is reserved for smb header */
> +       iov[1].iov_base = buf;
> +       iov[1].iov_len = io_parms.length;
> +       return SMB2_write(xid, &io_parms, &nbytes, iov, 1);
> +}
> +
> +static int smb3_simple_fallocate_range(unsigned int xid,
> +                                      struct cifs_tcon *tcon,
> +                                      struct cifsFileInfo *cfile,
> +                                      loff_t off, loff_t len)
> +{
> +       struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
> +       u32 out_data_len;
> +       char *buf = NULL;
> +       loff_t l;
> +       int rc;
> +
> +       in_data.file_offset = cpu_to_le64(off);
> +       in_data.length = cpu_to_le64(len);
> +       rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
> +                       cfile->fid.volatile_fid,
> +                       FSCTL_QUERY_ALLOCATED_RANGES, true,
> +                       (char *)&in_data, sizeof(in_data),
> +                       1024 * sizeof(struct file_allocated_range_buffer),
> +                       (char **)&out_data, &out_data_len);
> +       if (rc)
> +               goto out;
> +       /*
> +        * It is already all allocated
> +        */
> +       if (out_data_len == 0)
> +               goto out;
> +
> +       buf = kzalloc(1024 * 1024, GFP_KERNEL);
> +       if (buf == NULL) {
> +               rc = -ENOMEM;
> +               goto out;
> +       }
> +
> +       tmp_data = out_data;
> +       while (len) {
> +               /*
> +                * The rest of the region is unmapped so write it all.
> +                */
> +               if (out_data_len == 0) {
> +                       rc = smb3_simple_fallocate_write_range(xid, tcon,
> +                                              cfile, off, len, buf);
> +                       goto out;
> +               }
> +
> +               if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
> +                       rc = -EINVAL;
> +                       goto out;
> +               }
> +
> +               if (off < le64_to_cpu(tmp_data->file_offset)) {
> +                       /*
> +                        * We are at a hole. Write until the end of the region
> +                        * or until the next allocated data,
> +                        * whichever comes next.
> +                        */
> +                       l = le64_to_cpu(tmp_data->file_offset) - off;
> +                       if (len < l)
> +                               l = len;
> +                       rc = smb3_simple_fallocate_write_range(xid, tcon,
> +                                              cfile, off, l, buf);
> +                       if (rc)
> +                               goto out;
> +                       off = off + l;
> +                       len = len - l;
> +                       if (len == 0)
> +                               goto out;
> +               }
> +               /*
> +                * We are at a section of allocated data, just skip forward
> +                * until the end of the data or the end of the region
> +                * we are supposed to fallocate, whichever comes first.
> +                */
> +               l = le64_to_cpu(tmp_data->length);
> +               if (len < l)
> +                       l = len;
> +               off += l;
> +               len -= l;
> +
> +               tmp_data = &tmp_data[1];
> +               out_data_len -= sizeof(struct file_allocated_range_buffer);
> +       }
> +
> + out:
> +       kfree(out_data);
> +       kfree(buf);
> +       return rc;
> +}
> +
> +
>  static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>                             loff_t off, loff_t len, bool keep_size)
>  {
> @@ -3661,6 +3774,26 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>         }
>
>         if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
> +               /*
> +                * At this point, we are trying to fallocate an internal
> +                * regions of a sparse file. Since smb2 does not have a
> +                * fallocate command we have two otions on how to emulate this.
> +                * We can either turn the entire file to become non-sparse
> +                * which we only do if the fallocate is for virtually
> +                * the whole file,  or we can overwrite the region with zeroes
> +                * using SMB2_write, which could be prohibitevly expensive
> +                * if len is large.
> +                */
> +               /*
> +                * We are only trying to fallocate a small region so
> +                * just write it with zero.
> +                */
> +               if (len <= 1024 * 1024) {
> +                       rc = smb3_simple_fallocate_range(xid, tcon, cfile,
> +                                                        off, len);
> +                       goto out;
> +               }
> +
>                 /*
>                  * Check if falloc starts within first few pages of file
>                  * and ends within a few pages of the end of file to
> --
> 2.30.2
>


-- 
Thanks,

Steve
