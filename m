From: "Christopher R. Hertel" <crh@samba.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 06 Dec 2010 14:38:37 -0600
Message-ID: <4CFD49CD.5010002@samba.org>
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
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, cifs-protocol@samba.org,
	samba-technical@lists.samba.org,
	Jeff Layton <jlayton@redhat.com>, linux-cifs@vger.kernel.org
To: Volker.Lendecke@SerNet.DE
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <E1PPhWb-00EZX7-6F@intern.SerNet.DE>
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
> On Mon, Dec 06, 2010 at 12:54:30PM -0600, Christopher R. Hertel wrote:
>> There are a lot of companies out there that do WAN acceleration and each of
>> them do things differently, so there is no good answer to your quite
>> rational question.  Some of the vendors are very focused on "just like the
>> real thing" behavior while others are willing to compromise behavior in
>> favor of acceleration.
>>
>> The best-known product in this market would be Riverbed.  BlueCoat is
>> another, I think.
> 
> Sorry, but if a WAN accelerator does not have the smarts to
> see that if a client sends smbechos, it is in trouble, then
> that WAN accelerator is just broken. It does not necessarily
> need to send these echos across the WAN link, but it must
> trigger its own server liveliness check at this point.

I agree.

That's why these companies hire me, though.  They have *no clue* when it
comes to CIFS and they run into brick walls at full speed.

When it comes down to it, though, anyone with smarts and half a clue would
avoid SMB/CIFS if at all possible.  Most of what we do with Samba and the
CIFS client is mitigate stupidity.  :)

...and we're good at it too!

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
