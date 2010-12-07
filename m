From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Tue, 07 Dec 2010 14:53:04 -0600
Message-ID: <4CFE9EB0.8010309@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<E1POnFL-00BKfp-6h@intern.SerNet.DE>	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>	<20101205210634.602b076b@corrin.poochiereds.net>	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>	<4CFD16D8.4090207@samba.org>	<20101206124255.7ea8a8a9@tlielax.poochiereds.net>	<4CFD3166.4000800@samba.org> <E1PPhWb-00EZX7-6F@intern.SerNet.DE> <673E6032983AF84185CE49D109B4F40A526665@TK5EX14MBXC103.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org" <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Matt Ficken (Insight Global)" <v-mafick-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <673E6032983AF84185CE49D109B4F40A526665-Jfd81uAzPQsTaQvdokkCPVir+X/St4rqwBk/1ggFUS45P9zcU8sUGwC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Matt Ficken (Insight Global) wrote:
> If the connection from the WAN Accelerator to the origin SMB server is down (ie the origin SMB server is down), shouldn't the WAN Accelerator realize that, and then not be responding to SMB echoes (at least responding as though it was the origin SMB server)?

In theory, theory and practice are the same.  In practice they're not.

In other words, "should do" and "does do" are two very different things.  :)

...but I agree with Volker and Jeremy and others.  It's not our[1] job to
fix these things unless the fix is generally beneficial to the implementation.

Chris -)-----
[1]Where "our" refers to SMB/CIFS implementers in general.

> -----Original Message-----
> From: samba-technical-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org [mailto:samba-technical-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org] On Behalf Of Volker Lendecke
> Sent: Monday, December 06, 2010 12:17 PM
> To: Christopher R. Hertel
> Cc: Steve French; cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; Jeff Layton; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: cifs client timeouts and hard/soft mounts
> 
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
> 
> Volker
> 

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
