From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/9] cFYI
Date: Fri, 22 Nov 2013 09:33:57 -0500
Message-ID: <20131122093357.5305c1da@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
	<1385116018-14068-1-git-send-email-gbeck@sernet.de>
	<1385116018-14068-9-git-send-email-gbeck@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-9-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Nov 2013 11:26:57 +0100
Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

The subject on this patch needs more elaboration. "cFYI" doesn't tell
me much when I'm looking at this patch in a year or two.

> ---
>  smb1ops.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/smb1ops.c b/smb1ops.c
> index a12e370..11daa28 100644
> --- a/smb1ops.c
> +++ b/smb1ops.c
> @@ -522,6 +522,7 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>  	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
>  			      0 /* not legacy */, cifs_sb->local_nls, remap);
>  	if (rc == -EIO) {
> +		cifs_dbg(FYI, "is_path_accessible: FALLBACK");
>  		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
>  					   (FILE_BASIC_INFO*)file_info,
>  					   cifs_sb->local_nls, remap);
> @@ -547,6 +548,7 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  			      cifs_sb->local_nls, remap);
>  
>  	if (rc == -EIO) {
> +		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK");
>  		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
>  					   (FILE_BASIC_INFO*)data,
>  					   cifs_sb->local_nls, remap);


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
