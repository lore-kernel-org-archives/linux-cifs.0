From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Thu, 28 Feb 2013 08:47:04 -0800
Message-ID: <20130228084704.7f267119@corrin.poochiereds.net>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net>
	<512E8787.6070709@canonical.com>
	<20130228072637.3b71a4f7@corrin.poochiereds.net>
	<CAH2r5mtBHO6woWeOJ+DJDBmF35VTfuFYo2iza--xAe7grnELAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Chiluk <dave.chiluk-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dave Chiluk <chiluk-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtBHO6woWeOJ+DJDBmF35VTfuFYo2iza--xAe7grnELAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Feb 2013 10:04:36 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Feb 28, 2013 at 9:26 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > On Wed, 27 Feb 2013 16:24:07 -0600
> > Dave Chiluk <dave.chiluk-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> >
> >> On 02/27/2013 10:34 AM, Jeff Layton wrote:
> >> > On Wed, 27 Feb 2013 12:06:14 +0100
> >> > "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >> >
> >> >> Hi Dave,
> >> >>
> >> >>> When messages are currently in queue awaiting a response, decrease amount of
> >> >>> time before attempting cifs_reconnect to SMB_MAX_RTT = 10 seconds. The current
> >> >>> wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERVAL(120
> >> >>> seconds) since the last response was recieved.  This does not take into account
> >> >>> the fact that messages waiting for a response should be serviced within a
> >> >>> reasonable round trip time.
> >> >>
> >> >> Wouldn't that mean that the client will disconnect a good connection,
> >> >> if the server doesn't response within 10 seconds?
> >> >> Reads and Writes can take longer than 10 seconds...
> >> >>
> >> >
> >> > Where does this magic value of 10s come from? Note that a slow server
> >> > can take *minutes* to respond to writes that are long past the EOF.
> >> It comes from the desire to decrease the reconnection delay to something
> >> better than a random number between 60 and 120 seconds.  I am not
> >> committed to this number, and it is open for discussion.  Additionally
> >> if you look closely at the logic it's not 10 seconds per request, but
> >> actually when requests have been in flight for more than 10 seconds make
> >> sure we've heard from the server in the last 10 seconds.
> >>
> >> Can you explain more fully your use case of writes that are long past
> >> the EOF?  Perhaps with a test-case or script that I can test?  As far as
> >> I know writes long past EOF will just result in a sparse file, and
> >> return in a reasonable round trip time *(that's at least what I'm seeing
> >> with my testing).  dd if=/dev/zero of=/mnt/cifs/a bs=1M count=100
> >> seek=100000, starts receiving responses from the server in about .05
> >> seconds with subsequent responses following at roughly .002-.01 second
> >> intervals.  This is well within my 10 second value.  Even adding the
> >> latency of AT&T's 2g cell network brings it up to only 1s.  Still 10x
> >> less than my 10 second value.
> >>
> >> The new logic goes like this
> >> if( we've been expecting a response from the server (in_flight), and
> >>  message has been in_flight for more than 10 seconds and
> >>  we haven't had any other contact from the server in that time
> >>   reconnect
> >>
> >
> > That will break writes long past the EOF. Note too that reconnects on
> > CIFS are horrifically expensive and problematic. Much of the state on a
> > CIFS mount is tied to the connection. When that drops, open files are
> > closed and things like locks are dropped. SMB1 has no real mechanism
> > for state recovery, so that can really be a problem.
> >
> >> On a side note, I discovered a small race condition in the previous
> >> logic while working on this, that my new patch also fixes.
> >> 1s  request
> >> 2s  response
> >> 61.995 echo job pops
> >> 121.995 echo job pops and sends echo
> >> 122 server_unresponsive called.  Finds no response and attempts to
> >>        reconnect
> >> 122.95 response to echo received
> >>
> >
> > Sure, here's a reproducer. Do this against a windows server, preferably
> > one exporting NTFS on relatively slow storage. Make sure that
> > "testfile" doesn't exist first:
> >
> >      $ dd if=/dev/zero of=/path/to/cifs/share/testfile bs=1M count=1 seek=3192
> >
> > NTFS doesn't support sparse files, so the OS has to zero-fill up to the
> > point where you're writing. That can take a looooong time on slow
> > storage (minutes even). What we do now is periodically send a SMB echo
> > to make sure the server is alive rather than trying to time out a
> > particular call.
> 
> Writing past end of file in Windows can be very slow, but note that it
> is possible for a windows to set as sparse a file on an NTFS
> partition.   Quoting from
> http://msdn.microsoft.com/en-us/library/windows/desktop/aa365566%28v=vs.85%29.aspx
> Windows NTFS does support sparse files (and we could even send it over
> cifs if we want) but it has to be explicitly set by the app on the
> file:
> 
> "To determine whether a file system supports sparse files, call the
> GetVolumeInformation function and examine the
> FILE_SUPPORTS_SPARSE_FILES bit flag returned through the
> lpFileSystemFlags parameter.
> 
> Most applications are not aware of sparse files and will not create
> sparse files. The fact that an application is reading a sparse file is
> transparent to the application. An application that is aware of
> sparse-files should determine whether its data set is suitable to be
> kept in a sparse file. After that determination is made, the
> application must explicitly declare a file as sparse, using the
> FSCTL_SET_SPARSE control code."
> 
> 

That's interesting. I didn't know about the fsctl.

It doesn't really help us though. Not all servers support passthrough
infolevels, and there are other filesystems (e.g. FAT) that don't
support sparse files at all.

In any case, the upshot of all of this is that we simply can't assume
that we'll get the response to a particular call in any given amount of
time, so we have to periodically check that the server is still
responding via echoes before giving up on it completely.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
