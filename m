From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] CIFS support for XFS test suite
Date: Wed, 3 Sep 2014 21:42:16 +1000
Message-ID: <20140903114216.GP20518@dastard>
References: <1409341340-27031-1-git-send-email-pshilovsky@samba.org>
 <CAKywueRns+hehrZ3dQ8a8XnaHbd6tNh1BnZAwsTxNTV_w6V6SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueRns+hehrZ3dQ8a8XnaHbd6tNh1BnZAwsTxNTV_w6V6SQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 03, 2014 at 10:23:47AM +0400, Pavel Shilovsky wrote:
> 2014-08-29 23:42 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > These are patches that adds CIFS support to XFS tests.
> >
> > The first patch changes generic/013 test to use mount options provided for $TEST_DEV for remount. The second patch adds "-cifs" command line argument and CIFS specific variables. The third patch disables tests that need POSIX behavior from filesystem for unix cifs mounts.
> >
> > With these patches applied, most of generic/shared $TEST_DEV tests pass for the recent kernel cifs module.
> >
> > Changes since v2:
> > 1) patch #3 uses separate _require_test_{feature} functions rather than generic _require_test_posix_ext
> > 2) patch #2 adds UDF notes to README
> >
> > Pavel Shilovsky (3):
> >   generic/013: encapsulate remount during cleanup
> >   common: add cifs support
> >   cifs: skip tests that need POSIX support for nounix mounts
> >
> >  README            |  5 +++--
> >  check             |  2 ++
> >  common/config     | 31 +++++++++++++++++++++++++++----
> >  common/rc         | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/005 |  8 ++------
> >  tests/generic/013 |  2 +-
> >  tests/generic/023 |  1 +
> >  tests/generic/024 |  1 +
> >  tests/generic/025 |  1 +
> >  tests/generic/131 |  1 +
> >  10 files changed, 94 insertions(+), 13 deletions(-)
> >
> > --
> > 1.9.1
> >
> 
> Any comments on the series?

Patience. It will be friday before I get to it....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
