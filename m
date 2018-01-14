From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: work around gcc -Wmaybe-uninitialized warning
Date: Sun, 14 Jan 2018 13:07:42 -0600
Message-ID: <CAH2r5mvYkZnoSnr1+6jvJKavwfQJvJFHw-E8vNCwOHKXWNNQtw@mail.gmail.com>
References: <20180110205137.2044979-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110205137.2044979-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

Also noticed a few sparse warnings in the same file that need to be cleaned up

On Wed, Jan 10, 2018 at 2:51 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> GCC versions from 4.9 to 6.3 produce a false-positive warning when
> dealing with a conditional spin_lock_irqsave():
>
> fs/cifs/smbdirect.c: In function 'smbd_recv_buf':
> include/linux/spinlock.h:260:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
>
> This function calls some sleeping interfaces, so it is clear that it
> does not get called with interrupts disabled and there is no need
> to save the irq state before taking the spinlock. This lets us
> remove the variable, which makes the function slightly more efficient
> and avoids the warning.
>
> A further cleanup could do the same change for other functions in this
> file, but I did not want to take this too far for now.
>
> Fixes: ac69f66e54ca ("CIFS: SMBD: Implement function to receive data via RDMA receive")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  fs/cifs/smbdirect.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index f527e22650f5..f9234ed83a60 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1862,7 +1862,6 @@ int smbd_recv_buf(struct smbd_connection *info, char *buf, unsigned int size)
>         int to_copy, to_read, data_read, offset;
>         u32 data_length, remaining_data_length, data_offset;
>         int rc;
> -       unsigned long flags;
>
>  again:
>         if (info->transport_status != SMBD_CONNECTED) {
> @@ -1935,15 +1934,13 @@ int smbd_recv_buf(struct smbd_connection *info, char *buf, unsigned int size)
>                                  * end of the queue
>                                  */
>                                 if (!queue_length)
> -                                       spin_lock_irqsave(
> -                                               &info->reassembly_queue_lock,
> -                                               flags);
> +                                       spin_lock_irq(
> +                                               &info->reassembly_queue_lock);
>                                 list_del(&response->list);
>                                 queue_removed++;
>                                 if (!queue_length)
> -                                       spin_unlock_irqrestore(
> -                                               &info->reassembly_queue_lock,
> -                                               flags);
> +                                       spin_unlock_irq(
> +                                               &info->reassembly_queue_lock);
>
>                                 info->count_reassembly_queue--;
>                                 info->count_dequeue_reassembly_queue++;
> @@ -1963,10 +1960,10 @@ int smbd_recv_buf(struct smbd_connection *info, char *buf, unsigned int size)
>                                 to_read, data_read, offset);
>                 }
>
> -               spin_lock_irqsave(&info->reassembly_queue_lock, flags);
> +               spin_lock_irq(&info->reassembly_queue_lock);
>                 info->reassembly_data_length -= data_read;
>                 info->reassembly_queue_length -= queue_removed;
> -               spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
> +               spin_unlock_irq(&info->reassembly_queue_lock);
>
>                 info->first_entry_offset = offset;
>                 log_read(INFO, "returning to thread data_read=%d "
> --
> 2.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
