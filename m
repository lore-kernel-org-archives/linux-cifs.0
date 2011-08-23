From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: fix possible memory corruption in CIFSFindNext
Date: Tue, 23 Aug 2011 17:55:25 +0530
Message-ID: <4E539C35.70004@suse.de>
References: <1314098488-1547-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dcl-HN4QTLPn1qTvY7RNz7mR4EEOCMrvLtNR@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314098488-1547-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/23/2011 04:51 PM, Jeff Layton wrote:
> The name_len variable in CIFSFindNext is a signed int that gets set to
> the resume_name_len in the cifs_search_info. The resume_name_len however
> is unsigned and for some infolevels is populated directly from a 32 bit
> value sent by the server.
> 
> If the server sends a very large value for this, then that value could
> look negative when converted to a signed int. That would make that
> value pass the PATH_MAX check later in CIFSFindNext. The name_len would
> then be used as a length value for a memcpy. It would then be treated
> as unsigned again, and the memcpy scribbles over a ton of memory.
> 
> Fix this by making the name_len an unsigned value in CIFSFindNext.
> 
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Darren Lavender <dcl-HN4QTLPn1qTvY7RNz7mR4EEOCMrvLtNR@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f4d0988..950464d 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4089,7 +4089,8 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
>  	T2_FNEXT_RSP_PARMS *parms;
>  	char *response_data;
>  	int rc = 0;
> -	int bytes_returned, name_len;
> +	int bytes_returned;
> +	unsigned int name_len;

Looks obviously correct. Just curious when does the server sends a very
large resume_name_len? Does it try to overload with some other info in
such circumstances?



-- 
Suresh Jayaraman
