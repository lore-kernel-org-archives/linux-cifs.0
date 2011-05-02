From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add rwpidforward mount option
Date: Mon, 2 May 2011 19:10:26 +0400
Message-ID: <BANLkTik-+AGJ6o2LmSQGrzTp5agfDR_K0g@mail.gmail.com>
References: <1303392395-9217-1-git-send-email-piastry@etersoft.ru>
	<1303392395-9217-2-git-send-email-piastry@etersoft.ru>
	<20110429102213.3c8bdb33@corrin.poochiereds.net>
	<BANLkTi=JihA=TjEo6J5o6oR7rcw4LtpSxw@mail.gmail.com>
	<20110502081335.6cbe8222@corrin.poochiereds.net>
	<20110502081844.1bc9f063@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110502081844.1bc9f063-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/2 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> One more question though...
>
> If I run multiple applications under wine, then do I get multiple
> wineserver programs? I assume not...
>
> If that's the case, then won't this change break locking between
> multiple wine applications that are operating on the same files?
>

Wineserver is run per combination of user and configuration directory.
Wineserver provides mechanisms for processing such kind things(on
local file systems). So, it seems that this change doesn't break it.

-- 
Best regards,
Pavel Shilovsky.
