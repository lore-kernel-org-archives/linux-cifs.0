From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/12] cifs: various fixes for NULL pointers
Date: Wed, 11 Oct 2017 12:59:15 +1100
Message-ID: <20171011015927.7669-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


List, Steve

We recently had two very similar issues of dereferencing uninitialized pointer
when Sendreceive2() would have certain failures.

I went through the rest of smb2pdu.c to check for similar issues.

These are what I found. Including a memory leak in smb2_lockv().

These patches are all small and kept separate for review.
It might make sense to collapse all these patches into a single one. I don't
know. Up to you.
