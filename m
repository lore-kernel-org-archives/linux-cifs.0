From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question about howto test notify with a fuse fs.
Date: Thu, 10 May 2012 11:22:28 +0200
Message-ID: <CANXojcznM1pMJO5pe7TXV1qED89J0+SdSz59yfwWJganZP896g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

earlier we spoke about monitoring SMB shares with cifs for file changes.

I've posted a question on samba-technical howto send a
SMB2_CHANGE_NOTIFY message to the server using smbclient:

https://lists.samba.org/archive/samba-technical/2012-May/083472.html

No reaction so far. I'm interested cause there are fuse fs's like
fusesmb (using libsmbclient) to
provide access to SMB shares. For me it's very easy to test notifyfs,
easier than cifs.
Do you maybe know howto send a message like that (and receive) using
libsmbclient?

Stef
