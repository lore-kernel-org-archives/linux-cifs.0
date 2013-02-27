From: Dave Chiluk <dave.chiluk-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Wed, 27 Feb 2013 16:24:07 -0600
Message-ID: <512E8787.6070709@canonical.com>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com> <512DE8A6.9030000@samba.org> <20130227083419.0af9deaf@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dave Chiluk <chiluk-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130227083419.0af9deaf-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 02/27/2013 10:34 AM, Jeff Layton wrote:
> On Wed, 27 Feb 2013 12:06:14 +0100
> "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
>> Hi Dave,
>>
>>> When messages are currently in queue awaiting a response, decrease amount of
>>> time before attempting cifs_reconnect to SMB_MAX_RTT = 10 seconds. The current
>>> wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERVAL(120
>>> seconds) since the last response was recieved.  This does not take into account
>>> the fact that messages waiting for a response should be serviced within a
>>> reasonable round trip time.
>>
>> Wouldn't that mean that the client will disconnect a good connection,
>> if the server doesn't response within 10 seconds?
>> Reads and Writes can take longer than 10 seconds...
>>
> 
> Where does this magic value of 10s come from? Note that a slow server
> can take *minutes* to respond to writes that are long past the EOF.
It comes from the desire to decrease the reconnection delay to something
better than a random number between 60 and 120 seconds.  I am not
committed to this number, and it is open for discussion.  Additionally
if you look closely at the logic it's not 10 seconds per request, but
actually when requests have been in flight for more than 10 seconds make
sure we've heard from the server in the last 10 seconds.

Can you explain more fully your use case of writes that are long past
the EOF?  Perhaps with a test-case or script that I can test?  As far as
I know writes long past EOF will just result in a sparse file, and
return in a reasonable round trip time *(that's at least what I'm seeing
with my testing).  dd if=/dev/zero of=/mnt/cifs/a bs=1M count=100
seek=100000, starts receiving responses from the server in about .05
seconds with subsequent responses following at roughly .002-.01 second
intervals.  This is well within my 10 second value.  Even adding the
latency of AT&T's 2g cell network brings it up to only 1s.  Still 10x
less than my 10 second value.

The new logic goes like this
if( we've been expecting a response from the server (in_flight), and
 message has been in_flight for more than 10 seconds and
 we haven't had any other contact from the server in that time
  reconnect

On a side note, I discovered a small race condition in the previous
logic while working on this, that my new patch also fixes.
1s  request
2s  response
61.995 echo job pops
121.995 echo job pops and sends echo
122 server_unresponsive called.  Finds no response and attempts to
	 reconnect
122.95 response to echo received

>>> This fixes the issue where user moves from wired to wireless or vice versa
>>> causing the mount to hang for 120 seconds, when it could reconnect considerably
>>> faster.  After this fix it will take SMB_MAX_RTT (10 seconds) from the last
>>> time the user attempted to access the volume or SMB_MAX_RTT after the last
>>> echo.  The worst case of the latter scenario being
>>> 2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130 seconds).
>>> Statistically speaking it would normally reconnect sooner.  However in the best
>>> case where the user changes nics, and immediately tries to access the cifs
>>> share it will take SMB_MAX_RTT=10 seconds.
>>
>> I think it would be better to detect the broken connection
>> by using an AF_NETLINK socket listening for RTM_DELADDR
>> messages?
>>
>> metze
>>
> 
> Ick -- that sounds horrid ;)
> 
> Dave, this problem sounds very similar to the one that your colleague
> Chris J Arges was trying to solve several months ago. You may want to
> go back and review that thread. Perhaps you can solve both problems at
> the same time here...
> 
This is the same problem as was discussed here.
https://patchwork.kernel.org/patch/1717841/

>From that thread you made the suggestion of
"What would really be better is fixing the code to only echo when there
are outstanding calls to the server."

I thought about that, and liked keeping the echo functionality as a
heart beat when nothing else is going on.  If we only echo when there
are outstanding calls, then the client will not attempt to reconnect
until the user attempts to use the mount.  I'd rather it reconnect when
nothing is happening.

As for the rest of the suggestion from that thread, we aren't trying to
solve a suspend/resume use case, but actually a dock/undock use case.
Basically reconnecting quickly when going from wired to wireless or vice
versa.

Dave.
