From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: Accented characters not working with CIFS (but ok with smbclient)
Date: Sun, 28 Sep 2014 10:32:38 +0200
Message-ID: <5427C7A6.8080901@steve-ss.com>
References: <541E0369.8070205@gmail.com> <CAH2r5mvHw=D=sjZr6wDoJndjDuzA41rNudRdtn8N=OjY8kUA=A@mail.gmail.com> <542746D9.7090007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <542746D9.7090007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 28/09/14 01:23, adcromitus wrote:
> Hello again,
>
> Sorry for the long time to reply.
>
> I've been going around on how to do this. I set up Wireshark and saw
> what the server was transmitting. However I'm not really sure about w=
hat
> I should send here.
>
> Anyway I did a "ls" on a dir with a file named "Cole=C3=A7=C3=A3o", a=
nd wireshar
> captured "cole \247 \243o". I send a few frames from tcpdump where th=
at
> happens.
>
> How can I see if my distro defaults to UTF-8 on the client?
>
> I'm using:
> Linux kernel 3.2.0-4-amd64
> (Debian Wheezy)
> mount.cifs version: 5.5
>
>
> Thanks in advance.
>
>
>
>
> On 22/09/2014 04:28, Steve French wrote:
>> This seems strange because modern Linux distributions should map UCS=
-2
>> (16 bit Unicode characters which cifs servers like Windows and Samba
>> send over the wire) fine to UTF-8 which is the typical default one f=
or
>> local.
>>
>> Does you distro not default to UTF-8 on the client?
>>
>> Would be helpful to see a wire trace (ethereal or tcpdump) and make
>> sure the server is sending UCS-2 (Unicode) on the wire.  See
>> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>>
>> On Sat, Sep 20, 2014 at 5:44 PM, adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>> Hy,
>>>
>>> I'm not sure of what can be relevant so I'll tell the whole story.
>>>
>>> I have a router (that I got from my ISP) which allows the connectio=
n
>>> of a
>>> pen/HDD by USB. That pen is shared on the network as a Windows Shar=
e
>>> folder.
>>>
>>> In Windows 7 I can see all the files name correctly, but when I mou=
nt
>>> the
>>> drive in Linux, with the command:
>>>
>>> mount -t cifs //<local share ip-address>/<shared-folder> --verbose =
-o
>>> user=3Duser,pass=3D"",uid=3D1000,gid=3D1000
>>>
>>> (there is no password)
>>>
>>> All file names with special characters (like =C3=87=C3=A3=C3=B5=C3=A9=
=2E..) have a question
>>> mark
>>> in place of the accented character and I can't open the file or
>>> folder, as
>>> any command responds the file doesn't exist. This happens in dolphi=
n,
>>> thunar
>>> and in the command line with simple commands like cat.
>>>
>>> I tried adding the following option without success
>>>
>>> iocharset=3Dutf-8
>>> iocharset=3Dutf-8,codepage=3Dcp437
>>> iocharset=3Dutf-8,codepage=3Dcp850
>>> iocharset=3Diso8859-1
>>>
>>> This also happens if I access the share from my android device, so =
I was
>>> convinced it was a problem related to old firmware (from the router=
).
>>>
>>> However, recently I connected to the drive using smbclient and the =
file
>>> names appeared correctly. I would like to mount this share folder a=
t
>>> fstab,
>>> and so smbclient is not a good solution.
>>>
>>> I'm using:
>>> Linux kernel 3.2.0-4-amd64
>>> (Debian Wheezy)
>>> mount.cifs version: 5.5
>>>
>>> And I get this information from smbclient -L <local share ip addres=
s>:
>>> (smbclient version 4.1.11-Debian)
>>> Server=3D[Samba 2.2.12]
>>>
>>> So. Is there something else I can try?
>>>
>>> Thanks in advance.
Hi
Probably an old cifs-utils? We have 6.2 with Spanish:
steve2@altet:~> ls
avi=C3=B1=C3=B3n
bar=C3=A7a

HTH,
Steve



>>>
>>>
>>>
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
