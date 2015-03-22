From: Taesoo Kim <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
Subject: Re: [PATCH 1/1] cifs: potential memory leaks when parsing mnt opts
Date: Sat, 21 Mar 2015 23:23:40 -0400
Message-ID: <20150322032340.GD5170@taesoo.org>
References: <1426979310-31201-1-git-send-email-tsgatesv@gmail.com>
 <CAFB9KM3==40uUXxxOD_CD09zFPj3Fmr-Brt7x4SZj86NTf3_vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taesoo Kim <tsgatesv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org,
	sanidhya-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, blee-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, csong84-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFB9KM3==40uUXxxOD_CD09zFPj3Fmr-Brt7x4SZj86NTf3_vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/21/15 at 09:10pm, Scott Lovenberg wrote:
> On Sat, Mar 21, 2015 at 6:08 PM, Taesoo Kim <tsgatesv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Althouhg mkfs.cifs in userspace performs a bit of sanitization
> > (e.g., forcing one user option), current implementation is not
> > robust. Other options such as iocharset and domainanme are similary
> > vulnerable.
> >
> 
> I assume you mean mount.cifs?  :-) Anyways, good catch.

Right. FYI, I've tried mangling password field (e.g., pass=a,user=A
&c); Skimming through the code (just a few minutes), there are a few
potential places that don't sanitize its string, unlike passwd. But
don't have much time to play with for now :)

Thanks,
Taesoo
 
> -- 
> Peace and Blessings,
> -Scott.
