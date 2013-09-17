From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] readdir cf_nlink initialization
Date: Mon, 16 Sep 2013 21:17:20 -0400
Message-ID: <20130916211720.48ce084a@corrin.poochiereds.net>
References: <CAFneQcePFASf4u_Q-xyCy0_cYrpOb7p3+yQV1N1FKxtNYMi2vQ@mail.gmail.com>
	<20130908103237.645ce91d@tlielax.poochiereds.net>
	<CAFneQccR3FK10Lw0KgMdhQDz6CZGfeHEE05VEv3HTRnpHVZsxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFneQccR3FK10Lw0KgMdhQDz6CZGfeHEE05VEv3HTRnpHVZsxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 16 Sep 2013 17:11:13 -0400
Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Sun, Sep 8, 2013 at 10:32 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > The only other thing I see is that the code in cifs_all_info_to_fattr
> > ought to be changed to use this flag and not try to fake up the
> > cf_nlink value.
> Ok, after looking a bit more, I'm not sure how we would know what to
> do.  If we're doing a qpathinfo for all_info, aren't we always getting
> a value for nlink?  How would we determine whether it needs to be
> "fixed" or not?  Do we just assume that for all non-unix cases we
> can't trust it?
> 

We get a NumberOfLinks value that is often wrong. See commit 6658b9f70e. 

Windows-y servers have funny ideas about how hardlinks work. I'd
suggest just trying to follow the logic as it currently exists and
simply change it over to use your new flag.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
