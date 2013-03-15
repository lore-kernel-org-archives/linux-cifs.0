From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH] cifs: Rename cERROR and cFYI to cifs_dbg
Date: Fri, 15 Mar 2013 16:46:22 -0500
Message-ID: <CAH2r5msj-Mei76ZX8Hjg5uWwCUcn_PLWuSpAorGROV3nRsX=Zg@mail.gmail.com>
References: <1363128287.23052.21.camel@joe-AO722>
	<1363174614.2031.9.camel@joe-AO722>
	<20130313075155.7464a34a@tlielax.poochiereds.net>
	<1363178421.2031.29.camel@joe-AO722>
	<1363289077.2146.19.camel@joe-AO722>
	<20130315150136.7f7a262a@tlielax.poochiereds.net>
	<CAH2r5mvW29FV+stH5CsjY5S2FdaHn48TfiSEk_beC=NzHC7-MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvW29FV+stH5CsjY5S2FdaHn48TfiSEk_beC=NzHC7-MQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 15, 2013 at 2:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, 14 Mar 2013 12:24:37 -0700
> Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
>
> > It's not obvious from reading the macro names that these macros
> > are for debugging.  Convert the names to a single more typical
> > kernel style cifs_dbg macro.
> >
> >       cERROR(1, ...)   -> cifs_dbg(VFS, ...)
> >       cFYI(1, ...)     -> cifs_dbg(FYI, ...)
> >       cFYI(DBG2, ...)  -> cifs_dbg(NOISY, ...)
> >
> > Move the terminating format newline from the macro to the call site.
> >
> > Add CONFIG_CIFS_DEBUG function cifs_vfs_err to emit the
> > "CIFS VFS: " prefix for VFS messages.
> >
> > Size is reduced ~ 1% when CONFIG_CIFS_DEBUG is set (default y)
> >
> > $ size fs/cifs/cifs.ko*
> >    text    data     bss     dec     hex filename
> >  265245          2525     132  267902   4167e fs/cifs/cifs.ko.new
> >  268359    2525     132  271016   422a8 fs/cifs/cifs.ko.old
> >
>
> (my apologies -- my MUA has a mind of its own sometimes)
>
> This all looks like good stuff. I am a bit concerned about mashing all
> of these cleanups into the same patch though.
>
> > Other miscellaneous changes around these conversions:
> >
> > o Miscellaneous typo fixes
> > o Add terminating \n's to almost all formats and remove them
> >   from the macros to be more kernel style like.  A few formats
> >   previously had defective \n's
> > o Remove unnecessary OOM messages as kmalloc() calls dump_stack
> > o Coalesce formats to make grep easier,
> >   added missing spaces when coalescing formats
> > o Use %s, __func__ instead of embedded function name
> > o Removed unnecessary "cifs: " prefixes
>
> > o Convert kzalloc with multiply to kcalloc
>         ^^^
> Things like this really ought to be a separate patch, even though it is
> a trivial change. That's a minor nit though...
>
> > o Remove unused cifswarn macro
> >
>
> I think we ought to go ahead and take this for 3.10. I do have some
> minor concern about having to deal with backports of later patches to
> kernels that don't have these changes, but hey, that's the price of
> dealing with old kernels.
>
> The sooner Steve merges this into his for-next tree, the better. This
> bound to give us all sorts of merge conflicts for the 3.10 window, so
> we want to make sure that people know what to base their work on.

I would like to merge the three we have (one still has to be put in for-next
- the one from Jeff) for for-next in the next three or fouir days - but I
can create another temporary branch for the ones for 3.10 - but ... I would
like to simplify things by merging the other cleanup patches we already have
first.  I agree that we are going to have to let people know to rebase
everything for cifs for 3.10 on this big cleanup patch.

--
Thanks,

Steve



--
Thanks,

Steve
