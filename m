From: adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Accented characters not working with CIFS (but ok with smbclient)
Date: Mon, 29 Sep 2014 23:50:10 +0100
Message-ID: <5429E222.4090101@gmail.com>
References: <541E0369.8070205@gmail.com> <CAH2r5mvHw=D=sjZr6wDoJndjDuzA41rNudRdtn8N=OjY8kUA=A@mail.gmail.com> <542746D9.7090007@gmail.com> <5427C7A6.8080901@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5427C7A6.8080901-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


On 28/09/2014 09:32, steve wrote:
> On 28/09/14 01:23, adcromitus wrote:
>> Hello again,
>>
>> Sorry for the long time to reply.
>>
>> I've been going around on how to do this. I set up Wireshark and saw
>> what the server was transmitting. However I'm not really sure about =
what
>> I should send here.
>>
>> Anyway I did a "ls" on a dir with a file named "Cole=C3=A7=C3=A3o", =
and wireshar
>> captured "cole \247 \243o". I send a few frames from tcpdump where t=
hat
>> happens.
>>
>> How can I see if my distro defaults to UTF-8 on the client?
>>
>> I'm using:
>> Linux kernel 3.2.0-4-amd64
>> (Debian Wheezy)
>> mount.cifs version: 5.5
>>
>>
>> Thanks in advance.
>>
>>
>>
>>
>> On 22/09/2014 04:28, Steve French wrote:
>>> This seems strange because modern Linux distributions should map UC=
S-2
>>> (16 bit Unicode characters which cifs servers like Windows and Samb=
a
>>> send over the wire) fine to UTF-8 which is the typical default one =
for
>>> local.
>>>
>>> Does you distro not default to UTF-8 on the client?
>>>
>>> Would be helpful to see a wire trace (ethereal or tcpdump) and make
>>> sure the server is sending UCS-2 (Unicode) on the wire.  See
>>> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>>>
>>> On Sat, Sep 20, 2014 at 5:44 PM, adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=20
>>> wrote:
>>>> Hy,
>>>>
>>>> I'm not sure of what can be relevant so I'll tell the whole story.
>>>>
>>>> I have a router (that I got from my ISP) which allows the connecti=
on
>>>> of a
>>>> pen/HDD by USB. That pen is shared on the network as a Windows Sha=
re
>>>> folder.
>>>>
>>>> In Windows 7 I can see all the files name correctly, but when I mo=
unt
>>>> the
>>>> drive in Linux, with the command:
>>>>
>>>> mount -t cifs //<local share ip-address>/<shared-folder> --verbose=
 -o
>>>> user=3Duser,pass=3D"",uid=3D1000,gid=3D1000
>>>>
>>>> (there is no password)
>>>>
>>>> All file names with special characters (like =C3=87=C3=A3=C3=B5=C3=
=A9...) have a question
>>>> mark
>>>> in place of the accented character and I can't open the file or
>>>> folder, as
>>>> any command responds the file doesn't exist. This happens in dolph=
in,
>>>> thunar
>>>> and in the command line with simple commands like cat.
>>>>
>>>> I tried adding the following option without success
>>>>
>>>> iocharset=3Dutf-8
>>>> iocharset=3Dutf-8,codepage=3Dcp437
>>>> iocharset=3Dutf-8,codepage=3Dcp850
>>>> iocharset=3Diso8859-1
>>>>
>>>> This also happens if I access the share from my android device, so=
=20
>>>> I was
>>>> convinced it was a problem related to old firmware (from the route=
r).
>>>>
>>>> However, recently I connected to the drive using smbclient and the=
=20
>>>> file
>>>> names appeared correctly. I would like to mount this share folder =
at
>>>> fstab,
>>>> and so smbclient is not a good solution.
>>>>
>>>> I'm using:
>>>> Linux kernel 3.2.0-4-amd64
>>>> (Debian Wheezy)
>>>> mount.cifs version: 5.5
>>>>
>>>> And I get this information from smbclient -L <local share ip addre=
ss>:
>>>> (smbclient version 4.1.11-Debian)
>>>> Server=3D[Samba 2.2.12]
>>>>
>>>> So. Is there something else I can try?
>>>>
>>>> Thanks in advance.
> Hi
> Probably an old cifs-utils? We have 6.2 with Spanish:
> steve2@altet:~> ls
> avi=C3=B1=C3=B3n
> bar=C3=A7a
>
> HTH,
> Steve

Hy Steve,

So I used chroot to install the cifs-utils version from Debian next=20
release (cifs-utils v.6.4), and the result was the same as with my=20
current version.

Does the tcpdump helped in any way?

Thanks again.

>
>
>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> --=20
>>>> To unsubscribe from this list: send the line "unsubscribe=20
>>>> linux-cifs" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>
>
