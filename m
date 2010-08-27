From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs bindaddr v2] cifs: Allow binding to local IP address.
Date: Thu, 26 Aug 2010 21:07:51 -0400
Message-ID: <20100826210751.505d89ce@corrin.poochiereds.net>
References: <1282844096-13295-1-git-send-email-greearb@candelatech.com>
 <20100826155733.6eccc377@tlielax.poochiereds.net>
 <AANLkTikdghfNW0Qq9DkWk8a363EYvKHQn65iOn0ni6e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikdghfNW0Qq9DkWk8a363EYvKHQn65iOn0ni6e7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 26 Aug 2010 18:36:54 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> There are clearly valid reasons for being able to select outgoing
> interface - I wouldn't mind doing this using IPv6 address format if
> that is more natural (since that can include ipv4 addresses) - or
> distinct ipv4/ipv6
> 

The patch already uses cifs_convert_address which handles IPv4 or IPv6
addresses just fine. I don't think it would be that difficult to
optionally store a v4 or v6 address to bind socket.

You'll also need to think about what this means for ip address
selection in the mount helper. It'll need to be modified to make sure
that the address families between the two match. What happens if
someone specifies and IPv4 bindaddr, and the host in the UNC resolves
to an IPv6 address?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
