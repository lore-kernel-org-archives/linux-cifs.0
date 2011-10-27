From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Thu, 27 Oct 2011 16:12:50 -0500
Message-ID: <CAH2r5mvCDTE91Mj-HAm_WhSTrzHKi6RNvBL0-+e92POxeqXA9w@mail.gmail.com>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
	<20111027210722.GA29989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111027210722.GA29989-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Most of the patches have been posted by Pavel quite a long time ago
and incrementally improved.  He spent the summer
fixing/improving/testing. Jeff has reviewed and acked some.  I don't
mind backing them out, and giving more time to review, but as far back
as Connectathon, many of these have been reviewed and some of your
feedback and Jeff's incorporated.   If you think that you and Jeff are
likely to have additional time to review these that is fine, but the
parts that hit common code with cifs in particular have been discussed
quite a bit already.   I am sure Pavel would welcome more eyes.

The smb2 ones are at the tip of the cifs-2.6.git tree (with one
exception, the build fix for Jeff's freezer patch).

On Thu, Oct 27, 2011 at 4:07 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> Clear NAK. =A0The SMB2 support has been posted a couple of days ago, =
and
> both Jeff and me as likely reviewers had been travelling during that
> time, nevermind that a totally new feature really needs more baking t=
ime
> than half a week.
>
>



--=20
Thanks,

Steve
