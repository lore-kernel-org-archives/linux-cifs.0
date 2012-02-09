From: "Bob Balsover" <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org>
Subject: [MAC Lion] smbclient "Open AndX Request->STATUS_NOT_SUPPORTED"
Date: Wed, 8 Feb 2012 22:59:13 -0800
Message-ID: <000301cce6f8$551aa830$ff4ff890$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have also been seeing this problem, it appears it might be in Apple'=
s
flawed authentication the new SMBX or whatever they call it. We are onl=
y
able to mount and write to a SMB share on an Lion 10.7.3 machine using
guest, any attempt with a normal user account fails every time. We have=
 been
using the same parameters as you have
'pass=3Dxxx,user=3Dyyy,nounix,noserverino,sec=3Dntlmssp'.  Darrik, I wi=
ll leave
uploading the trace to you as I don't think that I can to it tomorrow. =
 If
you are having trouble mounting it as guest verify that you have the pr=
oper
permissions on the share.

-Bob

-----Original Message-----
=46rom: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shirish Pargaonk=
ar
Sent: Wednesday, February 08, 2012 10:07 PM
To: Darrik Spaude
Cc: George K Colley; linux-cifs
Subject: Re: [MAC Lion] smbclient "Open AndX Request->STATUS_NOT_SUPPOR=
TED"

On Wed, Feb 8, 2012 at 5:28 PM, Darrik Spaude <dspaude-BGUGTLuWYFm1Z/+hSey0Gg@public.gmane.org> w=
rote:
>> You should be using cifs to connect to Lion.
>
> George,
>
> Is there a specific cifs version and list of options to use? It seems
> that there is some minimum cifs version before this problem is resolv=
ed.
> We have tried the following and both of them fail:
>
> # mount.cifs -V =A0 (Updated Embedded Server, kernel 2.6.32.28)
> mount.cifs version: 1.14-3.5.6
>
> # mount.cifs -V =A0 (Ubuntu 10.04 LTS, kernel 2.6.32-38)
> mount.cifs version: 1.12-3.4.7
>
>
> The command options we have tried (based on lots of searching) are
> 'nounix,noserverino,sec=3Dntlmssp'.
>
> The command is then:
> mount.cifs //192.168.1.2/Shared mntpoint -o
> 'guest,nounix,noserverino,sec=3Dntlmssp'
>
> Ubuntu gives a different error (-126) with the sec=3Dntlmssp. The emb=
edded
> server just gives error -22.
>
> Any help is appreciated,
> Darrik
>

I think this concerns linux cifs vfs client.  If so, a wireshark trace
would be helpful.

Regards,

Shirish
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
