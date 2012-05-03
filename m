From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
Date: Thu, 03 May 2012 08:56:06 +0800
Message-ID: <1336006566.4154.8.camel@perseus.themaw.net>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net>
	 <CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com>
	 <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
	 <4FA11E59.9050004@suse.com>
	 <20120502135044.6d815e62@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120502135044.6d815e62-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2012-05-02 at 13:50 -0400, Jeff Layton wrote:
> On Wed, 02 May 2012 17:15:29 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > On 04/28/2012 09:03 AM, Steve French wrote:
> > > The fix makes sense, but it is fairly recent and I haven't had a
> > > chance to try it,
> > > so unless a new release is imminent, I would prefer to put in the next merge
> > > request (I have at least one more fix likely as well) next week.
> > 
> > We need this fix for -stable as well, right? Please include
> > 
> >    Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > 
> > 
> > Suresh
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> The stable-kernel-rules.txt file says this:
> 
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
> 
> ...and...
> 
>  - No "theoretical race condition" issues, unless an explanation of how the
>    race can be exploited is also provided.
> 
> ...and this seems to clearly violate both of those rules. I'd say we
> just go with putting it in 3.4 for now, and keep it in mind if someone
> comes back later and says that it's needed.
> 

I have to agree with Jeff.

I just happened to notice it when trying to work out why DFS automounts
weren't happening.

I eventually found that the kernel in use didn't have the d_invalidate()
patch, then realized the potential problem. It would require fairly
heavy demand to trigger so it isn't urgent, especially since no-one has
actually reported it.

Another reason I should have sent this to Steve, not Linus, sorry for
the noise Linus.

Ian
