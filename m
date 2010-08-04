From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 5/8] cifs: implement CIFSCheckMFSymlink()
Date: Wed, 4 Aug 2010 10:22:56 -0400
Message-ID: <20100804102256.4706f50b@tlielax.poochiereds.net>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com>
	<1280931109-22380-6-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280931109-22380-6-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  4 Aug 2010 16:11:46 +0200
Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/link.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 65 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 0d90a89..6cd0879 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -114,6 +114,71 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>  		   const unsigned char *path,
>  		   struct cifs_sb_info *cifs_sb, int xid)
>  {
> +	int rc;
> +	int oplock = 0;
> +	__u16 netfid = 0;
> +	struct cifsTconInfo *pTcon = cifs_sb->tcon;
> +	u8 *buf;
> +	char *pbuf;
> +	unsigned int bytes_read = 0;
> +	int buf_type = CIFS_NO_BUFFER;
> +	unsigned int link_len = 0;
> +	FILE_ALL_INFO file_info;
> +
> +	if (!(fattr->cf_mode & S_IFREG))
> +		/* it's not a symlink */
> +		return 0;
> +
> +	if (fattr->cf_eof != CIFS_MF_SYMLINK_FILE_SIZE)
> +		/* it's not a symlink */
> +		return 0;
> +
> +	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +	pbuf = buf;
> +
> +	rc = CIFSSMBOpen(xid, pTcon, path, FILE_OPEN, GENERIC_READ,
> +			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
> +			 cifs_sb->local_nls,
> +			 cifs_sb->mnt_cifs_flags &
> +				CIFS_MOUNT_MAP_SPECIAL_CHR);
> +	if (rc != 0) {
> +		kfree(buf);
> +		return rc;
> +	}
> +
> +	if (file_info.EndOfFile != CIFS_MF_SYMLINK_FILE_SIZE) {
> +		CIFSSMBClose(xid, pTcon, netfid);
> +		kfree(buf);
> +		/* it's not a symlink */
> +		return 0;
> +	}
> +

Might be better to move the kmalloc() here. If the open fails, or the
size is wrong you won't need the buffer. Allocating memory can lead to
reclaim events too, so it's best not to do it unless you really need it.

> +	/* Read header */
> +	rc = CIFSSMBRead(xid, pTcon, netfid,
> +			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
> +			 0 /* offset */,
> +			 &bytes_read, &pbuf, &buf_type);
> +	CIFSSMBClose(xid, pTcon, netfid);
> +	if (rc != 0) {
> +		kfree(buf);
> +		return rc;
> +	}
> +
> +	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, NULL);
> +	kfree(buf);
> +	if (rc == -EINVAL)
> +		/* it's not a symlink */
> +		return 0;
> +	if (rc != 0)
> +		return rc;
> +
> +	/* it is a symlink */
> +	fattr->cf_eof = link_len;
> +	fattr->cf_mode &= ~S_IFMT;
> +	fattr->cf_mode |= S_IFLNK;
> +	fattr->cf_dtype = DT_LNK;
>  	return 0;
>  }
>  


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
