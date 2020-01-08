Return-Path: <SRS0=ymiT=25=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4FCC33C99
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351292077B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 03:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tGI/zNJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgAHDJa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jan 2020 22:09:30 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:39312 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgAHDJa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jan 2020 22:09:30 -0500
Received: by mail-il1-f196.google.com with SMTP id x5so1440880ila.6
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jan 2020 19:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3tim9KGo8Hq5R8yF7hEdkKs/m9ChPv6Hehcr87gJBY8=;
        b=tGI/zNJZGkBBCL3DB6eVTafuKWqUxFdUPz1ndgopCnf8N1GWlVXlBlSsU/uPjf2lVQ
         ymXQWWl/9jiGGb6Po6nTqjmEvd5lyHlQ/pGugHb1HxnLBnXMiX60i8fZWQ9NdtcfGxDy
         zUzGRF7hEacuNTjOnrd7m5PTWQ8MMK5Tn6VGIYzz0bgt7bbWWAClp2YWc5ED0GqvY183
         WPpFWonhL6aK/Jb6DurYsEfr+PHHiKKbAMnifIpy/w4DOThpwquqvjw4H//XUf2sYgiv
         ULPfpi7ZZI9Q1oIobKhZaqjX3jVjc/iUScQ0KY6kLKjCL4eJMj01iM94zqMZGPB50OH8
         6L4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3tim9KGo8Hq5R8yF7hEdkKs/m9ChPv6Hehcr87gJBY8=;
        b=fswtKvaS5RDkbM47hDWcTpK1GE8R2pc5J596CZrEJjHpKXN9dznQjmfO5JvymsuIRR
         kIzZqQv8BSWLJK9I1OOXXRW8Ad7L9/R6yFQU85k6EOPFKIdMuWnc3xOj7Tjr7z4ogaU3
         +AmtlLIDoFV9OuVHFzA5Eson/DgglcSYpOhed77ICxC1hDXXCAvK81MxxDbnnK3yFuH5
         AjS1PZVPA8uqgcP1XcESFkXwQGxgw44Wo3jku5SxAPauUePQ/mwWsa47Y040BPnyT44P
         0rl4D3SOppANFDPzbpZvIw8eHRO0PmRsZwgtO6vCGFY9X4VVqx/fN4vPH4o/MtoOFW2L
         4yLQ==
X-Gm-Message-State: APjAAAWWxoqyZpovUv8apz8ngjLAevTBbTj6Xrg1F5ej+rQV1tMLSGbM
        9FIgFVNoo/2rNHSPmEZRX8387UxO5I+0pzrvPjSzPw==
X-Google-Smtp-Source: APXvYqzhNEBw8DEOuqdMz8/6ZoKJwvcBxl31I6cYtlshGd4jfKIpQbcpQixChHQXgeDcDpKClW4lS5w44P0wME+6EpI=
X-Received: by 2002:a92:5b49:: with SMTP id p70mr2021802ilb.209.1578452969650;
 Tue, 07 Jan 2020 19:09:29 -0800 (PST)
MIME-Version: 1.0
References: <20191204225410.17514-1-lsahlber@redhat.com> <20191204225410.17514-2-lsahlber@redhat.com>
 <CAKywueQ40hEMH_X9M+ip6ftwO-is9w-Yv6h4vxSzD_F=h-kG1w@mail.gmail.com>
In-Reply-To: <CAKywueQ40hEMH_X9M+ip6ftwO-is9w-Yv6h4vxSzD_F=h-kG1w@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 8 Jan 2020 13:09:18 +1000
Message-ID: <CAN05THRxVsa1Ln91UqvPzXSyFSprj54mDsNS3nx=NuH8zB05qQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: prepare SMB2_query_directory to be used with compounding
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks,

I have resent it after addressing your concerns.
I added an extra patch to fix the two places calling smb2_ioctl_init()
that were unrelated to opendir/readdir

regards
ronnie sahlberg

On Tue, Dec 24, 2019 at 9:50 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=81=D1=80, 4 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 14:54, Ronnie Sah=
lberg <lsahlber@redhat.com>:
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2pdu.c   | 108 +++++++++++++++++++++++++++++++++++---------=
--------
> >  fs/cifs/smb2pdu.h   |   2 +
> >  fs/cifs/smb2proto.h |   5 +++
> >  3 files changed, 80 insertions(+), 35 deletions(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index ed77f94dbf1d..df903931590e 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -4214,56 +4214,36 @@ num_entries(char *bufstart, char *end_of_buf, c=
har **lastentry, size_t size)
> >  /*
> >   * Readdir/FindFirst
> >   */
> > -int
> > -SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
> > -                    u64 persistent_fid, u64 volatile_fid, int index,
> > -                    struct cifs_search_info *srch_inf)
> > +int SMB2_query_directory_init(const unsigned int xid,
> > +                             struct cifs_tcon *tcon, struct smb_rqst *=
rqst,
> > +                             u64 persistent_fid, u64 volatile_fid,
> > +                             int index, int info_level)
> >  {
> > -       struct smb_rqst rqst;
> > +       struct TCP_Server_Info *server =3D tcon->ses->server;
> >         struct smb2_query_directory_req *req;
> > -       struct smb2_query_directory_rsp *rsp =3D NULL;
> > -       struct kvec iov[2];
> > -       struct kvec rsp_iov;
> > -       int rc =3D 0;
> > -       int len;
> > -       int resp_buftype =3D CIFS_NO_BUFFER;
> >         unsigned char *bufptr;
> > -       struct TCP_Server_Info *server;
> > -       struct cifs_ses *ses =3D tcon->ses;
> >         __le16 asteriks =3D cpu_to_le16('*');
> > -       char *end_of_smb;
> >         unsigned int output_size =3D CIFSMaxBufSize;
>
> I think we need to account for compound responses here. The response
> buffer size is MAX_SMB2_HDR_SIZE + CIFSMaxBufSize, where
> MAX_SMB2_HDR_SIZE is 52 transform hdr + 64 hdr + 88 create rsp. While
> output_size being CIFSMaxBufSize worked for non-compounded query
> directory responses it may not fit into buffer for compounded ones
> when encryption is used.
>
> It seem like we need to set it to CIFSMaxBufSize -
> MAX_SMB2_CREATE_RESPONSE_SIZE - MAX_SMB2_CLOSE_RESPONSE_SIZE like to
> do in smb2_query_eas().
>
> I found other occurrences of the similar issue in smb2_query_symlink()
> and smb2_ioctl_query_info(): SMB2_ioctl_init() should use
> CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
> MAX_SMB2_CLOSE_RESPONSE_SIZE too instead of CIFSMaxBufSize. Could you
> fix those together with this one?
>
>
> > -       size_t info_buf_size;
> > -       int flags =3D 0;
> >         unsigned int total_len;
> > -
> > -       if (ses && (ses->server))
> > -               server =3D ses->server;
> > -       else
> > -               return -EIO;
> > +       struct kvec *iov =3D rqst->rq_iov;
> > +       int len, rc;
> >
> >         rc =3D smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, (void **=
) &req,
> >                              &total_len);
> >         if (rc)
> >                 return rc;
> >
> > -       if (smb3_encryption_required(tcon))
> > -               flags |=3D CIFS_TRANSFORM_REQ;
> > -
> > -       switch (srch_inf->info_level) {
> > +       switch (info_level) {
> >         case SMB_FIND_FILE_DIRECTORY_INFO:
> >                 req->FileInformationClass =3D FILE_DIRECTORY_INFORMATIO=
N;
> > -               info_buf_size =3D sizeof(FILE_DIRECTORY_INFO) - 1;
> >                 break;
> >         case SMB_FIND_FILE_ID_FULL_DIR_INFO:
> >                 req->FileInformationClass =3D FILEID_FULL_DIRECTORY_INF=
ORMATION;
> > -               info_buf_size =3D sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
> >                 break;
> >         default:
> >                 cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
> > -                        srch_inf->info_level);
> > -               rc =3D -EINVAL;
> > -               goto qdir_exit;
> > +                       info_level);
> > +               return -EINVAL;
> >         }
> >
> >         req->FileIndex =3D cpu_to_le32(index);
> > @@ -4292,15 +4272,56 @@ SMB2_query_directory(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >         iov[1].iov_base =3D (char *)(req->Buffer);
> >         iov[1].iov_len =3D len;
> >
> > +       trace_smb3_query_dir_enter(xid, persistent_fid, tcon->tid,
> > +                       tcon->ses->Suid, index, output_size);
> > +
> > +       return 0;
> > +}
> > +
> > +void SMB2_query_directory_free(struct smb_rqst *rqst)
> > +{
> > +       if (rqst && rqst->rq_iov) {
> > +               cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* re=
quest */
> > +       }
> > +}
> > +
> > +int
> > +SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
> > +                    u64 persistent_fid, u64 volatile_fid, int index,
> > +                    struct cifs_search_info *srch_inf)
> > +{
> > +       struct smb_rqst rqst;
> > +       struct kvec iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > +       struct smb2_query_directory_rsp *rsp =3D NULL;
> > +       int resp_buftype =3D CIFS_NO_BUFFER;
> > +       struct kvec rsp_iov;
> > +       int rc =3D 0;
> > +       struct TCP_Server_Info *server;
> > +       struct cifs_ses *ses =3D tcon->ses;
> > +       char *end_of_smb;
> > +       size_t info_buf_size;
> > +       int flags =3D 0;
> > +
> > +       if (ses && (ses->server))
> > +               server =3D ses->server;
> > +       else
> > +               return -EIO;
> > +
> > +       if (smb3_encryption_required(tcon))
> > +               flags |=3D CIFS_TRANSFORM_REQ;
> > +
> >         memset(&rqst, 0, sizeof(struct smb_rqst));
> > +       memset(&iov, 0, sizeof(iov));
> >         rqst.rq_iov =3D iov;
> > -       rqst.rq_nvec =3D 2;
> > +       rqst.rq_nvec =3D SMB2_QUERY_DIRECTORY_IOV_SIZE;
> >
> > -       trace_smb3_query_dir_enter(xid, persistent_fid, tcon->tid,
> > -                       tcon->ses->Suid, index, output_size);
> > +       rc =3D SMB2_query_directory_init(xid, tcon, &rqst, persistent_f=
id,
> > +                                      volatile_fid, index,
> > +                                      srch_inf->info_level);
> > +       if (rc)
> > +               goto qdir_exit;
> >
> >         rc =3D cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &r=
sp_iov);
> > -       cifs_small_buf_release(req);
> >         rsp =3D (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
> >
> >         if (rc) {
> > @@ -4318,6 +4339,20 @@ SMB2_query_directory(const unsigned int xid, str=
uct cifs_tcon *tcon,
> >                 goto qdir_exit;
> >         }
> >
> > +       switch (srch_inf->info_level) {
> > +       case SMB_FIND_FILE_DIRECTORY_INFO:
> > +               info_buf_size =3D sizeof(FILE_DIRECTORY_INFO) - 1;
> > +               break;
> > +       case SMB_FIND_FILE_ID_FULL_DIR_INFO:
> > +               info_buf_size =3D sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
> > +               break;
> > +       default:
> > +               cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
> > +                        srch_inf->info_level);
> > +               rc =3D -EINVAL;
> > +               goto qdir_exit;
> > +       }
> > +
> >         rc =3D smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
> >                                le32_to_cpu(rsp->OutputBufferLength), &r=
sp_iov,
> >                                info_buf_size);
> > @@ -4353,11 +4388,14 @@ SMB2_query_directory(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >         else
> >                 cifs_tcon_dbg(VFS, "illegal search buffer type\n");
> >
> > +       rsp =3D NULL;
>
> minor: the subsequent patch removes this assignment, probably better
> to not do it here.
>
> > +       resp_buftype =3D CIFS_NO_BUFFER;
> > +
> >         trace_smb3_query_dir_done(xid, persistent_fid, tcon->tid,
> >                         tcon->ses->Suid, index, srch_inf->entries_in_bu=
ffer);
> > -       return rc;
> >
> >  qdir_exit:
> > +       SMB2_query_directory_free(&rqst);
> >         free_rsp_buf(resp_buftype, rsp);
> >         return rc;
> >  }
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index f264e1d36fe1..caf323be0d7f 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -1272,6 +1272,8 @@ struct smb2_echo_rsp {
> >  #define SMB2_INDEX_SPECIFIED           0x04
> >  #define SMB2_REOPEN                    0x10
> >
> > +#define SMB2_QUERY_DIRECTORY_IOV_SIZE 2
> > +
> >  struct smb2_query_directory_req {
> >         struct smb2_sync_hdr sync_hdr;
> >         __le16 StructureSize; /* Must be 33 */
> > diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> > index d21a5fcc8d06..ba48ce9af620 100644
> > --- a/fs/cifs/smb2proto.h
> > +++ b/fs/cifs/smb2proto.h
> > @@ -194,6 +194,11 @@ extern int SMB2_echo(struct TCP_Server_Info *serve=
r);
> >  extern int SMB2_query_directory(const unsigned int xid, struct cifs_tc=
on *tcon,
> >                                 u64 persistent_fid, u64 volatile_fid, i=
nt index,
> >                                 struct cifs_search_info *srch_inf);
> > +extern int SMB2_query_directory_init(unsigned int xid, struct cifs_tco=
n *tcon,
> > +                                    struct smb_rqst *rqst,
> > +                                    u64 persistent_fid, u64 volatile_f=
id,
> > +                                    int index, int info_level);
> > +extern void SMB2_query_directory_free(struct smb_rqst *rqst);
> >  extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon=
,
> >                         u64 persistent_fid, u64 volatile_fid, u32 pid,
> >                         __le64 *eof);
> > --
> > 2.13.6
> >
>
> Other than the note about buffer sizes above the series looks good at
> the first glance.
>
> --
> Best regards,
> Pavel Shilovsky
