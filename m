From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: add new module parameter 'enable_oplocks'
Date: Tue, 11 Oct 2011 12:31:57 -0500
Message-ID: <CAH2r5mv_j-B_7C+jP=uq83v1towx5YzthS3cEBrChh4Sn2MmTw@mail.gmail.com>
References: <4E946788.3060101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E946788.3060101-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Does that really work - to disable oplocks you would need to reset both
the old (/proc/fs/cifs/OplockEnabled) and new module parm (oplock_enabl=
ed)
to zero.

We should be using one global for this, not two (the /proc/fs/cifs one
could be changed to affect "enable_oplocks")

On Tue, Oct 11, 2011 at 10:58 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>=
 wrote:
> Thus spake Jeff Layton:
>
> "Making that a module parm would allow you to set that parameter at b=
oot
> time without needing to add special startup scripts. IMO, all of the
> procfile "switches" under /proc/fs/cifs should be module parms
> instead."
>
> This patch doesn't alter the default behavior (Oplocks are enabled by
> default).
>
> To disable oplocks when loading the module, use
>
> =A0 modprobe cifs enable_oplocks=3D0
>
> (any of '0' or 'n' or 'N' conventions can be used).
>
> To disable oplocks at runtime using the new interface, use
>
> =A0 echo 0 > /sys/module/cifs/parameters/enable_oplocks
>
> The older /proc/fs/cifs/OplockEnabled interface will be deprecated
> after two releases. A subsequent patch will add an warning message
> about the deprecation.
>
> Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 | =A0 =A05 +++++
> =A0fs/cifs/cifsglob.h | =A0 =A03 +++
> =A0fs/cifs/dir.c =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/cifs/file.c =A0 =A0 | =A0 =A04 ++--
> =A04 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 3e29899..675ab40 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -81,6 +81,11 @@ module_param(echo_retries, ushort, 0644);
> =A0MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giv=
ing up and "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "reconnec=
ting server. Default: 5. 0 means "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "never re=
connect.");
> +unsigned int enable_oplocks =3D 1;
> +module_param(enable_oplocks, bool, 0644);
> +MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). =
Default:"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"y/Y=
/1");
> +
> =A0extern mempool_t *cifs_sm_req_poolp;
> =A0extern mempool_t *cifs_req_poolp;
> =A0extern mempool_t *cifs_mid_poolp;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 6255fa8..b3e229c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -936,6 +936,9 @@ GLOBAL_EXTERN unsigned int cifs_max_pending; /* M=
AX requests at once to server*/
> =A0/* reconnect after this many failed echo attempts */
> =A0GLOBAL_EXTERN unsigned short echo_retries;
>
> +/* enable or disable oplocks */
> +GLOBAL_EXTERN unsigned int enable_oplocks;
> +
> =A0GLOBAL_EXTERN struct rb_root uidtree;
> =A0GLOBAL_EXTERN struct rb_root gidtree;
> =A0GLOBAL_EXTERN spinlock_t siduidlock;
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 81914df..6529b69 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -165,7 +165,7 @@ cifs_create(struct inode *inode, struct dentry *d=
irentry, int mode,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(tlink);
>
> - =A0 =A0 =A0 if (oplockEnabled)
> + =A0 =A0 =A0 if (oplockEnabled || enable_oplocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D REQ_OPLOCK;
>
> =A0 =A0 =A0 =A0if (nd && (nd->flags & LOOKUP_OPEN))
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index bb71471..b76c31d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -369,7 +369,7 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> =A0 =A0 =A0 =A0cFYI(1, "inode =3D 0x%p file flags are 0x%x for %s",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, file->f_flags, full_path);
>
> - =A0 =A0 =A0 if (oplockEnabled)
> + =A0 =A0 =A0 if (oplockEnabled || enable_oplocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D REQ_OPLOCK;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D 0;
> @@ -493,7 +493,7 @@ static int cifs_reopen_file(struct cifsFileInfo *=
pCifsFile, bool can_flush)
> =A0 =A0 =A0 =A0cFYI(1, "inode =3D 0x%p file flags 0x%x for %s",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, pCifsFile->f_flags, full_path)=
;
>
> - =A0 =A0 =A0 if (oplockEnabled)
> + =A0 =A0 =A0 if (oplockEnabled || enable_oplocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D REQ_OPLOCK;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D 0;
>



--=20
Thanks,

Steve
