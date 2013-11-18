From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: setfacl fix
Date: Tue, 19 Nov 2013 09:44:26 +1100
Message-ID: <20131118224426.GW6188@dastard>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
 <20131116145507.GA22395@infradead.org>
 <CAH2r5mtXjnAOpKzZzta_yWDGyEPzR7h1wb0UW2pnoicm9Qsgxg@mail.gmail.com>
 <20131118152723.GA19649@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131118152723.GA19649-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 18, 2013 at 07:27:23AM -0800, Christoph Hellwig wrote:
> On Sat, Nov 16, 2013 at 03:38:09PM -0600, Steve French wrote:
> > Makes sense to add a setfacl/getfacl test to xfstest and was trying to
> > build updated xfstests and look at what has changed but ran into a
> > strange error building xfstests and didn't see an obvious answer when
> > googling for it.  Any idea how to workaround the build failure?
> > 
> > Building src
> >     [DEP]
> >     [CC]    dirstress
> > gcc: error: /lib64/libhandle.so: Too many levels of symbolic links

What's the circular link chain?

> > These are the steps I went through from a fairly clean Fedora 19 64
> > system before the make failure:
> 
> No idea.  Maybe some of the RedHat people on the xfs list have more
> experience with Fedora than I have.

Don't look at me - I use Debian for all my upstream stuff.... ;)

> > git clone git://oss.sgi.com/xfs/cmds/xfstests
> > git clone git://oss.sgi.com/xfs/cmds/xfsprogs
> > sudo yum install uuid-devel e2fsprogs-devel libuuid-devel
> > libattr-devel libacl-devel
> > cd xfsprogs
> > make
> > sudo make install-qa
> > cd ../xfstests
> > ./configure
> > make (which failed with the symlink error above)

Having the output of all the steps, especially the xfsprogs
install-qa step is probably going to be necessary to debug this. You
probably want to run "make Q= install-qa" so that it runs verbosely.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
