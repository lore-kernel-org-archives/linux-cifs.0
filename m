From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH] cifs: stop trying to use virtual circuits
Date: Wed, 18 Sep 2013 07:42:09 -0700
Message-ID: <E1VMJ0n-001ZxR-I8@intern.SerNet.DE>
References: <1379345025-10868-1-git-send-email-jlayton@redhat.com>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: sauron99@gmx.de, smfrench@gmail.com, samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Date: Wed, 18 Sep 2013 07:42:09 -0700
Content-Disposition: inline
In-Reply-To: <1379345025-10868-1-git-send-email-jlayton@redhat.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Sep 16, 2013 at 11:23:45AM -0400, Jeff Layton wrote:
> Currently, we try to ensure that we use vcnum of 0 on the first
> established session on a connection and then try to use a different
> vcnum on each session after that.
>=20
> This is a little odd, since there's no real reason to use a different
> vcnum for each SMB session. I can only assume there was some confusion
> between SMB sessions and VCs. That's somewhat understandable since they
> both get created during SESSION_SETUP, but the documentation indicates
> that they are really orthogonal. The comment on max_vcs in particular
> looks quite misguided. An SMB session is already uniquely identified
> by the SMB UID value -- there's no need to again uniquely ID with a
> VC.
>=20
> Furthermore, a vcnum of 0 is a cue to the server that it should release
> any resources that were previously held by the client. This sounds like
> a good thing, until you consider that:
>=20
> a) it totally ignores the fact that other programs on the box (e.g.
> smbclient) might have connections established to the server. Using a
> vcnum of 0 causes them to get kicked off.
>=20
> b) it causes problems with NAT. If several clients are connected to the
> same server via the same NAT'ed address, whenever one connects to the
> server it kicks off all the others, which then reconnect and kick off
> the first one...ad nauseum.
>=20
> I don't see any reason to ignore the advice in "Implementing CIFS" whic=
h
> has a comprehensive treatment of virtual circuits. In there, it states
> "...and contrary to the specs the client should always use a VcNumber o=
f
> one, never zero."
>=20
> Have the client just use a hardcoded vcnum of 1, and stop abusing the
> special behavior of vcnum 0.

It's kindof a tough choice, but I like this patch. It does
solve real problems. The downside certainly is that we have
worse cleanup behaviour of dead connections, but I would
prefer not killing NATed connections.

Volker

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
