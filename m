From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: backing up to a Drobo CIFS VFS: Error -11 sending data on socket
 to server, Bufferbloat?
Date: Thu, 11 May 2017 15:56:25 -0700
Message-ID: <CACyXjPzG4L3Px8ws+CQkh0K6xwB7Kd6tCC7zSO0C11j4SWHY1w@mail.gmail.com>
References: <B0AAEC04-DBAE-49AB-A549-B772D5F1B7F6@fordham.edu> <D5627D5A-065B-4C28-B152-7B0A587A0CBF@fordham.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Robert Kudyba <rkudyba-tzaSEmCkE7qVc3sceRu5cw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D5627D5A-065B-4C28-B152-7B0A587A0CBF-tzaSEmCkE7qVc3sceRu5cw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 11, 2017 at 1:42 PM, Robert Kudyba <rkudyba-tzaSEmCkE7qVc3sceRu5cw@public.gmane.org> wrote:
>>> Could you provide a network trace of the isssue happening? You can add =
a
>>> new bug report on bugzilla.samba.org in the cifsVFS/kernel fs section
>>> and attach the trace there.
>
>> I submitted a bug. Seems to happen every night. Cron starts at 11:30 PM.=
 Error happens around 1:25 AM. Here are some logs in context as well as a t=
cpdump=E2=80=94drobo-ds is the NAS backup device. I created a large (3GB) t=
cpdump during the backup but it=E2=80=99s way too big to upload. Could this=
 be bufferbloat?

This suggests that the Drobo is simply going off into the weeds
somewhere. Do you have enough storage on it. They will insert write
delays when storage is low, but I didn't think they would insert 120
seconds.

Also, if you run the capture through tshark you can get a text listing
of the requests that might allow you to find the location where the
Drobo stops responding and then you can extract the 100-1000 packets
around that point.

tshark -r whatever-your-capture-is.pcap.

>> May 11 01:22:23 ourserver kernel: CIFS VFS: Server droboh has not respon=
ded in 120 seconds. Reconnecting...
>> May 11 01:23:40 ourserver kernel: CIFS VFS: sends on sock ffff9f2881408c=
80 stuck for 15 seconds
>> May 11 01:23:40 ourserver kernel: CIFS VFS: Error -11 sending data on so=
cket to server
>> May 11 01:24:24 ourserver kernel: CIFS VFS: sends on sock ffff9f2881408c=
80 stuck for 15 seconds
>> May 11 01:24:24 ourserver kernel: CIFS VFS: Error -11 sending data on so=
cket to server
>> May 11 01:25:00 ourserver kernel: CIFS VFS: sends on sock ffff9f2881408c=
80 stuck for 15 seconds
>> May 11 01:25:00 ourserver kernel: CIFS VFS: Error -11 sending data on so=
cket to server
>> May 11 01:25:16 ourserver kernel: CIFS VFS: sends on sock ffff9f2881408c=
80 stuck for 15 seconds
>> May 11 01:25:16 ourserver kernel: CIFS VFS: Error -11 sending data on so=
cket to server
>> May 11 01:25:49 ourserver kernel: CIFS VFS: sends on sock ffff9f2881408c=
80 stuck for 15 seconds
>> May 11 01:25:49 ourserver kernel: CIFS VFS: Error -11 sending data on so=
cket to server
>>
>> reading from file capture_eth1.pcap, link-type EN10MB (Ethernet)
>> 01:29:10.445882 IP ourserver.uuidgen > fileserver.nfs: Flags [P.], seq 2=
359428476:2359428700, ack 4223248510, win 1444, options [nop,nop,TS val 197=
9978735 ecr 775533219], length 224: NFS request xid 2016398399 220 getattr =
fh 0,2/53
>> 01:29:10.446331 IP fileserver.nfs > ourserver.uuidgen: Flags [P.], seq 1=
:173, ack 224, win 5204, options [nop,nop,TS val 775535659 ecr 1979978735],=
 length 172: NFS reply xid 2016398399 reply ok 168 getattr NON 4 ids 0/1730=
480217 sz 1861894709
>> 01:29:10.446378 IP ourserver.uuidgen > fileserver.nfs: Flags [.], ack 17=
3, win 1444, options [nop,nop,TS val 1979978736 ecr 775535659], length 0
>> 01:29:10.446466 IP ourserver.uuidgen > fileserver.nfs: Flags [P.], seq 2=
24:568, ack 173, win 1444, options [nop,nop,TS val 1979978736 ecr 775535659=
], length 344: NFS request xid 2033175615 340 getattr fh 0,2/53
>> 01:29:10.447034 IP fileserver.nfs > ourserver.uuidgen: Flags [P.], seq 1=
73:537, ack 568, win 5204, options [nop,nop,TS val 775535660 ecr 1979978736=
], length 364: NFS reply xid 2033175615 reply ok 360 getattr NON 6 ids 0/17=
30480217 sz 1861894709
>> 01:29:10.447346 IP ourserver.uuidgen > fileserver.nfs: Flags [P.], seq 5=
68:836, ack 537, win 1444, options [nop,nop,TS val 1979978737 ecr 775535660=
], length 268: NFS request xid 2049952831 264 getattr fh 0,2/53
>> 01:29:10.465786 IP fileserver.nfs > ourserver.uuidgen: Flags [P.], seq 5=
37:805, ack 836, win 5204, options [nop,nop,TS val 775535679 ecr 1979978737=
], length 268: NFS reply xid 2049952831 reply ok 264 getattr NON 4 ids 0/17=
30480217 sz 1861894709
>> 01:29:13.964676 IP drobo-ds > ourserver.42582: Flags [.], ack 3571070888=
, win 26508, options [nop,nop,TS val 616097295 ecr 1073740628], length 0
>> 01:29:13.964780 IP drobo-ds > ourserver.42582: Flags [.], ack 2897, win =
26508, options [nop,nop,TS val 616097295 ecr 1073740628], length 0
>> 01:29:13.965029 IP drobo-ds > ourserver.42582: Flags [.], ack 5793, win =
26508, options [nop,nop,TS val 616097295 ecr 1073740628], length 0
>> 01:29:13.965155 IP drobo-ds > ourserver.42582: Flags [.], ack 8689, win =
26508, options [nop,nop,TS val 616097295 ecr 1073740629], length 0
>> 01:29:13.965176 IP ourserver.42582 > drobo-ds: Flags [.], seq 101361:115=
841, ack 0, win 321, options [nop,nop,TS val 1073740637 ecr 616097295], len=
gth 14480 SMB-over-TCP packet:(raw data or continuation?)
>>
>> 01:29:13.965397 IP drobo-ds > ourserver.42582: Flags [.], ack 11585, win=
 26421, options [nop,nop,TS val 616097295 ecr 1073740630], length 0
>> 01:29:13.965418 IP ourserver.42582 > drobo-ds: Flags [.], seq 115841:118=
737, ack 0, win 321, options [nop,nop,TS val 1073740638 ecr 616097295], len=
gth 2896 SMB-over-TCP packet:(raw data or continuation?)
>>
>> 01:29:13.966364 IP drobo-ds > ourserver.42582: Flags [P.], seq 0:51, ack=
 18825, win 25986, options [nop,nop,TS val 616097295 ecr 1073740630], lengt=
h 51 SMB PACKET: SMBwriteX (REPLY)
>>
>> 01:29:13.966386 IP drobo-ds > ourserver.42582: Flags [.], ack 21721, win=
 26508, options [nop,nop,TS val 616097295 ecr 1073740630], length 0
>> 01:29:13.966416 IP ourserver.42582 > drobo-ds: Flags [.], seq 118737:125=
977, ack 51, win 321, options [nop,nop,TS val 1073740639 ecr 616097295], le=
ngth 7240 SMB-over-TCP packet:(raw data or continuation?)
>>
>> 01:29:13.966658 IP drobo-ds > ourserver.42582: Flags [.], ack 24617, win=
 26508, options [nop,nop,TS val 616097295 ecr 1073740631], length 0
>> 01:29:13.966783 IP drobo-ds > ourserver.42582: Flags [.], ack 27513, win=
 26508, options [nop,nop,TS val 616097295 ecr 1073740631], length 0
>> 01:29:13.967054 IP drobo-ds > ourserver.42582: Flags [.], ack 30409, win=
 26508, options [nop,nop,TS val 616097295 ecr 1073740631], length 0
>> 01:29:13.967072 IP ourserver.42582 > drobo-ds: Flags [P.], seq 125977:13=
7561, ack 51, win 321, options [nop,nop,TS val 1073740639 ecr 616097295], l=
ength 11584 SMB-over-TCP packet:(raw data or continuation?)
>>
>> 01:29:13.967408 IP drobo-ds > ourserver.42582: Flags [.], ack 33305, win=
 26508, options [nop,nop,TS val 616097295 ecr 1073740631], length 0
>> 01:29:13.968436 IP drobo-ds > ourserver.42582: Flags [.], ack 44889, win=
 26508, options [nop,nop,TS val 616097296 ecr 1073740632], length 0
>> 01:29:13.968460 IP ourserver.42582 > drobo-ds: Flags [.], seq 140457:152=
041, ack 51, win 321, options [nop,nop,TS val 1073740641 ecr 616097296], le=
ngth 11584 SMB-over-TCP packet:(raw data or continuation?)
>>
>> 01:29:13.968515 IP drobo-ds > ourserver.42582: Flags [.], ack 47785, win=
 26508, options [nop,nop,TS val 616097296 ecr 1073740634], length 0
>> 01:29:13.968782 IP drobo-ds > ourserver.42582: Flags [.], ack 50681, win=
 26508, options [nop,nop,TS val 616097296 ecr 1073740634], length 0
>> 01:29:13.969224 IP drobo-ds > ourserver.42582: Flags [.], ack 53577, win=
 26508, options [nop,nop,TS val 616097296 ecr 1073740634], length 0
>> 01:29:13.969242 IP ourserver.42582 > drobo-ds: Flags [.], seq 152041:160=
729, ack 51, win 321, options [nop,nop,TS val 1073740642 ecr 616097296], le=
ngth 8688 SMB-over-TCP packet:(raw data or continuation?)
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
