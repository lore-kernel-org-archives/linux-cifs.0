From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
Date: Sat, 4 Jun 2011 07:35:25 -0500
Message-ID: <BANLkTik15fEwzS5m6xWvMxKesYkQGArfPw@mail.gmail.com>
References: <4DE6103E.6010100@hist.no>
	<4DE8B449.2000008@suse.de>
	<4DE8F989.50208@hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE8F989.50208-CND4fxrytsY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 3, 2011 at 10:11 AM, Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org> =
wrote:
> On 03. juni 2011 12:15, Suresh Jayaraman wrote:
>>
>> [Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
>>
>> On 06/01/2011 03:41 PM, Helge Hafting wrote:
>>>
>>> At work I use cifs for accessing a windows server. This has worked =
fine
>>> for a long time, up to and including Debian's 2.6.38-2.
>>>
>>> I just installed Debians's 2.6.39-1, and had to give up on it.
>>> Mounting CIFS works, and I can see the files. But if I
>>> try to make a new file (with cp), I get a long delay.
>>
>> What is the security mechanism you are using? If you seeing the prob=
lem
>> with ntlm, could you try using ntlmv2 and see whether the problem is
>> reproducible?
>
> In the beginning, I did not specify the mechanism. So, whatever the d=
efault
> is.
>
> The fstab entry was like this:
> \\servername\resource /mountpoint cifs
> domain=3DMYDOMAIN,credentials=3D/etc/fstabcred,rw,noauto,iocharset=3D=
utf8,uid=3Dusername,gid=3Dgroup,sockopt=3DTCP_NODELAY,users,file_mode=3D=
0640,dir_mode=3D0750,relatime
> 0 0
>
> I looked at cifs options, and tried to add "sign" and "sec=3Dntlmv2i"=
=2E It made
> no difference. Still failure with 2.6.39, and mounting with these new
> options works fine with 2.6.38
>
> Helge Hafting
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Yes, I think wireshark trace would be really useful.

Regards,

Shirish
