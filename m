From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cthon failure
Date: Wed, 20 Aug 2014 10:05:47 +0400
Message-ID: <CAKywueTzRheGbgKPijF9Wk5LiTx9LL3BHm4zgfMSB7-FzSLpUw@mail.gmail.com>
References: <CAH2r5mtN1cHocFcVPsDC9kVq5c9DyxazmTBFQp_wUVCPNsvV7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtN1cHocFcVPsDC9kVq5c9DyxazmTBFQp_wUVCPNsvV7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-08-20 6:33 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Noticed that even with Unix Extensions on cifs mount that Samba
> refuses to delete a file in this scenario (locally and presumably over
> nfs it still works since it is in cthon suite).  This causes
> connectathon special tests to fail
>
> touch newfile
> chmod 0000 newfile
> rm newfile
>
> (works locally but samba rejects)
>
> Samba 4.1 rejects posix unlink (set path info) STATUS_CANNOT_DELETE
> then client falls back to SMB unlink which fails.  STATUS_CANNOT_DELETE
> then client falls back to a set path info of file info basic which
> also fails STATUS_ACCESS_DENIED
>
> Will do quick test with Samba master when build completes - but does
> this server unlink bug look familiar (or am I missing an smb.conf that
> I have forgotten about)?


Steve,

I faced with exactly the same problem during my testing.

This behavior appears after setting

"store dos attributes = Yes"

in smb.conf. Without this option all Cthon tests passes fine.

I am using Samba 4.1.7 version (Ubuntu version from Jelmer's ppa
https://launchpad.net/~jelmer/+archive/ubuntu/samba-backports).

-- 
Best regards,
Pavel Shilovsky.
