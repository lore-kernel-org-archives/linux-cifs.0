From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Handle big endianness in NTLM (ntlmv2)
 authentication
Date: Tue, 25 Jun 2013 13:54:40 -0400
Message-ID: <20130625135440.32f70550@tlielax.poochiereds.net>
References: <1372175077-12846-1-git-send-email-shirishpargaonkar@gmail.com>
	<20130625134929.29f7a1c3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130625134929.29f7a1c3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 25 Jun 2013 13:49:29 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 25 Jun 2013 10:44:37 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> 
> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > 
> > This is RH bug 970891
> > Uppercasing of username during calculation of ntlmv2 hash fails
> > because UniStrupr function does not handle big endian wchars.
> > 
> > Also fix a comment in the same code to reflect its correct usage.
> > 
> > 
> > Reported-by: steve <sanpatr1-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  fs/cifs/cifs_unicode.h |    2 +-
> >  fs/cifs/cifsencrypt.c  |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> > index 4fb0974..bec1137 100644
> > --- a/fs/cifs/cifs_unicode.h
> > +++ b/fs/cifs/cifs_unicode.h
> > @@ -334,7 +334,7 @@ UniStrupr(register wchar_t *upin)
> >  
> >  	up = upin;
> >  	while (*up) {		/* For all characters */
> > -		*up = UniToupper(*up);
> > +		*up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
> >  		up++;
> >  	}
> >  	return upin;		/* Return input pointer */

Actually...there is one more change I'd suggest. With this, we now
expect an array of le16 values, and not an array of wchar_t's. The
arguments to this function and the "up" variable should probably be
changed accordingly.

Some comments clarifying that (maybe even a kerneldoc header?) might be
good too.

> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > index 71436d1..8b34a73 100644
> > --- a/fs/cifs/cifsencrypt.c
> > +++ b/fs/cifs/cifsencrypt.c
> > @@ -439,7 +439,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
> >  		return rc;
> >  	}
> >  
> > -	/* convert ses->user_name to unicode and uppercase */
> > +	/* convert ses->user_name to unicode */
> >  	len = ses->user_name ? strlen(ses->user_name) : 0;
> >  	user = kmalloc(2 + (len * 2), GFP_KERNEL);
> >  	if (user == NULL) {
> 
> Looks correct. Nice work tracking that down!
> 

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
