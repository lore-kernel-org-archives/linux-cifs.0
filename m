Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78DDC282DA
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 00:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A279E20651
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 00:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfDRAkD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 20:40:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfDRAkD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Apr 2019 20:40:03 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75D7181F13;
        Thu, 18 Apr 2019 00:40:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 613971001DE1;
        Thu, 18 Apr 2019 00:40:02 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4347D1819AFF;
        Thu, 18 Apr 2019 00:40:02 +0000 (UTC)
Date:   Wed, 17 Apr 2019 20:40:01 -0400 (EDT)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Message-ID: <513650.13992269.1555548001642.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAKywueTsdXc8TSTGUPTm6KXGFop9rmS4=8dQTGXPRyqDGkWyMQ@mail.gmail.com>
References: <20190417063410.6371-1-lsahlber@redhat.com> <CAKywueTsdXc8TSTGUPTm6KXGFop9rmS4=8dQTGXPRyqDGkWyMQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: add SEEK_HOLE/SEEK_DATA support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.64.54.110, 10.4.195.8]
Thread-Topic: cifs: add SEEK_HOLE/SEEK_DATA support
Thread-Index: Uj+ifXImibYzLZvPPTrtkQ37aUFGpw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 18 Apr 2019 00:40:02 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org





----- Original Message -----
> From: "Pavel Shilovsky" <piastryyy@gmail.com>
> To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> Cc: "linux-cifs" <linux-cifs@vger.kernel.org>, "Steve French" <smfrench@gmail.com>
> Sent: Thursday, 18 April, 2019 7:41:44 AM
> Subject: Re: [PATCH] cifs: add SEEK_HOLE/SEEK_DATA support
> 
> --
> Best regards,
> Pavel Shilovsky
> 
> вт, 16 апр. 2019 г. в 23:35, Ronnie Sahlberg <lsahlber@redhat.com>:
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c   |  9 ++++++++
> >  fs/cifs/cifsglob.h |  2 ++
> >  fs/cifs/smb2ops.c  | 65
> >  ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/cifs/smb2pdu.c  |  7 +++++-
> >  fs/cifs/smb2pdu.h  |  5 +++++
> >  fs/cifs/smbfsctl.h |  2 +-
> >  6 files changed, 88 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 07fdf1771add..a00ef6c6a988 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -884,6 +884,9 @@ static ssize_t cifs_file_write_iter(struct kiocb *iocb,
> > struct iov_iter *from)
> >
> >  static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
> >  {
> > +       struct cifsFileInfo *cfile = file->private_data;
> > +       struct cifs_tcon *tcon;
> > +
> >         /*
> >          * whence == SEEK_END || SEEK_DATA || SEEK_HOLE => we must
> >          revalidate
> >          * the cached file length
> > @@ -915,6 +918,12 @@ static loff_t cifs_llseek(struct file *file, loff_t
> > offset, int whence)
> >                 if (rc < 0)
> >                         return (loff_t)rc;
> >         }
> > +       if (cfile && cfile->tlink) {
> > +               tcon = tlink_tcon(cfile->tlink);
> > +               if (tcon->ses->server->ops->llseek)
> > +                       return tcon->ses->server->ops->llseek(file, tcon,
> > +                                                             offset,
> > whence);
> > +       }
> >         return generic_file_llseek(file, offset, whence);
> >  }
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 0dc55f4e6929..828772da5fa4 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -493,6 +493,8 @@ struct smb_version_operations {
> >                          char *full_path,
> >                          umode_t mode,
> >                          dev_t device_number);
> > +       /* version specific llseek implementation */
> > +       loff_t (*llseek)(struct file *, struct cifs_tcon *, loff_t, int);
> >  };
> >
> >  struct smb_version_values {
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 2824b97c5869..dc36316b9bd5 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -2872,6 +2872,69 @@ static long smb3_simple_falloc(struct file *file,
> > struct cifs_tcon *tcon,
> >         return rc;
> >  }
> >
> > +static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon,
> > loff_t offset, int whence)
> > +{
> > +       struct cifsFileInfo *cfile = file->private_data;
> > +       struct cifsInodeInfo *cifsi;
> > +       struct inode *inode;
> > +       int rc = 0;
> > +       struct fsctl_query_allocate_ranges in_data, *out_data = NULL;
> > +       u32 out_data_len;
> > +       unsigned int xid;
> > +
> > +       if (whence != SEEK_HOLE && whence != SEEK_DATA)
> > +               return generic_file_llseek(file, offset, whence);
> > +
> > +       inode = d_inode(cfile->dentry);
> > +       cifsi = CIFS_I(inode);
> > +
> > +       if (offset < 0 || offset > i_size_read(inode))
> > +               return -ENXIO;
> > +
> > +       if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)) {
> > +               if (whence == SEEK_HOLE)
> > +                       offset = i_size_read(inode);
> > +               else
> > +                       offset = offset;
> > +               goto lseek_exit;
> > +       }
> > +
> > +       in_data.file_offset = cpu_to_le64(offset);
> > +       in_data.length = cpu_to_le64(i_size_read(inode));
> > +
> > +       xid = get_xid();
> > +       rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
> > +                       cfile->fid.volatile_fid,
> > +                       FSCTL_QUERY_ALLOCATED_RANGES, true,
> > +                       (char *)&in_data, sizeof(in_data),
> > +                       sizeof(struct fsctl_query_allocate_ranges),
> > +                       (char **)&out_data, &out_data_len);
> > +       free_xid(xid);
> > +       if (rc == -E2BIG)
> > +               rc = 0;
> > +       if (rc)
> > +               goto lseek_exit;
> > +
> > +       if (out_data_len < sizeof(struct fsctl_query_allocate_ranges)) {
> > +               rc = -EINVAL;
> > +               goto lseek_exit;
> > +       }
> > +       if (whence == SEEK_DATA) {
> > +               offset = le64_to_cpu(out_data->file_offset);
> > +               goto lseek_exit;
> > +       }
> > +       if (offset < le64_to_cpu(out_data->file_offset))
> > +               goto lseek_exit;
> > +
> > +       offset = le64_to_cpu(out_data->file_offset) +
> > le64_to_cpu(out_data->length);
> > +
> > + lseek_exit:
> > +       kfree(out_data);
> > +       if (!rc)
> > +               return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
> > +       else
> > +               return rc;
> > +}
> >
> >  static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int
> >  mode,
> >                            loff_t off, loff_t len)
> > @@ -4247,6 +4310,7 @@ struct smb_version_operations smb30_operations = {
> >         .next_header = smb2_next_header,
> >         .ioctl_query_info = smb2_ioctl_query_info,
> >         .make_node = smb2_make_node,
> > +       .llseek = smb3_llseek,
> >  };
> >
> >  struct smb_version_operations smb311_operations = {
> > @@ -4356,6 +4420,7 @@ struct smb_version_operations smb311_operations = {
> >         .next_header = smb2_next_header,
> >         .ioctl_query_info = smb2_ioctl_query_info,
> >         .make_node = smb2_make_node,
> > +       .llseek = smb3_llseek,
> >  };
> >
> >  struct smb_version_values smb20_values = {
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 99a015e980d2..ac92d066c724 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -2625,7 +2625,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon
> > *tcon, u64 persistent_fid,
> >                 trace_smb3_fsctl_err(xid, persistent_fid, tcon->tid,
> >                                 ses->Suid, 0, opcode, rc);
> >
> > -       if ((rc != 0) && (rc != -EINVAL)) {
> > +       if ((rc != 0) && (rc != -EINVAL) && (rc != -E2BIG)) {
> >                 cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> >                 goto ioctl_exit;
> >         } else if (rc == -EINVAL) {
> > @@ -2634,6 +2634,11 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon
> > *tcon, u64 persistent_fid,
> >                         cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> >                         goto ioctl_exit;
> >                 }
> > +       } else if (rc == -E2BIG) {
> > +               if (opcode != FSCTL_QUERY_ALLOCATED_RANGES) {
> > +                       cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> > +                       goto ioctl_exit;
> > +               }
> >         }
> >
> >         /* check if caller wants to look at return data or just return rc
> >         */
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index ee8977688e21..3a29db740fe6 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -842,6 +842,11 @@ struct fsctl_get_integrity_information_rsp {
> >         __le32  ClusterSizeInBytes;
> >  } __packed;
> >
> > +struct fsctl_query_allocate_ranges {
> 
> This describes one range, so should be fsctl_query_allocate_range or
> even file_allocated_range_buffer as specified here:
> 
> https://docs.microsoft.com/en-us/windows/desktop/api/winioctl/ns-winioctl-_file_allocated_range_buffer

Thanks.
Will resend with this change.

> 
> > +       __le64  file_offset;
> > +       __le64  length;
> > +} __packed;
> > +
> >  /* Integrity ChecksumAlgorithm choices for above */
> >  #define        CHECKSUM_TYPE_NONE      0x0000
> >  #define        CHECKSUM_TYPE_CRC64     0x0002
> > diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
> > index 9b3459b9a5ce..08628e6a42ac 100644
> > --- a/fs/cifs/smbfsctl.h
> > +++ b/fs/cifs/smbfsctl.h
> > @@ -103,7 +103,7 @@
> >  #define FSCTL_SET_ZERO_ON_DEALLOC    0x00090194 /* BB add struct */
> >  #define FSCTL_SET_SHORT_NAME_BEHAVIOR 0x000901B4 /* BB add struct */
> >  #define FSCTL_GET_INTEGRITY_INFORMATION 0x0009027C
> > -#define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF /* BB add struct */
> > +#define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF
> >  #define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
> >  #define FSCTL_FILE_LEVEL_TRIM        0x00098208 /* BB add struct */
> >  #define FSCTL_DUPLICATE_EXTENTS_TO_FILE 0x00098344
> > --
> > 2.13.6
> >
> 
