From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs-utils: moving resolve_host into separate file
Date: Fri, 20 Aug 2010 15:07:54 -0400
Message-ID: <20100820150754.55e15b6c@tlielax.poochiereds.net>
References: <1282290314-9477-1-git-send-email-jaxbrigs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282290314-9477-1-git-send-email-jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Aug 2010 11:45:13 +0400
Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The resolve_host routine from mount.cifs is carried out in
> separate file and appropriate corrections are made.
> 
> Signed-off-by: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Nice work, Igor.

Looks good -- both patches merged. That should allow people to start
playing with it. They should make the 4.7 release.

There's still plenty of work to do here:

1) the kernel pieces need to go in once they're ready. I'll plan to
review the latest ones this weekend sometime.

2) it needs a manpage

Once all of that is done, we can start considering building it by
default (i.e. make the default "enable" instead of "disable").

We also need to have a hard look at how to sync this work up with
the multiuser mount work. That's not something we need to worry about
until the multiuser mount code for krb5 goes in.

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
