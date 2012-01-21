From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: eliminate CONFIG_CIFS_WEAK_PW_HASH
Date: Sat, 21 Jan 2012 15:03:31 +1100
Message-ID: <1327118615.7985.5.camel@ruth>
References: <1327091153-22391-1-git-send-email-jlayton@redhat.com>
	 <CAH2r5msOk=4rz_XUGi+GitzVGyJrSo9B1iGXdjz0Bnymzt0NyQ@mail.gmail.com>
	 <20120120153856.6ded308a@tlielax.poochiereds.net>
	 <CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms6YbZp+erat9RQw7-vMxem6vLWp72Yaf=Z8d4p=4+BBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2012-01-20 at 14:45 -0600, Steve French wrote:
> My general thinking on this is as follows:
> 
> If the kernel is distributed to all the workstations in an organization
> with this Kconfig option disabled, it makes it harder for individual users
> to make the mistake of enabling lanman (sec=lanman, or the Kconfig
> option) on a public network and thus send weak password hashes
> which could be discovered simply.   Most distros make the choice
> of enabling broader compatibility with old pre-1997 servers but
> it is a very small set of servers who would require lanman support,
> and a large number of potential attackers who could benefit if
> users enable lanman on a public network.  I suspect that there
> are environments where removing code (via Kconfig) is preferred
> to trusting all owners of all workstations running that organizations
> standard linux to never enable lanman at runtime.
> 
> But ... the opinion of security specialists on this would be welcome.

We have been though some of this with the kerberos libs, which now allow
(default?) to not even compile with weak crypto.  If the weak crypto is
not compiled in, it can therefore be asserted that the weak crypto
cannot be used, and this makes it easier to comply with security
audits/certification etc.

I don't want to make your code more complex than it needs to be, but LM
encryption really, really needs to go away.  If it is not a major
bother, I would like to make it easier for that to happen if possible.

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
