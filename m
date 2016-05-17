From: Sachin Prabhu <sprabhu@redhat.com>
Subject: Re: [PATCH] [SMB3] remove directory incorrectly tries to set
 delete on close on non-empty directories
Date: Tue, 17 May 2016 16:19:47 +0100
Message-ID: <1463498387.3084.24.camel@redhat.com>
References: <1463106632-88753-1-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <steve.french@primarydata.com>,
	Stable <stable@vger.kernel.org>
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1463106632-88753-1-git-send-email-smfrench@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 2016-05-12 at 21:30 -0500, Steve French wrote:
> For SMB3 (unlike for cifs), we attempt to delete a directory by
> set of delete on close flag on the open. Windows clients set
> this flag via a set info (SET_FILE_DISPOSITION to set this flag)
> which properly checks if the directory is empty.
>=20
> With this patch on smb3 mounts we correctly return
> =C2=A0"DIRECTORY NOT EMPTY"
> on attempts to remove a non-empty directory.
>=20
> Signed-off-by: Steve French <steve.french@primarydata.com>
> CC: Stable <stable@vger.kernel.org>

Acked-by: Sachin Prabhu <sprabhu@redhat.com>

> ---
> =C2=A0fs/cifs/smb2glob.h=C2=A0=C2=A0|=C2=A0=C2=A01 +
> =C2=A0fs/cifs/smb2inode.c |=C2=A0=C2=A08 ++++++--
> =C2=A0fs/cifs/smb2pdu.c=C2=A0=C2=A0=C2=A0| 16 ++++++++++++++++
> =C2=A0fs/cifs/smb2proto.h |=C2=A0=C2=A02 ++
> =C2=A04 files changed, 25 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
> index bc0bb9c..0ffa180 100644
> --- a/fs/cifs/smb2glob.h
> +++ b/fs/cifs/smb2glob.h
> @@ -44,6 +44,7 @@
> =C2=A0#define SMB2_OP_DELETE 7
> =C2=A0#define SMB2_OP_HARDLINK 8
> =C2=A0#define SMB2_OP_SET_EOF 9
> +#define SMB2_OP_RMDIR 10
> =C2=A0
> =C2=A0/* Used when constructing chained read requests. */
> =C2=A0#define CHAINED_REQUEST 1
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 899bbc8..4f0231e 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -80,6 +80,10 @@ smb2_open_op_close(const unsigned int xid, struct
> cifs_tcon *tcon,
> =C2=A0		=C2=A0* SMB2_open() call.
> =C2=A0		=C2=A0*/
> =C2=A0		break;
> +	case SMB2_OP_RMDIR:
> +		tmprc =3D SMB2_rmdir(xid, tcon, fid.persistent_fid,
> +				=C2=A0=C2=A0=C2=A0fid.volatile_fid);
> +		break;
> =C2=A0	case SMB2_OP_RENAME:
> =C2=A0		tmprc =3D SMB2_rename(xid, tcon, fid.persistent_fid,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0fid.volatile_fid, (__le16
> *)data);
> @@ -191,8 +195,8 @@ smb2_rmdir(const unsigned int xid, struct
> cifs_tcon *tcon, const char *name,
> =C2=A0	=C2=A0=C2=A0=C2=A0struct cifs_sb_info *cifs_sb)
> =C2=A0{
> =C2=A0	return smb2_open_op_close(xid, tcon, cifs_sb, name, DELETE,
> FILE_OPEN,
> -				=C2=A0=C2=A0CREATE_NOT_FILE |
> CREATE_DELETE_ON_CLOSE,
> -				=C2=A0=C2=A0NULL, SMB2_OP_DELETE);
> +				=C2=A0=C2=A0CREATE_NOT_FILE,
> +				=C2=A0=C2=A0NULL, SMB2_OP_RMDIR);
> =C2=A0}
> =C2=A0
> =C2=A0int
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 42e1f44..8f38e33 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2575,6 +2575,22 @@ SMB2_rename(const unsigned int xid, struct
> cifs_tcon *tcon,
> =C2=A0}
> =C2=A0
> =C2=A0int
> +SMB2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
> +		=C2=A0=C2=A0u64 persistent_fid, u64 volatile_fid)
> +{
> +	__u8 delete_pending =3D 1;
> +	void *data;
> +	unsigned int size;
> +
> +	data =3D &delete_pending;
> +	size =3D 1; /* sizeof __u8 */
> +
> +	return send_set_info(xid, tcon, persistent_fid,
> volatile_fid,
> +			current->tgid, FILE_DISPOSITION_INFORMATION,
> 1, &data,
> +			&size);
> +}
> +
> +int
> =C2=A0SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tco=
n,
> =C2=A0		=C2=A0=C2=A0u64 persistent_fid, u64 volatile_fid, __le16
> *target_file)
> =C2=A0{
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 4f07dc9..eb2cde2 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -141,6 +141,8 @@ extern int SMB2_query_directory(const unsigned
> int xid, struct cifs_tcon *tcon,
> =C2=A0extern int SMB2_rename(const unsigned int xid, struct cifs_tcon
> *tcon,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 persistent_fid,=
 u64 volatile_fid,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__le16 *target_file=
);
> +extern int SMB2_rmdir(const unsigned int xid, struct cifs_tcon
> *tcon,
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 persistent_fid, u64 volati=
le_fid);
> =C2=A0extern int SMB2_set_hardlink(const unsigned int xid, struct
> cifs_tcon *tcon,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 persistent_fid, u64 volati=
le_fid,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__le16 *target_file);
