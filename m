From: Steve French <smfrench@gmail.com>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Mon, 6 Dec 2010 11:17:53 -0600
Message-ID: <AANLkTi=1q+0yt6redPdAevHoJrAzqxvxCA8YGCAFRRwq@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>
	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
	<1291654155.3167.6.camel@pico.li.ssimo.org>
	<4CFD1822.70703@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	Volker.Lendecke@sernet.de, simo <idra@samba.org>,
	samba-technical@lists.samba.org
To: "Christopher R. Hertel" <crh@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <4CFD1822.70703@samba.org>
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

On Mon, Dec 6, 2010 at 11:06 AM, Christopher R. Hertel <crh@samba.org> wrot=
e:
> simo wrote:
>> On Mon, 2010-12-06 at 10:28 -0600, Steve French wrote:
>>> On Sun, Dec 5, 2010 at 10:34 PM, Volker Lendecke
>>> <Volker.Lendecke@sernet.de> wrote:
>>>> Hi!
>>>>
>>>> On Sun, Dec 05, 2010 at 08:16:46PM -0600, Steve French wrote:
>>>>> I am more worried about firewall rule changes and similar events
>>>>> than about broken servers - but the idea of waiting forever on stat
>>>>> to a server that is never going to respond seems odd.
>>>> That would be a strange fw rule that allows SMBEcho but not
>>>> other SMB requests. I think if someone puts up such a silly
>>>> rule, some pain is deserved :-)
>>> Aaah - remember the proxies that cut out "chatty" smb traffic by
>>> responding on behalf of remote servers in the interest of optimizing
>>> traffic over slow links :)
>>
>> They better send their own smb echos to remote servers then ...
>
> The client-end proxy node is only interested in whether or not its peer n=
ode
> is up and running. =A0The peer node, at the server end of the link, shoul=
d be
> responsible for knowing when the actual server is down.
>
> ...but this goes back to my question. =A0How much responsibility does the
> Linux CIFS client have to ensure that the connection and server are both
> working properly, and how much responsibility falls to the WAN accelerato=
r?
>
> I think it makes sense to do a little to mitigate WAN accelerator problem=
s,
> but the CIFS client needs to be as generic as possible so that it works w=
ell
> in all environments.

That is a good broad "design goal"
Obviously using smb echo will help.  In the smb2 code, I issued an smb2
at mount time to do a rough estimate of link speed, but with both cifs and
smb2 code we need to be issuing an echo (at least) when the server is
unresponsive, but we may find that the action to take soft/hard, retry forv=
er
vs. giveup after one or two cancel/retry takes some experimentation to
get right.



--=20
Thanks,

Steve
