From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] autoconf: fix help message for --enable-cifsidmap
Date: Tue, 23 Aug 2011 12:41:53 -0400
Message-ID: <20110823124153.638df155@corrin.poochiereds.net>
References: <1314104603-3941-1-git-send-email-jlayton@samba.org>
	<20110823182106.163416ro6niegbci@rozijn.ugent.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: "Luk Claes" <Luk.Claes-Uy3+E7BMiTU@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110823182106.163416ro6niegbci-e9H6qYbevPUmCttN7JqJIg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 23 Aug 2011 18:21:06 +0200
"Luk Claes" <Luk.Claes-Uy3+E7BMiTU@public.gmane.org> wrote:

> Hi Jeff
> 
> Hmm, I thought it's auto as default which would only be yes if the  
> needed headers and libraries are installed?
> 
> Cheers
> 
> Luk
> 

Point of semantics I guess :)

I figured the default was "yes", but if the necessary stuff wasn't
present then it would be autodisabled. That's how cifs.upcall works
too. If "default=auto" is more illustrative of this situation then I'll
respin the patch and fix the cifs.upcall help text too.

> Quoting "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> 
> > It currently says "no" is the default, but it should be "yes".
> >
> > Reported-by: Elias Pipping <pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> >  configure.ac |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/configure.ac b/configure.ac
> > index 780abe7..6a9ad75 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -24,7 +24,7 @@ AC_ARG_ENABLE(cifscreds,
> >
> >  AC_ARG_ENABLE(cifsidmap,
> >  	[AC_HELP_STRING([--enable-cifsidmap],
> > -			[Create cifs.idmap binary @<:@default=no@:>@])],
> > +			[Create cifs.idmap binary @<:@default=yes@:>@])],
> >  	enable_cifsidmap=$enableval,
> >  	enable_cifsidmap="maybe")
> >
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> Luk Claes                                    e-mail: Luk.Claes-Uy3+E7BMiTU@public.gmane.org
> Directie ICT      Afdeling ICT-Infrastructuur            Groep Systemen
> Universiteit Gent      tel: +32 9 264 96 35         fax: +32 9 264 4994
> Krijgslaan 281, gebouw S9, 9000 Gent, Belgie               www.UGent.be
> -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
