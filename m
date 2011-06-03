From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
Date: Fri, 03 Jun 2011 15:45:37 +0530
Message-ID: <4DE8B449.2000008@suse.de>
References: <4DE6103E.6010100@hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE6103E.6010100-CND4fxrytsY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

On 06/01/2011 03:41 PM, Helge Hafting wrote:
> At work I use cifs for accessing a windows server. This has worked fine
> for a long time, up to and including Debian's 2.6.38-2.
> 
> I just installed Debians's 2.6.39-1, and had to give up on it.
> Mounting CIFS works, and I can see the files. But if I
> try to make a new file (with cp), I get a long delay.

What is the security mechanism you are using? If you seeing the problem
with ntlm, could you try using ntlmv2 and see whether the problem is
reproducible?


> In this time, anything accessing CIFS will pause, including "ls".
> CIFS eventually becomes unstuck, and I will find that my "ls" succeeded,
> but the file copy did not. The file was created, but
> with 0 size.
> 
> Trying to copy the file again results in another stall, and so on.
> 
> 
> When I mount CIFS, I get this message:
> CIFS VFS: Unexpected SMB signature
> 
> This happens with 2.6.38 as well as 2.6.39.
> 
> When writes fail in 2.6.39, I also get:
> CIFS VFS: Send error in Close = -512
> 
> Followed by:
> CIFS VFS: Server servername has not responded in 300 seconds.
> Reconnecting...
> 
> I have also seen
> CIFS VFS: Send error in Close = -512
> and
> CIFS VFS: Send error in read = -13

-- 
Suresh Jayaraman
