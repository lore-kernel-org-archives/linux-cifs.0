From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs] cifs:  Allow binding to local IP address.
Date: Tue, 31 Aug 2010 14:50:23 -0400
Message-ID: <20100831145023.09253a26@tlielax.poochiereds.net>
References: <1283233222-8702-1-git-send-email-greearb@candelatech.com>
	<20100831100649.3c9121df@corrin.poochiereds.net>
	<4C7D3177.7070906@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7D3177.7070906-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 31 Aug 2010 09:44:39 -0700
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> On 08/31/2010 07:06 AM, Jeff Layton wrote:
> > On Mon, 30 Aug 2010 22:40:22 -0700
> > Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
> >
> >> When using multi-homed machines, it's nice to be able to specify
> >> the local IP to use for outbound connections.  This patch gives
> >> cifs the ability to bind to a particular IP address.
> >>
> >>    Usage:  mount -t cifs -o srcaddr=192.168.1.50,user=foo, ...
> >>    Usage:  mount -t cifs -o srcaddr=2002::100:1,user=foo, ...
> 
> >> +bool
> >> +cifs_addr_is_specified(struct sockaddr *srcaddr) {
> >> +	struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
> >> +	struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> >> +	switch (srcaddr->sa_family) {
> >> +	case AF_INET:
> >> +		return saddr4->sin_addr.s_addr != 0;
> > 						^^^^
> > 					nit: should probably be htonl(INADDR_ANY)
> 
> We don't initialize it to INADDR_ANY, so I'd rather not check
> against it, even though now and forever it's going to be zero.
> But, will change if that's the consensus.
> 

What may be best instead is to just set sa_family to AF_UNSPEC when
it's not specified. An sa_family that was AF_INET or AF_INET6 would
imply that it had been specified. That way someone could reasonably
force a ->bind to occur to INADDR_ANY (as silly as that sounds).

> >> @@ -1064,6 +1066,22 @@ cifs_parse_mount_options(char *options, const char *devname,
> >>   						    "long\n");
> >>   				return 1;
> >>   			}
> >> +		} else if (strnicmp(data, "srcaddr", 8) == 0) {
> >> +			memset(&vol->srcaddr, 0, sizeof(vol->srcaddr));
> > 			^^^^^^^^^
> > 			Is this necessary? vol is kzalloc'ed so it
> > 			should be zeroed out already. Or are you
> > 			worried about people specifying srcaddr= more
> > 			than once?
> 
> It just seems cleaner in general to set it to known value in case errors
> later in that method keep us from setting it to a proper new value.
> And, certainly useful if it can be set twice somehow..but not sure if that's
> currently the case or not.
> 

Fair enough. There's probably no need to zero this out entirely though.
Setting the family to AF_UNSPEC should be sufficient.

> >
> >> +
> >> +			if (!value || !*value) {
> >> +				printk(KERN_WARNING "CIFS: srcaddr value"
> >> +				       " not specified.\n");
> >> +				return 1;	/* needs_arg; */
> >> +			}
> >> +			i = cifs_convert_address((struct sockaddr *)&vol->srcaddr,
> >> +						 value, strlen(value));
> >> +			if (i<  0) {
> >> +				printk(KERN_WARNING "CIFS:  Could not parse"
> >> +				       " srcaddr: %s\n",
> >> +				       value);
> >> +				return 1;
> >> +			}
> >>   		} else if (strnicmp(data, "prefixpath", 10) == 0) {
> >>   			if (!value || !*value) {
> >>   				printk(KERN_WARNING
> >> @@ -1392,8 +1410,37 @@ cifs_parse_mount_options(char *options, const char *devname,
> >>   	return 0;
> >>   }
> >>
> >> +/** Returns true if srcaddr isn't specified or if it matches
> >> + * the IP address of the rhs argument.
> >> + */
> >>   static bool
> >> -match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
> >> +srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
> >> +{
> >> +	if (cifs_addr_is_specified(srcaddr)) {
> >
> > 	Just wondering what the expected behavior would be here...
> >
> > 	Suppose I have a clustered IP address set up, and I want to
> > 	ensure that one of my CIFS mounts use that as the srcaddr. Now,
> > 	suppose I make another mount to the same server, but don't
> > 	specify the srcaddr there. That mount uses the same socket as
> > 	the first one (that is bound to the srcaddr). Now, suppose I
> > 	unmount the first mount and then fail over the IP address. What
> > 	happens to the second one? (Nothing good, I'd wager...)
> >
> > 	Perhaps we should consider using a different socket when the
> > 	srcaddr isn't specified?
> 
> The idea is that each mount with unique source addr gets it's own
> cifs session.  They will not be shared even if the server is the
> same.  If srcaddr isn't specified, then you get today's behaviour
> (shared so long as server is the same).
> 
> In your example, the bound and the un-bound shouldn't share anything,
> but it's possible my code doesn't fully do that.  If so, I would
> consider that a bug.
> 

Ok, I think that is a bug here. srcip_matches returns true when
cifs_addr_is_specified returns false. So if you don't specify a
srcaddr= option, you'll match any session, right?

> >> +		case AF_INET6:
> >> +			if (memcmp(&saddr6->sin6_addr,&vaddr6->sin6_addr,
> >> +				   sizeof(saddr6->sin6_addr)) != 0)
> >
> > 			^^^ should use ipv6_addr_equal, unless there's some reason not to do so...
> 
> addr_equal should be fine, I will change that.
> 
> >
> >> +				return false;
> >> +			break;
> >> +		}
> >> +	}
> >> +	return true;
> >> +}
> >> +
> >> +
> >> +static bool
> >> +match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
> >> +	      struct sockaddr *srcaddr)
> >>   {
> >>   	struct sockaddr_in *addr4 = (struct sockaddr_in *)addr;
> >>   	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;
> >> @@ -1420,6 +1467,9 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
> >>   		break;
> >>   	}
> >>
> >> +	if (!srcip_matches(srcaddr, (struct sockaddr *)&server->srcaddr))
> >> +		return false;
> >> +
> >>   	return true;
> >>   }
> >>
> >> @@ -1487,7 +1537,8 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
> >>   		if (server->tcpStatus == CifsNew)
> >>   			continue;
> >>
> >> -		if (!match_address(server, addr))
> >> +		if (!match_address(server, addr,
> >> +				   (struct sockaddr *)&vol->srcaddr))
> >>   			continue;
> >>
> >>   		if (!match_security(server, vol))
> >> @@ -1602,6 +1653,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
> >>   	 * no need to spinlock this init of tcpStatus or srv_count
> >>   	 */
> >>   	tcp_ses->tcpStatus = CifsNew;
> >> +	memcpy(&tcp_ses->srcaddr,&volume_info->srcaddr,
> >> +	       sizeof(tcp_ses->srcaddr));
> >>   	++tcp_ses->srv_count;
> >>
> >>   	if (addr.ss_family == AF_INET6) {
> >> @@ -1678,6 +1731,9 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
> >>   				    vol->password ? vol->password : "",
> >>   				    MAX_PASSWORD_SIZE))
> >>   				continue;
> >> +			if (!srcip_matches((struct sockaddr *)&server->srcaddr,
> >> +					   (struct sockaddr *)&ses->server->srcaddr))
> >> +				continue;
> >
> > 			^^^ there should be no need for this. By the
> > 			time you get here, you've already determined
> > 			whether you can use the same socket as another
> > 			one (via the check in match_address).
> 
> Ok, I'll remove that.
> 
> >> index ab70a3f..735989a 100644
> >> --- a/net/ipv6/addrconf.c
> >> +++ b/net/ipv6/addrconf.c
> >> @@ -230,6 +230,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
> >>
> >>   /* IPv6 Wildcard Address and Loopback Address defined by RFC2553 */
> >>   const struct in6_addr in6addr_any = IN6ADDR_ANY_INIT;
> >> +EXPORT_SYMBOL(in6addr_any);
> >
> > There should be no need at all to touch stuff outside of cifs.ko, at
> > least, not in this patch. If you want to do this, you need to do it as
> > a separate patch and float it in linux-netdev or someplace like that.
> >
> > In the meantime, I'd suggest declaring a private in6_addr variable and
> > initializing it to IN6ADDR_ANY_INIT (similar to what the sunrpc code
> > does).
> 
> Sounds good.  I'll see if davem will accept such a patch, and will use
> a private copy in cifs until such time as the ipv6 patch goes in.
> 
> Thanks for the review!
> 

No problem.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
