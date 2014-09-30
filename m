From: adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Accented characters not working with CIFS (but ok with smbclient)
Date: Tue, 30 Sep 2014 19:38:20 +0100
Message-ID: <542AF89C.3050707@gmail.com>
References: <541E0369.8070205@gmail.com> <CAH2r5mvHw=D=sjZr6wDoJndjDuzA41rNudRdtn8N=OjY8kUA=A@mail.gmail.com> <542746D9.7090007@gmail.com> <5427C7A6.8080901@steve-ss.com> <5429E222.4090101@gmail.com> <CAH2r5mtwPK8_HGtxnCq5kOs-4ZaaNNR5ame=GNXLUkCtzGq+Dg@mail.gmail.com> <CAH2r5msdOGbYPEW0+wNp4_qxQR5L1tHZvod2c4v1hYxjpme+Gg@mail.gmail.com> <CAH2r5mt1EVo26=N8tVRgqCDGGUpJrUDpajF4T+g3weJQcYwFFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt1EVo26=N8tVRgqCDGGUpJrUDpajF4T+g3weJQcYwFFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hy,

I tried creating a new file, and as I write it correctly, it appears=20
garbled in "ls".

So, I hadn't though about this, but he files were created locally in a=20
=46AT32 volume.
I did some research and it appears the most probable cp is 1252 (I'm in=
=20
Portugal). But I got this error:

# mount -t cifs //192.168.1.253/Disk_a1 /shared/ahgora --verbose -o=20
user=3Duser,pass=3D"",uid=3D1000,gid=3D1000,iocharset=3Dcp1257
mount.cifs kernel mount options:=20
ip=3D192.168.1.253,unc=3D\\192.168.1.253\Disk_a1,iocharset=3Dcp1257,uid=
=3D1000,gid=3D1000,user=3Duser,pass=3D********
mount error(79): Can not access a needed shared library
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

I also tried cp860 and cp 1250, but the accented characters were kept a=
s=20
weird symbols.

I didn't quite get how iocharset would solve this, as by you're=20
experiment, the server seems not to support UTF.
        iocharset
            Charset used to convert local path names to and from=20
Unicode. Unicode is used by default for network path names if the serve=
r=20
supports
            it. If iocharset is not specified then the nls_default=20
specified during the local client kernel build will be used. **If serve=
r=20
does not
            support Unicode, this parameter is unused**.


Since smbclient seems to be doing the conversion correctly, isn't it=20
possible to just "ask it" which conversion it is doing?

Thanks



On 30/09/2014 03:40, Steve French wrote:
> I did some experiments:
>
> Took a Samba server, and set "unicode=3Dfalse" in smb.conf
>
> mounted to the server from cifs and verified that Unicode is not bein=
g sent
>
> created some files locally with Spanish characters in the directory
> "test" and as expected the special characters were mapped to '?' (see
> the ls of /mnt1/test)
>
> sfrench@ubuntu:/mnt1/test1$ ls ~/test/*a*b*
> /home/sfrench/test/123=C3=A1a=C3=A9b=C3=ADc=C3=B3d=C3=BAe=C3=BCf=C3=B1=
g=C2=BFh=C2=A1  /home/sfrench/test/=C3=A1a=C3=A9b=C3=ADc=C3=B3d=C3=BAe=C3=
=BCf=C3=B1g=C2=BFh=C2=A1
> sfrench@ubuntu:/mnt1/test1$ ls ~/test1
> 123=E2=94=9C=C3=ADa=E2=94=9C=C2=AEb=E2=94=9C=C2=A1c=E2=94=9C=E2=94=82=
d=E2=94=9C=E2=95=91e=E2=94=9C=E2=95=9Df=E2=94=9C=E2=96=92g=E2=94=AC=E2=94=
=90h=E2=94=AC=C3=AD  =E2=94=9C=C3=ADa=E2=94=9C=C2=AEb=E2=94=9C=C2=A1c=E2=
=94=9C=E2=94=82d=E2=94=9C=E2=95=91e=E2=94=9C=E2=95=9Df=E2=94=9C=E2=96=92=
g=E2=94=AC=E2=94=90h=E2=94=AC=C3=AD
> sfrench@ubuntu:/mnt1/test1$ ls /mnt1/test/*a*b*
> /mnt1/test/123?a?b?c?d?e?f?g?h?  /mnt1/test/?a?b?c?d?e?f?g?h?
> sfrench@ubuntu:/mnt1/test1$ ls /mnt1/test1/
> 123=C3=A1a=C3=A9b=C3=ADc=C3=B3d=C3=BAe=C3=BCf=C3=B1g=C2=BFh=C2=A1  =C3=
=A1a=C3=A9b=C3=ADc=C3=B3d=C3=BAe=C3=BCf=C3=B1g=C2=BFh=C2=A1
>
> unmounted and the mounted with "iocharset=3Dcp850" on the client.
> Created the files over the remote mount in /mnt1/test1 and it worked
> fine and the Spanish characters were visible (locally in ~/test1 thos=
e
> same filenames are not easily visible since the characters map
> differently).
>
> So ... it looks like if files were created on a mount with the right
> code page (iocharset=3Dcp850 in my case) then you should be able to
> create and read them fine remotely.
>
> On Mon, Sep 29, 2014 at 8:33 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>> To clarify - we need to experiment with setting "unicode=3Dfalse" in=
 a
>> normal Samba server's smb.conf and experiment with client mount
>> options to see if it can be reproduced
>>
>> On Mon, Sep 29, 2014 at 8:32 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>> First strange thing is why isn't the server negotiating Unicode - t=
hat
>>> is unusual these days
>>>
>>> Negotiating unicode (UCS-2) the way like most every other server wo=
uld
>>> avoid this issue
>>>
>>> Looking at the trace we are not setting the Unicode flag on SMB Fin=
dFirst
>>>
>>> presumably because it was not offered at SMB tree connect time.  We
>>> always set it in the normal case when the server supports Unicode (=
see
>>> below)
>>>
>>> 265         if (treeCon->ses) {
>>> 266             if (treeCon->ses->capabilities & CAP_UNICODE)
>>> 267                 buffer->Flags2 |=3D SMBFLG2_UNICODE;
>>>
>>>
>>>
>>> So without Unicode we have to set the code page manually.  The serv=
er
>>> is way too old (10 years?) for us to mount smb2 (which would force
>>> unicode on the wire) or to use Unix Extensions (which probably
>>> requires at least 3.0 Samba to be useful).
>>>
>>> Haven't tried iocharset and codepage mount options recently
>>> (presumably the way to experiment with this is to turn off Unicode =
in
>>> Samba smb.conf via unicode=3Dfalse)
>>>
>>> On Mon, Sep 29, 2014 at 5:50 PM, adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>>>> On 28/09/2014 09:32, steve wrote:
>>>>> On 28/09/14 01:23, adcromitus wrote:
>>>>>> Hello again,
>>>>>>
>>>>>> Sorry for the long time to reply.
>>>>>>
>>>>>> I've been going around on how to do this. I set up Wireshark and=
 saw
>>>>>> what the server was transmitting. However I'm not really sure ab=
out what
>>>>>> I should send here.
>>>>>>
>>>>>> Anyway I did a "ls" on a dir with a file named "Cole=C3=A7=C3=A3=
o", and wireshar
>>>>>> captured "cole \247 \243o". I send a few frames from tcpdump whe=
re that
>>>>>> happens.
>>>>>>
>>>>>> How can I see if my distro defaults to UTF-8 on the client?
>>>>>>
>>>>>> I'm using:
>>>>>> Linux kernel 3.2.0-4-amd64
>>>>>> (Debian Wheezy)
>>>>>> mount.cifs version: 5.5
>>>>>>
>>>>>>
>>>>>> Thanks in advance.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 22/09/2014 04:28, Steve French wrote:
>>>>>>> This seems strange because modern Linux distributions should ma=
p UCS-2
>>>>>>> (16 bit Unicode characters which cifs servers like Windows and =
Samba
>>>>>>> send over the wire) fine to UTF-8 which is the typical default =
one for
>>>>>>> local.
>>>>>>>
>>>>>>> Does you distro not default to UTF-8 on the client?
>>>>>>>
>>>>>>> Would be helpful to see a wire trace (ethereal or tcpdump) and =
make
>>>>>>> sure the server is sending UCS-2 (Unicode) on the wire.  See
>>>>>>> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>>>>>>>
>>>>>>> On Sat, Sep 20, 2014 at 5:44 PM, adcromitus <adcromitus@gmail.c=
om>
>>>>>>> wrote:
>>>>>>>> Hy,
>>>>>>>>
>>>>>>>> I'm not sure of what can be relevant so I'll tell the whole st=
ory.
>>>>>>>>
>>>>>>>> I have a router (that I got from my ISP) which allows the conn=
ection
>>>>>>>> of a
>>>>>>>> pen/HDD by USB. That pen is shared on the network as a Windows=
 Share
>>>>>>>> folder.
>>>>>>>>
>>>>>>>> In Windows 7 I can see all the files name correctly, but when =
I mount
>>>>>>>> the
>>>>>>>> drive in Linux, with the command:
>>>>>>>>
>>>>>>>> mount -t cifs //<local share ip-address>/<shared-folder> --ver=
bose -o
>>>>>>>> user=3Duser,pass=3D"",uid=3D1000,gid=3D1000
>>>>>>>>
>>>>>>>> (there is no password)
>>>>>>>>
>>>>>>>> All file names with special characters (like =C3=87=C3=A3=C3=B5=
=C3=A9...) have a question
>>>>>>>> mark
>>>>>>>> in place of the accented character and I can't open the file o=
r
>>>>>>>> folder, as
>>>>>>>> any command responds the file doesn't exist. This happens in d=
olphin,
>>>>>>>> thunar
>>>>>>>> and in the command line with simple commands like cat.
>>>>>>>>
>>>>>>>> I tried adding the following option without success
>>>>>>>>
>>>>>>>> iocharset=3Dutf-8
>>>>>>>> iocharset=3Dutf-8,codepage=3Dcp437
>>>>>>>> iocharset=3Dutf-8,codepage=3Dcp850
>>>>>>>> iocharset=3Diso8859-1
>>>>>>>>
>>>>>>>> This also happens if I access the share from my android device=
, so I
>>>>>>>> was
>>>>>>>> convinced it was a problem related to old firmware (from the r=
outer).
>>>>>>>>
>>>>>>>> However, recently I connected to the drive using smbclient and=
 the file
>>>>>>>> names appeared correctly. I would like to mount this share fol=
der at
>>>>>>>> fstab,
>>>>>>>> and so smbclient is not a good solution.
>>>>>>>>
>>>>>>>> I'm using:
>>>>>>>> Linux kernel 3.2.0-4-amd64
>>>>>>>> (Debian Wheezy)
>>>>>>>> mount.cifs version: 5.5
>>>>>>>>
>>>>>>>> And I get this information from smbclient -L <local share ip a=
ddress>:
>>>>>>>> (smbclient version 4.1.11-Debian)
>>>>>>>> Server=3D[Samba 2.2.12]
>>>>>>>>
>>>>>>>> So. Is there something else I can try?
>>>>>>>>
>>>>>>>> Thanks in advance.
>>>>> Hi
>>>>> Probably an old cifs-utils? We have 6.2 with Spanish:
>>>>> steve2@altet:~> ls
>>>>> avi=C3=B1=C3=B3n
>>>>> bar=C3=A7a
>>>>>
>>>>> HTH,
>>>>> Steve
>>>>
>>>> Hy Steve,
>>>>
>>>> So I used chroot to install the cifs-utils version from Debian nex=
t release
>>>> (cifs-utils v.6.4), and the result was the same as with my current=
 version.
>>>>
>>>> Does the tcpdump helped in any way?
>>>>
>>>> Thanks again.
>>>>
>>>>
>>>>>
>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linu=
x-cifs"
>>>>>>>> in
>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.h=
tml
>>>>>>>
>>>>>>>
>>>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
