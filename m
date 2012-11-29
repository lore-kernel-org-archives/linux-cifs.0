From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounting SMB2 fails with -EINVAL on 3.7-rc7
Date: Wed, 28 Nov 2012 23:38:24 -0600
Message-ID: <CAH2r5mtuS45U5bgHU_OvWTSfv1PLK4GK1JBczbmW83AC4iN7xA@mail.gmail.com>
References: <50B48601.6070000@suse.com>
	<CAKywueT-Wi_gS8SNOQ+Ac-MNFNSuN_ni1BA8neQsy0836w6BvA@mail.gmail.com>
	<50B4B972.8070604@suse.com>
	<CAKywueSm5K_H870mvQED02fqKoY8FTR=T+RhAo6hk3VzN3Jd4g@mail.gmail.com>
	<CAH2r5msNJSdS5Pq3+PY0Lndg0C22GR-27HNA8vzBVfT50x3uQA@mail.gmail.com>
	<CAKywueSRRuCDJxDgnHURSGY9qAvc_kb4BuKMoMaxCbjh4UPrNg@mail.gmail.com>
	<50B6370F.2060402@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50B6370F.2060402-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The patch for 2.02 dialect support was reviewed by Pavel and is now in
cifs-2.6.git for next (destined for 3.8).

On Wed, Nov 28, 2012 at 10:08 AM, Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> On 11/28/2012 07:19 PM, Pavel Shilovsky wrote:
>> 2012/11/27 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> I have a patch for 2.0 support that was in my for-next branch for a
>>> little bit but I decided was too late for 3.7
>>
>> Are your going to re-add it again for 3.8? (I think it's important to
>> support Samba - my be we should backport it to v3.7 too during stable
>> series)
>>
>
> While I agree that it is quite important for smb client to work with
> Samba, I'm not sure whether this patch would meet the -stable criteria...
>
> --
> Suresh Jayaraman



-- 
Thanks,

Steve
