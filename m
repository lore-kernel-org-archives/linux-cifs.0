From: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Properly update mtab during remount V2
Date: Tue, 10 Jan 2012 16:53:02 -0200
Message-ID: <20120110185302.GB25854@andromeda.usersys.redhat.com>
References: <1325178125-13884-1-git-send-email-cmaiolino@redhat.com>
 <20120103072229.3cb43bf4@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120103072229.3cb43bf4-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff
On Tue, Jan 03, 2012 at 07:22:29AM -0500, Jeff Layton wrote:
> > +
> > +	mtabfile = strdup(MOUNTED);
> 
> This looks like a buffer overrun. Here, you're strduping MOUNTED...
> 
> > +	mtabdir = dirname(mtabfile);
> 
> Then altering that string to get the dirname...
> 
> > +	if (!mtabdir) {
> > +		fprintf(stderr, "del_mtab: cannot determine current mtab path");
> > +		rc = EX_FILEIO;
> > +		goto del_mtab_exit;
> > +	}
> > +
> > +	tmpfile = strcat(mtabdir, MNT_TMP_FILE);
> 
> Then using strcat to append MNT_TMP_FILE to mtabdir. But, won't that be
> longer than the original string that you strdup'ed?
> 
Right, makes sense. I'll be changing this to pre-allocate enough memory
to tmpfile and mtabdir before concatenate the strings.

> > +		if (rc) {
> > +			fprintf(stderr, "del_mtab: unable to add mount entry to mtab\n");
> > +			ftruncate(fd, statbuf.st_size);
> 
> 			^^^^^^^^^^^^
> 			At this point, statbuf is full of leftover stack
> 			junk. You're going to truncate it to an unknown
> 			value here since you haven't fstat'ed it yet.
> 
> 			In any case, there's no reason to truncate the
> 			original mnttab here. You aren't altering it.
> 			Won't that potentially fail since you opened it
> 			"r" anyway?
> 

About the ftruncate, I'm removing it since it's not necessary. About the
open mode of mnttab, the rename() function doesn't need the file to be
opened, look that both files are closed before call rename().

> > +	}
> > +
> > +	tmprc = my_endmntent(mntmtab, statbuf.st_size);
> > +	if (tmprc) {
> > +		fprintf(stderr, "del_mtab: error %d detected on close of mtab\n", tmprc);
> > +		rc = EX_FILEIO;
> > +	}
> 
> You probably don't need to use my_endmntent here since the original
> mtab isn't being altered, just replaced.
> 
> > +	endmntent(mnttmp);
> 
> You should however fflush the mnttmp stream, and fsync that fd before
> you replace the mtab. You could use my_endmntent for that, but there's
> no need to truncate if that fails -- you'll just want to delete the
> tmpfile in that case and return an error (right?).
> 
I'm changing the order here. I'll close mnttmp using my_endmntent() to
ensure it gets synched before it's closed and use endmntent() to close
the mntmtab since the last one does not need a sync.

I hope to have the patch today yet.

-- 
--Carlos
