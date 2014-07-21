From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setting allocation size in cifs/smb3
Date: Mon, 21 Jul 2014 14:41:58 -0500
Message-ID: <CAH2r5msy4OWaJfAKUrc0Tzx73dsb0zx6fU1wAejKsksq1V8gdA@mail.gmail.com>
References: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
 <20140718170952.GA27001@samba2> <CAH2r5mubvLEd7QFY8p-YSCojPPdwzQMXK_Ka6k7V0uKRgUeeaw@mail.gmail.com>
 <20140719051427.GA21226@jeremy-HP> <CAH2r5mvSEYbGxE166W2GijnhKj4hVcVzhVLJQQeQeWejk4AoaQ@mail.gmail.com>
 <20140721182840.GC29893@samba2> <CAH2r5mtLO9jwBx+EumbXzEjiprPMVvnz39CsZJsEm3dAraDDZQ@mail.gmail.com>
 <20140721185528.GD29893@samba2> <CAH2r5msV39xCYsK9Ru=zaJadv5-fKa5-DHwUO7wPt+E55k0vMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msV39xCYsK9Ru=zaJadv5-fKa5-DHwUO7wPt+E55k0vMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To Windows 8.1 it appears to round to 4K boundaries when shrinking but
also not extend the allocation size when allocating beyond end of file
as the documentation would imply

[sfrench@localhost cifs-2.6]$ stat /mnt/test/4M ; fallocate -n -l
5400000 /mnt/test/4M ; sleep 3 ; stat /mnt/test/4M ; fallocate -n -l
10000 /mnt/test/4M ; sleep 2; stat /mnt/test/4M
  File: =E2=80=98/mnt/test/4M=E2=80=99
  Size: 4194304   Blocks: 8192       IO Block: 16384  regular file
Device: 26h/38d Inode: 1407374883618316  Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root=
)
Context: system_u:object_r:cifs_t:s0
Access: 2014-07-21 14:36:20.249486200 -0500
Modify: 2014-07-21 14:36:20.389204200 -0500
Change: 2014-07-21 14:36:20.389204200 -0500
 Birth: -
  File: =E2=80=98/mnt/test/4M=E2=80=99
  Size: 4194304   Blocks: 8192       IO Block: 16384  regular file
Device: 26h/38d Inode: 1407374883618316  Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root=
)
Context: system_u:object_r:cifs_t:s0
Access: 2014-07-21 14:36:20.249486200 -0500
Modify: 2014-07-21 14:38:01.677837600 -0500
Change: 2014-07-21 14:38:01.677837600 -0500
 Birth: -
  File: =E2=80=98/mnt/test/4M=E2=80=99
  Size: 12288     Blocks: 24         IO Block: 16384  regular file
Device: 26h/38d Inode: 1407374883618316  Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root=
)
Context: system_u:object_r:cifs_t:s0
Access: 2014-07-21 14:36:20.249486200 -0500
Modify: 2014-07-21 14:38:04.693266400 -0500
Change: 2014-07-21 14:38:04.693266400 -0500
 Birth: -

On Mon, Jul 21, 2014 at 2:27 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> So depending on the file sizes and with strict allocate enabled in
> smb.conf it does shrink the file (I will also experiment with e.g.
> allocation roundup size)
>
> What I was trying to do was extend allocation for a 4MB file to 5.4MB=
,
> shrink it to 10K (which ended up shrinking it to 1MB for the Samba
> case).
>
> [sfrench@localhost cifs-2.6]$ stat /mnt/test/4M ; fallocate -n -l
> 5400000 /mnt/test/4M ; sleep 3 ; stat /mnt/test/4M ; fallocate -n -l
> 10000 /mnt/test/4M ; sleep 2; stat /mnt/test/4M
>   File: =E2=80=98/mnt/test/4M=E2=80=99
>   Size: 4194304   Blocks: 8192       IO Block: 16384  regular file
> Device: 26h/38d Inode: 393820      Links: 1
> Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> Context: system_u:object_r:cifs_t:s0
> Access: 2014-07-21 14:19:30.596249500 -0500
> Modify: 2014-07-21 14:19:30.731591000 -0500
> Change: 2014-07-21 14:19:30.731591000 -0500
>  Birth: -
>
>   File: =E2=80=98/mnt/test/4M=E2=80=99   (after fallocate 5400000)
>   Size: 4194304   Blocks: 8192       IO Block: 16384  regular file
> Device: 26h/38d Inode: 393820      Links: 1
> Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> Context: system_u:object_r:cifs_t:s0
> Access: 2014-07-21 14:19:30.596249500 -0500
> Modify: 2014-07-21 14:20:17.141270500 -0500
> Change: 2014-07-21 14:20:17.141270500 -0500
>  Birth: -
>
>   File: =E2=80=98/mnt/test/4M=E2=80=99  (after fallocate 10000)
>   Size: 1048576   Blocks: 2048       IO Block: 16384  regular file
> Device: 26h/38d Inode: 393820      Links: 1
> Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> Context: system_u:object_r:cifs_t:s0
> Access: 2014-07-21 14:19:30.596249500 -0500
> Modify: 2014-07-21 14:20:20.157755800 -0500
> Change: 2014-07-21 14:20:20.157755800 -0500
>  Birth: -
>
> (I will send jra the wireshark trace).
>
> On Mon, Jul 21, 2014 at 1:55 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
>> On Mon, Jul 21, 2014 at 01:43:12PM -0500, Steve French wrote:
>>> What about shrinking the file to the wrong size?
>>
>> In the set allocation path info it's going through:
>>
>>         if (allocation_size) {
>>                 allocation_size =3D smb_roundup(conn, allocation_siz=
e);
>>         }
>>
>> which by default uses 1MB allocation roundup values.
>>
>> If you need to set the file length, set the file length :-).
>>
>> It's arguable if the server can mess with allocation
>> requests on file shrink, but this hasn't caused a
>> problem in the SMB1/Windows SMB2 code paths so far,
>> so I'm guessing it might be allowable....
>>
>> More research needed !
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
