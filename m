From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 work status
Date: Tue, 26 Jul 2011 23:41:08 +0400
Message-ID: <CAKywueQ2B6R7EzB2t4WDfR15Ot-x823zBzy9nQwRwZSxdpco1Q@mail.gmail.com>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
	<CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
	<CAKywueTDhS_FHtssdVbSrBiPksngYsmotU69u9S1QELnm9Vh+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTDhS_FHtssdVbSrBiPksngYsmotU69u9S1QELnm9Vh+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Updated smb2-dev branch
(http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev)
with the following changes:
1) rebased to current master
2) create support
3) readdir support
4) cifs_get_inode_info refactoring

Also, I refactored the code a little - changed statements like
if (server->is_smb2 == false)
    do cifs things
#ifdef CONFIG_CIFS_SMB2
else
    do smb2 things
#endif

to
#ifdef CONFIG_CIFS_SMB2
if (server->is_smb2)
    do smb2 things
else
#endif
    do cifs things

that helps to avoid compiler warnings when compiling without CONFIG_CIFS_SMB2.

Your comments are welcome!

-- 
Best regards,
Pavel Shilovsky.
