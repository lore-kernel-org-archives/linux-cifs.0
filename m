From: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Subject: Re: Flush issue with overwritten FID
Date: Thu, 11 Jun 2015 18:06:15 +0200
Message-ID: <5579B1F7.4010606@innominate.com>
References: <556748C2.40202@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <556748C2.40202-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,


I am using two shares. In order to connect to each share I use a 
different user, but it is the same Windows host. In the abovementioned 
scenario something strange happens while mounting the shares, namely 
that the session setup commands both return the same user ID for two 
different users. Conversely, the tree connect command then also returns 
the same tree ID for each one of the (different) shares.

I think that is the root cause of the problem, leading to the 
duplication of a file ID later in the process.

My question is whether this is a Windows issue that we cannot fix, or 
whether there is a possibility to tackle this problem from Linux.

I should probably mention that both shares are mounted in parallel.

Also: the only client-controlled field that I have been able to identify 
as being the same in the bad scenario is the multiplexer ID. For both 
session setup command the MID is the same, but the process ID (and the 
user ID) is different. In the working case both the process ID and the 
MID are different.

Any hints are welcomed! ;-)


Kind regards,


Federico Sauter
Senior Firmware Programmer
-- 
Innominate Security Technologies AG
Rudower Chaussee 13 | 12489 Berlin | Germany
tel: +49 30 921028-210 | fax: +49 30 921028-020
www.innominate.com | www.twitter.com/mGuardcom

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald | Chairman of the Supervisory Board: 
Christoph Leifer


On 05/28/2015 06:56 PM, Federico Sauter wrote:
> Greetings,
>
>
> I am using a Linux device with kernel 3.10.40. The Windows host is using
> XP PRO (32-bit,) but the problem has laso been observed with Windows 7
> 64-bit.
>
> When I directly connect the Linux device to the Windows host, a very
> strange problem arises. First of all: by "directly connect" I mean
> connecting the network cable from the device's NIC directly to the
> host's NIC, without any switch in between.
>
> The device then mounts two shares on the host: a RO share, as well as a
> RW share.
>
> The device opens a file (integrity-check-idx.tmp) for writing on the RW
> share. Then (without closing it) it scans the contents of the RO share.
> Afterwards, it writes some result on that file and flushes it before
> closing it. Straightforward enough.
>
> In the described case where the NICs are directly connected *and* that
> the Windows host finishes booting before the Linux device does,
> something strange happens. The file opened for writing is opened on FID
> 0x4002, then, when opening another file on the RO share, the same FID
> seems to be reused. That file is closed and FID 0x4002 is then invalid.
> In the end, when FID 0x4002 is flushed, an error is returned.
>
> Attached you will find an abridged version of the Wireshark capture.
> Here is the summary:
>
> SMB_COM_NT_CREATE_ANDX integrity-check-idx.tmp on FID 0x4002
> SMB_COM_READ_ANDX  FID 0x4002
> (...browse share...)
> SMB_COM_NT_CREATE_ANDX append.exe on FID 0x4002
> SMB_COM_READ_ANDX  FID 0x4002
> SMB_COM_CLOSE  FID 0x4002
> (...)
> SMB_COM_FLUSH  FID 0x4002
> Response: NT Status: STATUS_INVALID_HANDLE (0xc0000008)
>
> In the case where there is a switch between both NICs, this problem does
> not happen. In that case, FID 0x4002 is used only once for the file
> opened for writing (which was created first) and then other FIDs are
> used for each file that is opened afterwards. Thus, all operations
> succeed (which is the behavior that I would expect.)
>
> Do you have any idea on how to solve this?
>
> I am taking a deeper look at the kernel code, but so far it seems to me
> like this was a Windows problem and not a problem in our implementation,
> given that the FID is assigned by the Windows host. Could you please
> confirm that this is correct so as to provide a workaround?
>
> Thank you in advance for your kind support!
>
>
> Federico Sauter
> Senior Firmware Programmer
