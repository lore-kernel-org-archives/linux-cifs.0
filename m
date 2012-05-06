From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/16] CIFS: Check for SMB2 vs CIFS in find_tcp_session
Date: Sun, 6 May 2012 10:01:29 -0400
Message-ID: <20120506100129.0b2f626b@corrin.poochiereds.net>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 26 Mar 2012 13:21:30 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    3 +++
>  fs/cifs/connect.c  |   16 +++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 9e28070..fbee8ef 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -267,6 +267,9 @@ struct TCP_Server_Info {
>  	char server_GUID[16];
>  	char sec_mode;
>  	bool session_estab; /* mark when very first sess is established */
> +#ifdef CONFIG_CIFS_SMB2
> +	bool is_smb2;	/* SMB2 not CIFS protocol negotiated */
> +#endif
>  	u16 dialect; /* dialect index that server chose */
>  	enum securityEnum secType;
>  	bool oplocks:1; /* enable oplocks */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 955f0a3..1fbc21f 100644
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
> @@ -2093,6 +2093,14 @@ static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
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

Again, booleans for this seem like a less than ideal solution. Better
to have this based on a version number or maybe a protocol version enum?

>  	if (!match_port(server, addr))
>  		return 0;
>  
> @@ -2217,6 +2225,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  
>  	tcp_ses->noblocksnd = volume_info->noblocksnd;
>  	tcp_ses->noautotune = volume_info->noautotune;
> +	/* BB should we set this unconditionally now, especially for SMB2 */
>  	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;

Why is it more important to use TCP_NODELAY for SMB2? The above comment
doesn't really say...

>  	tcp_ses->in_flight = 0;
>  	tcp_ses->credits = 1;
> @@ -2261,6 +2270,11 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  		goto out_err_crypto_release;
>  	}
>  
> +#ifdef CONFIG_CIFS_SMB2
> +	if (volume_info->use_smb2)
> +		tcp_ses->is_smb2 = true;
> +#endif /* CONFIG_CIFS_SMB2 */
> +

The above should instead set a pointer to a "struct
protocol_operations" or something. That struct could have a version
field within it and it would give you a mechanism to allow for
protocol-version specific behavior without resorting to sprinkling
"is_smb2" checks all over the code.

>  	/*
>  	 * since we're in a cifs function already, we know that
>  	 * this will succeed. No need for try_module_get().


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
