From: Dominic Dougherty <dominic.dougherty-cDnhz4gMPjZOSnsfY10OVw@public.gmane.org>
Subject: Re: encryption on network
Date: Fri, 29 Jul 2011 04:04:51 +0000
Message-ID: <06B0D589A4AC0243AD95D4DA4978081A182DECD8@mbx024-e1-nj-6.exch024.domain.local>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
	<4E31E9DD.2060604@ubiqx.mn.org>	<20110728235410.GA4976@jeremy-laptop>
	<4E31F9E4.2030004@ubiqx.mn.org>	<20110729001133.GA6742@jeremy-laptop>
	<4E31FE48.7060606@ubiqx.mn.org>
 <CAH2r5muVFuCNwyAKK+O1s8M2LT5qCFYvYJ5XnxiqhqEDgW_NWQ@mail.gmail.com>
 <06B0D589A4AC0243AD95D4DA4978081A182DEC78@mbx024-e1-nj-6.exch024.domain.local>,<4E321C18.5000201@ubiqx.mn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org" <crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E321C18.5000201-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

One more option
Otfe with samba, but in this case you would need otfe on the client




-----Original Message-----
From: Christopher R. Hertel [crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org]
Received: Thursday, 28 Jul 2011, 10:34pm
To: Dominic Dougherty [dominic.dougherty-cDnhz4gMPjZOSnsfY10OVw@public.gmane.org]
CC: Steve French [smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]; Jeremy Allison [jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org]; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org [samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org]; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
Subject: Re: encryption on network



On 07/28/2011 09:11 PM, Dominic Dougherty wrote:
> Thanks guys,
>
> I know this is a interesting one and more than one way to solve it.
>
> 1.) install a vpn server which is natively support by any windows machine (PPTP or L2TP or IPSEC) on the samba server and establish a vpn connection to the samba server.

I actually prefer OpenVPN, since it runs well on so many platforms, but it's
important to go with whichever technology you are most comfortable running.

> 2.) the newer version of samba supports SSL. However, the only valid client for this is smbclient.  Not support by the "net use" command.

This, as Jeremy so rightly pointed out, is based on the Unix extensions to SMB.

I whined earlier that there is no specification for this feature, but we
spent almost twenty years without a real specification for SMB itself.  Even
now, the [MS-SMB] and [MS-CIFS] docs from Microsoft are written to reflect
Windows behavior.  That is, the spec. has to match the product, not the
other way 'round.

> 3.) use sshfs on the samba server and install putty on the local windows box and use port forwarding to connect to the samba share.
> 4.) configure ipsec on the windows network

These are really just alternative ways of setting up a VPN.

> 5.) use webdav on apache with https

That would move you away from the SMB protocol entirely.

> 6.) using stunnel and Microsoft loopback adapter encrypt traffic.

Same as 1, 3, and 4.

> I was hoping to get something working without installing anything extra on the client and which could be natively support by windows.

No such puppy.

> CIFS is supposed to support encryption, I would have to check up on that.

If you mean CIFS the Linux file system, then you are correct.  It supports
the Unix extensions to SMB and so, therefore, should support encrypted SMB
traffic.  There just hasn't been time to add that feature yet.

If you mean CIFS the alternative name for the SMB protocol, then no.  I was
lead author of Microsoft's [MS-CIFS] and [MS-SMB] specifications so I am
quite sure about this.  There's no encryption of file data in the
protocol...dangit.

Chris -)-----

> -----Original Message-----
> From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, July 28, 2011 9:23 PM
> To: Christopher R. Hertel
> Cc: Jeremy Allison; Dominic Dougherty; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: encryption on network
>
> On Thu, Jul 28, 2011 at 7:26 PM, Christopher R. Hertel<crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>  wrote:
>> Jeremy Allison wrote:
>> :
>>>> Right, but the question particularly listed WinXP as one of the
>>>> participating clients.  Windows clients don't support the Unix extensions,
>>>> so they don't support encrypted SMB and that kinda ruins the whole thing,
>>>> eh?  [sad face]
>>>
>>> Yes I realize that. But that's not what you said. You said:
>>> "The SMB protocol does not provide any mechanism for encrypting traffic
>>> between clients and servers." - but that's not generically true,
>>> only between *Microsoft* clients and servers.
>>
>> Well... technically the SMB protocol (as it exists today) is defined by the
>> Microsoft specifications, and they don't include any support for encryption.
>>
>> There is, unfortunately, no "official" specification of the Unix extensions
>> for SMB (only an old draft that doesn't include encryption, IIRC).  Also, as
>> their name suggests, they're extensions to the protocol which means that
>> they're not part of the protocol itself.
>>
>>> You made it sound like that was definitive, and you are the
>>> acknowledged authority on CIFS/SMB, so I couldn't let that
>>> stand. People link to your posts here :-).
>>
>> Absolutely right to set the record straight.  I should have added the caveat
>> that the Unix extensions include support for encryption.
>>
>>>> Please allow me to join the choir on that.  (I'll sit at the back and not
>>>> get in anyone's way.)  [winky face]
>>>
>>> Maybe if we all wish REALLY HARD, Steve and Jeff will hear
>>> us.. :-).
>>
>> Don't forget to click your heels together and burn the tana leaves when the
>> moon is full over Vermont.  ;)
>
> I haven't forgotten ... just queued up behind reviewing ~10 other patches.
>
>

--
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org
