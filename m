From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] [SMB3] Fix warning on uninitialized buftype
Date: Sat, 28 Mar 2015 09:19:13 -0500
Message-ID: <CADT32e+mFhArKfV3Su5G1zkzG8KNp8RtgV49oV+P8zJ4x5i6kw@mail.gmail.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
	<1427434082-4299-2-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427434082-4299-2-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Mar 27, 2015 at 12:27 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Pointed out by coverity analyzer.  resp_buftype is
> not initialized in one path which can rarely log
> a spurious warning (buf is null so there will
> not be a problem with freeing data, but if buf_type
> were randomly set to wrong value could log a warning)
>
> Reported by Coverity (CID 1269144)
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 3417340..1b906de 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2114,7 +2114,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
>         struct kvec iov[2];
>         int rc = 0;
>         int len;
> -       int resp_buftype;
> +       int resp_buftype = CIFS_NO_BUFFER;
>         unsigned char *bufptr;
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses = tcon->ses;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
