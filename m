From: Andrew Bartlett <abartlet@samba.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
	available
Date: Thu, 08 Sep 2011 07:42:46 +1000
Message-ID: <1315431768.22110.4.camel@obed>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
	<1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
	<20110906121017.7ce0018b@tlielax.poochiereds.net>
	<4E673D6F.90606@ts.fujitsu.com>
	<20110907090321.2196de8f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, Martin Wilck <mwilck@arcor.de>
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20110907090321.2196de8f@tlielax.poochiereds.net>
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

On Wed, 2011-09-07 at 09:03 -0400, Jeff Layton wrote:
> On Wed, 07 Sep 2011 11:46:23 +0200
> Martin Wilck <martin.wilck@ts.fujitsu.com> wrote:
> 
> > Hi Jeff,
> > 
> > thanks for reviewing this.
> > 
> > > I'm not opposed to adding this with appropriate warnings about the
> > > danger involved.
> > > 
> > > Trusting the SPN provided in the NEGOTIATE response waters down much of
> > > the security that Kerberos provides. Granted, cifs doesn't currently do
> > > mutual auth, but if it did, using this would make it pretty useless.
> > 
> > Please help me understand - is this functionality any different from
> > smbclient's? If yes, what do I need to change? If no, smbclient users
> > will suffer from the same security risk (I see that a mounted file
> > system is a higher risk than a process like smbclient).
> > 
> > Is there any way to do this more securely?
> > 
> > > It would probably be a good idea to clearly warn that an attacker can
> > > use this in order to trick the client into mounting a server of his
> > > choosing (providing he can redirect the traffic to that server too).
> > 
> > I'm will happily add a warning if you tell me where you'd like to have
> > it - in the man page, or in the kernel logs, or in the cifs.upcall log?
> > 
> > Regards
> > Martin
> > 
> 
> (re-cc'ing linux-cifs and cc'ing samba-technical)
> 
> We've discussed this on the list many times before, but the most
> comprehensive discussion is here. I recommend reading over that as it
> explains the problems in detail:
> 
>     http://lists.samba.org/archive/linux-cifs-client/2008-August/003348.html
> 
> Really, the best answer is not to rely on this. Windows clients never
> have, and recent windows servers don't even populate the field.
> 
> smbclient does, but support for that was added long ago. It should
> probably be removed as Andrew suggested in the above thread, or
> perhaps made conditional on a new smb.conf option that defaults to
> being off.

Samba 3.5 (latest release) and Samba 3.6 now default to the
server-provided SPN being untrusted and unused.  Samba 3.6 also does not
send it by default.  No new software should start using this principal,
and now all modern servers will not send it.

Please do not introduce this security hole into new software.  The only
reason that Samba continues to have optional support for this at all is
in deference to possible legacy users. 

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
