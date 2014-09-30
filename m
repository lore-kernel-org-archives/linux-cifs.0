From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Accented characters not working with CIFS (but ok with smbclient)
Date: Mon, 29 Sep 2014 20:33:48 -0500
Message-ID: <CAH2r5msdOGbYPEW0+wNp4_qxQR5L1tHZvod2c4v1hYxjpme+Gg@mail.gmail.com>
References: <541E0369.8070205@gmail.com> <CAH2r5mvHw=D=sjZr6wDoJndjDuzA41rNudRdtn8N=OjY8kUA=A@mail.gmail.com>
 <542746D9.7090007@gmail.com> <5427C7A6.8080901@steve-ss.com>
 <5429E222.4090101@gmail.com> <CAH2r5mtwPK8_HGtxnCq5kOs-4ZaaNNR5ame=GNXLUkCtzGq+Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtwPK8_HGtxnCq5kOs-4ZaaNNR5ame=GNXLUkCtzGq+Dg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To clarify - we need to experiment with setting "unicode=3Dfalse" in a
normal Samba server's smb.conf and experiment with client mount
options to see if it can be reproduced

On Mon, Sep 29, 2014 at 8:32 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> First strange thing is why isn't the server negotiating Unicode - tha=
t
> is unusual these days
>
> Negotiating unicode (UCS-2) the way like most every other server woul=
d
> avoid this issue
>
> Looking at the trace we are not setting the Unicode flag on SMB FindF=
irst
>
> presumably because it was not offered at SMB tree connect time.  We
> always set it in the normal case when the server supports Unicode (se=
e
> below)
>
> 265         if (treeCon->ses) {
> 266             if (treeCon->ses->capabilities & CAP_UNICODE)
> 267                 buffer->Flags2 |=3D SMBFLG2_UNICODE;
>
>
>
> So without Unicode we have to set the code page manually.  The server
> is way too old (10 years?) for us to mount smb2 (which would force
> unicode on the wire) or to use Unix Extensions (which probably
> requires at least 3.0 Samba to be useful).
>
> Haven't tried iocharset and codepage mount options recently
> (presumably the way to experiment with this is to turn off Unicode in
> Samba smb.conf via unicode=3Dfalse)
>
> On Mon, Sep 29, 2014 at 5:50 PM, adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>>
>> On 28/09/2014 09:32, steve wrote:
>>>
>>> On 28/09/14 01:23, adcromitus wrote:
>>>>
>>>> Hello again,
>>>>
>>>> Sorry for the long time to reply.
>>>>
>>>> I've been going around on how to do this. I set up Wireshark and s=
aw
>>>> what the server was transmitting. However I'm not really sure abou=
t what
>>>> I should send here.
>>>>
>>>> Anyway I did a "ls" on a dir with a file named "Cole=C3=A7=C3=A3o"=
, and wireshar
>>>> captured "cole \247 \243o". I send a few frames from tcpdump where=
 that
>>>> happens.
>>>>
>>>> How can I see if my distro defaults to UTF-8 on the client?
>>>>
>>>> I'm using:
>>>> Linux kernel 3.2.0-4-amd64
>>>> (Debian Wheezy)
>>>> mount.cifs version: 5.5
>>>>
>>>>
>>>> Thanks in advance.
>>>>
>>>>
>>>>
>>>>
>>>> On 22/09/2014 04:28, Steve French wrote:
>>>>>
>>>>> This seems strange because modern Linux distributions should map =
UCS-2
>>>>> (16 bit Unicode characters which cifs servers like Windows and Sa=
mba
>>>>> send over the wire) fine to UTF-8 which is the typical default on=
e for
>>>>> local.
>>>>>
>>>>> Does you distro not default to UTF-8 on the client?
>>>>>
>>>>> Would be helpful to see a wire trace (ethereal or tcpdump) and ma=
ke
>>>>> sure the server is sending UCS-2 (Unicode) on the wire.  See
>>>>> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>>>>>
>>>>> On Sat, Sep 20, 2014 at 5:44 PM, adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
>
>>>>> wrote:
>>>>>>
>>>>>> Hy,
>>>>>>
>>>>>> I'm not sure of what can be relevant so I'll tell the whole stor=
y.
>>>>>>
>>>>>> I have a router (that I got from my ISP) which allows the connec=
tion
>>>>>> of a
>>>>>> pen/HDD by USB. That pen is shared on the network as a Windows S=
hare
>>>>>> folder.
>>>>>>
>>>>>> In Windows 7 I can see all the files name correctly, but when I =
mount
>>>>>> the
>>>>>> drive in Linux, with the command:
>>>>>>
>>>>>> mount -t cifs //<local share ip-address>/<shared-folder> --verbo=
se -o
>>>>>> user=3Duser,pass=3D"",uid=3D1000,gid=3D1000
>>>>>>
>>>>>> (there is no password)
>>>>>>
>>>>>> All file names with special characters (like =C3=87=C3=A3=C3=B5=C3=
=A9...) have a question
>>>>>> mark
>>>>>> in place of the accented character and I can't open the file or
>>>>>> folder, as
>>>>>> any command responds the file doesn't exist. This happens in dol=
phin,
>>>>>> thunar
>>>>>> and in the command line with simple commands like cat.
>>>>>>
>>>>>> I tried adding the following option without success
>>>>>>
>>>>>> iocharset=3Dutf-8
>>>>>> iocharset=3Dutf-8,codepage=3Dcp437
>>>>>> iocharset=3Dutf-8,codepage=3Dcp850
>>>>>> iocharset=3Diso8859-1
>>>>>>
>>>>>> This also happens if I access the share from my android device, =
so I
>>>>>> was
>>>>>> convinced it was a problem related to old firmware (from the rou=
ter).
>>>>>>
>>>>>> However, recently I connected to the drive using smbclient and t=
he file
>>>>>> names appeared correctly. I would like to mount this share folde=
r at
>>>>>> fstab,
>>>>>> and so smbclient is not a good solution.
>>>>>>
>>>>>> I'm using:
>>>>>> Linux kernel 3.2.0-4-amd64
>>>>>> (Debian Wheezy)
>>>>>> mount.cifs version: 5.5
>>>>>>
>>>>>> And I get this information from smbclient -L <local share ip add=
ress>:
>>>>>> (smbclient version 4.1.11-Debian)
>>>>>> Server=3D[Samba 2.2.12]
>>>>>>
>>>>>> So. Is there something else I can try?
>>>>>>
>>>>>> Thanks in advance.
>>>
>>> Hi
>>> Probably an old cifs-utils? We have 6.2 with Spanish:
>>> steve2@altet:~> ls
>>> avi=C3=B1=C3=B3n
>>> bar=C3=A7a
>>>
>>> HTH,
>>> Steve
>>
>>
>> Hy Steve,
>>
>> So I used chroot to install the cifs-utils version from Debian next =
release
>> (cifs-utils v.6.4), and the result was the same as with my current v=
ersion.
>>
>> Does the tcpdump helped in any way?
>>
>> Thanks again.
>>
>>
>>>
>>>
>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
cifs"
>>>>>> in
>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.htm=
l
>>>>>
>>>>>
>>>>>
>>>>
>>>
>>>
>>
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
