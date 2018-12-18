From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: use the correct length when pinning memory for
 direct I/O for write
Date: Mon, 17 Dec 2018 23:05:48 -0600
Message-ID: <CAH2r5muQnmCG2qJBfoDSm59x0hfJo4MtCxqOkCLWh46iYdFNNg@mail.gmail.com>
References: <20181216231704.16761-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Stable <stable@vger.kernel.org>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181216231704.16761-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Sun, Dec 16, 2018 at 5:18 PM Long Li <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> The current code attempts to pin memory using the largest possible wsize
> based on the currect SMB credits. This doesn't cause kernel oops but this is
> not optimal as we may pin more pages then actually needed.
>
> Fix this by only pinning what are needed for doing this write I/O.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/cifs/file.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 3467351..c23bf9d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2617,11 +2617,13 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
>                 if (rc)
>                         break;
>
> +               cur_len = min_t(const size_t, len, wsize);
> +
>                 if (ctx->direct_io) {
>                         ssize_t result;
>
>                         result = iov_iter_get_pages_alloc(
> -                               from, &pagevec, wsize, &start);
> +                               from, &pagevec, cur_len, &start);
>                         if (result < 0) {
>                                 cifs_dbg(VFS,
>                                         "direct_writev couldn't get user pages "
> --
> 2.7.4
>


-- 
Thanks,

Steve
