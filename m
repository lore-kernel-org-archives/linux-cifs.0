From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 08/45] CIFS: Move unlink code to ops struct
Date: Thu, 13 Sep 2012 10:04:37 +0400
Message-ID: <CAKywueTvDNzQQVG0TEvhu2CxEERQc9dxH-VuUwmgOf5d7eeniA@mail.gmail.com>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-9-git-send-email-pshilovsky@samba.org>
	<20120912154804.19b97830@corrin.poochiereds.net>
	<20120912161038.4c32810a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120912161038.4c32810a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/9/13 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> In fact, now that I look...
>
> The unlink(2) manpage lists EBUSY as a valid return code, but doesn't
> mention ETXTBSY. Perhaps we'd be better off turning that error into
> EBUSY instead of returning it as-is to userspace?

Looks reasonable - nfs code returns -EBUSY too.

> In any case, -ENOSYS just because you can't do a sillyrename seems
> clearly wrong. Better to return either -EBUSY or -ETXTBUSY there.

Ok, will repost this patch.

-- 
Best regards,
Pavel Shilovsky.
