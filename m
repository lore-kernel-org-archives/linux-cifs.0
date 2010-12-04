From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 09:13:21 +0100
Message-ID: <E1POnFL-00BKg9-JW@intern.SerNet.DE>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: "Christopher R. Hertel" <crh@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Date: Sat, 4 Dec 2010 09:13:21 +0100
Content-Disposition: inline
In-Reply-To: <4CF9BB65.2010307@samba.org>
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

On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Hertel wrote:
> That may seem to be in the "who cares" category, since those old transports
> are essentially dead (much more dead than NBT, or even NBF).  Unfortunately,
> the code to handle the old transports is still there in Windows, so there
> are behaviors -- things like the timeouts you're talking about and the weird
> VC=0 shutdown behvior -- that exist because of these old disused transports.

VC=0, how does Windows treat this facing NAT (masquerading)
networks? I've done tests in the past where Windows killed
valid connections from behind a NAT box when a new client
came in.

Volker
