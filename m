From: Jeff Layton <jlayton@samba.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
	available
Date: Wed, 7 Sep 2011 09:03:21 -0400
Message-ID: <20110907090321.2196de8f@tlielax.poochiereds.net>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
	<1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
	<20110906121017.7ce0018b@tlielax.poochiereds.net>
	<4E673D6F.90606@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	Martin Wilck <mwilck@arcor.de>
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <4E673D6F.90606@ts.fujitsu.com>
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

On Wed, 07 Sep 2011 11:46:23 +0200
Martin Wilck <martin.wilck@ts.fujitsu.com> wrote:

> Hi Jeff,
> 
> thanks for reviewing this.
> 
> > I'm not opposed to adding this with appropriate warnings about the
> > danger involved.
> > 
> > Trusting the SPN provided in the NEGOTIATE response waters down much of
> > the security that Kerberos provides. Granted, cifs doesn't currently do
> > mutual auth, but if it did, using this would make it pretty useless.
> 
> Please help me understand - is this functionality any different from
> smbclient's? If yes, what do I need to change? If no, smbclient users
> will suffer from the same security risk (I see that a mounted file
> system is a higher risk than a process like smbclient).
> 
> Is there any way to do this more securely?
> 
> > It would probably be a good idea to clearly warn that an attacker can
> > use this in order to trick the client into mounting a server of his
> > choosing (providing he can redirect the traffic to that server too).
> 
> I'm will happily add a warning if you tell me where you'd like to have
> it - in the man page, or in the kernel logs, or in the cifs.upcall log?
> 
> Regards
> Martin
> 

(re-cc'ing linux-cifs and cc'ing samba-technical)

We've discussed this on the list many times before, but the most
comprehensive discussion is here. I recommend reading over that as it
explains the problems in detail:

    http://lists.samba.org/archive/linux-cifs-client/2008-August/003348.html

Really, the best answer is not to rely on this. Windows clients never
have, and recent windows servers don't even populate the field.

smbclient does, but support for that was added long ago. It should
probably be removed as Andrew suggested in the above thread, or
perhaps made conditional on a new smb.conf option that defaults to
being off.

-- 
Jeff Layton <jlayton@samba.org>
