From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/14] cifs: add compounding support for smb2+
Date: Tue, 13 Feb 2018 15:42:20 +1100
Message-ID: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, all,

Please find attached a series that adds the plumbing to do compounding
as well as, the last patch, changing smb2_queryfs() to use a
compound for the Create/Query/Close cycle.

There is still a small bug in SMB2_read() when using SMB3 encryption
in that we get the wrong buffer (offset by 4) for the data, but I will
look into that.
As the series is somewhat large, that does not preclude us from starting to
review.

Basic manual testing looks promising so far.
The only operation so far that will use compounding is smb2_queryfs()
so far. You can use 'df' to invoke this operation if you want to look
at what the PDUs for compounding looks like on the wire.

Once we get this finished and ready to merge, we can move on and convert
all other create/set|query/close operations to be compounded too.
that should be very easy.

Wooohooo
