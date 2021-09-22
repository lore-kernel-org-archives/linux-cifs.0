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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BF8C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 21:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B606611C4
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 21:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbhIVVlG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 17:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbhIVVlG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 17:41:06 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87F8C061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 14:39:35 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v24so15475523eda.3
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 14:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xoGOJbrFgiBiYElWZw3E9VNAjHDDlWC93qKpt3jh4Kc=;
        b=YZ2fVEz9EBq2xKxvDJDkDXr5J6Ksn5GeRbA35FRDG2MjI3vW7za4FIo9I2IAb88Hdi
         gaexLw9LpUsd01+lbQfO9p15EhNoDx/QKooJ2HmVioXi6UcuPFfQ3Ddmvf3gRvGLOEIC
         JBAatCFRMHE8o+hfYiYYomN18zp2VPYaItZiJK8FwsoUSKcRwtScFcoj8osBwUdBmI5j
         Sjvy+P+it1oYXAwBXBDx+KaOp9dtVHE4Qb384m42oraXmjWEFb8NmdphvQWgBbH7khrk
         4xdxezm1LJZkSKNSESCXrSdmIL+O8TcY27ncmt7oMabrNYiEDo+6ok/ypwPnSD3rVp/D
         KbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xoGOJbrFgiBiYElWZw3E9VNAjHDDlWC93qKpt3jh4Kc=;
        b=6+ksN5Gy4XSvBpE2J0DtFqaEBf+KH+UCadYA75af8iNL4KeBUdVse7WEbzVVCYln42
         PuOgHIAomEiMtIHdbcnhqQbb9yniJbYii+gtBXpVMSP0D2YpU1CMl83CKGcc29ZZkpXm
         2Ld4mCXlcPoahZRj446IHJCYQaQWhzZ42qbhN60LKSG05WnL3hcvaSwV3fFy3irdToYH
         uEbUmTCqUpG3+pQb+eZdu7wh1bKYow3Q4BeFHLQJ/hZ746U6tQPHV/7Vfs29Vn3FvHMv
         riVZkvi+YC/mKzw1RXDUkksCgnO7nroLZMcmeZWL9++i+1TPHOxiP4fA/VzE4bX78GWy
         GREA==
X-Gm-Message-State: AOAM532U46xFUKwVQT/FX1RI/6maEVUfFU17S3CIw83BNiAQd5RJRLZU
        xjaefjS9qh0bn93EjH0TGl2MhVm2kd5X0CYEKXmqpIjP
X-Google-Smtp-Source: ABdhPJyrn/LiMA54fDYBLRCxMJm3l6/nEnd1Co4AZ6k8Vxf3cbCWfHPNhe32LVa8GtnEvzA4FuH1DFD0pGCWVXBrN/g=
X-Received: by 2002:aa7:da41:: with SMTP id w1mr1798362eds.344.1632346774373;
 Wed, 22 Sep 2021 14:39:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210922012651.513888-1-hyc.lee@gmail.com> <90804f93-9a51-9562-758f-b63ab71c9f74@samba.org>
In-Reply-To: <90804f93-9a51-9562-758f-b63ab71c9f74@samba.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 23 Sep 2021 07:39:22 +1000
Message-ID: <CAN05THTmB=TWLEmSB1so9KnM7zG0D4i3J6NnksXW5=zX+UxQtA@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
To:     Ralph Boehme <slow@samba.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 22, 2021 at 11:08 PM Ralph Boehme <slow@samba.org> wrote:
>
> Hi Hyunchul,
>
> patch looks excellent, few more nitpicks below.
>
> Am 22.09.21 um 03:26 schrieb Hyunchul Lee:
> > Add buffer validation for SMB2_CREATE_CONTEXT.
> >
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Ralph Boehme <slow@samba.org>
> > Cc: Steve French <smfrench@gmail.com>
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> > Changes from v2:
> >   - check struct create_context's fields more in smb2_find_context_vals
> >     (suggested by Ralph Boehme).
> >
> >   fs/ksmbd/oplock.c  | 34 ++++++++++++++++++++++++----------
> >   fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
> >   fs/ksmbd/smbacl.c  |  9 ++++++++-
> >   3 files changed, 56 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> > index 16b6236d1bd2..8f743913b1cf 100644
> > --- a/fs/ksmbd/oplock.c
> > +++ b/fs/ksmbd/oplock.c
> > @@ -1451,26 +1451,40 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
> >    */
> >   struct create_context *smb2_find_context_vals(void *open_req, const char *tag)
> >   {
> > -     char *data_offset;
> > +     struct smb2_create_req *req = (struct smb2_create_req *)open_req;
> >       struct create_context *cc;
> > -     unsigned int next = 0;
> > +     char *data_offset, *data_end;
> >       char *name;
> > -     struct smb2_create_req *req = (struct smb2_create_req *)open_req;
>
> this line is only moved, not changed. Can we remove this change from the
> diff?
>
> > +     unsigned int next = 0;
> > +     unsigned int name_off, name_len, value_off, value_len;
> >
> >       data_offset = (char *)req + 4 + le32_to_cpu(req->CreateContextsOffset);
> > +     data_end = data_offset + le32_to_cpu(req->CreateContextsLength);
>
> do we need overflow checks here? At least on 32-bit arch this could
> easily overflow.
>
> >       cc = (struct create_context *)data_offset;
> >       do {
> > -             int val;
> > -
> >               cc = (struct create_context *)((char *)cc + next);
> > -             name = le16_to_cpu(cc->NameOffset) + (char *)cc;
> > -             val = le16_to_cpu(cc->NameLength);
> > -             if (val < 4)
> > +             if ((char *)cc + offsetof(struct create_context, Buffer) >
> > +                 data_end)
> >                       return ERR_PTR(-EINVAL);
> >
> > -             if (memcmp(name, tag, val) == 0)
> > -                     return cc;
> >               next = le32_to_cpu(cc->Next);
> > +             name_off = le16_to_cpu(cc->NameOffset);
> > +             name_len = le16_to_cpu(cc->NameLength);
> > +             value_off = le16_to_cpu(cc->DataOffset);
> > +             value_len = le32_to_cpu(cc->DataLength);
>
> same here: possible overflow checks needed?
>
> > +
> > +             if ((next & 0x7) != 0 ||
> > +                 name_off != 16 ||
> > +                 name_len < 4 ||
> > +                 (char *)cc + name_off + name_len > data_end ||
> > +                 (value_off & 0x7) != 0 ||
> > +                 (value_off && value_off < name_off + name_len) ||
>
> I guess this must be
>
>             (value_off && (value_off < name_off + name_len)) ||
>
> > +                 (char *)cc + value_off + value_len > data_end)
> > +                     return ERR_PTR(-EINVAL);
> > +
> > +             name = (char *)cc + name_off;
> > +             if (memcmp(name, tag, name_len) == 0)
> > +                     return cc;
> >       } while (next != 0);
> >
> >       return NULL;
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index c86164dc70bb..976490bfd93c 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -2377,6 +2377,10 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
> >       ksmbd_debug(SMB,
> >                   "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");
> >       sd_buf = (struct create_sd_buf_req *)context;
> > +     if (le16_to_cpu(context->DataOffset) +
> > +         le32_to_cpu(context->DataLength) <
> > +         sizeof(struct create_sd_buf_req))
> > +             return -EINVAL;
> >       return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
> >                           le32_to_cpu(sd_buf->ccontext.DataLength), true);
> >   }
> > @@ -2577,6 +2581,12 @@ int smb2_open(struct ksmbd_work *work)
> >                       goto err_out1;
> >               } else if (context) {
> >                       ea_buf = (struct create_ea_buf_req *)context;
> > +                     if (le16_to_cpu(context->DataOffset) +
> > +                         le32_to_cpu(context->DataLength) <
> > +                         sizeof(struct create_ea_buf_req)) {
> > +                             rc = -EINVAL;
> > +                             goto err_out1;
> > +                     }
> >                       if (req->CreateOptions & FILE_NO_EA_KNOWLEDGE_LE) {
> >                               rsp->hdr.Status = STATUS_ACCESS_DENIED;
> >                               rc = -EACCES;
> > @@ -2615,6 +2625,12 @@ int smb2_open(struct ksmbd_work *work)
> >                       } else if (context) {
> >                               struct create_posix *posix =
> >                                       (struct create_posix *)context;
> > +                             if (le16_to_cpu(context->DataOffset) +
> > +                                 le32_to_cpu(context->DataLength) <
> > +                                 sizeof(struct create_posix)) {
> > +                                     rc = -EINVAL;
> > +                                     goto err_out1;
> > +                             }
> >                               ksmbd_debug(SMB, "get posix context\n");
> >
> >                               posix_mode = le32_to_cpu(posix->Mode);
> > @@ -3019,9 +3035,16 @@ int smb2_open(struct ksmbd_work *work)
> >                       rc = PTR_ERR(az_req);
> >                       goto err_out;
> >               } else if (az_req) {
> > -                     loff_t alloc_size = le64_to_cpu(az_req->AllocationSize);
> > +                     loff_t alloc_size;
> >                       int err;
> >
> > +                     if (le16_to_cpu(az_req->ccontext.DataOffset) +
> > +                         le32_to_cpu(az_req->ccontext.DataLength) <
> > +                         sizeof(struct create_alloc_size_req)) {
> > +                             rc = -EINVAL;
> > +                             goto err_out;
> > +                     }
> > +                     alloc_size = le64_to_cpu(az_req->AllocationSize);
> >                       ksmbd_debug(SMB,
> >                                   "request smb2 create allocate size : %llu\n",
> >                                   alloc_size);
> > diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
> > index 0a95cdec8c80..f67567e1e178 100644
> > --- a/fs/ksmbd/smbacl.c
> > +++ b/fs/ksmbd/smbacl.c
> > @@ -392,7 +392,7 @@ static void parse_dacl(struct user_namespace *user_ns,
> >               return;
> >
> >       /* validate that we do not go past end of acl */
> > -     if (end_of_acl <= (char *)pdacl ||
> > +     if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
> >           end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
> >               pr_err("ACL too small to parse DACL\n");
> >               return;
> > @@ -434,6 +434,10 @@ static void parse_dacl(struct user_namespace *user_ns,
> >               ppace[i] = (struct smb_ace *)(acl_base + acl_size);
> >               acl_base = (char *)ppace[i];
> >               acl_size = le16_to_cpu(ppace[i]->size);
>
> overflow check needed?
>
> > +
> > +             if (acl_base + acl_size > end_of_acl)
> > +                     break;
> > +
> >               ppace[i]->access_req =
> >                       smb_map_generic_desired_access(ppace[i]->access_req);
> >
> > @@ -807,6 +811,9 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
> >       if (!pntsd)
> >               return -EIO;
> >
> > +     if (acl_len < sizeof(struct smb_ntsd))
> > +             return -EINVAL;
> > +
> >       owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
> >                       le32_to_cpu(pntsd->osidoffset));
> >       group_sid_ptr = (struct smb_sid *)((char *)pntsd +
> >

Agree with Ralph.
Overflow checks needs in all these places. But there are several ways
to do them.
Note that the maximum stream length is 0x00ffffff  which means that
every Offset or Length must be
< 0x01000000
If you check every single Length and Offset for < 0x01000000   then
overflow can not happen.
(well, at least Offset + Length can not overflow)


>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
