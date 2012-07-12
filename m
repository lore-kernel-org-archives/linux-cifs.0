From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: obtain file access during backup intent lookup
Date: Thu, 12 Jul 2012 17:11:38 +0400
Message-ID: <CAKywueQ6Xb7DC1-gpH3UoqWnPiZFAK0zfWhh4_o3x8=TwyVnMQ@mail.gmail.com>
References: <1341926028-30845-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341926028-30845-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/10  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> path based querries can fail for lack of access, especially during lookup
> during open.
> open itself would actually succeed becasue of back up intent bit
> but querries (either path or file handle based) do not have a means to
> specifiy backup intent bit.
> So querry the file info during lookup using a file handle (based call)
> obtained by opening the file only for that purpose (and then closing the file).
>
> Add a file handle based call to obtain Index Number of a file
> in addition to an existing path based call.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Tushar Gosavi <tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |    4 ++
>  fs/cifs/cifssmb.c   |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/inode.c     |   31 ++++++++++++++++++-
>  3 files changed, 113 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 0a6cbfe..3c63ee4 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -375,6 +375,10 @@ extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
>                         const unsigned char *searchName, __u64 *inode_number,
>                         const struct nls_table *nls_codepage,
>                         int remap_special_chars);
> +extern int CIFSGetFileSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
> +                       u16 netfid, __u64 *inode_number,
> +                       const struct nls_table *nls_codepage,
> +                       int remap_special_chars);
>
>  extern int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
>                       const __u8 lock_type, const __u32 num_unlock,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 5b40073..dcd4091 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4621,6 +4621,86 @@ GetInodeNumOut:
>         return rc;
>  }
>
> +int
> +CIFSGetFileSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
> +                     u16 netfid, __u64 *inode_number,
> +                     const struct nls_table *nls_codepage, int remap)
> +{
> +       int rc = 0;
> +       struct smb_t2_qfi_req *pSMB = NULL;
> +       struct smb_t2_qfi_rsp *pSMBr = NULL;

While the existing code uses the same "pSMB" names I suggest to follow
kernel coding style for a new code. May be something like "req" and
"rsp" more suitable?

> +       int bytes_returned;
> +       __u16 params, byte_count;
> +
> +       cFYI(1, "In %s", __func__);
> +       if (tcon == NULL)
> +               return -ENODEV;
> +
> +FileGetInodeNumberRetry:
> +       rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
> +                     (void **) &pSMBr);
> +       if (rc)
> +               return rc;
> +
> +       params = 2 /* level */  + 2 /* fid */;
> +       pSMB->t2.TotalDataCount = 0;
> +       pSMB->t2.MaxParameterCount = cpu_to_le16(4);
> +       /* BB find exact max data count below from sess structure BB */
> +       pSMB->t2.MaxDataCount = cpu_to_le16(CIFSMaxBufSize);
> +       pSMB->t2.MaxSetupCount = 0;
> +       pSMB->t2.Reserved = 0;
> +       pSMB->t2.Flags = 0;
> +       pSMB->t2.Timeout = 0;
> +       pSMB->t2.Reserved2 = 0;
> +       pSMB->t2.ParameterOffset = cpu_to_le16(offsetof(
> +               struct smb_com_transaction2_qpi_req, InformationLevel) - 4);
> +       pSMB->t2.DataCount = 0;
> +       pSMB->t2.DataOffset = 0;
> +       pSMB->t2.SetupCount = 1;
> +       pSMB->t2.Reserved3 = 0;
> +       pSMB->t2.SubCommand = cpu_to_le16(TRANS2_QUERY_FILE_INFORMATION);
> +       byte_count = params + 1 /* pad */ ;
> +       pSMB->t2.TotalParameterCount = cpu_to_le16(params);
> +       pSMB->t2.ParameterCount = pSMB->t2.TotalParameterCount;
> +       pSMB->Fid = cpu_to_le16(netfid);
> +       pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_INTERNAL_INFO);
> +       inc_rfc1001_len(pSMB, byte_count);
> +       pSMB->t2.ByteCount = cpu_to_le16(byte_count);
> +
> +       rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> +               (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +       if (rc) {
> +               cFYI(1, "error %d in QueryInternalInfo", rc);
> +       } else {
> +               /* decode response */
> +               rc = validate_t2((struct smb_t2_rsp *)pSMBr);
> +               /* BB also check enough total bytes returned */
> +               if (rc || get_bcc(&pSMBr->hdr) < 2)
> +                       /* If rc should we check for EOPNOSUPP and
> +                       disable the srvino flag? or in caller? */
> +                       rc = -EIO;      /* bad smb */
> +               else {
> +                       __u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
> +                       __u16 count = le16_to_cpu(pSMBr->t2.DataCount);
> +                       struct file_internal_info *pfinfo;
> +                       /* BB Do we need a cast or hash here ? */
> +                       if (count < 8) {
> +                               cFYI(1, "Illegal size ret in FileQryIntrnlInf");
> +                               rc = -EIO;
> +                               goto FileGetInodeNumOut;
> +                       }
> +                       pfinfo = (struct file_internal_info *)
> +                               (data_offset + (char *) &pSMBr->hdr.Protocol);
> +                       *inode_number = le64_to_cpu(pfinfo->UniqueId);
> +               }
> +       }
> +FileGetInodeNumOut:
> +       cifs_buf_release(pSMB);
> +       if (rc == -EAGAIN)
> +               goto FileGetInodeNumberRetry;
> +       return rc;
> +}
> +
>  /* parses DFS refferal V3 structure
>   * caller is responsible for freeing target_nodes
>   * returns:
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 745da3d..a7c07a0 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -604,7 +604,8 @@ int cifs_get_inode_info(struct inode **pinode,
>         const unsigned char *full_path, FILE_ALL_INFO *pfindData,
>         struct super_block *sb, int xid, const __u16 *pfid)
>  {
> -       int rc = 0, tmprc;
> +       __u16 fid;
> +       int rc = 0, rc2 = -EINVAL, tmprc, oplock = 0;
>         struct cifs_tcon *pTcon;
>         struct tcon_link *tlink;
>         struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> @@ -640,6 +641,23 @@ int cifs_get_inode_info(struct inode **pinode,
>                               0 /* not legacy */,
>                               cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
>                                 CIFS_MOUNT_MAP_SPECIAL_CHR);
> +
> +               /*
> +                * This sequence of calls is meant for a lookup operation
> +                * that would otherwise fail since query path info has no
> +                * means to indicate backup intent.
> +                */
> +               if (rc == -EACCES && *pinode == NULL && backup_cred(cifs_sb)) {
> +                       /* pfindData contains same info returned by qpathinfo */
> +                       rc2 = CIFSSMBOpen(xid, pTcon, full_path,
> +                               FILE_OPEN, GENERIC_READ,
> +                               CREATE_OPEN_BACKUP_INTENT, &fid, &oplock,
> +                               pfindData, cifs_sb->local_nls,
> +                               cifs_sb->mnt_cifs_flags &
> +                                       CIFS_MOUNT_MAP_SPECIAL_CHR);
> +                       rc = rc2;
> +               }
> +
>                 /* BB optimize code so we do not make the above call
>                 when server claims no NT SMB support and the above call
>                 failed at least once - set flag in tcon or mount */
> @@ -683,7 +701,14 @@ int cifs_get_inode_info(struct inode **pinode,
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>                         int rc1 = 0;
>
> -                       rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
> +                       if (!rc2)
> +                               rc1 = CIFSGetFileSrvInodeNumber(xid, pTcon,
> +                                       fid, &fattr.cf_uniqueid,
> +                                       cifs_sb->local_nls,
> +                                       cifs_sb->mnt_cifs_flags &
> +                                               CIFS_MOUNT_MAP_SPECIAL_CHR);
> +                       else
> +                               rc1 = CIFSGetSrvInodeNumber(xid, pTcon,

This will cause merge conflicts with my smb2 changes - but I am not
sure what Steve prefer to merge at first.

>                                         full_path, &fattr.cf_uniqueid,
>                                         cifs_sb->local_nls,
>                                         cifs_sb->mnt_cifs_flags &
> @@ -699,6 +724,8 @@ int cifs_get_inode_info(struct inode **pinode,
>         } else {
>                 fattr.cf_uniqueid = CIFS_I(*pinode)->uniqueid;
>         }
> +       if (!rc2)
> +               CIFSSMBClose(xid, pTcon, fid);
>
>         /* query for SFU type info if supported and needed */
>         if (fattr.cf_cifsattrs & ATTR_SYSTEM &&
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Pavel Shilovsky.
