From: adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Accented characters not working with CIFS (but ok with smbclient)
Date: Sun, 28 Sep 2014 00:23:05 +0100
Message-ID: <542746D9.7090007@gmail.com>
References: <541E0369.8070205@gmail.com> <CAH2r5mvHw=D=sjZr6wDoJndjDuzA41rNudRdtn8N=OjY8kUA=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040008070808090300070705"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvHw=D=sjZr6wDoJndjDuzA41rNudRdtn8N=OjY8kUA=A@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040008070808090300070705
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello again,

Sorry for the long time to reply.

I've been going around on how to do this. I set up Wireshark and saw 
what the server was transmitting. However I'm not really sure about what 
I should send here.

Anyway I did a "ls" on a dir with a file named "Coleção", and wireshar 
captured "cole \247 \243o". I send a few frames from tcpdump where that 
happens.

How can I see if my distro defaults to UTF-8 on the client?

I'm using:
Linux kernel 3.2.0-4-amd64
(Debian Wheezy)
mount.cifs version: 5.5


Thanks in advance.




On 22/09/2014 04:28, Steve French wrote:
> This seems strange because modern Linux distributions should map UCS-2
> (16 bit Unicode characters which cifs servers like Windows and Samba
> send over the wire) fine to UTF-8 which is the typical default one for
> local.
>
> Does you distro not default to UTF-8 on the client?
>
> Would be helpful to see a wire trace (ethereal or tcpdump) and make
> sure the server is sending UCS-2 (Unicode) on the wire.  See
> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>
> On Sat, Sep 20, 2014 at 5:44 PM, adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hy,
>>
>> I'm not sure of what can be relevant so I'll tell the whole story.
>>
>> I have a router (that I got from my ISP) which allows the connection of a
>> pen/HDD by USB. That pen is shared on the network as a Windows Share folder.
>>
>> In Windows 7 I can see all the files name correctly, but when I mount the
>> drive in Linux, with the command:
>>
>> mount -t cifs //<local share ip-address>/<shared-folder> --verbose -o
>> user=user,pass="",uid=1000,gid=1000
>>
>> (there is no password)
>>
>> All file names with special characters (like Çãõé...) have a question mark
>> in place of the accented character and I can't open the file or folder, as
>> any command responds the file doesn't exist. This happens in dolphin, thunar
>> and in the command line with simple commands like cat.
>>
>> I tried adding the following option without success
>>
>> iocharset=utf-8
>> iocharset=utf-8,codepage=cp437
>> iocharset=utf-8,codepage=cp850
>> iocharset=iso8859-1
>>
>> This also happens if I access the share from my android device, so I was
>> convinced it was a problem related to old firmware (from the router).
>>
>> However, recently I connected to the drive using smbclient and the file
>> names appeared correctly. I would like to mount this share folder at fstab,
>> and so smbclient is not a good solution.
>>
>> I'm using:
>> Linux kernel 3.2.0-4-amd64
>> (Debian Wheezy)
>> mount.cifs version: 5.5
>>
>> And I get this information from smbclient -L <local share ip address>:
>> (smbclient version 4.1.11-Debian)
>> Server=[Samba 2.2.12]
>>
>> So. Is there something else I can try?
>>
>> Thanks in advance.
>>
>>
>>
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


--------------040008070808090300070705
Content-Type: application/x-zip-compressed;
 name="cifs-traffic.pcap.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="cifs-traffic.pcap.zip"

UEsDBBQAAAAIACEBPEWqJrJ8DwIAAIMEAAAVABwAdG1wL2NpZnMtdHJhZmZpYy5wY2FwVVQJ
AAONQydURUMnVHV4CwABBAAAAAAEAAAAALtyeNNCJgYWBhj4/5+BgRFI9zirh9RfY2CYwwDB
XGX/O5gNZLyv9YY/5GBwZWDouzXVgcGB7bbbgRWMDkD89/59hu6OgDJfKfuiZw0SDGd02oEm
MXJwMZy7LuY7r+8Y0JCw/8G+TkZgexgdGJAAI8N8ZgYGBUZ+EZBVDAxIkiIMTlAljAyiDAzi
DNMY2IDmgoRiSlKLS2K0wG6d9omBIY4RgiGuhLgY5FbGgNkrQG6VLAK5E+Rehu7790HuBLp3
eYMEb8aOexC3+s5bpQRyL5AnAXdrgyMDNrdycTFcAbvWAkheYXABSz5kYPj7nxkcgh1A7ALV
07B6v9TaW+cZcdEI0wXgJEhQD9kMMVYBsB4cNDYzmEBmAA3xgZnh/HvHEpAeHDQDGlAAYk4g
Ts7PSVVYrrA4H5oyvgBDGxQtTthShsmtaeCUMR8tZSyXsi9hahBgeNCyBZ4yJEAhDjKx6jMD
wzwGCMYwccKt6WATnbCaKMHwYOotVBOBhkTgT2uKjPxi4ABawI+QEoOnNVZgQmNgR0pliBAA
ufYPJyPDe6AcCKOnNoaHs1eCU9sD1NRWwtQRUM4MSm37EuCpTQPkYqAhK/GnNkVGLiaGXLB7
Qaktl8EGLFlEXKwqoEcr3GwI4EJkf4b9jLwosc8ATQHwAAB5n3UpI77onwGOrLmokVXODAyC
9cDo/4wU/SqgIAAAUEsBAh4DFAAAAAgAIQE8RaomsnwPAgAAgwQAABUAGAAAAAAAAAAAAKSB
AAAAAHRtcC9jaWZzLXRyYWZmaWMucGNhcFVUBQADjUMnVHV4CwABBAAAAAAEAAAAAFBLBQYA
AAAAAQABAFsAAABeAgAAAAA=
--------------040008070808090300070705--
