From: Sachin Prabhu <sprabhu@redhat.com>
Subject: Re: [PATCH 1/4] [SMB3] Fix warning on uninitialized buftype
Date: Mon, 30 Mar 2015 10:36:01 +0100
Message-ID: <1427708161.14176.2.camel@redhat.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	 <1427434082-4299-2-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427434082-4299-2-git-send-email-smfrench@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 2015-03-27 at 00:27 -0500, Steve French wrote:
> Pointed out by coverity analyzer.  resp_buftype is
> not initialized in one path which can rarely log
> a spurious warning (buf is null so there will
> not be a problem with freeing data, but if buf_type
> were randomly set to wrong value could log a warning)
> 
> Reported by Coverity (CID 1269144)
> 
> Signed-off-by: Steve French <smfrench@gmail.com>

ACKed-by: Sachin Prabhu <sprabhu@redhat.com>

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
