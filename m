From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] [CIFS] SMB2 FSCTL and IOCTL worker function
Date: Mon, 24 Jun 2013 14:24:58 +0400
Message-ID: <CAKywueR4pnOpEraAY9fXBvGHjZUJ8dO4cZJ_6w12uNwJ=2bviw@mail.gmail.com>
References: <CAH2r5muUxsPGg6VoiykMx-YiT=zyiF5tfgfs6j2U++KoGVCP+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muUxsPGg6VoiykMx-YiT=zyiF5tfgfs6j2U++KoGVCP+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/6/24 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This worker function is needed to send SMB2 fsctl (and ioctl) requests
> including:
>
> validating negotiation info (secure negotiate)
> querying the servers network interfaces
> copy offload (refcopy)
>
> Followon patches for the above three will use this worker function.
> Samba server implements
> the first and third of these (Windows implements all three).   As Ira
> and I were discussing
> we should probably add the simplest version of the query network
> interfaces fsctl to
> Samba server (to give out the link speed and ipv4 and ipv6 socket info
> for the socket
> the server is listening on)
>
> (fsctl may also be needed eventually to request resiliency and work
> with branch cache
> among other tasks but that is farther in the future)
>
> This patch also does general validation of the ioctl/fsctl response.
>
> See MS-SMB2 Section 2.2.31
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/smb2misc.c  |   4 ++
>  fs/cifs/smb2pdu.c   | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2pdu.h   |  23 +++++++++++
>  fs/cifs/smb2proto.h |   4 ++
>  4 files changed, 145 insertions(+)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 10383d8..b0c4334 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -266,6 +266,10 @@ smb2_get_data_area_len(int *off, int *len, struct
> smb2_hdr *hdr)
>                   ((struct smb2_query_directory_rsp *)hdr)->OutputBufferLength);
>                 break;
>         case SMB2_IOCTL:
> +               *off = le32_to_cpu(
> +                 ((struct smb2_ioctl_rsp *)hdr)->OutputOffset);
> +               *len = le32_to_cpu(((struct smb2_ioctl_rsp *)hdr)->OutputCount);
> +               break;
>         case SMB2_CHANGE_NOTIFY:
>         default:
>                 /* BB FIXME for unimplemented cases above */
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 0de6a82..ebad80a 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -997,6 +997,120 @@ creat_exit:
>         return rc;
>  }
>
> +/*
> + *     SMB2 IOCTL is used for both IOCTLs and FSCTLs
> + */
> +int
> +SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
> +          u64 volatile_fid, u32 opcode, bool is_fsctl, char *in_data,
> +          u32 indatalen, char **out_data, u32 *plen /* returned data len */)
> +{
> +       struct smb2_ioctl_req *req;
> +       struct smb2_ioctl_rsp *rsp;
> +       struct TCP_Server_Info *server;
> +       struct cifs_ses *ses = tcon->ses;
> +       struct kvec iov[2];
> +       int resp_buftype;
> +       int num_iovecs;
> +       int rc = 0;
> +
> +       cifs_dbg(FYI, "SMB2 IOCTL\n");
> +
> +       /* zero out returned data len, in case of error */
> +       if (plen)
> +               *plen = 0;
> +
> +       if (ses && (ses->server))
> +               server = ses->server;
> +       else
> +               return -EIO;
> +
> +       rc = small_smb2_init(SMB2_IOCTL, tcon, (void **) &req);
> +       if (rc)
> +               return rc;
> +
> +       req->CtlCode = cpu_to_le32(opcode);
> +       req->PersistentFileId = persistent_fid;
> +       req->VolatileFileId = volatile_fid;
> +
> +       if (indatalen) {
> +               req->InputCount = cpu_to_le32(indatalen);
> +               /* do not set InputOffset if no input data */
> +               req->InputOffset =
> +                      cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer) - 4);
> +               iov[1].iov_base = in_data;
> +               iov[1].iov_len = indatalen;
> +               num_iovecs = 2;
> +       } else
> +               num_iovecs = 1;
> +
> +       req->OutputOffset = 0;
> +       req->OutputCount = 0; /* MBZ */
> +
> +       /* Could increase MaxOutputResponse, but that would require
> +          more than one credit. Windows typically sets this smaller, but for
> +          some ioctls it may be useful to allow server to send more. No point
> +          limiting what the server can send as long as fits in one credit */

I think we should follow kernel comment style here and make it this way:
/*
 * text here
 */

> +       req->MaxOutputResponse = cpu_to_le32(0xFF00); /* < 64K uses 1 credit */
> +
> +       if (is_fsctl)
> +               req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
> +       else
> +               req->Flags = 0;
> +
> +       iov[0].iov_base = (char *)req;
> +       /* 4 for rfc1002 length field */
> +       iov[0].iov_len = get_rfc1002_length(req) + 4;
> +
> +       if (indatalen)
> +               inc_rfc1001_len(req, indatalen);
> +
> +       rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
> +       rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
> +
> +       if (rc != 0) {
> +               if (tcon)
> +                       cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> +               goto ioctl_exit;
> +       }
> +
> +       /* check if caller wants to look at return data or just return rc */
> +       if ((plen == NULL) || (out_data == NULL))
> +               goto ioctl_exit;
> +
> +       *plen = le32_to_cpu(rsp->OutputCount);
> +
> +       /* We check for obvious errors in the output buffer length and offset */
> +       if (*plen == 0)
> +               goto ioctl_exit; /* server returned no data */
> +       else if (*plen > 0xFF00) {
> +               cifs_dbg(VFS, "srv returned invalid ioctl length: %d\n", *plen);
> +               *plen = 0;
> +               rc = -EIO;
> +               goto ioctl_exit;
> +       }
> +
> +       if (get_rfc1002_length(rsp) < le32_to_cpu(rsp->OutputOffset) + *plen) {
> +               cifs_dbg(VFS, "Malformed ioctl resp: len %d offset %d\n", *plen,
> +                       le32_to_cpu(rsp->OutputOffset));
> +               *plen = 0;
> +               rc = -EIO;
> +               goto ioctl_exit;
> +       }
> +
> +       *out_data = kmalloc(*plen, GFP_KERNEL);
> +       if (*out_data == NULL) {
> +               rc = -ENOMEM;
> +               goto ioctl_exit;
> +       }
> +
> +       memcpy(*out_data, rsp->hdr.ProtocolId + le32_to_cpu(rsp->OutputOffset),
> +              *plen);
> +ioctl_exit:
> +       free_rsp_buf(resp_buftype, rsp);
> +       return rc;
> +}
> +
>  int
>  SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>            u64 persistent_fid, u64 volatile_fid)
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 0ef06ec..f31043b 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -497,6 +497,29 @@ struct copychunk_ioctl {
>         __u32 Reserved2;
>  } __packed;
>
> +/* Response and Request are the same format */
> +struct validate_negotiate_info {
> +       __le32 Capabilities;
> +       __u8   Guid[SMB2_CLIENT_GUID_SIZE];
> +       __le16 SecurityMode;
> +       __le16 DialectCount;
> +       __le16 Dialect[1];
> +} __packed;
> +
> +#define RSS_CAPABLE    0x00000001
> +#define RDMA_CAPABLE   0x00000002
> +
> +struct network_interface_info_ioctl_rsp {
> +       __le32 Next; /* next interface. zero if this is last one */
> +       __le32 IfIndex;
> +       __le32 Capability; /* RSS or RDMA Capable */
> +       __le32 Reserved;
> +       __le64 LinkSpeed;
> +       char    SockAddr_Storage[128];
> +} __packed;
> +
> +#define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not
> to file */
> +
>  struct smb2_ioctl_req {
>         struct smb2_hdr hdr;
>         __le16 StructureSize;   /* Must be 57 */
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 2aa3535..d4e1eb8 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -111,6 +111,10 @@ extern int SMB2_open(const unsigned int xid,
> struct cifs_tcon *tcon,
>                      __u32 desired_access, __u32 create_disposition,
>                      __u32 file_attributes, __u32 create_options,
>                      __u8 *oplock, struct smb2_file_all_info *buf);
> +extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
> +                    u64 persistent_fid, u64 volatile_fid, u32 opcode,
> +                    bool is_fsctl, char *in_data, u32 indatalen,
> +                    char **out_data, u32 *plen /* returned data len */);
>  extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>                       u64 persistent_file_id, u64 volatile_file_id);
>  extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
> --
> 1.7.11.7
>
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Other than the notice about comments, the patch looks ok.

Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--
Best regards,
Pavel Shilovsky.
