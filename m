From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] use mkstemp instead of mktemp
Date: Fri, 11 May 2012 14:18:33 -0400
Message-ID: <20120511141833.5d617bf4@corrin.poochiereds.net>
References: <1335454598-27812-1-git-send-email-gitter.spiros@gmail.com>
	<20120426142215.59d29cb6@corrin.poochiereds.net>
	<20120509125611.GA16402@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120509125611.GA16402-PWLG29+z7hGDShSEFzyI5WNt5VayBDZ4VpNB7YpNyf8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 May 2012 09:56:11 -0300
Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Hi,
> 
> > >  	FILE *mnttmp, *mntmtab;
> > >  	struct mntent *mountent;
> > >  	char *mtabfile, *mtabdir, *mtabtmpfile;
> > > +	mode_t mode;
> > > +	FILE *spf;
> > > +	int fd = -1 ;
> > >  
> > >  	mtabfile = strdup(MOUNTED);
> > >  	mtabdir = dirname(mtabfile);
> > > @@ -1652,12 +1655,17 @@ del_mtab(char *mountpoint)
> > >  		goto del_mtab_exit;
> > >  	}
> > >  
> > > -	mtabtmpfile = mktemp(mtabtmpfile);
> > > -	if (!mtabtmpfile) {
> > > -		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
> > > -		rc = EX_FILEIO;
> > > -		goto del_mtab_exit;
> > > +	mode = umask(0077);
> > 
> > (cc'ing Carlos since he did most of this work originally)
> > 
> > I think we want the final mtab to be group and world-readable, right?
> > So maybe umask(0033) would be better? We should probably also reset the
> > umask afterward too just to be safe...
> > 
> > > +	(void) umask(mode);
> > > +	if ((fd = mkstemp(mtabtmpfile)) == -1 ||
> > > +		(spf = fdopen(fd, "w+")) == NULL) {
> > > +		if (fd != -1) {
> > > +			fprintf(stderr, "del_mtab: cannot setup tmp file destination");
> > > +			rc = EX_FILEIO;
> > > +			goto del_mtab_exit;
> > > +                }
> > >  	}
> > > +	(void) fclose(spf);
> > >  
> > 
> > Looks reasonable to change to mkstemp, but what's the point of doing the
> > the fdopen there if you're just going to immediately close it
> > afterward? Why not just close(fd) there?
> > 
> The mainly reason I chose mktemp() instead of mkstemp was due its return value.
> The mktemp() returns a template, while mkstemp returns a file descriptor, which
> makes the need to handle the file descriptor.
> Due our usage of mktemp() here, I didn't think we were subjected to both risks
> it implies (the limit of at most 26 different names and the race), and also,
> mktemp() made it easier to implement. But I have no objection to change it to
> mkstemp if anyone believes it's a risk.
> 
>  
> Sorry for my delay though, I was enjoying some vacations :)
> 

Well, there is a minor risk here. We don't open the file with O_EXCL and
we should. It's possible someone could guess the filename and be able
to create it during the race window. Presumably they'd already need to
be root to do that in which case they could already clobber /etc/mtab,
but it doesn't hurt to be safe there I guess...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
