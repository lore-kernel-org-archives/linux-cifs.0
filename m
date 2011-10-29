From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 03/53] CIFS: Check for smb2 vs. cifs in
 find_tcp_session
Date: Sat, 29 Oct 2011 00:40:46 -0400
Message-ID: <20111029004046.2bf8e111@corrin.poochiereds.net>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 28 Oct 2011 23:54:14 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> Also set ses->is_smb2 when smb2 session initialized.
> 

The commit message doesn't seem to be accurate. ses->is_smb2 is not
being set here (and doesn't seem to exist).

> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    1 +
>  fs/cifs/connect.c  |   16 +++++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 6dfc7ef..179b784 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -172,6 +172,7 @@ struct smb_vol {
>  	mode_t file_mode;
>  	mode_t dir_mode;
>  	unsigned secFlg;
> +	bool use_smb2:1; /* use SMB2 protocol rather that CIFS */
>  	bool retry:1;
>  	bool intr:1;
>  	bool setuids:1;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f70d87d..6743558 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1,7 +1,7 @@
>  /*
>   *   fs/cifs/connect.c
>   *
> - *   Copyright (C) International Business Machines  Corp., 2002,2009
> + *   Copyright (C) International Business Machines  Corp., 2002,2011
>   *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>   *
>   *   This library is free software; you can redistribute it and/or modify
> @@ -1760,6 +1760,14 @@ static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
>  			   (struct sockaddr *)&vol->srcaddr))
>  		return 0;
>  
> +#ifdef CONFIG_CIFS_SMB2
> +	if ((server->is_smb2 == true) && (vol->use_smb2 == false))
> +		return 0;
> +
> +	if ((server->is_smb2 == false) && (vol->use_smb2 == true))
> +		return 0;
> +#endif /* CONFIG_CIFS_SMB2 */
> +
>  	if (!match_port(server, addr))
>  		return 0;
>  
> @@ -1884,6 +1892,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  
>  	tcp_ses->noblocksnd = volume_info->noblocksnd;
>  	tcp_ses->noautotune = volume_info->noautotune;
> +	/* BB should we set this unconditionally now, especially for SMB2 */
>  	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
>  	atomic_set(&tcp_ses->inFlight, 0);
>  	init_waitqueue_head(&tcp_ses->response_q);
> @@ -1927,6 +1936,11 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		goto out_err_crypto_release;
>  	}
>  
> +#ifdef CONFIG_CIFS_SMB2
> +	if (volume_info->use_smb2)
> +		tcp_ses->is_smb2 = true;
> +#endif /* CONFIG_CIFS_SMB2 */
> +
>  	/*
>  	 * since we're in a cifs function already, we know that
>  	 * this will succeed. No need for try_module_get().


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
