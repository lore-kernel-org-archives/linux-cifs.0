From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove support for "complex" usernames from
 mount.cifs
Date: Fri, 4 Jan 2013 07:33:04 -0500
Message-ID: <20130104073304.545af2f2@tlielax.poochiereds.net>
References: <1357214055-24911-1-git-send-email-jlayton@samba.org>
	<CAFB9KM0-BrPcjV8gTW9BV_Awiw5bHbgYr=42smTJWKxCr=Y-PA@mail.gmail.com>
	<20130103142110.269ea0d1@tlielax.poochiereds.net>
	<CAH2r5mtRD85Te3g=G7Ez80NzGgG+36wHsiRnCzszQu9uee1-kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtRD85Te3g=G7Ez80NzGgG+36wHsiRnCzszQu9uee1-kQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 3 Jan 2013 14:04:23 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I am not as worried about code cleanliness as I am about losing function,
> especially as it is sometimes hard to figure out how many users would be
> affected by removing function.  I mildly prefer leaving the nfs syntax
> if it makes it easier for nfs users to use smb3, but we could make a stub
> mount helper that parses nfs syntax and simply calls mount.cifs if you
> prefer that approach - in any case I don't feel strongly about nfs syntax.
> 
> On the question of domain name - since Samba uses that form for
> username (which allows domain and username and password to be overloaded) --
> how do samba utilities deal with the conflict you are trying to fix by removing
> support for including domain\user%password?
> 

Do the samba client utilities even have the ability to use a keytab at
all? My understanding is that you must already have a TGT in order to
use them with krb5 auth.

In any case, the smbclient manpage doesn't list DOMAIN/user as valid
syntax for the -U option. I think you're expected to use -W to supply
a domain name.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
