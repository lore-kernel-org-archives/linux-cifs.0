From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch
Date: Fri, 2 Dec 2011 11:08:31 +0400
Message-ID: <CAKywueSx7efJWX7N8v+KVxRfAsgdFyMx6rc2F7+izpsC-Hcrbg@mail.gmail.com>
References: <4ED86453.2040007@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ED86453.2040007-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/12/2 Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>:
> The stable release 2.6.32.32 added the upstream commit
> 12fed00de963433128b5366a21a55808fab2f756. However, one of the hunks o=
f
> the original patch seems missing from the stable backport which can b=
e
> found here:
> =A0 http://permalink.gmane.org/gmane.linux.kernel.stable/5676
>
> This hunk corresponds to the change in is_valid_oplock_break() at
> fs/cifs/misc.c.
>
> This patch backports the missing hunk and is against
> linux-2.6.32.y stable kernel.
>
>
> Cc: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
> ---
> [PS. not very happy about the subject line and changelog.
> =A0Feel free to modify as you see fit.]
>
> =A0fs/cifs/misc.c | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index d27d4ec..7055827 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -584,6 +584,9 @@ is_valid_oplock_break(struct smb_hdr *buf, struct=
 TCP_Server_Info *srv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsI=
node->clientCanCacheAll =3D false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (pS=
MB->OplockLevel =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0pCifsInode->clientCanCacheRead =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if=
 (pSMB->OplockLevel =3D=3D OPLOCK_READ)
pSMB->OplockLevel can either be 0 or 1 here but OPLOCK_READ is 3 -
this should be:
"else if (pSMB->OplockLevel)"

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 pCifsInode->clientCanCacheRead =3D true;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 slow_work_enqueue(&netfile->oplock_break);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cERROR(1, ("failed to enqueue oplock "



--=20
Best regards,
Pavel Shilovsky.
