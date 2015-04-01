From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 3/4] [SMB3] Fix dereference before null check warning
Date: Tue, 31 Mar 2015 20:46:34 -0400
Message-ID: <20150331204634.4d38c27e@synchrony.poochiereds.net>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	<1427434082-4299-4-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427434082-4299-4-git-send-email-smfrench@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 27 Mar 2015 00:28:01 -0500
Steve French <smfrench@gmail.com> wrote:

> null tcon is not likely in these paths in current
> code, but obviously it does clarify the code to
> check for null (if at all) before derefrencing
> rather than after.
> 
> Reported by Coverity (CID 1042666)
> 
> Signed-off-by: Steve French <smfrench@gmail.com>

I don't get it. Under what circumstances would the tcon ever be NULL
here? If there aren't any then this is just confusing. It would be
better to just remove the bogus checks for a NULL tcon instead.

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


-- 
Jeff Layton <jlayton@poochiereds.net>
