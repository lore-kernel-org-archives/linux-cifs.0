From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2
Date: Tue, 30 Nov 2010 14:18:37 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011301242210.15277@awakenings.cable.ziggo.nl>
References: <alpine.DEB.2.00.1011291143280.21269@awakenings.cable.ziggo.nl> <AANLkTi=MqT4Fkw2FJZJHvXmwGn1MtB_Gq=aMXwj6Q7Fg@mail.gmail.com> <alpine.DEB.2.00.1011291513080.21269@awakenings.cable.ziggo.nl>
 <AANLkTimaLdKa5OVEjQEbkS+TWVsF1cKRHPaBTaooYCdp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimaLdKa5OVEjQEbkS+TWVsF1cKRHPaBTaooYCdp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Shirish,

On Mon, 29 Nov 2010, Shirish Pargaonkar wrote:

> Robert, does sec=ntlmssp without  dom=sox helps?
> A wireshark trace when you issue mount command would be useful.

With or wihout dom=sox does not make a difference.

Here is an overview of what I tested:

 		2003sp2		2008r2 (+DFS)	2008 (+DFS)
NTLM		(1)		OK		OK
NTLMv2		(1)		(2)		(2)
NTLMSSP		(3)		(3)		(3)


1 = Fails with "Required key not available"
2 = Fails with "NT_STATUS_INVALID_PARAMETER"
3 = Fails with "NT_STATUS_NOT_SUPPORTED"

I will send you some detailed logs and pcaps off-list.

Regards,
Robbert
