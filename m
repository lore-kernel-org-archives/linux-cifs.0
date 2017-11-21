From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/19 Version 4] cifs: remove rfc1002 from smb2 requests
Date: Mon, 20 Nov 2017 17:22:33 -0800
Message-ID: <CAKywueTabn0mDuagWUq5h4ByN_UszFZtpy4d5H_cy1qfEPZHEw@mail.gmail.com>
References: <20171121000442.24888-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121000442.24888-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-20 16:04 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Steve, All,
>
> Please find an updated version of the patch series to get rid of the
> rfc1002 header from all request structures in SMB2.
>
> Version 2:
> * changed SendReceive3 to smb2_send_recv
> * fixed a Buffer[1] error that aaptel@xxxxxxxx reported
>
> Version 3:
> * Change SMB2_read() to use smb2_send_recv instead of cifs_send_recv
> * Fix smb2_negotiate_req where we didnt update the total length to
> accomodate smb2 contexts.
> * Fix smb2_lease_ack where I forgot to bump total length by 12.
>
> Version 4:
> * Fix incorrect length in smb2_lockv
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Finished reviewing patches and testing with cthon and xfstests.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Aurelien, a lot of error messages like "CIFS VFS: ioctl error in
smb2_get_dfs_refer rc=-2" are being written into syslog. What do you
think about decreasing the log level of this message?

--
Best regards,
Pavel Shilovsky
