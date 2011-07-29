From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: encryption on network
Date: Thu, 28 Jul 2011 20:23:05 -0500
Message-ID: <CAH2r5muVFuCNwyAKK+O1s8M2LT5qCFYvYJ5XnxiqhqEDgW_NWQ@mail.gmail.com>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
	<4E31E9DD.2060604@ubiqx.mn.org>
	<20110728235410.GA4976@jeremy-laptop>
	<4E31F9E4.2030004@ubiqx.mn.org>
	<20110729001133.GA6742@jeremy-laptop>
	<4E31FE48.7060606@ubiqx.mn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dominic Dougherty <dominic.dougherty-cDnhz4gMPjZOSnsfY10OVw@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christopher R. Hertel" <crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E31FE48.7060606-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jul 28, 2011 at 7:26 PM, Christopher R. Hertel <crh-jFlgvBokg3kpug/h7KTFAQ@public.gmane.org=
g> wrote:
> Jeremy Allison wrote:
> :
>>> Right, but the question particularly listed WinXP as one of the
>>> participating clients. =A0Windows clients don't support the Unix ex=
tensions,
>>> so they don't support encrypted SMB and that kinda ruins the whole =
thing,
>>> eh? =A0[sad face]
>>
>> Yes I realize that. But that's not what you said. You said:
>> "The SMB protocol does not provide any mechanism for encrypting traf=
fic
>> between clients and servers." - but that's not generically true,
>> only between *Microsoft* clients and servers.
>
> Well... technically the SMB protocol (as it exists today) is defined =
by the
> Microsoft specifications, and they don't include any support for encr=
yption.
>
> There is, unfortunately, no "official" specification of the Unix exte=
nsions
> for SMB (only an old draft that doesn't include encryption, IIRC). =A0=
Also, as
> their name suggests, they're extensions to the protocol which means t=
hat
> they're not part of the protocol itself.
>
>> You made it sound like that was definitive, and you are the
>> acknowledged authority on CIFS/SMB, so I couldn't let that
>> stand. People link to your posts here :-).
>
> Absolutely right to set the record straight. =A0I should have added t=
he caveat
> that the Unix extensions include support for encryption.
>
>>> Please allow me to join the choir on that. =A0(I'll sit at the back=
 and not
>>> get in anyone's way.) =A0[winky face]
>>
>> Maybe if we all wish REALLY HARD, Steve and Jeff will hear
>> us.. :-).
>
> Don't forget to click your heels together and burn the tana leaves wh=
en the
> moon is full over Vermont. =A0;)

I haven't forgotten ... just queued up behind reviewing ~10 other patch=
es.


--=20
Thanks,

Steve
