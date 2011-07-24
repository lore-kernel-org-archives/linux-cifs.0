From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 work status
Date: Sun, 24 Jul 2011 18:56:17 +0400
Message-ID: <CAKywueTDhS_FHtssdVbSrBiPksngYsmotU69u9S1QELnm9Vh+w@mail.gmail.com>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
	<CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

I updated my branch smb2-dev
(http://git.etersoft.ru/people/piastry/packages?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev)
with the following changes:
1) rebased to v3.0.
2) buffered i/o support
3) echo support

I used callbacks that let me share the common code for both protocols
in direct i/o, readpage, readpages, writepage, writepages, etc. Also,
I made some minor changes in demultiplex patchset (now smb2-dev branch
is based on this new one).

Comments/thoughts?

-- 
Best regards,
Pavel Shilovsky.
