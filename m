From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Mon, 06 Dec 2010 11:06:42 -0600
Message-ID: <4CFD1822.70703@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<E1POnFL-00BKfp-6h@intern.SerNet.DE>	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>	<20101205210634.602b076b@corrin.poochiereds.net>	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com> <1291654155.3167.6.camel@pico.li.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291654155.3167.6.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

simo wrote:
> On Mon, 2010-12-06 at 10:28 -0600, Steve French wrote:
>> On Sun, Dec 5, 2010 at 10:34 PM, Volker Lendecke
>> <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:
>>> Hi!
>>>
>>> On Sun, Dec 05, 2010 at 08:16:46PM -0600, Steve French wrote:
>>>> I am more worried about firewall rule changes and similar events
>>>> than about broken servers - but the idea of waiting forever on stat
>>>> to a server that is never going to respond seems odd.
>>> That would be a strange fw rule that allows SMBEcho but not
>>> other SMB requests. I think if someone puts up such a silly
>>> rule, some pain is deserved :-)
>> Aaah - remember the proxies that cut out "chatty" smb traffic by
>> responding on behalf of remote servers in the interest of optimizing
>> traffic over slow links :)
> 
> They better send their own smb echos to remote servers then ...

The client-end proxy node is only interested in whether or not its peer node
is up and running.  The peer node, at the server end of the link, should be
responsible for knowing when the actual server is down.

...but this goes back to my question.  How much responsibility does the
Linux CIFS client have to ensure that the connection and server are both
working properly, and how much responsibility falls to the WAN accelerator?

I think it makes sense to do a little to mitigate WAN accelerator problems,
but the CIFS client needs to be as generic as possible so that it works well
in all environments.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
