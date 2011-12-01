From: =?UTF-8?Q?Johannes_Thr=C3=A4n?= <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: vim reports file having changed
Date: Thu, 1 Dec 2011 10:34:42 +0100
Message-ID: <CAFbNW2Fu-Wb=q88gnf_dRVGH8_Esmh8ibB_rwMzp_Sy3m+JJRA@mail.gmail.com>
References: <CAFbNW2Fv58h_r1rmtk0rHg+uJ0C9i1Rtoy2DEDm-Hxw-ZtK_mQ@mail.gmail.com>
	<CADT32eKDtm0sGk8TWp9zvELaK+Fw_PSinSpGR2S_epw7_pXu9g@mail.gmail.com>
	<CAH2r5mszHcu5XKTsTtQeEVd-jCMCOnNvucZTe=p2PAfAA9vAmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mszHcu5XKTsTtQeEVd-jCMCOnNvucZTe=p2PAfAA9vAmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

=2E..cifs/Debugdata
CIFS Version 1.71
=46eatures: dfs lanman posix spnego xattr
Active VFS Requests: 0
Servers:
1) Name: 192.168.1.10  Domain: PMG Uses: 1 OS: Windows Server 2003
3790 Service Pack 2
	NOS: Windows Server 2003 5.2	Capability: 0x1f3fd
	SMB session status: 1	TCP status: 1
	Local Users To Server: 1 SecMode: 0xf Req On Wire: 0
	Shares:
	1) \\192.168.1.10\XXX Mounts: 1 Type: NTFS DevInfo: 0x20 Attributes: 0=
x700ff
PathComponentMax: 255 Status: 0x1 type: DISK


and modinfo cifs:


filename:       /lib/modules/2.6.38-8-generic/kernel/fs/cifs/cifs.ko
version:        1.71
description:    VFS to access servers complying with the SNIA CIFS
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:     9D5FB508C3F48DB44F28CAF
depends:
vermagic:       2.6.38-8-generic SMP mod_unload modversions
parm:           CIFSMaxBufSize:Network buffer size (not including
header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4
Range: 1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default:
30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server.
Default: 50 Range: 2 to 256 (int)
parm:           echo_retries:Number of echo attempts before giving up
and reconnecting server. Default: 5. 0 means never reconnect. (ushort)

thanks for the help


On Thu, Dec 1, 2011 at 6:24 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> The version of cifs (cifs.ko kernel module) can be viewed in
> /proc/fs/cifs/DebugData or from "modinfo cifs"
>
> On Wed, Nov 30, 2011 at 7:42 PM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Nov 30, 2011 at 8:25 AM, Johannes Thr=C3=A4n
>> <johannes.thraen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
>>> Hi all,
>>>
>>> I reported this before here, it somehow went under. So I'll try aga=
in:
>>>
>>> When I open a file which is located on a cifs-mounted windows share
>>> with vim, vim will after some time always report the file as having
>>> changed upon saving, regardless whether it has actually changed or
>>> not.
>>>
>>> I reported this also to the vim maintainer who told me, there he
>>> doesn't know of a similar problem with samba. Ergo it's probably a
>>> problem with cifs.
>>> I work on a daily basis with mentioned setup, so I would be vary gl=
ad
>>> to help resolve it.
>>>
>>> mount.cifs -v gives 4.5, I use kubuntu 11.04 and vim 7.2
>>>
>>> best regard, Johannes
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>> What is the version of cifs and what is the Windows server?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
>
> --
> Thanks,
>
> Steve
