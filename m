From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove support for "complex" usernames from mount.cifs
Date: Fri, 4 Jan 2013 13:26:38 -0500
Message-ID: <CAFB9KM3uR1xCa9gGyyRyKjRgsL8npdzo4zxfyLUQToAvrJUCEw@mail.gmail.com>
References: <1357214055-24911-1-git-send-email-jlayton@samba.org>
	<CAFB9KM0-BrPcjV8gTW9BV_Awiw5bHbgYr=42smTJWKxCr=Y-PA@mail.gmail.com>
	<20130103142110.269ea0d1@tlielax.poochiereds.net>
	<CAH2r5mtRD85Te3g=G7Ez80NzGgG+36wHsiRnCzszQu9uee1-kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtRD85Te3g=G7Ez80NzGgG+36wHsiRnCzszQu9uee1-kQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jan 3, 2013 at 3:04 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I am not as worried about code cleanliness as I am about losing function,
> especially as it is sometimes hard to figure out how many users would be
> affected by removing function.  I mildly prefer leaving the nfs syntax
> if it makes it easier for nfs users to use smb3, but we could make a stub
> mount helper that parses nfs syntax and simply calls mount.cifs if you
> prefer that approach - in any case I don't feel strongly about nfs syntax.

I don't care much either way.  The reason behind removing it, IIRC,
was that it was an undocumented feature that lead to an ambiguous
parsing situation when you had NFS syntax with an IPv6 address as the
server portion of the string (ie
dead:beef::1:/shareNameWithColon:/prepath).  It was easier to remove
the undocumented feature than to support it for this use case.

How does NFS syntax make things easier for SMB3?

-- 
Peace and Blessings,
-Scott.
