Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F12CA0ECE
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Sep 2023 22:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbjIKWmi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbjIKObZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Sep 2023 10:31:25 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F2F3
        for <linux-cifs@vger.kernel.org>; Mon, 11 Sep 2023 07:31:20 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-523100882f2so5836423a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Sep 2023 07:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694442679; x=1695047479; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mrxLW/r54lgr1nVJd/PxNq4luBSvavciSR8GKMmXoGE=;
        b=rHuZNcQvlG6OrFnQiJQf9fdbWch7k3FiLa7H4ymsrhai1aUOpUEIyek6miEKQ69Vjw
         a4B9h/IWOfm0FSljpjy6JgZMt94F91rAVp70qLbDEl6gvFDmIsZgG9n5WIqkS5FgfoTD
         7M1WH9rFaluEWff2/EM+w5lwzSSZohhLvVKLX+Q+JJuHiQO0/O+2uGR2s3JTTWZhEYjq
         mQNg0nXv8dytlpQSP7YdVM8KLWkkx9iyKWiZOO31rxs61uQqPPo2IdhbFeVOlzaNxXXi
         yJboEMwsIuZpEBCeF3Qh6bLzCnBvWhmqmZKG0ge5C/ZV4yCXX7i0wzbdPbT0vx8wQ2eg
         n72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694442679; x=1695047479;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mrxLW/r54lgr1nVJd/PxNq4luBSvavciSR8GKMmXoGE=;
        b=V4rrVwT81a6XOn1JSzhIKb72nxcGEslWoBZUBZ+eHnI7eP0rHu/zbFUDSGCZ019JKO
         SMi1kHJuh5kEBbjoFkPZRGRorHWIigYuKjzUX9V9WDimjFbh3AyxM/5x4Am9VbH8a0SN
         09aMHRppKNkbnw2KM1GYz05AQa0L/vB8Y3Ntgo/rJ/UwrykhOmD3x9NjuB9DI4kKUhW/
         p1jfqEJASXkMoH4a1nRvaFgi9J+48dQVfCQe5McMoIz68wnj1Bd6j4O4bG6IzFEtOI20
         023PGCGys5fIeEsV+BM8zwYzvmBtFwNy8KoWdZzhMX8S7TFkJKw9uGdfBBDfrkRguyZf
         g8gQ==
X-Gm-Message-State: AOJu0YzJ+EVWHHyFD7hjO5lRL8UnCR3r5yviP3x9kTFUaRplWrn8CRUC
        hH82dA69I6HzBLFYJ7PaYG8otlt1OuuLIF/xzZM=
X-Google-Smtp-Source: AGHT+IHzo8KvJ9JbxQtCpKUYt0rUKJbUBS6aiCiAL+dfyLFj7Lklz8nBU28nerR1XjZsofNsR+TVKw==
X-Received: by 2002:a05:6402:1487:b0:52d:faa6:8ae3 with SMTP id e7-20020a056402148700b0052dfaa68ae3mr8897836edv.31.1694442679347;
        Mon, 11 Sep 2023 07:31:19 -0700 (PDT)
Received: from localhost (h3220.n1.ips.mtn.co.ug. [41.210.178.32])
        by smtp.gmail.com with ESMTPSA id i23-20020a0564020f1700b0052f8c67a399sm384166eda.37.2023.09.11.07.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 07:31:18 -0700 (PDT)
Date:   Mon, 11 Sep 2023 17:31:09 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     linkinjeon@kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] ksmbd: add support for read compound
Message-ID: <dfc735a8-c0a6-4691-80a0-bf5c3814662e@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch e2b76ab8b5c9: "ksmbd: add support for read compound" from
Aug 29, 2023 (linux-next), leads to the following Smatch static
checker warning:

	fs/smb/server/smb2pdu.c:6329 smb2_read()
	warn: passing freed memory 'aux_payload_buf'

fs/smb/server/smb2pdu.c
    6283         ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
    6284                     fp->filp, offset, length);
    6285 
    6286         aux_payload_buf = kvzalloc(length, GFP_KERNEL);
    6287         if (!aux_payload_buf) {
    6288                 err = -ENOMEM;
    6289                 goto out;
    6290         }
    6291 
    6292         nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
    6293         if (nbytes < 0) {
    6294                 err = nbytes;
    6295                 goto out;
    6296         }
    6297 
    6298         if ((nbytes == 0 && length != 0) || nbytes < mincount) {
    6299                 kvfree(aux_payload_buf);
    6300                 rsp->hdr.Status = STATUS_END_OF_FILE;
    6301                 smb2_set_err_rsp(work);
    6302                 ksmbd_fd_put(work, fp);
    6303                 return 0;
    6304         }
    6305 
    6306         ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
    6307                     nbytes, offset, mincount);
    6308 
    6309         if (is_rdma_channel == true) {
    6310                 /* write data to the client using rdma channel */
    6311                 remain_bytes = smb2_read_rdma_channel(work, req,
    6312                                                       aux_payload_buf,
    6313                                                       nbytes);
    6314                 kvfree(aux_payload_buf);
                         ^^^^^^^^^^^^^^^^^^^^^^^
freed

    6315 
    6316                 nbytes = 0;

I guess probably it doesn't matter that we're passing a freed variable
if nbytes is zero.  But could we also just set "aux_payload_buf = NULL"?
I am not going to try silence this type of warning in Smatch.

    6317                 if (remain_bytes < 0) {
    6318                         err = (int)remain_bytes;
    6319                         goto out;
    6320                 }
    6321         }
    6322 
    6323         rsp->StructureSize = cpu_to_le16(17);
    6324         rsp->DataOffset = 80;
    6325         rsp->Reserved = 0;
    6326         rsp->DataLength = cpu_to_le32(nbytes);
    6327         rsp->DataRemaining = cpu_to_le32(remain_bytes);
    6328         rsp->Flags = 0;
--> 6329         err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
    6330                                      offsetof(struct smb2_read_rsp, Buffer),
    6331                                      aux_payload_buf, nbytes);
                                              ^^^^^^^^^^^^^^^
Passing free variable.


    6332         if (err)
    6333                 goto out;
    6334         ksmbd_fd_put(work, fp);
    6335         return 0;
    6336 
    6337 out:
    6338         if (err) {
    6339                 if (err == -EISDIR)
    6340                         rsp->hdr.Status = STATUS_INVALID_DEVICE_REQUEST;
    6341                 else if (err == -EAGAIN)
    6342                         rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
    6343                 else if (err == -ENOENT)
    6344                         rsp->hdr.Status = STATUS_FILE_CLOSED;
    6345                 else if (err == -EACCES)
    6346                         rsp->hdr.Status = STATUS_ACCESS_DENIED;
    6347                 else if (err == -ESHARE)
    6348                         rsp->hdr.Status = STATUS_SHARING_VIOLATION;
    6349                 else if (err == -EINVAL)
    6350                         rsp->hdr.Status = STATUS_INVALID_PARAMETER;
    6351                 else
    6352                         rsp->hdr.Status = STATUS_INVALID_HANDLE;
    6353 
    6354                 smb2_set_err_rsp(work);
    6355         }
    6356         ksmbd_fd_put(work, fp);
    6357         return err;
    6358 }

regards,
dan carpenter
