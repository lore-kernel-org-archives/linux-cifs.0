From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2 linux-next] cifs: Remove redundant multiplex
 identifier check from check_smb_hdr()
Date: Wed, 16 Oct 2013 11:36:32 -0400
Message-ID: <20131016113632.6548d399@tlielax.poochiereds.net>
References: <1381936190-67628-1-git-send-email-timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381936190-67628-1-git-send-email-timg-l6nL5VImRDY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Oct 2013 09:09:49 -0600
Tim Gardner <timg-l6nL5VImRDY@public.gmane.org> wrote:

> The only call site for check_smb_header() assigns 'mid' from the SMB
> packet, which is then checked again in check_smb_header(). This seems
> like redundant redundancy.
> 
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
> ---
>  fs/cifs/misc.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 138a011..298e31e 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -278,7 +278,7 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
>  }
>  
>  static int
> -check_smb_hdr(struct smb_hdr *smb, __u16 mid)
> +check_smb_hdr(struct smb_hdr *smb)
>  {
>  	/* does it have the right SMB "signature" ? */
>  	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
> @@ -287,13 +287,6 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
>  		return 1;
>  	}
>  
> -	/* Make sure that message ids match */
> -	if (mid != smb->Mid) {
> -		cifs_dbg(VFS, "Mids do not match. received=%u expected=%u\n",
> -			 smb->Mid, mid);
> -		return 1;
> -	}
> -
>  	/* if it's a response then accept */
>  	if (smb->Flags & SMBFLG_RESPONSE)
>  		return 0;
> @@ -310,7 +303,6 @@ int
>  checkSMB(char *buf, unsigned int total_read)
>  {
>  	struct smb_hdr *smb = (struct smb_hdr *)buf;
> -	__u16 mid = smb->Mid;
>  	__u32 rfclen = be32_to_cpu(smb->smb_buf_length);
>  	__u32 clc_len;  /* calculated length */
>  	cifs_dbg(FYI, "checkSMB Length: 0x%x, smb_buf_length: 0x%x\n",
> @@ -348,7 +340,7 @@ checkSMB(char *buf, unsigned int total_read)
>  	}
>  
>  	/* otherwise, there is enough to get to the BCC */
> -	if (check_smb_hdr(smb, mid))
> +	if (check_smb_hdr(smb))
>  		return -EIO;
>  	clc_len = smbCalcSize(smb);
>  

Nice...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
