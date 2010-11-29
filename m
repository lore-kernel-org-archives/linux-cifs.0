From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
 (try #2)
Date: Mon, 29 Nov 2010 20:08:14 +0300
Message-ID: <AANLkTikB6_nwg+G+pYv9NNeohHPwymjUkv3r-mJkZBxW@mail.gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<1290931972-2770-4-git-send-email-piastryyy@gmail.com>
	<20101128063604.7d9cdded@tlielax.poochiereds.net>
	<20101128065100.51c8a404@tlielax.poochiereds.net>
	<AANLkTimO9t_wXPZRWXx856-wkG-EwRWTizrCKSo4e2SY@mail.gmail.com>
	<20101129063713.0b71ac09@tlielax.poochiereds.net>
	<4CF39901.3010108@suse.de>
	<AANLkTimvA08MT5gcy=h_w6UtcTgyvos4X4x+KUTVbM8u@mail.gmail.com>
	<4CF3D3D9.3060500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF3D3D9.3060500-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/29 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 11/29/2010 05:56 PM, Pavel Shilovsky wrote:
>>
>> What's about mmap and fsync patch? How do you think they mix with fscache?
>>
>
> Basically, relinquishing cookie when you are invalidating inode should
> make them work without issues I think. But, I would also test your
> patches (once you post the patchset that includes fscache handling as
> well) to be sure.
>
>

I reposted patches from 2 to 5(included). So, uptodate set is

Pavel Shilovsky (6):
 CIFS: Make cifsFileInfo_put work with strict cache mode (try #4)
 CIFS: Make read call work with strict cache mode (try #3)
 CIFS: Make write call work with strict cache mode (try #3)
 CIFS: Make cifs_fsync work with strict cache mode (try #3)
 CIFS: Make cifs_file_map work with strict cache mode (try #3)
 CIFS: Add strictcache mount option (try #2)

please, let me know about results when you finished testing them.

-- 
Best regards,
Pavel Shilovsky.
