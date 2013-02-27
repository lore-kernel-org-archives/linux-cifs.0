From: Jeff Layton <jlayton@samba.org>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Wed, 27 Feb 2013 08:34:19 -0800
Message-ID: <20130227083419.0af9deaf@corrin.poochiereds.net>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, Dave Chiluk <chiluk@canonical.com>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <512DE8A6.9030000@samba.org>
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

On Wed, 27 Feb 2013 12:06:14 +0100
"Stefan (metze) Metzmacher" <metze@samba.org> wrote:

> Hi Dave,
> 
> > When messages are currently in queue awaiting a response, decrease amount of
> > time before attempting cifs_reconnect to SMB_MAX_RTT = 10 seconds. The current
> > wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERVAL(120
> > seconds) since the last response was recieved.  This does not take into account
> > the fact that messages waiting for a response should be serviced within a
> > reasonable round trip time.
> 
> Wouldn't that mean that the client will disconnect a good connection,
> if the server doesn't response within 10 seconds?
> Reads and Writes can take longer than 10 seconds...
> 

Where does this magic value of 10s come from? Note that a slow server
can take *minutes* to respond to writes that are long past the EOF.

> > This fixes the issue where user moves from wired to wireless or vice versa
> > causing the mount to hang for 120 seconds, when it could reconnect considerably
> > faster.  After this fix it will take SMB_MAX_RTT (10 seconds) from the last
> > time the user attempted to access the volume or SMB_MAX_RTT after the last
> > echo.  The worst case of the latter scenario being
> > 2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130 seconds).
> > Statistically speaking it would normally reconnect sooner.  However in the best
> > case where the user changes nics, and immediately tries to access the cifs
> > share it will take SMB_MAX_RTT=10 seconds.
> 
> I think it would be better to detect the broken connection
> by using an AF_NETLINK socket listening for RTM_DELADDR
> messages?
> 
> metze
> 

Ick -- that sounds horrid ;)

Dave, this problem sounds very similar to the one that your colleague
Chris J Arges was trying to solve several months ago. You may want to
go back and review that thread. Perhaps you can solve both problems at
the same time here...

-- 
Jeff Layton <jlayton@samba.org>
