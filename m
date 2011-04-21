From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add rwpidforward mount option (try #2)
Date: Thu, 21 Apr 2011 12:20:35 +0400
Message-ID: <BANLkTik5EAKDMwkuK2_KvT88ptB2jFqM9Q@mail.gmail.com>
References: <1303129252-7006-1-git-send-email-piastry@etersoft.ru>
	<20110418084414.295ef417@tlielax.poochiereds.net>
	<BANLkTinFCrP=VzG6b6-WR-S6af6Jc91Tzg@mail.gmail.com>
	<20110418091106.386447c5@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110418091106.386447c5-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> I think we should do whatever is necessary for that write to succeed.
> If that means forwarding the pid then that's fine. I just don't see why
> the RWPIDFORWARD flag should matter at all in that case.
>

Ok, I got it and absolutely agree that we should do it for writepages
every time. We still have a problem when we negotiate mandatory
locking style and a child succeeds doing writepages on a locked file
region but I don't think it is a big problem.

-- 
Best regards,
Pavel Shilovsky.
