From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] cifs: prototype declaration and definition for smb 2
 - 3 and cifsacl mount options
Date: Sat, 8 Jul 2017 16:42:13 +0000
Message-ID: <CY4PR21MB01350B5E0CE26809932BB4C6B6AB0@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <1498189891-4824-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498189891-4824-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-06-28 20:37 GMT-07:00  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Modified current set info function to accommodate multiple info types and
> additional information.
>
> Added cifs acl specific function to invoke set info functionality.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
>  fs/cifs/smb2pdu.c   | 39 +++++++++++++++++++++++++++------------
>  fs/cifs/smb2proto.h |  3 +++
>  2 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 4938e8b..c3c8eaf 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3000,8 +3000,9 @@ void smb2_reconnect_server(struct work_struct *work=
)
>
>  static int
>  send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
> -              u64 persistent_fid, u64 volatile_fid, u32 pid, int info_cl=
ass,
> -              unsigned int num, void **data, unsigned int *size)
> +              u64 persistent_fid, u64 volatile_fid, u32 pid, u8 info_cla=
ss,
> +              u8 info_type, u32 additional_info, unsigned int num,
> +               void **data, unsigned int *size)
>  {
>         struct smb2_set_info_req *req;
>         struct smb2_set_info_rsp *rsp =3D NULL;
> @@ -3037,10 +3038,11 @@ void smb2_reconnect_server(struct work_struct *wo=
rk)
>
>         req->hdr.sync_hdr.ProcessId =3D cpu_to_le32(pid);
>
> -       req->InfoType =3D SMB2_O_INFO_FILE;
> +       req->InfoType =3D info_type;
>         req->FileInfoClass =3D info_class;
>         req->PersistentFileId =3D persistent_fid;
>         req->VolatileFileId =3D volatile_fid;
> +       req->AdditionalInformation =3D cpu_to_le32(additional_info);
>
>         /* 4 for RFC1001 length and 1 for Buffer */
>         req->BufferOffset =3D
> @@ -3100,8 +3102,8 @@ void smb2_reconnect_server(struct work_struct *work=
)
>         size[1] =3D len + 2 /* null */;
>
>         rc =3D send_set_info(xid, tcon, persistent_fid, volatile_fid,
> -                          current->tgid, FILE_RENAME_INFORMATION, 2, dat=
a,
> -                          size);
> +               current->tgid, FILE_RENAME_INFORMATION, SMB2_O_INFO_FILE,
> +               0, 2, data, size);
>         kfree(data);
>         return rc;
>  }
> @@ -3118,8 +3120,8 @@ void smb2_reconnect_server(struct work_struct *work=
)
>         size =3D 1; /* sizeof __u8 */
>
>         return send_set_info(xid, tcon, persistent_fid, volatile_fid,
> -                       current->tgid, FILE_DISPOSITION_INFORMATION, 1, &=
data,
> -                       &size);
> +               current->tgid, FILE_DISPOSITION_INFORMATION, SMB2_O_INFO_=
FILE,
> +               0, 1, &data, &size);
>  }
>
>  int
> @@ -3148,7 +3150,8 @@ void smb2_reconnect_server(struct work_struct *work=
)
>         size[1] =3D len + 2 /* null */;
>
>         rc =3D send_set_info(xid, tcon, persistent_fid, volatile_fid,
> -                          current->tgid, FILE_LINK_INFORMATION, 2, data,=
 size);
> +                       current->tgid, FILE_LINK_INFORMATION, SMB2_O_INFO=
_FILE,
> +                       0, 2, data, size);
>         kfree(data);
>         return rc;
>  }
> @@ -3168,10 +3171,12 @@ void smb2_reconnect_server(struct work_struct *wo=
rk)
>
>         if (is_falloc)
>                 return send_set_info(xid, tcon, persistent_fid, volatile_=
fid,
> -                       pid, FILE_ALLOCATION_INFORMATION, 1, &data, &size=
);
> +                       pid, FILE_ALLOCATION_INFORMATION, SMB2_O_INFO_FIL=
E,
> +                       0, 1, &data, &size);
>         else
>                 return send_set_info(xid, tcon, persistent_fid, volatile_=
fid,
> -                       pid, FILE_END_OF_FILE_INFORMATION, 1, &data, &siz=
e);
> +                       pid, FILE_END_OF_FILE_INFORMATION, SMB2_O_INFO_FI=
LE,
> +                       0, 1, &data, &size);
>  }
>
>  int
> @@ -3181,8 +3186,18 @@ void smb2_reconnect_server(struct work_struct *wor=
k)
>         unsigned int size;
>         size =3D sizeof(FILE_BASIC_INFO);
>         return send_set_info(xid, tcon, persistent_fid, volatile_fid,
> -                            current->tgid, FILE_BASIC_INFORMATION, 1,
> -                            (void **)&buf, &size);
> +               current->tgid, FILE_BASIC_INFORMATION, SMB2_O_INFO_FILE,
> +               0, 1, (void **)&buf, &size);
> +}
> +
> +int
> +SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
> +               u64 persistent_fid, u64 volatile_fid,
> +               struct cifs_ntsd *pnntsd, int pacllen, int aclflag)
> +{
> +       return send_set_info(xid, tcon, persistent_fid, volatile_fid,
> +                       current->tgid, 0, SMB2_O_INFO_SECURITY, aclflag,
> +                       1, (void **)&pnntsd, &pacllen);
>  }
>
>  int
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 3595cd7..1cadaf9 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -166,6 +166,9 @@ extern int SMB2_set_eof(const unsigned int xid, struc=
t cifs_tcon *tcon,
>  extern int SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
>                          u64 persistent_fid, u64 volatile_fid,
>                          FILE_BASIC_INFO *buf);
> +extern int SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
> +                       u64 persistent_fid, u64 volatile_fid,
> +                       struct cifs_ntsd *pnntsd, int pacllen, int aclfla=
g);
>  extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon=
 *tcon,
>                                 u64 persistent_fid, u64 volatile_fid);
>  extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *t=
con,
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
