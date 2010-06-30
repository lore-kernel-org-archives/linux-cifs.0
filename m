From: Steve French <smfrench@gmail.com>
Subject: Re: Linux CIFS NTLMSSP mount failing against win2k8
Date: Wed, 30 Jun 2010 11:00:32 -0500
Message-ID: <AANLkTilkPyeuWWgVrIGjFQh03Oz1ZiSW8zZfh1ritNLu@mail.gmail.com>
References: <20100410181730.7fa0af32@tlielax.poochiereds.net>
	<j2n4a4634331004102109k49cfb3f0gdaafcd712a972c01@mail.gmail.com>
	<1277853910.2423.5.camel@ruth>
	<20100630075530.4d5263c1@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	Andrew Bartlett <abartlet@samba.org>
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100630075530.4d5263c1@corrin.poochiereds.net>
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

On Wed, Jun 30, 2010 at 6:55 AM, Jeff Layton <jlayton@samba.org> wrote:
> On Wed, 30 Jun 2010 09:25:10 +1000
> Andrew Bartlett <abartlet@samba.org> wrote:
>
>> On Sat, 2010-04-10 at 23:09 -0500, Shirish Pargaonkar wrote:
>> > On Sat, Apr 10, 2010 at 5:17 PM, Jeff Layton <jlayton@samba.org> wrote=
:
>> > > I've been playing with NTLMSSP today in CIFS, and have run across a
>> > > problem. The Session Setup using Raw NTLMSSP succeeds, but then afte=
rward
>> > > the tree connect fails with STATUS_ACCESS_DENIED. The odd thing is t=
hat
>> > > if authenticate as the same user using krb5, then it works fine.
>> > > smbclient does SPNEGO encapsulated NTLMSSP and the tree connect it d=
oes
>> > > works fine as well.
>> > >
>> > > Attached is a capture that shows two "mount attempts". The first one
>> > > fails (that the Linux CIFS one). The second succeeds -- that's the
>> > > Linux CIFS one.
>> > >
>> > > The code I'm using is slightly modified so that the tree connect is
>> > > closer to identical to what smbclient does. That doesn't get around =
the
>> > > problem though. I assume that there must be something wrong with the
>> > > session setup, but since it succeeds it seems like it ought to work.=
..
>> > >
>> > > Does anyone have any clue as to what the problem is? Or does anyone
>> > > know how to make win2k8 tell me why it's refusing the tree connect? =
The
>> > > event viewer seems to be pretty useless for this, but maybe I'm just
>> > > not looking in the right place?
>> > >
>> > > --
>> > > Jeff Layton <jlayton@samba.org>
>> > >
>> >
>> > Jeff,
>> >
>> > You can see if this code change,
>> > =A0 cifs_MD5_update(&context, (char *)&key->data, 16);
>> > insetead of
>> > =A0cifs_MD5_update(&context, (char *)&key->data, key->len);
>> > in function cifs_calculate_signature() works.
>>
>> If I had some context, I would be able to advise if this is correct. =A0=
If
>> this is the application of the 'session key' to the SMB singing (the MD5
>> with the actual packet), then this is important, but only for Kerberos,
>> not NTLMSSP, which for all versions returns a 16 byte key.
>>
>
> (dropping old linux-cifs-client list and adding new one to cc list)
>
> Unfortunately, I haven't had time to spend on this in a while so I
> haven't really given it the time it deserves. =A0My gut feeling is that
> there are enough questionable portions of this code in CIFS that it
> really needs an overhaul from "first principles" -- starting by making
> the encryption algorithms use the standard kernel crypto libs and a
> review of what NTLMSSP flags are being set in the negotation. Some of
> that may just be my lack of familiarity with the code, but a lot of the
> unicode conversion in smbencrypt.c looks questionable.

I would like to make some simplifying assumptions, e.g.
the number of NTLMSSP flags we use.  For SMB2 it
is easier because we can limit support to only
two auth mechanisms: krb5 in spnego and ntlmv2 in ntlmssp -
and only one signing mechanism (the new SHA256 one),
but for cifs we have old servers that won't support those.

The originals for a few key pieces of the old came from Samba,
so it probably had some of the same problems with Unicode
that you noted.  Converting the RC4-MD5-HMAC to kernel crypto libs is harde=
r
than it seems.  Shirish had some trouble with the kernel crypto (as did I a
few years ago when I tried it - the code got uglier/bigger using those
interfaces).

The documentation for this is harder than it seems to wade through
(due to lack of examples).

--=20
Thanks,

Steve
