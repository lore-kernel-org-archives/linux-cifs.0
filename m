From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/10] cifs: Remove rfc1002 header from smb2 request structs
Date: Mon, 20 Nov 2017 11:24:28 +1100
Message-ID: <20171120002447.32322-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, All,

Please find an updated version of the patch series to get rid of the
rfc1002 header from all request structures in SMB2.

Version 2:
* changed SendReceive3 to smb2_send_recv
* fixed a Buffer[1] error that aaptel-IBi9RG/b67k@public.gmane.org reported

Version 3:
* Change SMB2_read() to use smb2_send_recv instead of cifs_send_recv
* Fix smb2_negotiate_req where we didnt update the total length to
accomodate smb2 contexts.
* Fix smb2_lease_ack where I forgot to bump total length by 12.
