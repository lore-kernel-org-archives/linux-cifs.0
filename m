From: Helge Hafting <helge.hafting@hist.no>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
Date: Fri, 03 Jun 2011 17:11:05 +0200
Message-ID: <4DE8F989.50208@hist.no>
References: <4DE6103E.6010100@hist.no> <4DE8B449.2000008@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-cifs <linux-cifs@vger.kernel.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DE8B449.2000008@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 03. juni 2011 12:15, Suresh Jayaraman wrote:
> [Cc linux-cifs@vger.kernel.org]
>
> On 06/01/2011 03:41 PM, Helge Hafting wrote:
>> At work I use cifs for accessing a windows server. This has worked fine
>> for a long time, up to and including Debian's 2.6.38-2.
>>
>> I just installed Debians's 2.6.39-1, and had to give up on it.
>> Mounting CIFS works, and I can see the files. But if I
>> try to make a new file (with cp), I get a long delay.
>
> What is the security mechanism you are using? If you seeing the problem
> with ntlm, could you try using ntlmv2 and see whether the problem is
> reproducible?

In the beginning, I did not specify the mechanism. So, whatever the 
default is.

The fstab entry was like this:
\\servername\resource /mountpoint cifs 
domain=MYDOMAIN,credentials=/etc/fstabcred,rw,noauto,iocharset=utf8,uid=username,gid=group,sockopt=TCP_NODELAY,users,file_mode=0640,dir_mode=0750,relatime 
0 0

I looked at cifs options, and tried to add "sign" and "sec=ntlmv2i". It 
made no difference. Still failure with 2.6.39, and mounting with these 
new options works fine with 2.6.38

Helge Hafting
