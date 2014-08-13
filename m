From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 5/5] special: fix op_unlk and op_ren tests output
Date: Wed, 13 Aug 2014 11:45:45 +0400
Message-ID: <CAKywueR2u+RFGP7_2FX427H5Z8Q_0i4LQJAZqTUZG4p=wMMz9g@mail.gmail.com>
References: <1407326472-13853-1-git-send-email-pshilovsky@samba.org>
	<1407326472-13853-6-git-send-email-pshilovsky@samba.org>
	<53EA4450.1060900@RedHat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53EA4450.1060900-AfCzQyP5zfLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

2014-08-12 20:44 GMT+04:00 Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Hello,
>
> Just curious... what is wrong with the output of these
> two tests?

These tests call 'ls' command for the path names that doesn't exists -
".nfs*". Previously we create file names through "tempnam(".",
"nfsa")" command and have "nfs*" style file names (without the first
dot symbol). So, the proposed patch fixes the output in the way we
already have in op_chmod.c.

-- 
Best regards,
Pavel Shilovsky.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
