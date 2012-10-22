From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] CIFS: Use OID registry facility
Date: Mon, 22 Oct 2012 15:57:15 -0400
Message-ID: <20121022155715.3902512b@corrin.poochiereds.net>
References: <20121022143635.0ee0c824@corrin.poochiereds.net>
	<20121022142318.6989.5077.stgit@warthog.procyon.org.uk>
	<20121022142326.6989.45552.stgit@warthog.procyon.org.uk>
	<12137.1350933565@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12137.1350933565-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Oct 2012 20:19:25 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > In general, I'm all for moving CIFS out of the business of implementing
> > ASN.1 like this. This last bit of this patch was a bit confusing though.
> > It left me wondering where the actual definitions of these OIDs go.
> > 
> > It looks though like you're using a script to scrape the comments out
> > of the above enum to generate C files.
> 
> That is correct.  See the comment preceding enum OID.  I should add something
> to Documentation/ about this too.
> 
> > That would certainly work, but it seems like a fragile solution. Minor
> > whitespace munging (like an extra newline in there) could throw off the
> > parsing...
> 
> Extra whitespace and extra newlines shouldn't hurt, unless you mean splitting
> a comment over multiple lines.
> 
> I could generate the enum too, though it's easy enough for anyone to check
> that the OID they've just added is present in the table.
> 
> Actually, it can be made a lot more robust by assuming that every line with
> "OID_" in it is an OID declaration, and everyone of those lines that doesn't
> match the expected pattern gets an error.
> 
> David

I guess it just looked a little weird to me. The comment that matches a
enum element is actually part of the following element since it comes
after the comma. Based on the script, what matters is that the enum and
the comment are on the same line.

But...as long as it's all clearly documented, I guess I can't complain
too much. ;)

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
