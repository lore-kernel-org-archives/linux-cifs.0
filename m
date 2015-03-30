From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] [SMB3] Fix dereference before null check warning
Date: Mon, 30 Mar 2015 10:50:53 +0100
Message-ID: <1427709053.14176.4.camel@redhat.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	 <1427434082-4299-4-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427434082-4299-4-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2015-03-27 at 00:28 -0500, Steve French wrote:
> null tcon is not likely in these paths in current
> code, but obviously it does clarify the code to
> check for null (if at all) before derefrencing
> rather than after.
> 
> Reported by Coverity (CID 1042666)
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

ACKed-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  fs/cifs/smb2pdu.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 1b906de..78b329f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1218,7 +1218,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>  	struct smb2_ioctl_req *req;
>  	struct smb2_ioctl_rsp *rsp;
>  	struct TCP_Server_Info *server;
> -	struct cifs_ses *ses = tcon->ses;
> +	struct cifs_ses *ses;
>  	struct kvec iov[2];
>  	int resp_buftype;
>  	int num_iovecs;
> @@ -1233,6 +1233,11 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>  	if (plen)
>  		*plen = 0;
>  
> +	if (tcon)
> +		ses = tcon->ses;
> +	else
> +		return -EIO;
> +
>  	if (ses && (ses->server))
>  		server = ses->server;
>  	else
> @@ -1296,14 +1301,12 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>  	rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
>  
>  	if ((rc != 0) && (rc != -EINVAL)) {
> -		if (tcon)
> -			cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> +		cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>  		goto ioctl_exit;
>  	} else if (rc == -EINVAL) {
>  		if ((opcode != FSCTL_SRV_COPYCHUNK_WRITE) &&
>  		    (opcode != FSCTL_SRV_COPYCHUNK)) {
> -			if (tcon)
> -				cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> +			cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>  			goto ioctl_exit;
>  		}
>  	}
