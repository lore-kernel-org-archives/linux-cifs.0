From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/19] Remove rfc1002 header from smb2 request structs
Date: Thu,  9 Nov 2017 12:14:14 +1100
Message-ID: <20171109011433.14468-1-lsahlber@redhat.com>
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
