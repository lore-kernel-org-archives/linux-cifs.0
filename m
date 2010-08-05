From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 2/8] cifs: add CIFSCreateMFSymLink() and CIFSQueryMFSymLink()
 as stubs
Date: Thu, 05 Aug 2010 17:20:44 +0530
Message-ID: <4C5AA594.3020707@suse.de>
References: <1280847960-16371-1-git-send-email-metze@samba.org> <1280847960-16371-3-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280847960-16371-3-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/03/2010 08:35 PM, Stefan Metzmacher wrote:
> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/link.c |   34 ++++++++++++++++++++++++++++++----
>  1 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 473ca80..2358a5f 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -29,6 +29,24 @@
>  #include "cifs_debug.h"
>  #include "cifs_fs_sb.h"
>  
> +static int
> +CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
> +		    const char *fromName, const char *toName,
> +		    const struct nls_table *nls_codepage)
> +{
> +	int rc = -EOPNOTSUPP;
> +	return rc;
> +}
> +
> +static int
> +CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
> +		   const unsigned char *searchName, char **symlinkinfo,
> +		   const struct nls_table *nls_codepage)
> +{
> +	int rc = -EOPNOTSUPP;
> +	return rc;
> +}

Perhaps these two should be added to cifssmb.c because that is where the
other related functions are defined?

Thanks,

-- 
Suresh Jayaraman
