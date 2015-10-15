From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: Channel Sequence handling - was RE: [PATCH] [SMB3] Send durable
 handle v2 contexts when use of persistent handles required
Date: Thu, 15 Oct 2015 13:25:06 +0000
Message-ID: <BN3PR03MB15109A4408412CE39C8540CFA03E0@BN3PR03MB1510.namprd03.prod.outlook.com>
References: <BN3PR03MB15107EF8D31A9F3B463FD753A0480@BN3PR03MB1510.namprd03.prod.outlook.com>
 <CAH2r5msW2+Mbui=jR3r2TaFspEUJFvLZYSQ5AXwGZ7qK2N5fkA@mail.gmail.com>
 <20151015111520.GA5143@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
To: Michael Adam <obnox@samba.org>, Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20151015111520.GA5143@samba.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: Michael Adam [mailto:obnox@samba.org]
> Sent: Thursday, October 15, 2015 7:15 AM
> To: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <ttalpey@microsoft.com>; linux-cifs <linux-
> cifs@vger.kernel.org>; samba-technical <samba-technical@lists.samba.org>
> Subject: Re: Channel Sequence handling - was RE: [PATCH] [SMB3] Send
> durable handle v2 contexts when use of persistent handles required
>=20
> On 2015-10-05 at 14:50 -0500, Steve French wrote:
> > On Mon, Oct 5, 2015 at 9:44 AM, Tom Talpey <ttalpey@microsoft.com>
> wrote:
> > >> -----Original Message-----
> > >> From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> > >> owner@vger.kernel.org] On Behalf Of Steve French
> > >> Sent: Saturday, October 3, 2015 10:03 PM
> > >> ...
> > >> I don't know if channel sequence number in the SMB3 request would
> also
> > >> need to be incremented on disconnect though (the documentation is
> > >> confusing on that in MS-SMB2) in the case where we only have one
> > >> channel.
> > >
> > > There's nothing special about replay on one channel, after any discon=
nect
> you should increment the channel sequence so the server's replay detectio=
n
> can work properly.
> > >
> > > Can you point me to the MS-SMB2 text that you find confusing? We can
> address it.
> >
> >
> > (the doc text in 3.2.4.1 and 3.2.7.1 of MS-SMB2 seems to
> > conflict)
> >
> > On disconnect "If Connection.Dialect belongs to the SMB 3.x dialect
> > family, and if the Session has more than one channel in
> > Session.ChannelList, the client MUST perform the following actions:
> >
> > "Session.ChannelSequence MUST be incremented by 1."
> >
> > but 3.2.4.1 indicates that it is not just for multichannel but also
> > for PersistentHandle that it must be incremented (see below)
> >
> > "If Connection.Dialect belongs to the SMB 3.x dialect family and if
> > Connection.SupportsMultiChannel or
> > Connection.SupportsPersistentHandles is TRUE, the
> > client MUST set ChannelSequence in the SMB2 header to
> Session.ChannelSequence."
>=20
> I don't see a contradiction / conflict here:
>=20
> - 3.2.7.1 tells when to bump the seqnum.
> - 3.2.4.1 tells when to send it to the server
>   (this makes no statement about the value)

Correct. These are two distinct requirements.

> So the document seems to indicate this:
>=20
> Bumping the channel sequence number is only done
> by the Windows client upon connection loss on a
> multi-channel session (i.e. a real one, with
> more than one channel) and not for a single channel
> session (also not on a formerly multi-channel
> session, when the last channel goes down).

The document indicates this, but the text is incomplete. Channel sequence m=
anagement is not limited to this case. We're looking into this (section 3.2=
.7.1) and I hope to clarify it soon. There are some improvements in flight.

>=20
> A new smbtorture test case that I am currently reviewing
> indicates that the windows server is OK with this
> client behaviour (i.e. not bumping when the last
> channel of a session goes down).

Not sure what you mean by "server is OK with this". The server uses the cha=
nnel sequence number to detect whether the client experienced a disconnect.=
 Remember, the connection can break on one side before the other. If the se=
quence doesn't change, there is no end-to-end detection, so it becomes a pr=
obabilistic issue whether the orphaned operations replay properly. With pro=
per channel sequence management, this behavior is guaranteed.

Bottom line, bump the channel sequence on any disconnect when the server in=
dicated it inspects the field, i.e. has set SMB2_GLOBAL_CAP_MULTI_CHANNEL a=
nd/or SMB2_GLOBAL_CAP_PERSISTENT_HANDLES at negotiate time.

Tom.
