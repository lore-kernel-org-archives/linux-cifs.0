From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v2 01/19] CIFS: Add RDMA mount option
Date: Mon, 21 Aug 2017 07:36:01 +0300
Message-ID: <20170821043601.GD1724@mtr-leonro.local>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <1503255883-3041-2-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503255883-3041-2-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 20, 2017 at 12:04:25PM -0700, Long Li wrote:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> Add "rdma" to CIFS mount option, which tells CIFS this is for connecting to a SMB server over SMBDirect. Add checks to validate this feature is only used on SMB 3.X dialects.
>
> To connect to SMBDirect, use "mount.cifs -o rdma,vers=3.x".
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |  2 ++
>  fs/cifs/cifsfs.c     |  2 ++
>  fs/cifs/cifsglob.h   |  3 +++
>  fs/cifs/connect.c    | 25 ++++++++++++++++++++++++-
>  4 files changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 9727e1d..ba0870d 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -171,6 +171,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  				ses->ses_count, ses->serverOS, ses->serverNOS,
>  				ses->capabilities, ses->status);
>  			}
> +			if (server->rdma)
> +				seq_printf(m, "RDMA\n\t");
>  			seq_printf(m, "TCP status: %d\n\tLocal Users To "
>  				   "Server: %d SecMode: 0x%x Req On Wire: %d",
>  				   server->tcpStatus, server->srv_count,
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index fe0c8dc..a628800 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -330,6 +330,8 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
>  	default:
>  		seq_puts(s, "(unknown)");
>  	}
> +	if (server->rdma)
> +		seq_puts(s, ",rdma");
>  }
>
>  static void
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 8289f95..703c2fb 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -531,6 +531,7 @@ struct smb_vol {
>  	bool nopersistent:1;
>  	bool resilient:1; /* noresilient not required since not fored for CA */
>  	bool domainauto:1;
> +	bool rdma:1;
>  	unsigned int rsize;
>  	unsigned int wsize;
>  	bool sockopt_tcp_nodelay:1;
> @@ -649,6 +650,8 @@ struct TCP_Server_Info {
>  	bool	sec_kerberos;		/* supports plain Kerberos */
>  	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
>  	bool	large_buf;		/* is current buffer large? */
> +	/* use SMBD connection instead of socket */
> +	bool	rdma;
>  	struct delayed_work	echo; /* echo ping workqueue job */
>  	char	*smallbuf;	/* pointer to current "small" buffer */
>  	char	*bigbuf;	/* pointer to current "big" buffer */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2eeaac6..d5d0ecd 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -94,7 +94,7 @@ enum {
>  	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
>  	Opt_persistent, Opt_nopersistent,
>  	Opt_resilient, Opt_noresilient,
> -	Opt_domainauto,
> +	Opt_domainauto, Opt_rdma,
>
>  	/* Mount options which take numeric value */
>  	Opt_backupuid, Opt_backupgid, Opt_uid,
> @@ -185,6 +185,7 @@ static const match_table_t cifs_mount_option_tokens = {
>  	{ Opt_resilient, "resilienthandles"},
>  	{ Opt_noresilient, "noresilienthandles"},
>  	{ Opt_domainauto, "domainauto"},
> +	{ Opt_rdma, "rdma"},
>
>  	{ Opt_backupuid, "backupuid=%s" },
>  	{ Opt_backupgid, "backupgid=%s" },
> @@ -1541,6 +1542,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  		case Opt_domainauto:
>  			vol->domainauto = true;
>  			break;
> +		case Opt_rdma:
> +			vol->rdma = true;
> +			break;
>
>  		/* Numeric Values */
>  		case Opt_backupuid:
> @@ -1931,6 +1935,21 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  		goto cifs_parse_mount_err;
>  	}
>
> +	if (vol->rdma) {
> +		switch (vol->vals->protocol_id) {
> +		case SMB30_PROT_ID:
> +		case SMB302_PROT_ID:
> +		case SMB311_PROT_ID:
> +			break;

In cover letter, you wrote that this option is relevant for 3.X versions,
so why do you write explicitly versions and don't do check if (version > SMB30_PROT_ID) ...?

Thanks

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmaYzEACgkQ5GN7iDZy
WKc33w/8DK2askGTFKvt03g0R45z2gd7eG/J99I6o5rpiTsUlB6BW7tSYvg+o0Mf
4u2SRMRIdHhzSklHIVFs5+O8lp4r57O6rDYhdtRmihNmy74yd4fd/ly7Pt4UhYUD
bFklghfmQFbEE0RXZl/2kpO29Huc3LXe9//3w7Q/jqH3aywliTaFKYzMxqZcrC8h
B/G4CNbEmzJEF+mXos8dM3r4kyT31IqAwYqrvHQxpd0YRjakqBGmwdyyguE1Y8uq
SqK2Y1UJ0EiIOOAR2HH+y/tvtxvaV1yC3jiN8StU8Ic5ZLAIFI5AwhYMYtOXpkah
6uqgo9+yLX6J2AouT/DXnflBVYJD1EZnF24iIHUaad/aYRC55haUiPZhn7Bul3dF
eZLSddfFk7YOOkOk2/V6yygAv54DS+p9wRaASeyK52rWeTOd1FZS0fI3oEcvcO09
I2Apw/KIsntAqfGpEa9IOf5ua4opHol0nKFZ7rtR5E0oaD9NclbsPnHbXwTHamma
WYoKa6vKqS8GY6fV/O7912PCVbKLMDeQ+YIrzHQOPP4/PaiKulKQG9qrhRA3skrC
EwubmQ7XNtLNTTfRIvQq0vPChbnXiltunjR9CM7f0hIpXmBBRNB67/htIGFeNl2q
A2cYDk9aj/LOgZl7peVjNQQOOkzoSJd19Hxfdemlfs7GhxjzjNI=
=lpqK
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
