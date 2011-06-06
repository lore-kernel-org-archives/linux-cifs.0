From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS Not Responding Error On Working System
Date: Mon, 6 Jun 2011 06:32:44 -0400
Message-ID: <20110606063244.3c4aee47@corrin.poochiereds.net>
References: <4DB9BFBA.3020403@softtalker.com>
	<loom.20110606T095706-912@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kofolamaster <kofolamaster-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110606T095706-912-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 6 Jun 2011 07:57:55 +0000 (UTC)
kofolamaster <kofolamaster-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This is maybe related to this problem?
> 
> http://groups.google.com/group/linux.kernel/browse_thread/thread/126601c09b6ea94f
> /84041e22a62b47fa?lnk=raot&fwc=1&pli=1#
> 

I don't think so -- at least, I don't think they're directly related. I
think we understand why the problem in $SUBJECT occurred and there's a
fix in place in mainline and current stable kernels.

Helge's problem seems to be something different. I think we'll need to
see wire traces to understand what's going on.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
