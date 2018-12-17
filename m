From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the y2038 tree
Date: Mon, 17 Dec 2018 16:25:43 -0600
Message-ID: <CAH2r5mtzWrJqj6uVXO=QrY=WwrKAWfrwqf-3yz1PcLm27r0XMg@mail.gmail.com>
References: <20181217201146.170ca9b4@canb.auug.org.au> <CAK8P3a3LaRt8Gszbj2QYJhERKS=T3u=fzPTXaELW4a=BJDNnzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paulo Alcantara <palcantara@suse.de>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3LaRt8Gszbj2QYJhERKS=T3u=fzPTXaELW4a=BJDNnzA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Pushed to cifs-2.6.git for-next (after minor commit description text
cleanup and adding acked-by and reviewed-by)

Paulo/Aurelien,
Let me know your thoughts about Arnd's additional comments which were
interesting.

On Mon, Dec 17, 2018 at 6:49 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Dec 17, 2018 at 10:11 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> > I have applied the following merge fix patch (better versions welcome):
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 17 Dec 2018 20:03:28 +1100
> > Subject: [PATCH] cifs: update for current_kernel_time64() removal
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
>
> Your patch looks correct, and the conflict should be easy to
> resolve by Steve merging this into his tree, as
> ktime_get_coarse_real_ts64() is readily available in mainline
> kernels.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> >  fs/cifs/dfs_cache.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> > index 70f9c9e2175c..d20cc94d7abd 100644
> > --- a/fs/cifs/dfs_cache.c
> > +++ b/fs/cifs/dfs_cache.c
> > @@ -103,7 +103,7 @@ static inline bool cache_entry_expired(const struct dfs_cache_entry *ce)
> >  {
> >         struct timespec64 ts;
> >
> > -       ts = current_kernel_time64();
> > +       ktime_get_coarse_real_ts64(&ts);
> >         return timespec64_compare(&ts, &ce->ce_etime) >= 0;
> >  }
> >
> > @@ -338,8 +338,10 @@ static inline struct timespec64 get_expire_time(int ttl)
> >                 .tv_sec = ttl,
> >                 .tv_nsec = 0,
> >         };
> > +       struct timespec64 now;
> >
> > -       return timespec64_add(current_kernel_time64(), ts);
> > +       ktime_get_coarse_real_ts64(&now);
> > +       return timespec64_add(now, ts);
> >  }
>
> In case efficiency is a concern: using ktime_t with
> ktime_get_coarse_real() may be much faster if we decide to
> abandon the coarse-grained timespec64 accessors in the future.
>
> Also, I wonder if the expiration here has to use CLOCK_REALTIME,
> since that is affected by leap second adjustment and
> clock_settime().
>
> In other modules, we usually concluded that it should be either
> CLOCK_MONOTONIC or CLOCK_BOOTTIME, depending on whether
> you want the expiration timer to keep ticking during suspend.
>
>         Arnd



-- 
Thanks,

Steve
