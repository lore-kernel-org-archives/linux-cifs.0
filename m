Return-Path: <SRS0=pEcy=2N=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E64C2D0C0
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Dec 2019 23:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41FF420715
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Dec 2019 23:49:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLz5akAc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfLWXtE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Dec 2019 18:49:04 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38172 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfLWXtE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Dec 2019 18:49:04 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so13842580lfm.5
        for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2019 15:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WpFy1o04gGKWo/8xALRc/Gpt0eK9BshRp5zY1lyPbsw=;
        b=CLz5akAcy8lVBYLNeSRXhE8H6GOZj1QEiPHExB0gNUXixfZeEA3ORwoAqyICJzo7kg
         DKXBzZJ3RxmfywWqJ4kUegFd1MNSz3TPZY7MH7YR4Vfk7bJrnzZJWPP2T/RF4kXLvule
         2eoAERdRgX1wx7aSbTMg+1ZQ5p3q9biw3omvgUvRt7k2PErq/aNrZG1GeL3rxikFPxyW
         capVufN+u0hrC3zJV7c5pYlxZAz9njHWtUpOayIWy6MQ3TCvTeiN0KFyS+HLpPGdfNF0
         KyC/EZZxVr6aNhcUAvd3L0A7uKuQ/NgCuKbwL3ZvD0tUVAyjmywbwYrIEwNQeMbjLQQC
         OqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WpFy1o04gGKWo/8xALRc/Gpt0eK9BshRp5zY1lyPbsw=;
        b=XgxLrmfrRY18fHZAgJykT27MgihPlT3Atmo+J3KlXX3gW2sQYqcE4/XBMshiz84JyG
         dXhcT8fFIYLjFNn5fMELMEopHfrs/Ok8Z+9ryuGLAK7ssA6dFGh5qW7RicWnbQTs799d
         QFyVzvBfGNZ+i8V3q9EDbQzmQAToyjK9KMo8KYH5lZcCRY0rhRX+vReNsc3LYw/OYvRd
         OjILeTMWnT599jYOoymE7DNGYfomdZPKRs4Z5RnhYw98j5JOPbbesu+KG4gNdwP6JQxe
         bOqjU+I9OcWES53vrQnOr8UcCQw/OfRwOI/qmir7+oUU7l0ssPBDYMZQUGxZbPfPFGY4
         /OeQ==
X-Gm-Message-State: APjAAAX/GlZDngwTwCLlcJruKqmcfqKmAmkMKGV2iTMeZHb3r4g3dPJ7
        xf0rYnEEkgbA+IKmqUWdz87DkHLh559pTPAlSQ==
X-Google-Smtp-Source: APXvYqy1ZFZULyQPQcsrkCxKDSb+EbOeve7tJFY+xit/RB25tsJHAFiX5bhZECZ2+kAuTfXxEebtiQKrBKbWnbmP9a4=
X-Received: by 2002:a19:40d8:: with SMTP id n207mr18203655lfa.4.1577144941298;
 Mon, 23 Dec 2019 15:49:01 -0800 (PST)
MIME-Version: 1.0
References: <20191204225410.17514-1-lsahlber@redhat.com> <20191204225410.17514-2-lsahlber@redhat.com>
In-Reply-To: <20191204225410.17514-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 23 Dec 2019 15:48:50 -0800
Message-ID: <CAKywueQ40hEMH_X9M+ip6ftwO-is9w-Yv6h4vxSzD_F=h-kG1w@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: prepare SMB2_query_directory to be used with compounding
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 4 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 14:54, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c   | 108 +++++++++++++++++++++++++++++++++++-----------=
------
>  fs/cifs/smb2pdu.h   |   2 +
>  fs/cifs/smb2proto.h |   5 +++
>  3 files changed, 80 insertions(+), 35 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ed77f94dbf1d..df903931590e 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -4214,56 +4214,36 @@ num_entries(char *bufstart, char *end_of_buf, cha=
r **lastentry, size_t size)
>  /*
>   * Readdir/FindFirst
>   */
> -int
> -SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
> -                    u64 persistent_fid, u64 volatile_fid, int index,
> -                    struct cifs_search_info *srch_inf)
> +int SMB2_query_directory_init(const unsigned int xid,
> +                             struct cifs_tcon *tcon, struct smb_rqst *rq=
st,
> +                             u64 persistent_fid, u64 volatile_fid,
> +                             int index, int info_level)
>  {
> -       struct smb_rqst rqst;
> +       struct TCP_Server_Info *server =3D tcon->ses->server;
>         struct smb2_query_directory_req *req;
> -       struct smb2_query_directory_rsp *rsp =3D NULL;
> -       struct kvec iov[2];
> -       struct kvec rsp_iov;
> -       int rc =3D 0;
> -       int len;
> -       int resp_buftype =3D CIFS_NO_BUFFER;
>         unsigned char *bufptr;
> -       struct TCP_Server_Info *server;
> -       struct cifs_ses *ses =3D tcon->ses;
>         __le16 asteriks =3D cpu_to_le16('*');
> -       char *end_of_smb;
>         unsigned int output_size =3D CIFSMaxBufSize;

I think we need to account for compound responses here. The response
buffer size is MAX_SMB2_HDR_SIZE + CIFSMaxBufSize, where
MAX_SMB2_HDR_SIZE is 52 transform hdr + 64 hdr + 88 create rsp. While
output_size being CIFSMaxBufSize worked for non-compounded query
directory responses it may not fit into buffer for compounded ones
when encryption is used.

It seem like we need to set it to CIFSMaxBufSize -
MAX_SMB2_CREATE_RESPONSE_SIZE - MAX_SMB2_CLOSE_RESPONSE_SIZE like to
do in smb2_query_eas().

I found other occurrences of the similar issue in smb2_query_symlink()
and smb2_ioctl_query_info(): SMB2_ioctl_init() should use
CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
MAX_SMB2_CLOSE_RESPONSE_SIZE too instead of CIFSMaxBufSize. Could you
fix those together with this one?


> -       size_t info_buf_size;
> -       int flags =3D 0;
>         unsigned int total_len;
> -
> -       if (ses && (ses->server))
> -               server =3D ses->server;
> -       else
> -               return -EIO;
> +       struct kvec *iov =3D rqst->rq_iov;
> +       int len, rc;
>
>         rc =3D smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, (void **) =
&req,
>                              &total_len);
>         if (rc)
>                 return rc;
>
> -       if (smb3_encryption_required(tcon))
> -               flags |=3D CIFS_TRANSFORM_REQ;
> -
> -       switch (srch_inf->info_level) {
> +       switch (info_level) {
>         case SMB_FIND_FILE_DIRECTORY_INFO:
>                 req->FileInformationClass =3D FILE_DIRECTORY_INFORMATION;
> -               info_buf_size =3D sizeof(FILE_DIRECTORY_INFO) - 1;
>                 break;
>         case SMB_FIND_FILE_ID_FULL_DIR_INFO:
>                 req->FileInformationClass =3D FILEID_FULL_DIRECTORY_INFOR=
MATION;
> -               info_buf_size =3D sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
>                 break;
>         default:
>                 cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
> -                        srch_inf->info_level);
> -               rc =3D -EINVAL;
> -               goto qdir_exit;
> +                       info_level);
> +               return -EINVAL;
>         }
>
>         req->FileIndex =3D cpu_to_le32(index);
> @@ -4292,15 +4272,56 @@ SMB2_query_directory(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>         iov[1].iov_base =3D (char *)(req->Buffer);
>         iov[1].iov_len =3D len;
>
> +       trace_smb3_query_dir_enter(xid, persistent_fid, tcon->tid,
> +                       tcon->ses->Suid, index, output_size);
> +
> +       return 0;
> +}
> +
> +void SMB2_query_directory_free(struct smb_rqst *rqst)
> +{
> +       if (rqst && rqst->rq_iov) {
> +               cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* requ=
est */
> +       }
> +}
> +
> +int
> +SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
> +                    u64 persistent_fid, u64 volatile_fid, int index,
> +                    struct cifs_search_info *srch_inf)
> +{
> +       struct smb_rqst rqst;
> +       struct kvec iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> +       struct smb2_query_directory_rsp *rsp =3D NULL;
> +       int resp_buftype =3D CIFS_NO_BUFFER;
> +       struct kvec rsp_iov;
> +       int rc =3D 0;
> +       struct TCP_Server_Info *server;
> +       struct cifs_ses *ses =3D tcon->ses;
> +       char *end_of_smb;
> +       size_t info_buf_size;
> +       int flags =3D 0;
> +
> +       if (ses && (ses->server))
> +               server =3D ses->server;
> +       else
> +               return -EIO;
> +
> +       if (smb3_encryption_required(tcon))
> +               flags |=3D CIFS_TRANSFORM_REQ;
> +
>         memset(&rqst, 0, sizeof(struct smb_rqst));
> +       memset(&iov, 0, sizeof(iov));
>         rqst.rq_iov =3D iov;
> -       rqst.rq_nvec =3D 2;
> +       rqst.rq_nvec =3D SMB2_QUERY_DIRECTORY_IOV_SIZE;
>
> -       trace_smb3_query_dir_enter(xid, persistent_fid, tcon->tid,
> -                       tcon->ses->Suid, index, output_size);
> +       rc =3D SMB2_query_directory_init(xid, tcon, &rqst, persistent_fid=
,
> +                                      volatile_fid, index,
> +                                      srch_inf->info_level);
> +       if (rc)
> +               goto qdir_exit;
>
>         rc =3D cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp=
_iov);
> -       cifs_small_buf_release(req);
>         rsp =3D (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
>
>         if (rc) {
> @@ -4318,6 +4339,20 @@ SMB2_query_directory(const unsigned int xid, struc=
t cifs_tcon *tcon,
>                 goto qdir_exit;
>         }
>
> +       switch (srch_inf->info_level) {
> +       case SMB_FIND_FILE_DIRECTORY_INFO:
> +               info_buf_size =3D sizeof(FILE_DIRECTORY_INFO) - 1;
> +               break;
> +       case SMB_FIND_FILE_ID_FULL_DIR_INFO:
> +               info_buf_size =3D sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
> +               break;
> +       default:
> +               cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
> +                        srch_inf->info_level);
> +               rc =3D -EINVAL;
> +               goto qdir_exit;
> +       }
> +
>         rc =3D smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
>                                le32_to_cpu(rsp->OutputBufferLength), &rsp=
_iov,
>                                info_buf_size);
> @@ -4353,11 +4388,14 @@ SMB2_query_directory(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>         else
>                 cifs_tcon_dbg(VFS, "illegal search buffer type\n");
>
> +       rsp =3D NULL;

minor: the subsequent patch removes this assignment, probably better
to not do it here.

> +       resp_buftype =3D CIFS_NO_BUFFER;
> +
>         trace_smb3_query_dir_done(xid, persistent_fid, tcon->tid,
>                         tcon->ses->Suid, index, srch_inf->entries_in_buff=
er);
> -       return rc;
>
>  qdir_exit:
> +       SMB2_query_directory_free(&rqst);
>         free_rsp_buf(resp_buftype, rsp);
>         return rc;
>  }
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index f264e1d36fe1..caf323be0d7f 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -1272,6 +1272,8 @@ struct smb2_echo_rsp {
>  #define SMB2_INDEX_SPECIFIED           0x04
>  #define SMB2_REOPEN                    0x10
>
> +#define SMB2_QUERY_DIRECTORY_IOV_SIZE 2
> +
>  struct smb2_query_directory_req {
>         struct smb2_sync_hdr sync_hdr;
>         __le16 StructureSize; /* Must be 33 */
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index d21a5fcc8d06..ba48ce9af620 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -194,6 +194,11 @@ extern int SMB2_echo(struct TCP_Server_Info *server)=
;
>  extern int SMB2_query_directory(const unsigned int xid, struct cifs_tcon=
 *tcon,
>                                 u64 persistent_fid, u64 volatile_fid, int=
 index,
>                                 struct cifs_search_info *srch_inf);
> +extern int SMB2_query_directory_init(unsigned int xid, struct cifs_tcon =
*tcon,
> +                                    struct smb_rqst *rqst,
> +                                    u64 persistent_fid, u64 volatile_fid=
,
> +                                    int index, int info_level);
> +extern void SMB2_query_directory_free(struct smb_rqst *rqst);
>  extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
>                         u64 persistent_fid, u64 volatile_fid, u32 pid,
>                         __le64 *eof);
> --
> 2.13.6
>

Other than the note about buffer sizes above the series looks good at
the first glance.

--
Best regards,
Pavel Shilovsky
