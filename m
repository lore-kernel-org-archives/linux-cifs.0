From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: untangle server->maxBuf and CIFSMaxBufSize
Date: Wed, 24 Aug 2011 11:51:25 +0530
Message-ID: <4E549865.6010004@suse.de>
References: <1313803308-32276-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313803308-32276-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/20/2011 06:51 AM, Jeff Layton wrote:
> server->maxBuf is the maximum SMB size (including header) that the
> server can handle. CIFSMaxBufSize is the maximum amount of data (sans
> header) that the client can handle. Currently maxBuf is being capped at
> CIFSMaxBufSize + the max headers size, and the two values are used
> somewhat interchangeably in the code.
> 
> This makes little sense as these two values are not related at all.
> Separate them and make sure the code uses the right values in the right
> places.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |   33 ++++++++++-----------------------
>  fs/cifs/connect.c |   11 +++++------
>  fs/cifs/file.c    |    2 +-
>  fs/cifs/sess.c    |    4 +++-
>  4 files changed, 19 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 7bac906..5a2f2bc 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -458,8 +458,8 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
>  		   (otherwise oplock break e.g. would fail) */
>  		if (server->maxReq < 2)
>  			server->maxReq = CIFS_MAX_REQ; /* 50 */
> -		server->maxBuf = min((__u32)le16_to_cpu(rsp->MaxBufSize),
> -				(__u32)CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);

Looks correct to me.

But, what is the rationale behind the current code (not using the maxBuf
from the server)? Perhaps, broken servers not setting max
rsp->MaxBufSize or setting too high value?

Steve, do you remember, why?


> +		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
>  		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
>  		/* even though we do not use raw we might as well set this
>  		accurately, in case we ever find a need for it */
> @@ -571,8 +571,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
>  	if (server->maxReq < 2)
>  		server->maxReq = CIFS_MAX_REQ; /* 50 */

-- 
Suresh Jayaraman
