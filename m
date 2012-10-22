From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] CIFS: Use OID registry facility
Date: Mon, 22 Oct 2012 20:19:25 +0100
Message-ID: <12137.1350933565@warthog.procyon.org.uk>
References: <20121022143635.0ee0c824@corrin.poochiereds.net> <20121022142318.6989.5077.stgit@warthog.procyon.org.uk> <20121022142326.6989.45552.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121022143635.0ee0c824-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> In general, I'm all for moving CIFS out of the business of implementing
> ASN.1 like this. This last bit of this patch was a bit confusing though.
> It left me wondering where the actual definitions of these OIDs go.
> 
> It looks though like you're using a script to scrape the comments out
> of the above enum to generate C files.

That is correct.  See the comment preceding enum OID.  I should add something
to Documentation/ about this too.

> That would certainly work, but it seems like a fragile solution. Minor
> whitespace munging (like an extra newline in there) could throw off the
> parsing...

Extra whitespace and extra newlines shouldn't hurt, unless you mean splitting
a comment over multiple lines.

I could generate the enum too, though it's easy enough for anyone to check
that the OID they've just added is present in the table.

Actually, it can be made a lot more robust by assuming that every line with
"OID_" in it is an OID declaration, and everyone of those lines that doesn't
match the expected pattern gets an error.

David
