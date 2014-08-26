From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v2] CIFS: Fix wrong restart readdir for SMB1
Date: Tue, 26 Aug 2014 10:26:54 -0500
Message-ID: <CAH2r5mtABcjpXg4huG83JRvDc-qx+Wv-wNtr1my+qJOcC-wBFw@mail.gmail.com>
References: <1409065484-7438-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	stable@vger.kernel.org
To: Pavel Shilovsky <pshilovsky@samba.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1409065484-7438-1-git-send-email-pshilovsky@samba.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Aug 26, 2014 at 10:04 AM, Pavel Shilovsky <pshilovsky@samba.org> wrote:
> The existing code calls server->ops->close() that is not
> right. This causes XFS test generic/310 to fail. Fix this
> by using server->ops->closedir() function.
>
> Cc: <stable@vger.kernel.org> # v3.7+
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
> ---
>  fs/cifs/readdir.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 798c80a..b334a89 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -596,8 +596,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
>                 if (server->ops->dir_needs_close(cfile)) {
>                         cfile->invalidHandle = true;
>                         spin_unlock(&cifs_file_list_lock);
> -                       if (server->ops->close)
> -                               server->ops->close(xid, tcon, &cfile->fid);
> +                       if (server->ops->close_dir)
> +                               server->ops->close_dir(xid, tcon, &cfile->fid);
>                 } else
>                         spin_unlock(&cifs_file_list_lock);
>                 if (cfile->srch_inf.ntwrk_buf_start) {
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
