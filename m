From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 5/8] cifs: implement CIFSCheckMFSymlink()
Date: Thu, 05 Aug 2010 18:14:24 +0530
Message-ID: <4C5AB228.90800@suse.de>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com> <1280931109-22380-6-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280931109-22380-6-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/04/2010 07:41 PM, Stefan Metzmacher wrote:
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

Perhaps a little naive - what if cf_mode is S_IFDIR?

Thanks,


-- 
Suresh Jayaraman
