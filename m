From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Tue, 16 Nov 2010 11:02:56 +0300
Message-ID: <AANLkTikv9QCf_tJd8TQotmqnLn4b=j0myiLtagDHviwA@mail.gmail.com>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
	<20101113070012.760cf09d@tlielax.poochiereds.net>
	<AANLkTinb-A4kdumURzhkVb9oNojtfW94LPL99GwOr9MU@mail.gmail.com>
	<AANLkTim+SO4TfTJnXHnvaSjbPaoHt4k63hbVbs0gtbn9@mail.gmail.com>
	<20101114203112.5d901619@corrin.poochiereds.net>
	<AANLkTikJVcpezQ54_XrsNMEBewq15YO3iHymoQ-9xc9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikJVcpezQ54_XrsNMEBewq15YO3iHymoQ-9xc9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Even more. I think it should be the following:

port=arg

sets the port number on the server to attempt to contact to negotiate
CIFS support. If this value is specified, looking for an existing
connection with this port and try to connect if no such a connection.
Return an error if it fails.

If this value isn't specified, looking for an existing connection with
445 or 139 port. If no such a connection, try to connect with 445 port
and if it fails - with 139 port. Return an error if both fail.
-- 
Best regards,
Pavel Shilovsky.
