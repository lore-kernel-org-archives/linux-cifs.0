From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
 (try #2)
Date: Mon, 06 Dec 2010 17:20:47 +0530
Message-ID: <4CFCCE17.2010108@suse.de>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>	<1290931972-2770-4-git-send-email-piastryyy@gmail.com>	<20101128063604.7d9cdded@tlielax.poochiereds.net>	<20101128065100.51c8a404@tlielax.poochiereds.net>	<AANLkTimO9t_wXPZRWXx856-wkG-EwRWTizrCKSo4e2SY@mail.gmail.com>	<20101129063713.0b71ac09@tlielax.poochiereds.net>	<4CF39901.3010108@suse.de>	<AANLkTimvA08MT5gcy=h_w6UtcTgyvos4X4x+KUTVbM8u@mail.gmail.com>	<4CF3D3D9.3060500@suse.de>	<AANLkTikB6_nwg+G+pYv9NNeohHPwymjUkv3r-mJkZBxW@mail.gmail.com>	<4CF61979.5080505@suse.de> <AANLkTik1AC5YJV_CtihSobE1mgj1-7tuiBLf7_nDsiv2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik1AC5YJV_CtihSobE1mgj1-7tuiBLf7_nDsiv2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/01/2010 10:09 PM, Pavel Shilovsky wrote:
> 2010/12/1 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
>>
>> I just applied your patches on my test box, but I see that the fscache
>> integration is not done, yet. Am I seeing older version of patches?
> 
> What do you mean for "fscache integration"? I changed all
> invalidate_inode_* calls to cifs_invalidate_mapping or setting
> invalid_mapping flag - so, it seems to me that I don't miss places
> where I affect cache but don't aware of fscache
> (cifs_invalidate_mapping process fscache as well). Of course, it can
> be - so, could you point me to such places, please?
> 

Sorry about the delay in getting back. You're right the patches are
taking care of relinquishing the cookies wherever appropriate.
I have done some testing with both 'strictcache' and 'fsc' enabled and
so far they work as expected. The tests involve doing file operations
with fsc enabled always but strict cache enabled/disabled and watching
fscache statistics via /proc/fs/fscache/stats). I didn't encounter any
unexpected results.


Thanks,

-- 
Suresh Jayaraman
