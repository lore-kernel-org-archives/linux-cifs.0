From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Create test groups for cifs in xfstests
Date: Fri, 15 Apr 2016 15:02:39 +1000
Message-ID: <20160415050239.GB567@dastard>
References: <CAH2r5muHTHXikTCqiiU7AFx8Z-Ra_7CYK4f6PCZ_4KfVbO3-PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muHTHXikTCqiiU7AFx8Z-Ra_7CYK4f6PCZ_4KfVbO3-PA@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Apr 14, 2016 at 10:53:15PM -0500, Steve French wrote:
> Attached is a trivial patch to create two xfstest groups for cifs
> 
> Since some of the tests in xfstests are only appropriate for local filesystems
> and some of the "quick" tests are only quick on local, not network
> filesystems, create two test groups for testing cifs to make
> use of xfstests easier. (I will add a similar follow on patch for
> nfs after this). The first new test group "cifs-quick"
> includes a set of tests that execute fairly quickly (under a few minutes
> each), and second "cifs" which includes the tests which can take
> much longer or are not as appropriate for quick verification of
> a cifs build.

I'm not sure this is the best way to use test grouping. Yes, it
serves your immediate purpose, but I'd prefer to find a way of
grouping tests that is less protocol specific and hence easier to
maintain.

A couple of things stand out about your classifications that will
catch people unaware:

	- quick is a subset of auto, so when you run the auto group,
	  you also get the quick tests run. "cifs" and "cifs-quick"
	  are exclusive groups, so when you run the "cifs" group, it
	  doesn't run all the regression tests it could.

	- new tests are not going to add cifs or nfs
	  classifications, so they are not going to be run if you
	  are using cifs/cifs-quick rather than auto/quick as the
	  test groups that you run.

	- "quick" means runs in under 15-20s on typical test
	  systems. auto is generally limited to tests that run in
	  under 5 minutes. You're definition of "cifs-quick" is
	  roughly the same as "auto", which means nobody is going to
	  be able to classify them correctly without a CIFS setup.

	- similarly, there is no consistency between quick and
	  cifs-quick, or auto and cifs. Some are auto + cifs-quick,
	  others are quick + cifs. Often tests that are not marked
	  as quick will run really fast on SSD/RAID w/ bbwc, but are
	  horrifically slow on a spinning SATA drive. Hence we don't
	  classify them as quick, and I can't see how adding CIFS on
	  a slow SATA drive is going to make them any faster....

What I think would be a better solution is to define groups for
exclusion of certain tests, rather than trying define a compelte new
set of tests specific to a certain filesystem.

That is, define a "remotefs-slow" group, so that you can run:

./check -g quick -x remotefs-slow

ad it runs all the tests in the quick group except for those that
are known to be slow on remote filesystems. This way you'll
automatically run new tests that are added to the quick/auto groups,
rather than periodically having to make passes to add all the new
tests into your cifs/nfs groups. I suspect that the "slow" tests is
a much smaller set than cifs/nfs sets currently are...

This will preserve the expected behaviour across different types of
physical storage, but also encodes the fact that a remotefs layer
makes this test much slower. This might even extend to, say, iscsi
as well as there are a couple of tests (generic/127) that run in
~50s on local storage but take >1200s on my iscsi based test VMs
because of the latency all the sync writes introduce across the
network. i.e:

./check -g auto -x iscsi-slow

would knock 15 minutes of runtime from a test cycle on a couple of
my test VMs...

Such classifications would also be useful documentation when someone
asks "how long should we expect this test to run". Just looking at
the group files will tell use roughly what we should expect.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
