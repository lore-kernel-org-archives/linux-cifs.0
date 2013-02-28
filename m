From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Thu, 28 Feb 2013 13:01:20 +0000
Message-ID: <614F550557B82C44AC27C492ADA391AA045A5B27@TK5EX14MBXC284.redmond.corp.microsoft.com>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net>
	<512EA1B5.5010801@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, Dave Chiluk <chiluk@canonical.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: "Stefan (metze) Metzmacher" <metze@samba.org>, Jeff Layton
	<jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <512EA1B5.5010801@samba.org>
Content-Language: en-US
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

> -----Original Message-----
> From: samba-technical-bounces@lists.samba.org [mailto:samba-technical-
> bounces@lists.samba.org] On Behalf Of Stefan (metze) Metzmacher
> Sent: Wednesday, February 27, 2013 7:16 PM
> To: Jeff Layton
> Cc: Steve French; Dave Chiluk; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org; linux-cifs@vger.kernel.org
> Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nic=
s
>=20
> Am 27.02.2013 17:34, schrieb Jeff Layton:
> > On Wed, 27 Feb 2013 12:06:14 +0100
> > "Stefan (metze) Metzmacher" <metze@samba.org> wrote:
> >
> >> Hi Dave,
> >>
> >>> When messages are currently in queue awaiting a response, decrease
> >>> amount of time before attempting cifs_reconnect to SMB_MAX_RTT =3D
> 10
> >>> seconds. The current wait time before attempting to reconnect is
> >>> currently 2*SMB_ECHO_INTERVAL(120
> >>> seconds) since the last response was recieved.  This does not take
> >>> into account the fact that messages waiting for a response should be
> >>> serviced within a reasonable round trip time.
> >>
> >> Wouldn't that mean that the client will disconnect a good connection,
> >> if the server doesn't response within 10 seconds?
> >> Reads and Writes can take longer than 10 seconds...
> >>
> >
> > Where does this magic value of 10s come from? Note that a slow server
> > can take *minutes* to respond to writes that are long past the EOF.
> >
> >>> This fixes the issue where user moves from wired to wireless or vice
> >>> versa causing the mount to hang for 120 seconds, when it could
> >>> reconnect considerably faster.  After this fix it will take
> >>> SMB_MAX_RTT (10 seconds) from the last time the user attempted to
> >>> access the volume or SMB_MAX_RTT after the last echo.  The worst
> >>> case of the latter scenario being
> 2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130
> seconds).
> >>> Statistically speaking it would normally reconnect sooner.  However
> >>> in the best case where the user changes nics, and immediately tries
> >>> to access the cifs share it will take SMB_MAX_RTT=3D10 seconds.
> >>
> >> I think it would be better to detect the broken connection by using
> >> an AF_NETLINK socket listening for RTM_DELADDR messages?
> >>
> >> metze
> >>
> >
> > Ick -- that sounds horrid ;)
>=20
> This is what winbindd uses to detect that a source ip of outgoing connect=
ions
> are gone. I don't know much of the kernel, there might be a better way fr=
om
> within the kernel to detect this. But this is exactly the correct thing t=
o do to
> failover to another interface, as it just happens when the ip is removed
> without messing with a timeout value.
>=20
> Another optimization would be to use tcp keepalives (I think there 10
> seconds would be ok), I think that's what Windows SMB3 clients are using.

Yes, they do. See MS-SMB2 behavior note 144 attached to section 3.2.5.14.9.

10 seconds seems a fairly rapid keepalive interval. The TCP stack probably
won't allow it to be less than the maximum retransmit, for instance.

Tom.
