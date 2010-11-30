From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 11:20:23 -0600
Message-ID: <AANLkTin3-k4AJRYvL4p8VQqvnnL5mLJJZXNf5mC1RBKg@mail.gmail.com>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl>
	<AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>
	<alpine.DEB.2.00.1011301739010.31075@awakenings.cable.ziggo.nl>
	<AANLkTinwtjkL_Exr57wDjRiKQTzVFwjuv=kBOw7s5mgS@mail.gmail.com>
	<alpine.DEB.2.00.1011301809050.31075@awakenings.cable.ziggo.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1011301809050.31075-56sTcPfcKMhJlCS1zhbguEjk2N/pv5CcZkel5v8DVj8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 30, 2010 at 11:11 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote:
> Hi,
>
>>> Do you also have an idea on (1), the resolving problem?
>>>
>>
>> Robbert, did you send me a wireshark trace with that error?
>> I do not see that error in any of the trace files you sent.
>
> The trace is in 1.pcap. It is also the first log exempt in the text file I
> sent you.
>
> First, a "NT_STATUS_PATH_NOT_COVERED" (which is in the trace), and after
> this resolving is tried.
>
> Regards,
> Robbert
>

Robbert, I do not think this error has anything to do with the authentication.
This error in response to a Tree Connect request seems related to MS-DFS
implementations on Windows 2003 server and on Windows 2008 servers.
I think you would see this error with sec=ntlmssp also (if that auth
mech was working).
