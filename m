From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New read logic
Date: Tue, 2 Nov 2010 10:52:45 +0300
Message-ID: <AANLkTimZp9Sv75CQmAcGAwgr6FsreBv+Ejadr+bM_wPG@mail.gmail.com>
References: <AANLkTimbGk9zKbVBU+Fd-d4XwQdFyEJFzcxi84dVEjQx@mail.gmail.com>
	<20101101131930.18d35c34@tlielax.poochiereds.net>
	<AANLkTinyh5zxKsyZetpN4WwiDMWQ-Y9E-1uu9_dzDQTY@mail.gmail.com>
	<20101101140019.166be768@tlielax.poochiereds.net>
	<AANLkTin3WmGcoTEF0Edg5k3e5dx4Z6o9esCUSgXC2kJZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin3WmGcoTEF0Edg5k3e5dx4Z6o9esCUSgXC2kJZ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

But although we don't have the agreement in this question, what's
about my patch? We can always change lookupcache timeout even if my
patch is applied. May be I should to remove cifs_revalidate_file call
from the non-strictcache mode and post it again?

-- 
Best regards,
Pavel Shilovsky.
