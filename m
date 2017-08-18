From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cifs: Add attribute read/write support to SMB2+
Date: Fri, 18 Aug 2017 15:07:52 +1000
Message-ID: <20170818050754.24425-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following two patches add support to reading and writing attributes
on SMB2+ shares.

Tested against both Samba shares as well as Win7 shares.

Version 2:
* For reading attributes we need FILE_READ_EA not FILE_READ_ATTRIBUTES
