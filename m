From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v3 6/7] NFSv4: Add O_DENY* open flags support
Date: Thu, 4 Apr 2013 21:45:20 +0400
Message-ID: <CAKywueTcy8gMy=TVpj=TnfRMBj9e3xPCpaJvUmRd=TvT5uJHFw@mail.gmail.com>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
	<1362065133-9490-7-git-send-email-piastry@etersoft.ru>
	<20130311145434.707f5ed1@corrin.poochiereds.net>
	<20130312083517.770a17f6@tlielax.poochiereds.net>
	<CAKywueRSTipeO8V-oNrM=jM8WUo7Dd0ahj_Xcw8f8ViE3NGEOQ@mail.gmail.com>
	<20130404090232.30457b32@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130404090232.30457b32-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/4/4 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> I'd probably still stick with a FS_* flag for this...
>
> That sort of mechanism would work (for now) but sounds like the sort of
> subtle behavior that's difficult for filesystem authors to get right.
> It would also be subject to subtle breakage later.
>
> Also, suppose there are changes in the future that require you to
> determine this before calling into ->open? Then you'll have to go back
> and somehow mark the fs anyway...

Ok, this makes sense, thanks. Will do it this way and repost.

--
Best regards,
Pavel Shilovsky.
