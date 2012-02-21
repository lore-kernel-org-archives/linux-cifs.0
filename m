From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 5/8] cifs: make cifsFileInfo_get return the
 cifsFileInfo pointer
Date: Tue, 21 Feb 2012 11:46:03 +0400
Message-ID: <CAKywueR5W2jmwhJKy-9JNEJcL5Lc_BW-b84JGQPWO74hFCSwfA@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-6-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-6-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 =A04 +++-
> =A01 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 0e56b1e..4adad0a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -555,9 +555,11 @@ struct cifs_io_parms {
> =A0* Take a reference on the file private data. Must be called with
> =A0* cifs_file_list_lock held.
> =A0*/
> -static inline void cifsFileInfo_get(struct cifsFileInfo *cifs_file)
> +static inline
> +struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file=
)
> =A0{
> =A0 =A0 =A0 =A0++cifs_file->count;
> + =A0 =A0 =A0 return cifs_file;
> =A0}
>
> =A0void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
> --
> 1.7.7.6
>

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
