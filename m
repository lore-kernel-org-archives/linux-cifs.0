From: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] readdir cf_nlink initialization
Date: Mon, 16 Sep 2013 17:11:13 -0400
Message-ID: <CAFneQccR3FK10Lw0KgMdhQDz6CZGfeHEE05VEv3HTRnpHVZsxA@mail.gmail.com>
References: <CAFneQcePFASf4u_Q-xyCy0_cYrpOb7p3+yQV1N1FKxtNYMi2vQ@mail.gmail.com>
 <20130908103237.645ce91d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130908103237.645ce91d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 8, 2013 at 10:32 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> The only other thing I see is that the code in cifs_all_info_to_fattr
> ought to be changed to use this flag and not try to fake up the
> cf_nlink value.
Ok, after looking a bit more, I'm not sure how we would know what to
do.  If we're doing a qpathinfo for all_info, aren't we always getting
a value for nlink?  How would we determine whether it needs to be
"fixed" or not?  Do we just assume that for all non-unix cases we
can't trust it?


-- 
Jim McDonough
Samba Team
SUSE labs
jmcd at samba dot org
jmcd at themcdonoughs dot org
