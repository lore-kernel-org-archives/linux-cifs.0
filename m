Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19730CA0EC3
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Sep 2023 13:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbjILNFL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Sep 2023 09:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbjILNEw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Sep 2023 09:04:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C762130
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 06:03:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832B9C433C8
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 13:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694523809;
        bh=9LfnhffvLCkFuEGlSaZMxYpyZr3nwMKD2xC80hYIsFw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=GDg2C/uRWwwFBch6KOL0+wD7aLzVNxthlLPDe2lWlzk5Z5esX3bmuprCh25k4SauV
         k/xXjJRSHJKzb0jXIDFo8wXNS38Q/OeuFTuMwqXRzrtU6Dk8NlSsu1oRdyY6z0k52E
         DGb6R1UyIUX/0UoycqmNx426oeL7NcvezZrqjpE1kcQt5kG6seIdAI9IdvBJ4iBcak
         P/iTZ77vgt2y3OHGd7EL4+pE3xMGtLQUs+e10pWCxsTbdTzYMTFxAP2Rg4uPFuhmO3
         FA4hVA9aFZjMWXtQROFwwWhIec/p1Q4haS9epSmr+sCcWySVsYx7oS1ldFmN94Q/Lq
         N0ynd7rFP6jeg==
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5734b893a11so3563080eaf.1
        for <linux-cifs@vger.kernel.org>; Tue, 12 Sep 2023 06:03:29 -0700 (PDT)
X-Gm-Message-State: AOJu0YyPX+Isj5Uh22Zi6EIzRQVRx7YxmMDT6RJ6NURCUXAeY2dLWkxu
        ziVwS1MPvP/WiI9fLBlK8zrKmIjtnpm+fggn82A=
X-Google-Smtp-Source: AGHT+IHxUa/JkvRicmwxbZx552AhxDenPSz4MkBseKf9rMP6JNzSSEoHYIX1Xv6c+KacN16+vGUqYbG15Fg9H+kBtYE=
X-Received: by 2002:a05:6870:3c83:b0:1d5:a3b5:d89c with SMTP id
 gl3-20020a0568703c8300b001d5a3b5d89cmr8262862oab.3.1694523808488; Tue, 12 Sep
 2023 06:03:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:692:0:b0:4f6:2c4a:5156 with HTTP; Tue, 12 Sep 2023
 06:03:27 -0700 (PDT)
In-Reply-To: <dfc735a8-c0a6-4691-80a0-bf5c3814662e@moroto.mountain>
References: <dfc735a8-c0a6-4691-80a0-bf5c3814662e@moroto.mountain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 12 Sep 2023 22:03:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9_rxHxUioYdKD7HshfJq0nzw1hBrJKnE6vHnk+ztsN7g@mail.gmail.com>
Message-ID: <CAKYAXd9_rxHxUioYdKD7HshfJq0nzw1hBrJKnE6vHnk+ztsN7g@mail.gmail.com>
Subject: Re: [bug report] ksmbd: add support for read compound
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-09-11 23:31 GMT+09:00, Dan Carpenter <dan.carpenter@linaro.org>:
> Hello Namjae Jeon,
Hi Dan,
>
> The patch e2b76ab8b5c9: "ksmbd: add support for read compound" from
> Aug 29, 2023 (linux-next), leads to the following Smatch static
> checker warning:
>
> 	fs/smb/server/smb2pdu.c:6329 smb2_read()
> 	warn: passing freed memory 'aux_payload_buf'
>
> fs/smb/server/smb2pdu.c
>     6283         ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
>     6284                     fp->filp, offset, length);
>     6285
>     6286         aux_payload_buf = kvzalloc(length, GFP_KERNEL);
>     6287         if (!aux_payload_buf) {
>     6288                 err = -ENOMEM;
>     6289                 goto out;
>     6290         }
>     6291
>     6292         nbytes = ksmbd_vfs_read(work, fp, length, &offset,
> aux_payload_buf);
>     6293         if (nbytes < 0) {
>     6294                 err = nbytes;
>     6295                 goto out;
>     6296         }
>     6297
>     6298         if ((nbytes == 0 && length != 0) || nbytes < mincount) {
>     6299                 kvfree(aux_payload_buf);
>     6300                 rsp->hdr.Status = STATUS_END_OF_FILE;
>     6301                 smb2_set_err_rsp(work);
>     6302                 ksmbd_fd_put(work, fp);
>     6303                 return 0;
>     6304         }
>     6305
>     6306         ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
>     6307                     nbytes, offset, mincount);
>     6308
>     6309         if (is_rdma_channel == true) {
>     6310                 /* write data to the client using rdma channel */
>     6311                 remain_bytes = smb2_read_rdma_channel(work, req,
>     6312
> aux_payload_buf,
>     6313                                                       nbytes);
>     6314                 kvfree(aux_payload_buf);
>                          ^^^^^^^^^^^^^^^^^^^^^^^
> freed
>
>     6315
>     6316                 nbytes = 0;
>
> I guess probably it doesn't matter that we're passing a freed variable
> if nbytes is zero.
>  But could we also just set "aux_payload_buf = NULL"?
> I am not going to try silence this type of warning in Smatch.
Yes, It isn't a problem... but will fix it to make smatch happy.

Thanks.
>
>     6317                 if (remain_bytes < 0) {
>     6318                         err = (int)remain_bytes;
>     6319                         goto out;
>     6320                 }
>     6321         }
>     6322
>     6323         rsp->StructureSize = cpu_to_le16(17);
>     6324         rsp->DataOffset = 80;
>     6325         rsp->Reserved = 0;
>     6326         rsp->DataLength = cpu_to_le32(nbytes);
>     6327         rsp->DataRemaining = cpu_to_le32(remain_bytes);
>     6328         rsp->Flags = 0;
> --> 6329         err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
>     6330                                      offsetof(struct smb2_read_rsp,
> Buffer),
>     6331                                      aux_payload_buf, nbytes);
>                                               ^^^^^^^^^^^^^^^
> Passing free variable.
>
>
>     6332         if (err)
>     6333                 goto out;
>     6334         ksmbd_fd_put(work, fp);
>     6335         return 0;
>     6336
>     6337 out:
>     6338         if (err) {
>     6339                 if (err == -EISDIR)
>     6340                         rsp->hdr.Status =
> STATUS_INVALID_DEVICE_REQUEST;
>     6341                 else if (err == -EAGAIN)
>     6342                         rsp->hdr.Status =
> STATUS_FILE_LOCK_CONFLICT;
>     6343                 else if (err == -ENOENT)
>     6344                         rsp->hdr.Status = STATUS_FILE_CLOSED;
>     6345                 else if (err == -EACCES)
>     6346                         rsp->hdr.Status = STATUS_ACCESS_DENIED;
>     6347                 else if (err == -ESHARE)
>     6348                         rsp->hdr.Status =
> STATUS_SHARING_VIOLATION;
>     6349                 else if (err == -EINVAL)
>     6350                         rsp->hdr.Status =
> STATUS_INVALID_PARAMETER;
>     6351                 else
>     6352                         rsp->hdr.Status = STATUS_INVALID_HANDLE;
>     6353
>     6354                 smb2_set_err_rsp(work);
>     6355         }
>     6356         ksmbd_fd_put(work, fp);
>     6357         return err;
>     6358 }
>
> regards,
> dan carpenter
>
