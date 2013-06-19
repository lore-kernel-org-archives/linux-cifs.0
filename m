From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Dump SMB3 share capabilities and flags
Date: Wed, 19 Jun 2013 13:31:46 -0400
Message-ID: <20130619133146.76f7665a@tlielax.poochiereds.net>
References: <CAH2r5mvciRhWVYjh5Un-BSwU3wddsmMF1XuC63DxwR1J-NBz=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvciRhWVYjh5Un-BSwU3wddsmMF1XuC63DxwR1J-NBz=w@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Jun 2013 12:24:07 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> SMB3 protocol adds various optional per-share capabilities (and
> SMB3.02 adds one more beyond that).  Add ability to dump
> (/proc/fs/cifs/DebugData) the share capabilities and share flags to
> improve debugging.
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 856f8f5..9a39650 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -224,6 +224,8 @@ static int cifs_debug_data_proc_show(struct
> seq_file *m, void *v)
>  					seq_puts(m, " type: CDROM ");
>  				else
>  					seq_printf(m, " type: %d ", dev_type);
> +				if (server->ops->dump_share_caps)
> +					server->ops->dump_share_caps(m, tcon);
> 
>  				if (tcon->need_reconnect)
>  					seq_puts(m, "\tDISCONNECTED ");
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f13cbbe..d6f6939 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -223,6 +223,7 @@ struct smb_version_operations {
>  	void (*dump_detail)(void *);
>  	void (*clear_stats)(struct cifs_tcon *);
>  	void (*print_stats)(struct seq_file *m, struct cifs_tcon *);
> +	void (*dump_share_caps)(struct seq_file *, struct cifs_tcon *);
>  	/* verify the message */
>  	int (*check_message)(char *, unsigned int);
>  	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 14539c7..32bb62e 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -281,6 +281,25 @@ smb2_clear_stats(struct cifs_tcon *tcon)
>  }
> 
>  static void
> +smb2_dump_share_caps(struct seq_file *m, struct cifs_tcon *tcon)
> +{
> +	seq_puts(m, "\nShare Capabilities:");
> +	if (tcon->capabilities & SMB2_SHARE_CAP_DFS)
> +		seq_puts(m, " DFS,");
> +	if (tcon->capabilities & SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY)
> +		seq_puts(m, " CONTINUOUS AVAILABILITY,");
> +	if (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT)
> +		seq_puts(m, " SCALEOUT,");
> +	if (tcon->capabilities & SMB2_SHARE_CAP_CLUSTER)
> +		seq_puts(m, " CLUSTER,");
> +	if (tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC)
> +		seq_puts(m, " ASYMMETRIC,");
> +	if (tcon->capabilities == 0)
> +		seq_puts(m, " None");
> +	seq_printf(m, "\tShare Flags: %d", tcon->share_flags);
> +}
> +
> +static void
>  smb2_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
>  {
>  #ifdef CONFIG_CIFS_STATS
> @@ -645,6 +664,7 @@ struct smb_version_operations smb30_operations = {
>  	.dump_detail = smb2_dump_detail,
>  	.clear_stats = smb2_clear_stats,
>  	.print_stats = smb2_print_stats,
> +	.dump_share_caps = smb2_dump_share_caps,
>  	.is_oplock_break = smb2_is_valid_oplock_break,
>  	.need_neg = smb2_need_neg,
>  	.negotiate = smb2_negotiate,
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index cb155bf..a6237ae 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -741,6 +741,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses
> *ses, const char *tree,
>  	}
> 
>  	tcon->share_flags = le32_to_cpu(rsp->ShareFlags);
> +	tcon->capabilities = le32_to_cpu(rsp->Capabilities);
>  	tcon->maximal_access = le32_to_cpu(rsp->MaximalAccess);
>  	tcon->tidStatus = CifsGood;
>  	tcon->need_reconnect = false;
> 

Looks reasonable...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
