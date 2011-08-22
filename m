From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] mount.cifs with "sec=ntlmv2" fails ("mount error(22):
 Invalid argument")
Date: Mon, 22 Aug 2011 12:33:51 -0500
Message-ID: <CADT32eKhcCtNhi2Vd0xwnDR2ZrhMGbX2u-DE3Z3r5awwmd4dTw@mail.gmail.com>
References: <4E527F5C.1090205@pre-sense.de>
	<CADT32eKLjbuUjY1=PS9Pqa5zWnHNcCcouzPHmTo3s+QO-9iQ4A@mail.gmail.com>
	<4E528B56.5070301@pre-sense.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?ISO-8859-1?Q?Till_D=F6rges?= <doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E528B56.5070301-/hMagybUd5GoYr4blSSd5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 22, 2011 at 12:01 PM, Till D=F6rges <doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org> =
wrote:
> Hello,
>
> On 22.08.2011 18:28, Shirish Pargaonkar wrote:
>> On Mon, Aug 22, 2011 at 11:10 AM, Till D=F6rges <doerges@pre-sense.d=
e> wrote:
>>
>>> Hello, everyone,
>>>
>>> I'm trying to mount a CIFS share served by Samba using mount.cifs w=
ith NTLMv2
>>> authentication.
>>>
>>>
>>> According to 'man mount.cifs' the option "sec=3Dntlmv2" should be s=
upported, but it
>>> keeps giving me "mount error(22): Invalid argument".
>>>
>>> The Samba server enforces the use of NTLMv2. When allowing for NTLM=
v1 on both sides
>>> everything works just fine.
>>>
>>>
>>> The client runs kernel 2.6.37.6-0.7-desktop (fully patched openSUSE=
-11.4) with the
>>> CIFS kernel module version 1.68. mount.cifs identifies as "version:=
 4.6".
>>>
>>>
>>> Mounting on the client side it looks like this:
>>>
>>> --- snip ---
>>> # =A0mount.cifs //abctest.box/abclaufwerk /mnt/mnt/ --verbose -o
>>> domain=3DABCTEST,user=3Dabc,pass=3Dsecrect,sec=3Dntlmv2
>>>
>>> mount.cifs kernel mount options:
>>> ip=3D10.9.0.103,unc=3D\\abctest.box\abclaufwerk,sec=3Dntlmv2,ver=3D=
1,user=3Dabc,domain=3DABCTEST,pass=3D********
>>> mount error(22): Invalid argument
>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>> --- snap ---
>>>
>>> CIFS debugging on the client is enabled:
>>>
>>> --- snip ---
>>> # =A0cat /proc/fs/cifs/cifsFYI
>>> 1
>>> --- snap ---
>>>
>>> Which yields the following lines in syslog (for the full log see at=
tachment)
>>>
>>> --- snip ---
>>> Aug 22 17:47:34 client kernel: [28966.056081]
>>> /usr/src/packages/BUILD/kernel-desktop-2.6.37.6/linux-2.6.37/fs/cif=
s/connect.c:
>>> Security Mode: 0x3 Capabilities: 0x80f3fd TimeAdjust: -7200
>>> Aug 22 17:47:34 client kernel: [28966.056088]
>>> /usr/src/packages/BUILD/kernel-desktop-2.6.37.6/linux-2.6.37/fs/cif=
s/sess.c: sess
>>> setup type 2
>>> --- snap ---
>>>
>>> "sess setup type 2" seems to indicate that NTLMv2 is used.
>>>
>>>
>>> The server is running a fully patched openSUSE 11.3 with kernel 2.6=
=2E34.8-0.2-default
>>> and Samba 3.5.4. Both "lanman auth" and "ntlm auth" are disabled, w=
hich should force
>>> the use of NTLMv2 according to 'man smb.conf':
>>>
>>> --- snip ---
>>> server # testparm 2> /dev/null | egrep 'ntlm|lan'
>>> =A0 =A0 =A0 =A0ntlm auth =3D No
>>> server #
>>> --- snap ---
>>>
>>> The server's corresponding log entries are also attached.
>>>
>>>
>>> Like said above, when I allow for the use of NTLMv1 on both sides (=
ntlm auth =3D Yes on
>>> the server and no sec=3Dntlmv2 on the client) everything works just=
 fine.
>>>
>>> When I enforce NTLMv2 on the server and don't specify "sec=3Dntlmv2=
" with mount.cifs I
>>> get "mount error(13): Permission denied" and syslog on the client s=
hows that NTLMv1
>>> is tried ("sess setup type 1").
>>>
>>>
>>> So is there anything wrong with my setup? Should NTLMv2 be working =
between Samba and
>>> mount.cifs? If it should, why isn't it in this particular setup?
>>>
>>>
>>> Any hints will be greatly appreciated.
>>>
>>>
>>> TIA -- Till
>
> [...]
>
>> sec=3Dntlmv2 auth type should work between cifs vfs client and Samba=
 server.
>
> Ack.
>
>> Can you try sec=3Dntlmssp and see if it works?
>
> Yes, that works.
> I see "sess setup type 3" in my syslog on the client, and "ntlm_passw=
ord_check:
> Checking NTLMv2 password with domain [***]" on the server. I can suce=
ssfully create
> and remove files on the server from the client.
>
>> Can you list the smb.conf file here?
>
> See attachment.
>
>> And a wireshark trace when sec=3Dntlmv2 fails would be really helpfu=
l.
>
> See attachment.
>
> HTH -- Till
> --
> Dipl.-Inform. Till D=F6rges =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0doerge=
s@pre-sense.de
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Te=
l. +49 - 40 - 244 2407 - 14
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Fa=
x =A0+49 - 40 - 244 2407 - 24
> PRESENSE Technologies GmbH =A0 =A0 =A0 =A0 =A0 =A0Sachsenstr. 5, D-20=
097 HH
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 USt-IdNr.: DE263765024
> Gesch=E4ftsf=FChrer/Managing Directors =A0 =A0 =A0 AG Hamburg, HRB 10=
7844
> Till D=F6rges =A0 =A0 =A0 =A0 =A0 J=FCrgen Sander =A0 =A0 =A0 =A0 =A0=
 =A0 =A0Axel Theilmann
>

smb.conf options look fine.  I will have to spend some time on this.
But sec=3Dntlmv2/i works against a Windows server just fine, so somethi=
ng needs
to changed to make it work against Samba server, some bit in flags or
flags2 field in cifs/smb header perhaps.

Regards,

Shirish
