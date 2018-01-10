From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] CIFS: SMBD: work around gcc -Wmaybe-uninitialized warning
Date: Wed, 10 Jan 2018 21:55:48 +0000
Message-ID: <MWHPR21MB0846F519ADCDDF1B238187ADCE110@MWHPR21MB0846.namprd21.prod.outlook.com>
References: <20180110205137.2044979-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110205137.2044979-1-arnd-r2nGTMty4D4@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> GCC versions from 4.9 to 6.3 produce a false-positive warning when dealin=
g
> with a conditional spin_lock_irqsave():
>=20
> fs/cifs/smbdirect.c: In function 'smbd_recv_buf':
> include/linux/spinlock.h:260:3: warning: 'flags' may be used uninitialize=
d in
> this function [-Wmaybe-uninitialized]
>=20
> This function calls some sleeping interfaces, so it is clear that it does=
 not get
> called with interrupts disabled and there is no need to save the irq stat=
e
> before taking the spinlock. This lets us remove the variable, which makes=
 the
> function slightly more efficient and avoids the warning.
>=20
> A further cleanup could do the same change for other functions in this fi=
le,
> but I did not want to take this too far for now.
>=20
> Fixes: ac69f66e54ca ("CIFS: SMBD: Implement function to receive data via
> RDMA receive")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Reviewed-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

> ---
>  fs/cifs/smbdirect.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c index
> f527e22650f5..f9234ed83a60 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1862,7 +1862,6 @@ int smbd_recv_buf(struct smbd_connection *info,
> char *buf, unsigned int size)
>  	int to_copy, to_read, data_read, offset;
>  	u32 data_length, remaining_data_length, data_offset;
>  	int rc;
> -	unsigned long flags;
>=20
>  again:
>  	if (info->transport_status !=3D SMBD_CONNECTED) { @@ -1935,15
> +1934,13 @@ int smbd_recv_buf(struct smbd_connection *info, char *buf,
> unsigned int size)
>  				 * end of the queue
>  				 */
>  				if (!queue_length)
> -					spin_lock_irqsave(
> -						&info-
> >reassembly_queue_lock,
> -						flags);
> +					spin_lock_irq(
> +						&info-
> >reassembly_queue_lock);
>  				list_del(&response->list);
>  				queue_removed++;
>  				if (!queue_length)
> -					spin_unlock_irqrestore(
> -						&info-
> >reassembly_queue_lock,
> -						flags);
> +					spin_unlock_irq(
> +						&info-
> >reassembly_queue_lock);
>=20
>  				info->count_reassembly_queue--;
>  				info-
> >count_dequeue_reassembly_queue++;
> @@ -1963,10 +1960,10 @@ int smbd_recv_buf(struct smbd_connection
> *info, char *buf, unsigned int size)
>  				to_read, data_read, offset);
>  		}
>=20
> -		spin_lock_irqsave(&info->reassembly_queue_lock, flags);
> +		spin_lock_irq(&info->reassembly_queue_lock);
>  		info->reassembly_data_length -=3D data_read;
>  		info->reassembly_queue_length -=3D queue_removed;
> -		spin_unlock_irqrestore(&info->reassembly_queue_lock,
> flags);
> +		spin_unlock_irq(&info->reassembly_queue_lock);
>=20
>  		info->first_entry_offset =3D offset;
>  		log_read(INFO, "returning to thread data_read=3D%d "
> --
> 2.9.0
