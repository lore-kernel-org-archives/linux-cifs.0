From: Jeff Layton <jlayton@samba.org>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Thu, 28 Feb 2013 07:26:37 -0800
Message-ID: <20130228072637.3b71a4f7@corrin.poochiereds.net>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net>
	<512E8787.6070709@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	"Stefan \(metze\) Metzmacher" <metze@samba.org>,
	Dave Chiluk <chiluk@canonical.com>
To: Dave Chiluk <dave.chiluk@canonical.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <512E8787.6070709@canonical.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 27 Feb 2013 16:24:07 -0600
Dave Chiluk <dave.chiluk@canonical.com> wrote:

> On 02/27/2013 10:34 AM, Jeff Layton wrote:
> > On Wed, 27 Feb 2013 12:06:14 +0100
> > "Stefan (metze) Metzmacher" <metze@samba.org> wrote:
> > 
> >> Hi Dave,
> >>
> >>> When messages are currently in queue awaiting a response, decrease amount of
> >>> time before attempting cifs_reconnect to SMB_MAX_RTT = 10 seconds. The current
> >>> wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERVAL(120
> >>> seconds) since the last response was recieved.  This does not take into account
> >>> the fact that messages waiting for a response should be serviced within a
> >>> reasonable round trip time.
> >>
> >> Wouldn't that mean that the client will disconnect a good connection,
> >> if the server doesn't response within 10 seconds?
> >> Reads and Writes can take longer than 10 seconds...
> >>
> > 
> > Where does this magic value of 10s come from? Note that a slow server
> > can take *minutes* to respond to writes that are long past the EOF.
> It comes from the desire to decrease the reconnection delay to something
> better than a random number between 60 and 120 seconds.  I am not
> committed to this number, and it is open for discussion.  Additionally
> if you look closely at the logic it's not 10 seconds per request, but
> actually when requests have been in flight for more than 10 seconds make
> sure we've heard from the server in the last 10 seconds.
> 
> Can you explain more fully your use case of writes that are long past
> the EOF?  Perhaps with a test-case or script that I can test?  As far as
> I know writes long past EOF will just result in a sparse file, and
> return in a reasonable round trip time *(that's at least what I'm seeing
> with my testing).  dd if=/dev/zero of=/mnt/cifs/a bs=1M count=100
> seek=100000, starts receiving responses from the server in about .05
> seconds with subsequent responses following at roughly .002-.01 second
> intervals.  This is well within my 10 second value.  Even adding the
> latency of AT&T's 2g cell network brings it up to only 1s.  Still 10x
> less than my 10 second value.
> 
> The new logic goes like this
> if( we've been expecting a response from the server (in_flight), and
>  message has been in_flight for more than 10 seconds and
>  we haven't had any other contact from the server in that time
>   reconnect
> 

That will break writes long past the EOF. Note too that reconnects on
CIFS are horrifically expensive and problematic. Much of the state on a
CIFS mount is tied to the connection. When that drops, open files are
closed and things like locks are dropped. SMB1 has no real mechanism
for state recovery, so that can really be a problem.

> On a side note, I discovered a small race condition in the previous
> logic while working on this, that my new patch also fixes.
> 1s  request
> 2s  response
> 61.995 echo job pops
> 121.995 echo job pops and sends echo
> 122 server_unresponsive called.  Finds no response and attempts to
> 	 reconnect
> 122.95 response to echo received
> 

Sure, here's a reproducer. Do this against a windows server, preferably
one exporting NTFS on relatively slow storage. Make sure that
"testfile" doesn't exist first:

     $ dd if=/dev/zero of=/path/to/cifs/share/testfile bs=1M count=1 seek=3192

NTFS doesn't support sparse files, so the OS has to zero-fill up to the
point where you're writing. That can take a looooong time on slow
storage (minutes even). What we do now is periodically send a SMB echo
to make sure the server is alive rather than trying to time out a
particular call.

The logic that handles that today is somewhat sub-optimal though. We
send an echo every 60s whether there are any calls in flight or not and
wait for 60s until we decide that the server isn't there. What would be
better is to only send one when we've been waiting a long time for a
response.

That "long time" is debatable -- 10s would be fine with me but the
logic needs to be fixed not to send echoes unless there is an
outstanding request first.

I think though that you're trying to use this mechanism to do something
that it wasn't really designed to do. A better method might be to try
and detect whether the TCP connection is really dead somehow. That
would be more immediate, but I'm unclear on how best to do that.
Probably it'll mean groveling around down in the TCP layer...

FWIW, there was a thread on the linux-cifs mailing list started on Dec
3, 2010 entitled "cifs client timeouts and hard/soft mounts" that lays
out the rationale for the current reconnection behavior. You may want
to look over that before you go making changes here...

-- 
Jeff Layton <jlayton@samba.org>
