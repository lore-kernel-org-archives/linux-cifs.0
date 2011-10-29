From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Sat, 29 Oct 2011 14:35:32 -0400
Message-ID: <20111029183532.GF12122@fieldses.org>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
 <20111027210722.GA29989@infradead.org>
 <CAH2r5mvCDTE91Mj-HAm_WhSTrzHKi6RNvBL0-+e92POxeqXA9w@mail.gmail.com>
 <20111027211515.GA1380@infradead.org>
 <20111028095834.2a89660b@corrin.poochiereds.net>
 <CAH2r5mtEV2YpTTnrE+03_gm=+CKGxOhLOtRBf6VX2QgXihLDrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtEV2YpTTnrE+03_gm=+CKGxOhLOtRBf6VX2QgXihLDrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 28, 2011 at 10:16:58AM -0500, Steve French wrote:
> Be fair to Pavel ... I trivially found individual smb2 patches on list as
> far back as February (probably earlier on the other mailing list),
> the stats patch I redid to include Christoph's feedback and Pavel
> incorporated much feedback this summer from at least four developers
> and from the two test events I attended.

Well, obviously "Here are some comments on this patch" shouldn't be
assumed to mean "consider this patch ACKed if this comments are
addressed".

The policy I aim for (though no doubt I screw it up) is: every patch I
commit should have previously been cc:'d to the appropriate places, in
the form it's applied (eh, modulo whitespace fixes or fixups nearly that
trivial).  And some time should pass before committing.  (Totally
trivial stuff I figure I can get away with committing immediately,
stuff I don't expect much argument over might sit only 24 hours,
anything big I try to make sure potential reviewers have a few days to
respond.)

> And with him breaking the patches into smaller pieces,
> I can see why he was reluctant to post a 50 patch series,
> but posted a link to them.

Another approach is to break up the 50 patches into logical subsets
(especially good is if you can split out any of them as cleanup or
bugfixes that can be justified entirely on their own).

--b.
