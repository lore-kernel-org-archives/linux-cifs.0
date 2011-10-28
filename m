From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Fri, 28 Oct 2011 10:16:58 -0500
Message-ID: <CAH2r5mtEV2YpTTnrE+03_gm=+CKGxOhLOtRBf6VX2QgXihLDrw@mail.gmail.com>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
	<20111027210722.GA29989@infradead.org>
	<CAH2r5mvCDTE91Mj-HAm_WhSTrzHKi6RNvBL0-+e92POxeqXA9w@mail.gmail.com>
	<20111027211515.GA1380@infradead.org>
	<20111028095834.2a89660b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111028095834.2a89660b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 28, 2011 at 8:58 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 27 Oct 2011 17:15:15 -0400
> Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
>> I'm not complaining about Pavel - he has generally done outstanding
>> work.
>>
>> But patches posted the first time in that form two days ago (and the
>> first time completely for a long time) are simply not suitable for
>
> I agree. It's definitely premature to merge this series. The patches
> themselves have never been posted to the list AFAICT, though Pavel ha=
s
> on occasion posted a link to his git tree. That's not the same thing
> however. As a general rule...
>
> =A0 "If it's not on the list, then it doesn't exist"

Be fair to Pavel ... I trivially found individual smb2 patches on list =
as
far back as February (probably earlier on the other mailing list),
the stats patch I redid to include Christoph's feedback and Pavel
incorporated much feedback this summer from at least four developers
and from the two test events I attended.  You
gave patch feedback to Pavel multiple times this summer.
And with him breaking the patches into smaller pieces,
I can see why he was reluctant to post a 50 patch series,
but posted a link to them.   Posting the series individually
is usually better, but this last respin was mainly to deal
with merge conflicts from your large (nicely done) async
series and other recent cifs patches.



--=20
Thanks,

Steve
