From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Fri, 28 Oct 2011 07:28:14 -0700
Message-ID: <CA+55aFy1BtNSjti8SrEgy-Kc9FWr4gKPx0ytyW=47J+JnaHpHQ@mail.gmail.com>
References: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
 <20111027210722.GA29989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111027210722.GA29989-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 27, 2011 at 2:07 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> Clear NAK. =A0The SMB2 support has been posted a couple of days ago, =
and
> both Jeff and me as likely reviewers had been travelling during that
> time, nevermind that a totally new feature really needs more baking t=
ime
> than half a week.

Thanks for catching that.

And in general, I *really* want code to have been in linux-next for
this merge window (although rebasing has made it annoyingly hard to
check that).

There was tons of time for it, and linux-next is absolutely huge, so
it's clear that we have "enough" code in linux-next as-is.

                          Linus
