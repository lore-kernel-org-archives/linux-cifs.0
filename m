Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCF8C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 23:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B516115A
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 23:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhIVX2K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 19:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231259AbhIVX2K (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 19:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1426061050
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 23:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632353200;
        bh=aTKt3rUZdjAiGudPKf1cKWtrmYSttCypZ8ir/MvPU3c=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=LR/DDw4qT9ukLONYPfE5SeEtLyI+g6iFUEIICNU/n8HJksG5q79T+Htp/HZ/N0noq
         2sphtwpOJmIvtp7yGgZe0At8vPyaJ2ZZWjGKpe/SGRimBaSKUpfCug7wYrsL7SR8QB
         kwj70yEN6YQ1QNo48qC6LLsy2/UxsOVAFCiB1Fmf0adninbnP3tn8xVBtMFJLqMCFI
         iJIqRdT8ZczKvJlBzDRcbDadWi8fzTaSXepvXaXdAj/N3T3kQMbhrNf99JIF9poYBB
         je509dAYbviWxr/DCn9Bp4Y8b3dGUk4Vl5Sc+UuWWu7QKvQ9zxAd3Jqx6Q0ixQUR7Z
         jWMvvX3rd9WCA==
Received: by mail-oi1-f171.google.com with SMTP id y201so7057058oie.3
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 16:26:40 -0700 (PDT)
X-Gm-Message-State: AOAM532p5GWuwUzxfmOtSQHh5oRifS2JTYcdO3qXgfjiDIHCocF1pw2n
        BgdBZij5+iIOHLxAsh9EeHJgUaB2PAZ0IBMiWhU=
X-Google-Smtp-Source: ABdhPJxChD1P2L3fxijlpOezKHqA/JV8L/5zPCNDPAjZu0PrTSDYXmHKuOELVoFnS9KgyL2zovx9k8ffij+CksDqnn4=
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr4705811oib.138.1632353199468;
 Wed, 22 Sep 2021 16:26:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 22 Sep 2021 16:26:39
 -0700 (PDT)
In-Reply-To: <CAN05THTmB=TWLEmSB1so9KnM7zG0D4i3J6NnksXW5=zX+UxQtA@mail.gmail.com>
References: <20210922012651.513888-1-hyc.lee@gmail.com> <90804f93-9a51-9562-758f-b63ab71c9f74@samba.org>
 <CAN05THTmB=TWLEmSB1so9KnM7zG0D4i3J6NnksXW5=zX+UxQtA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Sep 2021 08:26:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8JBd_VLOKvcJ24fRLiw8yEWE5O+OJRydRqJjZpN67jKw@mail.gmail.com>
Message-ID: <CAKYAXd8JBd_VLOKvcJ24fRLiw8yEWE5O+OJRydRqJjZpN67jKw@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ralph Boehme <slow@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-23 6:39 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> On Wed, Sep 22, 2021 at 11:08 PM Ralph Boehme <slow@samba.org> wrote:
>>
>> Hi Hyunchul,
>>
>> patch looks excellent, few more nitpicks below.
>>
>> Am 22.09.21 um 03:26 schrieb Hyunchul Lee:
>> > Add buffer validation for SMB2_CREATE_CONTEXT.
>> >
>> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> > Cc: Ralph Boehme <slow@samba.org>
>> > Cc: Steve French <smfrench@gmail.com>
>> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> > ---
>> > Changes from v2:
>> >   - check struct create_context's fields more in smb2_find_context_vals
>> >     (suggested by Ralph Boehme).
>> >
>> >   fs/ksmbd/oplock.c  | 34 ++++++++++++++++++++++++----------
>> >   fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
>> >   fs/ksmbd/smbacl.c  |  9 ++++++++-
>> >   3 files changed, 56 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
>> > index 16b6236d1bd2..8f743913b1cf 100644
>> > --- a/fs/ksmbd/oplock.c
>> > +++ b/fs/ksmbd/oplock.c
>> > @@ -1451,26 +1451,40 @@ struct lease_ctx_info *parse_lease_state(void
>> > *open_req)
>> >    */
>> >   struct create_context *smb2_find_context_vals(void *open_req, const
>> > char *tag)
>> >   {
>> > -     char *data_offset;
>> > +     struct smb2_create_req *req = (struct smb2_create_req *)open_req;
>> >       struct create_context *cc;
>> > -     unsigned int next = 0;
>> > +     char *data_offset, *data_end;
>> >       char *name;
>> > -     struct smb2_create_req *req = (struct smb2_create_req *)open_req;
>>
>> this line is only moved, not changed. Can we remove this change from the
>> diff?
>>
>> > +     unsigned int next = 0;
>> > +     unsigned int name_off, name_len, value_off, value_len;
>> >
>> >       data_offset = (char *)req + 4 +
>> > le32_to_cpu(req->CreateContextsOffset);
>> > +     data_end = data_offset + le32_to_cpu(req->CreateContextsLength);
>>
>> do we need overflow checks here? At least on 32-bit arch this could
>> easily overflow.
>>
>> >       cc = (struct create_context *)data_offset;
>> >       do {
>> > -             int val;
>> > -
>> >               cc = (struct create_context *)((char *)cc + next);
>> > -             name = le16_to_cpu(cc->NameOffset) + (char *)cc;
>> > -             val = le16_to_cpu(cc->NameLength);
>> > -             if (val < 4)
>> > +             if ((char *)cc + offsetof(struct create_context, Buffer)
>> > >
>> > +                 data_end)
>> >                       return ERR_PTR(-EINVAL);
>> >
>> > -             if (memcmp(name, tag, val) == 0)
>> > -                     return cc;
>> >               next = le32_to_cpu(cc->Next);
>> > +             name_off = le16_to_cpu(cc->NameOffset);
>> > +             name_len = le16_to_cpu(cc->NameLength);
>> > +             value_off = le16_to_cpu(cc->DataOffset);
>> > +             value_len = le32_to_cpu(cc->DataLength);
>>
>> same here: possible overflow checks needed?
>>
>> > +
>> > +             if ((next & 0x7) != 0 ||
>> > +                 name_off != 16 ||
>> > +                 name_len < 4 ||
>> > +                 (char *)cc + name_off + name_len > data_end ||
>> > +                 (value_off & 0x7) != 0 ||
>> > +                 (value_off && value_off < name_off + name_len) ||
>>
>> I guess this must be
>>
>>             (value_off && (value_off < name_off + name_len)) ||
>>
>> > +                 (char *)cc + value_off + value_len > data_end)
>> > +                     return ERR_PTR(-EINVAL);
>> > +
>> > +             name = (char *)cc + name_off;
>> > +             if (memcmp(name, tag, name_len) == 0)
>> > +                     return cc;
>> >       } while (next != 0);
>> >
>> >       return NULL;
>> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> > index c86164dc70bb..976490bfd93c 100644
>> > --- a/fs/ksmbd/smb2pdu.c
>> > +++ b/fs/ksmbd/smb2pdu.c
>> > @@ -2377,6 +2377,10 @@ static int smb2_create_sd_buffer(struct
>> > ksmbd_work *work,
>> >       ksmbd_debug(SMB,
>> >                   "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");
>> >       sd_buf = (struct create_sd_buf_req *)context;
>> > +     if (le16_to_cpu(context->DataOffset) +
>> > +         le32_to_cpu(context->DataLength) <
>> > +         sizeof(struct create_sd_buf_req))
>> > +             return -EINVAL;
>> >       return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
>> >                           le32_to_cpu(sd_buf->ccontext.DataLength),
>> > true);
>> >   }
>> > @@ -2577,6 +2581,12 @@ int smb2_open(struct ksmbd_work *work)
>> >                       goto err_out1;
>> >               } else if (context) {
>> >                       ea_buf = (struct create_ea_buf_req *)context;
>> > +                     if (le16_to_cpu(context->DataOffset) +
>> > +                         le32_to_cpu(context->DataLength) <
>> > +                         sizeof(struct create_ea_buf_req)) {
>> > +                             rc = -EINVAL;
>> > +                             goto err_out1;
>> > +                     }
>> >                       if (req->CreateOptions & FILE_NO_EA_KNOWLEDGE_LE)
>> > {
>> >                               rsp->hdr.Status = STATUS_ACCESS_DENIED;
>> >                               rc = -EACCES;
>> > @@ -2615,6 +2625,12 @@ int smb2_open(struct ksmbd_work *work)
>> >                       } else if (context) {
>> >                               struct create_posix *posix =
>> >                                       (struct create_posix *)context;
>> > +                             if (le16_to_cpu(context->DataOffset) +
>> > +                                 le32_to_cpu(context->DataLength) <
>> > +                                 sizeof(struct create_posix)) {
>> > +                                     rc = -EINVAL;
>> > +                                     goto err_out1;
>> > +                             }
>> >                               ksmbd_debug(SMB, "get posix context\n");
>> >
>> >                               posix_mode = le32_to_cpu(posix->Mode);
>> > @@ -3019,9 +3035,16 @@ int smb2_open(struct ksmbd_work *work)
>> >                       rc = PTR_ERR(az_req);
>> >                       goto err_out;
>> >               } else if (az_req) {
>> > -                     loff_t alloc_size =
>> > le64_to_cpu(az_req->AllocationSize);
>> > +                     loff_t alloc_size;
>> >                       int err;
>> >
>> > +                     if (le16_to_cpu(az_req->ccontext.DataOffset) +
>> > +                         le32_to_cpu(az_req->ccontext.DataLength) <
>> > +                         sizeof(struct create_alloc_size_req)) {
>> > +                             rc = -EINVAL;
>> > +                             goto err_out;
>> > +                     }
>> > +                     alloc_size = le64_to_cpu(az_req->AllocationSize);
>> >                       ksmbd_debug(SMB,
>> >                                   "request smb2 create allocate size :
>> > %llu\n",
>> >                                   alloc_size);
>> > diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
>> > index 0a95cdec8c80..f67567e1e178 100644
>> > --- a/fs/ksmbd/smbacl.c
>> > +++ b/fs/ksmbd/smbacl.c
>> > @@ -392,7 +392,7 @@ static void parse_dacl(struct user_namespace
>> > *user_ns,
>> >               return;
>> >
>> >       /* validate that we do not go past end of acl */
>> > -     if (end_of_acl <= (char *)pdacl ||
>> > +     if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
>> >           end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
>> >               pr_err("ACL too small to parse DACL\n");
>> >               return;
>> > @@ -434,6 +434,10 @@ static void parse_dacl(struct user_namespace
>> > *user_ns,
>> >               ppace[i] = (struct smb_ace *)(acl_base + acl_size);
>> >               acl_base = (char *)ppace[i];
>> >               acl_size = le16_to_cpu(ppace[i]->size);
>>
>> overflow check needed?
>>
>> > +
>> > +             if (acl_base + acl_size > end_of_acl)
>> > +                     break;
>> > +
>> >               ppace[i]->access_req =
>> >
>> > smb_map_generic_desired_access(ppace[i]->access_req);
>> >
>> > @@ -807,6 +811,9 @@ int parse_sec_desc(struct user_namespace *user_ns,
>> > struct smb_ntsd *pntsd,
>> >       if (!pntsd)
>> >               return -EIO;
>> >
>> > +     if (acl_len < sizeof(struct smb_ntsd))
>> > +             return -EINVAL;
>> > +
>> >       owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
>> >                       le32_to_cpu(pntsd->osidoffset));
>> >       group_sid_ptr = (struct smb_sid *)((char *)pntsd +
>> >
>
> Agree with Ralph.
> Overflow checks needs in all these places. But there are several ways
> to do them.
> Note that the maximum stream length is 0x00ffffff  which means that
> every Offset or Length must be
> < 0x01000000
> If you check every single Length and Offset for < 0x01000000   then
> overflow can not happen.
> (well, at least Offset + Length can not overflow)
Thanks for detailed explanation!
>
>
>>
>> Thanks!
>> -slow
>>
>> --
>> Ralph Boehme, Samba Team                 https://samba.org/
>> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>>
>
