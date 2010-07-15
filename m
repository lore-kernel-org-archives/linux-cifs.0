From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/6] cifs: add separate cred_uid field to sesInfo
Date: Thu, 15 Jul 2010 17:19:36 -0400
Message-ID: <20100715171936.4252a16d@corrin.poochiereds.net>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
	<1277068251-16344-7-git-send-email-jlayton@redhat.com>
	<AANLkTik7vm4iYcRH2oGxuINyL2VxY_h9Y03sFhQWR19d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik7vm4iYcRH2oGxuINyL2VxY_h9Y03sFhQWR19d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 15 Jul 2010 15:24:46 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I merged the first 5 of this series, but wanted to understand what
> behavior this changes first (it is probably ok).  With current
> userspace code - what changes would a user see with this?
> 

With this and the accompanying userspace patch, this makes it so that
the credentials cache used when mounting with sec=krb5 is unaffected by
the uid= option. The credcache will be determined using the real uid of
the user performing the mount. There will be a cifs.upcall option that
will make it use the legacy behavior for those that require it for some
reason. 

I consider the current situation a bad design decision on my part as
the ownership of files on the mount has no direct relationship to the
owner of the mount credentials. The mount credentials should always be
under the ownership of the user performing the mount. The existing
scheme allows someone to use the credcache of another user to perform
a mount.

I'll resend the userspace patch in another day or two when I get back
from vacation.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
