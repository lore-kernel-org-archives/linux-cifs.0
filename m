From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Thu, 15 Mar 2012 07:06:17 -0400
Message-ID: <20120315070617.3728cf0d@tlielax.poochiereds.net>
References: <4F5A2CCD.6010808@gmail.com>
	<24dc471d-42ca-45cf-89eb-26dc3117fa1a@zmail17.collab.prod.int.phx2.redhat.com>
	<20120314151811.65838f6b@redhat.com>
	<CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 14 Mar 2012 14:30:23 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I don't mind reviewing this, but it does appear to change behaviour
> significantly from existing code.  Does this fix a reported bug?
> 

Technically no, but it's horribly ugly code and that makes it difficult
to maintain. Look . It's long been a pain point for cifs.ko maintenance. Now
that we're looking at SMB2 code, I for one am keen on eliminating that
pain now before it's a similar problem there.

> The linux cifs kernel driver, like some other
> network clients, allows partial option matching to ease
> usability for users of other platforms (e.g. "pass" or
> "passwd" or "password" are intentionally all accepted
> since we match on the first four bytes of that keyword).
> Is there a way to get that to work with your patchset.
> I worry that some users will be confused that their
> mount options won't work if this is taken.
> 

I consider the existing behavior a bug (though a minor one). The
question is not so much those, but the fact that the existing parser
also accepts stuff like "passfoobarbaz=".

We can certainly make the standard token parser accept common and
*advertised* mount option abbreviations. If it breaks someone who's
using "passfoobarbz=" then I personally don't care very much. We've
never claimed that that option would work, and thus if it breaks then I
wouldn't consider it a bug.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
