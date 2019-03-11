Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00912C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 12:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E112075C
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 12:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHSkfEyH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfCKMC5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:02:57 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41153 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfCKMC5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Mar 2019 08:02:57 -0400
Received: by mail-qk1-f193.google.com with SMTP id o129so557782qke.8
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 05:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ziItSQYq9yhyd2WFYhpbg+emdc3t/e65woAFzdBYfc=;
        b=RHSkfEyHSKPPGMEt+U4hKEDE66ySEKH/dtueEYpLqua7Lt6l5YhVrwKR6Fec2sF/4R
         9DolGBRURtJDU3sTo5hKVO0TutSlyq8/WrFHbreuMxJ8UbOGcIgJsjxTEK3bNUW5B1dF
         0Iv3a/VjsDTfBINjN2NCiUOVQ8H554k/gML7r9oerZyWWHsC3K2VDgUi0vhnpnQKvQ1U
         +6PJmWUm7ede3OGZVs2nH6/EaH7sNxeC9W4m7CGj3Qzy24TeAne14hylfEoJv6v3k7SK
         5SziWjPBFkvAE27Ep45GdReA7TZK+my39fx9Z7ETwzd2YAibex/eEIzCzxIkooTb2srB
         kRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ziItSQYq9yhyd2WFYhpbg+emdc3t/e65woAFzdBYfc=;
        b=IYcgzNDEpZ4xXd1a6B7/uV5WBN5KyIbwNhYsxjzTkO4PyIgEcNkhLWMKhMvtM8hG9X
         TLnksOQE5RsswgogTYvJak0iSYH8zf5UuO+SEPDLZ6E2dBffJiPm8qLmeCsqHISd0inW
         eq839fXfNI12sq6OLLQk1JTgbLFyB3MySAIGFdwVDbaj1tzt3NdpmFGFuv4j4/mD+qkK
         R1FwhYQPSVEa9V8N255JxKEZMnPQNwmhrcUvT5FE9kgyRpWQAVle2rUSmKY6ezRZFHb7
         PNmCGuUr/N3IcynrstTld0jBAUEB8YNjwZoDdZlppdymYhCPpztW5zQS1VfM+MDd6QL+
         iRGQ==
X-Gm-Message-State: APjAAAWcbZnzthO08WOP9MkMlVNlMi4C1YteW/E1WOxhsKDGSqxdMU+5
        o8cn6BYjEwSb1k6a8Dkxh1OUGpNRixL1710nvvA=
X-Google-Smtp-Source: APXvYqwjYXraIfqxXEl+7fFIMRaUkS7R8hdzdaLyuS1zGv+0FaFqyiBd1zWdjZ3oponGEdRljJy3a9fa6754/CePYQ0=
X-Received: by 2002:a05:620a:1348:: with SMTP id c8mr24182285qkl.246.1552305773870;
 Mon, 11 Mar 2019 05:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190311060025.9750-1-lsahlber@redhat.com> <20190311060025.9750-2-lsahlber@redhat.com>
In-Reply-To: <20190311060025.9750-2-lsahlber@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 11 Mar 2019 22:02:42 +1000
Message-ID: <CAN05THRzCvh-yq8Z3p2iearCtsr0O8gWQNJC804eZspZTcWwoQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache FILE_ALL_INFO for the shared root handle
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As a followup discussion.

We do tracing in SMB2_open() but not in SMB2_open_init().  Perhaps we
should change this to do the actual tracing in SMB2_open_init()
instead and catch ALL places where we try to open a file.
Though, we don't actually have the result of the operation in
_open_init() which means we may need to reconsider how we trace these
things.

As we will likely switch more and more things to be compounds, maybe
we should not have tracing in SMB2_open() and have it trace
trace_smb3_open_err()

Maybe we should trace "smb2_init : constructing compound"
and have trace_smb3_compound_error()


We restructure the tracing to be focused around compounds instead of
individual PDUs.
I.e. tracing in all the _init() functions, then tracing in
compound_send_recv() for success/error.

Tracing success/error on pdu/compound level instead of individual
open/close/read/...  operations.
For individual non-compounded commands we can still treat these the
same. They are just trivial compounds of one single SMB2 PDU.


On Mon, Mar 11, 2019 at 4:01 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> When we open the shared root handle also ask for FILE_ALL_INFORMATION since
> we can do this at zero cost as part of a compound.
> Cache this information as long as the lease is return and serve any
> future requests from cache.
>
> This allows us to serve "stat /<mountpoint>" directly from cache and avoid
> a network roundtrip.  Since clients ofthen need to do this quite a lot
> this improve performance slightly.
>
> As an example: xfstest generic/533 performs 43 stat operations on the root
> of the share while it is run. Which are eliminated with this patch.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h  |   3 ++
>  fs/cifs/smb2inode.c |  15 ++++---
>  fs/cifs/smb2ops.c   | 111 +++++++++++++++++++++++++++++++++++++++++++---------
>  fs/cifs/smb2pdu.c   |  12 +++---
>  fs/cifs/smb2proto.h |   3 ++
>  5 files changed, 116 insertions(+), 28 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f293e052e351..b8360ca221eb 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -962,11 +962,14 @@ cap_unix(struct cifs_ses *ses)
>
>  struct cached_fid {
>         bool is_valid:1;        /* Do we have a useable root fid */
> +       bool file_all_info_is_valid:1;
> +
>         struct kref refcount;
>         struct cifs_fid *fid;
>         struct mutex fid_mutex;
>         struct cifs_tcon *tcon;
>         struct work_struct lease_break;
> +       struct smb2_file_all_info file_all_info;
>  };
>
>  /*
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 01a76bccdb8d..b6e07e2eed10 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -309,12 +309,17 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 rc = open_shroot(xid, tcon, &fid);
>                 if (rc)
>                         goto out;
> -               rc = SMB2_query_info(xid, tcon, fid.persistent_fid,
> -                                    fid.volatile_fid, smb2_data);
> +
> +               if (tcon->crfid.file_all_info_is_valid) {
> +                       move_smb2_info_to_cifs(data,
> +                                              &tcon->crfid.file_all_info);
> +               } else {
> +                       rc = SMB2_query_info(xid, tcon, fid.persistent_fid,
> +                                            fid.volatile_fid, smb2_data);
> +                       if (!rc)
> +                               move_smb2_info_to_cifs(data, smb2_data);
> +               }
>                 close_shroot(&tcon->crfid);
> -               if (rc)
> -                       goto out;
> -               move_smb2_info_to_cifs(data, smb2_data);
>                 goto out;
>         }
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 085e91436da7..0d8bf87592ff 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -619,6 +619,7 @@ smb2_close_cached_fid(struct kref *ref)
>                 SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
>                            cfid->fid->volatile_fid);
>                 cfid->is_valid = false;
> +               cfid->file_all_info_is_valid = false;
>         }
>  }
>
> @@ -643,9 +644,18 @@ smb2_cached_lease_break(struct work_struct *work)
>   */
>  int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
>  {
> -       struct cifs_open_parms oparams;
> -       int rc;
> -       __le16 srch_path = 0; /* Null - since an open of top of share */
> +       struct cifs_ses *ses = tcon->ses;
> +       struct TCP_Server_Info *server = ses->server;
> +       struct cifs_open_parms oparms;
> +       struct smb2_create_rsp *o_rsp = NULL;
> +       struct smb2_query_info_rsp *qi_rsp = NULL;
> +       int resp_buftype[2];
> +       struct smb_rqst rqst[2];
> +       struct kvec rsp_iov[2];
> +       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> +       struct kvec qi_iov[1];
> +       int rc, flags = 0;
> +       __le16 utf16_path = 0; /* Null - since an open of top of share */
>         u8 oplock = SMB2_OPLOCK_LEVEL_II;
>
>         mutex_lock(&tcon->crfid.fid_mutex);
> @@ -657,22 +667,87 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
>                 return 0;
>         }
>
> -       oparams.tcon = tcon;
> -       oparams.create_options = 0;
> -       oparams.desired_access = FILE_READ_ATTRIBUTES;
> -       oparams.disposition = FILE_OPEN;
> -       oparams.fid = pfid;
> -       oparams.reconnect = false;
> -
> -       rc = SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, NULL);
> -       if (rc == 0) {
> -               memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> -               tcon->crfid.tcon = tcon;
> -               tcon->crfid.is_valid = true;
> -               kref_init(&tcon->crfid.refcount);
> -               kref_get(&tcon->crfid.refcount);
> -       }
> +       if (smb3_encryption_required(tcon))
> +               flags |= CIFS_TRANSFORM_REQ;
> +
> +       memset(rqst, 0, sizeof(rqst));
> +       resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
> +       memset(rsp_iov, 0, sizeof(rsp_iov));
> +
> +       /* Open */
> +       memset(&open_iov, 0, sizeof(open_iov));
> +       rqst[0].rq_iov = open_iov;
> +       rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
> +
> +       oparms.tcon = tcon;
> +       oparms.create_options = 0;
> +       oparms.desired_access = FILE_READ_ATTRIBUTES;
> +       oparms.disposition = FILE_OPEN;
> +       oparms.fid = pfid;
> +       oparms.reconnect = false;
> +
> +       rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, &utf16_path);
> +       if (rc)
> +               goto oshr_exit;
> +       smb2_set_next_command(tcon, &rqst[0]);
> +
> +       memset(&qi_iov, 0, sizeof(qi_iov));
> +       rqst[1].rq_iov = qi_iov;
> +       rqst[1].rq_nvec = 1;
> +
> +       rc = SMB2_query_info_init(tcon, &rqst[1], COMPOUND_FID,
> +                                 COMPOUND_FID, FILE_ALL_INFORMATION,
> +                                 SMB2_O_INFO_FILE, 0,
> +                                 sizeof(struct smb2_file_all_info) +
> +                                 PATH_MAX * 2, 0, NULL);
> +       if (rc)
> +               goto oshr_exit;
> +
> +       smb2_set_related(&rqst[1]);
> +
> +       rc = compound_send_recv(xid, ses, flags, 2, rqst,
> +                               resp_buftype, rsp_iov);
> +       if (rc)
> +               goto oshr_exit;
> +
> +       o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> +       oparms.fid->persistent_fid = o_rsp->PersistentFileId;
> +       oparms.fid->volatile_fid = o_rsp->VolatileFileId;
> +#ifdef CONFIG_CIFS_DEBUG2
> +       oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
> +#endif /* CIFS_DEBUG2 */
> +
> +       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
> +               oplock = smb2_parse_lease_state(server, o_rsp,
> +                                               &oparms.fid->epoch,
> +                                               oparms.fid->lease_key);
> +       else
> +               goto oshr_exit;
> +
> +
> +       memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> +       tcon->crfid.tcon = tcon;
> +       tcon->crfid.is_valid = true;
> +       kref_init(&tcon->crfid.refcount);
> +       kref_get(&tcon->crfid.refcount);
> +
> +
> +       qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> +       rc = smb2_validate_and_copy_iov(
> +                               le16_to_cpu(qi_rsp->OutputBufferOffset),
> +                               le32_to_cpu(qi_rsp->OutputBufferLength),
> +                               &rsp_iov[1], sizeof(struct smb2_file_all_info),
> +                               (char *)&tcon->crfid.file_all_info);
> +       if (rc)
> +               goto oshr_exit;
> +       tcon->crfid.file_all_info_is_valid = 1;
> +
> + oshr_exit:
>         mutex_unlock(&tcon->crfid.fid_mutex);
> +       SMB2_open_free(&rqst[0]);
> +       SMB2_query_info_free(&rqst[1]);
> +       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> +       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>         return rc;
>  }
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 60fbe306f604..cfe9fe41ccf5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1797,9 +1797,10 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
>         return buf;
>  }
>
> -static __u8
> -parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp,
> -                 unsigned int *epoch, char *lease_key)
> +__u8
> +smb2_parse_lease_state(struct TCP_Server_Info *server,
> +                      struct smb2_create_rsp *rsp,
> +                      unsigned int *epoch, char *lease_key)
>  {
>         char *data_offset;
>         struct create_context *cc;
> @@ -2456,8 +2457,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>         }
>
>         if (rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
> -               *oplock = parse_lease_state(server, rsp, &oparms->fid->epoch,
> -                                           oparms->fid->lease_key);
> +               *oplock = smb2_parse_lease_state(server, rsp,
> +                                                &oparms->fid->epoch,
> +                                                oparms->fid->lease_key);
>         else
>                 *oplock = rsp->OplockLevel;
>  creat_exit:
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 87733b27a65f..72cc563c32fe 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -223,6 +223,9 @@ extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
>
>  extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
>                                         enum securityEnum);
> +extern __u8 smb2_parse_lease_state(struct TCP_Server_Info *server,
> +                                  struct smb2_create_rsp *rsp,
> +                                  unsigned int *epoch, char *lease_key);
>  extern int smb3_encryption_required(const struct cifs_tcon *tcon);
>  extern int smb2_validate_iov(unsigned int offset, unsigned int buffer_length,
>                              struct kvec *iov, unsigned int min_buf_size);
> --
> 2.13.6
>
