From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 04 Dec 2010 14:04:13 -0600
Message-ID: <4CFA9EBD.8090708@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<4CF9BB65.2010307@samba.org>	<E1POnFL-00BKg9-JW@intern.SerNet.DE> <20101204064452.46ac24c7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101204064452.46ac24c7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton wrote:
> On Sat, 4 Dec 2010 09:13:21 +0100
> Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:
> 
>> On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Hertel wrote:
>>> That may seem to be in the "who cares" category, since those old transports
>>> are essentially dead (much more dead than NBT, or even NBF).  Unfortunately,
>>> the code to handle the old transports is still there in Windows, so there
>>> are behaviors -- things like the timeouts you're talking about and the weird
>>> VC=0 shutdown behvior -- that exist because of these old disused transports.
>> VC=0, how does Windows treat this facing NAT (masquerading)
>> networks? I've done tests in the past where Windows killed
>> valid connections from behind a NAT box when a new client
>> came in.
>>
>> Volker
> 
> It seems like the best way to deal with this on the server side with
> direct hosted TCP would be to treat VC=0 like any other VC number
> (MS-CIFS says that this is allowed).

The reasoning behind the VC=0 behavior does not apply to any contemporary
transport, so there is no reason to enforce that behavior.

> Ideally any new connection event from a host however should make the
> server check the validity of any other connection from the same host.
> That way you could release resources held by dead connections in case
> the new one is a reconnect and needs to reclaim state.

That's overkill, I think.  The transport, as you mention below, will take
care of dropped connections in due time.

> The question is how to check that validity. Unfortunately, the best you
> can probably do is rely on TCP keepalives.

...and that's probably the best you want to do.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
