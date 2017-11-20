From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove unused variable from SMB2_read
Date: Mon, 20 Nov 2017 17:20:42 -0600
Message-ID: <CAH2r5muqVmwzFA1syQUjA0JfY4Rxksx0E88n3h9X5+n+2nkGrQ@mail.gmail.com>
References: <20171120225745.1384-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120225745.1384-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Mon, Nov 20, 2017 at 4:57 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index a555d2b39b30..3ff0b08eaac2 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2629,8 +2629,6 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>         struct kvec iov[1];
>         struct kvec rsp_iov;
>         unsigned int total_len;
> -       struct smb_rqst rqst = { .rq_iov = iov,
> -                                .rq_nvec = 2 };
>         int flags = CIFS_LOG_ERROR;
>         struct cifs_ses *ses = io_parms->tcon->ses;
>
> --
> 2.13.3
>



-- 
Thanks,

Steve
