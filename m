From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 1/4] [SMB3] Fix warning on uninitialized buftype
Date: Tue, 31 Mar 2015 20:35:07 -0400
Message-ID: <20150331203507.7b82e45f@synchrony.poochiereds.net>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	<1427434082-4299-2-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427434082-4299-2-git-send-email-smfrench@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 27 Mar 2015 00:27:59 -0500
Steve French <smfrench@gmail.com> wrote:

> Pointed out by coverity analyzer.  resp_buftype is
> not initialized in one path which can rarely log
> a spurious warning (buf is null so there will
> not be a problem with freeing data, but if buf_type
> were randomly set to wrong value could log a warning)
> 
> Reported by Coverity (CID 1269144)
> 
> Signed-off-by: Steve French <smfrench@gmail.com>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 3417340..1b906de 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2114,7 +2114,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
>  	struct kvec iov[2];
>  	int rc = 0;
>  	int len;
> -	int resp_buftype;
> +	int resp_buftype = CIFS_NO_BUFFER;
>  	unsigned char *bufptr;
>  	struct TCP_Server_Info *server;
>  	struct cifs_ses *ses = tcon->ses;

Reviewed-by: Jeff Layton <jlayton@poochiereds.net>
