From: "L. A. Walsh" <linux-cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3"
Date: Thu, 31 Aug 2017 17:03:46 -0700
Message-ID: <59A8A3E2.40804@tlinx.org>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504213298-27431-1-git-send-email-linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thorsten Leemhuis wrote:
> This reverts commit eef914a9eb5eb83e60eb498315a491cd1edc13a1 (
> [SMB3] Improve security, move default dialect to SMB3 from old CIFS), 
> as it confuses users: https://bugzilla.kernel.org/show_bug.cgi?id=196599
>
> It was a patch to improve security by switching to SMB3 by default and
> support SMB1 (aka CIFS) only when explicitly requested, as the latter
> is not considered secure anymore (see below for details). This is one of
> the rare cases where regressions are unavoidable and accepted in Linux.
>   
----
    Why not SMB2.1?  Win7 is still in support and getting security updates.
MS has not issued any updates for Win7 upgrading it to SMB3.0 for any
reason (that I'm aware of) -- including security. 

    If there were security problems in Win7 w/SMB2.1, wouldn't MS
issue patches -- as they did for WinXP just recently for a severe
SMB1 bug?

    Seems like if they are willing to patch "out of support" XP, for
a serious problem, then they would be more likely to patch Win7 for
lesser problems.

    Seems like jumping the default to MS's latest and greatest puts
linux on MS's OS-release schedule -- especially when they haven't declared
SMB2.1 as "bad"...  From what I understand, most of the new security
features in 3.0 when into SMB2.1 or 2.0.

>> SMB3 is both secure and widely available: in Windows 8 and later,
>> Samba and Macs.
>>     
----
    I can't find more recent stats than last Dec, but Win7 had between
2-3X the number of Win8 users AND Win7 had between 40-100% more uses
than Win10.  Win 8 was pretty much a non-starter.
(http://www.zdnet.com/article/windows-10-versus-windows-7-whose-numbers-do-you-trust/)

As of March 2017, another article showed Win7 growing w/r/t Win10:
(https://www.theinquirer.net/inquirer/news/3005602/windows-7-market-share-rises-at-the-expense-of-windows-10)

    I can't say moving the default away from SMB1 seems like a bad thing 
-- especially if the error messages can be improved.  Besides security, its
notably slower, but many home devices still use SMB1 -- which is *fine*,
if they are not exposed to the outside net.  Then again, I've never
put a Windows machine facing the internet -- don't think they are security
enough -- use linux for that.


>
>   
