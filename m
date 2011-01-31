From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: aio and cifs
Date: Mon, 31 Jan 2011 12:05:29 +0100
Message-ID: <AANLkTinMdEPntK3be5qPLg2kPKhEmq6iLVuxr-HdcLUO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

as I've already mentioned here, I'm working on a fuse fs, and want to
make it work with aio.

Now I got it (finally) working on the localhost,well the first testprogram runs.
The same testprogram fails with an error when doing an aio write on a smb share.


Is doing an aio read and aio write possible on shares mounted with
cifs (by the automounter)?

I see that the logical blocksize is 4096, well reported on my system.

Stef
