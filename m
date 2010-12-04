From: "Christopher R. Hertel" <crh@samba.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 04 Dec 2010 13:49:18 -0600
Message-ID: <4CFA9B3E.8050603@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<4CF9BB65.2010307@samba.org>
	<20101204062837.55cb13a2@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101204062837.55cb13a2@tlielax.poochiereds.net>
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

Jeff Layton wrote:
> On Fri, 03 Dec 2010 21:54:13 -0600
> "Christopher R. Hertel" <crh@samba.org> wrote:
> 
>> Jeff Layton wrote:
>> :
>> :
>>> Timeouts:
>>> =========
>>> It's tempting to think of SMB as being very similar to NFS/RPC, but
>>> when it comes to low-level transport, there are significant
>>> differences. ONC-RPC was designed for connectionless transports and has
>>> the concept of a retransmission. SMB however does not -- it was
>>> originally layered on NetBIOS sessions and so has always been assumed
>>> to run on a connection-based transport.
>> ...with the exception of the Direct Hosted IPX transport.  IPX is
>> connectionless.  In order to accommodate this connectionless transport, SMB
>> was actually modified (slightly).
>>
>> That may seem to be in the "who cares" category, since those old transports
>> are essentially dead (much more dead than NBT, or even NBF).  Unfortunately,
>> the code to handle the old transports is still there in Windows, so there
>> are behaviors -- things like the timeouts you're talking about and the weird
>> VC=0 shutdown behvior -- that exist because of these old disused transports.
>>
>> Ugh.  Eh?
>>
> 
> Yeah, Direct Hosted IPX is a lot more like NFS/RPC. MS essentially
> shoehorned in a way to do request retransmissions. It's a pretty
> impressive kludge! I suppose we could theorize that that legacy is why
> Windows times out individual requests so aggressively, but maybe there
> are other design concerns behind that behavior.

I've seen the source code.  [Aiigh!  Bleach the eyes!]

I think that this is the primary reason for the timeout, but yeah... there
are other factors that are likely involved.

> In this case however it really is a "don't care" for us in Linux CIFS
> land since we have never implemented it on top of IPX or any other
> non-connected transport and have no plans to do so.

Yep!  I agree with Volker's vote that this is a case in which third-party
implementations should do "the right thing" rather than "what Windows does".

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
