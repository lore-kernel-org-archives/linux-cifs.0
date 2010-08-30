From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs mount errors
Date: Mon, 30 Aug 2010 16:00:53 -0400
Message-ID: <20100830160053.3cbe631d@tlielax.poochiereds.net>
References: <545700.65464.qm@web56901.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joe hefner <joehef06-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545700.65464.qm-RVHwM+Z+5pGB9c0Qi4KiSs0jms80CZx+QQ4Iyu8u01E@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 30 Aug 2010 11:41:56 -0700 (PDT)
joe hefner <joehef06-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:

> CIFS VFS: No response to cmd 115 mid 2
> fs/cifs/transport.c: marking request for retry
> fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> fs/cifs/sess.c: ssetup rc from sendrecv2 is -11
> CIFS VFS: Send error in SessSetup = -11

Looks like the server is just not sending a response to the session
setup request here. I'd check the server logs -- maybe they have
something?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
