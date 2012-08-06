From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Sun, 5 Aug 2012 20:57:24 -0500
Message-ID: <CAH2r5ms9EYUV7uwCpU6De9y_PFtFG6wfekPVRXQza6pE6TVC4Q@mail.gmail.com>
References: <20120806104841.07ed3708b600529ff7eb6fa6@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120806104841.07ed3708b600529ff7eb6fa6-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 5, 2012 at 7:48 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/Kconfig:3: syntax error
> fs/Kconfig:244: missing end statement for this entry
<snip>
>
> Caused by commit 12f3f9b7c80c ("Remove sparse warning in cifsfs.c").
> Please, please build test after doing updates and before publishing your
> tree.
>
> I have used the cifs tree from next-20120803 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

Fixed.  The corrupted commit came after a build test caught a few
sparse warnings - forgot to rerun the build test though after fixing
the warning (I had multiple
Kconfigs I build test - fs/cifs/Kconfig obviously should not have changed)



-- 
Thanks,

Steve
