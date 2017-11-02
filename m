From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/19] cifs: remove rfc1002 header from all smb2 requests
Date: Thu,  2 Nov 2017 18:02:53 +1100
Message-ID: <20171102070312.18903-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, all

I split the !1002 patch into a small serie for easier review.

This patch series removes the NBSS 4 byte header from all the
smb2 request structures.
Instead of computing and tweaking the header as part of composing
the SMB2 request, we now compute it in the new SendReceive3() function
that is used by all of SMB2.

This eliminates a huge amount of magic +4 / -4 in the code
and all the ugly inc_rfc1002.... stuff where the old code would
constantly tweak the length field as it was building the PDU.

So overall it also simplifies the code in some places I think.


This series is to prepare for and make it easier to add smb2 compounding
in the future as then we will need to construct multiple SMB2 pdus
and wrap them all insode one single rfc1002 header.


As a later series, before we get to the actual compounding, I plan to
do a similar change to all the reply structures and remove the rfc1002
header from them all too.


Please review, and test.
