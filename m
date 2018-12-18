From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: return correct errors when pinning memory failed
 for direct I/O
Date: Mon, 17 Dec 2018 23:07:47 -0600
Message-ID: <CAH2r5muQVqOy1c0Mk0BBHBND_7oqqhyXUwGVp1M0ek7+onLAJw@mail.gmail.com>
References: <20181216224107.16164-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Stable <stable@vger.kernel.org>, jencce.kernel@gmail.com
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181216224107.16164-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Sun, Dec 16, 2018 at 4:44 PM Long Li <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> When pinning memory failed, we should return the correct error code and
> rewind the SMB credits.
>
> Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> Cc: stable@vger.kernel.org
> Cc: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/file.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c9bc56b..3467351 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2630,6 +2630,9 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
>                                         result, from->type,
>                                         from->iov_offset, from->count);
>                                 dump_stack();
> +
> +                               rc = result;
> +                               add_credits_and_wake_if(server, credits, 0);
>                                 break;
>                         }
>                         cur_len = (size_t)result;
> @@ -3313,13 +3316,16 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>                                         cur_len, &start);
>                         if (result < 0) {
>                                 cifs_dbg(VFS,
> -                                       "couldn't get user pages (cur_len=%zd)"
> +                                       "couldn't get user pages (rc=%zd)"
>                                         " iter type %d"
>                                         " iov_offset %zd count %zd\n",
>                                         result, direct_iov.type,
>                                         direct_iov.iov_offset,
>                                         direct_iov.count);
>                                 dump_stack();
> +
> +                               rc = result;
> +                               add_credits_and_wake_if(server, credits, 0);
>                                 break;
>                         }
>                         cur_len = (size_t)result;
> --
> 2.7.4
>


-- 
Thanks,

Steve
