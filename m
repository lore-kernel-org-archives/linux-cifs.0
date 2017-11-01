From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/1] Remove the rfc1002 length from all SMB2 requests
Date: Wed,  1 Nov 2017 12:51:43 +1100
Message-ID: <20171101015144.2034-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, All,

Do not merge yet. It is still WIP but I want some review.

I have been looking at compounding, but before we can do that easily
we need to break the layering violation that happens between the
RFC1002 SM Length field and the SMB2 PDUs.

This patch removes the 4 byte RFC1002 length header from all SMB2 request
structures and at the same time also gets rid of a lot of the
magic +4 / -4 tweaking that was used all over the code to cope with that
the structures were actually bigger than they should be. It also
gets rid of a lot of magic "tweak the first four bytes" as the dynamic
parts of the SMB2 pdus are constructed.

Additionally we have a new SendReceive3() function that computes and attaches
the rfc1002 length from scratch, based on the input kiov containing the
smb2 pdu and data.


This will simplify later for compounding when we will use the SMB2_*()
functions to create multiple SMB2 pdus that will all be wrapped inside
one single rfc1002 header.


It would be nice to do the similar split of the nbss and smb2 layers
for all the reply structures as well but that can go in a different patch.
