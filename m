From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/7] cifs: convert cifs_writepages to use async writes
Date: Fri, 15 Apr 2011 13:05:40 +0400
Message-ID: <BANLkTi=C6X621tabVe1LsMYAPDbxPXF2Lw@mail.gmail.com>
References: <1302694994-8303-1-git-send-email-jlayton@redhat.com>
	<1302694994-8303-7-git-send-email-jlayton@redhat.com>
	<BANLkTintNfs=W+UFaC8SCUTt-hN5BXSFRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTintNfs=W+UFaC8SCUTt-hN5BXSFRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/15 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I tested it again and noticed that it is a little faster that the 1st
> variant against Windows 7 on LAN (about 0.5%). Anyway, it seems like a
> very good change - Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>.
>

Just missed the info that I tested it with a patch #7 (with the fix
for if statement, you proposed later).

-- 
Best regards,
Pavel Shilovsky.
