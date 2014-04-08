From: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifskey: better use snprintf()
Date: Tue, 8 Apr 2014 16:41:29 +0200
Message-ID: <20140408144129.GA7863@suse.de>
References: <20140408124444.GB23274@suse.de> <20140408103212.356655ac@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140408103212.356655ac-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi

C standard says snprintf() is writing
the terminating 0-byte (thats indeed the real beauty of snprintf).
Nevertheless snprintf() return value may be
larger than buffer size (# bytes that would have been written).
So strlen() should be safe and the buffer is 0-terminated in any case.

Sebastian

On Tue, Apr 08, 2014 at 10:32:12AM -0400, Jeff Layton wrote:
> On Tue, 8 Apr 2014 14:44:44 +0200
> Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org> wrote:
> 
> > 
> > Prefer snprintf() over sprintf() in cifskey.c
> > Projects that fork the code (pam_cifscreds) can't rely on
> > the max-size parameters. Also use strlen() for determining
> > buffer size, as snprintf() may return values larger than buffer size.
> > 
> > 
> > Signed-off-by: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
> > ---
> > 
> > 
> > --- cifskey.c.orig	2014-04-08 13:10:41.653435040 +0200
> > +++ cifskey.c	2014-04-08 14:28:54.457766913 +0200
> > @@ -20,6 +20,7 @@
> >  #include <sys/types.h>
> >  #include <keyutils.h>
> >  #include <stdio.h>
> > +#include <string.h>
> >  #include "cifskey.h"
> >  #include "resolve_host.h"
> >  
> > @@ -29,7 +30,7 @@
> >  {
> >  	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
> >  
> > -	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
> > +	snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr);
> 
> If we're concerned about buffer overruns here, then shouldn't you be
> checking the return value of snprintf() to ensure that the string above
> is NULL terminated?
> 
> >  
> >  	return keyctl_search(DEST_KEYRING, CIFS_KEY_TYPE, desc, 0);
> >  }
> > @@ -38,15 +39,14 @@
> >  key_serial_t
> >  key_add(const char *addr, const char *user, const char *pass, char keytype)
> >  {
> > -	int len;
> >  	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
> >  	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
> >  
> >  	/* set key description */
> > -	sprintf(desc, "%s:%c:%s", KEY_PREFIX, keytype, addr);
> > +	snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr);
> >  
> >  	/* set payload contents */
> > -	len = sprintf(val, "%s:%s", user, pass);
> > +	snprintf(val, sizeof(val), "%s:%s", user, pass);
> >  
> > -	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
> > +	return add_key(CIFS_KEY_TYPE, desc, val, strlen(val) + 1, DEST_KEYRING);
> >  }
> > 
> > 
> 
> Ditto with the above checks. Just because you're using snprintf doesn't
> mean that the resulting string will be NULL terminated. You need to
> check the return value of snprintf and ensure that it fits within the
> buffer and that it ended up being NULL terminated.
> 
> If you do that then you don't need to use strlen() either.
> 
> -- 
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

-- 

~ perl self.pl
~ $_='print"\$_=\47$_\47;eval"';eval
~ krahmer-l3A5Bk7waGM@public.gmane.org - SuSE Security Team
