From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/10] cifs: Remove rfc1002 header from smb2 request structs
Date: Sun, 19 Nov 2017 19:39:44 -0600
Message-ID: <CAH2r5mvaV=GX2vR3abQe8hqEWvi=s+qGtqPoiyTS0ObGmpb02g@mail.gmail.com>
References: <20171120002447.32322-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120002447.32322-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged all but patch 14, 15, 19 from that series in cifs-2.6.git
for-next (giving Pavel a chance to have an opinion on the changes he
suggested to patch 14).

Manually added the missing reviewed by (from Aurelien, and acked by
from Pavel) to the unchanged patches.



On Sun, Nov 19, 2017 at 6:24 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Steve, All,
>
> Please find an updated version of the patch series to get rid of the
> rfc1002 header from all request structures in SMB2.
>
> Version 2:
> * changed SendReceive3 to smb2_send_recv
> * fixed a Buffer[1] error that aaptel-IBi9RG/b67k@public.gmane.org reported
>
> Version 3:
> * Change SMB2_read() to use smb2_send_recv instead of cifs_send_recv
> * Fix smb2_negotiate_req where we didnt update the total length to
> accomodate smb2 contexts.
> * Fix smb2_lease_ack where I forgot to bump total length by 12.
>



-- 
Thanks,

Steve
