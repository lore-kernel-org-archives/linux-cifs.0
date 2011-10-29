From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Sat, 29 Oct 2011 16:57:04 -0500
Message-ID: <CAH2r5muS_1U=RsLavVSnjFUSqDREAoFS+dLpF9gXMrcODv6cEw@mail.gmail.com>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
	<20111027210722.GA29989@infradead.org>
	<CAH2r5mvCDTE91Mj-HAm_WhSTrzHKi6RNvBL0-+e92POxeqXA9w@mail.gmail.com>
	<20111027211515.GA1380@infradead.org>
	<20111028095834.2a89660b@corrin.poochiereds.net>
	<CAH2r5mtEV2YpTTnrE+03_gm=+CKGxOhLOtRBf6VX2QgXihLDrw@mail.gmail.com>
	<20111029183532.GF12122@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111029183532.GF12122-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Oct 29, 2011 at 1:35 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>=
 wrote:
> The policy I aim for (though no doubt I screw it up) is: every patch =
I
> commit should have previously been cc:'d to the appropriate places, i=
n
> the form it's applied (eh, modulo whitespace fixes or fixups nearly t=
hat
> trivial). =A0And some time should pass before committing. =A0(Totally
> trivial stuff I figure I can get away with committing immediately,
> stuff I don't expect much argument over might sit only 24 hours,
> anything big I try to make sure potential reviewers have a few days t=
o
> respond.)
>
>> And with him breaking the patches into smaller pieces,
>> I can see why he was reluctant to post a 50 patch series,
>> but posted a link to them.
>
> Another approach is to break up the 50 patches into logical subsets
> (especially good is if you can split out any of them as cleanup or
> bugfixes that can be justified entirely on their own).

He did a reasonable job of breaking them down, but I also suggested
to him that he defer some of the unrelated cleanup (e.g. a couple
cifs functions moved from one file  to a (more logical) other file
which increases the patch size but doesn't have anything to do
with smb2).  The part that hits existing cifs code is not bad,
and is the part I am most worried about for careful review in
the short term.   As we saw with pNFS, I expect multiple changes,
cleanup, rework of the smb2 specific functions over time, partly
because smb2 (the protocol) is being enhanced - smb 2.2
brings some very interesting new features, and partly due
to adding a few linux extensions (once the support
for smb2.1 passes all functional tests) and partly because
we are going to continue to learn more at every test event.

--=20
Thanks,

Steve
