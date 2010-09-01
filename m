From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs bindaddr v3] cifs:  Allow binding to local IP address.
Date: Wed, 1 Sep 2010 12:40:49 -0400
Message-ID: <20100901124049.63aad883@tlielax.poochiereds.net>
References: <1283284514-25588-1-git-send-email-greearb@candelatech.com>
	<20100901084147.4aa66e9d@corrin.poochiereds.net>
	<4C7E7FDC.7060606@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7E7FDC.7060606-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 01 Sep 2010 09:31:24 -0700
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> On 09/01/2010 05:41 AM, Jeff Layton wrote:
> > On Tue, 31 Aug 2010 12:55:14 -0700
> > Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
> >
> >> When using multi-homed machines, it's nice to be able to specify
> >> the local IP to use for outbound connections.  This patch gives
> >> cifs the ability to bind to a particular IP address.
> >>
> >>     Usage:  mount -t cifs -o srcaddr=192.168.1.50,user=foo, ...
> >>     Usage:  mount -t cifs -o srcaddr=2002::100:1,user=foo, ...
> >>
> >> Signed-off-by: Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> 
> >> +bool
> >> +cifs_addr_is_specified(struct sockaddr *srcaddr) {
> >> +	struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
> >> +	struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> >> +	static const struct in6_addr c_in6addr_any = IN6ADDR_ANY_INIT;
> >> +	switch (srcaddr->sa_family) {
> >> +	case AF_INET:
> >> +		return saddr4->sin_addr.s_addr != 0;
> >> +	case AF_INET6:
> >> +		return (!ipv6_addr_equal(&c_in6addr_any,&saddr6->sin6_addr));
> >> +	}
> >> +	return false;
> >> +}
> >> +
> >
> > I don't think you need all of this. cifs_addr_is_specified ought to
> > just be srcaddr->sa_family != AF_UNSPEC. That could be a static inline
> > or macro, even.
> 
> Yeah, I'll fix that next patch.
> 
> >> +/** Returns true if srcaddr isn't specified and rhs isn't
> >> + * specified, or if srcaddr is specified and
> >> + * matches the IP address of the rhs argument.
> >> + */
> >> +static bool
> >> +srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
> >> +{
> >> +	if (cifs_addr_is_specified(srcaddr)) {
> >> +		struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
> >> +		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> >> +		struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
> >> +		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
> >> +
> >> +		switch (srcaddr->sa_family) {
> >> +		case AF_INET:
> >> +			if (saddr4->sin_addr.s_addr != vaddr4->sin_addr.s_addr)
> >> +				return false;
> >> +			break;
> >> +		case AF_INET6:
> >> +			if (!ipv6_addr_equal(&saddr6->sin6_addr,
> >> +					&vaddr6->sin6_addr))
> >> +				return false;
> >> +			break;
> >> +		default:
> >> +			return false;
> >> +		}
> >> +		return true;
> >> +	}
> >> +	else
> >> +		return !cifs_addr_is_specified(rhs);
> >> +}
> >
> > This is more complicated than it really needs to be I think. I think
> > all what you really need to do here is check to see if the address
> > families match. If they do and they're either AF_INET flavor, then check
> > to see if the addresses match. You might even be able to reuse some of
> > the code in match_address here.
> 
> I think I'm basically doing what you suggest, with the only trick that
> any un-bound (non-specified) addresses must match only other non-specified
> connections.
> 
> Please post an improved version of this method if you have one to
> suggest, but I don't see any way to significantly simplify this.
> 

In pseudocode...

switch(srcaddr->sa_family) {
AF_UNSPEC:
	if (rhs->sa_family == AF_UNSPEC)
		return true;
AF_INET:
	/* compare v4 address, return true if same */
AF_INET6:
	/* compare v6 address, return true if same */
default:
	/* fall through */
}
return false;

> >> +static int
> >> +bind_socket(struct TCP_Server_Info *server)
> >> +{
> >> +	int rc = 0;
> >> +	if (cifs_addr_is_specified((struct sockaddr *)&server->srcaddr)) {
> >> +		/* Bind to the local IP address if specified */
> >> +		struct socket *socket = server->ssocket;
> >> +		rc = socket->ops->bind(socket,
> >> +				       (struct sockaddr *)&server->srcaddr,
> >> +				       sizeof(server->srcaddr));
> >> +		if (rc<  0) {
> >> +			struct sockaddr_in *saddr4;
> >> +			struct sockaddr_in6 *saddr6;
> >> +			saddr4 = (struct sockaddr_in *)&server->srcaddr;
> >> +			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
> >> +			if (saddr6->sin6_family == AF_INET6)
> >> +				printk(KERN_WARNING "cifs: "
> >> +				       "Failed to bind to: %pI6c, error: %d\n",
> >> +				&saddr6->sin6_addr, rc);
> >> +			else
> >> +				printk(KERN_WARNING "cifs: "
> >> +				       "Failed to bind to: %pI4, error: %d\n",
> >> +				&saddr4->sin_addr.s_addr, rc);
> >> +		}
> > 			^^^^^^^^^^^
> > For better or worse, the CIFS code uses the cFYI and cERROR macros for
> > printk's. You should probably do the same here.
> 
> If I make these cERROR, will they be printed to /var/log/messages
> and/or dmesg by default if the error case hits?  I definately want this
> visible in the logs by default so users have a chance of figuring out why
> the bind failed.
> 

They should -- those are both macros around printk.

I'd make it a cFYI macro and fail the mount if the bind fails. They can
then crank up the debugging if they need to dig further.

> > ^^^^
> > The printk's are nice and all, but shouldn't you fail the
> > ipv[4,6]_connect if the socket can't be bound?
> 
> Either way is fine with me.  It would be possible for the actual
> connection to still work in the bind-failure case, but it might not
> be what the user would expect.
> 

Sounds like reason enough to fail to mount. If they don't really care
then they can remount without srcaddr=.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
