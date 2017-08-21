From: Long Li <longli@microsoft.com>
Subject: RE: [Patch v2 01/19] CIFS: Add RDMA mount option
Date: Mon, 21 Aug 2017 18:18:59 +0000
Message-ID: <MWHPR21MB01906CDDC71DE9BA4183BA6DCE870@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <1503255883-3041-2-git-send-email-longli@exchange.microsoft.com>
 <20170821043601.GD1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Tom Talpey" <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170821043601.GD1724@mtr-leonro.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Sunday, August 20, 2017 9:36 PM
> To: Long Li <longli@microsoft.com>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; Christoph Hellwig <hch@infradead.org>; Tom Talpey
> <ttalpey@microsoft.com>; Matthew Wilcox <mawilcox@microsoft.com>;
> Long Li <longli@microsoft.com>
> Subject: Re: [Patch v2 01/19] CIFS: Add RDMA mount option
>=20
> On Sun, Aug 20, 2017 at 12:04:25PM -0700, Long Li wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > Add "rdma" to CIFS mount option, which tells CIFS this is for connectin=
g to a
> SMB server over SMBDirect. Add checks to validate this feature is only us=
ed
> on SMB 3.X dialects.
> >
> > To connect to SMBDirect, use "mount.cifs -o rdma,vers=3D3.x".
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
> > ---
> >  fs/cifs/cifs_debug.c |  2 ++
> >  fs/cifs/cifsfs.c     |  2 ++
> >  fs/cifs/cifsglob.h   |  3 +++
> >  fs/cifs/connect.c    | 25 ++++++++++++++++++++++++-
> >  4 files changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c index
> > 9727e1d..ba0870d 100644
> > --- a/fs/cifs/cifs_debug.c
> > +++ b/fs/cifs/cifs_debug.c
> > @@ -171,6 +171,8 @@ static int cifs_debug_data_proc_show(struct
> seq_file *m, void *v)
> >  				ses->ses_count, ses->serverOS, ses-
> >serverNOS,
> >  				ses->capabilities, ses->status);
> >  			}
> > +			if (server->rdma)
> > +				seq_printf(m, "RDMA\n\t");
> >  			seq_printf(m, "TCP status: %d\n\tLocal Users To "
> >  				   "Server: %d SecMode: 0x%x Req On
> Wire: %d",
> >  				   server->tcpStatus, server->srv_count, diff -
> -git
> > a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c index fe0c8dc..a628800 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -330,6 +330,8 @@ cifs_show_address(struct seq_file *s, struct
> TCP_Server_Info *server)
> >  	default:
> >  		seq_puts(s, "(unknown)");
> >  	}
> > +	if (server->rdma)
> > +		seq_puts(s, ",rdma");
> >  }
> >
> >  static void
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h index
> > 8289f95..703c2fb 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -531,6 +531,7 @@ struct smb_vol {
> >  	bool nopersistent:1;
> >  	bool resilient:1; /* noresilient not required since not fored for CA =
*/
> >  	bool domainauto:1;
> > +	bool rdma:1;
> >  	unsigned int rsize;
> >  	unsigned int wsize;
> >  	bool sockopt_tcp_nodelay:1;
> > @@ -649,6 +650,8 @@ struct TCP_Server_Info {
> >  	bool	sec_kerberos;		/* supports plain Kerberos */
> >  	bool	sec_mskerberos;		/* supports legacy MS
> Kerberos */
> >  	bool	large_buf;		/* is current buffer large? */
> > +	/* use SMBD connection instead of socket */
> > +	bool	rdma;
> >  	struct delayed_work	echo; /* echo ping workqueue job */
> >  	char	*smallbuf;	/* pointer to current "small" buffer */
> >  	char	*bigbuf;	/* pointer to current "big" buffer */
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c index
> > 2eeaac6..d5d0ecd 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -94,7 +94,7 @@ enum {
> >  	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
> >  	Opt_persistent, Opt_nopersistent,
> >  	Opt_resilient, Opt_noresilient,
> > -	Opt_domainauto,
> > +	Opt_domainauto, Opt_rdma,
> >
> >  	/* Mount options which take numeric value */
> >  	Opt_backupuid, Opt_backupgid, Opt_uid, @@ -185,6 +185,7 @@
> static
> > const match_table_t cifs_mount_option_tokens =3D {
> >  	{ Opt_resilient, "resilienthandles"},
> >  	{ Opt_noresilient, "noresilienthandles"},
> >  	{ Opt_domainauto, "domainauto"},
> > +	{ Opt_rdma, "rdma"},
> >
> >  	{ Opt_backupuid, "backupuid=3D%s" },
> >  	{ Opt_backupgid, "backupgid=3D%s" },
> > @@ -1541,6 +1542,9 @@ cifs_parse_mount_options(const char
> *mountdata, const char *devname,
> >  		case Opt_domainauto:
> >  			vol->domainauto =3D true;
> >  			break;
> > +		case Opt_rdma:
> > +			vol->rdma =3D true;
> > +			break;
> >
> >  		/* Numeric Values */
> >  		case Opt_backupuid:
> > @@ -1931,6 +1935,21 @@ cifs_parse_mount_options(const char
> *mountdata, const char *devname,
> >  		goto cifs_parse_mount_err;
> >  	}
> >
> > +	if (vol->rdma) {
> > +		switch (vol->vals->protocol_id) {
> > +		case SMB30_PROT_ID:
> > +		case SMB302_PROT_ID:
> > +		case SMB311_PROT_ID:
> > +			break;
>=20
> In cover letter, you wrote that this option is relevant for 3.X versions,=
 so why
> do you write explicitly versions and don't do check if (version >
> SMB30_PROT_ID) ...?

Thanks for pointing it out. I will fix this.

>=20
> Thanks
