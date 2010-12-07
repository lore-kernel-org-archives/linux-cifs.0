From: "Matt Ficken (Insight Global)" <v-mafick@microsoft.com>
Subject: RE: cifs client timeouts and hard/soft mounts
Date: Tue, 7 Dec 2010 20:34:26 +0000
Message-ID: <673E6032983AF84185CE49D109B4F40A526665@TK5EX14MBXC103.redmond.corp.microsoft.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>
	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
	<4CFD16D8.4090207@samba.org>
	<20101206124255.7ea8a8a9@tlielax.poochiereds.net>
	<4CFD3166.4000800@samba.org> <E1PPhWb-00EZX7-6F@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <smfrench@gmail.com>,
	"cifs-protocol@samba.org" <cifs-protocol@samba.org>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	Jeff Layton <jlayton@redhat.com>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: "Volker.Lendecke@SerNet.DE" <Volker.Lendecke@SerNet.DE>, "Christopher R.
	Hertel" <crh@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <E1PPhWb-00EZX7-6F@intern.SerNet.DE>
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

If the connection from the WAN Accelerator to the origin SMB server is down=
 (ie the origin SMB server is down), shouldn't the WAN Accelerator realize =
that, and then not be responding to SMB echoes (at least responding as thou=
gh it was the origin SMB server)?

-----Original Message-----
From: samba-technical-bounces@lists.samba.org [mailto:samba-technical-bounc=
es@lists.samba.org] On Behalf Of Volker Lendecke
Sent: Monday, December 06, 2010 12:17 PM
To: Christopher R. Hertel
Cc: Steve French; cifs-protocol@samba.org; samba-technical@lists.samba.org;=
 Jeff Layton; linux-cifs@vger.kernel.org
Subject: Re: cifs client timeouts and hard/soft mounts

On Mon, Dec 06, 2010 at 12:54:30PM -0600, Christopher R. Hertel wrote:
> There are a lot of companies out there that do WAN acceleration and each =
of
> them do things differently, so there is no good answer to your quite
> rational question.  Some of the vendors are very focused on "just like th=
e
> real thing" behavior while others are willing to compromise behavior in
> favor of acceleration.
>=20
> The best-known product in this market would be Riverbed.  BlueCoat is
> another, I think.

Sorry, but if a WAN accelerator does not have the smarts to
see that if a client sends smbechos, it is in trouble, then
that WAN accelerator is just broken. It does not necessarily
need to send these echos across the WAN link, but it must
trigger its own server liveliness check at this point.

Volker
