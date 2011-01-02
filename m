From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs-utils: infrastructure for stashing passwords
 in keyring
Date: Sun, 2 Jan 2011 09:39:48 -0500
Message-ID: <20110102093948.5c006c68@tlielax.poochiereds.net>
References: <1282290314-9477-1-git-send-email-jaxbrigs@gmail.com>
	<1282290314-9477-2-git-send-email-jaxbrigs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282290314-9477-2-git-send-email-jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Aug 2010 11:45:14 +0400
Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> It is a userspace part of a new infrastructure for stashing passwords
> in kernel keyring per user basis. The patch adds the "cifscreds"
> utility for management keys with credentials. Assembling of the utility
> from the distribution is possible with --enable-cifscreds=yes option of
> configure script.
> 
> Signed-off-by: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


I've started dusting off this work with the aim of extending multiuser
mount code to non-krb5 mounts. While doing this, I've found a couple of
problems...

The current scheme is to store a key with this description:

    cifscreds:<ip>:<username>:[domainname]

The first problem is that the username shouldn't be part of the
description. We don't necessarily know what the username will be in
advance. It may be different from the local unix username. So I think
we need to eliminate the "username" part from the description and
instead store that name in the "payload". We should probably also encode
the port number be part of the address for situations where the host
has multiple smb servers with different credential DB's.

The second problem is that "ip" and "domainname" should basically be
mutually exclusive. IOW, someone ought to specify an ip address for
which the credentials are valid, or specify credentials that will work
for any machine that's in a particular domain.

So, I think we need 2 key description formats:

    cifscreds:address+port

...and...

    cifscreds:domain

...and the username and password should be stored together in the value
part of the key.

Then, the kernel's algorithm can look something like this:

1) see if there are credentials for the IP address (and maybe port)
with which we are communicating

...if those don't exist...

2) see if there are credentials for the domain that the server claims
to be part of

Does this make sense? If so, then I'll start work on a patchset to
change this over (unless you would rather do the work).

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
