From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial comment fix for cifs_invalidate_mapping
Date: Mon, 29 Nov 2010 20:14:20 +0300
Message-ID: <AANLkTi=suvFGxud3K3EV_Am4R19XJ+JngEFVeRhNbPPS@mail.gmail.com>
References: <1291050587-9642-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291050587-9642-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/29 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> Only the callers check whether the invalid_mapping flag is set and no=
t
> cifs_invalidate_mapping().
>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0fs/cifs/inode.c | =A0 =A04 +++-
> =A01 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ff7d299..669298f 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1670,7 +1670,9 @@ cifs_inode_needs_reval(struct inode *inode)
> =A0 =A0 =A0 =A0return false;
> =A0}
>
> -/* check invalid_mapping flag and zap the cache if it's set */
> +/*
> + * Zap the cache. Called when invalid_mapping flag is set.
> + */
> =A0static void
> =A0cifs_invalidate_mapping(struct inode *inode)
> =A0{

Looks correct.

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
