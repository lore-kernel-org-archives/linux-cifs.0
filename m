From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] Create test groups for cifs in xfstests
Date: Thu, 14 Apr 2016 23:47:44 -0500
Message-ID: <57107270.6060505@sandeen.net>
References: <CAH2r5muHTHXikTCqiiU7AFx8Z-Ra_7CYK4f6PCZ_4KfVbO3-PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Steve French <smfrench@gmail.com>, fstests@vger.kernel.org,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muHTHXikTCqiiU7AFx8Z-Ra_7CYK4f6PCZ_4KfVbO3-PA@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Steve -

On 4/14/16 10:53 PM, Steve French wrote:
> Attached is a trivial patch to create two xfstest groups for cifs
> 
> Since some of the tests in xfstests are only appropriate for local filesystems

Are there tests that are wholly inappropriate for cifs (or nfs) which try
to run anyway and flame out, explode, or fail nonsensically?

In that case, an _unsupported_fs or a _require_local_fs might be a
better way to exclude those tests.  (those don't exist yet, but
could easily).

> and some of the "quick" tests are only quick on local, not network
> filesystems,

Dave has a good idea on this, I'll let him chime in ;)

> create two test groups for testing cifs to make
> use of xfstests easier. (I will add a similar follow on patch for
> nfs after this). The first new test group "cifs-quick"
> includes a set of tests that execute fairly quickly (under a few minutes
> each), and second "cifs" which includes the tests which can take
> much longer or are not as appropriate for quick verification of
> a cifs build.

fs type specifications are a little odd in groups files; udf is in
there, but that's for hysterical raisins.

My worry is that as new tests are added, you're going to have to keep
chasing them with these new tags, and many new tests won't get run
because you'll have too much "./check -g cifs" muscle memory.  :)

More descriptive tags and functions like _require_local_fs, 
_unsupported_fs, or group tags to exclude slow network tests
keeps things a lot more generic, I think.

The commit log sounds like terse output is desired, too?
Perhaps a -q (quiet) switch could suppress all the "not run"
tests, although I guess I usually want to see why things don't
run, myself.

-Eric
