Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36043C6377D
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 07:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21FDB61249
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 07:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhGVGh3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhGVGh3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jul 2021 02:37:29 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E7EC061575
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 00:18:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ga14so6946869ejc.6
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 00:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HfFiQkwOJtdPGTwbUK8upugj7JqR07t3stq9QRHgjtg=;
        b=mXmK6TPGqGDSeIVxjC5rNqnLm3yp0dANbPwmu07qyzUHpwVw993iXeejROThZuxfOW
         RMmVdaYgJsopMOOk9tDgQ8lFBE6T1CB+7QdmQJ2Ox2Ntepk7EiuVD9+5O+rlwqeqFxU4
         +dzx0FGpj1UavXB8B5lH7mFz+8jXjS2/vQN+LrYdgrdkPPkI6IG/Lf2hoE4unrUY8CdF
         CM2sJpHGj8V+eHoSgqmlsUf1lM6/sxFF137b8Ml3PnxJY0w3Pgj8QkVhVygR6Xfxif+6
         w+/Fcs/fTRt7GUcnTv6LkZWdzGIag7WmSCpOYY3cC67KxpqCmDVt9Qo9seLZMyKO8mjM
         bwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HfFiQkwOJtdPGTwbUK8upugj7JqR07t3stq9QRHgjtg=;
        b=hXCKyJvOFkUHZG0KVTAxGoO0zgSEokY2yHrmi1odJQXSXD60KJd3TGZDbZ/KXVXmrK
         73LNCcfISZug3klFFKGeP33fyMimDOOSVoPNPf6c+/0VJjWnKdpLcOQKv704xrBp4B78
         XobKDB0SPn9NYBfbps2A2tjuU2jRj6FjFl9Q7ARmSL5EwIjYwJ/HtdBkFf+zBNSBG5Gk
         uQRUvECsG6xJTT286YNSfgI+sp5sr/kJYlpRJkSn6pJhoWSjVoAfEPGF4eJnqv5f3GD+
         svhNtwc3WXKAZGY34tmIz2ZmshOHjjELAfjd0zTjF0nzaBeMoZB9K3l5Vx22x95dF/JT
         Zu/g==
X-Gm-Message-State: AOAM533tuBwqDI7hcJCh+wTWErHCYhWSYJSn79DgsFpccrp9MQ1kOecm
        XHfEKsQtmk9NVoYIjkvr1tn3YVCCWIAT6WM5OnE=
X-Google-Smtp-Source: ABdhPJwRrhik06CudaRa5EWp8i8OVs6gQwTTJIqZmi/nayka/VvoxhSkgfLcJ86YPQk/ahM8QyQjfUribz3U8OazeT8=
X-Received: by 2002:a17:906:f8da:: with SMTP id lh26mr41756958ejb.203.1626938282282;
 Thu, 22 Jul 2021 00:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71@epcas1p4.samsung.com>
 <014c01d77dd3$57add320$07097960$@samsung.com> <016b01d77e00$fe61efd0$fb25cf70$@samsung.com>
 <CAGvGhF55Tq-sLUtKBn+QX6kWrL9dDzKkXFKdQ==gz3s=RkySKQ@mail.gmail.com> <006601d77ec6$6b1b13c0$41513b40$@samsung.com>
In-Reply-To: <006601d77ec6$6b1b13c0$41513b40$@samsung.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 22 Jul 2021 17:17:50 +1000
Message-ID: <CAN05THTv3o8yDuGLJE5M+YXhdW6ChnnUyznVF_a_3uLQcE=5Tw@mail.gmail.com>
Subject: Re: [PATCH] cifs: only write 64kb at a time when fallocating a small
 region of a file
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Leif Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes, ofcourse.

Steve, can you revert that deletion in the patch?

On Thu, Jul 22, 2021 at 4:55 PM Namjae Jeon <namjae.jeon@samsung.com> wrote:
>
> > This code is actually bogus and does the opposite of what the comment says.
> > If out_data_len is 0 then that means that the entire region is unallocated and then we should not
> > bail out but proceed and allocate the hole.
>
> > generic/071 works against a windows server for me.
>
>
> > If it fails with this code removed it might mean that generic/071 never worked with cifs.ko correctly.
>
> generic/071 create preallocated extent by calling fallocate with keep size flags.
> It means the file size should not be increased.
> But if (out_buf_len == 0) check is removed, 1MB write is performed using SMB2_write loop().
> It means the file size becomes 1MB.
>
> And then, generic/071 call again fallocate(0, 512K) which mean file size should be 512K.
> but SMB2_set_eof() in cifs is not called due to the code below(->i_size is bigger than off + len),
> So 071 test failed as file size remains 1MB.
>
>         /*
>          * Extending the file
>          */
>         if ((keep_size == false) && i_size_read(inode) < off + len) {
>                 rc = inode_newsize_ok(inode, off + len);
>                 if (rc)
>                         goto out;
>
>                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
>                         smb2_set_sparse(xid, tcon, cfile, inode, false);
>
>                 eof = cpu_to_le64(off + len);
>                 rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>                                   cfile->fid.volatile_fid, cfile->pid, &eof);
>                 if (rc == 0) {
>                         cifsi->server_eof = off + len;
>                         cifs_setsize(inode, off + len);
>                         cifs_truncate_page(inode->i_mapping, inode->i_size);
>                         truncate_setsize(inode, off + len);
>                 }
>                 goto out;
>         }
>
