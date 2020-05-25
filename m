Return-Path: <SRS0=rOol=7H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C618C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 May 2020 12:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4836F2071A
	for <linux-cifs@archiver.kernel.org>; Mon, 25 May 2020 12:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l7v6Ryzv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390509AbgEYMqJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 May 2020 08:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390488AbgEYMqJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 May 2020 08:46:09 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDD8C061A0E
        for <linux-cifs@vger.kernel.org>; Mon, 25 May 2020 05:46:09 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id s7so2354632ybo.9
        for <linux-cifs@vger.kernel.org>; Mon, 25 May 2020 05:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5WdkaI4/VTBoWMH5qx+Tm9t/15+LfjY4RC/K8iwPbCc=;
        b=l7v6Ryzv3TspTMRbAljQkE5o7OVe5X0YskiNp9z9QTXuCofIgsD5izI5rrHqSr6O+G
         WrOS8hSau/duOhla6SHQKc+k6wA59PfWp8IXn9dmbgPvCrHhO1nG4+IWWeKjJ3VD4/4G
         65fSrMnGyrP49FlEy36Tr1Xf/BIW+kq5X18Z0ffnaMbNAMcnGHRpFhxeAAuuxrxT8r6J
         IuKaoQ5PhpjII8nuvP/HoFkly8mhN1pW89KSCS/L4oDHp0bSiAlXbpVExB0GiO2y5cDy
         mV1JRztUTN0C3ZWqxzwGLaDx944saC6sgc9oJYbGi+gCjdHrg2qb9syYVexfveOvU8/s
         Sa1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5WdkaI4/VTBoWMH5qx+Tm9t/15+LfjY4RC/K8iwPbCc=;
        b=CQ7UQ1CrUwEhL0UUKJrCeFQw/49Ip/LkwE1CZIqaJScljtV5QVB7cVnm2k6/QaAnU+
         21RU4r88oOnVBtb5tjufmUw6NryOeKCFpTQvX/Sb74En6GYhoqjXyzawq8yfxRMfr3uR
         aJ8qJEd/Rk7VLMNqu0iCzdxKZ2cXqXb3BIvF8sWphidutVNg4EQE48dJRRYx7PZThIaZ
         fyLLk9d/+9bplC/kP7Tvqr2rGE5gUoQrF60sa8+QJ+dLoindMJxmskmkBYla5UsOnld5
         mXegpbfGRN2dHFlx/ZRJx0SAF3CyR6hO1+WrKA8ksu4H4zSsdlN9MtfbsiWj1lP477Ld
         VYag==
X-Gm-Message-State: AOAM531MlUHTh1I66EB/YPkq9Pi1kUmTi7lZEyzHnJBMK13BvN9Vv8m/
        Nm65rtMJH3xF0Z1sYhwKTeuiv5n4l/nz7YGXndL2J88y
X-Google-Smtp-Source: ABdhPJz9JaP4SiBEJQ20+X9S9JLE5cpJNxT+x6oKOd5gajZ55gJAzYGgbRt9n9lRyor9g/KAkJw6ET15qb0pwvUgosk=
X-Received: by 2002:a25:9709:: with SMTP id d9mr41608969ybo.85.1590410768462;
 Mon, 25 May 2020 05:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200521050315.6445-1-lsahlber@redhat.com>
In-Reply-To: <20200521050315.6445-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 May 2020 07:45:57 -0500
Message-ID: <CAH2r5msKK-WNgU1m1-QL+BpJmNEsv0+YQXSQmRSJdyqE_Gn2PQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: move some variables off the stack in smb2_ioctl_query_info
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged this and the previous patch into for-next pending
more testing

On Thu, May 21, 2020 at 12:03 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Move some large data structures off the stack and into dynamically
> allocated memory in the function smb2_ioctl_query_info
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 58 +++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 35 insertions(+), 23 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index f829f4165d38..fa5c79f64c0b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1452,6 +1452,16 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +struct iqi_vars {
> +       struct smb_rqst rqst[3];
> +       struct kvec rsp_iov[3];
> +       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> +       struct kvec qi_iov[1];
> +       struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> +       struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> +       struct kvec close_iov[1];
> +};
> +
>  static int
>  smb2_ioctl_query_info(const unsigned int xid,
>                       struct cifs_tcon *tcon,
> @@ -1459,6 +1469,9 @@ smb2_ioctl_query_info(const unsigned int xid,
>                       __le16 *path, int is_dir,
>                       unsigned long p)
>  {
> +       struct iqi_vars *vars;
> +       struct smb_rqst *rqst;
> +       struct kvec *rsp_iov;
>         struct cifs_ses *ses = tcon->ses;
>         char __user *arg = (char __user *)p;
>         struct smb_query_info qi;
> @@ -1468,45 +1481,47 @@ smb2_ioctl_query_info(const unsigned int xid,
>         struct smb2_query_info_rsp *qi_rsp = NULL;
>         struct smb2_ioctl_rsp *io_rsp = NULL;
>         void *buffer = NULL;
> -       struct smb_rqst rqst[3];
>         int resp_buftype[3];
> -       struct kvec rsp_iov[3];
> -       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
>         struct cifs_open_parms oparms;
>         u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
>         struct cifs_fid fid;
> -       struct kvec qi_iov[1];
> -       struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> -       struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> -       struct kvec close_iov[1];
>         unsigned int size[2];
>         void *data[2];
>         int create_options = is_dir ? CREATE_NOT_FILE : CREATE_NOT_DIR;
>
> -       memset(rqst, 0, sizeof(rqst));
> +       vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
> +       if (vars == NULL)
> +               return -ENOMEM;
> +       rqst = &vars->rqst[0];
> +       rsp_iov = &vars->rsp_iov[0];
> +
>         resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
> -       memset(rsp_iov, 0, sizeof(rsp_iov));
>
>         if (copy_from_user(&qi, arg, sizeof(struct smb_query_info)))
> -               return -EFAULT;
> +               goto e_fault;
>
> -       if (qi.output_buffer_length > 1024)
> +       if (qi.output_buffer_length > 1024) {
> +               kfree(vars);
>                 return -EINVAL;
> +       }
>
> -       if (!ses || !(ses->server))
> +       if (!ses || !(ses->server)) {
> +               kfree(vars);
>                 return -EIO;
> +       }
>
>         if (smb3_encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
>
>         buffer = memdup_user(arg + sizeof(struct smb_query_info),
>                              qi.output_buffer_length);
> -       if (IS_ERR(buffer))
> +       if (IS_ERR(buffer)) {
> +               kfree(vars);
>                 return PTR_ERR(buffer);
> +       }
>
>         /* Open */
> -       memset(&open_iov, 0, sizeof(open_iov));
> -       rqst[0].rq_iov = open_iov;
> +       rqst[0].rq_iov = &vars->open_iov[0];
>         rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
>
>         memset(&oparms, 0, sizeof(oparms));
> @@ -1548,8 +1563,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>                 if (!capable(CAP_SYS_ADMIN))
>                         rc = -EPERM;
>                 else  {
> -                       memset(&io_iov, 0, sizeof(io_iov));
> -                       rqst[1].rq_iov = io_iov;
> +                       rqst[1].rq_iov = &vars->io_iov[0];
>                         rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
>
>                         rc = SMB2_ioctl_init(tcon, &rqst[1],
> @@ -1565,8 +1579,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>                 if (!capable(CAP_SYS_ADMIN))
>                         rc = -EPERM;
>                 else  {
> -                       memset(&si_iov, 0, sizeof(si_iov));
> -                       rqst[1].rq_iov = si_iov;
> +                       rqst[1].rq_iov = &vars->si_iov[0];
>                         rqst[1].rq_nvec = 1;
>
>                         size[0] = 8;
> @@ -1579,8 +1592,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>                                         SMB2_O_INFO_FILE, 0, data, size);
>                 }
>         } else if (qi.flags == PASSTHRU_QUERY_INFO) {
> -               memset(&qi_iov, 0, sizeof(qi_iov));
> -               rqst[1].rq_iov = qi_iov;
> +               rqst[1].rq_iov = &vars->qi_iov[0];
>                 rqst[1].rq_nvec = 1;
>
>                 rc = SMB2_query_info_init(tcon, &rqst[1], COMPOUND_FID,
> @@ -1599,8 +1611,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>         smb2_set_related(&rqst[1]);
>
>         /* Close */
> -       memset(&close_iov, 0, sizeof(close_iov));
> -       rqst[2].rq_iov = close_iov;
> +       rqst[2].rq_iov = &vars->close_iov[0];
>         rqst[2].rq_nvec = 1;
>
>         rc = SMB2_close_init(tcon, &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
> @@ -1649,6 +1660,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>         }
>
>   iqinf_exit:
> +       kfree(vars);
>         kfree(buffer);
>         SMB2_open_free(&rqst[0]);
>         if (qi.flags & PASSTHRU_FSCTL)
> --
> 2.13.6
>


-- 
Thanks,

Steve
