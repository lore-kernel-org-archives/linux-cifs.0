From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Use pid saved in cifsFileInfo in writepages and set_file_size
Date: Thu, 19 May 2011 13:22:00 +0400
Message-ID: <BANLkTi=N1wN4o4i04=pW8joC__hNq3WynA@mail.gmail.com>
References: <linux-cifs@vger.kernel.org>
	<1304502271-11557-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304502271-11557-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/4 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> We need it to make them work with mandatory locking style because
> we can fail in a situation like when kernel need to flush dirty pages
> and there is a lock held by process who opened file.

I put this and 2/2 Add rwpidforward mount option patch on top of
current master branch into pidforward branch on git.etersoft.ru:
http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/pidforward

Comments?

-- 
Best regards,
Pavel Shilovsky.
