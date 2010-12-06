From: "Christopher R. Hertel" <crh@samba.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 06 Dec 2010 11:01:12 -0600
Message-ID: <4CFD16D8.4090207@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<E1POnFL-00BKfp-6h@intern.SerNet.DE>	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>	<20101205210634.602b076b@corrin.poochiereds.net>	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>
	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, Volker.Lendecke@sernet.de,
	cifs-protocol@samba.org, samba-technical@lists.samba.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
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

Steve,

I've done a lot of consulting work for companies that create this sort of
proxy.  Companies like Peribit (now part of Juniper), FineGround (now part
of Cisco), and Certeon (now part of history, I think).

You are correct.  A WAN accelerator that does proxy caching might very well
respond to an SMB Echo and various meta-data requests without actually
sending those requests to the "real" server.  If the link is down, or if the
real server is down, the proxy may still respond to some SMB messages.

To some extent, that is a problem inherent in the use of WAN accleration
systems.

Question (for which I do not have an answer):  How much work do you want to
do to make their intentionally broken model work?

WAN accelerators are actually cool technology.  I like them, but I also know
(and most of the companies that make them know) that there are inherent
problems when proxying SMB servers.

Chris -)-----

Steve French wrote:
> On Sun, Dec 5, 2010 at 10:34 PM, Volker Lendecke
> <Volker.Lendecke@sernet.de> wrote:
>> Hi!
>>
>> On Sun, Dec 05, 2010 at 08:16:46PM -0600, Steve French wrote:
>>> I am more worried about firewall rule changes and similar events
>>> than about broken servers - but the idea of waiting forever on stat
>>> to a server that is never going to respond seems odd.
>> That would be a strange fw rule that allows SMBEcho but not
>> other SMB requests. I think if someone puts up such a silly
>> rule, some pain is deserved :-)
> 
> Aaah - remember the proxies that cut out "chatty" smb traffic by
> responding on behalf of remote servers in the interest of optimizing
> traffic over slow links :)
> 
> 

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
