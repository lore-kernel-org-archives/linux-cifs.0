From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] cifs: smb2ops: Fix NULL check in smb2_query_symlink
Date: Fri, 13 Apr 2018 16:55:01 -0700
Message-ID: <CAKywueRA5x3uVfRKb=7cRHSwqi03dWRQoS7MTpTxAX8w5NEqDg@mail.gmail.com>
References: <20180413151329.GA27418@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413151329.GA27418@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2018-04-13 8:13 GMT-07:00 Gustavo A. R. Silva <gustavo@embeddedor.com>:
> The current code null checks variable err_buf, which is always null
> when it is checked, hence utf16_path is free'd and the function
> returns -ENOENT everytime it is called, making it impossible for the
> execution path to reach the following code:
>
> err_buf = err_iov.iov_base;
>
> Fix this by null checking err_iov.iov_base instead of err_buf. Also,
> notice that err_buf no longer needs to be initialized to NULL.
>
> Addresses-Coverity-ID: 1467876 ("Logically dead code")
> Fixes: 2d636199e400 ("cifs: Change SMB2_open to return an iov for the error parameter")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  fs/cifs/smb2ops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index b4ae932..38ebf3f 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1452,7 +1452,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>         struct cifs_open_parms oparms;
>         struct cifs_fid fid;
>         struct kvec err_iov = {NULL, 0};
> -       struct smb2_err_rsp *err_buf = NULL;
> +       struct smb2_err_rsp *err_buf;
>         struct smb2_symlink_err_rsp *symlink;
>         unsigned int sub_len;
>         unsigned int sub_offset;
> @@ -1476,7 +1476,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>
>         rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, &err_iov);
>
> -       if (!rc || !err_buf) {
> +       if (!rc || !err_iov.iov_base) {
>                 kfree(utf16_path);
>                 return -ENOENT;
>         }
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
