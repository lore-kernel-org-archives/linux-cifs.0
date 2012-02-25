From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Sun, 26 Feb 2012 01:25:09 +0400
Message-ID: <CAKywueRSpcmfFpMm-AkoMQY17o-BRqg2Y2xhkRaUghpvk1fZ=w@mail.gmail.com>
References: <1329484410-30540-1-git-send-email-piastry@etersoft.ru>
	<20120221100006.7e43e8b9@tlielax.poochiereds.net>
	<CAKywueS0XKjuX_sLfb=Lhp=hLgrYpq7ndAtNGDjq1pFg16A7dA@mail.gmail.com>
	<CAH2r5mv-W=Y40rnAck3uQiR8BuZULv0Nsj1P=OE8o5fPFWM-zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv-W=Y40rnAck3uQiR8BuZULv0Nsj1P=OE8o5fPFWM-zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/25 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I have not rerun my normal functional tests with this in tree, but will this
> weekend (before the upcoming test event).
>
> It also would be helpful to know the state of your current smb2 test branch
> so I can make sure I am working from a copy that is reasonably uptodate when
> I make changes during testing next week.
>
>

http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev2
branch is the latest
update of smb2 patches.

I have been working with cifs related part of the patches (preparing
transport code to handle new protocol as well) since that time (this
branch: http://git.etersoft.ru/people/piastry/packages?p=cifs-2.6.git;a=shortlog;h=refs/heads/cifs-patches)
and haven't rebased other smb2 specific patches yet. I am going to do
that soon - will let you know when it's done.

-- 
Best regards,
Pavel Shilovsky.
