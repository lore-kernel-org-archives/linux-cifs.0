From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: Fix write after setting a read lock for read
 oplock files
Date: Wed, 28 Nov 2012 17:55:41 +0400
Message-ID: <CAKywueTu8Tank1xTNgMBGhcD72L5_oM=UKVsPLACW4pT5u4wGg@mail.gmail.com>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
	<1353999029-3975-6-git-send-email-piastry@etersoft.ru>
	<20121127075203.7b0d8de6@tlielax.poochiereds.net>
	<CAKywueSb3q3-6whESnqrvPc2o0ka8GZepz0JmQGTzyRki4Bh1Q@mail.gmail.com>
	<20121128063614.12d7b0a7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121128063614.12d7b0a7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/11/28 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> There's also a lot of logic around what sort of locking you're doing
> here too. I think we ought to do the same sort of I/O regardless of
> whether POSIX locks are being used or not.

We can use cifs_writev for both POSIX and mandatory variants but I
divided them to make POSIX variant work faster (no need to check hold
a semaphore, walk through a lock list, etc).

-- 
Best regards,
Pavel Shilovsky.
