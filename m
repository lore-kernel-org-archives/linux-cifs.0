From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 work status
Date: Thu, 4 Aug 2011 00:20:04 +0400
Message-ID: <CAKywueRMDnm3t3bYrGbBf85UrpehacSJD2YCYTfPkYhrW9Aw-Q@mail.gmail.com>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
	<CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
	<CAKywueTDhS_FHtssdVbSrBiPksngYsmotU69u9S1QELnm9Vh+w@mail.gmail.com>
	<CAKywueQ2B6R7EzB2t4WDfR15Ot-x823zBzy9nQwRwZSxdpco1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQ2B6R7EzB2t4WDfR15Ot-x823zBzy9nQwRwZSxdpco1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Updated smb2-dev branch. Changes:
1) get_file_info (and convert smb2_open and smb2_create to use it),
2) rename,
3) hardlink,
4) flush,
5) other cleanups and bugfixes.

Also, I created a mirror repository on git.altlinux.org -
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev
- due to the problems with git.etersoft.ru.

Next, I am going to start working with oplocks and SMB2.1 leases related code.

-- 
Best regards,
Pavel Shilovsky.
