From: "Christopher R. Hertel" <crh@samba.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 04 Dec 2010 13:46:39 -0600
Message-ID: <4CFA9A9F.1080208@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org> <E1POnFL-00BKg9-JW@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Volker.Lendecke@SerNet.DE
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <E1POnFL-00BKg9-JW@intern.SerNet.DE>
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

Volker Lendecke wrote:
> On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Hertel wrote:
>> That may seem to be in the "who cares" category, since those old transports
>> are essentially dead (much more dead than NBT, or even NBF).  Unfortunately,
>> the code to handle the old transports is still there in Windows, so there
>> are behaviors -- things like the timeouts you're talking about and the weird
>> VC=0 shutdown behvior -- that exist because of these old disused transports.
> 
> VC=0, how does Windows treat this facing NAT (masquerading)
> networks? I've done tests in the past where Windows killed
> valid connections from behind a NAT box when a new client
> came in.

I put a lot of info into [MS-CIFS] about how *and why* this works the way it
does.  See [MS-CIFS] 2.1.3.  Unfortunately, since [MS-CIFS] applies only to
W98, NT4, and earlier it doesn't tell you much about W2K and newer
implementations.  There's a KB article that talks about the problem a
little:  KB301673.

I thought that there was a registry setting that would allow you to tell the
Windows server NOT to close existing connections if it received a VC=0 from
the same IP.  Even when working with Microsoft I wasn't able to find
anything like that, beyond what's in that KB article.

Basically, they should give up on the VC=0 thing, since it's a throw-back to
the days when OS/2 could run SMB over connectionless IPX transport over
multiple modems in parallel.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
