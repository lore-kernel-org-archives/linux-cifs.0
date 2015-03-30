From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] [CIFS] Don't ignore errors on encrypting password
 in SMBTcon
Date: Mon, 30 Mar 2015 10:44:04 +0100
Message-ID: <1427708644.14176.3.camel@redhat.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	 <1427434082-4299-3-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427434082-4299-3-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2015-03-27 at 00:28 -0500, Steve French wrote:
> Although unlikely to fail (and tree connect does not commonly send
> a password since SECMODE_USER is the default for most servers)
> do not ignore errors on SMBNTEncrypt in SMB Tree Connect.
> 
> Reported by Coverity (CID 1226853)
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

ACKed-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  fs/cifs/connect.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 4cb8450..cdb1aaf 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3696,6 +3696,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>  #endif /* CIFS_WEAK_PW_HASH */
>  		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
>  					bcc_ptr, nls_codepage);
> +		if (rc) {
> +			cifs_dbg(FYI, "%s Can't generate NTLM rsp. Error: %d\n",
> +				 __func__, rc);
> +			cifs_buf_release(smb_buffer);
> +			return rc;
> +		}
>  
>  		bcc_ptr += CIFS_AUTH_RESP_SIZE;
>  		if (ses->capabilities & CAP_UNICODE) {
