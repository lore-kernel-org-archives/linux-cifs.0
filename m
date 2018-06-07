From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [Patch v2 15/15] CIFS: Add direct I/O functions to file_operations
Date: Thu, 7 Jun 2018 04:17:00 -0700
Message-ID: <CAKywueRi=9j=3xPzv1wBJKT2KaZzor1=TMYHiTUUSL5KXrp8QA@mail.gmail.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com> <20180530194807.31657-16-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-16-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2018-05-30 12:48 GMT-07:00 Long Li <longli@linuxonhyperv.com>:
> From: Long Li <longli@microsoft.com>
>
> With direct read/write functions implemented, add them to file_operations.
> When mounting with "cache=none", CIFS uses direct I/O.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/cifsfs.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 62f1662..e84f8c2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1113,9 +1113,8 @@ const struct file_operations cifs_file_strict_ops = {
>  };
>
>  const struct file_operations cifs_file_direct_ops = {
> -       /* BB reevaluate whether they can be done with directio, no cache */
> -       .read_iter = cifs_user_readv,
> -       .write_iter = cifs_user_writev,
> +       .read_iter = cifs_direct_readv,
> +       .write_iter = cifs_direct_writev,

I would postpone making this change until we have asynchronous I/O
support for direct mode.

--
Best regards,
Pavel Shilovsky
