From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cifs: Add attribute read/write support to SMB2+
Date: Thu, 24 Aug 2017 11:24:54 +1000
Message-ID: <20170824012456.10977-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Tested against both Samba shares as well as Win7 shares.

Version 5:
* Learn how to use endianness macros correctly.

Version 4:
* Remove remaining CamelCase
* ea_value_length is __le16, not __u16

Version 3:
* No CamelCase in new code.
* No declarations inside loops.

Version 2:
* For reading attributes we need FILE_READ_EA not FILE_READ_ATTRIBUTES
