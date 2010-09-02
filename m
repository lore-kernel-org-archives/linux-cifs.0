From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs srcaddr-v4] cifs:  Allow binding to local IP address.
Date: Wed, 1 Sep 2010 20:38:36 -0400
Message-ID: <20100901203836.2628ce57@tlielax.poochiereds.net>
References: <1283367606-14030-1-git-send-email-greearb@candelatech.com>
	<20100901171418.44685b74@tlielax.poochiereds.net>
	<4C7EC614.6020505@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7EC614.6020505-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 01 Sep 2010 14:31:00 -0700
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> On 09/01/2010 02:14 PM, Jeff Layton wrote:
> > On Wed,  1 Sep 2010 12:00:06 -0700
> > Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
> 
> >> +	struct sockaddr *srcaddr;
> >> +	srcaddr = (struct sockaddr *)(&tcon->ses->server->srcaddr);
> > 					^^^ nit: parens not needed here
> 
> Ok, will fix in next patch.
> 
> >>
> >>   	seq_printf(s, ",unc=%s", tcon->treeName);
> >>   	if (tcon->ses->userName)
> >> @@ -374,6 +377,19 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
> >>   	if (tcon->ses->domainName)
> >>   		seq_printf(s, ",domain=%s", tcon->ses->domainName);
> >>
> >> +	if (srcaddr->sa_family != AF_UNSPEC) {
> >> +		struct sockaddr_in *saddr4;
> >> +		struct sockaddr_in6 *saddr6;
> >> +		saddr4 = (struct sockaddr_in *)srcaddr;
> >> +		saddr6 = (struct sockaddr_in6 *)srcaddr;
> >> +		if (saddr6->sin6_family == AF_INET6)
> >> +			seq_printf(s, ",srcaddr=%pI6c",
> >> +				&saddr6->sin6_addr);
> >> +		else
> >> +			seq_printf(s, ",srcaddr=%pI4",
> >> +				&saddr4->sin_addr.s_addr);
> > 		^^^ It's unlikely to occur, but maybe better to make
> > 		this a switch() and have a default: case that doesn't
> > 		prints the address as "(unknown)" or something? It's
> > 		usually better to code defensively for this sort of
> > 		stuff and printing a garbage address may be confusing
> > 		for users.
> 
> I'll work on that.
> 
> >> +/** Returns true if srcaddr isn't specified and rhs isn't
> >> + * specified, or if srcaddr is specified and
> >> + * matches the IP address of the rhs argument.
> >> + */
> >> +static bool
> >> +srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
> >> +{
> >> +	switch (srcaddr->sa_family) {
> >> +	case AF_UNSPEC:
> >> +		return (rhs->sa_family == AF_UNSPEC);
> >> +	case AF_INET: {
> >> +		struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
> >> +		struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
> >> +		return (saddr4->sin_addr.s_addr == vaddr4->sin_addr.s_addr);
> >> +	}
> >> +	case AF_INET6: {
> >> +		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> >> +		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
> >> +		return ipv6_addr_equal(&saddr6->sin6_addr,&vaddr6->sin6_addr);
> >> +	}
> > 	^^^^^
> > 	These curly braces aren't needed.
> 
> It won't compile without them.  I'd have to declare those variables before the
> switch to do away with the parens, and I prefer it as I wrote it.  I'll change
> it if you all prefer it otherwise, however.
> 
> >
> >> +	default:
> >> +		WARN_ON(1);
> >
> > Again, I'm not a huge fan of the cERROR and cFYI macros, but they are
> > our "standard". This would probably be best as a cERROR macro. You
> > should probably also have it print the value of srcaddr->sa_family as
> > that may be useful for debugging.
> >
> >> +		return false; /* don't expect to be here */
> >> +	}
> >> +}
> >
> > Does the above generate a compiler warning about reaching end of a
> > non-void function? Either way, it's less clear. I'd change the default
> > to just fall through and move the "return false" outside the switch.
> 
> No warning, it always returns something since the default case catches
> all others.  If I did put the return at the end, then the compiler wouldn't
> catch a case where I forgot to return from one of the case statements,
> but it's not overly complex code, so I don't care so much either way.
> Plz let me know if you still want it at the end.
> 
> I also think the WARN_ON is valid, because it can only be a coding bug
> that hits that state, and I'd like it to be as loud as possible while
> still allowing the user to continue.  There are automated tools that
> catch WARN_ON output and post to kernel bug trackers, for instance.
> 
> If you still want a cERROR, I can do that..but I prefer to not waste
> the space.
> 

It's definitely a coding bug if that fires, but a WARN_ON will mean
nothing to users. It looks scary and is virtually indistinguishable
from an oops. We'll get a stack trace, but it's unlikely to tell us
much.

At that point, you might as well make it a BUG(). At least that way,
we might get a core dump if it fires.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
