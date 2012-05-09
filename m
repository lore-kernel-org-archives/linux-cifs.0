From: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] use mkstemp instead of mktemp
Date: Wed, 9 May 2012 09:56:11 -0300
Message-ID: <20120509125611.GA16402@andromeda.usersys.redhat.com>
References: <1335454598-27812-1-git-send-email-gitter.spiros@gmail.com>
 <20120426142215.59d29cb6@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120426142215.59d29cb6-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

> >  	FILE *mnttmp, *mntmtab;
> >  	struct mntent *mountent;
> >  	char *mtabfile, *mtabdir, *mtabtmpfile;
> > +	mode_t mode;
> > +	FILE *spf;
> > +	int fd = -1 ;
> >  
> >  	mtabfile = strdup(MOUNTED);
> >  	mtabdir = dirname(mtabfile);
> > @@ -1652,12 +1655,17 @@ del_mtab(char *mountpoint)
> >  		goto del_mtab_exit;
> >  	}
> >  
> > -	mtabtmpfile = mktemp(mtabtmpfile);
> > -	if (!mtabtmpfile) {
> > -		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
> > -		rc = EX_FILEIO;
> > -		goto del_mtab_exit;
> > +	mode = umask(0077);
> 
> (cc'ing Carlos since he did most of this work originally)
> 
> I think we want the final mtab to be group and world-readable, right?
> So maybe umask(0033) would be better? We should probably also reset the
> umask afterward too just to be safe...
> 
> > +	(void) umask(mode);
> > +	if ((fd = mkstemp(mtabtmpfile)) == -1 ||
> > +		(spf = fdopen(fd, "w+")) == NULL) {
> > +		if (fd != -1) {
> > +			fprintf(stderr, "del_mtab: cannot setup tmp file destination");
> > +			rc = EX_FILEIO;
> > +			goto del_mtab_exit;
> > +                }
> >  	}
> > +	(void) fclose(spf);
> >  
> 
> Looks reasonable to change to mkstemp, but what's the point of doing the
> the fdopen there if you're just going to immediately close it
> afterward? Why not just close(fd) there?
> 
The mainly reason I chose mktemp() instead of mkstemp was due its return value.
The mktemp() returns a template, while mkstemp returns a file descriptor, which
makes the need to handle the file descriptor.
Due our usage of mktemp() here, I didn't think we were subjected to both risks
it implies (the limit of at most 26 different names and the race), and also,
mktemp() made it easier to implement. But I have no objection to change it to
mkstemp if anyone believes it's a risk.

 
Sorry for my delay though, I was enjoying some vacations :)

-- 
--Carlos
