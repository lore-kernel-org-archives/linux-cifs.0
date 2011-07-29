From: Dominic Dougherty <dominic.dougherty@protegrity.com>
Subject: RE: encryption on network
Date: Fri, 29 Jul 2011 02:11:47 +0000
Message-ID: <06B0D589A4AC0243AD95D4DA4978081A182DEC78@mbx024-e1-nj-6.exch024.domain.local>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
	<4E31E9DD.2060604@ubiqx.mn.org>	<20110728235410.GA4976@jeremy-laptop>
	<4E31F9E4.2030004@ubiqx.mn.org>	<20110729001133.GA6742@jeremy-laptop>
	<4E31FE48.7060606@ubiqx.mn.org>
	<CAH2r5muVFuCNwyAKK+O1s8M2LT5qCFYvYJ5XnxiqhqEDgW_NWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>, "Christopher R. Hertel"
	<crh@ubiqx.mn.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5muVFuCNwyAKK+O1s8M2LT5qCFYvYJ5XnxiqhqEDgW_NWQ@mail.gmail.com>
Content-Language: en-US
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

Thanks guys,

I know this is a interesting one and more than one way to solve it.=20

1.) install a vpn server which is natively support by any windows machine (=
PPTP or L2TP or IPSEC) on the samba server and establish a vpn connection t=
o the samba server.
2.) the newer version of samba supports SSL. However, the only valid client=
 for this is smbclient.  Not support by the "net use" command.
3.) use sshfs on the samba server and install putty on the local windows bo=
x and use port forwarding to connect to the samba share.
4.) configure ipsec on the windows network
5.) use webdav on apache with https
6.) using stunnel and Microsoft loopback adapter encrypt traffic.

I was hoping to get something working without installing anything extra on =
the client and which could be natively support by windows.=20

CIFS is supposed to support encryption, I would have to check up on that.=20


Dominic


-----Original Message-----
From: Steve French [mailto:smfrench@gmail.com]=20
Sent: Thursday, July 28, 2011 9:23 PM
To: Christopher R. Hertel
Cc: Jeremy Allison; Dominic Dougherty; samba-technical@lists.samba.org; lin=
ux-cifs@vger.kernel.org
Subject: Re: encryption on network

On Thu, Jul 28, 2011 at 7:26 PM, Christopher R. Hertel <crh@ubiqx.mn.org> w=
rote:
> Jeremy Allison wrote:
> :
>>> Right, but the question particularly listed WinXP as one of the
>>> participating clients. =A0Windows clients don't support the Unix extens=
ions,
>>> so they don't support encrypted SMB and that kinda ruins the whole thin=
g,
>>> eh? =A0[sad face]
>>
>> Yes I realize that. But that's not what you said. You said:
>> "The SMB protocol does not provide any mechanism for encrypting traffic
>> between clients and servers." - but that's not generically true,
>> only between *Microsoft* clients and servers.
>
> Well... technically the SMB protocol (as it exists today) is defined by t=
he
> Microsoft specifications, and they don't include any support for encrypti=
on.
>
> There is, unfortunately, no "official" specification of the Unix extensio=
ns
> for SMB (only an old draft that doesn't include encryption, IIRC). =A0Als=
o, as
> their name suggests, they're extensions to the protocol which means that
> they're not part of the protocol itself.
>
>> You made it sound like that was definitive, and you are the
>> acknowledged authority on CIFS/SMB, so I couldn't let that
>> stand. People link to your posts here :-).
>
> Absolutely right to set the record straight. =A0I should have added the c=
aveat
> that the Unix extensions include support for encryption.
>
>>> Please allow me to join the choir on that. =A0(I'll sit at the back and=
 not
>>> get in anyone's way.) =A0[winky face]
>>
>> Maybe if we all wish REALLY HARD, Steve and Jeff will hear
>> us.. :-).
>
> Don't forget to click your heels together and burn the tana leaves when t=
he
> moon is full over Vermont. =A0;)

I haven't forgotten ... just queued up behind reviewing ~10 other patches.


--=20
Thanks,

Steve
