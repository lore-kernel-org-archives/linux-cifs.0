Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24DCC43219
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 16:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbiCUQdW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351211AbiCUQcs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 12:32:48 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2CE103BB2
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 09:31:20 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 17so20661544lji.1
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 09:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QWA6kyiwDeRh34QKHmPOM/9FgZ9xudeeu/5Yl3qcf1s=;
        b=JUCEvacyEngt4mjXp7LJ+lJvW1G9Df2Wx9BFmVqJ8ObdSghysRpdZqPCOohOEPdson
         sZqAvzYiwGktx3ru/ZExDg9rzzZaM3ppM4pRfcDJkcJvBtOZbFsfw8c0H8HI/281Cpvw
         ky5BG1l7SsANYcMSSMQ6e9u6phqMSwHKhIPekjPwA1q7PtRuBLNBIIrgDBB5Bk/y41r5
         NyHAgIbcygVgdfqo8uPwO+KXKSSRfTS/Y/FjbFOX8NP+eSkWMSVKaLfC8VZ7+5GQ3rNs
         T32yUx96K159nDRty/Qljyek/7G1gDc7h4CNjrLZTPDnZW3Q/YCFIONkyctU7mqZxuag
         KL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QWA6kyiwDeRh34QKHmPOM/9FgZ9xudeeu/5Yl3qcf1s=;
        b=uD0gjny5pZSNSOIAuNO8bWzILIL2wBA/D6WvnqElnkkoHgdEpZhqUIPTSrzSXra7cs
         q3AqWNSFndpZ5BPs/3Xs/na6j8hO5Wjhy5vvO4bsPFChhWuXZX3GQ1TpnBiZrsif0kkL
         SSyqnUVSSWdS5bmQliX+dM6r8ktCIpcUgrcAg03juKxkBBJnHRx0wuIj0jSXtdXaYm+R
         3F+CHSpJLfV8oe/hUjK/ERPWLDUgG00WrWhdcjGlpmLxBMUoaFmlINBwf4hrznVDtLP8
         Tnw7Wow+5/K2SKf18VjV1fkG22aE8qUCaDIR41Eh3miVLRlImhziVsgX1ADuEvWh/sEn
         hhGQ==
X-Gm-Message-State: AOAM530i+QjHjk2HW8jCiDdrOsd8beunhJIgUy7BrU9r1VKvUoXD5x4b
        EX5wuGO/Tgopura3y8qkBg+CNRFQ6Qk1jMdF7qC117LF
X-Google-Smtp-Source: ABdhPJyGz5A1Uc4Dq+p3Vmdd4stPOnBTXWAwoDhv8ms0bnv0fBcoT2g1DUeGpaxEibV50AyKQ1KX2KWTOGSqiaMBUUo=
X-Received: by 2002:a05:651c:1597:b0:247:f79c:5794 with SMTP id
 h23-20020a05651c159700b00247f79c5794mr15472652ljq.398.1647880276813; Mon, 21
 Mar 2022 09:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220321160826.30814-1-pc@cjr.nz> <20220321160826.30814-2-pc@cjr.nz>
In-Reply-To: <20220321160826.30814-2-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 21 Mar 2022 11:31:05 -0500
Message-ID: <CAH2r5mtOgCse9sUfAVEJk4ZVhnGDnCyCe4VSXzAaS2GrOMKYpA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: store fids as opaque u64 integers
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It is also clearer to not convert them (better matches the
documentation MS-SMB2) and also slightly faster on big endian.

On Mon, Mar 21, 2022 at 11:09 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> There is no need to store the fids as le64 integers as they are opaque
> to the client and only used for equality.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/ksmbd/smb2pdu.c | 94 +++++++++++++++++++---------------------------
>  fs/ksmbd/smb2pdu.h | 34 ++++++++---------
>  2 files changed, 56 insertions(+), 72 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 67e8e28e3fc3..5440d61cea9f 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -377,12 +377,8 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
>          * command in the compound request
>          */
>         if (req->Command == SMB2_CREATE && rsp->Status == STATUS_SUCCESS) {
> -               work->compound_fid =
> -                       le64_to_cpu(((struct smb2_create_rsp *)rsp)->
> -                               VolatileFileId);
> -               work->compound_pfid =
> -                       le64_to_cpu(((struct smb2_create_rsp *)rsp)->
> -                               PersistentFileId);
> +               work->compound_fid = ((struct smb2_create_rsp *)rsp)->VolatileFileId;
> +               work->compound_pfid = ((struct smb2_create_rsp *)rsp)->PersistentFileId;
>                 work->compound_sid = le64_to_cpu(rsp->SessionId);
>         }
>
> @@ -2129,7 +2125,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
>         rsp->EndofFile = cpu_to_le64(0);
>         rsp->FileAttributes = FILE_ATTRIBUTE_NORMAL_LE;
>         rsp->Reserved2 = 0;
> -       rsp->VolatileFileId = cpu_to_le64(id);
> +       rsp->VolatileFileId = id;
>         rsp->PersistentFileId = 0;
>         rsp->CreateContextsOffset = 0;
>         rsp->CreateContextsLength = 0;
> @@ -3157,8 +3153,8 @@ int smb2_open(struct ksmbd_work *work)
>
>         rsp->Reserved2 = 0;
>
> -       rsp->PersistentFileId = cpu_to_le64(fp->persistent_id);
> -       rsp->VolatileFileId = cpu_to_le64(fp->volatile_id);
> +       rsp->PersistentFileId = fp->persistent_id;
> +       rsp->VolatileFileId = fp->volatile_id;
>
>         rsp->CreateContextsOffset = 0;
>         rsp->CreateContextsLength = 0;
> @@ -3865,9 +3861,7 @@ int smb2_query_dir(struct ksmbd_work *work)
>                 goto err_out2;
>         }
>
> -       dir_fp = ksmbd_lookup_fd_slow(work,
> -                                     le64_to_cpu(req->VolatileFileId),
> -                                     le64_to_cpu(req->PersistentFileId));
> +       dir_fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>         if (!dir_fp) {
>                 rc = -EBADF;
>                 goto err_out2;
> @@ -4088,12 +4082,12 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
>          * Windows can sometime send query file info request on
>          * pipe without opening it, checking error condition here
>          */
> -       id = le64_to_cpu(req->VolatileFileId);
> +       id = req->VolatileFileId;
>         if (!ksmbd_session_rpc_method(sess, id))
>                 return -ENOENT;
>
>         ksmbd_debug(SMB, "FileInfoClass %u, FileId 0x%llx\n",
> -                   req->FileInfoClass, le64_to_cpu(req->VolatileFileId));
> +                   req->FileInfoClass, req->VolatileFileId);
>
>         switch (req->FileInfoClass) {
>         case FILE_STANDARD_INFORMATION:
> @@ -4738,7 +4732,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
>         }
>
>         if (work->next_smb2_rcv_hdr_off) {
> -               if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +               if (!has_file_id(req->VolatileFileId)) {
>                         ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>                                     work->compound_fid);
>                         id = work->compound_fid;
> @@ -4747,8 +4741,8 @@ static int smb2_get_info_file(struct ksmbd_work *work,
>         }
>
>         if (!has_file_id(id)) {
> -               id = le64_to_cpu(req->VolatileFileId);
> -               pid = le64_to_cpu(req->PersistentFileId);
> +               id = req->VolatileFileId;
> +               pid = req->PersistentFileId;
>         }
>
>         fp = ksmbd_lookup_fd_slow(work, id, pid);
> @@ -5113,7 +5107,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
>         }
>
>         if (work->next_smb2_rcv_hdr_off) {
> -               if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +               if (!has_file_id(req->VolatileFileId)) {
>                         ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>                                     work->compound_fid);
>                         id = work->compound_fid;
> @@ -5122,8 +5116,8 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
>         }
>
>         if (!has_file_id(id)) {
> -               id = le64_to_cpu(req->VolatileFileId);
> -               pid = le64_to_cpu(req->PersistentFileId);
> +               id = req->VolatileFileId;
> +               pid = req->PersistentFileId;
>         }
>
>         fp = ksmbd_lookup_fd_slow(work, id, pid);
> @@ -5221,7 +5215,7 @@ static noinline int smb2_close_pipe(struct ksmbd_work *work)
>         struct smb2_close_req *req = smb2_get_msg(work->request_buf);
>         struct smb2_close_rsp *rsp = smb2_get_msg(work->response_buf);
>
> -       id = le64_to_cpu(req->VolatileFileId);
> +       id = req->VolatileFileId;
>         ksmbd_session_rpc_close(work->sess, id);
>
>         rsp->StructureSize = cpu_to_le16(60);
> @@ -5280,7 +5274,7 @@ int smb2_close(struct ksmbd_work *work)
>         }
>
>         if (work->next_smb2_rcv_hdr_off &&
> -           !has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +           !has_file_id(req->VolatileFileId)) {
>                 if (!has_file_id(work->compound_fid)) {
>                         /* file already closed, return FILE_CLOSED */
>                         ksmbd_debug(SMB, "file already closed\n");
> @@ -5299,7 +5293,7 @@ int smb2_close(struct ksmbd_work *work)
>                         work->compound_pfid = KSMBD_NO_FID;
>                 }
>         } else {
> -               volatile_id = le64_to_cpu(req->VolatileFileId);
> +               volatile_id = req->VolatileFileId;
>         }
>         ksmbd_debug(SMB, "volatile_id = %llu\n", volatile_id);
>
> @@ -5988,7 +5982,7 @@ int smb2_set_info(struct ksmbd_work *work)
>         if (work->next_smb2_rcv_hdr_off) {
>                 req = ksmbd_req_buf_next(work);
>                 rsp = ksmbd_resp_buf_next(work);
> -               if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +               if (!has_file_id(req->VolatileFileId)) {
>                         ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>                                     work->compound_fid);
>                         id = work->compound_fid;
> @@ -6000,8 +5994,8 @@ int smb2_set_info(struct ksmbd_work *work)
>         }
>
>         if (!has_file_id(id)) {
> -               id = le64_to_cpu(req->VolatileFileId);
> -               pid = le64_to_cpu(req->PersistentFileId);
> +               id = req->VolatileFileId;
> +               pid = req->PersistentFileId;
>         }
>
>         fp = ksmbd_lookup_fd_slow(work, id, pid);
> @@ -6079,7 +6073,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
>         struct smb2_read_req *req = smb2_get_msg(work->request_buf);
>         struct smb2_read_rsp *rsp = smb2_get_msg(work->response_buf);
>
> -       id = le64_to_cpu(req->VolatileFileId);
> +       id = req->VolatileFileId;
>
>         inc_rfc1001_len(work->response_buf, 16);
>         rpc_resp = ksmbd_rpc_read(work->sess, id);
> @@ -6215,8 +6209,7 @@ int smb2_read(struct ksmbd_work *work)
>                         goto out;
>         }
>
> -       fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
> -                                 le64_to_cpu(req->PersistentFileId));
> +       fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>         if (!fp) {
>                 err = -ENOENT;
>                 goto out;
> @@ -6335,7 +6328,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
>         size_t length;
>
>         length = le32_to_cpu(req->Length);
> -       id = le64_to_cpu(req->VolatileFileId);
> +       id = req->VolatileFileId;
>
>         if (le16_to_cpu(req->DataOffset) ==
>             offsetof(struct smb2_write_req, Buffer)) {
> @@ -6471,8 +6464,7 @@ int smb2_write(struct ksmbd_work *work)
>                 goto out;
>         }
>
> -       fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
> -                                 le64_to_cpu(req->PersistentFileId));
> +       fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>         if (!fp) {
>                 err = -ENOENT;
>                 goto out;
> @@ -6584,12 +6576,9 @@ int smb2_flush(struct ksmbd_work *work)
>
>         WORK_BUFFERS(work, req, rsp);
>
> -       ksmbd_debug(SMB, "SMB2_FLUSH called for fid %llu\n",
> -                   le64_to_cpu(req->VolatileFileId));
> +       ksmbd_debug(SMB, "SMB2_FLUSH called for fid %llu\n", req->VolatileFileId);
>
> -       err = ksmbd_vfs_fsync(work,
> -                             le64_to_cpu(req->VolatileFileId),
> -                             le64_to_cpu(req->PersistentFileId));
> +       err = ksmbd_vfs_fsync(work, req->VolatileFileId, req->PersistentFileId);
>         if (err)
>                 goto out;
>
> @@ -6804,12 +6793,9 @@ int smb2_lock(struct ksmbd_work *work)
>         int prior_lock = 0;
>
>         ksmbd_debug(SMB, "Received lock request\n");
> -       fp = ksmbd_lookup_fd_slow(work,
> -                                 le64_to_cpu(req->VolatileFileId),
> -                                 le64_to_cpu(req->PersistentFileId));
> +       fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>         if (!fp) {
> -               ksmbd_debug(SMB, "Invalid file id for lock : %llu\n",
> -                           le64_to_cpu(req->VolatileFileId));
> +               ksmbd_debug(SMB, "Invalid file id for lock : %llu\n", req->VolatileFileId);
>                 err = -ENOENT;
>                 goto out2;
>         }
> @@ -7164,8 +7150,8 @@ static int fsctl_copychunk(struct ksmbd_work *work,
>
>         ci_rsp = (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>
> -       rsp->VolatileFileId = cpu_to_le64(volatile_id);
> -       rsp->PersistentFileId = cpu_to_le64(persistent_id);
> +       rsp->VolatileFileId = volatile_id;
> +       rsp->PersistentFileId = persistent_id;
>         ci_rsp->ChunksWritten =
>                 cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>         ci_rsp->ChunkBytesWritten =
> @@ -7379,8 +7365,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
>         if (nii_rsp)
>                 nii_rsp->Next = 0;
>
> -       rsp->PersistentFileId = cpu_to_le64(SMB2_NO_FID);
> -       rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
> +       rsp->PersistentFileId = SMB2_NO_FID;
> +       rsp->VolatileFileId = SMB2_NO_FID;
>         return nbytes;
>  }
>
> @@ -7547,9 +7533,7 @@ static int fsctl_request_resume_key(struct ksmbd_work *work,
>  {
>         struct ksmbd_file *fp;
>
> -       fp = ksmbd_lookup_fd_slow(work,
> -                                 le64_to_cpu(req->VolatileFileId),
> -                                 le64_to_cpu(req->PersistentFileId));
> +       fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
>         if (!fp)
>                 return -ENOENT;
>
> @@ -7579,7 +7563,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>         if (work->next_smb2_rcv_hdr_off) {
>                 req = ksmbd_req_buf_next(work);
>                 rsp = ksmbd_resp_buf_next(work);
> -               if (!has_file_id(le64_to_cpu(req->VolatileFileId))) {
> +               if (!has_file_id(req->VolatileFileId)) {
>                         ksmbd_debug(SMB, "Compound request set FID = %llu\n",
>                                     work->compound_fid);
>                         id = work->compound_fid;
> @@ -7590,7 +7574,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>         }
>
>         if (!has_file_id(id))
> -               id = le64_to_cpu(req->VolatileFileId);
> +               id = req->VolatileFileId;
>
>         if (req->Flags != cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL)) {
>                 rsp->hdr.Status = STATUS_NOT_SUPPORTED;
> @@ -7656,8 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>                         goto out;
>
>                 nbytes = sizeof(struct validate_negotiate_info_rsp);
> -               rsp->PersistentFileId = cpu_to_le64(SMB2_NO_FID);
> -               rsp->VolatileFileId = cpu_to_le64(SMB2_NO_FID);
> +               rsp->PersistentFileId = SMB2_NO_FID;
> +               rsp->VolatileFileId = SMB2_NO_FID;
>                 break;
>         case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
>                 ret = fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
> @@ -7705,8 +7689,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>                                 (struct copychunk_ioctl_req *)&req->Buffer[0],
>                                 le32_to_cpu(req->CntCode),
>                                 le32_to_cpu(req->InputCount),
> -                               le64_to_cpu(req->VolatileFileId),
> -                               le64_to_cpu(req->PersistentFileId),
> +                               req->VolatileFileId,
> +                               req->PersistentFileId,
>                                 rsp);
>                 break;
>         case FSCTL_SET_SPARSE:
> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
> index 725b800c29c8..fd3df8b71687 100644
> --- a/fs/ksmbd/smb2pdu.h
> +++ b/fs/ksmbd/smb2pdu.h
> @@ -116,8 +116,8 @@ struct create_durable_reconn_req {
>         union {
>                 __u8  Reserved[16];
>                 struct {
> -                       __le64 PersistentFileId;
> -                       __le64 VolatileFileId;
> +                       __u64 PersistentFileId;
> +                       __u64 VolatileFileId;
>                 } Fid;
>         } Data;
>  } __packed;
> @@ -126,8 +126,8 @@ struct create_durable_reconn_v2_req {
>         struct create_context ccontext;
>         __u8   Name[8];
>         struct {
> -               __le64 PersistentFileId;
> -               __le64 VolatileFileId;
> +               __u64 PersistentFileId;
> +               __u64 VolatileFileId;
>         } Fid;
>         __u8 CreateGuid[16];
>         __le32 Flags;
> @@ -269,8 +269,8 @@ struct smb2_ioctl_req {
>         __le16 StructureSize; /* Must be 57 */
>         __le16 Reserved; /* offset from start of SMB2 header to write data */
>         __le32 CntCode;
> -       __le64  PersistentFileId;
> -       __le64  VolatileFileId;
> +       __u64  PersistentFileId;
> +       __u64  VolatileFileId;
>         __le32 InputOffset; /* Reserved MBZ */
>         __le32 InputCount;
>         __le32 MaxInputResponse;
> @@ -287,8 +287,8 @@ struct smb2_ioctl_rsp {
>         __le16 StructureSize; /* Must be 49 */
>         __le16 Reserved; /* offset from start of SMB2 header to write data */
>         __le32 CntCode;
> -       __le64  PersistentFileId;
> -       __le64  VolatileFileId;
> +       __u64  PersistentFileId;
> +       __u64  VolatileFileId;
>         __le32 InputOffset; /* Reserved MBZ */
>         __le32 InputCount;
>         __le32 OutputOffset;
> @@ -357,7 +357,7 @@ struct file_object_buf_type1_ioctl_rsp {
>  } __packed;
>
>  struct resume_key_ioctl_rsp {
> -       __le64 ResumeKey[3];
> +       __u64 ResumeKey[3];
>         __le32 ContextLength;
>         __u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
>  } __packed;
> @@ -432,8 +432,8 @@ struct smb2_lock_req {
>         __le16 StructureSize; /* Must be 48 */
>         __le16 LockCount;
>         __le32 Reserved;
> -       __le64  PersistentFileId;
> -       __le64  VolatileFileId;
> +       __u64  PersistentFileId;
> +       __u64  VolatileFileId;
>         /* Followed by at least one */
>         struct smb2_lock_element locks[1];
>  } __packed;
> @@ -468,8 +468,8 @@ struct smb2_query_directory_req {
>         __u8   FileInformationClass;
>         __u8   Flags;
>         __le32 FileIndex;
> -       __le64  PersistentFileId;
> -       __le64  VolatileFileId;
> +       __u64  PersistentFileId;
> +       __u64  VolatileFileId;
>         __le16 FileNameOffset;
>         __le16 FileNameLength;
>         __le32 OutputBufferLength;
> @@ -515,8 +515,8 @@ struct smb2_query_info_req {
>         __le32 InputBufferLength;
>         __le32 AdditionalInformation;
>         __le32 Flags;
> -       __le64  PersistentFileId;
> -       __le64  VolatileFileId;
> +       __u64  PersistentFileId;
> +       __u64  VolatileFileId;
>         __u8   Buffer[1];
>  } __packed;
>
> @@ -537,8 +537,8 @@ struct smb2_set_info_req {
>         __le16 BufferOffset;
>         __u16  Reserved;
>         __le32 AdditionalInformation;
> -       __le64  PersistentFileId;
> -       __le64  VolatileFileId;
> +       __u64  PersistentFileId;
> +       __u64  VolatileFileId;
>         __u8   Buffer[1];
>  } __packed;
>
> --
> 2.35.1
>


-- 
Thanks,

Steve
