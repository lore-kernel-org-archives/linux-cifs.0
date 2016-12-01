From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Thu, 1 Dec 2016 00:27:56 -0600
Message-ID: <CAH2r5msUNuqY7ZRsJa2k4ssPusgOtg31=KDNM7ZS5he-Sx+btQ@mail.gmail.com>
References: <20161130092742.0f1cc03b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161130092742.0f1cc03b-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit fixed to handle the ifdef CONFIG_CIFS_SMB2 disabled problem you
noted, and repushed to my for-next branch. Thx for pointing this out.

On Tue, Nov 29, 2016 at 4:27 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/connect.c: In function 'cifs_find_tcon':
> fs/cifs/connect.c:2610:11: error: 'struct cifs_tcon' has no member named 'snapshot_time'
>    if (tcon->snapshot_time != volume_info->snapshot_time)
>            ^
> fs/cifs/connect.c: In function 'cifs_get_tcon':
> fs/cifs/connect.c:2681:8: error: 'struct cifs_tcon' has no member named 'snapshot_time'
>     tcon->snapshot_time = volume_info->snapshot_time;
>         ^
>
> Caused by commit
>
>   36c659cf9241 ("SMB3: parsing for new snapshot timestamp mount parm")
>
> CONFIG_CIFS_SMB2 is not set for this build ...
>
> I have used the cifs tree from next-20161129 for today.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
