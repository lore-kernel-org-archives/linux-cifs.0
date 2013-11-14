From: Jeremy Allison <jra@samba.org>
Subject: Re: Samba POSIX ACL behavior
Date: Thu, 14 Nov 2013 10:18:58 -0800
Message-ID: <20131114181858.GC1661@samba2>
References: <CAH2r5msH8qTago4G=-_PpAzPJaOxwPeRVL3E8qfowjqwiSo5LA@mail.gmail.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msH8qTago4G=-_PpAzPJaOxwPeRVL3E8qfowjqwiSo5LA@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Nov 14, 2013 at 12:13:35PM -0600, Steve French wrote:
> > I recently encountered the following strange behavior as mentioned in
> > this post from several years ago:
> >
> > https://lists.samba.org/archive/linux-cifs-client/2009-February/00407=
9.html
> >
> > I'm currently running Ubuntu 12.04 LTS on desktop and server, so
> > I took some time to try the latest packaged versions of Samba and
> > the kernel to make sure that the issue had not yet been fixed.
> >
> > Client:=A0 Ubuntu 12.04 LTS with Kernel 3.11.0-13-generic
> > Server:=A0 Ubuntu 12.04 LTS with Samba 3.6.20 and Kernel 3.5.0-43-gen=
eric
> >
> > I tried many other combinations and the behavior is the same.=A0 It
> > looks like setting default ACLs somehow interacts with the
> > non-default ACLs and vice versa.
>=20
> I tried this here to Samba 3.6 with slightly different results:
> 1) If I set both a default and non-default ACL that seems to work
> 2) but as you and Rob saw, if I setfacl a default ACL it removes the no=
n-
> default ACL
> 3) and if I setfacl a non-default ACL it removes the default ACL
>=20
> So for case 2 and 3 the behavior is different than for a local file sys=
tem.=A0
> This may be a server bug.

Can you send me a wireshark trace ?

> For Samba 4 and Samba 4.2-pre (master) - I get an error not supported o=
n this
> infolevel 512 (Set POSIX ACL).

You're running the wrong server :-). You need smbd running, not the sourc=
e4
server.

Jeremy.
